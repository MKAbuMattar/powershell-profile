#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PNPM Plugin
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
#       This module provides comprehensive PNPM CLI integration with PowerShell functions and
#       convenient aliases for fast, disk space efficient package management. Provides complete
#       workspace support, dependency management, development workflow automation, and advanced
#       PNPM features with automatic PowerShell completion for modern JavaScript/Node.js development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Test-PNPMInstalled {
    <#
    .SYNOPSIS
        Tests if pnpm is installed and accessible.

    .DESCRIPTION
        Checks if pnpm command is available in the current environment and validates basic functionality.
        Used internally by other pnpm functions to ensure pnpm is available before executing commands.

    .OUTPUTS
        System.Boolean
        Returns $true if pnpm is available, $false otherwise.

    .EXAMPLE
        Test-PNPMInstalled
        Returns $true if pnpm is installed and accessible.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $null = Get-Command pnpm -ErrorAction Stop
        $null = pnpm --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Initialize-PNPMCompletion {
    <#
    .SYNOPSIS
        Initializes pnpm completion for PowerShell.

    .DESCRIPTION
        Sets up pnpm command completion for PowerShell to provide tab completion for pnpm commands,
        packages, and options. This function is automatically called when the module is imported.

    .EXAMPLE
        Initialize-PNPMCompletion
        Sets up pnpm completion for the current PowerShell session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    try {
        $completionScript = pnpm completion powershell 2>$null
        if ($completionScript) {
            Invoke-Expression $completionScript
        }
    }
    catch {
        Write-Verbose "pnpm completion initialization failed: $($_.Exception.Message)"
    }
}

function Get-PNPMVersion {
    <#
    .SYNOPSIS
        Gets the current pnpm version.

    .DESCRIPTION
        Retrieves and displays the currently installed pnpm version.

    .OUTPUTS
        String
        The pnpm version string.

    .EXAMPLE
        Get-PNPMVersion
        Returns the pnpm version.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm --version
}

function Get-PNPMStorePath {
    <#
    .SYNOPSIS
        Gets the pnpm store path.

    .DESCRIPTION
        Retrieves the path to the pnpm store where packages are cached.

    .OUTPUTS
        String
        The pnpm store path.

    .EXAMPLE
        Get-PNPMStorePath
        Returns the path to the pnpm store.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm store path
}

function Invoke-PNPM {
    <#
    .SYNOPSIS
        Base pnpm command wrapper.

    .DESCRIPTION
        Executes pnpm commands with all provided arguments. Serves as the base wrapper
        for all pnpm operations and ensures pnpm is available before execution.

    .PARAMETER Arguments
        All arguments to pass to pnpm command.

    .EXAMPLE
        Invoke-PNPM --version
        Shows pnpm version.

    .EXAMPLE
        Invoke-PNPM install express
        Installs the express package.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("p")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm @Arguments
}

function Invoke-PNPMAdd {
    <#
    .SYNOPSIS
        Add packages to dependencies.

    .DESCRIPTION
        Adds packages to dependencies in package.json using 'pnpm add' command.
        Equivalent to 'pnpm add' or 'pnpm i'.

    .PARAMETER PackageName
        Name of the package to add.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm add.

    .EXAMPLE
        Invoke-PNPMAdd express
        Adds express to dependencies.

    .EXAMPLE
        pa lodash
        Adds lodash using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pa")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('add')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMAddDev {
    <#
    .SYNOPSIS
        Add packages to dev-dependencies.

    .DESCRIPTION
        Adds packages to dev-dependencies in package.json using 'pnpm add -D' command.

    .PARAMETER PackageName
        Name of the package to add to dev-dependencies.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm add.

    .EXAMPLE
        Invoke-PNPMAddDev jest
        Adds jest to dev-dependencies.

    .EXAMPLE
        pad eslint
        Adds ESLint to dev-dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
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

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('add', '-D')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMAddOptional {
    <#
    .SYNOPSIS
        Add packages to optional dependencies.

    .DESCRIPTION
        Adds packages to optional dependencies in package.json using 'pnpm add -O' command.

    .PARAMETER PackageName
        Name of the package to add to optional dependencies.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm add.

    .EXAMPLE
        Invoke-PNPMAddOptional fsevents
        Adds fsevents to optional dependencies.

    .EXAMPLE
        pao sharp
        Adds sharp to optional dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pao")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('add', '-O')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMAddPeer {
    <#
    .SYNOPSIS
        Add packages to peer dependencies.

    .DESCRIPTION
        Adds packages to peer dependencies in package.json using 'pnpm add -P' command.

    .PARAMETER PackageName
        Name of the package to add to peer dependencies.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm add.

    .EXAMPLE
        Invoke-PNPMAddPeer react
        Adds react to peer dependencies.

    .EXAMPLE
        pap vue
        Adds vue to peer dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pap")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('add', '-P')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMRemove {
    <#
    .SYNOPSIS
        Remove packages from dependencies.

    .DESCRIPTION
        Removes packages from dependencies using 'pnpm remove' command.

    .PARAMETER PackageName
        Name of the package to remove.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm remove.

    .EXAMPLE
        Invoke-PNPMRemove lodash
        Removes lodash from dependencies.

    .EXAMPLE
        prm express
        Removes express using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
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

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('remove')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMUpdate {
    <#
    .SYNOPSIS
        Update packages to latest versions.

    .DESCRIPTION
        Updates packages to their latest versions using 'pnpm update' command.

    .PARAMETER PackageName
        Name of the specific package to update. If not specified, updates all packages.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm update.

    .EXAMPLE
        Invoke-PNPMUpdate
        Updates all packages.

    .EXAMPLE
        pup express
        Updates express package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
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

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('update')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMUpdateInteractive {
    <#
    .SYNOPSIS
        Update packages interactively.

    .DESCRIPTION
        Updates packages interactively using 'pnpm update -i' command, allowing selection
        of which packages to update.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm update.

    .EXAMPLE
        Invoke-PNPMUpdateInteractive
        Opens interactive package update selection.

    .EXAMPLE
        pupi
        Opens interactive update using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pupi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('update', '-i')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMInstall {
    <#
    .SYNOPSIS
        Install dependencies.

    .DESCRIPTION
        Installs all dependencies listed in package.json using 'pnpm install' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm install.

    .EXAMPLE
        Invoke-PNPMInstall
        Installs all dependencies.

    .EXAMPLE
        pi
        Installs dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('install')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMInstallFrozen {
    <#
    .SYNOPSIS
        Install dependencies from lockfile.

    .DESCRIPTION
        Installs dependencies exactly as specified in the lockfile using 'pnpm install --frozen-lockfile'.
        This is useful for production deployments and CI/CD pipelines.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm install.

    .EXAMPLE
        Invoke-PNPMInstallFrozen
        Installs dependencies from frozen lockfile.

    .EXAMPLE
        pif
        Installs from frozen lockfile using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pif")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('install', '--frozen-lockfile')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMInit {
    <#
    .SYNOPSIS
        Initialize a new package.json file.

    .DESCRIPTION
        Creates a new package.json file in the current directory using 'pnpm init' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm init.

    .EXAMPLE
        Invoke-PNPMInit
        Creates a new package.json file.

    .EXAMPLE
        pin
        Initializes package.json using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pin")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('init')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMRun {
    <#
    .SYNOPSIS
        Run a script defined in package.json.

    .DESCRIPTION
        Runs a script defined in the scripts section of package.json using 'pnpm run' command.

    .PARAMETER ScriptName
        Name of the script to run.

    .PARAMETER Arguments
        Additional arguments to pass to the script.

    .EXAMPLE
        Invoke-PNPMRun build
        Runs the build script.

    .EXAMPLE
        pr test
        Runs the test script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pr")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ScriptName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('run')
    if ($ScriptName) {
        $allArgs += $ScriptName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMStart {
    <#
    .SYNOPSIS
        Run the start script.

    .DESCRIPTION
        Runs the start script defined in package.json using 'pnpm start' command.

    .PARAMETER Arguments
        Additional arguments to pass to the start script.

    .EXAMPLE
        Invoke-PNPMStart
        Runs the start script.

    .EXAMPLE
        ps
        Runs start script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ps")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('start')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMDev {
    <#
    .SYNOPSIS
        Run the dev script.

    .DESCRIPTION
        Runs the dev script defined in package.json using 'pnpm dev' command.
        This is commonly used for development servers.

    .PARAMETER Arguments
        Additional arguments to pass to the dev script.

    .EXAMPLE
        Invoke-PNPMDev
        Runs the dev script.

    .EXAMPLE
        pd
        Runs dev script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('dev')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMBuild {
    <#
    .SYNOPSIS
        Run the build script.

    .DESCRIPTION
        Runs the build script defined in package.json using 'pnpm build' command.

    .PARAMETER Arguments
        Additional arguments to pass to the build script.

    .EXAMPLE
        Invoke-PNPMBuild
        Runs the build script.

    .EXAMPLE
        pb
        Runs build script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('build')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMServe {
    <#
    .SYNOPSIS
        Run the serve script.

    .DESCRIPTION
        Runs the serve script defined in package.json using 'pnpm serve' command.
        This is commonly used to serve built applications.

    .PARAMETER Arguments
        Additional arguments to pass to the serve script.

    .EXAMPLE
        Invoke-PNPMServe
        Runs the serve script.

    .EXAMPLE
        psv
        Runs serve script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("psv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('serve')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMTest {
    <#
    .SYNOPSIS
        Run the test script.

    .DESCRIPTION
        Runs the test script defined in package.json using 'pnpm test' command.

    .PARAMETER Arguments
        Additional arguments to pass to the test script.

    .EXAMPLE
        Invoke-PNPMTest
        Runs the test script.

    .EXAMPLE
        pt
        Runs test script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('test')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMTestCoverage {
    <#
    .SYNOPSIS
        Run tests with coverage.

    .DESCRIPTION
        Runs tests with coverage reporting using 'pnpm test --coverage' command.

    .PARAMETER Arguments
        Additional arguments to pass to the test command.

    .EXAMPLE
        Invoke-PNPMTestCoverage
        Runs tests with coverage.

    .EXAMPLE
        ptc
        Runs test coverage using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ptc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('test', '--coverage')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMLint {
    <#
    .SYNOPSIS
        Run the lint script.

    .DESCRIPTION
        Runs the lint script defined in package.json using 'pnpm lint' command.

    .PARAMETER Arguments
        Additional arguments to pass to the lint script.

    .EXAMPLE
        Invoke-PNPMLint
        Runs the lint script.

    .EXAMPLE
        pln
        Runs lint script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pln")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('lint')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMLintFix {
    <#
    .SYNOPSIS
        Run lint with auto-fix.

    .DESCRIPTION
        Runs the lint script with auto-fix using 'pnpm lint --fix' command.

    .PARAMETER Arguments
        Additional arguments to pass to the lint command.

    .EXAMPLE
        Invoke-PNPMLintFix
        Runs lint with auto-fix.

    .EXAMPLE
        plnf
        Runs lint fix using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("plnf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('lint', '--fix')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMFormat {
    <#
    .SYNOPSIS
        Run the format script.

    .DESCRIPTION
        Runs the format script defined in package.json using 'pnpm format' command.

    .PARAMETER Arguments
        Additional arguments to pass to the format script.

    .EXAMPLE
        Invoke-PNPMFormat
        Runs the format script.

    .EXAMPLE
        pf
        Runs format script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('format')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMExec {
    <#
    .SYNOPSIS
        Execute a command from node_modules/.bin.

    .DESCRIPTION
        Executes a command from node_modules/.bin using 'pnpm exec' command.

    .PARAMETER Command
        The command to execute.

    .PARAMETER Arguments
        Additional arguments to pass to the command.

    .EXAMPLE
        Invoke-PNPMExec eslint src/
        Executes ESLint on the src directory.

    .EXAMPLE
        px tsc --watch
        Runs TypeScript compiler in watch mode using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("px")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Command,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('exec')
    if ($Command) {
        $allArgs += $Command
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMDlx {
    <#
    .SYNOPSIS
        Execute a package without installing it globally.

    .DESCRIPTION
        Executes a package without installing it globally using 'pnpm dlx' command.
        Similar to npx but for pnpm.

    .PARAMETER PackageName
        Name of the package to execute.

    .PARAMETER Arguments
        Additional arguments to pass to the package.

    .EXAMPLE
        Invoke-PNPMDlx create-react-app my-app
        Creates a React app without globally installing create-react-app.

    .EXAMPLE
        pdlx @angular/cli new my-angular-app
        Creates Angular app using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pdlx")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('dlx')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMCreate {
    <#
    .SYNOPSIS
        Create a new project using a template.

    .DESCRIPTION
        Creates a new project using a template with 'pnpm create' command.

    .PARAMETER Template
        Name of the template to use.

    .PARAMETER Arguments
        Additional arguments to pass to the create command.

    .EXAMPLE
        Invoke-PNPMCreate react-app my-app
        Creates a React app using the react-app template.

    .EXAMPLE
        pc vite my-vite-app
        Creates a Vite app using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pc")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Template,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('create')
    if ($Template) {
        $allArgs += $Template
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMList {
    <#
    .SYNOPSIS
        List installed packages.

    .DESCRIPTION
        Lists installed packages using 'pnpm list' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm list.

    .EXAMPLE
        Invoke-PNPMList
        Lists all installed packages.

    .EXAMPLE
        pls --depth=0
        Lists top-level packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pls")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('list')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMOutdated {
    <#
    .SYNOPSIS
        Check for outdated packages.

    .DESCRIPTION
        Checks for outdated packages using 'pnpm outdated' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm outdated.

    .EXAMPLE
        Invoke-PNPMOutdated
        Shows outdated packages.

    .EXAMPLE
        pout
        Shows outdated packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pout")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('outdated')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMAudit {
    <#
    .SYNOPSIS
        Run security audit.

    .DESCRIPTION
        Runs security audit on dependencies using 'pnpm audit' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm audit.

    .EXAMPLE
        Invoke-PNPMAudit
        Runs security audit.

    .EXAMPLE
        paud
        Runs audit using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("paud")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('audit')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMAuditFix {
    <#
    .SYNOPSIS
        Fix security audit issues.

    .DESCRIPTION
        Fixes security audit issues using 'pnpm audit --fix' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm audit.

    .EXAMPLE
        Invoke-PNPMAuditFix
        Fixes audit issues automatically.

    .EXAMPLE
        paudf
        Fixes audit issues using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("paudf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('audit', '--fix')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMWhy {
    <#
    .SYNOPSIS
        Show why a package is installed.

    .DESCRIPTION
        Shows why a package is installed using 'pnpm why' command.

    .PARAMETER PackageName
        Name of the package to investigate.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm why.

    .EXAMPLE
        Invoke-PNPMWhy lodash
        Shows why lodash is installed.

    .EXAMPLE
        pw react
        Shows why react is installed using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pw")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('why')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMPublish {
    <#
    .SYNOPSIS
        Publish package to registry.

    .DESCRIPTION
        Publishes package to npm registry using 'pnpm publish' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm publish.

    .EXAMPLE
        Invoke-PNPMPublish
        Publishes the current package.

    .EXAMPLE
        ppub --access public
        Publishes with public access using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ppub")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('publish')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMPack {
    <#
    .SYNOPSIS
        Create a tarball from package.

    .DESCRIPTION
        Creates a tarball from the current package using 'pnpm pack' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm pack.

    .EXAMPLE
        Invoke-PNPMPack
        Creates a tarball of the current package.

    .EXAMPLE
        ppk
        Creates tarball using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ppk")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('pack')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMPrune {
    <#
    .SYNOPSIS
        Remove extraneous packages.

    .DESCRIPTION
        Removes extraneous packages not listed in package.json using 'pnpm prune' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm prune.

    .EXAMPLE
        Invoke-PNPMPrune
        Removes extraneous packages.

    .EXAMPLE
        ppr
        Prunes packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ppr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('prune')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMRebuild {
    <#
    .SYNOPSIS
        Rebuild packages.

    .DESCRIPTION
        Rebuilds packages using 'pnpm rebuild' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm rebuild.

    .EXAMPLE
        Invoke-PNPMRebuild
        Rebuilds all packages.

    .EXAMPLE
        prb
        Rebuilds packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("prb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('rebuild')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMStore {
    <#
    .SYNOPSIS
        Manage pnpm store.

    .DESCRIPTION
        Manages the pnpm store using 'pnpm store' command.

    .PARAMETER SubCommand
        The store subcommand to execute.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm store.

    .EXAMPLE
        Invoke-PNPMStore status
        Shows store status.

    .EXAMPLE
        pst prune
        Prunes store using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pst")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$SubCommand,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('store')
    if ($SubCommand) {
        $allArgs += $SubCommand
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMStorePath {
    <#
    .SYNOPSIS
        Get pnpm store path.

    .DESCRIPTION
        Gets the pnpm store path using 'pnpm store path' command.

    .EXAMPLE
        Invoke-PNPMStorePath
        Shows the store path.

    .EXAMPLE
        pstp
        Shows store path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pstp")]
    [OutputType([void])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm store path
}

function Invoke-PNPMStoreStatus {
    <#
    .SYNOPSIS
        Check pnpm store status.

    .DESCRIPTION
        Checks the pnpm store status using 'pnpm store status' command.

    .EXAMPLE
        Invoke-PNPMStoreStatus
        Shows store status.

    .EXAMPLE
        psts
        Shows store status using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("psts")]
    [OutputType([void])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm store status
}

function Invoke-PNPMStorePrune {
    <#
    .SYNOPSIS
        Prune pnpm store.

    .DESCRIPTION
        Prunes unreferenced packages from the pnpm store using 'pnpm store prune' command.

    .EXAMPLE
        Invoke-PNPMStorePrune
        Prunes the store.

    .EXAMPLE
        pspr
        Prunes store using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pspr")]
    [OutputType([void])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm store prune
}

function Invoke-PNPMEnv {
    <#
    .SYNOPSIS
        Manage Node.js environment.

    .DESCRIPTION
        Manages Node.js environment using 'pnpm env' command.

    .PARAMETER SubCommand
        The env subcommand to execute.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm env.

    .EXAMPLE
        Invoke-PNPMEnv use --global lts
        Uses LTS Node.js globally.

    .EXAMPLE
        penv list
        Lists available Node.js versions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("penv")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$SubCommand,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('env')
    if ($SubCommand) {
        $allArgs += $SubCommand
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMSetup {
    <#
    .SYNOPSIS
        Setup pnpm.

    .DESCRIPTION
        Sets up pnpm using 'pnpm setup' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm setup.

    .EXAMPLE
        Invoke-PNPMSetup
        Sets up pnpm.

    .EXAMPLE
        psetup
        Sets up pnpm using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("psetup")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('setup')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMConfig {
    <#
    .SYNOPSIS
        Manage pnpm configuration.

    .DESCRIPTION
        Manages pnpm configuration using 'pnpm config' command.

    .PARAMETER SubCommand
        The config subcommand to execute.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm config.

    .EXAMPLE
        Invoke-PNPMConfig get registry
        Gets registry configuration.

    .EXAMPLE
        pcfg set registry https://registry.npmjs.org
        Sets registry configuration using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pcfg")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$SubCommand,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('config')
    if ($SubCommand) {
        $allArgs += $SubCommand
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMConfigGet {
    <#
    .SYNOPSIS
        Get pnpm configuration value.

    .DESCRIPTION
        Gets a pnpm configuration value using 'pnpm config get' command.

    .PARAMETER Key
        The configuration key to get.

    .EXAMPLE
        Invoke-PNPMConfigGet registry
        Gets registry configuration.

    .EXAMPLE
        pcfgg store-dir
        Gets store directory configuration using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pcfgg")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Key
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('config', 'get')
    if ($Key) {
        $allArgs += $Key
    }

    & pnpm @allArgs
}

function Invoke-PNPMConfigSet {
    <#
    .SYNOPSIS
        Set pnpm configuration value.

    .DESCRIPTION
        Sets a pnpm configuration value using 'pnpm config set' command.

    .PARAMETER Key
        The configuration key to set.

    .PARAMETER Value
        The value to set.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm config set.

    .EXAMPLE
        Invoke-PNPMConfigSet registry https://registry.npmjs.org
        Sets registry configuration.

    .EXAMPLE
        pcfgs store-dir /path/to/store
        Sets store directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pcfgs")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Key,

        [Parameter(Position = 1)]
        [string]$Value,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('config', 'set')
    if ($Key) {
        $allArgs += $Key
    }
    if ($Value) {
        $allArgs += $Value
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMConfigDelete {
    <#
    .SYNOPSIS
        Delete pnpm configuration value.

    .DESCRIPTION
        Deletes a pnpm configuration value using 'pnpm config delete' command.

    .PARAMETER Key
        The configuration key to delete.

    .EXAMPLE
        Invoke-PNPMConfigDelete registry
        Deletes registry configuration.

    .EXAMPLE
        pcfgd store-dir
        Deletes store directory configuration using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pcfgd")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Key
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('config', 'delete')
    if ($Key) {
        $allArgs += $Key
    }

    & pnpm @allArgs
}

function Invoke-PNPMConfigList {
    <#
    .SYNOPSIS
        List all pnpm configuration.

    .DESCRIPTION
        Lists all pnpm configuration using 'pnpm config list' command.

    .EXAMPLE
        Invoke-PNPMConfigList
        Lists all configuration.

    .EXAMPLE
        pcfgl
        Lists configuration using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pcfgl")]
    [OutputType([void])]
    param()

    if (-not (Test-PNPMInstalled)) {
        return
    }

    & pnpm config list
}

function Invoke-PNPMPatch {
    <#
    .SYNOPSIS
        Patch a package.

    .DESCRIPTION
        Creates a patch for a package using 'pnpm patch' command.

    .PARAMETER PackageName
        Name of the package to patch.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm patch.

    .EXAMPLE
        Invoke-PNPMPatch lodash@4.17.21
        Creates a patch for lodash.

    .EXAMPLE
        ppatch react@18.2.0
        Patches React using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ppatch")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('patch')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMPatchCommit {
    <#
    .SYNOPSIS
        Commit a patch.

    .DESCRIPTION
        Commits a patch using 'pnpm patch-commit' command.

    .PARAMETER PatchDir
        The patch directory path.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm patch-commit.

    .EXAMPLE
        Invoke-PNPMPatchCommit /tmp/patch-dir
        Commits the patch.

    .EXAMPLE
        ppatchc /tmp/patch-dir
        Commits patch using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("ppatchc")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PatchDir,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('patch-commit')
    if ($PatchDir) {
        $allArgs += $PatchDir
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMFetch {
    <#
    .SYNOPSIS
        Fetch packages to store.

    .DESCRIPTION
        Fetches packages to the store using 'pnpm fetch' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm fetch.

    .EXAMPLE
        Invoke-PNPMFetch
        Fetches packages to store.

    .EXAMPLE
        pfetch --dev
        Fetches including dev dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pfetch")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('fetch')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMLink {
    <#
    .SYNOPSIS
        Link packages for development.

    .DESCRIPTION
        Links packages for development using 'pnpm link' command.

    .PARAMETER PackagePath
        Path to the package to link.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm link.

    .EXAMPLE
        Invoke-PNPMLink
        Links current package globally.

    .EXAMPLE
        plnk ../my-package
        Links a local package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("plnk")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackagePath,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('link')
    if ($PackagePath) {
        $allArgs += $PackagePath
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMUnlink {
    <#
    .SYNOPSIS
        Unlink packages.

    .DESCRIPTION
        Unlinks packages using 'pnpm unlink' command.

    .PARAMETER PackageName
        Name of the package to unlink.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm unlink.

    .EXAMPLE
        Invoke-PNPMUnlink
        Unlinks current package.

    .EXAMPLE
        punlnk my-package
        Unlinks a specific package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("punlnk")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('unlink')
    if ($PackageName) {
        $allArgs += $PackageName
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMImport {
    <#
    .SYNOPSIS
        Import from another lockfile.

    .DESCRIPTION
        Imports from another lockfile using 'pnpm import' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm import.

    .EXAMPLE
        Invoke-PNPMImport
        Imports from package-lock.json.

    .EXAMPLE
        pimp
        Imports lockfile using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pimp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('import')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMDeploy {
    <#
    .SYNOPSIS
        Deploy for production.

    .DESCRIPTION
        Deploys packages for production using 'pnpm deploy' command.

    .PARAMETER Directory
        Target directory for deployment.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm deploy.

    .EXAMPLE
        Invoke-PNPMDeploy dist
        Deploys to dist directory.

    .EXAMPLE
        pdep build
        Deploys to build directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pdep")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Directory,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('deploy')
    if ($Directory) {
        $allArgs += $Directory
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}

function Invoke-PNPMCatalog {
    <#
    .SYNOPSIS
        Browse package catalog.

    .DESCRIPTION
        Browses the package catalog using 'pnpm catalog' command.

    .PARAMETER Arguments
        Additional arguments to pass to pnpm catalog.

    .EXAMPLE
        Invoke-PNPMCatalog
        Opens package catalog.

    .EXAMPLE
        pcat
        Opens catalog using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md
    #>
    [CmdletBinding()]
    [Alias("pcat")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-PNPMInstalled)) {
        return
    }

    $allArgs = @('catalog')
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & pnpm @allArgs
}
