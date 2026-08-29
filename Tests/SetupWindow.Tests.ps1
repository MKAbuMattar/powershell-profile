#Requires -Version 7.0
<#
.SYNOPSIS
    Checks the parts of the setup window that can be checked without opening one.

.DESCRIPTION
    Show-ProfileSetupWindow blocks on ShowDialog and cannot be asserted, so the window is built
    from three things that can be: a support probe, a layout string, and a row shaper. Those are
    what these tests drive.

    The layout tests matter more than they look. Show-ProfileSetupWindow finds every control by
    name, so a renamed or deleted x:Name is a runtime failure that appears only when someone opens
    the window. Asserting the names against the same list the code looks up turns that into a
    test failure.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    Import-Module -Name (Join-Path $script:Root 'Module/Setup/Setup.psd1') -Force -DisableNameChecking

    # The controls Show-ProfileSetupWindow looks up. Keep in step with the list in Window.ps1.
    $script:RequiredControls = @(
        'TargetText', 'UnitGrid', 'InstallButton', 'RemoveButton',
        'SelectMissingButton', 'ClearButton', 'RefreshButton', 'CloseButton', 'LogBox'
    )

    function New-Row {
        <#
        .SYNOPSIS
            Builds a state row for the window to shape.
        #>
        param(
            [Parameter(Mandatory)][string]$Id,
            [switch]$Present,
            [switch]$Owned,
            [switch]$Required
        )

        [PSCustomObject]@{
            Id = $Id; Name = $Id; Category = 'Tool'
            Description = "Description of $Id."
            Required = [bool]$Required
            Kind = 'Package'
            Present = [bool]$Present
            Owned = [bool]$Owned
            InstalledOn = $null
            Replaced = $null
            Removable = ([bool]$Present -and [bool]$Owned -and -not $Required)
        }
    }
}

Describe 'Get-ProfileSetupWindowSupport' {

    It 'reports a result with a reason when it says no' {
        $support = Get-ProfileSetupWindowSupport

        $support.Supported | Should -BeOfType [bool]
        if (-not $support.Supported) {
            $support.Reason | Should -Not -BeNullOrEmpty
            $support.Reason | Should -Match 'Show-ProfileSetup'
        }
    }

    It 'says WPF is available on a Windows STA host' {
        # PowerShell 7 on Windows starts STA, which is why this module does not have to relaunch
        # itself the way winutil does. If that ever changes, this test is where it shows up.
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'not running on Windows'
            return
        }
        if ([Threading.Thread]::CurrentThread.GetApartmentState() -ne 'STA') {
            Set-ItResult -Skipped -Because 'this host is MTA'
            return
        }

        (Get-ProfileSetupWindowSupport).Supported | Should -BeTrue
    }
}

Describe 'Get-ProfileSetupWindowXaml' {

    BeforeAll {
        $script:Xaml = [xml](Get-ProfileSetupWindowXaml)
        $script:Names = @(
            $script:Xaml.SelectNodes("//*[@*[local-name()='Name']]") |
                ForEach-Object { $_.GetAttribute('Name', 'http://schemas.microsoft.com/winfx/2006/xaml') }
        )
    }

    It 'is well-formed XML' {
        $script:Xaml.DocumentElement.LocalName | Should -BeExactly 'Window'
    }

    It 'names every control the code looks up' {
        # A renamed x:Name would otherwise fail only when someone opens the window.
        foreach ($name in $script:RequiredControls) {
            $script:Names | Should -Contain $name
        }
    }

    It 'binds the grid columns to properties the row shaper produces' {
        $shaped = @(ConvertTo-ProfileSetupRow -State @(New-Row -Id 'a'))[0]
        $bound = @(
            $script:Xaml.SelectNodes('//*[@Binding]') |
                ForEach-Object { $_.GetAttribute('Binding') } |
                ForEach-Object { if ($_ -match '\{Binding\s+([A-Za-z]+)') { $Matches[1] } }
        )

        $bound.Count | Should -BeGreaterThan 0
        foreach ($property in $bound) {
            $shaped.PSObject.Properties.Name | Should -Contain $property
        }
    }

    It 'loads as a real window with every control resolvable' {
        if (-not (Get-ProfileSetupWindowSupport).Supported) {
            Set-ItResult -Skipped -Because 'this host cannot show a window'
            return
        }

        Add-Type -AssemblyName PresentationFramework
        $reader = [System.Xml.XmlNodeReader]::new([xml](Get-ProfileSetupWindowXaml))
        $window = [Windows.Markup.XamlReader]::Load($reader)

        try {
            $window | Should -Not -BeNullOrEmpty
            foreach ($name in $script:RequiredControls) {
                $window.FindName($name) | Should -Not -BeNullOrEmpty -Because "the window has no control named $name"
            }
        }
        finally {
            $window.Close()
        }
    }
}

Describe 'ConvertTo-ProfileSetupRow' {

    It 'starts every box unticked' {
        # A window that opens with boxes already ticked invites someone to press Install without
        # reading the list.
        $rows = @(ConvertTo-ProfileSetupRow -State (Get-ProfileSetupState))

        @($rows | Where-Object { $_.Selected }).Count | Should -Be 0
    }

    It 'describes <Expected> for the matching state' -ForEach @(
        @{ Expected = 'installed by setup'; Present = $true; Owned = $true; Required = $false }
        @{ Expected = 'recorded, but missing'; Present = $false; Owned = $true; Required = $false }
        @{ Expected = 'already yours'; Present = $true; Owned = $false; Required = $false }
        @{ Expected = 'present, required'; Present = $true; Owned = $false; Required = $true }
        @{ Expected = 'not installed'; Present = $false; Owned = $false; Required = $false }
    ) {
        $row = New-Row -Id 'a' -Present:$Present -Owned:$Owned -Required:$Required
        $shaped = @(ConvertTo-ProfileSetupRow -State @($row))[0]

        $shaped.StateText | Should -BeExactly $Expected
    }

    It 'tells the user which rows are theirs and which are ours' {
        # The window has to carry the same distinction the console picker prints, or someone will
        # tick a tool they installed years ago and expect Remove to take it.
        $mine = @(ConvertTo-ProfileSetupRow -State @(New-Row -Id 'a' -Present))[0]
        $ours = @(ConvertTo-ProfileSetupRow -State @(New-Row -Id 'b' -Present -Owned))[0]

        $mine.StateText | Should -BeExactly 'already yours'
        $mine.Removable | Should -BeFalse

        $ours.StateText | Should -BeExactly 'installed by setup'
        $ours.Removable | Should -BeTrue
    }

    It 'carries every row through' {
        $state = @(Get-ProfileSetupState)
        @(ConvertTo-ProfileSetupRow -State $state).Count | Should -Be $state.Count
    }

    It 'handles an empty list' {
        @(ConvertTo-ProfileSetupRow -State @()).Count | Should -Be 0
    }
}
