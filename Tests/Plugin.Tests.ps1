#Requires -Version 7.0
<#
.SYNOPSIS
    Checks that plugin wrappers run the command line their table declares.

.DESCRIPTION
    Tests/Loader.Tests.ps1 covers loading: manifests, imports, alias collisions, the plugin
    system. Nothing covered what a wrapper actually runs, so a table row could name the wrong
    subcommand and every check in the repository would still pass.

    Each test puts a shim named after the tool at the front of PATH, calls the wrapper, and reads
    back the command line the shim received.

    Two things about the shim are deliberate.

    It is a real executable rather than a PowerShell function shadowing the name, because the two
    disagree: splatting an unbound [string[]] into a function passes one empty argument, while
    PowerShell drops it for a native command. Shadowing reports a trailing empty string on every
    wrapper called with no arguments, and that bug is not real.

    It records %* rather than walking %~1 with shift, because cmd.exe treats = as an argument
    delimiter. Walking the arguments turns --rebase=interactive into two of them and reports a
    generator bug that is not real either.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeDiscovery {
    $script:Tables = @(
        Get-ChildItem -LiteralPath (Join-Path (Split-Path -Parent $PSScriptRoot) 'Module') -Recurse -File -Filter 'commands.psd1' |
            ForEach-Object {
                @{
                    Plugin   = Split-Path -Leaf $_.DirectoryName
                    Manifest = Join-Path $_.DirectoryName ((Split-Path -Leaf $_.DirectoryName) + '.psd1')
                    Table    = $_.FullName
                }
            }
    )
}

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    $script:ShimDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("plugin-argv-" + [guid]::NewGuid().ToString('N'))
    $script:ShimLog = Join-Path $script:ShimDirectory 'argv.log'
    $script:OriginalPath = $env:PATH

    $null = New-Item -ItemType Directory -Path $script:ShimDirectory -Force

    function New-ToolShim {
        <#
        .SYNOPSIS
            Writes a batch file that records the command line it was called with.

        .PARAMETER Name
            Executable name to shadow, without an extension.
        #>
        param([Parameter(Mandatory)][string]$Name)

        $body = @"
@echo off
echo %*>> "$script:ShimLog"
"@
        Set-Content -LiteralPath (Join-Path $script:ShimDirectory "$Name.cmd") -Value $body -Encoding ASCII
    }

    function Get-RecordedCommandLine {
        <#
        .SYNOPSIS
            Returns the command line from the most recent shim invocation.

        .OUTPUTS
            [string] The arguments as one line, empty when the tool was called with none.
        #>
        param()

        if (-not (Test-Path -LiteralPath $script:ShimLog)) { return '' }

        $lines = @(Get-Content -LiteralPath $script:ShimLog)
        if (-not $lines.Count) { return '' }

        # `echo %*` with no arguments prints ECHO's state line rather than a blank one.
        $last = "$($lines[-1])".Trim()
        if ($last -match '^ECHO is (on|off)') { return '' }

        $last
    }

    function Reset-RecordedCommandLine {
        <#
        .SYNOPSIS
            Clears the shim log between calls.
        #>
        param()

        Remove-Item -LiteralPath $script:ShimLog -ErrorAction SilentlyContinue
    }

    function Test-LiteralRow {
        <#
        .SYNOPSIS
            Reports whether every argument in a row is a literal token.

        .DESCRIPTION
            The generator writes a row's Args into the source unquoted, so a row may hold a
            PowerShell expression: (Get-GitMainBranch), "origin/$(Get-GitCurrentBranch)", or a
            trailing pipeline. Those evaluate at call time and cannot be compared against the
            table text, so only literal rows are asserted.

        .PARAMETER Argument
            The row's Args.
        #>
        param([string[]]$Argument)

        foreach ($item in @($Argument)) {
            if ($item -match '[\$\(\)\|"]') { return $false }
        }

        return $true
    }

    function Get-PluginFunction {
        <#
        .SYNOPSIS
            Resolves a row's function within its own module, ignoring any alias over the name.

        .DESCRIPTION
            Calling the bare name would not always reach the function under test. An alias
            outranks a function, and several wrapper names have one: seven are built-in
            PowerShell aliases (gcb gcm gcs gl gm gp gpv), and the GCP plugin exports gca, gcd
            and gcv over three Git wrappers. Which of those are live depends on what else the
            session imported, which is not a property of the module being tested.

            Resolving through the module makes the assertion about the wrapper itself. The
            shadowing is asserted separately, in a session that imports one plugin.

        .PARAMETER Name
            Function name from the table.

        .PARAMETER Module
            Module that should export it.

        .OUTPUTS
            [System.Management.Automation.FunctionInfo] or $null.
        #>
        param(
            [Parameter(Mandatory)][string]$Name,
            [Parameter(Mandatory)][string]$Module
        )

        Get-Command -Name $Name -CommandType Function -Module $Module -ErrorAction SilentlyContinue |
            Select-Object -First 1
    }

    $env:PATH = "$script:ShimDirectory;$script:OriginalPath"
}

AfterAll {
    $env:PATH = $script:OriginalPath
    Remove-Item -LiteralPath $script:ShimDirectory -Recurse -Force -ErrorAction SilentlyContinue
}

Describe 'Generated wrappers' {

    It 'finds at least one command table' {
        $found = @(Get-ChildItem -LiteralPath (Join-Path $script:Root 'Module') -Recurse -File -Filter 'commands.psd1')
        $found.Count | Should -BeGreaterThan 0
    }

    Context 'every literal row runs the command line it declares' {

        It 'builds the declared command line for every literal row in <Plugin>' -ForEach $script:Tables {
            $data = Import-PowerShellDataFile -LiteralPath $Table
            New-ToolShim -Name $data.Tool
            Import-Module -Name $Manifest -Force -DisableNameChecking

            $failures = [System.Collections.Generic.List[string]]::new()
            $checked = 0

            foreach ($row in $data.Commands) {
                if (-not (Test-LiteralRow -Argument $row.Args)) { continue }

                $command = Get-PluginFunction -Name $row.Name -Module $Plugin
                if (-not $command) {
                    $failures.Add(("{0}: not exported by {1}" -f $row.Name, $Plugin))
                    continue
                }

                $expected = ((@($row.Args) + @('PROBE')) -join ' ').Trim()

                Reset-RecordedCommandLine
                try {
                    & $command 'PROBE'
                }
                catch {
                    # One bad row must not hide the rest, so failures are collected. Pester runs
                    # with $ErrorActionPreference = 'Stop'.
                    $failures.Add(("{0}: threw {1}" -f $row.Name, $_.Exception.Message))
                    continue
                }

                $checked++
                $actual = Get-RecordedCommandLine

                if ($actual -ne $expected) {
                    $failures.Add(("{0}: ran '{1}', table declares '{2}'" -f $row.Name, $actual, $expected))
                }
            }

            $checked | Should -BeGreaterThan 0 -Because 'a table with no assertable row would pass vacuously'
            $failures -join "`n" | Should -BeNullOrEmpty
        }

        It 'passes no extra argument when called with none in <Plugin>' -ForEach $script:Tables {
            $data = Import-PowerShellDataFile -LiteralPath $Table
            New-ToolShim -Name $data.Tool
            Import-Module -Name $Manifest -Force -DisableNameChecking

            $row = @($data.Commands) |
                Where-Object { Test-LiteralRow -Argument $_.Args } |
                Select-Object -First 1

            $row | Should -Not -BeNullOrEmpty

            $command = Get-PluginFunction -Name $row.Name -Module $Plugin
            $command | Should -Not -BeNullOrEmpty

            Reset-RecordedCommandLine
            & $command
            Get-RecordedCommandLine | Should -BeExactly ((@($row.Args) -join ' ').Trim())
        }
    }

    Context 'declared aliases reach their function' {

        It 'resolves every alias in <Plugin> to its own function' -ForEach $script:Tables {
            $data = Import-PowerShellDataFile -LiteralPath $Table
            Import-Module -Name $Manifest -Force -DisableNameChecking

            $wrong = [System.Collections.Generic.List[string]]::new()

            foreach ($row in $data.Commands) {
                foreach ($alias in @($row.Aliases)) {
                    if (-not $alias) { continue }

                    $resolved = Get-Alias -Name $alias -ErrorAction SilentlyContinue
                    if (-not $resolved) {
                        $wrong.Add("$alias is not defined")
                    }
                    elseif ($resolved.ResolvedCommandName -ne $row.Name) {
                        $wrong.Add("$alias resolves to $($resolved.ResolvedCommandName), not $($row.Name)")
                    }
                }
            }

            $wrong -join "`n" | Should -BeNullOrEmpty
        }
    }

    Context 'names an alias outranks' {

        It 'loses exactly the seven names profile.config.psd1 lists to a built-in alias' {
            # Run in a clean session importing one plugin. In the shared Pester session
            # Tests/Loader.Tests.ps1 has already imported all 43 modules, so the answer would
            # depend on test order rather than on the module.
            $script = @'
Import-Module -Name "{0}" -Force -DisableNameChecking
$data = Import-PowerShellDataFile -LiteralPath "{1}"
$data.Commands |
    Where-Object {{ (Get-Command -Name $_.Name -ErrorAction SilentlyContinue).CommandType -eq 'Alias' }} |
    ForEach-Object {{ $_.Name }} |
    Sort-Object
'@ -f (Join-Path $script:Root 'Module/Plugins/Git/Git.psd1'),
                  (Join-Path $script:Root 'Module/Plugins/Git/commands.psd1')

            $shadowed = @(pwsh -NoProfile -Command $script)

            # profile.config.psd1 names these under AllowBuiltinShadowing. A name joining or
            # leaving the list is a change users feel, so it is pinned here rather than left in a
            # comment that nothing checks.
            $shadowed | Should -Be @('gcb', 'gcm', 'gcs', 'gl', 'gm', 'gp', 'gpv')
        }

        It 'loses gca, gcd and gcv to the GCP plugin when both are loaded' {
            # Not a built-in alias: the GCP plugin exports these three names for gcloud, and an
            # alias outranks a function, so with both plugins enabled gca runs gcloud auth rather
            # than git commit --all. The loader reports this as alias contention at startup.
            # Pinned here so the set cannot grow unnoticed.
            $script = @'
Import-Module -Name "{0}" -Force -DisableNameChecking
Import-Module -Name "{1}" -Force -DisableNameChecking
$data = Import-PowerShellDataFile -LiteralPath "{2}"
$data.Commands |
    Where-Object {{ (Get-Command -Name $_.Name -ErrorAction SilentlyContinue).ModuleName -eq 'GCP' }} |
    ForEach-Object {{ $_.Name }} |
    Sort-Object
'@ -f (Join-Path $script:Root 'Module/Plugins/Git/Git.psd1'),
                  (Join-Path $script:Root 'Module/Plugins/GCP/GCP.psd1'),
                  (Join-Path $script:Root 'Module/Plugins/Git/commands.psd1')

            $stolen = @(pwsh -NoProfile -Command $script)

            $stolen | Should -Be @('gca', 'gcd', 'gcv')
        }
    }
}
