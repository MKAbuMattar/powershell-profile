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
#   Font      a font file in the Windows font directory.
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
            Kind = 'Tree'; Detect = $path.ModuleTree; Step = 'Modules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'tool-tree'; Name = 'Maintenance scripts'; Category = 'Core'; Required = $true
            Description = 'The Tools directory. The loader reads its export policy from here.'
            Kind = 'Tree'; Detect = $path.ToolTree; Step = 'Modules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'profile'; Name = 'PowerShell profile'; Category = 'Core'; Required = $true
            Description = 'Microsoft.PowerShell_profile.ps1, installed over $PROFILE.'
            Kind = 'File'; Detect = $path.Profile; Step = 'Profile'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'config'; Name = 'Load configuration'; Category = 'Core'; Required = $true
            Description = 'profile.config.psd1, which decides what loads.'
            Kind = 'File'; Detect = $path.Config; Step = 'Modules'; Winget = $null; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'starship-config'; Name = 'Starship configuration'; Category = 'Config'; Required = $false
            Description = 'The prompt layout at ~/.config/starship.toml.'
            Kind = 'File'; Detect = $path.Starship; Step = 'Starship'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'fastfetch-config'; Name = 'FastFetch configuration'; Category = 'Config'; Required = $false
            Description = 'The system summary layout at ~/.config/fastfetch/config.jsonc.'
            Kind = 'File'; Detect = $path.FastFetch; Step = 'FastFetch'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'figlet-font'; Name = 'Figlet banner font'; Category = 'Config'; Required = $false
            Description = 'ANSI_Shadow.flf, used for banner text.'
            Kind = 'File'; Detect = $path.Figlet; Step = 'Figlet'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'windows-terminal'; Name = 'Windows Terminal settings'; Category = 'Config'; Required = $false
            Description = 'Replaces settings.json. Your existing file is backed up first.'
            Kind = 'File'; Detect = $path.WindowsTerminal; Step = 'WindowsTerminal'; Winget = $null; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'starship'; Name = 'Starship'; Category = 'Tool'; Required = $false
            Description = 'The prompt itself. Without it the profile falls back to the default prompt.'
            Kind = 'Package'; Detect = 'starship'; Step = 'Tools'; Winget = 'Starship.Starship'; Chocolatey = 'starship'
        }
        [PSCustomObject]@{
            Id = 'zoxide'; Name = 'zoxide'; Category = 'Tool'; Required = $false
            Description = 'Directory jumping. Replaces cd with a version that learns.'
            Kind = 'Package'; Detect = 'zoxide'; Step = 'Tools'; Winget = 'ajeetdsouza.zoxide'; Chocolatey = 'zoxide'
        }
        [PSCustomObject]@{
            Id = 'fzf'; Name = 'fzf'; Category = 'Tool'; Required = $false
            Description = 'Fuzzy finder, used by the history and file pickers.'
            Kind = 'Package'; Detect = 'fzf'; Step = 'Tools'; Winget = 'junegunn.fzf'; Chocolatey = 'fzf'
        }
        [PSCustomObject]@{
            Id = 'fastfetch'; Name = 'FastFetch'; Category = 'Tool'; Required = $false
            Description = 'System summary printed at start, if you enable it in the profile.'
            Kind = 'Package'; Detect = 'fastfetch'; Step = 'Tools'; Winget = 'Fastfetch-cli.Fastfetch'; Chocolatey = 'fastfetch'
        }

        [PSCustomObject]@{
            Id = 'coreutils'; Name = 'Microsoft coreutils'; Category = 'System'; Required = $false
            Description = 'GNU tools as native commands. Takes the grep, head, tail, touch and sed names.'
            Kind = 'Package'; Detect = 'coreutils'; Step = 'Coreutils'; Winget = 'Microsoft.Coreutils'; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'terminal-icons'; Name = 'Terminal-Icons'; Category = 'Module'; Required = $false
            Description = 'File-type icons in Get-ChildItem. Costs about 250 ms, so it loads after the first prompt.'
            Kind = 'Module'; Detect = 'Terminal-Icons'; Step = 'GalleryModules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'psreadline'; Name = 'PSReadLine'; Category = 'Module'; Required = $false
            Description = 'Line editing, history and prediction. Ships with PowerShell; this updates it.'
            Kind = 'Module'; Detect = 'PSReadLine'; Step = 'GalleryModules'; Winget = $null; Chocolatey = $null
        }
        [PSCustomObject]@{
            Id = 'completion-predictor'; Name = 'CompletionPredictor'; Category = 'Module'; Required = $false
            Description = 'Predictions drawn from your command history.'
            Kind = 'Module'; Detect = 'CompletionPredictor'; Step = 'GalleryModules'; Winget = $null; Chocolatey = $null
        }

        [PSCustomObject]@{
            Id = 'cascadia-code'; Name = 'CascadiaCode Nerd Font'; Category = 'Font'; Required = $false
            Description = 'The glyphs the prompt draws with. Without it the prompt shows boxes.'
            Kind = 'Font'; Detect = 'CaskaydiaCove NF'; Step = 'Font'; Winget = $null; Chocolatey = $null
        }
    )

    if ($Category) {
        $rows = @($rows | Where-Object { $_.Category -in $Category })
    }

    return $rows
}
