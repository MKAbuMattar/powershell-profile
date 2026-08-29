#Requires -Version 7.0
<#
.SYNOPSIS
    Checks that the installer adds what was asked for and removes only what it added.

.DESCRIPTION
    Every test here works on a scratch directory and a scratch receipt. Nothing installs a package
    or a Gallery module for real: those paths are exercised through mocks, and the File and Tree
    paths are exercised for real because copying a file is cheap and is where the risk lives.

    The risk is losing a file the user wrote. Install moves a displaced file aside and records
    where it went; uninstall puts it back. Two tests hold that down end to end.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    Import-Module -Name (Join-Path $script:Root 'Module/Setup/Setup.psd1') -Force -DisableNameChecking

    function New-Scratch {
        <#
        .SYNOPSIS
            Makes a throwaway directory and returns its path.
        #>
        param()

        $path = Join-Path ([System.IO.Path]::GetTempPath()) ("setup-install-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $path -Force
        $path
    }

    function New-FileUnit {
        <#
        .SYNOPSIS
            Builds a File catalog row pointed at a scratch destination.
        #>
        param(
            [Parameter(Mandatory)][string]$Destination,
            [Parameter(Mandatory)][string]$Source
        )

        [PSCustomObject]@{
            Id = 'scratch-file'; Name = 'Scratch'; Category = 'Config'; Required = $false
            Description = 'A file used by the tests.'
            Kind = 'File'; Detect = $Destination; Source = $Source; Step = $null
            Winget = $null; Chocolatey = $null
        }
    }
}

Describe 'The catalog knows where to copy from' {

    It 'gives every File and Tree unit a Source' {
        foreach ($unit in (Get-ProfileSetupCatalog | Where-Object { $_.Kind -in 'File', 'Tree' })) {
            $unit.Source | Should -Not -BeNullOrEmpty -Because "$($unit.Id) has nothing to copy from"
        }
    }

    It 'names a Source that exists in this repository' {
        # A row naming a path the repository does not have would install fine in review and fail
        # on a user's machine.
        foreach ($unit in (Get-ProfileSetupCatalog | Where-Object { $_.Kind -in 'File', 'Tree' })) {
            Test-Path -LiteralPath (Join-Path $script:Root $unit.Source) |
                Should -BeTrue -Because "$($unit.Id) names Source '$($unit.Source)'"
        }
    }

    It 'leaves Source empty for a unit that is not copied' {
        foreach ($unit in (Get-ProfileSetupCatalog | Where-Object { $_.Kind -in 'Package', 'Module', 'Font' })) {
            $unit.Source | Should -BeNullOrEmpty -Because "$($unit.Id) is not copied from the repository"
        }
    }
}

Describe 'Resolve-ProfileSetupManager' {

    It 'returns an explicit preference unchanged' {
        Resolve-ProfileSetupManager -Preference Chocolatey | Should -BeExactly 'Chocolatey'
        Resolve-ProfileSetupManager -Preference None | Should -BeExactly 'None'
    }

    It 'prefers winget over Chocolatey when both are present' {
        # winget installs the profile's tools without an elevated session and Chocolatey does not,
        # so Auto has to pick winget rather than whichever is found first.
        Mock -ModuleName Setup Get-Command { [PSCustomObject]@{ Name = 'winget' } } -ParameterFilter { $Name -eq 'winget' }

        Resolve-ProfileSetupManager -Preference Auto | Should -BeExactly 'Winget'
    }

    It 'returns None when neither is installed' {
        Mock -ModuleName Setup Get-Command { $null } -ParameterFilter { $Name -in 'winget', 'choco' }

        Resolve-ProfileSetupManager -Preference Auto | Should -BeExactly 'None'
    }
}

Describe 'Copy-ProfileSetupItem' {

    BeforeEach {
        $script:Scratch = New-Scratch
        $script:Source = Join-Path $script:Scratch 'source.txt'
        $script:Target = Join-Path $script:Scratch 'target.txt'
        Set-Content -LiteralPath $script:Source -Value 'from the repository' -Encoding UTF8
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'copies into a destination that does not exist and reports no backup' {
        $backup = Copy-ProfileSetupItem -Source $script:Source -Destination $script:Target -Confirm:$false

        $backup | Should -BeNullOrEmpty
        Get-Content -LiteralPath $script:Target | Should -BeExactly 'from the repository'
    }

    It 'moves an existing file aside and reports where it went' {
        Set-Content -LiteralPath $script:Target -Value 'the file the user wrote' -Encoding UTF8

        $backup = Copy-ProfileSetupItem -Source $script:Source -Destination $script:Target -Confirm:$false

        $backup | Should -Not -BeNullOrEmpty
        Get-Content -LiteralPath $backup | Should -BeExactly 'the file the user wrote'
        Get-Content -LiteralPath $script:Target | Should -BeExactly 'from the repository'
    }

    It 'creates the parent directory it copies into' {
        $nested = Join-Path $script:Scratch 'a/b/c/target.txt'

        Copy-ProfileSetupItem -Source $script:Source -Destination $nested -Confirm:$false | Out-Null

        Test-Path -LiteralPath $nested | Should -BeTrue
    }

    It 'throws when the source is not there' {
        { Copy-ProfileSetupItem -Source (Join-Path $script:Scratch 'absent') -Destination $script:Target -Confirm:$false } |
            Should -Throw '*does not exist*'
    }

    It 'copies nothing under -WhatIf' {
        Copy-ProfileSetupItem -Source $script:Source -Destination $script:Target -WhatIf | Out-Null

        Test-Path -LiteralPath $script:Target | Should -BeFalse
    }
}

Describe 'Invoke-ProfileSetup' {

    BeforeEach {
        $script:Scratch = New-Scratch
        $script:Receipt = Join-Path $script:Scratch 'receipt.json'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'installs a File unit and records that it owns it' {
        $results = @(Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        $results.Count | Should -Be 1
        $results[0].Status | Should -BeExactly 'installed'
        Test-Path -LiteralPath (Join-Path $script:Scratch 'profile.config.psd1') | Should -BeTrue

        $state = Get-ProfileSetupState -InstallPath $script:Scratch -ReceiptPath $script:Receipt | Where-Object { $_.Id -eq 'config' }
        $state.Owned | Should -BeTrue
    }

    It 'reports a unit that is already there as present and does not copy again' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $target = Join-Path $script:Scratch 'profile.config.psd1'
        Set-Content -LiteralPath $target -Value 'edited by the user' -Encoding UTF8

        $again = @(Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        $again[0].Status | Should -BeExactly 'present'
        Get-Content -LiteralPath $target | Should -BeExactly 'edited by the user'
    }

    It 'copies again under -Force' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $target = Join-Path $script:Scratch 'profile.config.psd1'
        Set-Content -LiteralPath $target -Value 'edited by the user' -Encoding UTF8

        $again = @(Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Force -Confirm:$false)

        $again[0].Status | Should -BeExactly 'installed'
        Get-Content -LiteralPath $target -Raw | Should -Not -BeExactly 'edited by the user'
    }

    It 'skips a File unit when no repository was given' {
        # Installing from nothing would either throw or write an empty file. It reports instead.
        $results = @(Invoke-ProfileSetup -Id config -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        $results[0].Status | Should -BeExactly 'skipped'
        $results[0].Message | Should -Match 'No repository'
    }

    It 'throws on an id that is not in the catalog' {
        { Invoke-ProfileSetup -Id 'no-such-unit' -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false } |
            Should -Throw '*No such setup unit*'
    }

    It 'writes no receipt entry when the install fails' {
        # An ownership claim for something that was never installed would make a later uninstall
        # try to remove a file it does not own.
        Mock -ModuleName Setup Copy-ProfileSetupItem { throw 'the disk is full' }

        $results = @(Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        $results[0].Status | Should -BeExactly 'failed'
        @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries).Count | Should -Be 0
    }

    It 'installs nothing under -WhatIf' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -WhatIf | Out-Null

        Test-Path -LiteralPath (Join-Path $script:Scratch 'profile.config.psd1') | Should -BeFalse
        @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries).Count | Should -Be 0
    }
}

Describe 'Uninstall-ProfileSetup' {

    BeforeEach {
        $script:Scratch = New-Scratch
        $script:Receipt = Join-Path $script:Scratch 'receipt.json'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'removes nothing at all when the receipt is empty' {
        # The case that matters: a machine where the profile was cloned, not installed. Every unit
        # is someone else's, so uninstall is a no-op that explains itself.
        $results = @(Uninstall-ProfileSetup -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        @($results | Where-Object { $_.Status -ne 'skipped' }).Count | Should -Be 0
    }

    It 'explains why it left a present but unowned unit alone' {
        $results = @(Uninstall-ProfileSetup -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)
        $unowned = $results | Where-Object { $_.Message -match 'not ours' } | Select-Object -First 1

        $unowned | Should -Not -BeNullOrEmpty
    }

    It 'refuses a Required unit even when it owns it' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $results = @(Uninstall-ProfileSetup -Id config -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        $results[0].Status | Should -BeExactly 'skipped'
        $results[0].Message | Should -Match 'Required'
        Test-Path -LiteralPath (Join-Path $script:Scratch 'profile.config.psd1') | Should -BeTrue
    }

    It 'deletes a file it installed over nothing' {
        $target = Join-Path $script:Scratch 'installed.txt'
        $source = Join-Path $script:Root 'VERSION'
        $unit = New-FileUnit -Destination $target -Source 'VERSION'

        $result = Install-ProfileSetupUnit -Unit $unit -Repository $script:Root -Confirm:$false
        $result.Status | Should -BeExactly 'installed'
        $result.Backup | Should -BeNullOrEmpty

        $removed = Remove-ProfileSetupUnit -Unit $unit -Confirm:$false

        $removed.Status | Should -BeExactly 'removed'
        Test-Path -LiteralPath $target | Should -BeFalse
        $source | Should -Exist
    }

    It 'puts back the file it displaced instead of deleting it' {
        # The whole reason the receipt keeps a backup path. Uninstalling must not leave the user
        # without the starship.toml they wrote.
        $target = Join-Path $script:Scratch 'starship.toml'
        Set-Content -LiteralPath $target -Value '# the file the user wrote' -Encoding UTF8

        $unit = New-FileUnit -Destination $target -Source 'VERSION'

        $installed = Install-ProfileSetupUnit -Unit $unit -Repository $script:Root -Confirm:$false
        $installed.Backup | Should -Not -BeNullOrEmpty
        Get-Content -LiteralPath $target -Raw | Should -Not -Match 'the file the user wrote'

        $removed = Remove-ProfileSetupUnit -Unit $unit -Backup $installed.Backup -Confirm:$false

        $removed.Status | Should -BeExactly 'restored'
        Get-Content -LiteralPath $target | Should -BeExactly '# the file the user wrote'
        Test-Path -LiteralPath $installed.Backup | Should -BeFalse
    }

    It 'leaves a font installed and says so' {
        $unit = Get-ProfileSetupCatalog -Category Font | Select-Object -First 1

        $result = Remove-ProfileSetupUnit -Unit $unit -Confirm:$false

        $result.Status | Should -BeExactly 'skipped'
        $result.Message | Should -Match 'left installed'
    }

    It 'drops the receipt entry once a unit is removed' {
        $target = Join-Path $script:Scratch 'installed.txt'
        $unit = New-FileUnit -Destination $target -Source 'VERSION'

        Install-ProfileSetupUnit -Unit $unit -Repository $script:Root -Confirm:$false | Out-Null
        Add-ProfileSetupReceiptEntry -Id $unit.Id -Path $script:Receipt
        @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries).Count | Should -Be 1

        Remove-ProfileSetupUnit -Unit $unit -Confirm:$false | Out-Null
        Remove-ProfileSetupReceiptEntry -Id $unit.Id -Path $script:Receipt

        @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries).Count | Should -Be 0
    }

    It 'throws on an id that is not in the catalog' {
        { Uninstall-ProfileSetup -Id 'no-such-unit' -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false } |
            Should -Throw '*No such setup unit*'
    }

    It 'removes nothing under -WhatIf' {
        Invoke-ProfileSetup -Id starship-config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $before = @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries).Count

        Uninstall-ProfileSetup -Id starship-config -InstallPath $script:Scratch -ReceiptPath $script:Receipt -WhatIf | Out-Null

        @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries).Count | Should -Be $before
    }
}

Describe 'Update-ProfileSetup' {

    BeforeEach {
        $script:Scratch = New-Scratch
        $script:Receipt = Join-Path $script:Scratch 'receipt.json'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'refuses to touch anything the receipt does not list' {
        # The bug this check exists for. Several units point at absolute user paths rather than at
        # anything under InstallPath: $PROFILE, ~/.config/starship.toml, the Windows Terminal
        # settings. Refreshing on Present alone reached past the scratch install path and
        # overwrote the real ones.
        $results = @(Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        @($results | Where-Object { $_.Status -ne 'skipped' }).Count | Should -Be 0
        @($results | Where-Object { $_.Message -match 'not ours to refresh' }).Count | Should -BeGreaterThan 0
    }

    It 'never writes outside the install path when it owns nothing' {
        # Named separately from the message check, because the message could be right while the
        # write still happened.
        $profileBackup = "$PROFILE.profile-backup"
        Test-Path -LiteralPath $profileBackup | Should -BeFalse -Because 'the test starts clean'

        Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        Test-Path -LiteralPath $profileBackup | Should -BeFalse -Because 'an unowned $PROFILE must not be replaced'
    }

    It 'refreshes a unit it does own' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $result = @(Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -IncludeConfig -Confirm:$false) |
            Where-Object { $_.Id -eq 'config' }

        $result.Status | Should -BeExactly 'refreshed'
    }

    It 'keeps profile.config.psd1 unless asked' {
        # It holds the choices about what loads at every shell start. Those are the user's, and an
        # update that silently reset them would be worse than one that did nothing.
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $target = Join-Path $script:Scratch 'profile.config.psd1'
        Add-Content -LiteralPath $target -Value '# a choice the user made'

        $result = @(Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false) |
            Where-Object { $_.Id -eq 'config' }

        $result.Status | Should -BeExactly 'skipped'
        $result.Message | Should -Match 'IncludeConfig'
        Get-Content -LiteralPath $target -Raw | Should -Match 'a choice the user made'
    }

    It 'replaces profile.config.psd1 under -IncludeConfig' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $target = Join-Path $script:Scratch 'profile.config.psd1'
        Add-Content -LiteralPath $target -Value '# a choice the user made'

        Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -IncludeConfig -Confirm:$false | Out-Null

        Get-Content -LiteralPath $target -Raw | Should -Not -Match 'a choice the user made'
    }

    It 'adds nothing that was not there' {
        # The difference between update and install. A machine that never wanted FastFetch must
        # not acquire it on an update.
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        Test-Path -LiteralPath (Join-Path $script:Scratch 'Module') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path $script:Scratch 'Tools') | Should -BeFalse
    }

    It 'leaves a package alone, because winget updates those' {
        $results = @(Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false)

        @($results | Where-Object { $_.Id -in 'fzf', 'starship', 'zoxide', 'terminal-icons' }).Count | Should -Be 0
    }

    It 'writes nothing under -WhatIf' {
        Invoke-ProfileSetup -Id config -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -Confirm:$false | Out-Null

        $target = Join-Path $script:Scratch 'profile.config.psd1'
        Add-Content -LiteralPath $target -Value '# a choice the user made'

        Update-ProfileSetup -Repository $script:Root -InstallPath $script:Scratch -ReceiptPath $script:Receipt -IncludeConfig -WhatIf | Out-Null

        Get-Content -LiteralPath $target -Raw | Should -Match 'a choice the user made'
    }
}