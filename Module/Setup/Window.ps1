#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup window
#
# Dot-sourced by Setup.psm1.
#
# The same picker as Picker.ps1, drawn in WPF. It binds to Get-ProfileSetupState and calls
# Invoke-ProfileSetup or Uninstall-ProfileSetup, so the window decides nothing.
#
# That split is not tidiness. A window cannot be asserted by the Pester suite, so anything it
# decided would be untested. What it holds is layout and event wiring; what it does comes from
# functions the console picker uses too and the suite already covers.
#
# On apartment state: PowerShell 7 on Windows starts STA, so WPF works even when this file arrives
# through `irm ... | iex`. winutil relaunches itself into powershell.exe -STA to get that; this
# does not have to. Get-ProfileSetupWindowSupport reports the case where it would fail anyway,
# which is a host that is not Windows or has no desktop.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileSetupWindowSupport {
    <#
    .SYNOPSIS
        Reports whether a window can be shown here, and why not when it cannot.

    .DESCRIPTION
        Checked before any assembly is loaded, so a headless or non-Windows host gets a sentence
        telling it to use Show-ProfileSetup instead of a type-loading exception.

    .OUTPUTS
        [PSCustomObject] Supported, and Reason when it is not.

    .EXAMPLE
        Get-ProfileSetupWindowSupport

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    if (-not $IsWindows) {
        return [PSCustomObject]@{ Supported = $false; Reason = 'WPF is Windows only. Use Show-ProfileSetup instead.' }
    }

    if ([Threading.Thread]::CurrentThread.GetApartmentState() -ne 'STA') {
        return [PSCustomObject]@{
            Supported = $false
            Reason    = 'This host runs MTA and WPF needs STA. Start pwsh with -sta, or use Show-ProfileSetup instead.'
        }
    }

    try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
        Add-Type -AssemblyName PresentationCore -ErrorAction Stop
        Add-Type -AssemblyName WindowsBase -ErrorAction Stop
    }
    catch {
        return [PSCustomObject]@{ Supported = $false; Reason = "WPF did not load: $($_.Exception.Message)" }
    }

    return [PSCustomObject]@{ Supported = $true; Reason = '' }
}

function Get-ProfileSetupWindowXaml {
    <#
    .SYNOPSIS
        Returns the window layout.

    .DESCRIPTION
        Kept as a function returning a string so a test can parse it without opening a window, and
        so the layout is one thing to read rather than a string spliced through the code that
        wires it up.

        Every control the code reaches for is named here. Show-ProfileSetupWindow looks each one
        up by name and fails loudly if the two ever disagree.

    .OUTPUTS
        [string] The XAML.

    .EXAMPLE
        [xml](Get-ProfileSetupWindowXaml)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PowerShell profile setup"
        Height="660" Width="920"
        WindowStartupLocation="CenterScreen"
        Background="#FF2B2233">

    <Window.Resources>
        <!-- The night palette from https://mkabumattar.com/identity/. Get-ProfileSetupBrand holds
             the same values for the console picker, so the two surfaces cannot drift apart. -->
        <SolidColorBrush x:Key="Ground"    Color="#FF2B2233"/>
        <SolidColorBrush x:Key="Surface"   Color="#FF352B3E"/>
        <SolidColorBrush x:Key="Line"      Color="#FF4A3F53"/>
        <SolidColorBrush x:Key="Heading"   Color="#FFEAE6DB"/>
        <SolidColorBrush x:Key="Body"      Color="#FFD9C9B0"/>
        <SolidColorBrush x:Key="Accent"    Color="#FFD9A36A"/>
        <SolidColorBrush x:Key="Secondary" Color="#FFB9875E"/>

        <!-- Archivo, Public Sans and JetBrains Mono are the identity's three faces. Each names a
             fallback, because WPF drops to a serif when a family is missing and that reads as a
             rendering bug rather than a font that is not installed. -->
        <Style TargetType="TextBlock">
            <Setter Property="Foreground" Value="{StaticResource Body}"/>
            <Setter Property="FontFamily" Value="Public Sans, Segoe UI"/>
        </Style>

        <Style x:Key="DisplayText" TargetType="TextBlock">
            <Setter Property="Foreground" Value="{StaticResource Heading}"/>
            <Setter Property="FontFamily" Value="Archivo, Segoe UI"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
        </Style>

        <Style TargetType="Button">
            <Setter Property="Padding" Value="16,7"/>
            <Setter Property="Margin" Value="0,0,8,0"/>
            <Setter Property="FontFamily" Value="Public Sans, Segoe UI"/>
            <Setter Property="Foreground" Value="{StaticResource Heading}"/>
            <Setter Property="Background" Value="{StaticResource Surface}"/>
            <Setter Property="BorderBrush" Value="{StaticResource Line}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Chrome"
                                Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"
                                              Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Chrome" Property="BorderBrush" Value="{StaticResource Accent}"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="Chrome" Property="Background" Value="{StaticResource Line}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Foreground" Value="{StaticResource Ground}"/>
            <Setter Property="Background" Value="{StaticResource Accent}"/>
            <Setter Property="BorderBrush" Value="{StaticResource Accent}"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
        </Style>
    </Window.Resources>

    <Grid Margin="18">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="170"/>
        </Grid.RowDefinitions>

        <StackPanel Grid.Row="0" Margin="0,0,0,14">
            <TextBlock Text="PowerShell profile setup" FontSize="22" Style="{StaticResource DisplayText}"/>
            <TextBlock x:Name="TargetText" FontSize="12" Foreground="{StaticResource Secondary}" Margin="0,5,0,0"
                       FontFamily="JetBrains Mono, Cascadia Mono, Consolas"/>
            <TextBlock FontSize="12" Margin="0,8,0,0"
                       Text="Only what this installer added can be removed. Anything already on your machine is left alone."/>
        </StackPanel>

        <Border Grid.Row="1" BorderBrush="{StaticResource Line}" BorderThickness="1" Background="{StaticResource Surface}">
            <DataGrid x:Name="UnitGrid"
                      AutoGenerateColumns="False"
                      HeadersVisibility="Column"
                      GridLinesVisibility="Horizontal"
                      HorizontalGridLinesBrush="{StaticResource Line}"
                      Background="{StaticResource Surface}"
                      RowBackground="{StaticResource Surface}"
                      AlternatingRowBackground="{StaticResource Ground}"
                      Foreground="{StaticResource Body}"
                      BorderThickness="0"
                      FontFamily="Public Sans, Segoe UI"
                      CanUserAddRows="False"
                      CanUserDeleteRows="False"
                      SelectionMode="Single">
                <DataGrid.ColumnHeaderStyle>
                    <Style TargetType="DataGridColumnHeader">
                        <Setter Property="Background" Value="{StaticResource Ground}"/>
                        <Setter Property="Foreground" Value="{StaticResource Heading}"/>
                        <Setter Property="FontFamily" Value="Archivo, Segoe UI"/>
                        <Setter Property="FontWeight" Value="SemiBold"/>
                        <Setter Property="Padding" Value="10,7"/>
                        <Setter Property="BorderBrush" Value="{StaticResource Line}"/>
                        <Setter Property="BorderThickness" Value="0,0,0,1"/>
                    </Style>
                </DataGrid.ColumnHeaderStyle>
                <DataGrid.CellStyle>
                    <Style TargetType="DataGridCell">
                        <Setter Property="BorderThickness" Value="0"/>
                        <Setter Property="Padding" Value="6,5"/>
                        <Style.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter Property="Background" Value="{StaticResource Line}"/>
                                <Setter Property="Foreground" Value="{StaticResource Heading}"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.CellStyle>
                <DataGrid.Columns>
                    <DataGridCheckBoxColumn Header="" Binding="{Binding Selected, Mode=TwoWay}" Width="36"/>
                    <DataGridTextColumn Header="Name" Binding="{Binding Name}" IsReadOnly="True" Width="200"/>
                    <DataGridTextColumn Header="Group" Binding="{Binding Category}" IsReadOnly="True" Width="80"/>
                    <DataGridTextColumn Header="State" Binding="{Binding StateText}" IsReadOnly="True" Width="150"/>
                    <DataGridTextColumn Header="What it is" Binding="{Binding Description}" IsReadOnly="True" Width="*"/>
                </DataGrid.Columns>
            </DataGrid>
        </Border>

        <StackPanel Grid.Row="2" Orientation="Horizontal" Margin="0,14,0,14">
            <Button x:Name="InstallButton" Content="Install selected" Style="{StaticResource PrimaryButton}"/>
            <Button x:Name="RemoveButton" Content="Remove selected"/>
            <Button x:Name="SelectMissingButton" Content="Tick everything missing"/>
            <Button x:Name="ClearButton" Content="Clear"/>
            <Button x:Name="RefreshButton" Content="Refresh"/>
            <Button x:Name="CloseButton" Content="Close"/>
        </StackPanel>

        <Border Grid.Row="3" BorderBrush="{StaticResource Line}" BorderThickness="1" Background="#FF241D2B">
            <ScrollViewer x:Name="LogScroller" VerticalScrollBarVisibility="Auto">
                <TextBox x:Name="LogBox"
                         Background="Transparent"
                         Foreground="{StaticResource Body}"
                         BorderThickness="0"
                         Padding="10,8"
                         FontFamily="JetBrains Mono, Cascadia Mono, Consolas"
                         FontSize="12"
                         IsReadOnly="True"
                         TextWrapping="Wrap"
                         VerticalScrollBarVisibility="Disabled"/>
            </ScrollViewer>
        </Border>
    </Grid>
</Window>
'@
}

function ConvertTo-ProfileSetupRow {
    <#
    .SYNOPSIS
        Turns state rows into the shape the grid binds to.

    .DESCRIPTION
        The grid needs a settable Selected and a readable StateText. Building them here rather than
        in the event handlers keeps the window free of any judgement about what a unit is, and lets
        a test check the wording without opening a window.

        Selected starts ticked for nothing. A window that arrives with boxes already ticked invites
        someone to press Install without reading the list.

    .PARAMETER State
        Rows from Get-ProfileSetupState.

    .OUTPUTS
        [PSCustomObject[]] Id, Name, Category, Description, StateText, Selected, Present, Owned,
        Required, Removable.

    .EXAMPLE
        ConvertTo-ProfileSetupRow -State (Get-ProfileSetupState)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$State
    )

    foreach ($row in $State) {
        $text = if ($row.Owned -and $row.Present) { 'installed by setup' }
        elseif ($row.Owned) { 'recorded, but missing' }
        elseif ($row.Present -and $row.Required) { 'present, required' }
        elseif ($row.Present) { 'already yours' }
        else { 'not installed' }

        [PSCustomObject]@{
            Id          = $row.Id
            Name        = $row.Name
            Category    = $row.Category
            Description = $row.Description
            StateText   = $text
            Selected    = $false
            Present     = $row.Present
            Owned       = $row.Owned
            Required    = $row.Required
            Removable   = $row.Removable
        }
    }
}

function Show-ProfileSetupWindow {
    <#
    .SYNOPSIS
        Opens the setup window.

    .DESCRIPTION
        A grid of everything the profile can install, with a tick box, what it is, and whether this
        installer put it there. Install and Remove act on the ticked rows and write their results
        into the log pane.

        Falls back with a sentence rather than an exception on a host that cannot show a window.
        Show-ProfileSetup is the console equivalent and does the same work.

    .PARAMETER Repository
        Root of a checkout or extracted archive, needed for the file and directory units. Defaults
        to the repository this module was loaded from.

    .PARAMETER InstallPath
        Where the Module tree goes. Defaults to the directory holding $PROFILE.

    .PARAMETER PackageManager
        Auto, Winget, Chocolatey or None.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .OUTPUTS
        None.

    .EXAMPLE
        Show-ProfileSetupWindow
        Opens the window.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-setup-gui')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Repository,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [ValidateSet('Auto', 'Winget', 'Chocolatey', 'None')]
        [string]$PackageManager = 'Auto',

        [Parameter()]
        [string]$ReceiptPath
    )

    $support = Get-ProfileSetupWindowSupport
    if (-not $support.Supported) {
        Write-Warning $support.Reason
        return
    }

    # Module/Setup sits two directories below the repository root.
    if (-not $Repository) { $Repository = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }

    $common = @{}
    if ($InstallPath) { $common['InstallPath'] = $InstallPath }
    if ($ReceiptPath) { $common['ReceiptPath'] = $ReceiptPath }

    $reader = [System.Xml.XmlNodeReader]::new([xml](Get-ProfileSetupWindowXaml))
    $window = [Windows.Markup.XamlReader]::Load($reader)

    $control = @{}
    foreach ($name in 'TargetText', 'UnitGrid', 'InstallButton', 'RemoveButton', 'SelectMissingButton', 'ClearButton', 'RefreshButton', 'CloseButton', 'LogBox') {
        $found = $window.FindName($name)
        if (-not $found) { throw "The window layout has no control named '$name'." }
        $control[$name] = $found
    }

    # Resolved here, once, and called through these variables inside the handlers below.
    #
    # A closure looks a command up by name when it runs, against whatever session state it was
    # bound to. That state depends on how this file was loaded: as a module, dot-sourced, or piped
    # into Invoke-Expression from the built installer. Get one of those wrong and every handler
    # fails with "the term is not recognized" while the window still opens, which looks like a
    # window that loaded nothing rather than a scope problem.
    #
    # GetNewClosure captures a variable by value, so a CommandInfo captured now resolves the same
    # way wherever the handler later runs.
    $command = @{}
    foreach ($name in 'Get-ProfileSetupState', 'Get-ProfileSetupMenuOrder', 'ConvertTo-ProfileSetupRow', 'Invoke-ProfileSetup', 'Uninstall-ProfileSetup') {
        $found = Get-Command -Name $name -ErrorAction SilentlyContinue
        if (-not $found) { throw "The setup window needs $name and it is not loaded." }
        $command[$name] = $found
    }

    $control.TargetText.Text = 'Installing into ' + (Get-ProfileSetupPath -InstallPath $InstallPath).InstallPath

    $writeLog = {
        param([string]$Text)

        $control.LogBox.AppendText($Text + [Environment]::NewLine)
        $control.LogBox.ScrollToEnd()
    }.GetNewClosure()

    $refresh = {
        $state = & $command['Get-ProfileSetupState'] @common
        $ordered = & $command['Get-ProfileSetupMenuOrder'] -State $state
        $shaped = & $command['ConvertTo-ProfileSetupRow'] -State $ordered

        $rows = [System.Collections.ObjectModel.ObservableCollection[object]]::new()
        foreach ($row in $shaped) { $rows.Add($row) }

        $control.UnitGrid.ItemsSource = $rows
    }.GetNewClosure()

    $selectedIds = {
        @($control.UnitGrid.ItemsSource | Where-Object { $_.Selected } | ForEach-Object { $_.Id })
    }.GetNewClosure()

    $report = {
        param($Results)

        foreach ($result in $Results) {
            & $writeLog ("  {0,-22} {1,-10} {2}" -f $result.Id, $result.Status, $result.Message)
        }
        & $writeLog ''
    }.GetNewClosure()

    # Every handler reports its own failure into the log pane. An exception raised on the WPF
    # dispatcher otherwise disappears: the button appears to do nothing at all.
    $guard = {
        param([scriptblock]$Action, [string]$What)

        try { & $Action }
        catch { & $writeLog ("  {0} failed: {1}" -f $What, $_.Exception.Message) }
    }.GetNewClosure()

    $control.RefreshButton.Add_Click({ & $guard $refresh 'Refresh' }.GetNewClosure())

    $control.ClearButton.Add_Click({
            & $guard {
                foreach ($row in $control.UnitGrid.ItemsSource) { $row.Selected = $false }
                $control.UnitGrid.Items.Refresh()
            } 'Clear'
        }.GetNewClosure())

    $control.SelectMissingButton.Add_Click({
            & $guard {
                foreach ($row in $control.UnitGrid.ItemsSource) { $row.Selected = -not $row.Present }
                $control.UnitGrid.Items.Refresh()
            } 'Tick everything missing'
        }.GetNewClosure())

    $control.InstallButton.Add_Click({
            & $guard {
                $ids = & $selectedIds
                if (-not $ids.Count) { & $writeLog 'Nothing is ticked.'; return }

                & $writeLog ("Installing {0} item(s)..." -f $ids.Count)
                $results = & $command['Invoke-ProfileSetup'] -Id $ids -Repository $Repository -PackageManager $PackageManager @common -Confirm:$false
                & $report $results
                & $refresh
            } 'Install'
        }.GetNewClosure())

    $control.RemoveButton.Add_Click({
            & $guard {
                $ids = & $selectedIds
                if (-not $ids.Count) { & $writeLog 'Nothing is ticked.'; return }

                & $writeLog ("Removing {0} item(s)..." -f $ids.Count)
                $results = & $command['Uninstall-ProfileSetup'] -Id $ids @common -Confirm:$false
                & $report $results
                & $refresh
            } 'Remove'
        }.GetNewClosure())

    $control.CloseButton.Add_Click({ $window.Close() }.GetNewClosure())

    & $guard $refresh 'Loading the list'

    if (-not $control.UnitGrid.Items.Count) {
        & $writeLog 'The list came back empty. Press Refresh, or run Show-ProfileSetup for the console version.'
    }
    else {
        & $writeLog ('{0} items. Tick what you want, then press Install or Remove.' -f $control.UnitGrid.Items.Count)
    }

    $null = $window.ShowDialog()
}
