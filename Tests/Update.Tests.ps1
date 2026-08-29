#Requires -Version 7.0
<#
.SYNOPSIS
    Checks the self-update path: version comparison, release resolution, checksum enforcement.

.DESCRIPTION
    These functions replace the Module tree and $PROFILE, both of which run in full at every shell
    start, so what they accept is worth pinning. Nothing here touches the network: the GitHub API
    and the downloads are mocked inside the Update module.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot

    # Update calls Write-LogMessage from Logging and Test-GitHubConnection from Environment, and
    # Pester cannot mock a command that does not exist in the session.
    Import-Module -Name (Join-Path $script:Root 'Module/Logging/Logging.psd1') -Force -DisableNameChecking
    Import-Module -Name (Join-Path $script:Root 'Module/Environment/Environment.psd1') -Force -DisableNameChecking
    Import-Module -Name (Join-Path $script:Root 'Module/Update/Update.psd1') -Force -DisableNameChecking
}

Describe 'ConvertTo-ProfileVersion' {

    It 'parses <Text> as <Expected>' -ForEach @(
        @{ Text = '7.9.0'; Expected = '7.9.0' }
        @{ Text = '7.10.0'; Expected = '7.10.0' }
        @{ Text = 'v7.6.0'; Expected = '7.6.0' }
        @{ Text = 'v7.6.0-preview.3'; Expected = '7.6.0' }
        @{ Text = '7.4.6.1'; Expected = '7.4.6.1' }
        @{ Text = 'v6'; Expected = '6.0' }
    ) {
        (ConvertTo-ProfileVersion $Text).ToString() | Should -BeExactly $Expected
    }

    It 'returns nothing for <Text>' -ForEach @(
        @{ Text = '' }
        @{ Text = '   ' }
        @{ Text = 'notaversion' }
    ) {
        ConvertTo-ProfileVersion $Text | Should -BeNullOrEmpty
    }

    It 'orders 7.9.0 below 7.10.0, which a string compare does not' {
        # The bug this function exists to prevent: as strings, '7.9.0' sorts above '7.10.0', so
        # Update-PowerShell reported an up-to-date shell for every release from 7.10 onwards.
        ('7.9.0' -lt '7.10.0') | Should -BeFalse
        ((ConvertTo-ProfileVersion '7.9.0') -lt (ConvertTo-ProfileVersion '7.10.0')) | Should -BeTrue
    }

    It 'accepts a prerelease build without throwing' {
        # $PSVersionTable.PSVersion carries a prerelease label on preview builds, and a bare
        # [version] cast throws on it.
        { ConvertTo-ProfileVersion '7.7.0-preview.1' } | Should -Not -Throw
    }
}

Describe 'Get-ProfileRelease' {

    It 'returns the archive and checksum assets of a release' {
        Mock -ModuleName Update Invoke-RestMethod {
            @{
                tag_name = 'v9.9.9'
                assets   = @(
                    @{ name = 'powershell-profile-v9.9.9.tar.gz'; browser_download_url = 'https://example.invalid/a.tar.gz' }
                    @{ name = 'SHA256SUMS'; browser_download_url = 'https://example.invalid/SHA256SUMS' }
                )
            }
        }

        $release = Get-ProfileRelease

        $release.Tag | Should -BeExactly 'v9.9.9'
        $release.ArchiveName | Should -BeExactly 'powershell-profile-v9.9.9.tar.gz'
        $release.ChecksumUrl | Should -BeExactly 'https://example.invalid/SHA256SUMS'
    }

    It 'refuses a release that publishes no checksum' {
        # Without SHA256SUMS there is nothing to check the archive against, and installing it
        # anyway would make the verification decorative.
        Mock -ModuleName Update Invoke-RestMethod {
            @{
                tag_name = 'v9.9.9'
                assets   = @(
                    @{ name = 'powershell-profile-v9.9.9.tar.gz'; browser_download_url = 'https://example.invalid/a.tar.gz' }
                )
            }
        }

        { Get-ProfileRelease } | Should -Throw '*SHA256SUMS*'
    }

    It 'refuses a release that publishes no archive' {
        Mock -ModuleName Update Invoke-RestMethod {
            @{ tag_name = 'v9.9.9'; assets = @(@{ name = 'SHA256SUMS'; browser_download_url = 'https://example.invalid/s' }) }
        }

        { Get-ProfileRelease } | Should -Throw '*no .tar.gz asset*'
    }
}

Describe 'Save-ProfileArchive' {

    BeforeEach {
        $script:Scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("update-test-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $script:Scratch -Force

        $script:Payload = Join-Path $script:Scratch 'payload.tar.gz'
        [System.IO.File]::WriteAllText($script:Payload, 'not really an archive, but it hashes')
        $script:Digest = (Get-FileHash -LiteralPath $script:Payload -Algorithm SHA256).Hash

        $script:Release = [PSCustomObject]@{
            Tag         = 'v9.9.9'
            ArchiveName = 'payload.tar.gz'
            ArchiveUrl  = 'https://example.invalid/payload.tar.gz'
            ChecksumUrl = 'https://example.invalid/SHA256SUMS'
        }

        # The download is already on disk, so the fetch is a no-op and the digest is real.
        Mock -ModuleName Update Invoke-WebRequest { }
        Mock -ModuleName Update Write-LogMessage { }
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'returns the archive when the digest matches' {
        Mock -ModuleName Update Invoke-WebRequest { @{ Content = "$script:Digest  payload.tar.gz`n" } } -ParameterFilter { $Uri -like '*SHA256SUMS' }

        Save-ProfileArchive -Release $script:Release -Path $script:Payload | Should -BeExactly $script:Payload
        Test-Path -LiteralPath $script:Payload | Should -BeTrue
    }

    It 'accepts the binary marker sha256sum writes' {
        Mock -ModuleName Update Invoke-WebRequest { @{ Content = "$script:Digest *payload.tar.gz`n" } } -ParameterFilter { $Uri -like '*SHA256SUMS' }

        { Save-ProfileArchive -Release $script:Release -Path $script:Payload } | Should -Not -Throw
    }

    It 'finds its own line among several' {
        $sums = @(
            "0000000000000000000000000000000000000000000000000000000000000000  other.tar.gz"
            "$script:Digest  payload.tar.gz"
            "1111111111111111111111111111111111111111111111111111111111111111  third.tar.gz"
        ) -join "`n"
        Mock -ModuleName Update Invoke-WebRequest { @{ Content = $sums } } -ParameterFilter { $Uri -like '*SHA256SUMS' }

        { Save-ProfileArchive -Release $script:Release -Path $script:Payload } | Should -Not -Throw
    }

    It 'throws and deletes the archive when the digest does not match' {
        # The whole point: a caller must not be able to act on an archive that failed the check.
        $wrong = '0' * 64
        Mock -ModuleName Update Invoke-WebRequest { @{ Content = "$wrong  payload.tar.gz`n" } } -ParameterFilter { $Uri -like '*SHA256SUMS' }

        { Save-ProfileArchive -Release $script:Release -Path $script:Payload } | Should -Throw '*Checksum mismatch*'
        Test-Path -LiteralPath $script:Payload | Should -BeFalse
    }

    It 'throws when the checksum file does not list the archive' {
        Mock -ModuleName Update Invoke-WebRequest { @{ Content = "$script:Digest  something-else.tar.gz`n" } } -ParameterFilter { $Uri -like '*SHA256SUMS' }

        { Save-ProfileArchive -Release $script:Release -Path $script:Payload } | Should -Throw '*does not list*'
        Test-Path -LiteralPath $script:Payload | Should -BeFalse
    }

    It 'does not match a line whose name merely ends with the archive name' {
        Mock -ModuleName Update Invoke-WebRequest { @{ Content = "$script:Digest  nested/payload.tar.gz`n" } } -ParameterFilter { $Uri -like '*SHA256SUMS' }

        { Save-ProfileArchive -Release $script:Release -Path $script:Payload } | Should -Throw '*does not list*'
    }
}

Describe 'Update-LocalProfileModuleDirectory' {

    BeforeEach {
        $script:Scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("update-branch-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $script:Scratch -Force

        Mock -ModuleName Update Test-GitHubConnection { $true }
        Mock -ModuleName Update Write-LogMessage { }
        Mock -ModuleName Update Invoke-WebRequest { throw 'the test should not have reached a download' }
        Mock -ModuleName Update Get-ProfileRelease { throw 'the test should not have reached the release API' }
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'refuses a branch download without -AllowUnverified' {
        # A branch tarball has no published digest, so taking one has to be an explicit choice.
        { Update-LocalProfileModuleDirectory -LocalPath $script:Scratch -Branch 'develop' -Confirm:$false } |
            Should -Not -Throw

        Should -Invoke -ModuleName Update Invoke-WebRequest -Times 0
    }

    It 'leaves a git clone alone' {
        $null = New-Item -ItemType Directory -Path (Join-Path $script:Scratch '.git') -Force

        { Update-LocalProfileModuleDirectory -LocalPath $script:Scratch -Confirm:$false } | Should -Not -Throw

        Should -Invoke -ModuleName Update Get-ProfileRelease -Times 0
    }

    It 'downloads nothing under -WhatIf' {
        { Update-LocalProfileModuleDirectory -LocalPath $script:Scratch -WhatIf } | Should -Not -Throw

        Should -Invoke -ModuleName Update Get-ProfileRelease -Times 0
        Should -Invoke -ModuleName Update Invoke-WebRequest -Times 0
    }
}
