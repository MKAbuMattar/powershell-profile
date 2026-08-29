#Requires -Version 7.0
<#
.SYNOPSIS
    Checks the installer catalog, the presence probe and the receipt that makes removal safe.

.DESCRIPTION
    The rule the whole design turns on: this installer removes only what it added. A tool being
    on PATH says nothing about who put it there, so uninstall reads the receipt rather than the
    machine. Most of what follows exists to hold that rule down.

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

        $path = Join-Path ([System.IO.Path]::GetTempPath()) ("setup-test-" + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $path -Force
        $path
    }
}

Describe 'Get-ProfileSetupCatalog' {

    BeforeAll {
        $script:Catalog = @(Get-ProfileSetupCatalog)
    }

    It 'returns rows' {
        $script:Catalog.Count | Should -BeGreaterThan 0
    }

    It 'gives every unit a unique id' {
        # The id is the receipt key. A duplicate would make one unit claim another's ownership.
        $ids = @($script:Catalog | ForEach-Object { $_.Id })
        ($ids | Sort-Object -Unique).Count | Should -Be $ids.Count
    }

    It 'uses only a Kind the probe understands' {
        $known = @('Package', 'Module', 'File', 'Tree', 'Font')
        foreach ($unit in $script:Catalog) {
            $unit.Kind | Should -BeIn $known -Because "$($unit.Id) declares Kind '$($unit.Kind)'"
        }
    }

    It 'gives every unit something to detect' {
        foreach ($unit in $script:Catalog) {
            $unit.Detect | Should -Not -BeNullOrEmpty -Because "$($unit.Id) has nothing to probe for"
        }
    }

    It 'gives every Package unit at least one package id' {
        # Otherwise the unit is offered in the picker and then cannot be installed by either
        # manager, which is worse than not offering it.
        foreach ($unit in ($script:Catalog | Where-Object { $_.Kind -eq 'Package' })) {
            ($unit.Winget -or $unit.Chocolatey) | Should -BeTrue -Because "$($unit.Id) names no package"
        }
    }

    It 'marks a unit Required only when it is Core' {
        foreach ($unit in ($script:Catalog | Where-Object { $_.Required })) {
            $unit.Category | Should -BeExactly 'Core' -Because "$($unit.Id) is Required outside Core"
        }
    }

    It 'gives every unit a description that is not the name again' {
        foreach ($unit in $script:Catalog) {
            $unit.Description | Should -Not -BeNullOrEmpty
            $unit.Description | Should -Not -BeExactly $unit.Name
        }
    }

    It 'filters by category' {
        $tools = @(Get-ProfileSetupCatalog -Category Tool)
        $tools.Count | Should -BeGreaterThan 0
        @($tools | Where-Object { $_.Category -ne 'Tool' }).Count | Should -Be 0
    }

    It 'resolves paths under a supplied install path' {
        $scratch = New-Scratch
        try {
            $config = Get-ProfileSetupCatalog -InstallPath $scratch | Where-Object { $_.Id -eq 'config' }
            $config.Detect | Should -BeExactly (Join-Path $scratch 'profile.config.psd1')
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Describe 'Test-ProfileSetupPresent' {

    It 'sees a file that exists and not one that does not' {
        $scratch = New-Scratch
        try {
            $file = Join-Path $scratch 'thing.txt'
            Set-Content -LiteralPath $file -Value 'x' -Encoding UTF8

            Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'a'; Kind = 'File'; Detect = $file }) | Should -BeTrue
            Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'b'; Kind = 'File'; Detect = (Join-Path $scratch 'absent.txt') }) | Should -BeFalse
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'does not mistake a directory for a file' {
        $scratch = New-Scratch
        try {
            Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'a'; Kind = 'File'; Detect = $scratch }) | Should -BeFalse
            Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'b'; Kind = 'Tree'; Detect = $scratch }) | Should -BeTrue
        }
        finally {
            Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'finds a module that is installed' {
        Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'a'; Kind = 'Module'; Detect = 'Pester' }) | Should -BeTrue
        Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'b'; Kind = 'Module'; Detect = 'NoSuchModuleAnywhere' }) | Should -BeFalse
    }

    It 'finds an executable on PATH' {
        Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'a'; Kind = 'Package'; Detect = 'git' }) | Should -BeTrue
        Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'b'; Kind = 'Package'; Detect = 'no-such-tool-anywhere' }) | Should -BeFalse
    }

    It 'does not answer a Package probe with a PowerShell function of the same name' {
        # Get-Command without -CommandType Application would find the Git plugin's own wrappers
        # and report every tool as installed.
        function global:no-such-tool-anywhere { 'not a real executable' }
        try {
            Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'a'; Kind = 'Package'; Detect = 'no-such-tool-anywhere' }) | Should -BeFalse
        }
        finally {
            Remove-Item -LiteralPath function:global:no-such-tool-anywhere -ErrorAction SilentlyContinue
        }
    }

    It 'throws on a Kind it does not know' {
        { Test-ProfileSetupPresent -Unit ([PSCustomObject]@{ Id = 'a'; Kind = 'Nonsense'; Detect = 'x' }) } |
            Should -Throw '*unknown Kind*'
    }
}

Describe 'The install receipt' {

    BeforeEach {
        $script:Scratch = New-Scratch
        $script:Receipt = Join-Path $script:Scratch 'receipt.json'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'reads as empty when the file does not exist' {
        $receipt = Get-ProfileSetupReceipt -Path $script:Receipt
        @($receipt.Entries).Count | Should -Be 0
    }

    It 'reads as empty when the file is corrupt, and says so' {
        # Failing towards "nothing is owned" makes a damaged receipt refuse to remove anything,
        # which is the safe direction.
        Set-Content -LiteralPath $script:Receipt -Value '{ this is not json' -Encoding UTF8

        $warnings = @()
        $receipt = Get-ProfileSetupReceipt -Path $script:Receipt -WarningVariable warnings -WarningAction SilentlyContinue

        @($receipt.Entries).Count | Should -Be 0
        ($warnings -join "`n") | Should -Match 'could not be read'
    }

    It 'records an entry and reads it back' {
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Manager 'Winget' -Path $script:Receipt

        $entries = @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries)
        $entries.Count | Should -Be 1
        $entries[0].Id | Should -BeExactly 'fzf'
        $entries[0].Manager | Should -BeExactly 'Winget'
        $entries[0].InstalledOn | Should -Not -BeNullOrEmpty
    }

    It 'replaces an entry rather than duplicating it' {
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Manager 'Winget' -Path $script:Receipt
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Manager 'Chocolatey' -Path $script:Receipt

        $entries = @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries)
        $entries.Count | Should -Be 1
        $entries[0].Manager | Should -BeExactly 'Chocolatey'
    }

    It 'keeps the path of a file it displaced' {
        Add-ProfileSetupReceiptEntry -Id 'starship-config' -Backup 'C:\x\starship.toml.bak' -Path $script:Receipt

        $entry = @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries)[0]
        $entry.Backup | Should -BeExactly 'C:\x\starship.toml.bak'
    }

    It 'removes one entry and leaves the rest' {
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Path $script:Receipt
        Add-ProfileSetupReceiptEntry -Id 'zoxide' -Path $script:Receipt

        Remove-ProfileSetupReceiptEntry -Id 'fzf' -Path $script:Receipt

        $entries = @((Get-ProfileSetupReceipt -Path $script:Receipt).Entries)
        $entries.Count | Should -Be 1
        $entries[0].Id | Should -BeExactly 'zoxide'
    }

    It 'creates the directory it writes into' {
        $nested = Join-Path $script:Scratch 'a/b/c/receipt.json'
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Path $nested

        Test-Path -LiteralPath $nested | Should -BeTrue
    }

    It 'writes nothing under -WhatIf' {
        Save-ProfileSetupReceipt -Entry @() -Path $script:Receipt -WhatIf
        Test-Path -LiteralPath $script:Receipt | Should -BeFalse
    }
}

Describe 'Get-ProfileSetupState' {

    BeforeEach {
        $script:Scratch = New-Scratch
        $script:Receipt = Join-Path $script:Scratch 'receipt.json'
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Scratch -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'reports nothing as owned when the receipt is empty' {
        $state = @(Get-ProfileSetupState -ReceiptPath $script:Receipt)

        @($state | Where-Object { $_.Owned }).Count | Should -Be 0
        @($state | Where-Object { $_.Removable }).Count | Should -Be 0
    }

    It 'refuses to call a present but unowned unit removable' {
        # This is the whole point. git and starship are on this machine because someone installed
        # them, not because this installer did, and an uninstall must not reach them.
        $state = @(Get-ProfileSetupState -ReceiptPath $script:Receipt)
        $present = @($state | Where-Object { $_.Present })

        $present.Count | Should -BeGreaterThan 0
        @($present | Where-Object { $_.Removable }).Count | Should -Be 0
    }

    It 'calls an owned, present, optional unit removable' {
        $optional = Get-ProfileSetupState -ReceiptPath $script:Receipt |
            Where-Object { $_.Present -and -not $_.Required } |
            Select-Object -First 1

        $optional | Should -Not -BeNullOrEmpty

        Add-ProfileSetupReceiptEntry -Id $optional.Id -Path $script:Receipt

        $after = Get-ProfileSetupState -ReceiptPath $script:Receipt | Where-Object { $_.Id -eq $optional.Id }
        $after.Owned | Should -BeTrue
        $after.Removable | Should -BeTrue
        $after.InstalledOn | Should -Not -BeNullOrEmpty
    }

    It 'never calls a Required unit removable, even when owned' {
        # The profile cannot run without these, so they are not offered for removal at all.
        foreach ($unit in (Get-ProfileSetupCatalog | Where-Object { $_.Required })) {
            Add-ProfileSetupReceiptEntry -Id $unit.Id -Path $script:Receipt
        }

        $state = @(Get-ProfileSetupState -ReceiptPath $script:Receipt | Where-Object { $_.Required })

        $state.Count | Should -BeGreaterThan 0
        @($state | Where-Object { $_.Removable }).Count | Should -Be 0
    }

    It 'does not call an owned but absent unit removable' {
        # A receipt entry for something that is no longer there, removed by hand or by another
        # installer. Nothing left to take away.
        $absent = Get-ProfileSetupState -ReceiptPath $script:Receipt |
            Where-Object { -not $_.Present } |
            Select-Object -First 1

        if (-not $absent) {
            Set-ItResult -Skipped -Because 'every catalogued unit is present on this machine'
            return
        }

        Add-ProfileSetupReceiptEntry -Id $absent.Id -Path $script:Receipt

        $after = Get-ProfileSetupState -ReceiptPath $script:Receipt | Where-Object { $_.Id -eq $absent.Id }
        $after.Owned | Should -BeTrue
        $after.Removable | Should -BeFalse
    }

    It 'reports one row per catalogue unit' {
        $state = @(Get-ProfileSetupState -ReceiptPath $script:Receipt)
        $state.Count | Should -Be @(Get-ProfileSetupCatalog).Count
    }

    It 'filters by category' {
        $tools = @(Get-ProfileSetupState -Category Tool -ReceiptPath $script:Receipt)
        $tools.Count | Should -Be @(Get-ProfileSetupCatalog -Category Tool).Count
        @($tools | Where-Object { $_.Category -ne 'Tool' }).Count | Should -Be 0
    }
}

Describe 'Get-ProfileSetupMode' {

    BeforeEach {
        # The real marker is moved aside, so the test decides what a first run looks like and the
        # machine's own state is put back afterwards.
        $script:Marker = Get-ProfileSetupMarkerPath
        $script:Stash = "$script:Marker.testing"
        if (Test-Path -LiteralPath $script:Marker) { Move-Item -LiteralPath $script:Marker -Destination $script:Stash -Force }
        $script:Made = [System.Collections.Generic.List[string]]::new()
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Marker -Force -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $script:Stash) { Move-Item -LiteralPath $script:Stash -Destination $script:Marker -Force }
        foreach ($path in $script:Made) { Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction SilentlyContinue }
    }

    It 'sandboxes the first run on a machine' {
        # A wrong click has to cost nothing while someone is still finding out what the buttons do.
        $mode = Get-ProfileSetupMode
        $script:Made.Add($mode.InstallPath)

        $mode.Real | Should -BeFalse
        $mode.Reason | Should -Match 'first run'
        $mode.InstallPath | Should -Not -BeNullOrEmpty
        Test-Path -LiteralPath $mode.InstallPath | Should -BeTrue
    }

    It 'installs for real once the marker exists' {
        Set-ProfileSetupSeen -Confirm:$false

        $mode = Get-ProfileSetupMode

        $mode.Real | Should -BeTrue
        $mode.Reason | Should -Match 'run this before'
        $mode.InstallPath | Should -BeNullOrEmpty -Because 'an empty path means the defaults apply'
    }

    It 'lets -Real override a first run' {
        $mode = Get-ProfileSetupMode -Real

        $mode.Real | Should -BeTrue
        $mode.Reason | Should -Match 'asked for it'
    }

    It 'lets -Sandbox override a machine that has run it before' {
        Set-ProfileSetupSeen -Confirm:$false

        $mode = Get-ProfileSetupMode -Sandbox
        $script:Made.Add($mode.InstallPath)

        $mode.Real | Should -BeFalse
        $mode.Reason | Should -Match 'asked for it'
    }

    It 'refuses both at once' {
        { Get-ProfileSetupMode -Real -Sandbox } | Should -Throw '*not both*'
    }

    It 'gives each sandbox run its own directory' {
        $first = Get-ProfileSetupMode
        $script:Made.Add($first.InstallPath)

        $second = Get-ProfileSetupMode
        $script:Made.Add($second.InstallPath)

        $second.InstallPath | Should -Not -BeExactly $first.InstallPath
    }

    It 'puts the receipt inside the sandbox' {
        # A sandbox run that wrote to the real receipt would tell the next real run it owns things
        # it never installed.
        $mode = Get-ProfileSetupMode
        $script:Made.Add($mode.InstallPath)

        $mode.ReceiptPath | Should -BeLike "$($mode.InstallPath)*"
        $mode.ReceiptPath | Should -Not -BeExactly (Get-ProfileSetupPath).Receipt
    }
}

Describe 'Set-ProfileSetupSeen' {

    BeforeEach {
        $script:Marker = Get-ProfileSetupMarkerPath
        $script:Stash = "$script:Marker.testing"
        if (Test-Path -LiteralPath $script:Marker) { Move-Item -LiteralPath $script:Marker -Destination $script:Stash -Force }
    }

    AfterEach {
        Remove-Item -LiteralPath $script:Marker -Force -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $script:Stash) { Move-Item -LiteralPath $script:Stash -Destination $script:Marker -Force }
    }

    It 'writes the marker and the directory holding it' {
        Set-ProfileSetupSeen -Repository 'C:\somewhere' -Confirm:$false

        Test-Path -LiteralPath $script:Marker | Should -BeTrue
        (Get-Content -LiteralPath $script:Marker -Raw | ConvertFrom-Json).Repository | Should -BeExactly 'C:\somewhere'
    }

    It 'keeps the first run date when called again' {
        Set-ProfileSetupSeen -Repository 'first' -Confirm:$false
        $first = Get-Content -LiteralPath $script:Marker -Raw

        Set-ProfileSetupSeen -Repository 'second' -Confirm:$false

        Get-Content -LiteralPath $script:Marker -Raw | Should -BeExactly $first
    }

    It 'lives beside the receipt, not in the repository' {
        # A fresh clone on a machine that has used the picker must not start over in the sandbox,
        # and a clone carried to a new machine must.
        Split-Path -Parent (Get-ProfileSetupMarkerPath) |
            Should -BeExactly (Split-Path -Parent (Get-ProfileSetupPath).Receipt)

        Get-ProfileSetupMarkerPath | Should -BeLike "$env:LOCALAPPDATA*"
    }

    It 'writes nothing under -WhatIf' {
        Set-ProfileSetupSeen -WhatIf

        Test-Path -LiteralPath $script:Marker | Should -BeFalse
    }
}

Describe 'The built installer carries the mode decision' {

    BeforeAll {
        $script:Built = Get-Content -LiteralPath (Join-Path $script:Root 'build/profileutil.ps1') -Raw
        $script:Wrapper = Get-Content -LiteralPath (Join-Path $script:Root 'try-local.ps1') -Raw
    }

    It 'decides the mode in the installer' {
        # The behaviour belongs to the thing people actually run, not to a local helper script.
        $script:Built | Should -Match 'Get-ProfileSetupMode'
        $script:Built | Should -Match 'Set-ProfileSetupSeen'
    }

    It 'accepts -Real and -Sandbox' {
        $script:Built | Should -Match '\[switch\]\$Real'
        $script:Built | Should -Match '\[switch\]\$Sandbox'
    }

    It 'leaves the local wrapper with no decision of its own' {
        # try-local.ps1 exists only because the built file downloads a repository and a checkout is
        # already here. Anything else it decided would be behaviour a real user never gets.
        $script:Wrapper | Should -Not -Match 'first run on this machine'
        $script:Wrapper | Should -Match 'Get-ProfileSetupMode'
    }
}
