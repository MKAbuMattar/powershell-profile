#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - NPM Plugin
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
#       This module provides npm CLI shortcuts and utility functions for improved Node.js
#       package management workflow in PowerShell environments. Supports package installation,
#       updating, removal, script execution, publishing, and configuration management with
#       automatic PowerShell completion for modern JavaScript/Node.js development.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Test-NpmInstalled {
    <#
    .SYNOPSIS
        Tests if npm is installed and accessible.

    .DESCRIPTION
        Checks if npm command is available in the current environment and validates basic functionality.
        Used internally by other npm functions to ensure npm is available before executing commands.

    .OUTPUTS
        System.Boolean
        Returns $true if npm is available, $false otherwise.

    .EXAMPLE
        Test-NpmInstalled
        Returns $true if npm is installed and accessible.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $null = Get-Command npm -ErrorAction Stop
        $null = npm --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Initialize-NpmCompletion {
    <#
    .SYNOPSIS
        Initializes npm completion for PowerShell.

    .DESCRIPTION
        Sets up npm command completion for PowerShell to provide tab completion for npm commands,
        packages, and options. This function is automatically called when the module is imported.

    .EXAMPLE
        Initialize-NpmCompletion
        Sets up npm completion for the current PowerShell session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-NpmInstalled)) {
        return
    }

    try {
        $completionScript = npm completion powershell 2>$null
        if ($completionScript) {
            Invoke-Expression $completionScript
        }
    }
    catch {
        Write-Verbose "npm completion initialization failed: $($_.Exception.Message)"
    }
}

function Invoke-Npm {
    <#
    .SYNOPSIS
        Base npm command wrapper.

    .DESCRIPTION
        Executes npm commands with all provided arguments. Serves as the base wrapper
        for all npm operations and ensures npm is available before execution.

    .PARAMETER Arguments
        All arguments to pass to npm command.

    .EXAMPLE
        Invoke-Npm --version
        Shows npm version.

    .EXAMPLE
        Invoke-Npm install express
        Installs the express package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npm")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    & npm @Arguments
}

function Invoke-NpmInstallGlobal {
    <#
    .SYNOPSIS
        Install npm packages globally.

    .DESCRIPTION
        Installs npm packages globally using 'npm install -g' command.
        Equivalent to 'npm i -g' shortcut.

    .PARAMETER PackageName
        Name of the package to install globally.

    .PARAMETER Arguments
        Additional arguments to pass to npm install.

    .EXAMPLE
        Invoke-NpmInstallGlobal nodemon
        Installs nodemon globally.

    .EXAMPLE
        npmg typescript
        Installs TypeScript globally using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmg")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('install', '-g')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmInstallSave {
    <#
    .SYNOPSIS
        Install and save packages to dependencies.

    .DESCRIPTION
        Installs npm packages and saves them to dependencies in package.json.
        Equivalent to 'npm install -S' or 'npm install --save'.

    .PARAMETER PackageName
        Name of the package to install and save.

    .PARAMETER Arguments
        Additional arguments to pass to npm install.

    .EXAMPLE
        Invoke-NpmInstallSave express
        Installs express and saves to dependencies.

    .EXAMPLE
        npmS lodash
        Installs lodash using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmS")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('install', '-S')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmInstallDev {
    <#
    .SYNOPSIS
        Install and save packages to dev-dependencies.

    .DESCRIPTION
        Installs npm packages and saves them to dev-dependencies in package.json.
        Equivalent to 'npm install -D' or 'npm install --save-dev'.

    .PARAMETER PackageName
        Name of the package to install and save to dev-dependencies.

    .PARAMETER Arguments
        Additional arguments to pass to npm install.

    .EXAMPLE
        Invoke-NpmInstallDev jest
        Installs jest and saves to dev-dependencies.

    .EXAMPLE
        npmD eslint
        Installs ESLint using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmD")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('install', '-D')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmInstallForce {
    <#
    .SYNOPSIS
        Force npm to fetch remote resources.

    .DESCRIPTION
        Force npm to fetch remote resources even if a local copy exists on disk.
        Equivalent to 'npm install -f' or 'npm install --force'.

    .PARAMETER Arguments
        Arguments to pass to npm install.

    .EXAMPLE
        Invoke-NpmInstallForce
        Forces npm to reinstall all packages.

    .EXAMPLE
        npmF express
        Forces reinstall of express package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmF")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('install', '-f') + $Arguments
    & npm @allArgs
}

function Invoke-NpmInstall {
    <#
    .SYNOPSIS
        Install npm packages.

    .DESCRIPTION
        Installs npm packages using 'npm install' command.
        Basic package installation without specific save options.

    .PARAMETER Arguments
        Arguments to pass to npm install.

    .EXAMPLE
        Invoke-NpmInstall
        Installs all dependencies from package.json.

    .EXAMPLE
        Invoke-NpmInstall express
        Installs the express package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('install') + $Arguments
    & npm @allArgs
}

function Invoke-NpmUninstall {
    <#
    .SYNOPSIS
        Uninstall npm packages.

    .DESCRIPTION
        Uninstalls npm packages using 'npm uninstall' command.
        Removes packages from node_modules and package.json.

    .PARAMETER Arguments
        Arguments to pass to npm uninstall.

    .EXAMPLE
        Invoke-NpmUninstall express
        Uninstalls the express package.

    .EXAMPLE
        Invoke-NpmUninstall -g nodemon
        Uninstalls nodemon globally.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('uninstall') + $Arguments
    & npm @allArgs
}

function Invoke-NpmExecute {
    <#
    .SYNOPSIS
        Execute commands from node_modules folder.

    .DESCRIPTION
        Execute command from node_modules folder based on current directory.
        Adds local node_modules/.bin to PATH for command execution.

    .PARAMETER Command
        Command to execute from node_modules.

    .PARAMETER Arguments
        Arguments to pass to the command.

    .EXAMPLE
        Invoke-NpmExecute gulp
        Executes gulp from local node_modules.

    .EXAMPLE
        npmE webpack --mode development
        Executes webpack with arguments.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmE")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Command,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $npmBinPath = npm bin 2>$null
    if ($npmBinPath) {
        $originalPath = $env:PATH
        try {
            $env:PATH = "$npmBinPath$([System.IO.Path]::PathSeparator)$env:PATH"
            & $Command @Arguments
        }
        finally {
            $env:PATH = $originalPath
        }
    }
    else {
        Write-Warning "Could not determine npm bin path."
    }
}

function Invoke-NpmStart {
    <#
    .SYNOPSIS
        Run npm start script.

    .DESCRIPTION
        Executes the 'start' script defined in package.json.
        Equivalent to 'npm start' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm start.

    .EXAMPLE
        Invoke-NpmStart
        Runs the start script.

    .EXAMPLE
        npmst
        Runs npm start using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmst")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('start') + $Arguments
    & npm @allArgs
}

function Invoke-NpmTest {
    <#
    .SYNOPSIS
        Run npm test script.

    .DESCRIPTION
        Executes the 'test' script defined in package.json.
        Equivalent to 'npm test' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm test.

    .EXAMPLE
        Invoke-NpmTest
        Runs the test script.

    .EXAMPLE
        npmt --coverage
        Runs tests with coverage.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('test') + $Arguments
    & npm @allArgs
}

function Invoke-NpmRun {
    <#
    .SYNOPSIS
        Run npm scripts.

    .DESCRIPTION
        Executes custom scripts defined in package.json using 'npm run'.
        Can run any script defined in the scripts section.

    .PARAMETER ScriptName
        Name of the script to run.

    .PARAMETER Arguments
        Additional arguments to pass to the script.

    .EXAMPLE
        Invoke-NpmRun build
        Runs the 'build' script.

    .EXAMPLE
        npmR lint --fix
        Runs the 'lint' script with --fix argument.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmR")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ScriptName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('run')
    if ($ScriptName) {
        $allArgs += $ScriptName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmRunDev {
    <#
    .SYNOPSIS
        Run npm development script.

    .DESCRIPTION
        Executes the 'dev' script defined in package.json.
        Common shortcut for development server startup.

    .PARAMETER Arguments
        Additional arguments to pass to the dev script.

    .EXAMPLE
        Invoke-NpmRunDev
        Runs the 'dev' script.

    .EXAMPLE
        npmrd --port 3001
        Runs dev script with port argument.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmrd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('run', 'dev') + $Arguments
    & npm @allArgs
}

function Invoke-NpmRunBuild {
    <#
    .SYNOPSIS
        Run npm build script.

    .DESCRIPTION
        Executes the 'build' script defined in package.json.
        Common shortcut for production build process.

    .PARAMETER Arguments
        Additional arguments to pass to the build script.

    .EXAMPLE
        Invoke-NpmRunBuild
        Runs the 'build' script.

    .EXAMPLE
        npmrb --prod
        Runs build script with production flag.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmrb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('run', 'build') + $Arguments
    & npm @allArgs
}

function Invoke-NpmRunScript {
    <#
    .SYNOPSIS
        Run custom npm script.

    .DESCRIPTION
        Alias for Invoke-NpmRun to execute custom scripts defined in package.json.
        Provides alternative command name for script execution.

    .PARAMETER Arguments
        Arguments to pass to npm run.

    .EXAMPLE
        Invoke-NpmRunScript lint
        Runs the 'lint' script.

    .EXAMPLE
        npmrs test:unit
        Runs the 'test:unit' script.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmrs")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('run') + $Arguments
    & npm @allArgs
}

function Invoke-NpmOutdated {
    <#
    .SYNOPSIS
        Check which npm modules are outdated.

    .DESCRIPTION
        Checks for outdated packages in the current project.
        Equivalent to 'npm outdated' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm outdated.

    .EXAMPLE
        Invoke-NpmOutdated
        Shows outdated packages.

    .EXAMPLE
        npmO --global
        Shows outdated global packages.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmO")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('outdated') + $Arguments
    & npm @allArgs
}

function Invoke-NpmUpdate {
    <#
    .SYNOPSIS
        Update npm packages.

    .DESCRIPTION
        Updates all packages listed to the latest version.
        Equivalent to 'npm update' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm update.

    .EXAMPLE
        Invoke-NpmUpdate
        Updates all packages to latest versions.

    .EXAMPLE
        npmU express
        Updates specific package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmU")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('update') + $Arguments
    & npm @allArgs
}

function Invoke-NpmVersion {
    <#
    .SYNOPSIS
        Check npm version.

    .DESCRIPTION
        Shows the version of npm and Node.js.
        Equivalent to 'npm -v' or 'npm --version'.

    .PARAMETER Arguments
        Additional arguments to pass to npm version.

    .EXAMPLE
        Invoke-NpmVersion
        Shows npm version information.

    .EXAMPLE
        npmV
        Shows version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmV")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    if ($Arguments) {
        $allArgs = @('version') + $Arguments
        & npm @allArgs
    }
    else {
        & npm --version
    }
}

function Invoke-NpmList {
    <#
    .SYNOPSIS
        List installed packages.

    .DESCRIPTION
        Lists installed packages in the current project.
        Equivalent to 'npm list' or 'npm ls'.

    .PARAMETER Arguments
        Additional arguments to pass to npm list.

    .EXAMPLE
        Invoke-NpmList
        Lists all installed packages.

    .EXAMPLE
        npmL --depth=1
        Lists packages with limited depth.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmL")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('list') + $Arguments
    & npm @allArgs
}

function Invoke-NpmListTopLevel {
    <#
    .SYNOPSIS
        List top-level installed packages.

    .DESCRIPTION
        Lists only top-level installed packages with no dependencies.
        Equivalent to 'npm ls --depth=0'.

    .PARAMETER Arguments
        Additional arguments to pass to npm list.

    .EXAMPLE
        Invoke-NpmListTopLevel
        Lists top-level packages only.

    .EXAMPLE
        npmL0 --global
        Lists top-level global packages.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmL0")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('ls', '--depth=0') + $Arguments
    & npm @allArgs
}

function Invoke-NpmInfo {
    <#
    .SYNOPSIS
        Get package information.

    .DESCRIPTION
        Shows detailed information about a package.
        Equivalent to 'npm info' command.

    .PARAMETER PackageName
        Name of the package to get information about.

    .PARAMETER Arguments
        Additional arguments to pass to npm info.

    .EXAMPLE
        Invoke-NpmInfo express
        Shows information about the express package.

    .EXAMPLE
        npmi lodash
        Shows package info using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmi")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('info')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmSearch {
    <#
    .SYNOPSIS
        Search for npm packages.

    .DESCRIPTION
        Searches npm registry for packages matching the query.
        Equivalent to 'npm search' command.

    .PARAMETER Query
        Search query for packages.

    .PARAMETER Arguments
        Additional arguments to pass to npm search.

    .EXAMPLE
        Invoke-NpmSearch react
        Searches for packages containing 'react'.

    .EXAMPLE
        npmSe vue component
        Searches for Vue components.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmSe")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Query,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('search')
    if ($Query) {
        $allArgs += $Query
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmPublish {
    <#
    .SYNOPSIS
        Publish npm package.

    .DESCRIPTION
        Publishes the current package to npm registry.
        Equivalent to 'npm publish' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm publish.

    .EXAMPLE
        Invoke-NpmPublish
        Publishes the current package.

    .EXAMPLE
        npmP --access public
        Publishes package with public access.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmP")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('publish') + $Arguments
    & npm @allArgs
}

function Invoke-NpmInit {
    <#
    .SYNOPSIS
        Initialize npm package.

    .DESCRIPTION
        Creates a new package.json file for the current project.
        Equivalent to 'npm init' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm init.

    .EXAMPLE
        Invoke-NpmInit
        Initializes a new npm package interactively.

    .EXAMPLE
        npmI -y
        Initializes with default values.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmI")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('init') + $Arguments
    & npm @allArgs
}

function Invoke-NpmAudit {
    <#
    .SYNOPSIS
        Run npm security audit.

    .DESCRIPTION
        Runs a security audit on the current package and its dependencies.
        Equivalent to 'npm audit' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm audit.

    .EXAMPLE
        Invoke-NpmAudit
        Runs security audit on current package.

    .EXAMPLE
        npma --json
        Runs audit with JSON output.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npma")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('audit') + $Arguments
    & npm @allArgs
}

function Invoke-NpmAuditFix {
    <#
    .SYNOPSIS
        Fix npm security vulnerabilities.

    .DESCRIPTION
        Automatically fixes security vulnerabilities found by npm audit.
        Equivalent to 'npm audit fix' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm audit fix.

    .EXAMPLE
        Invoke-NpmAuditFix
        Fixes security vulnerabilities automatically.

    .EXAMPLE
        npmaf --force
        Forces vulnerability fixes.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmaf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('audit', 'fix') + $Arguments
    & npm @allArgs
}

function Invoke-NpmCache {
    <#
    .SYNOPSIS
        Manage npm cache.

    .DESCRIPTION
        Manages npm cache with various operations like clean, verify.
        Equivalent to 'npm cache' command.

    .PARAMETER Arguments
        Arguments to pass to npm cache (e.g., clean, verify).

    .EXAMPLE
        Invoke-NpmCache clean
        Cleans npm cache.

    .EXAMPLE
        npmc verify
        Verifies npm cache integrity.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('cache') + $Arguments
    & npm @allArgs
}

function Invoke-NpmDoctor {
    <#
    .SYNOPSIS
        Run npm doctor diagnostics.

    .DESCRIPTION
        Runs diagnostic checks on npm installation and environment.
        Equivalent to 'npm doctor' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm doctor.

    .EXAMPLE
        Invoke-NpmDoctor
        Runs npm diagnostic checks.

    .EXAMPLE
        npmdoc
        Runs diagnostics using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmdoc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('doctor') + $Arguments
    & npm @allArgs
}

function Invoke-NpmWhoami {
    <#
    .SYNOPSIS
        Show current npm user.

    .DESCRIPTION
        Shows the username of the currently logged-in npm user.
        Equivalent to 'npm whoami' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm whoami.

    .EXAMPLE
        Invoke-NpmWhoami
        Shows current npm username.

    .EXAMPLE
        npmwho
        Shows username using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmwho")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('whoami') + $Arguments
    & npm @allArgs
}

function Invoke-NpmLogin {
    <#
    .SYNOPSIS
        Login to npm registry.

    .DESCRIPTION
        Logs in to npm registry with user credentials.
        Equivalent to 'npm login' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm login.

    .EXAMPLE
        Invoke-NpmLogin
        Prompts for npm login credentials.

    .EXAMPLE
        npmlogin --registry https://my-registry.com
        Logs in to custom registry.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmlogin")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('login') + $Arguments
    & npm @allArgs
}

function Invoke-NpmLogout {
    <#
    .SYNOPSIS
        Logout from npm registry.

    .DESCRIPTION
        Logs out from npm registry and removes authentication.
        Equivalent to 'npm logout' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm logout.

    .EXAMPLE
        Invoke-NpmLogout
        Logs out from npm registry.

    .EXAMPLE
        npmlogout --registry https://my-registry.com
        Logs out from custom registry.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmlogout")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('logout') + $Arguments
    & npm @allArgs
}

function Invoke-NpmPing {
    <#
    .SYNOPSIS
        Ping npm registry.

    .DESCRIPTION
        Tests connectivity to npm registry.
        Equivalent to 'npm ping' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm ping.

    .EXAMPLE
        Invoke-NpmPing
        Pings npm registry.

    .EXAMPLE
        npmping --registry https://my-registry.com
        Pings custom registry.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmping")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('ping') + $Arguments
    & npm @allArgs
}

function Invoke-NpmConfigList {
    <#
    .SYNOPSIS
        List npm configuration.

    .DESCRIPTION
        Lists all npm configuration settings.
        Equivalent to 'npm config list' command.

    .PARAMETER Arguments
        Additional arguments to pass to npm config list.

    .EXAMPLE
        Invoke-NpmConfigList
        Lists all npm configuration.

    .EXAMPLE
        npmcl --json
        Lists config in JSON format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmcl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('config', 'list') + $Arguments
    & npm @allArgs
}

function Invoke-NpmConfigGet {
    <#
    .SYNOPSIS
        Get npm configuration value.

    .DESCRIPTION
        Gets the value of a specific npm configuration setting.
        Equivalent to 'npm config get' command.

    .PARAMETER ConfigName
        Name of the configuration to get.

    .PARAMETER Arguments
        Additional arguments to pass to npm config get.

    .EXAMPLE
        Invoke-NpmConfigGet registry
        Gets the registry configuration.

    .EXAMPLE
        npmcg prefix
        Gets the prefix configuration.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmcg")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ConfigName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('config', 'get')
    if ($ConfigName) {
        $allArgs += $ConfigName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmConfigSet {
    <#
    .SYNOPSIS
        Set npm configuration value.

    .DESCRIPTION
        Sets the value of a specific npm configuration setting.
        Equivalent to 'npm config set' command.

    .PARAMETER Arguments
        Configuration key and value to set, plus additional arguments.

    .EXAMPLE
        Invoke-NpmConfigSet registry https://registry.npmjs.org/
        Sets the registry configuration.

    .EXAMPLE
        npmcs init.author.name "Your Name"
        Sets the default author name.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmcs")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('config', 'set') + $Arguments
    & npm @allArgs
}

function Invoke-NpmLink {
    <#
    .SYNOPSIS
        Link npm package.

    .DESCRIPTION
        Creates a symbolic link for local package development.
        Equivalent to 'npm link' command.

    .PARAMETER PackageName
        Name of the package to link.

    .PARAMETER Arguments
        Additional arguments to pass to npm link.

    .EXAMPLE
        Invoke-NpmLink
        Links current package globally.

    .EXAMPLE
        npmln my-package
        Links specified package to current project.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmln")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('link')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}

function Invoke-NpmUnlink {
    <#
    .SYNOPSIS
        Unlink npm package.

    .DESCRIPTION
        Removes symbolic link for local package development.
        Equivalent to 'npm unlink' command.

    .PARAMETER PackageName
        Name of the package to unlink.

    .PARAMETER Arguments
        Additional arguments to pass to npm unlink.

    .EXAMPLE
        Invoke-NpmUnlink
        Unlinks current package globally.

    .EXAMPLE
        npmunln my-package
        Unlinks specified package from current project.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md
    #>
    [CmdletBinding()]
    [Alias("npmunln")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-NpmInstalled)) {
        return
    }

    $allArgs = @('unlink')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & npm @allArgs
}
