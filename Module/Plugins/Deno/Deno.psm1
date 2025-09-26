#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Deno Plugin
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
#       This module provides Deno CLI shortcuts and utility functions for TypeScript/JavaScript
#       runtime operations in PowerShell environments. Supports bundling, compilation, caching,
#       formatting, linting, running, testing, and upgrade functionality with comprehensive
#       development workflow automation.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Test-DenoInstalled {
    <#
    .SYNOPSIS
        Tests if Deno is installed and accessible.

    .DESCRIPTION
        Checks if Deno command is available in the current environment and validates basic functionality.
        Used internally by other Deno functions to ensure Deno is available before executing commands.

    .OUTPUTS
        System.Boolean
        Returns $true if Deno is available, $false otherwise.

    .EXAMPLE
        Test-DenoInstalled
        Returns $true if Deno is installed and accessible.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $null = Get-Command deno -ErrorAction Stop
        $null = deno --version 2>$null
        return $true
    }
    catch {
        Write-Warning "Deno is not installed or not accessible. Please install Deno to use Deno functions."
        return $false
    }
}

function Initialize-DenoCompletion {
    <#
    .SYNOPSIS
        Initializes Deno completion for PowerShell.

    .DESCRIPTION
        Sets up Deno command completion for PowerShell to provide tab completion for Deno commands,
        subcommands, and common operations. This function is automatically called when the module is imported.

    .EXAMPLE
        Initialize-DenoCompletion
        Sets up Deno completion for the current PowerShell session.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-DenoInstalled)) {
        return
    }

    try {
        Register-ArgumentCompleter -CommandName 'deno' -ScriptBlock {
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            
            $commonCommands = @(
                'bundle', 'compile', 'cache', 'fmt', 'help', 'lint', 'run', 'test', 'upgrade',
                'install', 'uninstall', 'info', 'eval', 'repl', 'doc', 'check', 'types',
                'init', 'task', 'serve', 'publish', 'add', 'remove', 'jupyter', 'coverage',
                'completions', 'lsp', 'vendor', 'bench'
            )
            
            $commonCommands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
    catch {
        Write-Verbose "Deno completion initialization failed: $($_.Exception.Message)"
    }
}

function Get-DenoVersion {
    <#
    .SYNOPSIS
        Gets the installed Deno version.

    .DESCRIPTION
        Returns the version of Deno that is currently installed and accessible.

    .OUTPUTS
        System.String
        The Deno version string, or $null if Deno is not available.

    .EXAMPLE
        Get-DenoVersion
        Returns the Deno version (e.g., "deno 1.45.5").

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not (Test-DenoInstalled)) {
        return $null
    }

    try {
        $versionOutput = deno --version 2>$null
        return $versionOutput.Trim()
    }
    catch {
        return $null
    }
}

function Invoke-Deno {
    <#
    .SYNOPSIS
        Base Deno command wrapper.

    .DESCRIPTION
        Executes Deno commands with all provided arguments. Serves as the base wrapper
        for all Deno operations and ensures Deno is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Deno command.

    .EXAMPLE
        Invoke-Deno --version
        Shows Deno version.

    .EXAMPLE
        Invoke-Deno run script.ts
        Runs TypeScript script.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("d")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    & deno @Arguments
}

function Invoke-DenoBundle {
    <#
    .SYNOPSIS
        Bundle Deno project.

    .DESCRIPTION
        Bundles a TypeScript/JavaScript project into a single JavaScript file using Deno.
        Equivalent to 'deno bundle' or 'db' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno bundle.

    .EXAMPLE
        Invoke-DenoBundle src/main.ts dist/bundle.js
        Bundles main.ts into bundle.js.

    .EXAMPLE
        db app.ts
        Bundles app.ts using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("db")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('bundle') + $Arguments
    & deno @allArgs
}

function Invoke-DenoCompile {
    <#
    .SYNOPSIS
        Compile Deno project to executable.

    .DESCRIPTION
        Compiles a TypeScript/JavaScript project into a standalone executable using Deno.
        Equivalent to 'deno compile' or 'dc' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno compile.

    .EXAMPLE
        Invoke-DenoCompile --output=myapp src/main.ts
        Compiles main.ts to myapp executable.

    .EXAMPLE
        dc app.ts
        Compiles app.ts using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('compile') + $Arguments
    & deno @allArgs
}

function Invoke-DenoCache {
    <#
    .SYNOPSIS
        Cache Deno dependencies.

    .DESCRIPTION
        Downloads and caches dependencies for a TypeScript/JavaScript project.
        Equivalent to 'deno cache' or 'dca' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno cache.

    .EXAMPLE
        Invoke-DenoCache deps.ts
        Caches dependencies from deps.ts.

    .EXAMPLE
        dca *.ts
        Caches all TypeScript files using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dca")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('cache') + $Arguments
    & deno @allArgs
}

function Invoke-DenoFormat {
    <#
    .SYNOPSIS
        Format Deno code.

    .DESCRIPTION
        Formats TypeScript/JavaScript code according to Deno's formatting standards.
        Equivalent to 'deno fmt' or 'dfmt' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno fmt.

    .EXAMPLE
        Invoke-DenoFormat
        Formats all supported files in current directory.

    .EXAMPLE
        dfmt src/
        Formats files in src directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dfmt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('fmt') + $Arguments
    & deno @allArgs
}

function Invoke-DenoHelp {
    <#
    .SYNOPSIS
        Show Deno help.

    .DESCRIPTION
        Displays help information for Deno commands.
        Equivalent to 'deno help' or 'dh' shortcut.

    .PARAMETER Arguments
        Command to get help for.

    .EXAMPLE
        Invoke-DenoHelp
        Shows general Deno help.

    .EXAMPLE
        dh run
        Shows help for run command using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('help') + $Arguments
    & deno @allArgs
}

function Invoke-DenoLint {
    <#
    .SYNOPSIS
        Lint Deno code.

    .DESCRIPTION
        Runs the Deno linter on TypeScript/JavaScript files.
        Equivalent to 'deno lint' or 'dli' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno lint.

    .EXAMPLE
        Invoke-DenoLint
        Lints all supported files in current directory.

    .EXAMPLE
        dli src/
        Lints files in src directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dli")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('lint') + $Arguments
    & deno @allArgs
}

function Invoke-DenoRun {
    <#
    .SYNOPSIS
        Run Deno script.

    .DESCRIPTION
        Runs a TypeScript/JavaScript file using Deno runtime.
        Equivalent to 'deno run' or 'drn' shortcut.

    .PARAMETER Arguments
        Script file and arguments to pass to deno run.

    .EXAMPLE
        Invoke-DenoRun app.ts
        Runs app.ts script.

    .EXAMPLE
        drn --allow-net server.ts
        Runs server.ts with network permissions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("drn")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('run') + $Arguments
    & deno @allArgs
}

function Invoke-DenoRunAll {
    <#
    .SYNOPSIS
        Run Deno script with all permissions.

    .DESCRIPTION
        Runs a TypeScript/JavaScript file using Deno runtime with all permissions enabled.
        Equivalent to 'deno run -A' or 'drA' shortcut.

    .PARAMETER Arguments
        Script file and arguments to pass to deno run -A.

    .EXAMPLE
        Invoke-DenoRunAll app.ts
        Runs app.ts with all permissions.

    .EXAMPLE
        drA server.ts
        Runs server.ts with all permissions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("drA")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('run', '-A') + $Arguments
    & deno @allArgs
}

function Invoke-DenoRunWatch {
    <#
    .SYNOPSIS
        Run Deno script in watch mode.

    .DESCRIPTION
        Runs a TypeScript/JavaScript file using Deno runtime in watch mode for automatic restarts.
        Equivalent to 'deno run --watch' or 'drw' shortcut.

    .PARAMETER Arguments
        Script file and arguments to pass to deno run --watch.

    .EXAMPLE
        Invoke-DenoRunWatch app.ts
        Runs app.ts in watch mode.

    .EXAMPLE
        drw server.ts
        Runs server.ts in watch mode using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("drw")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('run', '--watch') + $Arguments
    & deno @allArgs
}

function Invoke-DenoRunUnstable {
    <#
    .SYNOPSIS
        Run Deno script with unstable APIs.

    .DESCRIPTION
        Runs a TypeScript/JavaScript file using Deno runtime with unstable APIs enabled.
        Equivalent to 'deno run --unstable' or 'dru' shortcut.

    .PARAMETER Arguments
        Script file and arguments to pass to deno run --unstable.

    .EXAMPLE
        Invoke-DenoRunUnstable app.ts
        Runs app.ts with unstable APIs.

    .EXAMPLE
        dru experimental.ts
        Runs experimental.ts with unstable APIs using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dru")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('run', '--unstable') + $Arguments
    & deno @allArgs
}

function Invoke-DenoTest {
    <#
    .SYNOPSIS
        Run Deno tests.

    .DESCRIPTION
        Runs tests using Deno's built-in test runner.
        Equivalent to 'deno test' or 'dts' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno test.

    .EXAMPLE
        Invoke-DenoTest
        Runs all tests in current directory.

    .EXAMPLE
        dts --coverage
        Runs tests with coverage using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dts")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('test') + $Arguments
    & deno @allArgs
}

function Invoke-DenoCheck {
    <#
    .SYNOPSIS
        Type-check Deno files.

    .DESCRIPTION
        Type-checks TypeScript/JavaScript files without running them.
        Equivalent to 'deno check' or 'dch' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno check.

    .EXAMPLE
        Invoke-DenoCheck app.ts
        Type-checks app.ts.

    .EXAMPLE
        dch src/*.ts
        Type-checks all TypeScript files in src using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dch")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('check') + $Arguments
    & deno @allArgs
}

function Invoke-DenoUpgrade {
    <#
    .SYNOPSIS
        Upgrade Deno to latest version.

    .DESCRIPTION
        Upgrades Deno to the latest stable version.
        Equivalent to 'deno upgrade' or 'dup' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno upgrade.

    .EXAMPLE
        Invoke-DenoUpgrade
        Upgrades to latest stable version.

    .EXAMPLE
        dup --canary
        Upgrades to latest canary version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dup")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('upgrade') + $Arguments
    & deno @allArgs
}

function Invoke-DenoInstall {
    <#
    .SYNOPSIS
        Install Deno script.

    .DESCRIPTION
        Installs a script as an executable command.
        Equivalent to 'deno install' or 'di' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno install.

    .EXAMPLE
        Invoke-DenoInstall --name=file_server https://deno.land/std@0.200.0/http/file_server.ts
        Installs file server as executable.

    .EXAMPLE
        di -A -n serve https://deno.land/std/http/file_server.ts
        Installs file server with all permissions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("di")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('install') + $Arguments
    & deno @allArgs
}

function Invoke-DenoUninstall {
    <#
    .SYNOPSIS
        Uninstall Deno script.

    .DESCRIPTION
        Uninstalls a previously installed script command.
        Equivalent to 'deno uninstall' or 'dun' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno uninstall.

    .EXAMPLE
        Invoke-DenoUninstall file_server
        Uninstalls file_server command.

    .EXAMPLE
        dun serve
        Uninstalls serve command using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dun")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('uninstall') + $Arguments
    & deno @allArgs
}

function Invoke-DenoInfo {
    <#
    .SYNOPSIS
        Show Deno module information.

    .DESCRIPTION
        Shows information about modules, dependencies, and compilation details.
        Equivalent to 'deno info' or 'dinf' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno info.

    .EXAMPLE
        Invoke-DenoInfo
        Shows general Deno information.

    .EXAMPLE
        dinf app.ts
        Shows information about app.ts dependencies using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dinf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('info') + $Arguments
    & deno @allArgs
}

function Invoke-DenoEval {
    <#
    .SYNOPSIS
        Evaluate Deno code.

    .DESCRIPTION
        Evaluates TypeScript/JavaScript code directly from command line.
        Equivalent to 'deno eval' or 'de' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno eval.

    .EXAMPLE
        Invoke-DenoEval 'console.log("Hello World")'
        Evaluates and runs the provided code.

    .EXAMPLE
        de 'console.log(Deno.version)'
        Shows Deno version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("de")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('eval') + $Arguments
    & deno @allArgs
}

function Invoke-DenoRepl {
    <#
    .SYNOPSIS
        Start Deno REPL.

    .DESCRIPTION
        Starts the Deno Read-Eval-Print Loop for interactive development.
        Equivalent to 'deno repl' or 'dr' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno repl.

    .EXAMPLE
        Invoke-DenoRepl
        Starts interactive Deno REPL.

    .EXAMPLE
        dr --unstable
        Starts REPL with unstable APIs using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('repl') + $Arguments
    & deno @allArgs
}

function Invoke-DenoDoc {
    <#
    .SYNOPSIS
        Generate Deno documentation.

    .DESCRIPTION
        Shows documentation for TypeScript/JavaScript modules and symbols.
        Equivalent to 'deno doc' or 'ddoc' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno doc.

    .EXAMPLE
        Invoke-DenoDoc
        Shows documentation for current module.

    .EXAMPLE
        ddoc https://deno.land/std/fs/mod.ts
        Shows documentation for fs module using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("ddoc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('doc') + $Arguments
    & deno @allArgs
}

function Invoke-DenoTypes {
    <#
    .SYNOPSIS
        Print Deno runtime type definitions.

    .DESCRIPTION
        Prints TypeScript definitions for Deno runtime APIs.
        Equivalent to 'deno types' or 'dt' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno types.

    .EXAMPLE
        Invoke-DenoTypes
        Prints all Deno type definitions.

    .EXAMPLE
        dt > deno.d.ts
        Saves type definitions to file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('types') + $Arguments
    & deno @allArgs
}

function Invoke-DenoInit {
    <#
    .SYNOPSIS
        Initialize Deno project.

    .DESCRIPTION
        Initializes a new Deno project with basic structure.
        Equivalent to 'deno init' or 'dinit' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno init.

    .EXAMPLE
        Invoke-DenoInit
        Initializes project in current directory.

    .EXAMPLE
        dinit my-project
        Initializes project in my-project directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dinit")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('init') + $Arguments
    & deno @allArgs
}

function Invoke-DenoTask {
    <#
    .SYNOPSIS
        Run Deno task.

    .DESCRIPTION
        Runs tasks defined in deno.json or deno.jsonc configuration file.
        Equivalent to 'deno task' or 'dtask' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno task.

    .EXAMPLE
        Invoke-DenoTask start
        Runs the start task.

    .EXAMPLE
        dtask build
        Runs the build task using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dtask")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('task') + $Arguments
    & deno @allArgs
}

function Invoke-DenoServe {
    <#
    .SYNOPSIS
        Run Deno HTTP server.

    .DESCRIPTION
        Runs an HTTP server using Deno's built-in server capabilities.
        Equivalent to 'deno serve' or 'dsv' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno serve.

    .EXAMPLE
        Invoke-DenoServe server.ts
        Serves HTTP server from server.ts.

    .EXAMPLE
        dsv --port=8080 app.ts
        Serves app on port 8080 using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dsv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('serve') + $Arguments
    & deno @allArgs
}

function Invoke-DenoPublish {
    <#
    .SYNOPSIS
        Publish Deno module.

    .DESCRIPTION
        Publishes a Deno module to JSR (JavaScript Registry).
        Equivalent to 'deno publish' or 'dpub' shortcut.

    .PARAMETER Arguments
        Arguments to pass to deno publish.

    .EXAMPLE
        Invoke-DenoPublish
        Publishes current module.

    .EXAMPLE
        dpub --dry-run
        Performs dry run publish using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md
    #>
    [CmdletBinding()]
    [Alias("dpub")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-DenoInstalled)) {
        return
    }

    $allArgs = @('publish') + $Arguments
    & deno @allArgs
}

if (Test-DenoInstalled) {
    Initialize-DenoCompletion
}
