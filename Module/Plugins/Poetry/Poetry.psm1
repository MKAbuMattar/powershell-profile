#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Poetry Plugin
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
#       This module provides Poetry CLI shortcuts and utility functions for improved Python
#       dependency management workflow in PowerShell environments. Converts 30+ common
#       poetry aliases from zsh/bash to PowerShell functions with full parameter support and
#       comprehensive project lifecycle management.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Test-PoetryInstalled {
    <#
    .SYNOPSIS
        Tests if Poetry is installed and accessible.

    .DESCRIPTION
        Checks if Poetry command is available in the current environment and validates basic functionality.
        Used internally by other Poetry functions to ensure Poetry is available before executing commands.

    .OUTPUTS
        System.Boolean
        Returns $true if Poetry is available, $false otherwise.

    .EXAMPLE
        Test-PoetryInstalled
        Returns $true if Poetry is installed and accessible.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $null = Get-Command poetry -ErrorAction Stop
        $null = poetry --version 2>$null
        return $true
    }
    catch {
        Write-Warning "Poetry is not installed or not accessible. Please install Poetry to use Poetry functions."
        return $false
    }
}

function Initialize-PoetryCompletion {
    <#
    .SYNOPSIS
        Initializes Poetry completion for PowerShell.

    .DESCRIPTION
        Sets up Poetry command completion for PowerShell to provide tab completion for Poetry commands,
        packages, and options. This function is automatically called when the module is imported.

    .EXAMPLE
        Initialize-PoetryCompletion
        Sets up Poetry completion for the current PowerShell session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-PoetryInstalled)) {
        return
    }

    try {
        Register-ArgumentCompleter -CommandName 'poetry' -ScriptBlock {
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            
            $subcommands = @(
                'add', 'build', 'check', 'config', 'env', 'export', 'init', 'install',
                'list', 'lock', 'new', 'publish', 'remove', 'run', 'search', 'self',
                'shell', 'show', 'update', 'version', '--help', '--version'
            )
            
            $subcommands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
    catch {
        Write-Verbose "Poetry completion initialization failed: $($_.Exception.Message)"
    }
}

function Invoke-Poetry {
    <#
    .SYNOPSIS
        Base Poetry command wrapper.

    .DESCRIPTION
        Executes Poetry commands with all provided arguments. Serves as the base wrapper
        for all Poetry operations and ensures Poetry is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Poetry command.

    .EXAMPLE
        Invoke-Poetry --version
        Shows Poetry version.

    .EXAMPLE
        Invoke-Poetry add requests
        Adds the requests package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("poetry")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    & poetry @Arguments
}

function Invoke-PoetryInit {
    <#
    .SYNOPSIS
        Initialize a new Poetry project.

    .DESCRIPTION
        Creates a new pyproject.toml file in the current directory for Poetry dependency management.
        Equivalent to 'poetry init' or 'pin' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry init.

    .EXAMPLE
        Invoke-PoetryInit
        Initializes Poetry project interactively.

    .EXAMPLE
        pin --name myproject --dependency requests
        Initializes with specific name and dependency using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pin")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('init') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryNew {
    <#
    .SYNOPSIS
        Create a new Poetry project.

    .DESCRIPTION
        Creates a new Python project with Poetry structure and configuration.
        Equivalent to 'poetry new' or 'pnew' shortcut.

    .PARAMETER ProjectName
        Name of the project to create.

    .PARAMETER Arguments
        Additional arguments to pass to poetry new.

    .EXAMPLE
        Invoke-PoetryNew myproject
        Creates a new project named 'myproject'.

    .EXAMPLE
        pnew myapp --src
        Creates new project with src layout using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pnew")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ProjectName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('new')
    if ($ProjectName) {
        $allArgs += $ProjectName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryCheck {
    <#
    .SYNOPSIS
        Check Poetry project configuration.

    .DESCRIPTION
        Validates the pyproject.toml file and checks project configuration for errors.
        Equivalent to 'poetry check' or 'pch' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry check.

    .EXAMPLE
        Invoke-PoetryCheck
        Checks project configuration.

    .EXAMPLE
        pch
        Validates configuration using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pch")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('check') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryList {
    <#
    .SYNOPSIS
        List available packages.

    .DESCRIPTION
        Lists packages available for the current project or from repositories.
        Equivalent to 'poetry list' or 'pcmd' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry list.

    .EXAMPLE
        Invoke-PoetryList
        Lists available packages.

    .EXAMPLE
        pcmd --installed
        Lists installed packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pcmd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('list') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryAdd {
    <#
    .SYNOPSIS
        Add dependencies to Poetry project.

    .DESCRIPTION
        Adds packages to the Poetry project and updates pyproject.toml.
        Equivalent to 'poetry add' or 'pad' shortcut.

    .PARAMETER PackageName
        Name of the package to add.

    .PARAMETER Arguments
        Additional arguments to pass to poetry add.

    .EXAMPLE
        Invoke-PoetryAdd requests
        Adds the requests package.

    .EXAMPLE
        pad numpy pandas --group dev
        Adds development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pad")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('add')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryRemove {
    <#
    .SYNOPSIS
        Remove dependencies from Poetry project.

    .DESCRIPTION
        Removes packages from the Poetry project and updates pyproject.toml.
        Equivalent to 'poetry remove' or 'prm' shortcut.

    .PARAMETER PackageName
        Name of the package to remove.

    .PARAMETER Arguments
        Additional arguments to pass to poetry remove.

    .EXAMPLE
        Invoke-PoetryRemove requests
        Removes the requests package.

    .EXAMPLE
        prm old-package
        Removes package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("prm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('remove')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryUpdate {
    <#
    .SYNOPSIS
        Update project dependencies.

    .DESCRIPTION
        Updates dependencies to their latest compatible versions.
        Equivalent to 'poetry update' or 'pup' shortcut.

    .PARAMETER PackageName
        Name of specific package to update (optional).

    .PARAMETER Arguments
        Additional arguments to pass to poetry update.

    .EXAMPLE
        Invoke-PoetryUpdate
        Updates all dependencies.

    .EXAMPLE
        pup requests
        Updates specific package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pup")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('update')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryInstall {
    <#
    .SYNOPSIS
        Install project dependencies.

    .DESCRIPTION
        Installs all dependencies defined in pyproject.toml.
        Equivalent to 'poetry install' or 'pinst' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry install.

    .EXAMPLE
        Invoke-PoetryInstall
        Installs all project dependencies.

    .EXAMPLE
        pinst --no-dev
        Installs without development dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pinst")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('install') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetrySync {
    <#
    .SYNOPSIS
        Synchronize environment with lock file.

    .DESCRIPTION
        Installs dependencies exactly as specified in poetry.lock, removing any extras.
        Equivalent to 'poetry install --sync' or 'psync' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry install --sync.

    .EXAMPLE
        Invoke-PoetrySync
        Synchronizes environment with lock file.

    .EXAMPLE
        psync
        Syncs dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("psync")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('install', '--sync') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryLock {
    <#
    .SYNOPSIS
        Update the lock file.

    .DESCRIPTION
        Updates poetry.lock file with current dependency versions.
        Equivalent to 'poetry lock' or 'plck' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry lock.

    .EXAMPLE
        Invoke-PoetryLock
        Updates lock file.

    .EXAMPLE
        plck --no-update
        Locks without updating using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("plck")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('lock') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryExport {
    <#
    .SYNOPSIS
        Export dependencies to requirements format.

    .DESCRIPTION
        Exports project dependencies to requirements.txt format.
        Equivalent to 'poetry export --without-hashes > requirements.txt' or 'pexp' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry export.

    .EXAMPLE
        Invoke-PoetryExport
        Exports dependencies to requirements.txt without hashes.

    .EXAMPLE
        pexp --dev -o dev-requirements.txt
        Exports including dev dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pexp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    if ($Arguments.Count -eq 0) {
        & poetry export --without-hashes > requirements.txt
    }
    else {
        $allArgs = @('export') + $Arguments
        & poetry @allArgs
    }
}

function Invoke-PoetryShell {
    <#
    .SYNOPSIS
        Activate Poetry virtual environment shell.

    .DESCRIPTION
        Activates the virtual environment associated with the current Poetry project.
        Equivalent to 'poetry shell' or 'psh' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry shell.

    .EXAMPLE
        Invoke-PoetryShell
        Activates Poetry shell environment.

    .EXAMPLE
        psh
        Activates shell using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("psh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('shell') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryRun {
    <#
    .SYNOPSIS
        Run commands in Poetry environment.

    .DESCRIPTION
        Executes commands within the Poetry virtual environment.
        Equivalent to 'poetry run' or 'prun' shortcut.

    .PARAMETER Command
        Command to run in the virtual environment.

    .PARAMETER Arguments
        Additional arguments to pass to the command.

    .EXAMPLE
        Invoke-PoetryRun python app.py
        Runs Python script in virtual environment.

    .EXAMPLE
        prun pytest
        Runs pytest using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
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

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('run')
    if ($Command) {
        $allArgs += $Command
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryEnvInfo {
    <#
    .SYNOPSIS
        Show virtual environment information.

    .DESCRIPTION
        Displays information about the Poetry virtual environment.
        Equivalent to 'poetry env info' or 'pvinf' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry env info.

    .EXAMPLE
        Invoke-PoetryEnvInfo
        Shows virtual environment information.

    .EXAMPLE
        pvinf --path
        Shows only the path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pvinf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('env', 'info') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryEnvPath {
    <#
    .SYNOPSIS
        Show virtual environment path.

    .DESCRIPTION
        Displays the path to the Poetry virtual environment.
        Equivalent to 'poetry env info --path' or 'ppath' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry env info.

    .EXAMPLE
        Invoke-PoetryEnvPath
        Shows virtual environment path.

    .EXAMPLE
        ppath
        Shows path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("ppath")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('env', 'info', '--path') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryEnvUse {
    <#
    .SYNOPSIS
        Use specific Python version for environment.

    .DESCRIPTION
        Configures the Poetry project to use a specific Python interpreter.
        Equivalent to 'poetry env use' or 'pvu' shortcut.

    .PARAMETER PythonVersion
        Python version or path to use.

    .PARAMETER Arguments
        Additional arguments to pass to poetry env use.

    .EXAMPLE
        Invoke-PoetryEnvUse python3.9
        Uses Python 3.9 for the environment.

    .EXAMPLE
        pvu 3.10
        Uses Python 3.10 using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pvu")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$PythonVersion,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('env', 'use', $PythonVersion) + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryEnvRemove {
    <#
    .SYNOPSIS
        Remove virtual environment.

    .DESCRIPTION
        Removes the virtual environment associated with the current project.
        Equivalent to 'poetry env remove' or 'pvrm' shortcut.

    .PARAMETER PythonVersion
        Python version of environment to remove.

    .PARAMETER Arguments
        Additional arguments to pass to poetry env remove.

    .EXAMPLE
        Invoke-PoetryEnvRemove python3.9
        Removes Python 3.9 environment.

    .EXAMPLE
        pvrm 3.10
        Removes Python 3.10 environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pvrm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PythonVersion,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('env', 'remove')
    if ($PythonVersion) {
        $allArgs += $PythonVersion
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryBuild {
    <#
    .SYNOPSIS
        Build Poetry project.

    .DESCRIPTION
        Builds the Poetry project into distributable packages.
        Equivalent to 'poetry build' or 'pbld' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry build.

    .EXAMPLE
        Invoke-PoetryBuild
        Builds the project.

    .EXAMPLE
        pbld --format wheel
        Builds only wheel format using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pbld")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('build') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryPublish {
    <#
    .SYNOPSIS
        Publish Poetry project.

    .DESCRIPTION
        Publishes the built Poetry project to a package repository.
        Equivalent to 'poetry publish' or 'ppub' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry publish.

    .EXAMPLE
        Invoke-PoetryPublish
        Publishes to default repository.

    .EXAMPLE
        ppub --repository testpypi
        Publishes to test PyPI using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("ppub")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('publish') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryShow {
    <#
    .SYNOPSIS
        Show package information.

    .DESCRIPTION
        Displays information about installed packages or available packages.
        Equivalent to 'poetry show' or 'pshw' shortcut.

    .PARAMETER PackageName
        Name of the package to show information for.

    .PARAMETER Arguments
        Additional arguments to pass to poetry show.

    .EXAMPLE
        Invoke-PoetryShow
        Shows all installed packages.

    .EXAMPLE
        pshw requests
        Shows information about requests package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pshw")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('show')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryShowLatest {
    <#
    .SYNOPSIS
        Show latest package versions.

    .DESCRIPTION
        Displays the latest available versions of packages.
        Equivalent to 'poetry show --latest' or 'pslt' shortcut.

    .PARAMETER PackageName
        Name of the package to check for latest version.

    .PARAMETER Arguments
        Additional arguments to pass to poetry show.

    .EXAMPLE
        Invoke-PoetryShowLatest
        Shows latest versions of all packages.

    .EXAMPLE
        pslt requests
        Shows latest version of requests using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pslt")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('show', '--latest')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetryShowTree {
    <#
    .SYNOPSIS
        Show dependency tree.

    .DESCRIPTION
        Displays the dependency tree for the project.
        Equivalent to 'poetry show --tree' or 'ptree' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry show.

    .EXAMPLE
        Invoke-PoetryShowTree
        Shows dependency tree.

    .EXAMPLE
        ptree --no-dev
        Shows tree without dev dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("ptree")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('show', '--tree') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetryConfig {
    <#
    .SYNOPSIS
        Manage Poetry configuration.

    .DESCRIPTION
        Displays or modifies Poetry configuration settings.
        Equivalent to 'poetry config --list' or 'pconf' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry config.

    .EXAMPLE
        Invoke-PoetryConfig
        Lists all configuration settings.

    .EXAMPLE
        pconf repositories.pypi.url https://pypi.org/simple/
        Sets PyPI URL using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pconf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    if ($Arguments.Count -eq 0) {
        & poetry config --list
    }
    else {
        $allArgs = @('config') + $Arguments
        & poetry @allArgs
    }
}

function Disable-PoetryVirtualenv {
    <#
    .SYNOPSIS
        Disable virtual environment creation.

    .DESCRIPTION
        Configures Poetry to not create virtual environments automatically.
        Equivalent to 'poetry config virtualenvs.create false' or 'pvoff' shortcut.

    .EXAMPLE
        Disable-PoetryVirtualenv
        Disables automatic virtual environment creation.

    .EXAMPLE
        pvoff
        Disables venv creation using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pvoff")]
    [OutputType([void])]
    param()

    if (-not (Test-PoetryInstalled)) {
        return
    }

    & poetry config virtualenvs.create false
    Write-Host "Poetry virtual environment creation disabled." -ForegroundColor Yellow
}

function Invoke-PoetrySelfUpdate {
    <#
    .SYNOPSIS
        Update Poetry itself.

    .DESCRIPTION
        Updates Poetry to the latest version.
        Equivalent to 'poetry self update' or 'psup' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry self update.

    .EXAMPLE
        Invoke-PoetrySelfUpdate
        Updates Poetry to latest version.

    .EXAMPLE
        psup --preview
        Updates to preview version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("psup")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('self', 'update') + $Arguments
    & poetry @allArgs
}

function Invoke-PoetrySelfAdd {
    <#
    .SYNOPSIS
        Add plugins to Poetry.

    .DESCRIPTION
        Installs plugins for Poetry itself.
        Equivalent to 'poetry self add' or 'psad' shortcut.

    .PARAMETER PluginName
        Name of the plugin to add.

    .PARAMETER Arguments
        Additional arguments to pass to poetry self add.

    .EXAMPLE
        Invoke-PoetrySelfAdd poetry-plugin-export
        Adds the export plugin.

    .EXAMPLE
        psad poetry-plugin-bundle
        Adds bundle plugin using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("psad")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PluginName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('self', 'add')
    if ($PluginName) {
        $allArgs += $PluginName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & poetry @allArgs
}

function Invoke-PoetrySelfShowPlugins {
    <#
    .SYNOPSIS
        Show installed Poetry plugins.

    .DESCRIPTION
        Displays currently installed Poetry plugins.
        Equivalent to 'poetry self show plugins' or 'pplug' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to poetry self show.

    .EXAMPLE
        Invoke-PoetrySelfShowPlugins
        Shows installed Poetry plugins.

    .EXAMPLE
        pplug
        Shows plugins using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md
    #>
    [CmdletBinding()]
    [Alias("pplug")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PoetryInstalled)) {
        return
    }

    $allArgs = @('self', 'show', 'plugins') + $Arguments
    & poetry @allArgs
}

if (Test-PoetryInstalled) {
    Initialize-PoetryCompletion
}
