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
        Height="720" Width="1040"
        MinHeight="520" MinWidth="820"
        WindowStartupLocation="CenterScreen"
        WindowStyle="None"
        ResizeMode="CanResize"
        AllowsTransparency="False"
        Background="#FF2B2233">

    <!-- Background is the literal Black Iris rather than {StaticResource Ground}: an attribute
         on Window itself is resolved before Window.Resources exists, and a StaticResource there
         throws at parse time. -->
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
        <SolidColorBrush x:Key="Tertiary"  Color="#FFC76B6B"/>

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

        <!-- The title bar buttons: square, flat, no border until hovered. Close turns Petra Rose
             so the destructive one is the only coloured thing in the strip. -->
        <Style x:Key="ChromeButton" TargetType="Button">
            <Setter Property="Width" Value="46"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="Margin" Value="0"/>
            <Setter Property="Foreground" Value="{StaticResource Body}"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Chrome" Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Chrome" Property="Background" Value="{StaticResource Line}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="CloseChromeButton" TargetType="Button" BasedOn="{StaticResource ChromeButton}">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Chrome" Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Chrome" Property="Background" Value="{StaticResource Tertiary}"/>
                                <Setter Property="Foreground" Value="{StaticResource Heading}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="FontFamily" Value="Archivo, Segoe UI"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Foreground" Value="{StaticResource Body}"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border x:Name="Tab"
                                Background="Transparent"
                                BorderBrush="Transparent"
                                BorderThickness="0,0,0,2"
                                Padding="18,10">
                            <ContentPresenter ContentSource="Header" HorizontalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="Tab" Property="BorderBrush" Value="{StaticResource Accent}"/>
                                <Setter Property="Foreground" Value="{StaticResource Heading}"/>
                                <Setter Property="FontWeight" Value="SemiBold"/>
                            </Trigger>
                            <MultiTrigger>
                                <MultiTrigger.Conditions>
                                    <Condition Property="IsMouseOver" Value="True"/>
                                    <Condition Property="IsSelected" Value="False"/>
                                </MultiTrigger.Conditions>
                                <Setter TargetName="Tab" Property="BorderBrush" Value="{StaticResource Line}"/>
                            </MultiTrigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="UnitGridStyle" TargetType="DataGrid">
            <Setter Property="AutoGenerateColumns" Value="False"/>
            <Setter Property="HeadersVisibility" Value="Column"/>
            <Setter Property="GridLinesVisibility" Value="Horizontal"/>
            <Setter Property="HorizontalGridLinesBrush" Value="{StaticResource Line}"/>
            <Setter Property="Background" Value="{StaticResource Surface}"/>
            <Setter Property="RowBackground" Value="{StaticResource Surface}"/>
            <Setter Property="AlternatingRowBackground" Value="{StaticResource Ground}"/>
            <Setter Property="Foreground" Value="{StaticResource Body}"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FontFamily" Value="Public Sans, Segoe UI"/>
            <Setter Property="CanUserAddRows" Value="False"/>
            <Setter Property="CanUserDeleteRows" Value="False"/>
            <Setter Property="SelectionMode" Value="Single"/>
            <Setter Property="ColumnHeaderStyle">
                <Setter.Value>
                    <Style TargetType="DataGridColumnHeader">
                        <Setter Property="Background" Value="{StaticResource Ground}"/>
                        <Setter Property="Foreground" Value="{StaticResource Heading}"/>
                        <Setter Property="FontFamily" Value="Archivo, Segoe UI"/>
                        <Setter Property="FontWeight" Value="SemiBold"/>
                        <Setter Property="Padding" Value="10,7"/>
                        <Setter Property="BorderBrush" Value="{StaticResource Line}"/>
                        <Setter Property="BorderThickness" Value="0,0,0,1"/>
                    </Style>
                </Setter.Value>
            </Setter>
            <Setter Property="CellStyle">
                <Setter.Value>
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
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border BorderBrush="{StaticResource Line}" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="150"/>
            </Grid.RowDefinitions>

            <!-- Title bar. WindowStyle is None, so this replaces the system one: TitleBar handles
                 the drag and the double-click, and the three buttons do what the system buttons
                 would have. -->
            <Border x:Name="TitleBar" Grid.Row="0" Background="{StaticResource Surface}" BorderBrush="{StaticResource Line}" BorderThickness="0,0,0,1">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <StackPanel Grid.Column="0" Orientation="Horizontal" Margin="14,0,0,0" VerticalAlignment="Center">
                        <Border Width="12" Height="12" Background="{StaticResource Accent}" Margin="0,0,10,0"/>
                        <TextBlock Text="PowerShell profile setup" FontSize="12" Style="{StaticResource DisplayText}" VerticalAlignment="Center"/>
                    </StackPanel>

                    <StackPanel Grid.Column="1" Orientation="Horizontal">
                        <Button x:Name="MinimiseButton" Content="&#xE921;" Style="{StaticResource ChromeButton}" ToolTip="Minimise"/>
                        <Button x:Name="MaximiseButton" Content="&#xE922;" Style="{StaticResource ChromeButton}" ToolTip="Maximise"/>
                        <Button x:Name="ChromeCloseButton" Content="&#xE8BB;" Style="{StaticResource CloseChromeButton}" ToolTip="Close"/>
                    </StackPanel>
                </Grid>
            </Border>

            <StackPanel Grid.Row="1" Margin="18,16,18,10">
                <TextBlock Text="PowerShell profile setup" FontSize="22" Style="{StaticResource DisplayText}"/>
                <TextBlock x:Name="TargetText" FontSize="12" Foreground="{StaticResource Secondary}" Margin="0,5,0,0"
                           FontFamily="JetBrains Mono, Cascadia Mono, Consolas"/>
            </StackPanel>

            <TabControl x:Name="Tabs" Grid.Row="2" Margin="18,0,18,0"
                        Background="Transparent" BorderThickness="0" Padding="0,12,0,0">

                <TabItem Header="Tools">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Row="0" Margin="0,0,0,10" FontSize="12"
                                   Text="Command-line tools the profile drives. Anything already on your machine reads as yours and is left alone."/>
                        <Border Grid.Row="1" BorderBrush="{StaticResource Line}" BorderThickness="1" Background="{StaticResource Surface}">
                            <DataGrid x:Name="ToolGrid" Style="{StaticResource UnitGridStyle}">
                                <DataGrid.Columns>
                                    <DataGridCheckBoxColumn Header="" Binding="{Binding Selected, Mode=TwoWay}" Width="36"/>
                                    <DataGridTextColumn Header="Name" Binding="{Binding Name}" IsReadOnly="True" Width="200"/>
                                    <DataGridTextColumn Header="Group" Binding="{Binding Category}" IsReadOnly="True" Width="80"/>
                                    <DataGridTextColumn Header="State" Binding="{Binding StateText}" IsReadOnly="True" Width="150"/>
                                    <DataGridTextColumn Header="What it is" Binding="{Binding Description}" IsReadOnly="True" Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Border>
                    </Grid>
                </TabItem>

                <TabItem Header="Profile">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Row="0" Margin="0,0,0,10" FontSize="12"
                                   Text="The profile itself and the configuration files it reads. A file this replaces is backed up and put back if you remove it."/>
                        <Border Grid.Row="1" BorderBrush="{StaticResource Line}" BorderThickness="1" Background="{StaticResource Surface}">
                            <DataGrid x:Name="ProfileGrid" Style="{StaticResource UnitGridStyle}">
                                <DataGrid.Columns>
                                    <DataGridCheckBoxColumn Header="" Binding="{Binding Selected, Mode=TwoWay}" Width="36"/>
                                    <DataGridTextColumn Header="Name" Binding="{Binding Name}" IsReadOnly="True" Width="200"/>
                                    <DataGridTextColumn Header="Group" Binding="{Binding Category}" IsReadOnly="True" Width="80"/>
                                    <DataGridTextColumn Header="State" Binding="{Binding StateText}" IsReadOnly="True" Width="150"/>
                                    <DataGridTextColumn Header="What it is" Binding="{Binding Description}" IsReadOnly="True" Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Border>
                    </Grid>
                </TabItem>

                <TabItem Header="What loads">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Row="0" Margin="0,0,0,10" FontSize="12"
                                   Text="What the profile imports at every shell start. Ticking writes profile.config.psd1 and takes effect on the next shell. Fewer ticks means a faster start."/>
                        <Border Grid.Row="1" BorderBrush="{StaticResource Line}" BorderThickness="1" Background="{StaticResource Surface}">
                            <DataGrid x:Name="ConfigGrid" Style="{StaticResource UnitGridStyle}">
                                <DataGrid.Columns>
                                    <DataGridCheckBoxColumn Header="" Binding="{Binding Enabled, Mode=TwoWay}" Width="36"/>
                                    <DataGridTextColumn Header="Name" Binding="{Binding Name}" IsReadOnly="True" Width="220"/>
                                    <DataGridTextColumn Header="List" Binding="{Binding Key}" IsReadOnly="True" Width="150"/>
                                    <DataGridTextColumn Header="Note" Binding="{Binding Description}" IsReadOnly="True" Width="*"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Border>
                    </Grid>
                </TabItem>
            </TabControl>

            <StackPanel Grid.Row="3" Orientation="Horizontal" Margin="18,14,18,14">
                <Button x:Name="InstallButton" Content="Install selected" Style="{StaticResource PrimaryButton}"/>
                <Button x:Name="RemoveButton" Content="Remove selected"/>
                <Button x:Name="SaveConfigButton" Content="Save what loads"/>
                <Button x:Name="SelectMissingButton" Content="Tick everything missing"/>
                <Button x:Name="ClearButton" Content="Clear"/>
                <Button x:Name="RefreshButton" Content="Refresh"/>
                <Button x:Name="CloseButton" Content="Close"/>
            </StackPanel>

            <Border Grid.Row="4" Margin="18,0,18,18" BorderBrush="{StaticResource Line}" BorderThickness="1" Background="#FF241D2B">
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
    </Border>
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

    # The configuration functions take InstallPath but not ReceiptPath: they read and write
    # profile.config.psd1, which has nothing to do with what the installer owns.
    # Reading takes the repository so the available components are known before anything is
    # installed. Writing takes the file itself: Set-ProfileConfigEntry edits profile.config.psd1
    # by path and has no idea what an install path is.
    $configRead = @{ Repository = $Repository }
    if ($InstallPath) { $configRead['InstallPath'] = $InstallPath }

    $configWrite = @{ Path = (Get-ProfileSetupPath -InstallPath $InstallPath).Config }

    $reader = [System.Xml.XmlNodeReader]::new([xml](Get-ProfileSetupWindowXaml))
    $window = [Windows.Markup.XamlReader]::Load($reader)

    $control = @{}
    foreach ($name in 'TitleBar', 'MinimiseButton', 'MaximiseButton', 'ChromeCloseButton',
        'TargetText', 'Tabs', 'ToolGrid', 'ProfileGrid', 'ConfigGrid',
        'InstallButton', 'RemoveButton', 'SaveConfigButton', 'SelectMissingButton',
        'ClearButton', 'RefreshButton', 'CloseButton', 'LogBox') {
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
    foreach ($name in 'Get-ProfileSetupState', 'Get-ProfileSetupMenuOrder', 'ConvertTo-ProfileSetupRow',
        'Invoke-ProfileSetup', 'Uninstall-ProfileSetup', 'Get-ProfileConfigState', 'Set-ProfileConfigEntry') {
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

    # Every handler reports its own failure into the log pane. An exception raised on the WPF
    # dispatcher otherwise disappears: the button appears to do nothing at all.
    $guard = {
        param([scriptblock]$Action, [string]$What)

        try { & $Action }
        catch { & $writeLog ("  {0} failed: {1}" -f $What, $_.Exception.Message) }
    }.GetNewClosure()

    # Tools and Profile show the same catalog split in two, so a person installing a tool is not
    # scrolling past the profile's own files to find it.
    $refresh = {
        $state = & $command['Get-ProfileSetupState'] @common
        $ordered = & $command['Get-ProfileSetupMenuOrder'] -State $state
        $shaped = & $command['ConvertTo-ProfileSetupRow'] -State $ordered

        $tools = [System.Collections.ObjectModel.ObservableCollection[object]]::new()
        $profile = [System.Collections.ObjectModel.ObservableCollection[object]]::new()

        foreach ($row in $shaped) {
            if ($row.Category -in 'Tool', 'System', 'Font') { $tools.Add($row) } else { $profile.Add($row) }
        }

        $control.ToolGrid.ItemsSource = $tools
        $control.ProfileGrid.ItemsSource = $profile
    }.GetNewClosure()

    $refreshConfig = {
        $rows = [System.Collections.ObjectModel.ObservableCollection[object]]::new()
        foreach ($row in (& $command['Get-ProfileConfigState'] @configRead)) { $rows.Add($row) }
        $control.ConfigGrid.ItemsSource = $rows
    }.GetNewClosure()

    # The grid on the tab that is showing. Install and Remove act on what the person is looking at.
    $activeGrid = {
        switch ($control.Tabs.SelectedIndex) {
            0 { $control.ToolGrid }
            1 { $control.ProfileGrid }
            default { $null }
        }
    }.GetNewClosure()

    $selectedIds = {
        $grid = & $activeGrid
        if (-not $grid) { return @() }
        @($grid.ItemsSource | Where-Object { $_.Selected } | ForEach-Object { $_.Id })
    }.GetNewClosure()

    $report = {
        param($Results)

        foreach ($result in $Results) {
            & $writeLog ("  {0,-22} {1,-10} {2}" -f $result.Id, $result.Status, $result.Message)
        }
        & $writeLog ''
    }.GetNewClosure()

    #-----------------------------------------------------------------------------------------------
    # Title bar. WindowStyle is None, so the drag, the double-click and the three buttons are wired
    # here rather than provided by the system.
    #-----------------------------------------------------------------------------------------------
    $control.TitleBar.Add_MouseLeftButtonDown({
            param($Sender, $EventArgs)

            if ($EventArgs.ClickCount -eq 2) {
                $window.WindowState = if ($window.WindowState -eq 'Maximized') { 'Normal' } else { 'Maximized' }
            }
            else {
                $window.DragMove()
            }
        }.GetNewClosure())

    $control.MinimiseButton.Add_Click({ $window.WindowState = 'Minimized' }.GetNewClosure())

    $control.MaximiseButton.Add_Click({
            $window.WindowState = if ($window.WindowState -eq 'Maximized') { 'Normal' } else { 'Maximized' }
        }.GetNewClosure())

    $control.ChromeCloseButton.Add_Click({ $window.Close() }.GetNewClosure())
    $control.CloseButton.Add_Click({ $window.Close() }.GetNewClosure())

    #-----------------------------------------------------------------------------------------------
    # Actions
    #-----------------------------------------------------------------------------------------------
    $control.RefreshButton.Add_Click({
            & $guard { & $refresh; & $refreshConfig } 'Refresh'
        }.GetNewClosure())

    $control.ClearButton.Add_Click({
            & $guard {
                $grid = & $activeGrid
                if (-not $grid) { & $writeLog 'Nothing to clear on this tab.'; return }

                foreach ($row in $grid.ItemsSource) { $row.Selected = $false }
                $grid.Items.Refresh()
            } 'Clear'
        }.GetNewClosure())

    $control.SelectMissingButton.Add_Click({
            & $guard {
                $grid = & $activeGrid
                if (-not $grid) { & $writeLog 'That tab has nothing to install.'; return }

                foreach ($row in $grid.ItemsSource) { $row.Selected = -not $row.Present }
                $grid.Items.Refresh()
            } 'Tick everything missing'
        }.GetNewClosure())

    $control.InstallButton.Add_Click({
            & $guard {
                $ids = & $selectedIds
                if (-not $ids.Count) { & $writeLog 'Nothing is ticked on this tab.'; return }

                & $writeLog ("Installing {0} item(s)..." -f $ids.Count)
                $results = & $command['Invoke-ProfileSetup'] -Id $ids -Repository $Repository -PackageManager $PackageManager @common -Confirm:$false
                & $report $results
                & $refresh
                & $refreshConfig
            } 'Install'
        }.GetNewClosure())

    $control.RemoveButton.Add_Click({
            & $guard {
                $ids = & $selectedIds
                if (-not $ids.Count) { & $writeLog 'Nothing is ticked on this tab.'; return }

                & $writeLog ("Removing {0} item(s)..." -f $ids.Count)
                $results = & $command['Uninstall-ProfileSetup'] -Id $ids @common -Confirm:$false
                & $report $results
                & $refresh
                & $refreshConfig
            } 'Remove'
        }.GetNewClosure())

    $control.SaveConfigButton.Add_Click({
            & $guard {
                $rows = @($control.ConfigGrid.ItemsSource)
                if (-not $rows.Count) { & $writeLog 'There is no configuration to save yet.'; return }

                # Commit the cell being edited, otherwise the tick just clicked is not in the row.
                $null = $control.ConfigGrid.CommitEdit()

                $changed = 0
                foreach ($row in $rows) {
                    if (& $command['Set-ProfileConfigEntry'] -Key $row.Key -Name $row.Name -Enabled ([bool]$row.Enabled) @configWrite -Confirm:$false) {
                        $changed++
                        & $writeLog ("  {0,-22} {1}" -f $row.Name, $(if ($row.Enabled) { 'loads' } else { 'does not load' }))
                    }
                }

                if ($changed) {
                    & $writeLog ("{0} change(s) written. They take effect in the next shell." -f $changed)
                }
                else {
                    & $writeLog 'Nothing changed.'
                }
                & $writeLog ''
                & $refreshConfig
            } 'Save what loads'
        }.GetNewClosure())

    & $guard $refresh 'Loading the list'
    & $guard $refreshConfig 'Loading the configuration'

    $toolCount = @($control.ToolGrid.ItemsSource).Count
    $profileCount = @($control.ProfileGrid.ItemsSource).Count
    $configCount = @($control.ConfigGrid.ItemsSource).Count

    if (-not ($toolCount + $profileCount)) {
        & $writeLog 'The list came back empty. Press Refresh, or run Show-ProfileSetup for the console version.'
    }
    else {
        & $writeLog ('{0} tools, {1} profile items, {2} loadable components.' -f $toolCount, $profileCount, $configCount)

        if (-not $configCount) {
            # No Module tree and no profile.config.psd1 at the target yet, which is what a first
            # run looks like. Saying so beats an empty tab with no explanation.
            & $writeLog 'What loads is empty until the profile is installed. Install it on the Profile tab first.'
        }
        & $writeLog 'Tick what you want, then press Install, Remove, or Save what loads.'
    }

    $null = $window.ShowDialog()
}
