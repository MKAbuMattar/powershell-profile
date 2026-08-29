#Requires -Version 7.0
<#
.SYNOPSIS
    Checks reading and writing the component lists in profile.config.psd1.

.DESCRIPTION
    The file turns an entry off by commenting it out, so the list of what is available stays next
    to the list of what is on. That makes editing it a line operation.

    Reading it with Import-PowerShellDataFile and writing the result back would delete every
    commented entry and every comment in the file, and profile.config.psd1 is mostly comments
    explaining what each module costs at startup. The test that matters most here is the one
    asserting a round trip leaves the file byte for byte unchanged.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    Import-Module -Name (Join-Path $script:Root 'Module/Setup/Setup.psd1') -Force -DisableNameChecking

    function New-Config {
        <#
        .SYNOPSIS
            Writes a scratch profile.config.psd1 and returns its path.
        #>
        param([string]$Newline = "`r`n")

        $path = Join-Path ([System.IO.Path]::GetTempPath()) ("cfg-" + [guid]::NewGuid().ToString('N') + ".psd1")

        $text = @(
            '# A comment above the hashtable.'
            '@{'
            '    Plugins               = @('
            "        'Git'"
            "        # 'AWS'          # off because it is slow"
            "        'Docker'"
            '    )'
            ''
            '    # A comment between the lists.'
            '    Utilities             = @('
            "        'Base64'"
            "        # 'Matrix'"
            '    )'
            '}'
        ) -join $Newline

        [System.IO.File]::WriteAllText($path, $text + $Newline)
        $path
    }
}

Describe 'Get-ProfileConfigEntry' {

    BeforeEach {
        $script:Config = New-Config
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Config -Force -ErrorAction SilentlyContinue
    }

    It 'reports an enabled entry' {
        $entry = Get-ProfileConfigEntry -Key Plugins -Path $script:Config | Where-Object { $_.Name -eq 'Git' }

        $entry.Enabled | Should -BeTrue
        $entry.Key | Should -BeExactly 'Plugins'
    }

    It 'reports a commented entry rather than leaving it out' {
        # The picker has to offer what is available, not only what is already on.
        $entry = Get-ProfileConfigEntry -Key Plugins -Path $script:Config | Where-Object { $_.Name -eq 'AWS' }

        $entry | Should -Not -BeNullOrEmpty
        $entry.Enabled | Should -BeFalse
    }

    It 'stops at the end of the list it was asked for' {
        $names = @(Get-ProfileConfigEntry -Key Plugins -Path $script:Config | ForEach-Object { $_.Name })

        $names | Should -Be @('Git', 'AWS', 'Docker')
        $names | Should -Not -Contain 'Base64'
    }

    It 'reads more than one list at a time' {
        $all = @(Get-ProfileConfigEntry -Key Plugins, Utilities -Path $script:Config)

        @($all | Where-Object { $_.Key -eq 'Plugins' }).Count | Should -Be 3
        @($all | Where-Object { $_.Key -eq 'Utilities' }).Count | Should -Be 2
    }

    It 'returns nothing when the file is not there' {
        Get-ProfileConfigEntry -Key Plugins -Path (Join-Path ([System.IO.Path]::GetTempPath()) 'no-such-config.psd1') |
            Should -BeNullOrEmpty
    }

    It 'reads the real configuration in this repository' {
        $entries = @(Get-ProfileConfigEntry -Key Plugins -Path (Join-Path $script:Root 'profile.config.psd1'))

        $entries.Count | Should -BeGreaterThan 10
        @($entries | Where-Object { $_.Name -eq 'Git' }).Enabled | Should -BeTrue
    }
}

Describe 'Set-ProfileConfigEntry' {

    BeforeEach {
        $script:Config = New-Config
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Config -Force -ErrorAction SilentlyContinue
    }

    It 'turns a commented entry on' {
        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true -Path $script:Config -Confirm:$false | Should -BeTrue

        (Get-ProfileConfigEntry -Key Plugins -Path $script:Config | Where-Object { $_.Name -eq 'AWS' }).Enabled |
            Should -BeTrue
    }

    It 'turns an enabled entry off' {
        Set-ProfileConfigEntry -Key Plugins -Name Git -Enabled $false -Path $script:Config -Confirm:$false | Should -BeTrue

        (Get-ProfileConfigEntry -Key Plugins -Path $script:Config | Where-Object { $_.Name -eq 'Git' }).Enabled |
            Should -BeFalse
    }

    It 'reports no change when the entry is already in that state' {
        Set-ProfileConfigEntry -Key Plugins -Name Git -Enabled $true -Path $script:Config -Confirm:$false | Should -BeFalse
    }

    It 'leaves the file byte for byte unchanged across a round trip' {
        # The whole reason this edits lines rather than rewriting the data. Everything explaining
        # what each module costs at startup lives in comments in that file.
        $before = [System.IO.File]::ReadAllText($script:Config)

        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true -Path $script:Config -Confirm:$false | Out-Null
        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $false -Path $script:Config -Confirm:$false | Out-Null

        [System.IO.File]::ReadAllText($script:Config) | Should -BeExactly $before
    }

    It 'keeps the note that followed the entry' {
        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true -Path $script:Config -Confirm:$false | Out-Null

        [System.IO.File]::ReadAllText($script:Config) | Should -Match 'off because it is slow'
    }

    It 'keeps the comments elsewhere in the file' {
        Set-ProfileConfigEntry -Key Plugins -Name Git -Enabled $false -Path $script:Config -Confirm:$false | Out-Null

        $text = [System.IO.File]::ReadAllText($script:Config)
        $text | Should -Match 'A comment above the hashtable'
        $text | Should -Match 'A comment between the lists'
    }

    It 'keeps the entries in the other list alone' {
        Set-ProfileConfigEntry -Key Plugins -Name Git -Enabled $false -Path $script:Config -Confirm:$false | Out-Null

        (Get-ProfileConfigEntry -Key Utilities -Path $script:Config | Where-Object { $_.Name -eq 'Base64' }).Enabled |
            Should -BeTrue
    }

    It 'adds an entry the file never mentioned' {
        Set-ProfileConfigEntry -Key Plugins -Name Terraform -Enabled $true -Path $script:Config -Confirm:$false | Should -BeTrue

        $entry = Get-ProfileConfigEntry -Key Plugins -Path $script:Config | Where-Object { $_.Name -eq 'Terraform' }
        $entry.Enabled | Should -BeTrue
    }

    It 'leaves the file parseable after adding an entry' {
        Set-ProfileConfigEntry -Key Plugins -Name Terraform -Enabled $true -Path $script:Config -Confirm:$false | Out-Null

        $data = Import-PowerShellDataFile -LiteralPath $script:Config
        $data.Plugins | Should -Contain 'Terraform'
        $data.Plugins | Should -Contain 'Git'
    }

    It 'keeps LF endings on an LF file' {
        $lf = New-Config -Newline "`n"
        try {
            Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true -Path $lf -Confirm:$false | Out-Null

            $text = [System.IO.File]::ReadAllText($lf)
            $text | Should -Not -Match "`r`n"
        }
        finally {
            Remove-Item -LiteralPath $lf -Force -ErrorAction SilentlyContinue
        }
    }

    It 'writes nothing under -WhatIf' {
        $before = [System.IO.File]::ReadAllText($script:Config)

        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true -Path $script:Config -WhatIf | Out-Null

        [System.IO.File]::ReadAllText($script:Config) | Should -BeExactly $before
    }

    It 'throws when the file is not there' {
        { Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true -Path (Join-Path ([System.IO.Path]::GetTempPath()) 'nope.psd1') -Confirm:$false } |
            Should -Throw '*no configuration file*'
    }
}

Describe 'Get-ProfileConfigState' {

    It 'lists what is on disk as well as what the file names' {
        # A plugin present in the Module tree but never mentioned in the configuration still has to
        # be offered, or a newly shipped plugin can only be enabled by editing the file by hand.
        $state = @(Get-ProfileConfigState -InstallPath $script:Root)

        $state.Count | Should -BeGreaterThan 20
        @($state | Where-Object { $_.Key -eq 'Plugins' }).Count | Should -BeGreaterThan 10
    }

    It 'marks an entry the configuration has commented out as off' {
        $state = @(Get-ProfileConfigState -InstallPath $script:Root)
        $aws = $state | Where-Object { $_.Key -eq 'Plugins' -and $_.Name -eq 'AWS' }

        $aws | Should -Not -BeNullOrEmpty
        $aws.Enabled | Should -BeFalse
        $aws.Installed | Should -BeTrue
    }

    It 'marks an enabled entry as on' {
        $state = @(Get-ProfileConfigState -InstallPath $script:Root)
        ($state | Where-Object { $_.Key -eq 'Plugins' -and $_.Name -eq 'Git' }).Enabled | Should -BeTrue
    }

    It 'includes the Gallery modules the file names' {
        $state = @(Get-ProfileConfigState -InstallPath $script:Root)

        @($state | Where-Object { $_.Key -eq 'ExternalModules' }).Count | Should -BeGreaterThan 0
    }

    It 'returns nothing rather than throwing when there is no profile there' {
        # What a first run looks like: the target has no Module tree and no configuration yet.
        $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("empty-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force

        try {
            @(Get-ProfileConfigState -InstallPath $scratch).Count | Should -Be 0
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
