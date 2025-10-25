#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PrayerTimes Plugin
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
#       This module provides functions to retrieve and display Islamic prayer times
#       for a specified city and country using a Python backend.
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Get-PrayerTimes {
    <#
    .SYNOPSIS
        Gets the current prayer times for a specified city and country.

    .DESCRIPTION
        This function retrieves the current prayer times for a specified city and country using the AlAdhan API. It displays the prayer times in 12-hour or 24-hour format, along with the current prayer and the time remaining until the next prayer.

    .PARAMETER City
        Specifies the city to get the prayer times for.

    .PARAMETER Country
        Specifies the country to get the prayer times for.

    .PARAMETER Method
        Specifies the calculation method to use for the prayer times. The default value is 1.

    .PARAMETER Use24HourFormat
        Indicates whether to display the prayer times in 24-hour format. The default value is $false.

    .INPUTS
        City: (Required) The city to get the prayer times for.
        Country: (Required) The country to get the prayer times for.
        Method: (Optional) The calculation method to use for the prayer times. The default value is 1.
        Use24HourFormat: (Optional) Indicates whether to display the prayer times in 24-hour format. The default value is $false.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for retrieving and displaying the current prayer times in the PowerShell console.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        Get-PrayerTimes -City "Amman" -Country "Jordan"
        Retrieves the current prayer times for Amman, Jordan.

    .EXAMPLE
        Get-PrayerTimes -City "New York" -Country "USA" -Method 2 -Use24HourFormat
        Retrieves the current prayer times for New York, USA using calculation method 2 and displays the times in 24-hour format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("prayer")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The city to get the prayer times for."
        )]
        [Alias("c")]
        [string]$City,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The country to get the prayer times for."
        )]
        [Alias("o")]
        [string]$Country,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The calculation method to use for the prayer times."
        )]
        [Alias("m")]
        [int]$Method = 1,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to display the prayer times in 24-hour format."
        )]
        [Alias("f")]
        [switch]$Use24HourFormat = $false
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "prayer_times.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: prayer_times.py not found at $pythonScript" -ForegroundColor Red
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
        $pythonScript,
        "--city", $City,
        "--country", $Country,
        "--method", $Method
    )
    
    if ($Use24HourFormat) {
        $arguments += @("--format", "24")
    }

    try {
        & python @arguments
    }
    catch {
        Write-Host "Error executing prayer_times.py: $_" -ForegroundColor Red
    }
}
