#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Pipenv Plugin
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
#       This module provides pipenv CLI shortcuts and utility functions for improved Python
#       virtual environment management workflow in PowerShell environments. Converts 15+ common
#       pipenv aliases from zsh/bash to PowerShell functions with full parameter support and
#       automatic shell activation functionality.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

# Global variable to track auto-shell preference
$script:PipenvAutoShell = $true

# Global variable to track current Pipfile directory
$script:PipfileDirectory = $null

function Test-PipenvInstalled {
    <#
    .SYNOPSIS
        Tests if pipenv is installed and accessible.

    .DESCRIPTION
        Checks if pipenv command is available in the current environment and validates basic functionality.
        Used internally by other pipenv functions to ensure pipenv is available before executing commands.

    .OUTPUTS
        System.Boolean
        Returns $true if pipenv is available, $false otherwise.

    .EXAMPLE
        Test-PipenvInstalled
        Returns $true if pipenv is installed and accessible.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $null = Get-Command pipenv -ErrorAction Stop
        $null = pipenv --version 2>$null
        return $true
    }
    catch {
        Write-Warning "pipenv is not installed or not accessible. Please install pipenv to use pipenv functions."
        return $false
    }
}

function Initialize-PipenvCompletion {
    <#
    .SYNOPSIS
        Initializes pipenv completion for PowerShell.

    .DESCRIPTION
        Sets up pipenv command completion for PowerShell to provide tab completion for pipenv commands,
        packages, and options. This function is automatically called when the module is imported.

    .EXAMPLE
        Initialize-PipenvCompletion
        Sets up pipenv completion for the current PowerShell session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-PipenvInstalled)) {
        return
    }

    try {
        Register-ArgumentCompleter -CommandName 'pipenv' -ScriptBlock {
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            
            $subcommands = @(
                'install', 'uninstall', 'lock', 'sync', 'update', 'run', 'shell',
                'check', 'clean', 'graph', 'open', 'requirements', 'script',
                '--venv', '--where', '--py', '--version', '--help'
            )
            
            $subcommands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
    catch {
        Write-Verbose "pipenv completion initialization failed: $($_.Exception.Message)"
    }
}

function Enable-PipenvAutoShell {
    <#
    .SYNOPSIS
        Enables automatic pipenv shell activation.

    .DESCRIPTION
        Enables automatic activation of pipenv virtual environments when entering
        directories containing a Pipfile. This mimics the zsh plugin behavior.

    .EXAMPLE
        Enable-PipenvAutoShell
        Enables automatic shell activation.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $script:PipenvAutoShell = $true
    Write-Host "Pipenv auto-shell activation enabled." -ForegroundColor Green
}

function Disable-PipenvAutoShell {
    <#
    .SYNOPSIS
        Disables automatic pipenv shell activation.

    .DESCRIPTION
        Disables automatic activation of pipenv virtual environments when entering
        directories containing a Pipfile.

    .EXAMPLE
        Disable-PipenvAutoShell
        Disables automatic shell activation.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $script:PipenvAutoShell = $false
    Write-Host "Pipenv auto-shell activation disabled." -ForegroundColor Yellow
}

function Test-PipenvAutoShell {
    <#
    .SYNOPSIS
        Tests if automatic pipenv shell activation is enabled.

    .DESCRIPTION
        Returns the current state of automatic pipenv shell activation.

    .OUTPUTS
        System.Boolean
        Returns $true if auto-shell is enabled, $false otherwise.

    .EXAMPLE
        Test-PipenvAutoShell
        Returns current auto-shell state.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    return $script:PipenvAutoShell
}

function Invoke-PipenvShellToggle {
    <#
    .SYNOPSIS
        Toggles pipenv shell activation based on current directory.

    .DESCRIPTION
        Automatically activates or deactivates pipenv virtual environment based on
        the presence of a Pipfile in the current directory or parent directories.
        This function is called automatically when auto-shell is enabled.

    .EXAMPLE
        Invoke-PipenvShellToggle
        Checks and toggles pipenv shell activation.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-PipenvInstalled) -or -not (Test-PipenvAutoShell)) {
        return
    }

    try {
        $currentDir = $PWD.Path
        $pipfilePath = $null
        $searchDir = $currentDir

        while ($searchDir) {
            $testPath = Join-Path $searchDir "Pipfile"
            if (Test-Path $testPath) {
                $pipfilePath = $searchDir
                break
            }
            $parentDir = Split-Path $searchDir -Parent
            if ($parentDir -eq $searchDir) {
                break
            }
            $searchDir = $parentDir
        }

        $isActive = $env:PIPENV_ACTIVE -eq '1'
        
        if ($pipfilePath) {
            if (-not $isActive -or $script:PipfileDirectory -ne $pipfilePath) {
                $script:PipfileDirectory = $pipfilePath
                
                $originalLocation = $PWD.Path
                try {
                    Set-Location $pipfilePath
                    $venvPath = pipenv --venv 2>$null
                    if ($venvPath) {
                        if ($IsWindows -or $env:OS -eq "Windows_NT") {
                            $activateScript = Join-Path $venvPath "Scripts\activate.ps1"
                        }
                        else {
                            $activateScript = Join-Path $venvPath "bin" "activate.ps1"
                        }
                        
                        if (Test-Path $activateScript) {
                            & $activateScript
                            $env:PIPENV_ACTIVE = '1'
                            Write-Host "Pipenv activated: $($pipfilePath | Split-Path -Leaf)" -ForegroundColor Green
                        }
                    }
                }
                finally {
                    Set-Location $originalLocation
                }
            }
        }
        else {
            if ($isActive -and $script:PipfileDirectory) {
                if (-not $currentDir.StartsWith($script:PipfileDirectory)) {
                    if (Get-Command deactivate -ErrorAction SilentlyContinue) {
                        deactivate
                    }
                    $env:PIPENV_ACTIVE = $null
                    $script:PipfileDirectory = $null
                    Write-Host "Pipenv deactivated" -ForegroundColor Yellow
                }
            }
        }
    }
    catch {
        Write-Verbose "Error in pipenv shell toggle: $($_.Exception.Message)"
    }
}

function Invoke-Pipenv {
    <#
    .SYNOPSIS
        Base pipenv command wrapper.

    .DESCRIPTION
        Executes pipenv commands with all provided arguments. Serves as the base wrapper
        for all pipenv operations and ensures pipenv is available before execution.

    .PARAMETER Arguments
        All arguments to pass to pipenv command.

    .EXAMPLE
        Invoke-Pipenv --version
        Shows pipenv version.

    .EXAMPLE
        Invoke-Pipenv install requests
        Installs the requests package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pipenv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    & pipenv @Arguments
}

function Invoke-PipenvInstall {
    <#
    .SYNOPSIS
        Install packages using pipenv.

    .DESCRIPTION
        Installs packages into the pipenv virtual environment and updates Pipfile.
        Equivalent to 'pipenv install' or 'pi' shortcut.

    .PARAMETER PackageName
        Name of the package to install.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv install.

    .EXAMPLE
        Invoke-PipenvInstall requests
        Installs the requests package.

    .EXAMPLE
        pi numpy pandas
        Installs multiple packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pi")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('install')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pipenv @allArgs
}

function Invoke-PipenvInstallDev {
    <#
    .SYNOPSIS
        Install development dependencies using pipenv.

    .DESCRIPTION
        Installs packages as development dependencies in the pipenv virtual environment.
        Equivalent to 'pipenv install --dev' or 'pidev' shortcut.

    .PARAMETER PackageName
        Name of the package to install as development dependency.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv install.

    .EXAMPLE
        Invoke-PipenvInstallDev pytest
        Installs pytest as development dependency.

    .EXAMPLE
        pidev black flake8
        Installs multiple dev packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pidev")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('install', '--dev')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pipenv @allArgs
}

function Invoke-PipenvUninstall {
    <#
    .SYNOPSIS
        Uninstall packages using pipenv.

    .DESCRIPTION
        Uninstalls packages from the pipenv virtual environment and updates Pipfile.
        Equivalent to 'pipenv uninstall' or 'pu' shortcut.

    .PARAMETER PackageName
        Name of the package to uninstall.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv uninstall.

    .EXAMPLE
        Invoke-PipenvUninstall requests
        Uninstalls the requests package.

    .EXAMPLE
        pu old-package
        Uninstalls package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pu")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('uninstall')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pipenv @allArgs
}

function Invoke-PipenvUpdate {
    <#
    .SYNOPSIS
        Update packages using pipenv.

    .DESCRIPTION
        Updates packages in the pipenv virtual environment to latest compatible versions.
        Equivalent to 'pipenv update' or 'pupd' shortcut.

    .PARAMETER PackageName
        Name of the package to update (optional).

    .PARAMETER Arguments
        Additional arguments to pass to pipenv update.

    .EXAMPLE
        Invoke-PipenvUpdate
        Updates all packages.

    .EXAMPLE
        pupd requests
        Updates specific package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pupd")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('update')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pipenv @allArgs
}

function Invoke-PipenvShell {
    <#
    .SYNOPSIS
        Activate pipenv shell.

    .DESCRIPTION
        Spawns a shell within the pipenv virtual environment.
        Equivalent to 'pipenv shell' or 'psh' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv shell.

    .EXAMPLE
        Invoke-PipenvShell
        Activates pipenv shell.

    .EXAMPLE
        psh
        Activates shell using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("psh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('shell') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvRun {
    <#
    .SYNOPSIS
        Run commands in pipenv environment.

    .DESCRIPTION
        Runs commands within the pipenv virtual environment.
        Equivalent to 'pipenv run' or 'prun' shortcut.

    .PARAMETER Command
        Command to run in the virtual environment.

    .PARAMETER Arguments
        Additional arguments to pass to the command.

    .EXAMPLE
        Invoke-PipenvRun python script.py
        Runs Python script in virtual environment.

    .EXAMPLE
        prun pytest
        Runs pytest using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("prun")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Command,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('run')
    if ($Command) {
        $allArgs += $Command
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pipenv @allArgs
}

function Invoke-PipenvWhere {
    <#
    .SYNOPSIS
        Show project directory path.

    .DESCRIPTION
        Shows the path to the pipenv project directory.
        Equivalent to 'pipenv --where' or 'pwh' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv.

    .EXAMPLE
        Invoke-PipenvWhere
        Shows project directory path.

    .EXAMPLE
        pwh
        Shows path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pwh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('--where') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvVenv {
    <#
    .SYNOPSIS
        Show virtual environment path.

    .DESCRIPTION
        Shows the path to the pipenv virtual environment.
        Equivalent to 'pipenv --venv' or 'pvenv' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv.

    .EXAMPLE
        Invoke-PipenvVenv
        Shows virtual environment path.

    .EXAMPLE
        pvenv
        Shows venv path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pvenv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('--venv') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvPython {
    <#
    .SYNOPSIS
        Show Python interpreter path.

    .DESCRIPTION
        Shows the path to the Python interpreter in the virtual environment.
        Equivalent to 'pipenv --py' or 'ppy' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv.

    .EXAMPLE
        Invoke-PipenvPython
        Shows Python interpreter path.

    .EXAMPLE
        ppy
        Shows Python path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("ppy")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('--py') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvLock {
    <#
    .SYNOPSIS
        Generate Pipfile.lock.

    .DESCRIPTION
        Generates the Pipfile.lock file with exact package versions.
        Equivalent to 'pipenv lock' or 'pl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv lock.

    .EXAMPLE
        Invoke-PipenvLock
        Generates Pipfile.lock.

    .EXAMPLE
        pl --dev
        Locks including development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('lock') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvSync {
    <#
    .SYNOPSIS
        Install dependencies from Pipfile.lock.

    .DESCRIPTION
        Installs dependencies exactly as specified in Pipfile.lock.
        Equivalent to 'pipenv sync' or 'psy' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv sync.

    .EXAMPLE
        Invoke-PipenvSync
        Syncs dependencies from Pipfile.lock.

    .EXAMPLE
        psy --dev
        Syncs including development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("psy")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('sync') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvRequirements {
    <#
    .SYNOPSIS
        Generate requirements.txt from Pipfile.lock.

    .DESCRIPTION
        Generates a requirements.txt file from Pipfile.lock.
        Equivalent to 'pipenv requirements' or 'preq' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv requirements.

    .EXAMPLE
        Invoke-PipenvRequirements > requirements.txt
        Generates requirements.txt file.

    .EXAMPLE
        preq --dev
        Generates including dev dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("preq")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('requirements') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvCheck {
    <#
    .SYNOPSIS
        Check for security vulnerabilities.

    .DESCRIPTION
        Checks installed packages for known security vulnerabilities.
        Equivalent to 'pipenv check' or 'pch' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv check.

    .EXAMPLE
        Invoke-PipenvCheck
        Checks for security vulnerabilities.

    .EXAMPLE
        pch --json
        Outputs results in JSON format using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pch")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('check') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvClean {
    <#
    .SYNOPSIS
        Clean unused dependencies.

    .DESCRIPTION
        Removes packages not specified in Pipfile from virtual environment.
        Equivalent to 'pipenv clean' or 'pcl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv clean.

    .EXAMPLE
        Invoke-PipenvClean
        Removes unused dependencies.

    .EXAMPLE
        pcl --dry-run
        Shows what would be removed using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pcl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('clean') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvGraph {
    <#
    .SYNOPSIS
        Show dependency graph.

    .DESCRIPTION
        Displays the dependency graph for installed packages.
        Equivalent to 'pipenv graph' or 'pgr' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv graph.

    .EXAMPLE
        Invoke-PipenvGraph
        Shows dependency graph.

    .EXAMPLE
        pgr --json
        Shows graph in JSON format using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pgr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('graph') + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvOpen {
    <#
    .SYNOPSIS
        Open installed package in editor.

    .DESCRIPTION
        Opens an installed package's source code in the default editor.
        Equivalent to 'pipenv open' or 'po' shortcut.

    .PARAMETER PackageName
        Name of the package to open.

    .PARAMETER Arguments
        Additional arguments to pass to pipenv open.

    .EXAMPLE
        Invoke-PipenvOpen requests
        Opens requests package source.

    .EXAMPLE
        po flask
        Opens Flask package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("po")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('open', $PackageName) + $Arguments
    & pipenv @allArgs
}

function Invoke-PipenvScript {
    <#
    .SYNOPSIS
        Run predefined scripts from Pipfile.

    .DESCRIPTION
        Runs scripts defined in the [scripts] section of Pipfile.
        Equivalent to 'pipenv run <script>' or 'pscr' shortcut.

    .PARAMETER ScriptName
        Name of the script to run.

    .PARAMETER Arguments
        Additional arguments to pass to the script.

    .EXAMPLE
        Invoke-PipenvScript test
        Runs the 'test' script defined in Pipfile.

    .EXAMPLE
        pscr lint --fix
        Runs lint script with arguments using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md
    #>
    [CmdletBinding()]
    [Alias("pscr")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$ScriptName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PipenvInstalled)) {
        return
    }

    $allArgs = @('run', $ScriptName) + $Arguments
    & pipenv @allArgs
}

if (Test-PipenvInstalled) {
    Initialize-PipenvCompletion
    
    if (Test-PipenvAutoShell) {
        $originalSetLocation = Get-Command Set-Location -CommandType Cmdlet
        function global:Set-Location {
            param(
                [Parameter(Position = 0)]
                [string]$Path = $HOME,
                
                [Parameter(ValueFromRemainingArguments = $true)]
                $RemainingArgs
            )
            
            & $originalSetLocation @PSBoundParameters
            if (Test-PipenvAutoShell) {
                Invoke-PipenvShellToggle
            }
        }
        
        if (Get-Alias cd -ErrorAction SilentlyContinue) {
            Remove-Alias cd -Force
        }
        New-Alias -Name cd -Value Set-Location -Option AllScope -Force
        
        Invoke-PipenvShellToggle
    }
}
