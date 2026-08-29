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
        'TitleBar', 'MinimiseButton', 'MaximiseButton', 'ChromeCloseButton',
        'TargetText', 'Tabs', 'ToolGrid', 'ProfileGrid', 'ConfigGrid',
        'InstallButton', 'RemoveButton', 'SaveConfigButton', 'SelectMissingButton',
        'ClearButton', 'RefreshButton', 'CloseButton', 'LogBox'
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

    It 'binds the <Grid> columns to properties its rows actually have' -ForEach @(
        @{ Grid = 'ToolGrid'; Source = 'unit' }
        @{ Grid = 'ProfileGrid'; Source = 'unit' }
        @{ Grid = 'ConfigGrid'; Source = 'config' }
    ) {
        # A binding to a property the rows do not carry renders an empty column and says nothing
        # about why, so each grid is checked against the shape that feeds it.
        $available = if ($Source -eq 'unit') {
            @(ConvertTo-ProfileSetupRow -State @(New-Row -Id 'a'))[0].PSObject.Properties.Name
        }
        else {
            @('Key', 'Name', 'Enabled', 'Installed', 'Description')
        }

        $node = $script:Xaml.SelectNodes('//*[local-name()="DataGrid"]') |
            Where-Object { $_.GetAttribute('Name', 'http://schemas.microsoft.com/winfx/2006/xaml') -eq $Grid }

        $node | Should -Not -BeNullOrEmpty

        $bound = @(
            [regex]::Matches($node.InnerXml, '\{Binding\s+([A-Za-z]+)') |
                ForEach-Object { $_.Groups[1].Value } |
                Sort-Object -Unique
        )

        $bound.Count | Should -BeGreaterThan 0
        foreach ($property in $bound) {
            $available | Should -Contain $property -Because "$Grid binds to $property"
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

Describe 'The window handlers do not depend on name resolution' {

    BeforeAll {
        $script:WindowSource = Get-Content -LiteralPath (Join-Path $script:Root 'Module/Setup/Window.ps1') -Raw

        # Only the wiring block matters. Above it are the function definitions and their
        # comment-based help, which name these commands legitimately.
        $start = $script:WindowSource.IndexOf('$reader = [System.Xml.XmlNodeReader]')
        $script:Wiring = $script:WindowSource.Substring($start)
    }

    It 'resolves every command it calls before building the closures' {
        # A closure looks a command up by name when it runs, against whatever session state it was
        # bound to, and that state depends on how the file was loaded: module, dot-sourced, or
        # piped into Invoke-Expression. Get it wrong and every handler fails with "the term is not
        # recognized" while the window still opens, so it reads as a window that loaded nothing.
        #
        # Resolving up front and calling through the captured CommandInfo removes the dependency.
        foreach ($name in 'Get-ProfileSetupState', 'Get-ProfileSetupMenuOrder', 'ConvertTo-ProfileSetupRow', 'Invoke-ProfileSetup', 'Uninstall-ProfileSetup', 'Get-ProfileConfigState', 'Set-ProfileConfigEntry') {
            $script:WindowSource | Should -Match ([regex]::Escape("'$name'")) -Because "$name must be resolved into the command table"
        }
    }

    It 'never calls <Name> by bare name inside a handler' -ForEach @(
        @{ Name = 'Get-ProfileSetupState' }
        @{ Name = 'Get-ProfileSetupMenuOrder' }
        @{ Name = 'ConvertTo-ProfileSetupRow' }
        @{ Name = 'Invoke-ProfileSetup' }
        @{ Name = 'Uninstall-ProfileSetup' }
        @{ Name = 'Get-ProfileConfigState' }
        @{ Name = 'Set-ProfileConfigEntry' }
    ) {
        # Matches the command name used as a command, rather than quoted in the lookup table.
        $bare = [regex]::Matches($script:Wiring, "(?<![\w'`"-])$([regex]::Escape($Name))(?![\w'`"-])")

        @($bare).Count | Should -Be 0 -Because "$Name is called by name in the wiring, which breaks when the closure's session state differs"
    }

    It 'reports a handler failure into the log pane instead of losing it' {
        # An exception raised on the WPF dispatcher disappears: the button appears to do nothing.
        $script:WindowSource | Should -Match '\$guard'
        $script:WindowSource | Should -Match 'failed: \{1\}'
    }

    It 'says so when the list comes back empty' {
        $script:WindowSource | Should -Match 'came back empty'
    }
}

Describe 'The window has a tab per job' {

    BeforeAll {
        $script:TabXaml = [xml](Get-ProfileSetupWindowXaml)
    }

    It 'carries three tabs, named for what each one does' {
        $headers = @(
            $script:TabXaml.SelectNodes('//*[local-name()="TabItem"]') |
                ForEach-Object { $_.GetAttribute('Header') }
        )

        $headers | Should -Be @('Tools', 'Profile', 'What loads')
    }

    It 'gives each tab its own grid' {
        # One grid per tab, so Install acts on what the person is looking at rather than on a
        # single list they have to scroll.
        foreach ($name in 'ToolGrid', 'ProfileGrid', 'ConfigGrid') {
            $script:RequiredControls | Should -Contain $name
        }
    }

    It 'binds the What loads grid to Enabled, not Selected' {
        # That tab writes profile.config.psd1 rather than installing anything, so its tick is the
        # entry's own on and off rather than a selection to act on.
        $configGrid = $script:TabXaml.SelectNodes('//*[local-name()="DataGrid"]') |
            Where-Object { $_.GetAttribute('Name', 'http://schemas.microsoft.com/winfx/2006/xaml') -eq 'ConfigGrid' }

        $configGrid | Should -Not -BeNullOrEmpty
        $configGrid.InnerXml | Should -Match 'Binding Enabled, Mode=TwoWay'
    }
}

Describe 'The window draws its own title bar' {

    BeforeAll {
        $script:ChromeXaml = Get-ProfileSetupWindowXaml
    }

    It 'turns the system title bar off' {
        $script:ChromeXaml | Should -Match 'WindowStyle="None"'
    }

    It 'stays resizable without the system frame' {
        $script:ChromeXaml | Should -Match 'ResizeMode="CanResize"'
    }

    It 'provides the three buttons the system one would have' {
        foreach ($name in 'MinimiseButton', 'MaximiseButton', 'ChromeCloseButton') {
            $script:ChromeXaml | Should -Match ('x:Name="{0}"' -f $name)
        }
    }

    It 'wires the drag and the double-click itself' {
        # WindowStyle None removes the system behaviour along with the system chrome, so moving
        # and maximising the window have to be handled.
        $source = Get-Content -LiteralPath (Join-Path $script:Root 'Module/Setup/Window.ps1') -Raw

        $source | Should -Match 'DragMove'
        $source | Should -Match 'ClickCount -eq 2'
    }

    It 'colours the close button with the brand tertiary' {
        # The only coloured thing in the strip, so the destructive button reads as one.
        $brand = Get-ProfileSetupBrand -Mode Night
        $script:ChromeXaml | Should -Match 'CloseChromeButton'
        $script:ChromeXaml | Should -Match ([regex]::Escape('#FF' + $brand.Hex.Tertiary.TrimStart('#')))
    }
}
