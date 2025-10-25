#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - RandomQuote Plugin
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
#       This module provides functions to retrieve and display random quotes
#       using a Python backend. Uses the Quotable API with color-coded output.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function Get-RandomQuote {
    <#
    .SYNOPSIS
        Retrieves a random quote from the Quotable API.

    .DESCRIPTION
        This function retrieves a random quote from the Quotable API and displays it
        with the author information. Supports multiple display formats including
        default (with colors), simple, and JSON.

    .PARAMETER Format
        The display format for the quote. Valid values are 'default', 'simple', and 'json'.
        Default is 'default' which displays with colors and formatting.

    .INPUTS
        Format: (Optional) The display format for the quote.

    .OUTPUTS
        This function displays formatted quote output to the console.

    .NOTES
        This function requires Python 3.6+ with the random_quote.py script available.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        Get-RandomQuote
        Retrieves and displays a random quote in default format.

    .EXAMPLE
        Get-RandomQuote -Format simple
        Displays the quote in simple format (quote and author only).

    .EXAMPLE
        Get-RandomQuote -Format json
        Displays the complete quote data in JSON format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("quote")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The display format for the quote."
        )]
        [ValidateSet("default", "simple", "json")]
        [Alias("f")]
        [string]$Format = "default"
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "random_quote.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: random_quote.py not found at $pythonScript" -ForegroundColor Red
        return
    }

    try {
        $pythonVersion = python --version 2>&1
    }
    catch {
        Write-Host "Error: Python is not installed or not available in PATH." -ForegroundColor Red
        return
    }

    $arguments = @(
        "--format", $Format
    )

    try {
        & python $pythonScript @arguments
    }
    catch {
        Write-Host "Error executing random_quote.py: $_" -ForegroundColor Red
    }
}

function Test-QuotableService {
    <#
    .SYNOPSIS
        Test connectivity to the Quotable API service.

    .DESCRIPTION
        Verifies that the Quotable API service is accessible and responding.
        Useful for troubleshooting network connectivity issues.

    .OUTPUTS
        Boolean. Returns $true if service is accessible, $false otherwise.

    .NOTES
        This function requires Python 3.6+ with the random_quote.py script available.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        Test-QuotableService
        Tests if the Quotable API service is available.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "random_quote.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: random_quote.py not found at $pythonScript" -ForegroundColor Red
        return $false
    }

    try {
        $pythonVersion = python --version 2>&1
    }
    catch {
        Write-Host "Error: Python is not installed or not available in PATH." -ForegroundColor Red
        return $false
    }

    try {
        & python $pythonScript --test 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        Write-Host "Error executing random_quote.py: $_" -ForegroundColor Red
        return $false
    }
}
