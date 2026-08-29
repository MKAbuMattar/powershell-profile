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
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# The 33 pure wrappers live in commands.psd1 and are generated into NPM.Generated.ps1 by
# Tools/Update-PluginCommand.ps1, the same arrangement the Git plugin uses. Adding an npm shortcut
# means adding a row there, not writing out another 25-line function.
#
# The two functions below stay by hand because neither is a pure wrapper: Invoke-NpmExecute
# rewrites PATH around an arbitrary command, and Invoke-NpmVersion runs `npm --version` when it is
# given no arguments and `npm version ...` when it is.
#---------------------------------------------------------------------------------------------------

. (Join-Path $PSScriptRoot 'NPM.Generated.ps1')

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

    if ($Arguments) {
        $allArgs = @('version') + $Arguments
        & npm @allArgs
    }
    else {
        & npm --version
    }
}
