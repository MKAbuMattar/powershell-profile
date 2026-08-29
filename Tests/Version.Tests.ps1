#Requires -Version 7.0
<#
.SYNOPSIS
    Checks that one version reaches every file that carries one.

.DESCRIPTION
    VERSION at the repository root is the source, and Tools/Update-Version.ps1 stamps it into
    every header comment, every ModuleVersion key and the loader constant the
    MinimumProfileVersion gate compares against. This is the same derivation CI runs, so a local
    Pester run reports drift before the push does.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    . (Join-Path $script:Root 'Tools/Get-VersionStamp.ps1')
}

Describe 'Version stamping' {

    It 'reads VERSION as a three-part version' {
        $version = Get-ProfileVersionFile -Path $script:Root
        $version | Should -BeOfType [version]
        $version.ToString() | Should -Match '^\d+\.\d+\.\d+$'
    }

    It 'throws when VERSION is missing' {
        $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("version-missing-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force

        try {
            { Get-ProfileVersionFile -Path $scratch } | Should -Throw '*VERSION not found*'
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'throws when VERSION is not a three-part version' {
        $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("version-bad-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force

        try {
            Set-Content -LiteralPath (Join-Path $scratch 'VERSION') -Value 'v5.1' -Encoding UTF8
            { Get-ProfileVersionFile -Path $scratch } | Should -Throw '*three-part version*'
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'reports no drift in the committed tree' {
        $drifted = @(Get-VersionStamp -Path $script:Root | ForEach-Object { $_.Relative })
        $drifted -join "`n" | Should -BeNullOrEmpty
    }

    It 'rewrites a version without changing line endings' {
        # The first draft anchored the header pattern with \s*$, which in multiline mode consumed
        # the CR of every CRLF it touched and left the repository with mixed endings.
        $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("version-stamp-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force

        try {
            Set-Content -LiteralPath (Join-Path $scratch 'VERSION') -Value '9.9.9' -Encoding UTF8

            $target = Join-Path $scratch 'Sample.psd1'
            [System.IO.File]::WriteAllText($target, "# Version: 1.2.3`r`n@{`r`n    ModuleVersion        = '1.2.3'`r`n}`r`n")

            $stamp = @(Get-VersionStamp -Path $scratch)
            $stamp.Count | Should -Be 1
            $stamp[0].Updated | Should -BeExactly "# Version: 9.9.9`r`n@{`r`n    ModuleVersion        = '9.9.9'`r`n}`r`n"
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'leaves an LF file with LF endings' {
        $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("version-lf-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force

        try {
            Set-Content -LiteralPath (Join-Path $scratch 'VERSION') -Value '9.9.9' -Encoding UTF8

            $target = Join-Path $scratch 'Sample.psd1'
            [System.IO.File]::WriteAllText($target, "# Version: 1.2.3`n@{`n    ModuleVersion        = '1.2.3'`n}`n")

            $stamp = @(Get-VersionStamp -Path $scratch)
            $stamp[0].Updated | Should -BeExactly "# Version: 9.9.9`n@{`n    ModuleVersion        = '9.9.9'`n}`n"
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'does not stamp ModuleVersion outside a manifest' {
        # Module/Loader/Plugin.ps1 carries ModuleVersion = '1.0.0' inside the here-string it
        # scaffolds a plugin from. A user's plugin starts at its own 1.0.0, not at the profile
        # version, so a .ps1 must not be stamped.
        $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("version-scaffold-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force

        try {
            Set-Content -LiteralPath (Join-Path $scratch 'VERSION') -Value '9.9.9' -Encoding UTF8
            [System.IO.File]::WriteAllText((Join-Path $scratch 'Scaffold.ps1'), "@`"`r`n    ModuleVersion        = '1.0.0'`r`n`"@`r`n")

            @(Get-VersionStamp -Path $scratch) | Should -BeNullOrEmpty
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'keeps the real scaffold at 1.0.0' {
        $scaffold = Join-Path $script:Root 'Module/Loader/Plugin.ps1'
        (Get-Content -LiteralPath $scaffold -Raw) | Should -Match "ModuleVersion\s*=\s*'1\.0\.0'"
    }

    It 'stamps the loader constant the plugin gate compares against' {
        $loader = Get-Content -LiteralPath (Join-Path $script:Root 'Module/Loader/Loader.psm1') -Raw
        $declared = (Get-ProfileVersionFile -Path $script:Root).ToString()

        $loader | Should -Match ([regex]::Escape("`$script:ProfileVersion = '$declared'"))
    }
}
