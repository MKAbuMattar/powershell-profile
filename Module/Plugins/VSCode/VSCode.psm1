#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - VSCode Plugin
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
#       This module provides VS Code CLI shortcuts and utility functions for Visual Studio Code,
#       VS Code Insiders, and VSCodium in PowerShell environments. Supports automatic VS Code
#       flavour detection, file operations, extension management, and comprehensive VS Code
#       workflow automation for modern development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

$script:VSCodeExecutable = $null

function Get-VSCodeExecutable {
    <#
    .SYNOPSIS
        Gets the available VS Code executable.

    .DESCRIPTION
        Detects and returns the path to the available VS Code executable.
        Checks for manual user choice via $env:VSCODE, then auto-detects code, code-insiders, or codium.

    .OUTPUTS
        System.String
        The VS Code executable name/path, or $null if none is available.

    .EXAMPLE
        Get-VSCodeExecutable
        Returns the detected VS Code executable.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ($script:VSCodeExecutable) {
        return $script:VSCodeExecutable
    }

    if ($env:VSCODE) {
        try {
            $null = Get-Command $env:VSCODE -ErrorAction Stop
            $script:VSCodeExecutable = $env:VSCODE
            return $script:VSCodeExecutable
        }
        catch {
            Write-Warning "'$($env:VSCODE)' flavour of VS Code not detected."
            $env:VSCODE = $null
        }
    }

    $vsCodeFlavours = @('code', 'code-insiders', 'codium')
    
    foreach ($flavour in $vsCodeFlavours) {
        try {
            $null = Get-Command $flavour -ErrorAction Stop
            $script:VSCodeExecutable = $flavour
            Write-Verbose "Detected VS Code flavour: $flavour"
            return $script:VSCodeExecutable
        }
        catch {        }
    }

    Write-Warning "No VS Code flavour detected. Please install VS Code, VS Code Insiders, or VSCodium."
    return $null
}

function Invoke-VSCode {
    <#
    .SYNOPSIS
        Base VS Code command wrapper.

    .DESCRIPTION
        Executes VS Code commands with all provided arguments. Serves as the base wrapper
        for all VS Code operations and ensures VS Code is available before execution.
        If no arguments are provided, opens VS Code in the current directory.

    .PARAMETER Arguments
        All arguments to pass to VS Code command.

    .EXAMPLE
        Invoke-VSCode --version
        Shows VS Code version.

    .EXAMPLE
        Invoke-VSCode
        Opens VS Code in current directory.

    .EXAMPLE
        Invoke-VSCode file.txt
        Opens file.txt in VS Code.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vsc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    if ($Arguments.Count -eq 0) {
        & $vscode .
    }
    else {
        & $vscode @Arguments
    }
}

function Invoke-VSCodeAdd {
    <#
    .SYNOPSIS
        Add folder to last active VS Code window.

    .DESCRIPTION
        Adds folders to the last active VS Code window.
        Equivalent to 'code --add' or 'vsca' shortcut.

    .PARAMETER Arguments
        Folders to add to VS Code window.

    .EXAMPLE
        Invoke-VSCodeAdd ./src ./docs
        Adds src and docs folders to VS Code window.

    .EXAMPLE
        vsca C:\Projects\MyApp
        Adds folder using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vsca")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--add') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeDiff {
    <#
    .SYNOPSIS
        Open VS Code in diff mode.

    .DESCRIPTION
        Opens VS Code to compare two files in diff mode.
        Equivalent to 'code --diff' or 'vscd' shortcut.

    .PARAMETER Arguments
        Two files to compare and additional options.

    .EXAMPLE
        Invoke-VSCodeDiff file1.txt file2.txt
        Opens diff comparison between two files.

    .EXAMPLE
        vscd old.js new.js
        Opens diff using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--diff') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeGoto {
    <#
    .SYNOPSIS
        Open VS Code and go to specific line and column.

    .DESCRIPTION
        Opens a file in VS Code and navigates to a specific line and column.
        Equivalent to 'code --goto' or 'vscg' shortcut.

    .PARAMETER Arguments
        File path with optional line and column (file:line:column).

    .EXAMPLE
        Invoke-VSCodeGoto file.js:10:5
        Opens file.js and goes to line 10, column 5.

    .EXAMPLE
        vscg app.py:25
        Opens app.py at line 25 using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscg")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--goto') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeNewWindow {
    <#
    .SYNOPSIS
        Open VS Code in new window.

    .DESCRIPTION
        Forces VS Code to open in a new window instead of reusing existing window.
        Equivalent to 'code --new-window' or 'vscn' shortcut.

    .PARAMETER Arguments
        Files or folders to open in new window.

    .EXAMPLE
        Invoke-VSCodeNewWindow ./project
        Opens project in new VS Code window.

    .EXAMPLE
        vscn
        Opens new empty VS Code window using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscn")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--new-window') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeReuseWindow {
    <#
    .SYNOPSIS
        Open VS Code in existing window.

    .DESCRIPTION
        Forces VS Code to reuse an existing window instead of opening new one.
        Equivalent to 'code --reuse-window' or 'vscr' shortcut.

    .PARAMETER Arguments
        Files or folders to open in existing window.

    .EXAMPLE
        Invoke-VSCodeReuseWindow ./project
        Opens project in existing VS Code window.

    .EXAMPLE
        vscr file.txt
        Opens file in existing window using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--reuse-window') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeWait {
    <#
    .SYNOPSIS
        Open VS Code and wait for files to be closed.

    .DESCRIPTION
        Opens files in VS Code and waits for the files to be closed before returning.
        Equivalent to 'code --wait' or 'vscw' shortcut.

    .PARAMETER Arguments
        Files to open and wait for.

    .EXAMPLE
        Invoke-VSCodeWait config.json
        Opens config.json and waits until it's closed.

    .EXAMPLE
        vscw commit_message.txt
        Opens commit message file and waits using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscw")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--wait') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeUserDataDir {
    <#
    .SYNOPSIS
        Open VS Code with custom user data directory.

    .DESCRIPTION
        Opens VS Code using a custom user data directory for settings and extensions.
        Equivalent to 'code --user-data-dir' or 'vscu' shortcut.

    .PARAMETER Arguments
        User data directory path and additional arguments.

    .EXAMPLE
        Invoke-VSCodeUserDataDir ~/vscode-portable
        Opens VS Code with portable user data directory.

    .EXAMPLE
        vscu ./vscode-workspace-settings
        Opens with custom data dir using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--user-data-dir') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeProfile {
    <#
    .SYNOPSIS
        Open VS Code with specific profile.

    .DESCRIPTION
        Opens VS Code using a specific profile for different development environments.
        Equivalent to 'code --profile' or 'vscp' shortcut.

    .PARAMETER Arguments
        Profile name and additional arguments.

    .EXAMPLE
        Invoke-VSCodeProfile development
        Opens VS Code with development profile.

    .EXAMPLE
        vscp web-dev ./project
        Opens project with web-dev profile using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--profile') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeExtensionsDir {
    <#
    .SYNOPSIS
        Open VS Code with custom extensions directory.

    .DESCRIPTION
        Opens VS Code using a custom directory for extensions.
        Equivalent to 'code --extensions-dir' or 'vsced' shortcut.

    .PARAMETER Arguments
        Extensions directory path and additional arguments.

    .EXAMPLE
        Invoke-VSCodeExtensionsDir ~/vscode-extensions
        Opens VS Code with custom extensions directory.

    .EXAMPLE
        vsced ./project-extensions
        Opens with custom extensions dir using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vsced")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--extensions-dir') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeInstallExtension {
    <#
    .SYNOPSIS
        Install VS Code extension.

    .DESCRIPTION
        Installs one or more VS Code extensions.
        Equivalent to 'code --install-extension' or 'vscie' shortcut.

    .PARAMETER Arguments
        Extension IDs to install.

    .EXAMPLE
        Invoke-VSCodeInstallExtension ms-python.python
        Installs Python extension.

    .EXAMPLE
        vscie ms-vscode.powershell
        Installs PowerShell extension using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscie")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--install-extension') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeUninstallExtension {
    <#
    .SYNOPSIS
        Uninstall VS Code extension.

    .DESCRIPTION
        Uninstalls one or more VS Code extensions.
        Equivalent to 'code --uninstall-extension' or 'vscue' shortcut.

    .PARAMETER Arguments
        Extension IDs to uninstall.

    .EXAMPLE
        Invoke-VSCodeUninstallExtension ms-python.python
        Uninstalls Python extension.

    .EXAMPLE
        vscue old.extension.id
        Uninstalls extension using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscue")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--uninstall-extension') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeVerbose {
    <#
    .SYNOPSIS
        Open VS Code with verbose logging.

    .DESCRIPTION
        Opens VS Code with verbose logging enabled for debugging.
        Equivalent to 'code --verbose' or 'vscv' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass with verbose mode.

    .EXAMPLE
        Invoke-VSCodeVerbose
        Opens VS Code with verbose logging.

    .EXAMPLE
        vscv ./project
        Opens project with verbose mode using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--verbose') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeLog {
    <#
    .SYNOPSIS
        Open VS Code with specific log level.

    .DESCRIPTION
        Opens VS Code with specific logging level (trace, debug, info, warn, error, critical, off).
        Equivalent to 'code --log' or 'vscl' shortcut.

    .PARAMETER Arguments
        Log level and additional arguments.

    .EXAMPLE
        Invoke-VSCodeLog debug
        Opens VS Code with debug logging.

    .EXAMPLE
        vscl trace ./project
        Opens project with trace logging using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--log') + $Arguments
    & $vscode @allArgs
}

function Invoke-VSCodeDisableExtensions {
    <#
    .SYNOPSIS
        Open VS Code with all extensions disabled.

    .DESCRIPTION
        Opens VS Code with all extensions disabled for troubleshooting.
        Equivalent to 'code --disable-extensions' or 'vscde' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass with disabled extensions.

    .EXAMPLE
        Invoke-VSCodeDisableExtensions
        Opens VS Code with no extensions.

    .EXAMPLE
        vscde ./project
        Opens project without extensions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [Alias("vscde")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return
    }

    $allArgs = @('--disable-extensions') + $Arguments
    & $vscode @allArgs
}

function Get-VSCodeVersion {
    <#
    .SYNOPSIS
        Get VS Code version information.

    .DESCRIPTION
        Returns the version information of the detected VS Code installation.

    .OUTPUTS
        System.String
        The VS Code version string, or $null if VS Code is not available.

    .EXAMPLE
        Get-VSCodeVersion
        Returns the VS Code version information.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return $null
    }

    try {
        $versionOutput = & $vscode --version 2>$null
        return $versionOutput -join "`n"
    }
    catch {
        return $null
    }
}

function Get-VSCodeExtensions {
    <#
    .SYNOPSIS
        List installed VS Code extensions.

    .DESCRIPTION
        Returns a list of all installed VS Code extensions.

    .OUTPUTS
        System.String[]
        Array of extension IDs, or $null if VS Code is not available.

    .EXAMPLE
        Get-VSCodeExtensions
        Lists all installed extensions.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $vscode = Get-VSCodeExecutable
    if (-not $vscode) {
        return $null
    }

    try {
        $extensionsOutput = & $vscode --list-extensions 2>$null
        return $extensionsOutput
    }
    catch {
        return $null
    }
}
