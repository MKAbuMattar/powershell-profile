#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Yarn Plugin
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
#       This module provides Yarn CLI shortcuts and utility functions for JavaScript/Node.js
#       package management, workspace handling, and development workflows in PowerShell
#       environments. Supports both Classic and Berry Yarn versions with automatic detection
#       and version-specific functionality.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Get-YarnVersion {
    <#
    .SYNOPSIS
        Gets the installed Yarn version.

    .DESCRIPTION
        Returns the version of Yarn that is currently installed and accessible.

    .OUTPUTS
        System.String
        The Yarn version string, or $null if Yarn is not available.

    .EXAMPLE
        Get-YarnVersion
        Returns the Yarn version (e.g., "1.22.19" or "3.6.4").

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $versionOutput = yarn --version 2>$null
        return $versionOutput.Trim()
    }
    catch {
        return $null
    }
}

function Test-YarnBerry {
    <#
    .SYNOPSIS
        Tests if the current Yarn installation is Berry (v2+).

    .DESCRIPTION
        Determines whether the current Yarn installation is Berry (Yarn 2+) or Classic (Yarn 1.x).
        This affects which commands and aliases are available.

    .OUTPUTS
        System.Boolean
        Returns $true if using Yarn Berry (v2+), $false if using Classic (v1.x).

    .EXAMPLE
        Test-YarnBerry
        Returns $true if using Yarn Berry, $false if using Yarn Classic.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $version = Get-YarnVersion
    if (-not $version) {
        return $false
    }

    try {
        $majorVersion = [int]($version -split '\.')[0]
        return $majorVersion -ge 2
    }
    catch {
        return $false
    }
}

function Get-YarnGlobalPath {
    <#
    .SYNOPSIS
        Gets the Yarn global bin directory path.

    .DESCRIPTION
        Returns the path to Yarn's global bin directory. For Classic Yarn, this is typically
        retrieved via 'yarn global bin'. For Berry, global packages are handled differently.

    .OUTPUTS
        System.String
        The path to the global bin directory, or $null if not available.

    .EXAMPLE
        Get-YarnGlobalPath
        Returns the global bin directory path.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $defaultPath = Join-Path $HOME ".yarn\bin"
        if (Test-Path $defaultPath -PathType Container) {
            return $defaultPath
        }

        if (-not (Test-YarnBerry)) {
            $globalBin = yarn global bin 2>$null
            if ($LASTEXITCODE -eq 0 -and $globalBin -and (Test-Path $globalBin -PathType Container)) {
                return $globalBin.Trim()
            }
        }

        return $null
    }
    catch {
        return $null
    }
}

function Initialize-YarnPath {
    <#
    .SYNOPSIS
        Initializes Yarn global bin directory in PATH.

    .DESCRIPTION
        Adds Yarn's global bin directory to the PATH environment variable if it exists
        and is not already present. This enables global packages to be executed directly.

    .EXAMPLE
        Initialize-YarnPath
        Adds Yarn global bin directory to PATH if needed.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $globalPath = Get-YarnGlobalPath
    if (-not $globalPath) {
        return
    }

    try {
        $currentPaths = $env:PATH -split [System.IO.Path]::PathSeparator
        if ($globalPath -notin $currentPaths) {
            $env:PATH = $env:PATH + [System.IO.Path]::PathSeparator + $globalPath
            Write-Verbose "Added Yarn global bin directory to PATH: $globalPath"
        }
    }
    catch {
        Write-Verbose "Failed to add Yarn global bin directory to PATH: $($_.Exception.Message)"
    }
}

function Invoke-Yarn {
    <#
    .SYNOPSIS
        Base Yarn command wrapper.

    .DESCRIPTION
        Executes Yarn commands with all provided arguments. Serves as the base wrapper
        for all Yarn operations and ensures Yarn is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Yarn command.

    .EXAMPLE
        Invoke-Yarn --version
        Shows Yarn version.

    .EXAMPLE
        Invoke-Yarn add react
        Adds React package to project.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("y")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    & yarn @Arguments
}

function Invoke-YarnAdd {
    <#
    .SYNOPSIS
        Add packages to Yarn project.

    .DESCRIPTION
        Adds one or more packages to the current Yarn project as production dependencies.
        Equivalent to 'yarn add' or 'ya' shortcut.

    .PARAMETER Packages
        Package names to add to the project.

    .PARAMETER Arguments
        Additional arguments to pass to yarn add.

    .EXAMPLE
        Invoke-YarnAdd react vue
        Adds React and Vue packages.

    .EXAMPLE
        ya lodash@latest
        Adds latest version of lodash using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ya")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    $allArgs = @('add') + $Packages
    & yarn @allArgs
}

function Invoke-YarnAddDev {
    <#
    .SYNOPSIS
        Add development packages to Yarn project.

    .DESCRIPTION
        Adds one or more packages to the current Yarn project as development dependencies.
        Equivalent to 'yarn add --dev' or 'yad' shortcut.

    .PARAMETER Packages
        Package names to add as development dependencies.

    .PARAMETER Arguments
        Additional arguments to pass to yarn add --dev.

    .EXAMPLE
        Invoke-YarnAddDev jest typescript
        Adds Jest and TypeScript as development dependencies.

    .EXAMPLE
        yad @types/node
        Adds Node.js types as dev dependency using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yad")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    $allArgs = @('add', '--dev') + $Packages
    & yarn @allArgs
}

function Invoke-YarnAddPeer {
    <#
    .SYNOPSIS
        Add peer dependencies to Yarn project.

    .DESCRIPTION
        Adds one or more packages to the current Yarn project as peer dependencies.
        Equivalent to 'yarn add --peer' or 'yap' shortcut.

    .PARAMETER Packages
        Package names to add as peer dependencies.

    .PARAMETER Arguments
        Additional arguments to pass to yarn add --peer.

    .EXAMPLE
        Invoke-YarnAddPeer react react-dom
        Adds React and React DOM as peer dependencies.

    .EXAMPLE
        yap vue@^3.0.0
        Adds Vue as peer dependency using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yap")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    $allArgs = @('add', '--peer') + $Packages
    & yarn @allArgs
}

function Invoke-YarnRemove {
    <#
    .SYNOPSIS
        Remove packages from Yarn project.

    .DESCRIPTION
        Removes one or more packages from the current Yarn project.
        Equivalent to 'yarn remove' or 'yrm' shortcut.

    .PARAMETER Packages
        Package names to remove from the project.

    .PARAMETER Arguments
        Additional arguments to pass to yarn remove.

    .EXAMPLE
        Invoke-YarnRemove lodash
        Removes lodash package.

    .EXAMPLE
        yrm jquery bootstrap
        Removes multiple packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yrm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    $allArgs = @('remove') + $Packages
    & yarn @allArgs
}

function Invoke-YarnUpgrade {
    <#
    .SYNOPSIS
        Upgrade Yarn project dependencies.

    .DESCRIPTION
        Upgrades dependencies in the current Yarn project to their latest compatible versions.
        Equivalent to 'yarn upgrade' or 'yup' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn upgrade.

    .EXAMPLE
        Invoke-YarnUpgrade
        Upgrades all dependencies.

    .EXAMPLE
        yup react
        Upgrades specific package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yup")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('upgrade') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnUpgradeInteractive {
    <#
    .SYNOPSIS
        Upgrade Yarn dependencies interactively.

    .DESCRIPTION
        Provides an interactive interface for upgrading dependencies in the Yarn project.
        Equivalent to 'yarn upgrade-interactive' or 'yui' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn upgrade-interactive.

    .EXAMPLE
        Invoke-YarnUpgradeInteractive
        Opens interactive upgrade interface.

    .EXAMPLE
        yui
        Opens interactive upgrade using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yui")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('upgrade-interactive') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnUpgradeInteractiveLatest {
    <#
    .SYNOPSIS
        Upgrade Yarn dependencies to latest versions interactively.

    .DESCRIPTION
        Provides an interactive interface for upgrading dependencies to their latest versions.
        For Berry, this is equivalent to 'yui'. For Classic, adds '--latest' flag.
        Equivalent to 'yarn upgrade-interactive [--latest]' or 'yuil' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn upgrade-interactive.

    .EXAMPLE
        Invoke-YarnUpgradeInteractiveLatest
        Opens interactive upgrade to latest versions.

    .EXAMPLE
        yuil
        Opens interactive latest upgrade using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yuil")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        $allArgs = @('upgrade-interactive') + $Arguments
    }
    else {
        $allArgs = @('upgrade-interactive', '--latest') + $Arguments
    }
    
    & yarn @allArgs
}

function Invoke-YarnInstall {
    <#
    .SYNOPSIS
        Install Yarn project dependencies.

    .DESCRIPTION
        Installs all dependencies defined in package.json using Yarn.
        Equivalent to 'yarn install' or 'yin' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn install.

    .EXAMPLE
        Invoke-YarnInstall
        Installs all project dependencies.

    .EXAMPLE
        yin --force
        Force installs dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yin")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('install') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnInstallImmutable {
    <#
    .SYNOPSIS
        Install dependencies immutably.

    .DESCRIPTION
        Installs dependencies without modifying lockfile. For Berry uses '--immutable',
        for Classic uses '--frozen-lockfile'. Equivalent to 'yii' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn install.

    .EXAMPLE
        Invoke-YarnInstallImmutable
        Installs dependencies without lockfile changes.

    .EXAMPLE
        yii
        Immutable install using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yii")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        $allArgs = @('install', '--immutable') + $Arguments
    }
    else {
        $allArgs = @('install', '--frozen-lockfile') + $Arguments
    }
    
    & yarn @allArgs
}

function Invoke-YarnInstallFrozenLockfile {
    <#
    .SYNOPSIS
        Install dependencies with frozen lockfile.

    .DESCRIPTION
        Alias for Invoke-YarnInstallImmutable. Installs dependencies without modifying lockfile.
        Equivalent to 'yarn install [--immutable|--frozen-lockfile]' or 'yifl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn install.

    .EXAMPLE
        Invoke-YarnInstallFrozenLockfile
        Installs with frozen lockfile.

    .EXAMPLE
        yifl
        Frozen lockfile install using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yifl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    Invoke-YarnInstallImmutable @Arguments
}

function Invoke-YarnInit {
    <#
    .SYNOPSIS
        Initialize new Yarn project.

    .DESCRIPTION
        Initializes a new Yarn project by creating package.json.
        Equivalent to 'yarn init' or 'yi' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn init.

    .EXAMPLE
        Invoke-YarnInit
        Initializes new project interactively.

    .EXAMPLE
        yi -y
        Initializes with defaults using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnRun {
    <#
    .SYNOPSIS
        Run Yarn script.

    .DESCRIPTION
        Runs a script defined in package.json scripts section.
        Equivalent to 'yarn run' or 'yrun' shortcut.

    .PARAMETER Script
        Name of the script to run.

    .PARAMETER Arguments
        Additional arguments to pass to the script.

    .EXAMPLE
        Invoke-YarnRun test
        Runs the test script.

    .EXAMPLE
        yrun build --production
        Runs build script with arguments using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yrun")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Script = @()
    )

    $allArgs = @('run') + $Script
    & yarn @allArgs
}

function Invoke-YarnStart {
    <#
    .SYNOPSIS
        Start Yarn project.

    .DESCRIPTION
        Runs the start script defined in package.json.
        Equivalent to 'yarn start' or 'yst' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn start.

    .EXAMPLE
        Invoke-YarnStart
        Starts the project.

    .EXAMPLE
        yst
        Starts using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yst")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('start') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnDev {
    <#
    .SYNOPSIS
        Run development script.

    .DESCRIPTION
        Runs the dev script defined in package.json.
        Equivalent to 'yarn dev' or 'yd' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn dev.

    .EXAMPLE
        Invoke-YarnDev
        Runs development server.

    .EXAMPLE
        yd --port 3000
        Runs dev server on specific port using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('dev') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnBuild {
    <#
    .SYNOPSIS
        Build Yarn project.

    .DESCRIPTION
        Runs the build script defined in package.json.
        Equivalent to 'yarn build' or 'yb' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn build.

    .EXAMPLE
        Invoke-YarnBuild
        Builds the project.

    .EXAMPLE
        yb --production
        Builds for production using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('build') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnServe {
    <#
    .SYNOPSIS
        Serve Yarn project.

    .DESCRIPTION
        Runs the serve script defined in package.json.
        Equivalent to 'yarn serve' or 'ys' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn serve.

    .EXAMPLE
        Invoke-YarnServe
        Serves the project.

    .EXAMPLE
        ys --host 0.0.0.0
        Serves on all interfaces using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ys")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('serve') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnTest {
    <#
    .SYNOPSIS
        Run Yarn project tests.

    .DESCRIPTION
        Runs the test script defined in package.json.
        Equivalent to 'yarn test' or 'yt' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn test.

    .EXAMPLE
        Invoke-YarnTest
        Runs all tests.

    .EXAMPLE
        yt --watch
        Runs tests in watch mode using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('test') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnTestCoverage {
    <#
    .SYNOPSIS
        Run Yarn tests with coverage.

    .DESCRIPTION
        Runs tests with coverage reporting.
        Equivalent to 'yarn test --coverage' or 'ytc' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn test --coverage.

    .EXAMPLE
        Invoke-YarnTestCoverage
        Runs tests with coverage.

    .EXAMPLE
        ytc
        Runs coverage tests using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ytc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('test', '--coverage') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnLint {
    <#
    .SYNOPSIS
        Run Yarn lint script.

    .DESCRIPTION
        Runs the lint script defined in package.json.
        Equivalent to 'yarn lint' or 'yln' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn lint.

    .EXAMPLE
        Invoke-YarnLint
        Runs linting.

    .EXAMPLE
        yln --fix
        Runs linting with fixes using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yln")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('lint') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnLintFix {
    <#
    .SYNOPSIS
        Run Yarn lint with automatic fixes.

    .DESCRIPTION
        Runs the lint script with automatic fixes.
        Equivalent to 'yarn lint --fix' or 'ylnf' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn lint --fix.

    .EXAMPLE
        Invoke-YarnLintFix
        Runs linting with automatic fixes.

    .EXAMPLE
        ylnf
        Runs lint fix using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ylnf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('lint', '--fix') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnFormat {
    <#
    .SYNOPSIS
        Run Yarn format script.

    .DESCRIPTION
        Runs the format script defined in package.json.
        Equivalent to 'yarn format' or 'yf' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn format.

    .EXAMPLE
        Invoke-YarnFormat
        Runs code formatting.

    .EXAMPLE
        yf --write
        Formats and writes files using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('format') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnWorkspace {
    <#
    .SYNOPSIS
        Run Yarn workspace command.

    .DESCRIPTION
        Executes commands within a specific workspace in a monorepo setup.
        Equivalent to 'yarn workspace' or 'yw' shortcut.

    .PARAMETER WorkspaceName
        Name of the workspace to operate on.

    .PARAMETER Arguments
        Command and arguments to run in the workspace.

    .EXAMPLE
        Invoke-YarnWorkspace frontend build
        Builds the frontend workspace.

    .EXAMPLE
        yw api test
        Runs tests in api workspace using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yw")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('workspace') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnWorkspaces {
    <#
    .SYNOPSIS
        Run Yarn workspaces command.

    .DESCRIPTION
        Manages multiple workspaces in a monorepo setup.
        Equivalent to 'yarn workspaces' or 'yws' shortcut.

    .PARAMETER Arguments
        Arguments to pass to yarn workspaces.

    .EXAMPLE
        Invoke-YarnWorkspaces info
        Shows workspace information.

    .EXAMPLE
        yws foreach run build
        Runs build in all workspaces using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yws")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('workspaces') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnWhy {
    <#
    .SYNOPSIS
        Show why a package is installed.

    .DESCRIPTION
        Explains why a package is installed and what depends on it.
        Equivalent to 'yarn why' or 'yy' shortcut.

    .PARAMETER PackageName
        Name of the package to analyze.

    .PARAMETER Arguments
        Additional arguments to pass to yarn why.

    .EXAMPLE
        Invoke-YarnWhy lodash
        Shows why lodash is installed.

    .EXAMPLE
        yy react
        Shows React dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yy")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('why') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnVersion {
    <#
    .SYNOPSIS
        Manage Yarn project version.

    .DESCRIPTION
        Updates the version in package.json according to semantic versioning rules.
        Equivalent to 'yarn version' or 'yv' shortcut.

    .PARAMETER Arguments
        Version increment type or specific version.

    .EXAMPLE
        Invoke-YarnVersion patch
        Increments patch version.

    .EXAMPLE
        yv 2.0.0
        Sets specific version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('version') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnHelp {
    <#
    .SYNOPSIS
        Show Yarn help.

    .DESCRIPTION
        Displays help information for Yarn commands.
        Equivalent to 'yarn help' or 'yh' shortcut.

    .PARAMETER Arguments
        Command to get help for.

    .EXAMPLE
        Invoke-YarnHelp
        Shows general Yarn help.

    .EXAMPLE
        yh add
        Shows help for add command using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('help') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnPack {
    <#
    .SYNOPSIS
        Pack Yarn project.

    .DESCRIPTION
        Creates a tarball from the current package.
        Equivalent to 'yarn pack' or 'yp' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn pack.

    .EXAMPLE
        Invoke-YarnPack
        Creates package tarball.

    .EXAMPLE
        yp --filename mypackage.tgz
        Packs with custom filename using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('pack') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnCacheClean {
    <#
    .SYNOPSIS
        Clean Yarn cache.

    .DESCRIPTION
        Clears Yarn's package cache.
        Equivalent to 'yarn cache clean' or 'ycc' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn cache clean.

    .EXAMPLE
        Invoke-YarnCacheClean
        Cleans the Yarn cache.

    .EXAMPLE
        ycc
        Cleans cache using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ycc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('cache', 'clean') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnDlx {
    <#
    .SYNOPSIS
        Download and execute package with Yarn Berry.

    .DESCRIPTION
        Downloads and executes a package without installing it globally.
        Only available in Yarn Berry (v2+). Equivalent to 'yarn dlx' or 'ydlx' shortcut.

    .PARAMETER Package
        Package name to download and execute.

    .PARAMETER Arguments
        Arguments to pass to the package.

    .EXAMPLE
        Invoke-YarnDlx create-react-app my-app
        Creates React app without installing globally.

    .EXAMPLE
        ydlx cowsay Hello
        Runs cowsay without installation using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ydlx")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-YarnBerry)) {
        Write-Warning "yarn dlx is only available in Yarn Berry (v2+). Current version is Classic."
        return
    }

    $allArgs = @('dlx') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnNode {
    <#
    .SYNOPSIS
        Run Node.js with Yarn Berry.

    .DESCRIPTION
        Runs Node.js with the project's Yarn configuration and PnP resolution.
        Only available in Yarn Berry (v2+). Equivalent to 'yarn node' or 'yn' shortcut.

    .PARAMETER Arguments
        Arguments to pass to Node.js.

    .EXAMPLE
        Invoke-YarnNode --version
        Shows Node.js version with Yarn context.

    .EXAMPLE
        yn script.js
        Runs Node.js script using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yn")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-YarnBerry)) {
        Write-Warning "yarn node is only available in Yarn Berry (v2+). Current version is Classic."
        return
    }

    $allArgs = @('node') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnGlobalAdd {
    <#
    .SYNOPSIS
        Add global packages with Yarn Classic.

    .DESCRIPTION
        Adds packages to Yarn's global installation directory.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn global add' or 'yga' shortcut.

    .PARAMETER Packages
        Package names to install globally.

    .PARAMETER Arguments
        Additional arguments to pass to yarn global add.

    .EXAMPLE
        Invoke-YarnGlobalAdd nodemon
        Installs nodemon globally.

    .EXAMPLE
        yga typescript @types/node
        Installs TypeScript globally using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yga")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn global is not available in Yarn Berry (v2+). Use 'yarn dlx' for temporary installs."
        return
    }

    $allArgs = @('global', 'add') + $Packages
    & yarn @allArgs
}

function Invoke-YarnGlobalList {
    <#
    .SYNOPSIS
        List global packages with Yarn Classic.

    .DESCRIPTION
        Lists globally installed packages.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn global list' or 'ygls' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn global list.

    .EXAMPLE
        Invoke-YarnGlobalList
        Lists globally installed packages.

    .EXAMPLE
        ygls --depth=0
        Lists top-level global packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ygls")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn global is not available in Yarn Berry (v2+)."
        return
    }

    $allArgs = @('global', 'list') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnGlobalRemove {
    <#
    .SYNOPSIS
        Remove global packages with Yarn Classic.

    .DESCRIPTION
        Removes packages from Yarn's global installation directory.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn global remove' or 'ygrm' shortcut.

    .PARAMETER Packages
        Package names to remove globally.

    .PARAMETER Arguments
        Additional arguments to pass to yarn global remove.

    .EXAMPLE
        Invoke-YarnGlobalRemove nodemon
        Removes nodemon globally.

    .EXAMPLE
        ygrm typescript
        Removes TypeScript globally using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ygrm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Packages = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn global is not available in Yarn Berry (v2+)."
        return
    }

    $allArgs = @('global', 'remove') + $Packages
    & yarn @allArgs
}

function Invoke-YarnGlobalUpgrade {
    <#
    .SYNOPSIS
        Upgrade global packages with Yarn Classic.

    .DESCRIPTION
        Upgrades globally installed packages.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn global upgrade' or 'ygu' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn global upgrade.

    .EXAMPLE
        Invoke-YarnGlobalUpgrade
        Upgrades all global packages.

    .EXAMPLE
        ygu nodemon
        Upgrades specific global package using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("ygu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn global is not available in Yarn Berry (v2+)."
        return
    }

    $allArgs = @('global', 'upgrade') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnList {
    <#
    .SYNOPSIS
        List installed packages with Yarn Classic.

    .DESCRIPTION
        Lists installed packages in the current project.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn list' or 'yls' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn list.

    .EXAMPLE
        Invoke-YarnList
        Lists all installed packages.

    .EXAMPLE
        yls --depth=0
        Lists top-level packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yls")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn list is not available in Yarn Berry (v2+). Use 'yarn info' instead."
        return
    }

    $allArgs = @('list') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnOutdated {
    <#
    .SYNOPSIS
        Show outdated packages with Yarn Classic.

    .DESCRIPTION
        Shows packages that have newer versions available.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn outdated' or 'yout' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn outdated.

    .EXAMPLE
        Invoke-YarnOutdated
        Shows outdated packages.

    .EXAMPLE
        yout
        Shows outdated packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yout")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn outdated is not available in Yarn Berry (v2+). Use 'yarn upgrade-interactive' instead."
        return
    }

    $allArgs = @('outdated') + $Arguments
    & yarn @allArgs
}

function Invoke-YarnGlobalUpgradeAndClean {
    <#
    .SYNOPSIS
        Upgrade global packages and clean cache.

    .DESCRIPTION
        Combines global upgrade with cache cleaning for maintenance.
        Only available in Yarn Classic (v1.x). Equivalent to 'yarn global upgrade && yarn cache clean' or 'yuca' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to yarn global upgrade.

    .EXAMPLE
        Invoke-YarnGlobalUpgradeAndClean
        Upgrades globals and cleans cache.

    .EXAMPLE
        yuca
        Maintenance operation using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md
    #>
    [CmdletBinding()]
    [Alias("yuca")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (Test-YarnBerry) {
        Write-Warning "yarn global is not available in Yarn Berry (v2+)."
        return
    }

    Write-Host "Upgrading global packages..." -ForegroundColor Yellow
    Invoke-YarnGlobalUpgrade @Arguments
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Cleaning cache..." -ForegroundColor Yellow
        Invoke-YarnCacheClean
    }
}
