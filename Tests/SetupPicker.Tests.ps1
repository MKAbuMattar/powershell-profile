#Requires -Version 7.0
<#
.SYNOPSIS
    Checks the console picker's ordering, rendering and selection parsing.

.DESCRIPTION
    Show-ProfileSetup itself reads keystrokes and cannot be asserted, so the three parts that
    decide what happens are separate functions and those are what the tests drive.

    The one that matters most is ordering. The menu numbers rows by position and a typed number is
    turned back into a row by index, so if the two see different orders then typing 1 installs
    something other than the first line on screen, and nothing about that failure is visible.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    Import-Module -Name (Join-Path $script:Root 'Module/Setup/Setup.psd1') -Force -DisableNameChecking

    function New-Row {
        <#
        .SYNOPSIS
            Builds a state row for the picker to render.
        #>
        param(
            [Parameter(Mandatory)][string]$Id,
            [Parameter(Mandatory)][string]$Category,
            [switch]$Present,
            [switch]$Owned,
            [switch]$Required
        )

        [PSCustomObject]@{
            Id = $Id; Name = $Id; Category = $Category
            Description = "Description of $Id."
            Required = [bool]$Required
            Kind = 'File'
            Present = [bool]$Present
            Owned = [bool]$Owned
            InstalledOn = $null
            Replaced = $null
            Removable = ([bool]$Present -and [bool]$Owned -and -not $Required)
        }
    }
}

Describe 'Get-ProfileSetupMenuOrder' {

    It 'puts Core first and System last' {
        $rows = @(
            New-Row -Id 'f' -Category 'Font'
            New-Row -Id 's' -Category 'System'
            New-Row -Id 'c' -Category 'Core'
            New-Row -Id 't' -Category 'Tool'
        )

        $sorted = Get-ProfileSetupMenuOrder -State $rows

        $sorted[0].Category | Should -BeExactly 'Core'
        $sorted[-1].Category | Should -BeExactly 'System'
    }

    It 'keeps catalog order within a category' {
        # The tools are listed in the order someone installs them, not alphabetically, so a stable
        # sort has to leave that alone.
        $rows = @(
            New-Row -Id 'starship' -Category 'Tool'
            New-Row -Id 'zoxide' -Category 'Tool'
            New-Row -Id 'fzf' -Category 'Tool'
        )

        @(Get-ProfileSetupMenuOrder -State $rows | ForEach-Object { $_.Id }) | Should -Be @('starship', 'zoxide', 'fzf')
    }

    It 'returns every row it was given' {
        $rows = @(Get-ProfileSetupState)
        @(Get-ProfileSetupMenuOrder -State $rows).Count | Should -Be $rows.Count
    }

    It 'handles an empty list' {
        @(Get-ProfileSetupMenuOrder -State @()).Count | Should -Be 0
    }
}

Describe 'Format-ProfileSetupMenu' {

    It 'numbers rows from one, in the order it was given' {
        $rows = @(
            New-Row -Id 'first' -Category 'Core'
            New-Row -Id 'second' -Category 'Core'
        )

        $lines = Format-ProfileSetupMenu -State $rows -Plain

        ($lines -join "`n") | Should -Match '1\. \[.\] first'
        ($lines -join "`n") | Should -Match '2\. \[.\] second'
    }

    It 'marks an owned and present unit with x' {
        $lines = Format-ProfileSetupMenu -State @(New-Row -Id 'a' -Category 'Tool' -Present -Owned) -Plain
        ($lines -join "`n") | Should -Match '\[x\] a'
    }

    It 'marks a present unit someone else installed with =' {
        # The distinction the whole design rests on, so it has to be visible on the line.
        $lines = Format-ProfileSetupMenu -State @(New-Row -Id 'a' -Category 'Tool' -Present) -Plain
        ($lines -join "`n") | Should -Match '\[=\] a'
        ($lines -join "`n") | Should -Match 'already on this machine'
    }

    It 'marks an absent unit with a blank box' {
        $lines = Format-ProfileSetupMenu -State @(New-Row -Id 'a' -Category 'Tool') -Plain
        ($lines -join "`n") | Should -Match '\[ \] a'
    }

    It 'marks a unit that is recorded but gone with a bang' {
        $lines = Format-ProfileSetupMenu -State @(New-Row -Id 'a' -Category 'Tool' -Owned) -Plain
        ($lines -join "`n") | Should -Match '\[!\] a'
        ($lines -join "`n") | Should -Match 'recorded, but missing'
    }

    It 'writes a category heading once per run of rows' {
        $rows = @(
            New-Row -Id 'a' -Category 'Core'
            New-Row -Id 'b' -Category 'Core'
            New-Row -Id 'c' -Category 'Tool'
        )

        $lines = @(Format-ProfileSetupMenu -State $rows -Plain)

        @($lines | Where-Object { $_ -eq 'CORE' }).Count | Should -Be 1
        @($lines | Where-Object { $_ -eq 'TOOL' }).Count | Should -Be 1
    }

    It 'shows the description under each unit' {
        $lines = Format-ProfileSetupMenu -State @(New-Row -Id 'a' -Category 'Tool') -Plain
        ($lines -join "`n") | Should -Match 'Description of a\.'
    }

    It 'handles an empty list' {
        @(Format-ProfileSetupMenu -State @() -Plain).Count | Should -Be 0
    }
}

Describe 'Resolve-ProfileSetupSelection' {

    BeforeAll {
        $script:Rows = @(
            New-Row -Id 'one' -Category 'Core'
            New-Row -Id 'two' -Category 'Core'
            New-Row -Id 'three' -Category 'Tool'
            New-Row -Id 'four' -Category 'Tool'
            New-Row -Id 'five' -Category 'Font'
        )
    }

    It 'resolves a single number to the row at that position' {
        (Resolve-ProfileSetupSelection -InputText '1' -State $script:Rows).Id | Should -Be @('one')
        (Resolve-ProfileSetupSelection -InputText '5' -State $script:Rows).Id | Should -Be @('five')
    }

    It 'resolves several numbers, separated by spaces or commas' {
        (Resolve-ProfileSetupSelection -InputText '1 3' -State $script:Rows).Id | Should -Be @('one', 'three')
        (Resolve-ProfileSetupSelection -InputText '1,3' -State $script:Rows).Id | Should -Be @('one', 'three')
    }

    It 'resolves a range' {
        (Resolve-ProfileSetupSelection -InputText '2-4' -State $script:Rows).Id | Should -Be @('two', 'three', 'four')
    }

    It 'accepts a range written backwards' {
        (Resolve-ProfileSetupSelection -InputText '4-2' -State $script:Rows).Id | Should -Be @('two', 'three', 'four')
    }

    It 'resolves an id' {
        (Resolve-ProfileSetupSelection -InputText 'three' -State $script:Rows).Id | Should -Be @('three')
    }

    It 'resolves a category to every row in it' {
        (Resolve-ProfileSetupSelection -InputText 'Tool' -State $script:Rows).Id | Should -Be @('three', 'four')
    }

    It 'resolves all to everything' {
        (Resolve-ProfileSetupSelection -InputText 'all' -State $script:Rows).Id.Count | Should -Be 5
    }

    It 'resolves none to nothing, whatever else was typed' {
        # Someone changing their mind mid-line should get nothing, not a partial install.
        (Resolve-ProfileSetupSelection -InputText '1 2 none' -State $script:Rows).Id.Count | Should -Be 0
    }

    It 'returns nothing for empty input' {
        (Resolve-ProfileSetupSelection -InputText '' -State $script:Rows).Id.Count | Should -Be 0
        (Resolve-ProfileSetupSelection -InputText '   ' -State $script:Rows).Id.Count | Should -Be 0
        (Resolve-ProfileSetupSelection -InputText $null -State $script:Rows).Id.Count | Should -Be 0
    }

    It 'does not repeat a row selected twice' {
        (Resolve-ProfileSetupSelection -InputText '1 1 one' -State $script:Rows).Id | Should -Be @('one')
    }

    It 'reports a word it did not understand rather than throwing' {
        # Ending the session over one typo would make the picker worse than editing the config.
        $result = Resolve-ProfileSetupSelection -InputText '1 nonsense 3' -State $script:Rows

        $result.Id | Should -Be @('one', 'three')
        $result.Unknown | Should -Be @('nonsense')
    }

    It 'reports a number outside the menu' {
        $result = Resolve-ProfileSetupSelection -InputText '99' -State $script:Rows

        $result.Id.Count | Should -Be 0
        $result.Unknown | Should -Be @('99')
    }

    It 'reports a range entirely outside the menu' {
        $result = Resolve-ProfileSetupSelection -InputText '90-99' -State $script:Rows

        $result.Id.Count | Should -Be 0
        $result.Unknown | Should -Be @('90-99')
    }

    It 'keeps the part of a range that is in the menu' {
        (Resolve-ProfileSetupSelection -InputText '4-99' -State $script:Rows).Id | Should -Be @('four', 'five')
    }
}

Describe 'The menu and the selection agree' {

    It 'resolves each number to the unit printed on that line' {
        # Drives the real catalog rather than fixtures, because this is the pairing that breaks
        # when a category is added or the sort order is changed.
        $state = Get-ProfileSetupMenuOrder -State (Get-ProfileSetupState)
        $lines = @(Format-ProfileSetupMenu -State $state -Plain)

        for ($n = 1; $n -le $state.Count; $n++) {
            $expected = $state[$n - 1]

            $resolved = Resolve-ProfileSetupSelection -InputText "$n" -State $state
            $resolved.Id | Should -Be @($expected.Id) -Because "typing $n must select the unit shown on line $n"

            $printed = $lines | Where-Object { $_ -match ('^\s*{0}\. ' -f $n) } | Select-Object -First 1
            $printed | Should -Match ([regex]::Escape($expected.Name))
        }
    }
}
