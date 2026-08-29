#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Loader Module
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       Loads the modules named in profile.config.psd1 and nothing else, reports every failure
#       instead of swallowing it, and resolves the three ways a profile command can collide with
#       something the user already has: a reserved alias that belongs to a real executable, a GNU
#       tool from coreutils, and a built-in PowerShell alias that outranks a module function.
#
#       This replaces the previous loader, which imported all 46 modules unconditionally with
#       -ErrorAction SilentlyContinue.
#
# Created: 2026-08-15
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

. (Join-Path $PSScriptRoot 'Python.ps1')
. (Join-Path $PSScriptRoot 'Dependency.ps1')
. (Join-Path $PSScriptRoot 'Help.ps1')
. (Join-Path $PSScriptRoot 'Lazy.ps1')
. (Join-Path $PSScriptRoot 'Plugin.ps1')

# Compared against a plugin's MinimumProfileVersion.
$script:ProfileVersion = '5.1.0'

$script:LoadReport = [System.Collections.Generic.List[PSCustomObject]]::new()
$script:LoadNotice = [System.Collections.Generic.List[string]]::new()

# Plugin name -> the executable that makes it worth loading. A plugin absent from this map is
# never skipped, because there is nothing to test for.
$script:PluginTool = @{
    AWS           = 'aws'
    Conda         = 'conda'
    Deno          = 'deno'
    Docker        = 'docker'
    DockerCompose = 'docker'
    Flutter       = 'flutter'
    GCP           = 'gcloud'
    Git           = 'git'
    Helm          = 'helm'
    Kubectl       = 'kubectl'
    NPM           = 'npm'
    PIP           = 'pip'
    Pipenv        = 'pipenv'
    PNPM          = 'pnpm'
    Poetry        = 'poetry'
    Rsync         = 'rsync'
    Ruby          = 'ruby'
    Rust          = 'cargo'
    Terraform     = 'terraform'
    Terragrunt    = 'terragrunt'
    UV            = 'uv'
    VSCode        = 'code'
    Yarn          = 'yarn'
}

function Get-ProfileConfig {
    <#
    .SYNOPSIS
        Reads profile.config.psd1 and fills in defaults for anything it omits.

    .DESCRIPTION
        Returns the load configuration as a hashtable. A missing or unreadable config is not
        fatal: the defaults load the core modules only, which is enough to get a working shell
        and a warning explaining what happened.

    .PARAMETER Path
        Path to profile.config.psd1.

    .OUTPUTS
        [hashtable] The configuration, with every key present.

    .EXAMPLE
        Get-ProfileConfig -Path ./profile.config.psd1

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    $defaults = @{
        Modules               = @('Directory', 'Environment', 'Logging', 'Network', 'Process', 'Starship', 'Update')
        Plugins               = @()
        Utilities             = @()
        ExternalModules       = @('Terminal-Icons', 'PSReadLine', 'CompletionPredictor')
        DeferExternalModules  = @()
        LoadChocolateyProfile = $false
        SkipMissingTools      = $true
        PreferNativeTools     = $true
        AllowBuiltinShadowing = $false
        ReportLoadFailures    = $true
        TrackTimings          = $true
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Warning "Profile config not found at $Path. Loading core modules only."
        return $defaults
    }

    try {
        $config = Import-PowerShellDataFile -LiteralPath $Path
    }
    catch {
        Write-Warning "Profile config at $Path is not valid: $($_.Exception.Message). Loading core modules only."
        return $defaults
    }

    foreach ($key in $defaults.Keys) {
        if (-not $config.ContainsKey($key)) { $config[$key] = $defaults[$key] }
    }

    return $config
}

function Test-ProfileTool {
    <#
    .SYNOPSIS
        Reports whether the command-line tool a plugin wraps is available.

    .PARAMETER Plugin
        The plugin name, for example 'Kubectl'.

    .OUTPUTS
        [bool] True when the plugin has no known tool, or its tool is on PATH.

    .EXAMPLE
        Test-ProfileTool -Plugin Kubectl

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Plugin
    )

    if (-not $script:PluginTool.ContainsKey($Plugin)) { return $true }

    return [bool](Get-Command -Name $script:PluginTool[$Plugin] -CommandType Application -ErrorAction SilentlyContinue)
}

function Import-ProfileComponent {
    <#
    .SYNOPSIS
        Imports one module and records the outcome.

    .DESCRIPTION
        Unlike the loader this replaces, a failure here is reported rather than discarded.
        The module is still skipped, so one broken module cannot stop a shell from opening,
        but the user is told which one and why.

    .PARAMETER Name
        Display name used in the load report.

    .PARAMETER Path
        Full path to the module manifest.

    .PARAMETER Kind
        Category shown in the report: Module, Plugin or Utility.

    .PARAMETER Track
        Record elapsed import time.

    .PARAMETER Report
        Emit a warning when the import fails.

    .EXAMPLE
        Import-ProfileComponent -Name Git -Path ./Module/Plugins/Git/Git.psd1 -Kind Plugin

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Kind,
        [switch]$Track,
        [switch]$Report
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        if ($Report) { Write-Warning "$Kind '$Name' not found at $Path" }
        $script:LoadReport.Add([PSCustomObject]@{ Kind = $Kind; Name = $Name; Status = 'missing'; Milliseconds = 0 })
        return
    }

    $stopwatch = if ($Track) { [System.Diagnostics.Stopwatch]::StartNew() } else { $null }

    try {
        Import-Module -Name $Path -Global -Force -DisableNameChecking -ErrorAction Stop
        $status = 'loaded'
    }
    catch {
        $status = 'failed'
        if ($Report) {
            Write-Warning "$Kind '$Name' failed to load: $($_.Exception.Message.Split([Environment]::NewLine)[0])"
        }
    }

    if ($stopwatch) { $stopwatch.Stop() }

    $script:LoadReport.Add([PSCustomObject]@{
            Kind         = $Kind
            Name         = $Name
            Status       = $status
            Milliseconds = if ($stopwatch) { [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 1) } else { 0 }
        })
}

function Resolve-ProfileConflict {
    <#
    .SYNOPSIS
        Applies the alias and shadowing policy once every module has loaded.

    .DESCRIPTION
        Handles the two collisions that only exist at runtime:

        PreferNativeTools     removes profile aliases that would take a name owned by a GNU tool
                              from Microsoft coreutils, so `grep` stays GNU grep.

        AllowBuiltinShadowing removes the built-in PowerShell aliases that outrank same-named Git
                              plugin functions, so `gl` can mean `git pull`. Off by default; the
                              affected functions are reported instead.

    .PARAMETER Policy
        The hashtable loaded from Tools/ExportPolicy.psd1.

    .PARAMETER PreferNativeTools
        Give coreutils the contested names.

    .PARAMETER AllowBuiltinShadowing
        Remove built-in aliases that block module functions.

    .EXAMPLE
        Resolve-ProfileConflict -Policy $policy -PreferNativeTools

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)][hashtable]$Policy,
        [switch]$PreferNativeTools,
        [switch]$AllowBuiltinShadowing
    )

    if ($PreferNativeTools) {
        $yielded = [System.Collections.Generic.List[string]]::new()

        foreach ($name in $Policy.NativeToolNames) {
            $alias = Get-Item -LiteralPath "Alias:\$name" -ErrorAction SilentlyContinue
            if (-not $alias) { continue }

            # Only yield to a real executable that is actually installed.
            $native = Get-Command -Name $name -CommandType Application -ErrorAction SilentlyContinue
            if (-not $native) { continue }

            try {
                Remove-Item -LiteralPath "Alias:\$name" -Force -ErrorAction Stop
                $yielded.Add($name)
            }
            catch {
                # An AllScope or read-only alias; leave it rather than fight the session.
                Write-Verbose "Could not yield alias '$name' to the native tool: $($_.Exception.Message)"
            }
        }

        if ($yielded.Count) {
            $script:LoadNotice.Add(("native tools keep their names: {0}" -f ($yielded -join ', ')))
        }
    }

    $blocked = [System.Collections.Generic.List[string]]::new()

    foreach ($name in $Policy.BuiltinAliases) {
        $function = Get-Item -LiteralPath "Function:\$name" -ErrorAction SilentlyContinue
        if (-not $function) { continue }

        $alias = Get-Item -LiteralPath "Alias:\$name" -ErrorAction SilentlyContinue
        if (-not $alias) { continue }

        if ($AllowBuiltinShadowing) {
            try {
                Remove-Item -LiteralPath "Alias:\$name" -Force -ErrorAction Stop
            }
            catch {
                $blocked.Add($name)
            }
        }
        else {
            $blocked.Add($name)
        }
    }

    if ($blocked.Count) {
        $script:LoadNotice.Add(("shadowed by built-in aliases, use the full function name: {0}" -f ($blocked -join ', ')))
    }
}

function Test-ProfileAliasContention {
    <#
    .SYNOPSIS
        Reports aliases that more than one loaded profile module defines.

    .DESCRIPTION
        PNPM, Pipenv and Poetry all compete for the p* namespace: pad, pch, pi, pin, ppub, prm,
        prun, psh and pup are each claimed by two of them, and Deno and Docker both want dr.

        Only one definition survives, decided by load order, which is not something the user
        chose. Enabling two contending plugins together is legitimate, so this reports rather than
        resolves; rename the loser in its own module if the collision matters to you.

    .OUTPUTS
        [PSCustomObject[]] One row per contested alias, with the modules claiming it.

    .EXAMPLE
        Test-ProfileAliasContention
        Lists contested aliases in the current session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-alias-conflicts')]
    [OutputType([PSCustomObject[]])]
    param()

    $claims = foreach ($module in Get-Module) {
        if (-not $module.Path) { continue }
        foreach ($alias in $module.ExportedAliases.Keys) {
            [PSCustomObject]@{ Alias = $alias; Module = $module.Name }
        }
    }

    return @($claims |
            Group-Object Alias |
            Where-Object { $_.Count -gt 1 } |
            ForEach-Object {
                [PSCustomObject]@{
                    Alias   = $_.Name
                    Modules = ($_.Group.Module | Sort-Object -Unique) -join ', '
                    Winner  = (Get-Command $_.Name -ErrorAction SilentlyContinue).Source
                }
            } |
            Sort-Object Alias)
}

function Import-ProfileModule {
    <#
    .SYNOPSIS
        Loads everything named in the profile configuration.

    .DESCRIPTION
        The single entry point the profile calls. Reads profile.config.psd1, imports the core
        modules, then the enabled plugins (skipping any whose tool is absent), then the
        utilities, then applies the conflict policy.

    .PARAMETER RepositoryRoot
        Directory containing profile.config.psd1 and the Module tree.

    .OUTPUTS
        None. Use Measure-ProfileLoad to inspect what happened.

    .EXAMPLE
        Import-ProfileModule -RepositoryRoot $PSScriptRoot

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('load-profile')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$RepositoryRoot
    )

    $script:LoadReport.Clear()
    $script:LoadNotice.Clear()

    $config = Get-ProfileConfig -Path (Join-Path $RepositoryRoot 'profile.config.psd1')
    $moduleRoot = Join-Path $RepositoryRoot 'Module'

    $track = [bool]$config.TrackTimings
    $report = [bool]$config.ReportLoadFailures

    foreach ($name in $config.Modules) {
        Import-ProfileComponent -Name $name -Kind 'Module' -Track:$track -Report:$report `
            -Path (Join-Path $moduleRoot "$name/$name.psd1")
    }

    # Plugins are resolved through discovery rather than by building a path, so a plugin outside
    # the repository loads exactly like a built-in and can override one of the same name.
    $script:PluginCache = $null
    $discovered = @{}
    foreach ($plugin in Get-ProfilePlugin) { $discovered[$plugin.Name] = $plugin }

    foreach ($name in $config.Plugins) {
        $plugin = $discovered[$name]

        if (-not $plugin) {
            if ($report) { Write-Warning "Plugin '$name' is enabled but was not found in any plugin directory." }
            $script:LoadReport.Add([PSCustomObject]@{ Kind = 'Plugin'; Name = $name; Status = 'missing'; Milliseconds = 0 })
            continue
        }

        if ($plugin.MinimumProfileVersion -and [version]$plugin.MinimumProfileVersion -gt [version]$script:ProfileVersion) {
            if ($report) {
                Write-Warning "Plugin '$name' needs profile $($plugin.MinimumProfileVersion); this is $script:ProfileVersion."
            }
            $script:LoadReport.Add([PSCustomObject]@{ Kind = 'Plugin'; Name = $name; Status = 'incompatible'; Milliseconds = 0 })
            continue
        }

        if ($config.SkipMissingTools -and -not $plugin.ToolPresent) {
            $script:LoadReport.Add([PSCustomObject]@{ Kind = 'Plugin'; Name = $name; Status = 'skipped'; Milliseconds = 0 })
            continue
        }

        if ($plugin.Shadows) {
            $script:LoadNotice.Add(("plugin '{0}' from {1} overrides the {2} one" -f $plugin.Name, $plugin.Scope, $plugin.Shadows))
        }

        # A lazy plugin registers stubs now and imports itself on first use.
        if ($plugin.LazyCommands -and $plugin.LazyCommands.Count) {
            Register-ProfileLazyCommand -Plugin $plugin
            $script:LoadReport.Add([PSCustomObject]@{ Kind = 'Plugin'; Name = $name; Status = 'lazy'; Milliseconds = 0 })
            continue
        }

        Import-ProfileComponent -Name $name -Kind 'Plugin' -Track:$track -Report:$report -Path $plugin.Path
    }

    foreach ($name in $config.Utilities) {
        Import-ProfileComponent -Name $name -Kind 'Utility' -Track:$track -Report:$report `
            -Path (Join-Path $moduleRoot "Utility/$name/$name.psd1")
    }

    foreach ($name in $config.ExternalModules) {
        # A Gallery module listed in DeferExternalModules is imported just after the first prompt
        # rather than during startup. Interactive shells reach a prompt sooner; non-interactive
        # ones never draw a prompt and so never pay for it at all.
        if ($config.DeferExternalModules -contains $name) {
            Register-ProfileDeferredModule -Name $name
            $script:LoadReport.Add([PSCustomObject]@{ Kind = 'External'; Name = $name; Status = 'deferred'; Milliseconds = 0 })
            continue
        }

        $stopwatch = if ($track) { [System.Diagnostics.Stopwatch]::StartNew() } else { $null }

        Import-Module -Name $name -Global -ErrorAction SilentlyContinue
        $status = if (Get-Module -Name $name) { 'loaded' } else { 'missing' }

        if ($stopwatch) { $stopwatch.Stop() }

        if ($status -eq 'missing' -and $report) {
            Write-Warning "Gallery module '$name' is not installed. Run Install-ProfileDependency to add it."
        }

        $script:LoadReport.Add([PSCustomObject]@{
                Kind         = 'External'
                Name         = $name
                Status       = $status
                Milliseconds = if ($stopwatch) { [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 1) } else { 0 }
            })
    }

    if ($config.LoadChocolateyProfile -and $env:ChocolateyInstall) {
        $chocolatey = Join-Path -Path $env:ChocolateyInstall -ChildPath 'helpers\chocolateyProfile.psm1'
        if (Test-Path -LiteralPath $chocolatey) {
            Import-Module -Name $chocolatey -Global -ErrorAction SilentlyContinue
        }
    }

    $policyPath = Join-Path $RepositoryRoot 'Tools/ExportPolicy.psd1'
    if (Test-Path -LiteralPath $policyPath) {
        Resolve-ProfileConflict -Policy (Import-PowerShellDataFile -LiteralPath $policyPath) `
            -PreferNativeTools:([bool]$config.PreferNativeTools) `
            -AllowBuiltinShadowing:([bool]$config.AllowBuiltinShadowing)
    }
}

function Measure-ProfileLoad {
    <#
    .SYNOPSIS
        Shows what the last profile load did, and what it cost.

    .DESCRIPTION
        Lists every module that loaded, failed, was skipped or was missing, with per-module
        timings when TrackTimings is on. Use it after editing profile.config.psd1 to see the
        effect of enabling or disabling something.

    .PARAMETER All
        Include modules that were skipped because their tool is not installed.

    .OUTPUTS
        [PSCustomObject[]] One row per component.

    .EXAMPLE
        Measure-ProfileLoad
        Lists what loaded, slowest first.

    .EXAMPLE
        Measure-ProfileLoad -All | Where-Object Status -eq 'skipped'
        Shows which plugins were skipped for a missing tool.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-load')]
    [OutputType([PSCustomObject[]])]
    param(
        [switch]$All
    )

    $rows = if ($All) { $script:LoadReport } else { $script:LoadReport | Where-Object { $_.Status -ne 'skipped' } }

    $loaded = @($script:LoadReport | Where-Object { $_.Status -eq 'loaded' })
    $failed = @($script:LoadReport | Where-Object { $_.Status -eq 'failed' })
    $skipped = @($script:LoadReport | Where-Object { $_.Status -eq 'skipped' })
    $total = ($loaded | Measure-Object -Property Milliseconds -Sum).Sum

    Write-Host ""
    Write-Host ("{0} loaded, {1} skipped (tool absent), {2} failed - {3:N0} ms" -f `
            $loaded.Count, $skipped.Count, $failed.Count, $total)

    foreach ($notice in $script:LoadNotice) {
        Write-Host ("  note: {0}" -f $notice) -ForegroundColor DarkGray
    }

    Write-Host ""
    return $rows | Sort-Object -Property Milliseconds -Descending
}
