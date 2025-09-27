#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PIP Plugin
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
#       This module provides pip CLI shortcuts and utility functions for improved Python
#       package management workflow in PowerShell environments. Converts 25+ common pip
#       aliases from zsh/bash to PowerShell functions with full parameter support.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Test-PipInstalled {
    <#
    .SYNOPSIS
        Tests if pip is installed and accessible.

    .DESCRIPTION
        Checks if pip command is available in the current environment and validates basic functionality.
        Prefers pip3 over pip if pip is not available but pip3 is.

    .OUTPUTS
        System.Boolean
        Returns $true if pip is available, $false otherwise.

    .EXAMPLE
        Test-PipInstalled
        Returns $true if pip is installed and accessible.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $pipCommand = $null
        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            $pipCommand = 'pip3'
        }
        elseif (Get-Command pip -ErrorAction SilentlyContinue) {
            $pipCommand = 'pip'
        }

        if ($pipCommand) {
            $null = & $pipCommand --version 2>$null
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}

function Get-PipCommand {
    <#
    .SYNOPSIS
        Gets the appropriate pip command to use.

    .DESCRIPTION
        Returns pip3 if pip is not available but pip3 is, otherwise returns pip.
        Used internally by other pip functions.

    .OUTPUTS
        System.String
        Returns the pip command to use.

    .EXAMPLE
        Get-PipCommand
        Returns 'pip3' or 'pip' based on availability.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (Get-Command pip3 -ErrorAction SilentlyContinue) {
        if (-not (Get-Command pip -ErrorAction SilentlyContinue)) {
            return 'pip3'
        }
    }
    return 'pip'
}

function Get-PipCacheFile {
    <#
    .SYNOPSIS
        Gets the pip cache file path.

    .DESCRIPTION
        Returns the appropriate cache file path for pip package caching,
        following XDG cache directory standards when available.

    .OUTPUTS
        System.String
        Returns the path to the pip cache file.

    .EXAMPLE
        Get-PipCacheFile
        Returns the pip cache file path.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $cacheDir = $env:XDG_CACHE_HOME
    if (-not $cacheDir) {
        $cacheDir = Join-Path $env:USERPROFILE '.cache'
    }

    $pipCacheDir = Join-Path $cacheDir 'pip'
    if (Test-Path $pipCacheDir) {
        return Join-Path $pipCacheDir 'powershell-cache'
    }
    else {
        return Join-Path $env:USERPROFILE '.pip\powershell-cache'
    }
}

function Clear-PipCache {
    <#
    .SYNOPSIS
        Clears the pip package cache.

    .DESCRIPTION
        Removes the pip package cache file used for PowerShell completion
        and package indexing.

    .EXAMPLE
        Clear-PipCache
        Clears the pip package cache.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $cacheFile = Get-PipCacheFile
    if (Test-Path $cacheFile) {
        Remove-Item $cacheFile -Force
        Write-Host "Pip cache cleared." -ForegroundColor Green
    }
    else {
        Write-Host "No pip cache found." -ForegroundColor Yellow
    }
}

function Update-PipPackageCache {
    <#
    .SYNOPSIS
        Updates the pip package cache for completion.

    .DESCRIPTION
        Caches package names from PyPI for improved completion performance.
        This function is automatically called when needed.

    .EXAMPLE
        Update-PipPackageCache
        Updates the pip package cache.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $cacheFile = Get-PipCacheFile
    $cacheDir = Split-Path $cacheFile -Parent

    if (-not (Test-Path $cacheDir)) {
        New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
    }

    if (-not (Test-Path $cacheFile)) {
        Write-Host "Caching package index..." -NoNewline -ForegroundColor Yellow
        try {
            $packages = @(
                'requests', 'numpy', 'pandas', 'matplotlib', 'flask', 'django',
                'scikit-learn', 'tensorflow', 'torch', 'jupyter', 'ipython',
                'pytest', 'black', 'flake8', 'mypy', 'setuptools', 'wheel',
                'pip', 'virtualenv', 'pipenv', 'poetry', 'tox'
            )
            $packages | Out-File -FilePath $cacheFile -Encoding UTF8
            Write-Host " Done." -ForegroundColor Green
        }
        catch {
            Write-Host " Failed." -ForegroundColor Red
            Write-Warning "Could not cache pip packages: $($_.Exception.Message)"
        }
    }
}

function Initialize-PipCompletion {
    <#
    .SYNOPSIS
        Initializes pip completion for PowerShell.

    .DESCRIPTION
        Sets up pip command completion for PowerShell to provide tab completion for pip commands
        and packages. This function is automatically called when the module is imported.

    .EXAMPLE
        Initialize-PipCompletion
        Sets up pip completion for the current PowerShell session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-PipInstalled)) {
        return
    }

    try {
        Update-PipPackageCache
        
        Register-ArgumentCompleter -CommandName 'pip', 'pip3', 'Invoke-Pip' -ScriptBlock {
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            
            $cacheFile = Get-PipCacheFile
            if (Test-Path $cacheFile) {
                Get-Content $cacheFile | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            }
        }
    }
    catch {
        Write-Verbose "pip completion initialization failed: $($_.Exception.Message)"
    }
}

function Invoke-Pip {
    <#
    .SYNOPSIS
        Base pip command wrapper.

    .DESCRIPTION
        Executes pip commands with all provided arguments. Serves as the base wrapper
        for all pip operations and ensures pip is available before execution.

    .PARAMETER Arguments
        All arguments to pass to pip command.

    .EXAMPLE
        Invoke-Pip --version
        Shows pip version.

    .EXAMPLE
        Invoke-Pip install requests
        Installs the requests package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pip")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    & $pipCmd @Arguments
}

function Invoke-PipInstall {
    <#
    .SYNOPSIS
        Install Python packages using pip.

    .DESCRIPTION
        Installs Python packages using 'pip install' command.
        Equivalent to 'pip install' or 'pipi' shortcut.

    .PARAMETER PackageName
        Name of the package to install.

    .PARAMETER Arguments
        Additional arguments to pass to pip install.

    .EXAMPLE
        Invoke-PipInstall requests
        Installs the requests package.

    .EXAMPLE
        pipi numpy pandas
        Installs multiple packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipi")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('install')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & $pipCmd @allArgs
}

function Invoke-PipUpgrade {
    <#
    .SYNOPSIS
        Upgrade Python packages using pip.

    .DESCRIPTION
        Upgrades Python packages using 'pip install --upgrade' command.
        Equivalent to 'pip install --upgrade' or 'pipu' shortcut.

    .PARAMETER PackageName
        Name of the package to upgrade.

    .PARAMETER Arguments
        Additional arguments to pass to pip upgrade.

    .EXAMPLE
        Invoke-PipUpgrade requests
        Upgrades the requests package.

    .EXAMPLE
        pipu numpy
        Upgrades numpy using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipu")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('install', '--upgrade')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & $pipCmd @allArgs
}

function Invoke-PipUninstall {
    <#
    .SYNOPSIS
        Uninstall Python packages using pip.

    .DESCRIPTION
        Uninstalls Python packages using 'pip uninstall' command.
        Equivalent to 'pip uninstall' or 'pipun' shortcut.

    .PARAMETER PackageName
        Name of the package to uninstall.

    .PARAMETER Arguments
        Additional arguments to pass to pip uninstall.

    .EXAMPLE
        Invoke-PipUninstall requests
        Uninstalls the requests package.

    .EXAMPLE
        pipun old-package
        Uninstalls package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipun")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('uninstall')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & $pipCmd @allArgs
}

function Invoke-PipInstallUser {
    <#
    .SYNOPSIS
        Install Python packages for current user only.

    .DESCRIPTION
        Installs Python packages using 'pip install --user' command.
        Installs packages to user site-packages directory.

    .PARAMETER Arguments
        Arguments to pass to pip install --user.

    .EXAMPLE
        Invoke-PipInstallUser requests
        Installs requests for current user only.

    .EXAMPLE
        pipiu numpy
        Installs numpy for user using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipiu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('install', '--user') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipInstallEditable {
    <#
    .SYNOPSIS
        Install package in editable/development mode.

    .DESCRIPTION
        Installs package in editable mode using 'pip install -e' command.
        Useful for development when you want changes to be immediately available.

    .PARAMETER Arguments
        Arguments to pass to pip install -e.

    .EXAMPLE
        Invoke-PipInstallEditable .
        Installs current directory package in editable mode.

    .EXAMPLE
        pipie /path/to/package
        Installs package in editable mode using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipie")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('install', '-e') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipFreeze {
    <#
    .SYNOPSIS
        Show installed packages and their versions.

    .DESCRIPTION
        Lists installed packages in requirements format using 'pip freeze'.
        Useful for creating requirements files.

    .PARAMETER Arguments
        Additional arguments to pass to pip freeze.

    .EXAMPLE
        Invoke-PipFreeze
        Shows all installed packages with versions.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('freeze') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipFreezeGrep {
    <#
    .SYNOPSIS
        Search installed packages using grep pattern.

    .DESCRIPTION
        Combines pip freeze with grep functionality to search for specific packages.
        Equivalent to 'pip freeze | grep' or 'pipgi' shortcut.

    .PARAMETER Pattern
        Pattern to search for in package names.

    .EXAMPLE
        Invoke-PipFreezeGrep requests
        Searches for packages containing 'requests'.

    .EXAMPLE
        pipgi numpy
        Searches for numpy-related packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipgi")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Pattern
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    & $pipCmd freeze | Where-Object { $_ -match $Pattern }
}

function Invoke-PipListOutdated {
    <#
    .SYNOPSIS
        List outdated packages.

    .DESCRIPTION
        Shows packages that have newer versions available using 'pip list -o'.
        Equivalent to 'pip list --outdated' or 'piplo' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pip list.

    .EXAMPLE
        Invoke-PipListOutdated
        Shows all outdated packages.

    .EXAMPLE
        piplo
        Shows outdated packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("piplo")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('list', '--outdated') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipList {
    <#
    .SYNOPSIS
        List installed packages.

    .DESCRIPTION
        Lists all installed packages using 'pip list' command.

    .PARAMETER Arguments
        Additional arguments to pass to pip list.

    .EXAMPLE
        Invoke-PipList
        Lists all installed packages.

    .EXAMPLE
        pipl --format=json
        Lists packages in JSON format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('list') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipShow {
    <#
    .SYNOPSIS
        Show package information.

    .DESCRIPTION
        Shows detailed information about installed packages using 'pip show'.

    .PARAMETER PackageName
        Name of the package to show information for.

    .PARAMETER Arguments
        Additional arguments to pass to pip show.

    .EXAMPLE
        Invoke-PipShow requests
        Shows information about the requests package.

    .EXAMPLE
        pips numpy
        Shows numpy package information using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pips")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('show')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & $pipCmd @allArgs
}

function Invoke-PipSearch {
    <#
    .SYNOPSIS
        Search for packages on PyPI.

    .DESCRIPTION
        Searches PyPI for packages matching the query using 'pip search'.
        Note: pip search may not be available in newer pip versions.

    .PARAMETER Query
        Search query for packages.

    .PARAMETER Arguments
        Additional arguments to pass to pip search.

    .EXAMPLE
        Invoke-PipSearch web framework
        Searches for web framework packages.

    .EXAMPLE
        pipsr machine learning
        Searches for ML packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipsr")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Query,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    Write-Warning "pip search is deprecated and may not work. Consider using https://pypi.org/ to search for packages."
    
    $pipCmd = Get-PipCommand
    $allArgs = @('search')
    if ($Query) {
        $allArgs += $Query
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & $pipCmd @allArgs
}

function Invoke-PipRequirements {
    <#
    .SYNOPSIS
        Create requirements.txt file.

    .DESCRIPTION
        Creates a requirements.txt file with currently installed packages.
        Equivalent to 'pip freeze > requirements.txt' or 'pipreq' shortcut.

    .PARAMETER FilePath
        Path for the requirements file. Defaults to 'requirements.txt'.

    .EXAMPLE
        Invoke-PipRequirements
        Creates requirements.txt in current directory.

    .EXAMPLE
        pipreq
        Creates requirements file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipreq")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$FilePath = 'requirements.txt'
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    & $pipCmd freeze | Out-File -FilePath $FilePath -Encoding UTF8
    Write-Host "Requirements saved to $FilePath" -ForegroundColor Green
}

function Invoke-PipInstallRequirements {
    <#
    .SYNOPSIS
        Install packages from requirements file.

    .DESCRIPTION
        Installs packages from a requirements file using 'pip install -r'.
        Equivalent to 'pip install -r requirements.txt' or 'pipir' shortcut.

    .PARAMETER FilePath
        Path to the requirements file. Defaults to 'requirements.txt'.

    .PARAMETER Arguments
        Additional arguments to pass to pip install.

    .EXAMPLE
        Invoke-PipInstallRequirements
        Installs from requirements.txt.

    .EXAMPLE
        pipir dev-requirements.txt
        Installs from custom requirements file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipir")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$FilePath = 'requirements.txt',

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    if (-not (Test-Path $FilePath)) {
        Write-Error "Requirements file '$FilePath' not found."
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('install', '-r', $FilePath) + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipUpgradeAll {
    <#
    .SYNOPSIS
        Upgrade all installed packages.

    .DESCRIPTION
        Upgrades all outdated packages to their latest versions.
        Equivalent to 'pipupall' function from zsh/bash.

    .EXAMPLE
        Invoke-PipUpgradeAll
        Upgrades all outdated packages.

    .EXAMPLE
        pipupall
        Upgrades all packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipupall")]
    [OutputType([void])]
    param()

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    Write-Host "Getting list of outdated packages..." -ForegroundColor Yellow
    
    try {
        $outdated = & $pipCmd list --outdated --format=json | ConvertFrom-Json
        if ($outdated.Count -eq 0) {
            Write-Host "All packages are up to date." -ForegroundColor Green
            return
        }

        Write-Host "Found $($outdated.Count) outdated packages. Upgrading..." -ForegroundColor Yellow
        foreach ($package in $outdated) {
            Write-Host "Upgrading $($package.name)..." -ForegroundColor Cyan
            & $pipCmd install --upgrade $package.name
        }
        Write-Host "All packages upgraded successfully." -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not get outdated packages list. Falling back to basic method."
        & $pipCmd list --outdated | Select-Object -Skip 2 | ForEach-Object {
            $packageName = ($_ -split '\s+')[0]
            if ($packageName) {
                Write-Host "Upgrading $packageName..." -ForegroundColor Cyan
                & $pipCmd install --upgrade $packageName
            }
        }
    }
}

function Invoke-PipUninstallAll {
    <#
    .SYNOPSIS
        Uninstall all installed packages.

    .DESCRIPTION
        Uninstalls all installed packages except pip, setuptools, and wheel.
        Equivalent to 'pipunall' function from zsh/bash. Use with caution.

    .PARAMETER Force
        Force uninstall without confirmation.

    .EXAMPLE
        Invoke-PipUninstallAll
        Uninstalls all packages with confirmation.

    .EXAMPLE
        pipunall -Force
        Uninstalls all packages without confirmation.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("pipunall")]
    [OutputType([void])]
    param(
        [Parameter()]
        [switch]$Force
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    
    try {
        $packages = & $pipCmd freeze | Where-Object { 
            $_ -notmatch '^(pip|setuptools|wheel)=' 
        } | ForEach-Object {
            ($_ -split '=')[0]
        }

        if ($packages.Count -eq 0) {
            Write-Host "No packages to uninstall." -ForegroundColor Green
            return
        }

        if (-not $Force -and -not $PSCmdlet.ShouldProcess("$($packages.Count) packages", "Uninstall")) {
            return
        }

        Write-Host "Uninstalling $($packages.Count) packages..." -ForegroundColor Yellow
        & $pipCmd uninstall -y @packages
        Write-Host "All packages uninstalled successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to uninstall packages: $($_.Exception.Message)"
    }
}

function Invoke-PipInstallGitHub {
    <#
    .SYNOPSIS
        Install package from GitHub repository.

    .DESCRIPTION
        Installs a Python package directly from a GitHub repository.
        Equivalent to 'pipig' function from zsh/bash.

    .PARAMETER Repository
        GitHub repository in format 'owner/repo'.

    .PARAMETER Arguments
        Additional arguments to pass to pip install.

    .EXAMPLE
        Invoke-PipInstallGitHub psf/requests
        Installs requests package from GitHub.

    .EXAMPLE
        pipig user/my-package
        Installs package from GitHub using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipig")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Repository,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $gitUrl = "git+https://github.com/$Repository.git"
    $allArgs = @('install', $gitUrl) + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipInstallGitHubBranch {
    <#
    .SYNOPSIS
        Install package from specific GitHub branch.

    .DESCRIPTION
        Installs a Python package from a specific branch of a GitHub repository.
        Equivalent to 'pipigb' function from zsh/bash.

    .PARAMETER Repository
        GitHub repository in format 'owner/repo'.

    .PARAMETER Branch
        Branch name to install from.

    .PARAMETER Arguments
        Additional arguments to pass to pip install.

    .EXAMPLE
        Invoke-PipInstallGitHubBranch psf/requests develop
        Installs requests from develop branch.

    .EXAMPLE
        pipigb user/package feature-branch
        Installs from feature branch using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipigb")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Repository,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]$Branch,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $gitUrl = "git+https://github.com/$Repository.git@$Branch"
    $allArgs = @('install', $gitUrl) + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipInstallGitHubPR {
    <#
    .SYNOPSIS
        Install package from GitHub pull request.

    .DESCRIPTION
        Installs a Python package from a specific pull request of a GitHub repository.
        Equivalent to 'pipigp' function from zsh/bash.

    .PARAMETER Repository
        GitHub repository in format 'owner/repo'.

    .PARAMETER PullRequestNumber
        Pull request number to install from.

    .PARAMETER Arguments
        Additional arguments to pass to pip install.

    .EXAMPLE
        Invoke-PipInstallGitHubPR psf/requests 123
        Installs requests from PR #123.

    .EXAMPLE
        pipigp user/package 456
        Installs from PR #456 using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipigp")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Repository,

        [Parameter(Position = 1, Mandatory = $true)]
        [int]$PullRequestNumber,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $gitUrl = "git+https://github.com/$Repository.git@refs/pull/$PullRequestNumber/head"
    $allArgs = @('install', $gitUrl) + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipCheck {
    <#
    .SYNOPSIS
        Verify installed packages have compatible dependencies.

    .DESCRIPTION
        Checks that installed packages have compatible dependencies using 'pip check'.

    .PARAMETER Arguments
        Additional arguments to pass to pip check.

    .EXAMPLE
        Invoke-PipCheck
        Checks for dependency conflicts.

    .EXAMPLE
        pipck
        Checks dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipck")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('check') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipWheel {
    <#
    .SYNOPSIS
        Build wheel archives for packages.

    .DESCRIPTION
        Builds wheel archives using 'pip wheel' command.

    .PARAMETER Arguments
        Arguments to pass to pip wheel.

    .EXAMPLE
        Invoke-PipWheel .
        Builds wheel for current package.

    .EXAMPLE
        pipw package-name
        Builds wheel for package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipw")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('wheel') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipDownload {
    <#
    .SYNOPSIS
        Download packages without installing.

    .DESCRIPTION
        Downloads packages without installing them using 'pip download'.

    .PARAMETER Arguments
        Arguments to pass to pip download.

    .EXAMPLE
        Invoke-PipDownload requests
        Downloads requests package without installing.

    .EXAMPLE
        pipd numpy -d downloads/
        Downloads numpy to specific directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('download') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipConfig {
    <#
    .SYNOPSIS
        Manage pip configuration.

    .DESCRIPTION
        Manages pip configuration using 'pip config' command.

    .PARAMETER Arguments
        Arguments to pass to pip config.

    .EXAMPLE
        Invoke-PipConfig list
        Lists pip configuration.

    .EXAMPLE
        pipc set global.index-url https://pypi.org/simple/
        Sets configuration using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('config') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipDebug {
    <#
    .SYNOPSIS
        Show pip debug information.

    .DESCRIPTION
        Shows debug information about pip installation using 'pip debug'.

    .PARAMETER Arguments
        Additional arguments to pass to pip debug.

    .EXAMPLE
        Invoke-PipDebug
        Shows pip debug information.

    .EXAMPLE
        pipdbg
        Shows debug info using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipdbg")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('debug') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipHash {
    <#
    .SYNOPSIS
        Compute hashes of package archives.

    .DESCRIPTION
        Computes hashes of package archives using 'pip hash'.

    .PARAMETER Arguments
        Arguments to pass to pip hash.

    .EXAMPLE
        Invoke-PipHash package.whl
        Computes hash for wheel file.

    .EXAMPLE
        piph *.tar.gz
        Computes hashes for all tar.gz files using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("piph")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('hash') + $Arguments
    & $pipCmd @allArgs
}

function Invoke-PipHelp {
    <#
    .SYNOPSIS
        Show pip help information.

    .DESCRIPTION
        Shows help information for pip commands using 'pip help'.

    .PARAMETER Command
        Specific command to get help for.

    .EXAMPLE
        Invoke-PipHelp
        Shows general pip help.

    .EXAMPLE
        Invoke-PipHelp install
        Shows help for pip install command.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Command
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    if ($Command) {
        & $pipCmd help $Command
    }
    else {
        & $pipCmd help
    }
}

function Invoke-PipCache {
    <#
    .SYNOPSIS
        Manage pip cache.

    .DESCRIPTION
        Manages pip cache using 'pip cache' command.

    .PARAMETER Arguments
        Arguments to pass to pip cache.

    .EXAMPLE
        Invoke-PipCache info
        Shows cache information.

    .EXAMPLE
        pipcc purge
        Purges pip cache using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md
    #>
    [CmdletBinding()]
    [Alias("pipcc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipInstalled)) {
        return
    }

    $pipCmd = Get-PipCommand
    $allArgs = @('cache') + $Arguments
    & $pipCmd @allArgs
}
