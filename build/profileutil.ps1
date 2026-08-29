#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - installer
#
# GENERATED FILE. Do not edit.
#
# Built from Module/Setup by Tools/Build-Installer.ps1. Change a source there and rebuild;
# Tools/Test-Installer.ps1 fails CI when this file and those sources disagree.
#
# Version: 5.1.0
#
# Run it with:
#
#   irm https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/build/profileutil.ps1 | iex
#
# https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

param(
    [Parameter()]
    [switch]$Console,

    [Parameter()]
    [string]$Branch = 'main',

    [Parameter()]
    [switch]$Real,

    [Parameter()]
    [switch]$Sandbox
)

$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "This installer needs PowerShell 7 or later. You are on $($PSVersionTable.PSVersion)." -ForegroundColor Red
    Write-Host "Install it with: winget install --id Microsoft.PowerShell"
    return
}

#---------------------------------------------------------------------------------------------------
# Module/Setup/Brand.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Brand palette
#
# Dot-sourced by Setup.psm1.
#
# The identity at https://mkabumattar.com/identity/, in one place, so the console picker and the
# window cannot drift into two different looks.
#
# The identity defines a day palette and a night palette. Both front ends here sit on a dark
# ground, so they use the night set: Black Iris underneath, Salt White for headings, Amman Stone
# for body copy, Wadi Rum Sand as the accent. The day values are carried too, for anything drawn
# on a light ground later.
#
# Typefaces are named with a fallback after them. Archivo, Public Sans and JetBrains Mono are not
# on a machine by default, and WPF silently falls back to a serif when a family is missing, which
# looks like a bug rather than a missing font.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileSetupBrand {
    <#
    .SYNOPSIS
        Returns the brand colours and typefaces.

    .DESCRIPTION
        Colours come back as hex for WPF and as 24-bit ANSI sequences for the console, so a caller
        picks the form its surface needs rather than converting one into the other.

    .PARAMETER Mode
        Night for a dark ground, Day for a light one. Night is the default: both setup front ends
        draw on a dark ground.

    .OUTPUTS
        [PSCustomObject] Hex, Ansi and Font.

    .EXAMPLE
        (Get-ProfileSetupBrand).Hex.Accent
        Returns the accent colour for the night palette.

    .EXAMPLE
        "$((Get-ProfileSetupBrand).Ansi.Accent)Selected$((Get-ProfileSetupBrand).Ansi.Reset)"
        Writes accented text to a console that understands virtual terminal sequences.

    .LINK
        https://mkabumattar.com/identity/
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Night', 'Day')]
        [string]$Mode = 'Night'
    )

    $hex = if ($Mode -eq 'Night') {
        [ordered]@{
            Ground    = '#2B2233'   # Black Iris
            Surface   = '#352B3E'   # Black Iris, lifted, for a panel on the ground
            Line      = '#4A3F53'   # Black Iris, lifted further, for a keyline
            Heading   = '#EAE6DB'   # Salt White
            Body      = '#D9C9B0'   # Amman Stone
            Accent    = '#D9A36A'   # Wadi Rum Sand
            Secondary = '#B9875E'   # Desert Camel
            Tertiary  = '#C76B6B'   # Petra Rose
            Positive  = '#6B7A4F'   # Olive Green
        }
    }
    else {
        [ordered]@{
            Ground    = '#EAE6DB'   # Salt White
            Surface   = '#F2EFE7'   # Salt White, lifted
            Line      = '#2B2233'   # Black Iris
            Heading   = '#2B2233'   # Black Iris
            Body      = '#3C3C3C'   # Basalt Black
            Accent    = '#8B1E2D'   # Keffiyeh Red
            Secondary = '#2F5D6B'   # Dead Sea Blue
            Tertiary  = '#C76B6B'   # Petra Rose
            Positive  = '#6B7A4F'   # Olive Green
        }
    }

    $ansi = [ordered]@{ Reset = "`e[0m" }
    foreach ($name in $hex.Keys) {
        $value = $hex[$name].TrimStart('#')
        $r = [Convert]::ToInt32($value.Substring(0, 2), 16)
        $g = [Convert]::ToInt32($value.Substring(2, 2), 16)
        $b = [Convert]::ToInt32($value.Substring(4, 2), 16)
        $ansi[$name] = "`e[38;2;$r;$g;${b}m"
    }

    [PSCustomObject]@{
        Mode = $Mode
        Hex  = $hex
        Ansi = $ansi
        Font = [ordered]@{
            # Weight ranges are the identity's: Archivo 500-900, Public Sans 300-700,
            # JetBrains Mono 400-700.
            Display = 'Archivo, Segoe UI'
            Body    = 'Public Sans, Segoe UI'
            Mono    = 'JetBrains Mono, Cascadia Mono, Consolas'
        }
    }
}

function Test-ProfileSetupColor {
    <#
    .SYNOPSIS
        Reports whether this host can draw 24-bit colour.

    .DESCRIPTION
        A redirected or piped host prints the escape sequences as literal text, which is worse
        than plain output, so the picker asks before it colours anything.

    .OUTPUTS
        [bool]

    .EXAMPLE
        if (Test-ProfileSetupColor) { Write-Host "$accent text$reset" }

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if ([System.Console]::IsOutputRedirected) { return $false }
    if ($env:NO_COLOR) { return $false }
    if ($env:TERM -eq 'dumb') { return $false }

    return $true
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/Catalog.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup catalog
#
# Dot-sourced by Setup.psm1.
#
# One row per thing the installer can put on a machine or take off it. Every front end reads this:
# the console picker, the WPF window, and setup.ps1 itself. A unit is described, never scripted,
# so adding an installable item means adding a row rather than editing three code paths.
#
# Each row carries:
#
#   Id            stable key, used in the receipt and by -Include / -Exclude
#   Name          what a person sees in a list
#   Category      groups the list: Core, Config, Tool, Font, Module, System
#   Description   one line, shown under the name
#   Required      Core rows the profile cannot run without. Never offered for removal.
#   Kind          how Get-ProfileSetupState probes for it and how it is installed
#   Detect        the argument the probe needs: a command name, a path, or a module name
#   Source        for File and Tree, the path inside the repository to copy from
#   Winget        package id, for Kind = Package
#   Chocolatey    package id, for Kind = Package
#   Step          the setup.ps1 step that installs it, where one exists
#
# Kind decides everything else:
#
#   Package   a command-line tool from winget or Chocolatey. Present when it is on PATH.
#   Module    a PowerShell Gallery module. Present when Get-Module -ListAvailable finds it.
#   File      a file the installer copies. Present when the path exists.
#   Tree      a directory the installer copies. Present when the directory exists.
#   Font      a font, asked for by installed family name.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileSetupPath {
    <#
    .SYNOPSIS
        Resolves the paths the installer reads and writes.

    .DESCRIPTION
        Collected in one place because the catalog, the state probe and the receipt all need them,
        and because a test needs to point every one of them at a scratch directory.

    .PARAMETER InstallPath
        Where the Module tree lives. Defaults to the directory holding $PROFILE.

    .OUTPUTS
        [PSCustomObject] The resolved paths.

    .EXAMPLE
        Get-ProfileSetupPath

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [string]$InstallPath
    )

    if (-not $InstallPath) { $InstallPath = Split-Path -Parent $PROFILE }

    # Not $home: that is a readonly automatic variable, and assigning to it throws.
    $userProfile = [Environment]::GetFolderPath('UserProfile')

    [PSCustomObject]@{
        InstallPath     = $InstallPath
        Profile         = $PROFILE
        ModuleTree      = Join-Path $InstallPath 'Module'
        ToolTree        = Join-Path $InstallPath 'Tools'
        Config          = Join-Path $InstallPath 'profile.config.psd1'
        Starship        = Join-Path $userProfile '.config/starship.toml'
        FastFetch       = Join-Path $userProfile '.config/fastfetch/config.jsonc'
        Figlet          = Join-Path $userProfile '.config/.figlet/ANSI_Shadow.flf'
        WindowsTerminal = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
        FontDirectory   = Join-Path $env:WINDIR 'Fonts'

        # The receipt lives outside InstallPath on purpose: removing the Module tree must not
        # destroy the record of what else was installed alongside it.
        Receipt         = Join-Path $env:LOCALAPPDATA 'MKAbuMattar\powershell-profile\install-receipt.json'
    }
}

function Get-ProfileSetupCatalog {
    <#
    .SYNOPSIS
        Returns every unit the installer can add or remove.

    .DESCRIPTION
        The catalog is data. Get-ProfileSetupState decides what is present, Invoke-ProfileSetup
        adds, Uninstall-ProfileSetup removes, and each of them switches on Kind rather than
        knowing anything about a particular tool.

    .PARAMETER Category
        Return only these categories. Omit for all of them.

    .PARAMETER InstallPath
        Where the Module tree lives. Defaults to the directory holding $PROFILE.

    .OUTPUTS
        [PSCustomObject[]] The catalog rows.

    .EXAMPLE
        Get-ProfileSetupCatalog
        Lists everything.

    .EXAMPLE
        Get-ProfileSetupCatalog -Category Tool
        Lists the command-line tools only.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$InstallPath
    )

    $path = Get-ProfileSetupPath -InstallPath $InstallPath

    $rows = @(
        [PSCustomObject]@{
            Id = 'module-tree'; Name = 'Profile modules'; Category = 'Core'; Required = $true
            Description = 'The Module directory the profile loads at every start.'
            Kind = 'Tree'; Detect = $path.ModuleTree; Source = 'Module'; Step = 'Modules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'tool-tree'; Name = 'Maintenance scripts'; Category = 'Core'; Required = $true
            Description = 'The Tools directory. The loader reads its export policy from here.'
            Kind = 'Tree'; Detect = $path.ToolTree; Source = 'Tools'; Step = 'Modules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'profile'; Name = 'PowerShell profile'; Category = 'Core'; Required = $true
            Description = 'Microsoft.PowerShell_profile.ps1, installed over $PROFILE.'
            Kind = 'File'; Detect = $path.Profile; Source = 'Microsoft.PowerShell_profile.ps1'; Step = 'Profile'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'config'; Name = 'Load configuration'; Category = 'Core'; Required = $true
            Description = 'profile.config.psd1, which decides what loads.'
            Kind = 'File'; Detect = $path.Config; Source = 'profile.config.psd1'; Step = 'Modules'; Winget = $null; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'starship-config'; Name = 'Starship configuration'; Category = 'Config'; Required = $false
            Description = 'The prompt layout at ~/.config/starship.toml.'
            Kind = 'File'; Detect = $path.Starship; Source = '.config/starship.toml'; Step = 'Starship'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'fastfetch-config'; Name = 'FastFetch configuration'; Category = 'Config'; Required = $false
            Description = 'The system summary layout at ~/.config/fastfetch/config.jsonc.'
            Kind = 'File'; Detect = $path.FastFetch; Source = '.config/fastfetch/config.jsonc'; Step = 'FastFetch'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'figlet-font'; Name = 'Figlet banner font'; Category = 'Config'; Required = $false
            Description = 'ANSI_Shadow.flf, used for banner text.'
            Kind = 'File'; Detect = $path.Figlet; Source = '.config/.figlet/ANSI_Shadow.flf'; Step = 'Figlet'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'windows-terminal'; Name = 'Windows Terminal settings'; Category = 'Config'; Required = $false
            Description = 'Replaces settings.json. Your existing file is backed up first.'
            Kind = 'File'; Detect = $path.WindowsTerminal; Source = '.config/windows-terminal/settings.json'; Step = 'WindowsTerminal'; Winget = $null; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'starship'; Name = 'Starship'; Category = 'Tool'; Required = $false
            Description = 'The prompt itself. Without it the profile falls back to the default prompt.'
            Kind = 'Package'; Detect = 'starship'; Source = $null; Step = 'Tools'; Winget = 'Starship.Starship'; Chocolatey = 'starship'
        }
        [PSCustomObject]@{
            Id = 'zoxide'; Name = 'zoxide'; Category = 'Tool'; Required = $false
            Description = 'Directory jumping. Replaces cd with a version that learns.'
            Kind = 'Package'; Detect = 'zoxide'; Source = $null; Step = 'Tools'; Winget = 'ajeetdsouza.zoxide'; Chocolatey = 'zoxide'
        }
        [PSCustomObject]@{
            Id = 'fzf'; Name = 'fzf'; Category = 'Tool'; Required = $false
            Description = 'Fuzzy finder, used by the history and file pickers.'
            Kind = 'Package'; Detect = 'fzf'; Source = $null; Step = 'Tools'; Winget = 'junegunn.fzf'; Chocolatey = 'fzf'
        }
        [PSCustomObject]@{
            Id = 'fastfetch'; Name = 'FastFetch'; Category = 'Tool'; Required = $false
            Description = 'System summary printed at start, if you enable it in the profile.'
            Kind = 'Package'; Detect = 'fastfetch'; Source = $null; Step = 'Tools'; Winget = 'Fastfetch-cli.Fastfetch'; Chocolatey = 'fastfetch'
        }

        [PSCustomObject]@{
            Id = 'coreutils'; Name = 'Microsoft coreutils'; Category = 'System'; Required = $false
            Description = 'GNU tools as native commands. Takes the grep, head, tail, touch and sed names.'
            Kind = 'Package'; Detect = 'coreutils'; Source = $null; Step = 'Coreutils'; Winget = 'Microsoft.Coreutils'; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'terminal-icons'; Name = 'Terminal-Icons'; Category = 'Module'; Required = $false
            Description = 'File-type icons in Get-ChildItem. Costs about 250 ms, so it loads after the first prompt.'
            Kind = 'Module'; Detect = 'Terminal-Icons'; Source = $null; Step = 'GalleryModules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'psreadline'; Name = 'PSReadLine'; Category = 'Module'; Required = $false
            Description = 'Line editing, history and prediction. Ships with PowerShell; this updates it.'
            Kind = 'Module'; Detect = 'PSReadLine'; Source = $null; Step = 'GalleryModules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'completion-predictor'; Name = 'CompletionPredictor'; Category = 'Module'; Required = $false
            Description = 'Predictions drawn from your command history.'
            Kind = 'Module'; Detect = 'CompletionPredictor'; Source = $null; Step = 'GalleryModules'; Winget = $null; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'cascadia-code'; Name = 'CascadiaCode Nerd Font'; Category = 'Font'; Required = $false
            Description = 'The glyphs the prompt draws with. Without it the prompt shows boxes.'
            Kind = 'Font'; Detect = 'CaskaydiaCove NF'; Source = $null; Step = 'Font'; Winget = $null; Chocolatey = $null
        }
    )

    if ($Category) {
        $rows = @($rows | Where-Object { $_.Category -in $Category })
    }

    return $rows
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/State.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup state and receipt
#
# Dot-sourced by Setup.psm1.
#
# Two questions, and they are not the same question:
#
#   Is this on the machine?        Get-ProfileSetupState
#   Did this installer put it there?   the receipt
#
# Uninstall needs the second. Starship being on PATH says nothing about who put it there, and
# removing a tool the user installed years ago for other work is not an uninstall, it is damage.
# So Invoke-ProfileSetup writes down what it actually changed, and Uninstall-ProfileSetup takes
# back only that.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Test-ProfileSetupPresent {
    <#
    .SYNOPSIS
        Reports whether one catalog unit is on this machine.

    .DESCRIPTION
        Switches on the unit's Kind. Nothing here knows about a particular tool, so a new catalog
        row needs no change to this function unless it introduces a new Kind.

    .PARAMETER Unit
        A row from Get-ProfileSetupCatalog.


    .OUTPUTS
        [bool]

    .EXAMPLE
        Test-ProfileSetupPresent -Unit (Get-ProfileSetupCatalog | Where-Object Id -eq 'fzf')

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSCustomObject]$Unit
    )

    process {
        switch ($Unit.Kind) {
            'Package' {
                [bool](Get-Command -Name $Unit.Detect -CommandType Application -ErrorAction SilentlyContinue)
            }
            'Module' {
                [bool](Get-Module -ListAvailable -Name $Unit.Detect -ErrorAction SilentlyContinue)
            }
            'File' {
                Test-Path -LiteralPath $Unit.Detect -PathType Leaf
            }
            'Tree' {
                Test-Path -LiteralPath $Unit.Detect -PathType Container
            }
            'Font' {
                # Asked by installed family name, the same way Install-CascadiaCodeFont in
                # setup.ps1 asks, so the two never disagree about whether a font is present.
                # Looking for a filename under %WINDIR%\Fonts misses a per-user install, which
                # lands in %LOCALAPPDATA%\Microsoft\Windows\Fonts instead.
                try {
                    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
                    $families = [System.Drawing.Text.InstalledFontCollection]::new().Families
                    return ($families.Name -contains $Unit.Detect)
                }
                catch {
                    Write-Warning "Could not read the installed fonts, so '$($Unit.Id)' is reported as absent: $($_.Exception.Message)"
                    return $false
                }
            }
            default {
                throw "Catalog unit '$($Unit.Id)' has an unknown Kind '$($Unit.Kind)'."
            }
        }
    }
}

function Get-ProfileSetupState {
    <#
    .SYNOPSIS
        Reports what is on this machine and who put it there.

    .DESCRIPTION
        Returns one row per catalog unit with three facts a picker needs to render a checkbox
        correctly: whether it is present, whether this installer owns it, and therefore whether
        offering to remove it is safe.

        Owned is the difference between an uninstall and an accident. A unit is owned only when
        the receipt says this installer added it.

    .PARAMETER Category
        Limit to these categories.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .OUTPUTS
        [PSCustomObject[]] The catalog rows with Present, Owned, Removable and InstalledOn added.

    .EXAMPLE
        Get-ProfileSetupState | Format-Table Id, Present, Owned, Removable

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$ReceiptPath
    )

    $paths = Get-ProfileSetupPath -InstallPath $InstallPath
    $receipt = Get-ProfileSetupReceipt -Path $ReceiptPath
    $entries = @{}
    foreach ($entry in $receipt.Entries) { $entries[$entry.Id] = $entry }

    # Passed as a splat rather than as arguments: [ValidateSet] rejects the $null an unbound
    # -Category arrives as, so the parameter has to be absent instead of empty.
    $filter = @{}
    if ($Category) { $filter['Category'] = $Category }
    if ($InstallPath) { $filter['InstallPath'] = $InstallPath }

    foreach ($unit in (Get-ProfileSetupCatalog @filter)) {
        $present = Test-ProfileSetupPresent -Unit $unit
        $entry = $entries[$unit.Id]

        [PSCustomObject]@{
            Id          = $unit.Id
            Name        = $unit.Name
            Category    = $unit.Category
            Description = $unit.Description
            Required    = $unit.Required
            Kind        = $unit.Kind
            Present     = $present
            Owned       = [bool]$entry
            InstalledOn = if ($entry) { $entry.InstalledOn } else { $null }
            Replaced    = if ($entry -and $entry.Backup) { $entry.Backup } else { $null }

            # Offer removal only for something this installer added and the profile can live
            # without. Everything else is either load bearing or someone else's.
            Removable   = ($present -and [bool]$entry -and -not $unit.Required)
        }
    }
}

function Get-ProfileSetupReceipt {
    <#
    .SYNOPSIS
        Reads the record of what this installer put on the machine.

    .DESCRIPTION
        A missing or unreadable receipt is not an error. It means nothing is known to be owned,
        which makes uninstall refuse to remove anything, which is the safe direction to fail in.

    .PARAMETER Path
        Receipt file. Defaults to the one under LOCALAPPDATA.

    .OUTPUTS
        [PSCustomObject] With Version, UpdatedOn and Entries.

    .EXAMPLE
        (Get-ProfileSetupReceipt).Entries | Format-Table Id, InstalledOn

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    $empty = [PSCustomObject]@{ Version = 1; UpdatedOn = $null; Entries = @() }

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $empty }

    try {
        $data = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    }
    catch {
        Write-Warning "The install receipt at $Path could not be read, so nothing is treated as owned: $($_.Exception.Message)"
        return $empty
    }

    [PSCustomObject]@{
        Version   = if ($data.PSObject.Properties.Name -contains 'Version') { $data.Version } else { 1 }
        UpdatedOn = if ($data.PSObject.Properties.Name -contains 'UpdatedOn') { $data.UpdatedOn } else { $null }
        Entries   = @($data.Entries)
    }
}

function Add-ProfileSetupReceiptEntry {
    <#
    .SYNOPSIS
        Records that this installer added one unit.

    .DESCRIPTION
        Called after a unit installs, not before, so a failed install leaves no claim of ownership.
        Re-adding an existing id replaces its entry rather than duplicating it.

    .PARAMETER Id
        Catalog id.

    .PARAMETER Backup
        Path of the file that was displaced, when one was. Uninstall restores it.

    .PARAMETER Manager
        Package manager used, for a Package unit.

    .PARAMETER Path
        Receipt file. Defaults to the one under LOCALAPPDATA.

    .OUTPUTS
        None.

    .EXAMPLE
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Manager Winget

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Id,

        [Parameter()]
        [string]$Backup,

        [Parameter()]
        [string]$Manager,

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    $receipt = Get-ProfileSetupReceipt -Path $Path
    $entries = @($receipt.Entries | Where-Object { $_.Id -ne $Id })

    $entries += [PSCustomObject]@{
        Id          = $Id
        InstalledOn = (Get-Date).ToString('o')
        Backup      = if ($Backup) { $Backup } else { $null }
        Manager     = if ($Manager) { $Manager } else { $null }
    }

    Save-ProfileSetupReceipt -Entry $entries -Path $Path
}

function Remove-ProfileSetupReceiptEntry {
    <#
    .SYNOPSIS
        Drops one unit's ownership record after it has been removed.

    .PARAMETER Id
        Catalog id.

    .PARAMETER Path
        Receipt file. Defaults to the one under LOCALAPPDATA.

    .OUTPUTS
        None.

    .EXAMPLE
        Remove-ProfileSetupReceiptEntry -Id 'fzf'

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Id,

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    $receipt = Get-ProfileSetupReceipt -Path $Path
    Save-ProfileSetupReceipt -Entry @($receipt.Entries | Where-Object { $_.Id -ne $Id }) -Path $Path
}

function Save-ProfileSetupReceipt {
    <#
    .SYNOPSIS
        Writes the receipt.

    .PARAMETER Entry
        The entries to store.

    .PARAMETER Path
        Receipt file.

    .OUTPUTS
        None.

    .EXAMPLE
        Save-ProfileSetupReceipt -Entry @() -Path $receipt
        Empties the receipt.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$Entry = @(),

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    if (-not $PSCmdlet.ShouldProcess($Path, 'Write the install receipt')) { return }

    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    $document = [PSCustomObject]@{
        Version   = 1
        UpdatedOn = (Get-Date).ToString('o')
        Entries   = @($Entry)
    }

    $document | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Get-ProfileSetupMode {
    <#
    .SYNOPSIS
        Decides whether to install for real or into a throwaway directory.

    .DESCRIPTION
        The first run on a machine goes into a throwaway directory, so a wrong click costs nothing
        while someone is still finding out what the buttons do. Every run after that installs for
        real. Nobody has to remember a flag on the run where forgetting it is expensive.

        What makes a run the first one is a marker beside the install receipt under LOCALAPPDATA,
        not anything in the repository. A fresh clone on a machine that has used the picker does
        not start over in the sandbox, and the same clone carried to a new machine does.

        The marker is written by Set-ProfileSetupSeen, which the caller invokes once it has decided
        rather than as a side effect of asking.

    .PARAMETER Real
        Install for real whatever the marker says.

    .PARAMETER Sandbox
        Use a throwaway directory whatever the marker says.

    .OUTPUTS
        [PSCustomObject] Real, Reason, InstallPath, ReceiptPath, Seen. InstallPath and ReceiptPath
        are empty for a real run, meaning the defaults apply.

    .EXAMPLE
        $mode = Get-ProfileSetupMode
        if ($mode.Real) { 'installing for real' } else { $mode.InstallPath }

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        [switch]$Real,

        [Parameter()]
        [switch]$Sandbox
    )

    if ($Real -and $Sandbox) {
        throw 'Ask for Real or Sandbox, not both.'
    }

    $seen = Test-Path -LiteralPath (Get-ProfileSetupMarkerPath) -PathType Leaf

    $useReal = if ($Real) { $true } elseif ($Sandbox) { $false } else { $seen }

    $reason = if ($Real) { 'you asked for it' }
    elseif ($Sandbox) { 'you asked for it' }
    elseif ($seen) { 'you have run this before' }
    else { 'this is the first run on this machine' }

    if ($useReal) {
        return [PSCustomObject]@{
            Real = $true; Reason = $reason; Seen = $seen
            InstallPath = ''; ReceiptPath = ''
        }
    }

    $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-try-" + [guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $scratch -Force

    [PSCustomObject]@{
        Real = $false; Reason = $reason; Seen = $seen
        InstallPath = $scratch; ReceiptPath = (Join-Path $scratch 'receipt.json')
    }
}

function Get-ProfileSetupMarkerPath {
    <#
    .SYNOPSIS
        Where the record of having run the picker lives.

    .DESCRIPTION
        Beside the install receipt, for the same reason the receipt is there: it describes the
        machine, not the checkout, and removing the Module tree must not erase it.

    .OUTPUTS
        [string]

    .EXAMPLE
        Get-ProfileSetupMarkerPath

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Split-Path -Parent (Get-ProfileSetupPath).Receipt) 'first-run.json'
}

function Set-ProfileSetupSeen {
    <#
    .SYNOPSIS
        Records that the picker has been run on this machine.

    .DESCRIPTION
        Called once the mode is decided and before the picker opens, so closing the window without
        installing anything still counts. Someone who has seen the list has seen it.

    .PARAMETER Repository
        Where it was run from, kept for diagnosis.

    .OUTPUTS
        None.

    .EXAMPLE
        Set-ProfileSetupSeen -Repository $checkout

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Repository
    )

    $marker = Get-ProfileSetupMarkerPath
    if (Test-Path -LiteralPath $marker -PathType Leaf) { return }

    if (-not $PSCmdlet.ShouldProcess($marker, 'Record the first run')) { return }

    $parent = Split-Path -Parent $marker
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    [PSCustomObject]@{
        FirstRun   = (Get-Date).ToString('o')
        Repository = if ($Repository) { $Repository } else { '' }
    } | ConvertTo-Json | Set-Content -LiteralPath $marker -Encoding UTF8
}

function Write-ProfileSetupMode {
    <#
    .SYNOPSIS
        Prints which mode was chosen, why, and how to override it.

    .DESCRIPTION
        A picker that quietly writes to a different place than last time would be worse than one
        that asks, so the choice is stated before anything opens.

    .PARAMETER Mode
        A result from Get-ProfileSetupMode.

    .OUTPUTS
        None.

    .EXAMPLE
        Write-ProfileSetupMode -Mode (Get-ProfileSetupMode)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Mode
    )

    Write-Host ''

    if ($Mode.Real) {
        Write-Host ("Installing for real, because {0}." -f $Mode.Reason)
        Write-Host ('  ' + (Get-ProfileSetupPath).InstallPath)
        Write-Host '  Run it with -Sandbox to try it against a throwaway directory instead.'
    }
    else {
        Write-Host ("Sandbox run, because {0}." -f $Mode.Reason)
        Write-Host ('  ' + $Mode.InstallPath)
        Write-Host '  Nothing outside that directory is touched. The next run installs for real.'
    }

    Write-Host ''
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/Config.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Load configuration
#
# Dot-sourced by Setup.psm1.
#
# Reads and writes the component lists in profile.config.psd1: which plugins, utilities and Gallery
# modules the profile loads at start.
#
# The file disables an entry by commenting it out rather than deleting it, so the list of what is
# available stays visible next to the list of what is on:
#
#     Plugins = @(
#         'Git'
#         # 'AWS'
#     )
#
# That makes this a line edit, not a data rewrite. Reading the file with
# Import-PowerShellDataFile and writing it back would silently delete every commented entry and
# every comment in the file, and profile.config.psd1 is mostly comments explaining what each
# setting costs. So the line holding an entry is found and its comment marker added or removed,
# and nothing else in the file is touched.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileConfigEntry {
    <#
    .SYNOPSIS
        Returns the entries in one list in profile.config.psd1, enabled and disabled.

    .DESCRIPTION
        An entry that is commented out is reported with Enabled false rather than left out, because
        the picker needs to offer it.

    .PARAMETER Path
        The configuration file. Defaults to the one beside the installed Module tree.

    .PARAMETER Key
        Which list: Modules, Plugins, Utilities, ExternalModules or DeferExternalModules.

    .OUTPUTS
        [PSCustomObject[]] Key, Name, Enabled, Line.

    .EXAMPLE
        Get-ProfileConfigEntry -Key Plugins | Where-Object Enabled

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Modules', 'Plugins', 'Utilities', 'ExternalModules', 'DeferExternalModules')]
        [string[]]$Key = @('Modules', 'Plugins', 'Utilities', 'ExternalModules'),

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Config }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }

    $lines = @(Get-Content -LiteralPath $Path)

    foreach ($name in $Key) {
        $start = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^\s*$([regex]::Escape($name))\s*=\s*@\(") { $start = $i; break }
        }
        if ($start -lt 0) { continue }

        for ($i = $start + 1; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]

            # The list ends at its closing parenthesis on a line of its own.
            if ($line -match '^\s*\)\s*$') { break }

            # 'Name' or # 'Name', with anything after it, which is where the cost notes live.
            if ($line -notmatch "^\s*(#\s*)?'([^']+)'") { continue }

            [PSCustomObject]@{
                Key     = $name
                Name    = $Matches[2]
                Enabled = -not $Matches[1]
                Line    = $i
            }
        }
    }
}

function Set-ProfileConfigEntry {
    <#
    .SYNOPSIS
        Turns one entry in profile.config.psd1 on or off.

    .DESCRIPTION
        Adds or removes the comment marker on the line holding the entry. Everything else in the
        file, including the notes explaining what each module costs at startup, is left alone.

        An entry the file does not mention is added to the end of its list, so a plugin that ships
        later can be enabled without editing the file by hand.

    .PARAMETER Key
        Which list the entry belongs to.

    .PARAMETER Name
        The entry.

    .PARAMETER Enabled
        On or off.

    .PARAMETER Path
        The configuration file. Defaults to the one beside the installed Module tree.

    .OUTPUTS
        [bool] Whether the file changed.

    .EXAMPLE
        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('Modules', 'Plugins', 'Utilities', 'ExternalModules', 'DeferExternalModules')]
        [string]$Key,

        [Parameter(Mandatory, Position = 1)]
        [string]$Name,

        [Parameter(Mandatory, Position = 2)]
        [bool]$Enabled,

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Config }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "There is no configuration file at $Path."
    }

    if (-not $PSCmdlet.ShouldProcess("$Key/$Name", $(if ($Enabled) { 'Enable' } else { 'Disable' }))) {
        return $false
    }

    # Read as raw and split, so the file's own line ending survives the round trip.
    $raw = Get-Content -LiteralPath $Path -Raw
    $newline = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
    $lines = [System.Collections.Generic.List[string]]($raw -split "`r?`n")

    $entry = Get-ProfileConfigEntry -Key $Key -Path $Path | Where-Object { $_.Name -eq $Name } | Select-Object -First 1

    if ($entry) {
        if ($entry.Enabled -eq $Enabled) { return $false }

        $line = $lines[$entry.Line]

        $lines[$entry.Line] = if ($Enabled) {
            # Drop the marker, keep the indentation the rest of the list uses.
            $line -replace "^(\s*)#\s?", '$1'
        }
        else {
            $line -replace "^(\s*)", '$1# '
        }
    }
    else {
        # Not mentioned at all: add it at the end of the list, indented to match.
        $start = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^\s*$([regex]::Escape($Key))\s*=\s*@\(") { $start = $i; break }
        }
        if ($start -lt 0) { throw "profile.config.psd1 has no $Key list to add '$Name' to." }

        $close = -1
        for ($i = $start + 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*\)\s*$') { $close = $i; break }
        }
        if ($close -lt 0) { throw "The $Key list in profile.config.psd1 is not closed." }

        $indent = if ($lines[$close] -match '^(\s*)') { $Matches[1] + '    ' } else { '        ' }
        $text = if ($Enabled) { "$indent'$Name'" } else { "$indent# '$Name'" }

        $lines.Insert($close, $text)
    }

    Set-Content -LiteralPath $Path -Value ($lines -join $newline) -NoNewline -Encoding UTF8
    return $true
}

function Get-ProfileComponentSource {
    <#
    .SYNOPSIS
        Finds a Module tree to read the available components from.

    .DESCRIPTION
        The installed tree first, then the repository the installer was pointed at. Before the
        first install there is no installed tree, and reading the repository instead is what lets
        the picker show the real list rather than a page of rows saying nothing was found.

    .PARAMETER InstallPath
        Where the Module tree would be once installed.

    .PARAMETER Repository
        A checkout or extracted archive to fall back to.

    .OUTPUTS
        [PSCustomObject] Path and Origin, or nothing when neither has a Module tree.

    .EXAMPLE
        Get-ProfileComponentSource -Repository $PSScriptRoot

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$Repository
    )

    $installed = (Get-ProfileSetupPath -InstallPath $InstallPath).ModuleTree
    if (Test-Path -LiteralPath $installed -PathType Container) {
        return [PSCustomObject]@{ Path = $installed; Origin = 'installed' }
    }

    if ($Repository) {
        $candidate = Join-Path $Repository 'Module'
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            return [PSCustomObject]@{ Path = $candidate; Origin = 'repository' }
        }
    }

    return $null
}

function Get-ProfileConfigState {
    <#
    .SYNOPSIS
        Returns everything the profile can load, with whether it is turned on.

    .DESCRIPTION
        Joins the components on disk against what profile.config.psd1 lists, sorted by list and
        then by name so the same component is in the same place every time the window opens.

        On disk means the installed Module tree, or the repository the installer was pointed at
        when nothing is installed yet. Without that fallback every row on a first run reads
        "not in the Module tree", which is true and useless: nothing is, because nothing is
        installed.

        Note carries only what is worth saying. A component that is present and configured gets
        none, because a note on every row is a note nobody reads.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER Repository
        A checkout or extracted archive to read the available components from when nothing is
        installed yet.

    .PARAMETER Path
        The configuration file. Defaults to the one under InstallPath.

    .OUTPUTS
        [PSCustomObject[]] Key, Name, Enabled, Installed, Origin, Description.

    .EXAMPLE
        Get-ProfileConfigState -Repository $PSScriptRoot | Where-Object Key -eq 'Plugins'

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$Path
    )

    $paths = Get-ProfileSetupPath -InstallPath $InstallPath
    if (-not $Path) { $Path = $paths.Config }

    $configured = @{}
    foreach ($entry in (Get-ProfileConfigEntry -Path $Path)) {
        $configured["$($entry.Key)/$($entry.Name)"] = $entry
    }

    $source = Get-ProfileComponentSource -InstallPath $InstallPath -Repository $Repository

    $onDisk = [ordered]@{ Modules = @(); Plugins = @(); Utilities = @() }

    if ($source) {
        $onDisk.Plugins = @(Get-ChildItem -LiteralPath (Join-Path $source.Path 'Plugins') -Directory -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Name })
        $onDisk.Utilities = @(Get-ChildItem -LiteralPath (Join-Path $source.Path 'Utility') -Directory -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Name })
        $onDisk.Modules = @(Get-ChildItem -LiteralPath $source.Path -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -notin 'Plugins', 'Utility', 'Loader', 'Setup' } |
                ForEach-Object { $_.Name })
    }

    $rows = [System.Collections.Generic.List[PSCustomObject]]::new()
    $seen = @{}

    foreach ($key in $onDisk.Keys) {
        foreach ($name in $onDisk[$key]) {
            $entry = $configured["$key/$name"]
            $seen["$key/$name"] = $true

            $rows.Add([PSCustomObject]@{
                    Key         = $key
                    Name        = $name
                    Enabled     = [bool]($entry -and $entry.Enabled)
                    Installed   = $true
                    Origin      = $source.Origin
                    Description = if ($entry) { '' } else { 'Available, not yet named in the configuration.' }
                })
        }
    }

    foreach ($entry in $configured.Values) {
        if ($seen["$($entry.Key)/$($entry.Name)"]) { continue }

        $gallery = $entry.Key -in 'ExternalModules', 'DeferExternalModules'

        $rows.Add([PSCustomObject]@{
                Key         = $entry.Key
                Name        = $entry.Name
                Enabled     = $entry.Enabled
                Installed   = $gallery
                Origin      = if ($gallery) { 'gallery' } else { 'missing' }
                Description = if ($gallery) { 'From the PowerShell Gallery.' }
                elseif ($source) { 'Named in the configuration but not in the Module tree.' }
                else { 'The Module tree is not installed yet.' }
            })
    }

    # Sorted so a component keeps its place between one opening of the window and the next.
    $order = @{ Modules = 0; Plugins = 1; Utilities = 2; ExternalModules = 3; DeferExternalModules = 4 }
    $rows | Sort-Object -Property @{ Expression = { $order[$_.Key] } }, Name
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/Install.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup install
#
# Dot-sourced by Setup.psm1.
#
# Installs the units a caller selected and writes down what it did. The receipt entry is written
# after the unit installs, never before, so a failed install leaves no claim of ownership behind
# for Uninstall-ProfileSetup to act on.
#
# Every function here switches on Kind and nothing else. Adding a tool means adding a catalog row.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Resolve-ProfileSetupManager {
    <#
    .SYNOPSIS
        Picks the package manager to install with.

    .DESCRIPTION
        winget first: it installs the profile's tools without an elevated session, and Chocolatey
        does not.

    .PARAMETER Preference
        Auto, Winget, Chocolatey or None.

    .OUTPUTS
        [string] Winget, Chocolatey or None.

    .EXAMPLE
        Resolve-ProfileSetupManager -Preference Auto

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Auto', 'Winget', 'Chocolatey', 'None')]
        [string]$Preference = 'Auto'
    )

    if ($Preference -ne 'Auto') { return $Preference }

    if (Get-Command -Name winget -CommandType Application -ErrorAction SilentlyContinue) { return 'Winget' }
    if (Get-Command -Name choco -CommandType Application -ErrorAction SilentlyContinue) { return 'Chocolatey' }

    return 'None'
}

function Copy-ProfileSetupItem {
    <#
    .SYNOPSIS
        Copies a file or directory into place, keeping a copy of whatever it displaced.

    .DESCRIPTION
        Returns the backup path when something was displaced, so the caller can record it and
        Uninstall-ProfileSetup can put the original back rather than deleting a file the user had
        before this ever ran.

    .PARAMETER Source
        What to copy.

    .PARAMETER Destination
        Where it goes.

    .OUTPUTS
        [string] The backup path, or an empty string when nothing was displaced.

    .EXAMPLE
        Copy-ProfileSetupItem -Source $repo/profile.config.psd1 -Destination $target

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Source,

        [Parameter(Mandatory, Position = 1)]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Nothing to copy: $Source does not exist."
    }

    if (-not $PSCmdlet.ShouldProcess($Destination, 'Install')) { return '' }

    $parent = Split-Path -Parent $Destination
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    $backup = ''
    if (Test-Path -LiteralPath $Destination) {
        $backup = "$Destination.profile-backup"
        if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }
        Move-Item -LiteralPath $Destination -Destination $backup -Force
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force

    return $backup
}

function Install-ProfileSetupUnit {
    <#
    .SYNOPSIS
        Installs one catalog unit and reports what happened.

    .DESCRIPTION
        Returns a result rather than throwing, because one failing unit must not abandon the rest
        of a selection. Status is one of installed, present, skipped or failed.

    .PARAMETER Unit
        A row from Get-ProfileSetupCatalog.

    .PARAMETER Repository
        Root of a checkout or extracted archive, for File and Tree units.

    .PARAMETER Manager
        Winget, Chocolatey or None.

    .OUTPUTS
        [PSCustomObject] Id, Status, Backup, Message.

    .EXAMPLE
        Install-ProfileSetupUnit -Unit $unit -Repository $repo -Manager Winget

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Unit,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$Manager = 'None'
    )

    $result = [PSCustomObject]@{ Id = $Unit.Id; Status = 'failed'; Backup = ''; Message = '' }

    try {
        switch ($Unit.Kind) {

            { $_ -in 'File', 'Tree' } {
                if (-not $Repository) {
                    $result.Status = 'skipped'
                    $result.Message = 'No repository was supplied to copy from.'
                    break
                }

                $source = Join-Path $Repository $Unit.Source
                $result.Backup = Copy-ProfileSetupItem -Source $source -Destination $Unit.Detect
                $result.Status = 'installed'
                $result.Message = "-> $($Unit.Detect)"
            }

            'Module' {
                if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Install Gallery module')) {
                    $result.Status = 'skipped'
                    break
                }

                Install-Module -Name $Unit.Detect -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck -ErrorAction Stop
                $result.Status = 'installed'
            }

            'Package' {
                $package = if ($Manager -eq 'Winget') { $Unit.Winget } elseif ($Manager -eq 'Chocolatey') { $Unit.Chocolatey } else { $null }

                if (-not $package) {
                    $result.Status = 'skipped'
                    $result.Message = "No $Manager package is defined for this tool."
                    break
                }

                if (-not $PSCmdlet.ShouldProcess($package, "$Manager install")) {
                    $result.Status = 'skipped'
                    break
                }

                if ($Manager -eq 'Winget') {
                    & winget install --exact --id $package --accept-source-agreements --accept-package-agreements --silent
                }
                else {
                    & choco install $package -y --limit-output
                }

                if ($LASTEXITCODE -ne 0) {
                    $result.Message = "$Manager exited with code $LASTEXITCODE."
                    break
                }

                $result.Status = 'installed'
            }

            'Font' {
                $result = Install-ProfileSetupFont -Unit $Unit
            }

            default {
                $result.Message = "Unknown Kind '$($Unit.Kind)'."
            }
        }
    }
    catch {
        $result.Status = 'failed'
        $result.Message = $_.Exception.Message
    }

    return $result
}

function Install-ProfileSetupFont {
    <#
    .SYNOPSIS
        Installs the Nerd Font the prompt draws with.

    .DESCRIPTION
        Fonts go into the machine font directory through the shell namespace, which registers them.
        That needs an elevated session, so an unelevated caller gets a skip with a reason rather
        than a failure it cannot act on.

    .PARAMETER Unit
        The Font catalog row.

    .OUTPUTS
        [PSCustomObject] Id, Status, Backup, Message.

    .EXAMPLE
        Install-ProfileSetupFont -Unit $unit

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Unit
    )

    $result = [PSCustomObject]@{ Id = $Unit.Id; Status = 'failed'; Backup = ''; Message = '' }

    $identity = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $result.Status = 'skipped'
        $result.Message = 'Installing a font needs an elevated session.'
        return $result
    }

    if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Install font')) {
        $result.Status = 'skipped'
        return $result
    }

    $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-font-" + [guid]::NewGuid().ToString('N'))
    $archive = "$workspace.zip"

    try {
        $null = New-Item -ItemType Directory -Path $workspace -Force

        Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip' -OutFile $archive -UseBasicParsing
        Expand-Archive -Path $archive -DestinationPath $workspace -Force

        $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
        $installed = 0

        foreach ($file in Get-ChildItem -LiteralPath $workspace -Recurse -Filter '*.ttf') {
            if (Test-Path -LiteralPath (Join-Path $env:WINDIR "Fonts\$($file.Name)")) { continue }
            $fonts.CopyHere($file.FullName, 0x10)
            $installed++
        }

        $result.Status = 'installed'
        $result.Message = "$installed font file(s)"
    }
    catch {
        $result.Message = $_.Exception.Message
    }
    finally {
        Remove-Item -LiteralPath $workspace -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue
    }

    return $result
}

function Invoke-ProfileSetup {
    <#
    .SYNOPSIS
        Installs the selected units and records what it installed.

    .DESCRIPTION
        A unit already on the machine is reported as present and left alone unless -Force is given,
        so re-running is cheap and does not reinstall what is already there.

        The receipt entry is written only after a unit installs. A failure leaves no ownership
        claim, so a later uninstall cannot try to remove something this never put there.

    .PARAMETER Id
        Catalog ids to install. Omit to install everything not yet present.

    .PARAMETER Category
        Install everything in these categories.

    .PARAMETER Repository
        Root of a checkout or extracted archive, needed for File and Tree units.

    .PARAMETER InstallPath
        Where the Module tree goes. Defaults to the directory holding $PROFILE.

    .PARAMETER PackageManager
        Auto, Winget, Chocolatey or None.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .PARAMETER Force
        Install a unit even when it is already present.

    .OUTPUTS
        [PSCustomObject[]] One result per unit: Id, Status, Backup, Message.

    .EXAMPLE
        Invoke-ProfileSetup -Id fzf, zoxide
        Installs those two tools.

    .EXAMPLE
        Invoke-ProfileSetup -Category Tool -WhatIf
        Reports which tools it would install.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('profile-install')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]$Id,

        [Parameter()]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [ValidateSet('Auto', 'Winget', 'Chocolatey', 'None')]
        [string]$PackageManager = 'Auto',

        [Parameter()]
        [string]$ReceiptPath,

        [Parameter()]
        [switch]$Force
    )

    begin {
        $selected = [System.Collections.Generic.List[string]]::new()
    }

    process {
        foreach ($name in @($Id)) { if ($name) { $selected.Add($name) } }
    }

    end {
        # Splatted rather than passed as arguments: [ValidateSet] rejects the $null an unbound
        # -Category arrives as, so the parameter has to be absent instead of empty.
        $filter = @{}
        if ($Category) { $filter['Category'] = $Category }
        if ($InstallPath) { $filter['InstallPath'] = $InstallPath }
        if ($ReceiptPath) { $filter['ReceiptPath'] = $ReceiptPath }

        $catalogFilter = @{}
        if ($InstallPath) { $catalogFilter['InstallPath'] = $InstallPath }

        $state = @(Get-ProfileSetupState @filter)
        $catalog = @{}
        foreach ($unit in (Get-ProfileSetupCatalog @catalogFilter)) { $catalog[$unit.Id] = $unit }

        if ($selected.Count) {
            $unknown = @($selected | Where-Object { -not $catalog.ContainsKey($_) })
            if ($unknown.Count) {
                throw "No such setup unit: $($unknown -join ', '). Run Get-ProfileSetupCatalog to see the ids."
            }
            $state = @($state | Where-Object { $_.Id -in $selected })
        }

        $manager = Resolve-ProfileSetupManager -Preference $PackageManager

        foreach ($row in $state) {
            if ($row.Present -and -not $Force) {
                [PSCustomObject]@{ Id = $row.Id; Status = 'present'; Backup = ''; Message = 'Already installed.' }
                continue
            }

            $result = Install-ProfileSetupUnit -Unit $catalog[$row.Id] -Repository $Repository -Manager $manager

            if ($result.Status -eq 'installed') {
                Add-ProfileSetupReceiptEntry -Id $row.Id -Backup $result.Backup -Manager $manager -Path $ReceiptPath
            }

            $result
        }
    }
}

function Update-ProfileSetup {
    <#
    .SYNOPSIS
        Refreshes what is already installed, and adds nothing.

    .DESCRIPTION
        Install and update are different jobs and the difference matters.

        Invoke-ProfileSetup adds what a person picked. Running it again to pick up a new version
        would either report everything as already present and do nothing, or with -Force reinstall
        the lot, including the units the person deliberately left out.

        This refreshes the units that are already there, and only those: the Module tree, the
        maintenance scripts, the profile, and any configuration file this installer owns. Nothing
        absent is added, so a machine that never wanted FastFetch does not acquire it on an update.

        profile.config.psd1 is never overwritten. It holds the choices about what loads at every
        shell start, which are the user's, not the repository's. -IncludeConfig overrides that and
        says so in the result.

    .PARAMETER Repository
        A checkout or extracted archive to refresh from.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .PARAMETER IncludeConfig
        Replace profile.config.psd1 as well. The current one is backed up first.

    .OUTPUTS
        [PSCustomObject[]] One result per unit: Id, Status, Backup, Message.

    .EXAMPLE
        Update-ProfileSetup -Repository $checkout
        Refreshes the installed pieces from that checkout.

    .EXAMPLE
        Update-ProfileSetup -Repository $checkout -WhatIf
        Reports what it would refresh.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('profile-update')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Repository,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$ReceiptPath,

        [Parameter()]
        [switch]$IncludeConfig
    )

    $filter = @{}
    if ($InstallPath) { $filter['InstallPath'] = $InstallPath }
    if ($ReceiptPath) { $filter['ReceiptPath'] = $ReceiptPath }

    $catalog = @{}
    $catalogFilter = @{}
    if ($InstallPath) { $catalogFilter['InstallPath'] = $InstallPath }
    foreach ($unit in (Get-ProfileSetupCatalog @catalogFilter)) { $catalog[$unit.Id] = $unit }

    foreach ($row in (Get-ProfileSetupState @filter)) {

        # Only what is copied from the repository can be refreshed from it. A package or a Gallery
        # module is updated by winget or Install-Module, not by this.
        if ($catalog[$row.Id].Kind -notin 'File', 'Tree') { continue }

        # Owned, not merely present. Several units point at absolute user paths rather than at
        # anything under InstallPath: $PROFILE, ~/.config/starship.toml, the Windows Terminal
        # settings. Refreshing on Present alone reaches straight past a scratch install path and
        # overwrites the real ones, which is what it did before this check existed.
        if (-not $row.Owned) {
            [PSCustomObject]@{
                Id = $row.Id; Status = 'skipped'; Backup = ''
                Message = 'This installer did not install it, so it is not ours to refresh.'
            }
            continue
        }

        if (-not $row.Present) {
            [PSCustomObject]@{ Id = $row.Id; Status = 'skipped'; Backup = ''; Message = 'Not installed, so there is nothing to refresh.' }
            continue
        }

        if ($row.Id -eq 'config' -and -not $IncludeConfig) {
            [PSCustomObject]@{
                Id = 'config'; Status = 'skipped'; Backup = ''
                Message = 'Your choices about what loads are kept. Pass -IncludeConfig to replace them.'
            }
            continue
        }

        $result = Install-ProfileSetupUnit -Unit $catalog[$row.Id] -Repository $Repository

        if ($result.Status -eq 'installed') {
            $result.Status = 'refreshed'
            Add-ProfileSetupReceiptEntry -Id $row.Id -Backup $result.Backup -Path $ReceiptPath
        }

        $result
    }
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/Uninstall.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup uninstall
#
# Dot-sourced by Setup.psm1.
#
# Removes only what the receipt says this installer added. Everything else is refused, including
# a tool that is plainly present, because being present is not the same as being ours.
#
# Three refusals are deliberate and none of them are errors:
#
#   not owned    the receipt has no entry, so someone else installed it
#   required     the profile cannot run without it
#   absent       there is nothing left to remove
#
# A file that displaced an existing one is restored from the backup rather than deleted, so
# uninstalling puts the user's own starship.toml back instead of leaving them with nothing.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Remove-ProfileSetupUnit {
    <#
    .SYNOPSIS
        Removes one unit and reports what happened.

    .DESCRIPTION
        Returns a result rather than throwing, so one failure does not abandon the rest of a
        selection. Status is one of removed, restored, skipped or failed.

    .PARAMETER Unit
        A row from Get-ProfileSetupCatalog.

    .PARAMETER Backup
        The displaced original recorded at install time, when there was one.

    .PARAMETER Manager
        The package manager that installed it, from the receipt.

    .OUTPUTS
        [PSCustomObject] Id, Status, Message.

    .EXAMPLE
        Remove-ProfileSetupUnit -Unit $unit -Backup $path -Manager Winget

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Unit,

        [Parameter()]
        [string]$Backup,

        [Parameter()]
        [string]$Manager
    )

    $result = [PSCustomObject]@{ Id = $Unit.Id; Status = 'failed'; Message = '' }

    try {
        switch ($Unit.Kind) {

            { $_ -in 'File', 'Tree' } {
                if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Remove')) {
                    $result.Status = 'skipped'
                    break
                }

                if (Test-Path -LiteralPath $Unit.Detect) {
                    Remove-Item -LiteralPath $Unit.Detect -Recurse -Force
                }

                if ($Backup -and (Test-Path -LiteralPath $Backup)) {
                    Move-Item -LiteralPath $Backup -Destination $Unit.Detect -Force
                    $result.Status = 'restored'
                    $result.Message = "Put back the file that was there before."
                }
                else {
                    $result.Status = 'removed'
                }
            }

            'Module' {
                if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Uninstall Gallery module')) {
                    $result.Status = 'skipped'
                    break
                }

                Uninstall-Module -Name $Unit.Detect -AllVersions -Force -ErrorAction Stop
                $result.Status = 'removed'
            }

            'Package' {
                $package = if ($Manager -eq 'Chocolatey') { $Unit.Chocolatey } else { $Unit.Winget }

                if (-not $package) {
                    $result.Status = 'skipped'
                    $result.Message = "No package id is recorded for $Manager."
                    break
                }

                if (-not $PSCmdlet.ShouldProcess($package, "$Manager uninstall")) {
                    $result.Status = 'skipped'
                    break
                }

                if ($Manager -eq 'Chocolatey') {
                    & choco uninstall $package -y --limit-output
                }
                else {
                    & winget uninstall --exact --id $package --silent
                }

                if ($LASTEXITCODE -ne 0) {
                    $result.Message = "$Manager exited with code $LASTEXITCODE."
                    break
                }

                $result.Status = 'removed'
            }

            'Font' {
                # Left in place on purpose. Windows keeps a font loaded until a restart, other
                # programs may have picked it up, and deleting from the machine font directory
                # needs elevation for a cosmetic gain.
                $result.Status = 'skipped'
                $result.Message = "Fonts are left installed. Remove $($Unit.Detect) from Settings if you want it gone."
            }

            default {
                $result.Message = "Unknown Kind '$($Unit.Kind)'."
            }
        }
    }
    catch {
        $result.Status = 'failed'
        $result.Message = $_.Exception.Message
    }

    return $result
}

function Uninstall-ProfileSetup {
    <#
    .SYNOPSIS
        Removes what this installer put on the machine, and nothing else.

    .DESCRIPTION
        Reads the receipt, not the machine. A unit is removed only when Get-ProfileSetupState
        reports it Removable: present, recorded as installed by this installer, and not Required.

        Everything else is reported with the reason it was left alone. On a machine where the
        profile was cloned rather than installed, that is every unit, and the correct outcome is
        that nothing is touched.

        -Confirm is on by default because this deletes files. Pass -Confirm:$false to run it
        unattended.

    .PARAMETER Id
        Catalog ids to remove. Omit to remove everything this installer owns.

    .PARAMETER Category
        Remove everything owned in these categories.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .OUTPUTS
        [PSCustomObject[]] One result per unit: Id, Status, Message.

    .EXAMPLE
        Uninstall-ProfileSetup -WhatIf
        Reports what it would remove without removing it.

    .EXAMPLE
        Uninstall-ProfileSetup -Id fzf
        Removes fzf, if this installer is the one that added it.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias('profile-uninstall')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]$Id,

        [Parameter()]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$ReceiptPath
    )

    begin {
        $selected = [System.Collections.Generic.List[string]]::new()
    }

    process {
        foreach ($name in @($Id)) { if ($name) { $selected.Add($name) } }
    }

    end {
        # Splatted rather than passed as arguments: [ValidateSet] rejects the $null an unbound
        # -Category arrives as, so the parameter has to be absent instead of empty.
        $filter = @{}
        if ($Category) { $filter['Category'] = $Category }
        if ($InstallPath) { $filter['InstallPath'] = $InstallPath }
        if ($ReceiptPath) { $filter['ReceiptPath'] = $ReceiptPath }

        $catalogFilter = @{}
        if ($InstallPath) { $catalogFilter['InstallPath'] = $InstallPath }

        $state = @(Get-ProfileSetupState @filter)
        $catalog = @{}
        foreach ($unit in (Get-ProfileSetupCatalog @catalogFilter)) { $catalog[$unit.Id] = $unit }

        if ($selected.Count) {
            $unknown = @($selected | Where-Object { -not $catalog.ContainsKey($_) })
            if ($unknown.Count) {
                throw "No such setup unit: $($unknown -join ', '). Run Get-ProfileSetupCatalog to see the ids."
            }
            $state = @($state | Where-Object { $_.Id -in $selected })
        }

        $entries = @{}
        foreach ($entry in (Get-ProfileSetupReceipt -Path $ReceiptPath).Entries) { $entries[$entry.Id] = $entry }

        foreach ($row in $state) {
            if (-not $row.Removable) {
                $reason = if ($row.Required) { 'Required by the profile.' }
                elseif (-not $row.Owned) { 'This installer did not install it, so it is not ours to remove.' }
                else { 'Not on this machine.' }

                [PSCustomObject]@{ Id = $row.Id; Status = 'skipped'; Message = $reason }
                continue
            }

            $entry = $entries[$row.Id]
            $result = Remove-ProfileSetupUnit -Unit $catalog[$row.Id] -Backup $entry.Backup -Manager $entry.Manager

            if ($result.Status -in 'removed', 'restored') {
                Remove-ProfileSetupReceiptEntry -Id $row.Id -Path $ReceiptPath
            }

            $result
        }
    }
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/Picker.ps1
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup picker
#
# Dot-sourced by Setup.psm1.
#
# A checkbox list in the console. It reads Get-ProfileSetupState and calls Invoke-ProfileSetup or
# Uninstall-ProfileSetup, so it holds no knowledge of what a unit is or how one installs.
#
# The console rather than a window, for the first front end: it works over SSH, inside Windows
# Terminal, in an editor's integrated shell, and a Pester run can drive it by handing it a
# selection instead of keystrokes. Format-ProfileSetupMenu and Resolve-ProfileSetupSelection are
# separate from Show-ProfileSetup for exactly that reason, and are the parts under test.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileSetupMenuOrder {
    <#
    .SYNOPSIS
        Returns the rows in the order the menu shows them.

    .DESCRIPTION
        The menu numbers rows by position, and Resolve-ProfileSetupSelection turns a number back
        into a row by index. Both have to see the same order or number 1 selects something other
        than the first line on screen, which installs the wrong thing silently.

        One function orders them so the two cannot disagree. Categories run in the order a person
        installs in: the profile itself, then the tools it drives, then what is optional.

    .PARAMETER State
        Rows from Get-ProfileSetupState.

    .OUTPUTS
        [PSCustomObject[]] The same rows, in display order.

    .EXAMPLE
        Get-ProfileSetupMenuOrder -State (Get-ProfileSetupState)

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

    $order = @{ Core = 0; Tool = 1; Module = 2; Config = 3; Font = 4; System = 5 }

    @($State | Sort-Object -Stable -Property @{ Expression = { $order[$_.Category] } })
}

function Format-ProfileSetupMenu {
    <#
    .SYNOPSIS
        Renders the state rows as a numbered menu.

    .DESCRIPTION
        Returns lines of text rather than writing them, so a test can read what the user would see.

        Numbers follow the order of the rows it is given. Pass the output of Get-ProfileSetupMenuOrder
        and pass those same rows to Resolve-ProfileSetupSelection, or the numbers on screen will
        not match the rows a number resolves to.

        The marker in each row says what the unit is, in one glyph:

          [x]  installed by this installer, so it can be removed again
          [=]  present, but installed by someone else. Left alone.
          [ ]  not on this machine
          [!]  recorded as installed but no longer here

    .PARAMETER State
        Rows from Get-ProfileSetupState.

    .OUTPUTS
        [string[]] The menu, one line per element.

    .EXAMPLE
        Format-ProfileSetupMenu -State (Get-ProfileSetupState)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$State,

        [Parameter()]
        [switch]$Plain
    )

    # Colour is opt-out so a test reads the words rather than the escape sequences, and so a
    # redirected host gets plain text. The palette is the night set from the brand identity.
    $brand = Get-ProfileSetupBrand -Mode Night
    $ink = if ($Plain -or -not (Test-ProfileSetupColor)) {
        @{ Reset = ''; Heading = ''; Accent = ''; Body = ''; Secondary = ''; Positive = '' }
    }
    else {
        $brand.Ansi
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $index = 0
    $category = ''

    foreach ($row in $State) {
        $index++

        if ($row.Category -ne $category) {
            $category = $row.Category
            $lines.Add('')
            $lines.Add(('{0}{1}{2}' -f $ink.Heading, $category.ToUpper(), $ink.Reset))
        }

        $marker = if ($row.Owned -and $row.Present) { '[x]' }
        elseif ($row.Owned) { '[!]' }
        elseif ($row.Present) { '[=]' }
        else { '[ ]' }

        $note = if ($row.Required) { 'required' }
        elseif ($row.Owned -and $row.Present) { 'installed by setup' }
        elseif ($row.Owned) { 'recorded, but missing' }
        elseif ($row.Present) { 'already on this machine' }
        else { '' }

        $markerInk = if ($row.Owned -and $row.Present) { $ink.Positive }
        elseif ($row.Owned) { $ink.Accent }
        elseif ($row.Present) { $ink.Secondary }
        else { $ink.Body }

        $lines.Add(('{0,3}. {1}{2}{3} {4,-28} {5}{6}{7}' -f $index, $markerInk, $marker, $ink.Reset, $row.Name, $ink.Secondary, $note, $ink.Reset).TrimEnd())
        $lines.Add(('      {0}{1}{2}' -f $ink.Body, $row.Description, $ink.Reset))
    }

    return @($lines)
}

function Resolve-ProfileSetupSelection {
    <#
    .SYNOPSIS
        Turns what a person typed into catalog ids.

    .DESCRIPTION
        Accepts numbers as shown in the menu, ids, category names, and the words all and none,
        separated by spaces or commas. A range is written 3-7.

        An entry that matches nothing is returned in Unknown rather than thrown, so the caller can
        say which word was not understood and ask again instead of ending the session.

    .PARAMETER Input
        What the person typed.

    .PARAMETER State
        The rows the menu was built from, in menu order.

    .OUTPUTS
        [PSCustomObject] Id, the resolved ids, and Unknown, the entries that matched nothing.

    .EXAMPLE
        Resolve-ProfileSetupSelection -InputText '1 3-5 tool' -State $state

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$InputText,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$State
    )

    $ordered = @($State)
    $ids = [System.Collections.Generic.List[string]]::new()
    $unknown = [System.Collections.Generic.List[string]]::new()

    if ([string]::IsNullOrWhiteSpace($InputText)) {
        return [PSCustomObject]@{ Id = @(); Unknown = @() }
    }

    foreach ($token in ($InputText -split '[\s,]+' | Where-Object { $_ })) {

        if ($token -eq 'none') { return [PSCustomObject]@{ Id = @(); Unknown = @() } }

        if ($token -eq 'all') {
            foreach ($row in $ordered) { $ids.Add($row.Id) }
            continue
        }

        if ($token -match '^(\d+)-(\d+)$') {
            $from = [int]$Matches[1]
            $to = [int]$Matches[2]
            if ($from -gt $to) { $from, $to = $to, $from }

            $any = $false
            for ($n = $from; $n -le $to; $n++) {
                if ($n -ge 1 -and $n -le $ordered.Count) {
                    $ids.Add($ordered[$n - 1].Id)
                    $any = $true
                }
            }
            if (-not $any) { $unknown.Add($token) }
            continue
        }

        if ($token -match '^\d+$') {
            $n = [int]$token
            if ($n -ge 1 -and $n -le $ordered.Count) { $ids.Add($ordered[$n - 1].Id) }
            else { $unknown.Add($token) }
            continue
        }

        $byId = @($ordered | Where-Object { $_.Id -eq $token })
        if ($byId.Count) {
            foreach ($row in $byId) { $ids.Add($row.Id) }
            continue
        }

        $byCategory = @($ordered | Where-Object { $_.Category -eq $token })
        if ($byCategory.Count) {
            foreach ($row in $byCategory) { $ids.Add($row.Id) }
            continue
        }

        $unknown.Add($token)
    }

    [PSCustomObject]@{
        Id      = @($ids | Select-Object -Unique)
        Unknown = @($unknown | Select-Object -Unique)
    }
}

function Show-ProfileSetup {
    <#
    .SYNOPSIS
        Lists what the profile can install, asks what you want, and does it.

    .DESCRIPTION
        Prints the catalog with its current state, reads a selection, and hands it to
        Invoke-ProfileSetup or Uninstall-ProfileSetup.

        Type numbers, ids, a category name, a range such as 3-7, all, or none. Prefix with
        "remove" to take units away instead of adding them. Enter on its own ends the session.

        Nothing is installed until the selection is confirmed, and the confirmation names every
        unit, so a mistyped range is visible before it runs.

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
        None. Writes to the host.

    .EXAMPLE
        Show-ProfileSetup
        Opens the picker.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-setup')]
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

    # Module/Setup sits two directories below the repository root.
    if (-not $Repository) { $Repository = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }

    $common = @{}
    if ($InstallPath) { $common['InstallPath'] = $InstallPath }
    if ($ReceiptPath) { $common['ReceiptPath'] = $ReceiptPath }

    # The identity palette, or empty strings on a host that would print the escape sequences as
    # literal text. Every use is a format argument, so blanking them removes the colour and
    # changes nothing else.
    $brand = Get-ProfileSetupBrand -Mode Night
    $reset = if (Test-ProfileSetupColor) { $brand.Ansi.Reset } else { '' }
    if (-not $reset) {
        foreach ($key in @($brand.Ansi.Keys)) { $brand.Ansi[$key] = '' }
    }

    while ($true) {
        # Ordered once, then used for both the menu and the selection, so a number on screen and
        # the row it resolves to cannot drift apart.
        $state = Get-ProfileSetupMenuOrder -State (Get-ProfileSetupState @common)

        Write-Host ''
        Write-Host ("{0}MKAbuMattar PowerShell profile setup{1}" -f $brand.Ansi.Heading, $reset)
        Write-Host ("{0}Installing into {1}{2}" -f $brand.Ansi.Secondary, (Get-ProfileSetupPath -InstallPath $InstallPath).InstallPath, $reset)

        foreach ($line in (Format-ProfileSetupMenu -State $state)) { Write-Host $line }

        Write-Host ''
        Write-Host '  [x] installed by setup   [=] already yours   [ ] not installed   [!] missing'
        Write-Host '  numbers, ids, a category, a range like 3-7, all, or none'
        Write-Host '  prefix with "remove" to take something off. Enter on its own to finish.'
        Write-Host ''

        $answer = Read-Host 'Select'
        if ([string]::IsNullOrWhiteSpace($answer)) { return }

        $removing = $answer -match '^\s*remove\b'
        if ($removing) { $answer = $answer -replace '^\s*remove\b', '' }

        $selection = Resolve-ProfileSetupSelection -InputText $answer -State $state

        if ($selection.Unknown.Count) {
            Write-Host ("{0}Not understood: {1}{2}" -f $brand.Ansi.Accent, ($selection.Unknown -join ', '), $reset)
        }

        if (-not $selection.Id.Count) { continue }

        $verb = if ($removing) { 'Remove' } else { 'Install' }
        $names = @($state | Where-Object { $_.Id -in $selection.Id } | ForEach-Object { $_.Name })

        Write-Host ''
        Write-Host ("{0}:" -f $verb)
        foreach ($name in $names) { Write-Host ("  {0}" -f $name) }
        Write-Host ''

        if ((Read-Host "$verb these? [y/N]") -notmatch '^y') { continue }

        $results = if ($removing) {
            Uninstall-ProfileSetup -Id $selection.Id @common -Confirm:$false
        }
        else {
            Invoke-ProfileSetup -Id $selection.Id -Repository $Repository -PackageManager $PackageManager @common -Confirm:$false
        }

        Write-Host ''
        foreach ($result in $results) {
            $ink = switch ($result.Status) {
                'installed' { $brand.Ansi.Positive }
                'restored' { $brand.Ansi.Positive }
                'removed' { $brand.Ansi.Positive }
                'present' { $brand.Ansi.Secondary }
                'skipped' { $brand.Ansi.Accent }
                default { $brand.Ansi.Tertiary }
            }
            Write-Host ("{0}  {1,-22} {2,-10} {3}{4}" -f $ink, $result.Id, $result.Status, $result.Message, $reset)
        }
    }
}


#---------------------------------------------------------------------------------------------------
# Module/Setup/Window.ps1
#---------------------------------------------------------------------------------------------------

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


#---------------------------------------------------------------------------------------------------
# Launcher
#---------------------------------------------------------------------------------------------------

function Get-ProfileInstallerRepository {
    <#
    .SYNOPSIS
        Downloads the repository the file and directory units are copied from.

    .DESCRIPTION
        $PSScriptRoot is empty when a script arrives through Invoke-Expression, so there is no
        checkout beside this file to copy from. The archive is fetched into a temporary
        directory and its path returned.

    .OUTPUTS
        [string] Path to the extracted repository.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string]$Branch = 'main',

        [Parameter()]
        [switch]$Real,

        [Parameter()]
        [switch]$Sandbox
    )

    $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-installer-" + [guid]::NewGuid().ToString('N'))
    $archive = "$workspace.tar.gz"
    $null = New-Item -ItemType Directory -Path $workspace -Force

    Write-Host "Downloading the profile..."
    Invoke-WebRequest -Uri "https://codeload.github.com/MKAbuMattar/powershell-profile/tar.gz/refs/heads/$Branch" -OutFile $archive -UseBasicParsing

    & tar -xzf $archive -C $workspace
    if ($LASTEXITCODE -ne 0) { throw "tar exited with code $LASTEXITCODE." }

    Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue

    $extracted = Get-ChildItem -LiteralPath $workspace -Directory | Select-Object -First 1
    if (-not $extracted) { throw "The archive did not contain the expected directory." }

    return $extracted.FullName
}

function Invoke-ProfileInstaller {
    <#
    .SYNOPSIS
        Opens the picker.

    .DESCRIPTION
        The window when this host can show one, the console list otherwise. -Console forces the
        console list.

    .PARAMETER Console
        Use the console picker even where a window would work.

    .PARAMETER Branch
        Repository branch to install from.

    .OUTPUTS
        None.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter()]
        [switch]$Console,

        [Parameter()]
        [string]$Branch = 'main'
    )

    # The first run on a machine goes into a throwaway directory, so a wrong click costs
    # nothing while you are still finding out what the buttons do. Every run after that
    # installs for real. -Real and -Sandbox override it.
    $mode = Get-ProfileSetupMode -Real:$Real -Sandbox:$Sandbox
    Write-ProfileSetupMode -Mode $mode

    $target = @{}
    if ($mode.InstallPath) { $target['InstallPath'] = $mode.InstallPath }
    if ($mode.ReceiptPath) { $target['ReceiptPath'] = $mode.ReceiptPath }

    $repository = Get-ProfileInstallerRepository -Branch $Branch

    # Written before the picker opens, so closing it without installing anything still
    # counts as having seen the list.
    Set-ProfileSetupSeen -Repository $repository -Confirm:$false

    if (-not $Console -and (Get-ProfileSetupWindowSupport).Supported) {
        Show-ProfileSetupWindow -Repository $repository @target
    }
    else {
        Show-ProfileSetup -Repository $repository @target
    }
}

Invoke-ProfileInstaller -Console:$Console -Branch $Branch -Real:$Real -Sandbox:$Sandbox
