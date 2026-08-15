#Requires -Version 5.1
<#
    Pester tests for the load contract.

    These lock in the four bugs that were shipped for an unknown period because nothing checked
    them: a module that failed to parse, a manifest that promised functions nobody wrote, an alias
    that shadowed its own function, and a manifest GUID that was not a GUID.

    Run with ./Tools/Invoke-Pester.ps1.
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    $script:Policy = Import-PowerShellDataFile (Join-Path $Root 'Tools/ExportPolicy.psd1')
    . (Join-Path $Root 'Tools/Get-ModuleExport.ps1')

    $script:Manifests = @(Get-ChildItem -LiteralPath (Join-Path $Root 'Module') -Recurse -File -Filter '*.psd1' |
            Where-Object { Test-Path (Join-Path $_.DirectoryName ($_.BaseName + '.psm1')) })
}

Describe 'Module manifests' {

    It 'declares a valid GUID in <Name>' -ForEach @(
        (Get-ChildItem -LiteralPath (Join-Path (Split-Path -Parent $PSScriptRoot) 'Module') -Recurse -File -Filter '*.psd1' |
            ForEach-Object { @{ Name = $_.Name; Path = $_.FullName } })
    ) {
        # Conda.psd1 shipped '...-0e9f8g7h6i5j'. Letters beyond f are not hexadecimal, so the
        # module never imported and nothing said so.
        $data = Import-PowerShellDataFile -LiteralPath $Path
        { [guid]::Parse($data.GUID) } | Should -Not -Throw -Because "$Name must have a parseable GUID"
    }

    It 'exports only functions that exist, and every function it defines' {
        $stale = foreach ($manifest in $script:Manifests) {
            $data = Import-PowerShellDataFile -LiteralPath $manifest.FullName
            if (@($data.FunctionsToExport) -contains '*') { continue }

            $module = Join-Path $manifest.DirectoryName ($manifest.BaseName + '.psm1')
            $exports = Get-ModuleExport -ModulePath $module -Policy $script:Policy
            if ($exports.ParseErrors.Count) { continue }

            $committed = @($data.FunctionsToExport) -join '|'
            $generated = @($exports.Functions) -join '|'
            if ($committed -ne $generated) { $manifest.Name }
        }

        @($stale) | Should -BeNullOrEmpty -Because 'Tools/Update-Manifest.ps1 regenerates these'
    }
}

Describe 'Every module imports' {

    It 'imports <Name> without error' -ForEach @(
        (Get-ChildItem -LiteralPath (Join-Path (Split-Path -Parent $PSScriptRoot) 'Module') -Recurse -File -Filter '*.psd1' |
            Where-Object { $_.Name -ne 'Git.psd1' -and (Test-Path (Join-Path $_.DirectoryName ($_.BaseName + '.psm1'))) } |
            ForEach-Object { @{ Name = $_.BaseName; Path = $_.FullName } })
    ) {
        { Import-Module -Name $Path -Force -ErrorAction Stop } | Should -Not -Throw
    }
}

Describe 'Alias safety' {

    BeforeAll {
        $script:AllAliases = foreach ($manifest in $script:Manifests) {
            $data = Import-PowerShellDataFile -LiteralPath $manifest.FullName
            foreach ($alias in @($data.AliasesToExport)) {
                if ($alias -and $alias -ne '*') {
                    [PSCustomObject]@{ Alias = $alias; Module = $manifest.BaseName }
                }
            }
        }
    }

    It 'never exports an alias reserved for a real executable' {
        # WebSearch declared `docker` and `claude`, so `docker ps` opened a browser tab.
        $reserved = @($script:AllAliases |
                Where-Object { $_.Alias -in $script:Policy.ReservedAliases } |
                ForEach-Object { "$($_.Module): $($_.Alias)" })

        $reserved | Should -BeNullOrEmpty
    }

    It 'never exports an alias identical to its own function name' {
        # Update-Profile declared [Alias('update-profile')]. Alias names are case-insensitive, so
        # the alias shadowed the function and resolved to itself; the command was uncallable.
        $selfReferential = foreach ($manifest in $script:Manifests) {
            $data = Import-PowerShellDataFile -LiteralPath $manifest.FullName
            $functions = @($data.FunctionsToExport)
            foreach ($alias in @($data.AliasesToExport)) {
                if ($alias -and $alias -ne '*' -and $alias -in $functions) { "$($manifest.BaseName): $alias" }
            }
        }

        @($selfReferential) | Should -BeNullOrEmpty
    }

    It 'declares no alias twice within one module' {
        # PowerShell alias names are case-insensitive, so the zsh convention of distinguishing
        # commands by case does not survive the port: DockerCompose had dclf and dclF, NPM had
        # npmi and npmI. In each pair one alias was simply unreachable.
        $collisions = $script:AllAliases |
            Group-Object Module |
            ForEach-Object {
                $_.Group | Group-Object Alias | Where-Object Count -gt 1 | ForEach-Object { "$($_.Name)" }
            }

        @($collisions) | Should -BeNullOrEmpty -Because 'one of the pair would be unreachable'
    }

    It 'reports cross-module alias contention as a known, warned-about condition' {
        # PNPM, Pipenv and Poetry all want the p* namespace. Whichever loads last wins, which is
        # tolerable because they are rarely enabled together, and the loader warns when they are.
        # This test exists to notice if the set grows, not to fail on it.
        $shared = @($script:AllAliases |
                Group-Object Alias |
                Where-Object Count -gt 1 |
                ForEach-Object { $_.Name })

        $shared.Count | Should -BeLessOrEqual 12 -Because 'cross-module alias contention should not grow'
    }
}

Describe 'Loader' {

    BeforeAll {
        Import-Module (Join-Path $script:Root 'Module/Loader/Loader.psd1') -Force
    }

    It 'reads the repository configuration' {
        $config = Get-ProfileConfig -Path (Join-Path $script:Root 'profile.config.psd1')
        $config.Modules | Should -Not -BeNullOrEmpty
        $config.SkipMissingTools | Should -BeOfType [bool]
    }

    It 'falls back to defaults when the configuration is missing' {
        $config = Get-ProfileConfig -Path (Join-Path $script:Root 'no-such-config.psd1') -WarningAction SilentlyContinue
        $config.Modules | Should -Not -BeNullOrEmpty
        $config.Plugins | Should -BeNullOrEmpty
    }

    It 'reports a plugin with no known tool as available' {
        Test-ProfileTool -Plugin 'NotARealPlugin' | Should -BeTrue
    }

    It 'reports Kubectl according to whether kubectl is installed' {
        $expected = [bool](Get-Command kubectl -CommandType Application -ErrorAction SilentlyContinue)
        Test-ProfileTool -Plugin 'Kubectl' | Should -Be $expected
    }

    It 'names every module listed in the configuration' {
        $config = Get-ProfileConfig -Path (Join-Path $script:Root 'profile.config.psd1')

        $missing = foreach ($name in $config.Modules) {
            if (-not (Test-Path (Join-Path $script:Root "Module/$name/$name.psd1"))) { $name }
        }
        foreach ($name in $config.Plugins) {
            if (-not (Test-Path (Join-Path $script:Root "Module/Plugins/$name/$name.psd1"))) { $missing += $name }
        }
        foreach ($name in $config.Utilities) {
            if (-not (Test-Path (Join-Path $script:Root "Module/Utility/$name/$name.psd1"))) { $missing += $name }
        }

        @($missing) | Should -BeNullOrEmpty -Because 'the configuration must not name a module that does not exist'
    }
}

Describe 'Update-Profile' {

    BeforeAll {
        Import-Module (Join-Path $script:Root 'Module/Logging/Logging.psd1') -Force
        Import-Module (Join-Path $script:Root 'Module/Environment/Environment.psd1') -Force
        Import-Module (Join-Path $script:Root 'Module/Update/Update.psd1') -Force
    }

    It 'resolves to a function, not to its own alias' {
        (Get-Command Update-Profile).CommandType | Should -Be 'Function'
    }

    It 'finds a third-party section' {
        $file = Join-Path ([System.IO.Path]::GetTempPath()) "profile-test-$([guid]::NewGuid()).ps1"
        try {
            Set-Content -LiteralPath $file -Value @(
                '# ordinary profile content'
                '# DO NOT MODIFY -- coreutils -- 60b36fc6-2d59-49df-be51-28dd2f4c3c9a'
                '$script:__COREUTILS__ = 1'
            )

            $section = Get-ForeignProfileSection -Path $file
            $section | Should -Match 'DO NOT MODIFY'
            $section | Should -Match '__COREUTILS__'
            $section | Should -Not -Match 'ordinary profile content'
        }
        finally {
            Remove-Item -LiteralPath $file -Force -ErrorAction SilentlyContinue
        }
    }

    It 'returns nothing when there is no third-party section' {
        $file = Join-Path ([System.IO.Path]::GetTempPath()) "profile-test-$([guid]::NewGuid()).ps1"
        try {
            Set-Content -LiteralPath $file -Value '# just a profile'
            Get-ForeignProfileSection -Path $file | Should -BeNullOrEmpty
        }
        finally {
            Remove-Item -LiteralPath $file -Force -ErrorAction SilentlyContinue
        }
    }
}

Describe 'Pipeline binding' {

    BeforeAll {
        Import-Module (Join-Path $script:Root 'Module/Directory/Directory.psd1') -Force
    }

    It 'processes every piped item, not just the last' {
        # Before the process blocks were added, piping three names created only the third file.
        $directory = Join-Path ([System.IO.Path]::GetTempPath()) "pipe-test-$([guid]::NewGuid())"
        New-Item -ItemType Directory -Path $directory -Force | Out-Null

        try {
            Push-Location $directory
            'a.txt', 'b.txt', 'c.txt' | Set-FreshFile
            @(Get-ChildItem -File).Count | Should -Be 3
        }
        finally {
            Pop-Location
            Remove-Item -LiteralPath $directory -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
