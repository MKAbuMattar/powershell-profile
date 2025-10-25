#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - UV Plugin
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This module provides UV (Python package manager) CLI shortcuts and utility functions
#       for modern Python dependency management, virtual environment handling, and project
#       workflows in PowerShell environments. Converts 25+ common UV operations to PowerShell
#       functions with full parameter support and comprehensive Python project management.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function Get-UVProjectInfo {
    <#
    .SYNOPSIS
        Gets UV project information.

    .DESCRIPTION
        Retrieves information about the current UV project including dependencies,
        virtual environment status, and project configuration.

    .OUTPUTS
        System.Object
        Project information object or $null if not in a UV project.

    .EXAMPLE
        Get-UVProjectInfo
        Returns project information for the current UV project.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    try {
        $projectInfo = [PSCustomObject]@{
            IsUVProject      = $true
            ProjectPath      = $PWD.Path
            HasPyprojectToml = Test-Path "pyproject.toml"
            HasUVLock        = Test-Path "uv.lock"
            HasVirtualEnv    = $false
            VirtualEnvPath   = $null
        }

        $venvPath = Get-UVVirtualEnvPath
        if ($venvPath -and (Test-Path $venvPath)) {
            $projectInfo.HasVirtualEnv = $true
            $projectInfo.VirtualEnvPath = $venvPath
        }

        return $projectInfo
    }
    catch {
        return $null
    }
}

function Get-UVVirtualEnvPath {
    <#
    .SYNOPSIS
        Gets the path to the UV virtual environment.

    .DESCRIPTION
        Returns the path to the virtual environment created by UV for the current project.

    .OUTPUTS
        System.String
        Path to virtual environment or $null if not found.

    .EXAMPLE
        Get-UVVirtualEnvPath
        Returns the path to the current project's virtual environment.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $commonPaths = @(
            ".venv",
            "venv",
            ".env"
        )

        foreach ($path in $commonPaths) {
            $fullPath = Join-Path $PWD.Path $path
            if (Test-Path $fullPath -PathType Container) {
                return $fullPath
            }
        }

        return $null
    }
    catch {
        return $null
    }
}

function Invoke-UVAdd {
    <#
    .SYNOPSIS
        Add dependencies to UV project.

    .DESCRIPTION
        Adds one or more dependencies to the current UV project.
        Equivalent to 'uv add' or 'uva' shortcut.

    .PARAMETER Packages
        Package names to add to the project.

    .PARAMETER Arguments
        Additional arguments to pass to uv add.

    .EXAMPLE
        Invoke-UVAdd requests flask
        Adds requests and flask packages to the project.

    .EXAMPLE
        uva "django>=4.0" --dev
        Adds Django as a development dependency using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uva")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    $allArgs = @('add') + $Packages
    & uv @allArgs
}

function Invoke-UVRemove {
    <#
    .SYNOPSIS
        Remove dependencies from UV project.

    .DESCRIPTION
        Removes one or more dependencies from the current UV project.
        Equivalent to 'uv remove' or 'uvrm' shortcut.

    .PARAMETER Packages
        Package names to remove from the project.

    .PARAMETER Arguments
        Additional arguments to pass to uv remove.

    .EXAMPLE
        Invoke-UVRemove requests
        Removes requests package from the project.

    .EXAMPLE
        uvrm flask django
        Removes multiple packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvrm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    $allArgs = @('remove') + $Packages
    & uv @allArgs
}

function Invoke-UVSync {
    <#
    .SYNOPSIS
        Synchronize UV project dependencies.

    .DESCRIPTION
        Synchronizes the project environment with the lock file.
        Equivalent to 'uv sync' or 'uvs' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv sync.

    .EXAMPLE
        Invoke-UVSync
        Synchronizes project dependencies.

    .EXAMPLE
        uvs --dev
        Synchronizes including development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvs")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('sync') + $Arguments
    & uv @allArgs
}

function Invoke-UVSyncRefresh {
    <#
    .SYNOPSIS
        Synchronize UV project with refresh.

    .DESCRIPTION
        Synchronizes the project environment with refresh to update dependencies.
        Equivalent to 'uv sync --refresh' or 'uvsr' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv sync --refresh.

    .EXAMPLE
        Invoke-UVSyncRefresh
        Synchronizes with dependency refresh.

    .EXAMPLE
        uvsr --dev
        Refreshes sync including development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvsr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('sync', '--refresh') + $Arguments
    & uv @allArgs
}

function Invoke-UVSyncUpgrade {
    <#
    .SYNOPSIS
        Synchronize UV project with upgrade.

    .DESCRIPTION
        Synchronizes the project environment with upgrade to latest compatible versions.
        Equivalent to 'uv sync --upgrade' or 'uvsu' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv sync --upgrade.

    .EXAMPLE
        Invoke-UVSyncUpgrade
        Synchronizes with dependency upgrades.

    .EXAMPLE
        uvsu --dev
        Upgrades sync including development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvsu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('sync', '--upgrade') + $Arguments
    & uv @allArgs
}

function Invoke-UVLock {
    <#
    .SYNOPSIS
        Create or update UV lock file.

    .DESCRIPTION
        Creates or updates the uv.lock file with current dependency resolution.
        Equivalent to 'uv lock' or 'uvl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv lock.

    .EXAMPLE
        Invoke-UVLock
        Creates or updates the lock file.

    .EXAMPLE
        uvl --upgrade
        Updates lock file with upgrades using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('lock') + $Arguments
    & uv @allArgs
}

function Invoke-UVLockRefresh {
    <#
    .SYNOPSIS
        Refresh UV lock file.

    .DESCRIPTION
        Refreshes the lock file by re-resolving dependencies.
        Equivalent to 'uv lock --refresh' or 'uvlr' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv lock --refresh.

    .EXAMPLE
        Invoke-UVLockRefresh
        Refreshes the lock file resolution.

    .EXAMPLE
        uvlr
        Refreshes lock file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvlr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('lock', '--refresh') + $Arguments
    & uv @allArgs
}

function Invoke-UVLockUpgrade {
    <#
    .SYNOPSIS
        Upgrade UV lock file.

    .DESCRIPTION
        Upgrades dependencies in the lock file to latest compatible versions.
        Equivalent to 'uv lock --upgrade' or 'uvlu' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv lock --upgrade.

    .EXAMPLE
        Invoke-UVLockUpgrade
        Upgrades dependencies in lock file.

    .EXAMPLE
        uvlu
        Upgrades lock file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvlu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('lock', '--upgrade') + $Arguments
    & uv @allArgs
}

function Invoke-UVExport {
    <#
    .SYNOPSIS
        Export UV dependencies to requirements format.

    .DESCRIPTION
        Exports project dependencies to requirements.txt format.
        Equivalent to 'uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet' or 'uvexp' shortcut.

    .PARAMETER OutputFile
        Output file path for requirements. Defaults to requirements.txt.

    .PARAMETER Arguments
        Additional arguments to pass to uv export.

    .EXAMPLE
        Invoke-UVExport
        Exports to requirements.txt.

    .EXAMPLE
        uvexp -OutputFile dev-requirements.txt --dev
        Exports development dependencies to specific file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvexp")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$OutputFile = "requirements.txt",

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('export', '--format', 'requirements-txt', '--no-hashes', '--output-file', $OutputFile, '--quiet') + $Arguments
    & uv @allArgs
}

function Invoke-UVRun {
    <#
    .SYNOPSIS
        Run command in UV environment.

    .DESCRIPTION
        Runs a command or script in the UV project environment.
        Equivalent to 'uv run' or 'uvr' shortcut.

    .PARAMETER Command
        Command or script to run.

    .PARAMETER Arguments
        Arguments to pass to the command.

    .EXAMPLE
        Invoke-UVRun python script.py
        Runs Python script in UV environment.

    .EXAMPLE
        uvr pytest
        Runs pytest using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvr")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Command = @()
    )

    $allArgs = @('run') + $Command
    & uv @allArgs
}

function Invoke-UVPython {
    <#
    .SYNOPSIS
        Manage Python versions with UV.

    .DESCRIPTION
        Manages Python versions using UV's Python version management.
        Equivalent to 'uv python' or 'uvpy' shortcut.

    .PARAMETER Arguments
        Arguments to pass to uv python command.

    .EXAMPLE
        Invoke-UVPython install 3.12
        Installs Python 3.12.

    .EXAMPLE
        uvpy list
        Lists available Python versions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvpy")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('python') + $Arguments
    & uv @allArgs
}

function Invoke-UVPip {
    <#
    .SYNOPSIS
        Use pip functionality through UV.

    .DESCRIPTION
        Provides pip-compatible interface through UV for package management.
        Equivalent to 'uv pip' or 'uvp' shortcut.

    .PARAMETER Arguments
        Arguments to pass to uv pip command.

    .EXAMPLE
        Invoke-UVPip install requests
        Installs requests using UV's pip interface.

    .EXAMPLE
        uvp list
        Lists installed packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('pip') + $Arguments
    & uv @allArgs
}

function Invoke-UVVenv {
    <#
    .SYNOPSIS
        Create virtual environment with UV.

    .DESCRIPTION
        Creates a virtual environment using UV.
        Equivalent to 'uv venv' or 'uvv' shortcut.

    .PARAMETER Name
        Name or path for the virtual environment.

    .PARAMETER Arguments
        Additional arguments to pass to uv venv.

    .EXAMPLE
        Invoke-UVVenv
        Creates virtual environment in .venv.

    .EXAMPLE
        uvv myenv --python 3.12
        Creates named virtual environment with specific Python version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvv")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Name,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('venv')
    if ($Name) {
        $allArgs += $Name
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & uv @allArgs
}

function Invoke-UVInit {
    <#
    .SYNOPSIS
        Initialize new UV project.

    .DESCRIPTION
        Initializes a new UV project with pyproject.toml configuration.
        Equivalent to 'uv init' or 'uvi' shortcut.

    .PARAMETER ProjectName
        Name of the project to initialize.

    .PARAMETER Arguments
        Additional arguments to pass to uv init.

    .EXAMPLE
        Invoke-UVInit
        Initializes UV project in current directory.

    .EXAMPLE
        uvi myproject --lib
        Initializes library project using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvi")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ProjectName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init')
    if ($ProjectName) {
        $allArgs += $ProjectName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & uv @allArgs
}

function Invoke-UVBuild {
    <#
    .SYNOPSIS
        Build UV project.

    .DESCRIPTION
        Builds the UV project creating distribution packages.
        Equivalent to 'uv build' or 'uvb' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv build.

    .EXAMPLE
        Invoke-UVBuild
        Builds the project.

    .EXAMPLE
        uvb --wheel
        Builds wheel distribution using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('build') + $Arguments
    & uv @allArgs
}

function Invoke-UVPublish {
    <#
    .SYNOPSIS
        Publish UV project.

    .DESCRIPTION
        Publishes the UV project to a package repository.
        Equivalent to 'uv publish' or 'uvpub' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv publish.

    .EXAMPLE
        Invoke-UVPublish
        Publishes the project to PyPI.

    .EXAMPLE
        uvpub --repository testpypi
        Publishes to test PyPI using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvpub")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('publish') + $Arguments
    & uv @allArgs
}

function Invoke-UVTool {
    <#
    .SYNOPSIS
        Manage UV tools.

    .DESCRIPTION
        Manages Python tools using UV's tool management system.
        Equivalent to 'uv tool' or 'uvt' shortcut.

    .PARAMETER Arguments
        Arguments to pass to uv tool command.

    .EXAMPLE
        Invoke-UVTool list
        Lists installed tools.

    .EXAMPLE
        uvt install black
        Installs black formatter tool using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('tool') + $Arguments
    & uv @allArgs
}

function Invoke-UVToolRun {
    <#
    .SYNOPSIS
        Run tool with UV.

    .DESCRIPTION
        Runs a Python tool using UV, equivalent to uvx.
        Equivalent to 'uv tool run' or 'uvtr'/'uvx' shortcuts.

    .PARAMETER Tool
        Tool name to run.

    .PARAMETER Arguments
        Arguments to pass to the tool.

    .EXAMPLE
        Invoke-UVToolRun black .
        Runs black formatter on current directory.

    .EXAMPLE
        uvx pytest
        Runs pytest using uvx alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvtr", "uvx")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Tool = @()
    )

    $allArgs = @('tool', 'run') + $Tool
    & uv @allArgs
}

function Invoke-UVToolInstall {
    <#
    .SYNOPSIS
        Install tool with UV.

    .DESCRIPTION
        Installs a Python tool using UV's tool management.
        Equivalent to 'uv tool install' or 'uvti' shortcut.

    .PARAMETER Tools
        Tool names to install.

    .PARAMETER Arguments
        Additional arguments to pass to uv tool install.

    .EXAMPLE
        Invoke-UVToolInstall black
        Installs black formatter tool.

    .EXAMPLE
        uvti pytest flake8
        Installs multiple tools using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvti")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Tools = @()
    )

    $allArgs = @('tool', 'install') + $Tools
    & uv @allArgs
}

function Invoke-UVToolUninstall {
    <#
    .SYNOPSIS
        Uninstall tool with UV.

    .DESCRIPTION
        Uninstalls a Python tool using UV's tool management.
        Equivalent to 'uv tool uninstall' or 'uvtu' shortcut.

    .PARAMETER Tools
        Tool names to uninstall.

    .PARAMETER Arguments
        Additional arguments to pass to uv tool uninstall.

    .EXAMPLE
        Invoke-UVToolUninstall black
        Uninstalls black formatter tool.

    .EXAMPLE
        uvtu pytest flake8
        Uninstalls multiple tools using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvtu")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Tools = @()
    )

    $allArgs = @('tool', 'uninstall') + $Tools
    & uv @allArgs
}

function Invoke-UVToolList {
    <#
    .SYNOPSIS
        List installed UV tools.

    .DESCRIPTION
        Lists all installed Python tools managed by UV.
        Equivalent to 'uv tool list' or 'uvtl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv tool list.

    .EXAMPLE
        Invoke-UVToolList
        Lists all installed tools.

    .EXAMPLE
        uvtl
        Lists tools using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvtl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('tool', 'list') + $Arguments
    & uv @allArgs
}

function Invoke-UVToolUpgrade {
    <#
    .SYNOPSIS
        Upgrade UV tools.

    .DESCRIPTION
        Upgrades installed Python tools to their latest versions.
        Equivalent to 'uv tool upgrade' or 'uvtup' shortcut.

    .PARAMETER Tools
        Specific tool names to upgrade. If not specified, upgrades all tools.

    .PARAMETER Arguments
        Additional arguments to pass to uv tool upgrade.

    .EXAMPLE
        Invoke-UVToolUpgrade
        Upgrades all installed tools.

    .EXAMPLE
        uvtup black
        Upgrades specific tool using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvtup")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Tools = @()
    )

    $allArgs = @('tool', 'upgrade')
    if ($Tools.Count -gt 0) {
        $allArgs += $Tools
    }
    else {
        $allArgs += '--all'
    }

    & uv @allArgs
}

function Invoke-UVSelfUpdate {
    <#
    .SYNOPSIS
        Update UV itself.

    .DESCRIPTION
        Updates UV to the latest version.
        Equivalent to 'uv self update' or 'uvup' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv self update.

    .EXAMPLE
        Invoke-UVSelfUpdate
        Updates UV to latest version.

    .EXAMPLE
        uvup
        Updates UV using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvup")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('self', 'update') + $Arguments
    & uv @allArgs
}

function Invoke-UVVersion {
    <#
    .SYNOPSIS
        Show UV version.

    .DESCRIPTION
        Displays the version of UV.
        Equivalent to 'uv --version' or 'uvver' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to uv version.

    .EXAMPLE
        Invoke-UVVersion
        Shows UV version.

    .EXAMPLE
        uvver
        Shows version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md
    #>
    [CmdletBinding()]
    [Alias("uvver")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('--version') + $Arguments
    & uv @allArgs
}
