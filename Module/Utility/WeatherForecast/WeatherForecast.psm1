#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - WeatherForecast Plugin
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
#       This module provides functions to retrieve and display weather forecasts
#       from the wttr.in service. Features ASCII art display with customizable options
#       including glyphs, moon phases, and multiple languages.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function Get-WeatherForecast {
    <#
    .SYNOPSIS
        Gets the weather forecast for a specified location.

    .DESCRIPTION
        This function retrieves the weather forecast for a specified location using the wttr.in service. 
        It returns the weather forecast in ASCII art format. The forecast can include weather glyphs, 
        moon phases, and be customized with additional options.

        This function wraps the weather_forecast.py Python script which handles API communication
        and data retrieval. Python 3.6+ is required.

    .PARAMETER Location
        Specifies the location to retrieve the weather forecast for. If not provided, the current 
        location is used based on IP geolocation.

    .PARAMETER Glyphs
        Indicates whether to display weather glyphs in the forecast. The default value is $true.

    .PARAMETER Moon
        Indicates whether to display moon phases in the forecast. The default value is $false.

    .PARAMETER Format
        Specifies a custom format code (0-6) for the weather forecast. Optional.

    .PARAMETER Lang
        Specifies the language for the weather forecast. The default language is "en".
        Supported languages: en, ar, de, es, fr, it, nl, pl, pt, ro, ru, tr

    .INPUTS
        None. You cannot pipe objects to this function.

    .OUTPUTS
        System.String. The weather forecast in ASCII art format.

    .EXAMPLE
        Get-WeatherForecast
        Retrieves the weather forecast for the current location.

    .EXAMPLE
        Get-WeatherForecast -Location "London"
        Retrieves the weather forecast for London.

    .EXAMPLE
        Get-WeatherForecast -Location "Paris" -Lang fr
        Retrieves the weather forecast for Paris in French.

    .EXAMPLE
        Get-WeatherForecast -Moon
        Retrieves the moon phase forecast.

    .EXAMPLE
        Get-WeatherForecast -Location "Tokyo" -Glyphs:$false
        Retrieves the weather forecast for Tokyo without weather glyphs.

    .NOTES
        Requires Python 3.6+ and internet connectivity to wttr.in service.
        The weather_forecast.py script must be in the same directory as this module.

    .LINK
        https://wttr.in/
        https://github.com/MKAbuMattar/powershell-profile
    #>

    [CmdletBinding()]
    [Alias("weather")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The location to retrieve the weather forecast for"
        )]
        [Alias("l")]
        [string]$Location,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Display weather glyphs"
        )]
        [Alias("g")]
        [switch]$Glyphs = $true,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Show moon phases instead of weather"
        )]
        [Alias("m")]
        [switch]$Moon,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Custom format code (0-6)"
        )]
        [Alias("f")]
        [string]$Format,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Language for output"
        )]
        [Alias("lang")]
        [ValidateSet(
            "en", "ar", "de", "es", "fr", "it", "nl",
            "pl", "pt", "ro", "ru", "tr", "uk", "ja",
            "zh", "vi", "th", "fa"
        )]
        [string]$Lang = "en"
    )

    begin {
        # Get the script directory
        $scriptDir = Split-Path -Parent $PSCommandPath

        # Build path to Python script
        $pythonScript = Join-Path $scriptDir "weather_forecast.py"

        # Check if Python script exists
        if (-not (Test-Path $pythonScript)) {
            Write-Error "weather_forecast.py not found at: $pythonScript"
            return
        }

        # Check if Python is available
        $pythonCmd = Get-Command python3, python -ErrorAction SilentlyContinue | Select-Object -First 1

        if (-not $pythonCmd) {
            Write-Error "Python 3 is not installed or not available in PATH"
            Write-Error "Please install Python 3.6 or later from https://www.python.org"
            return
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            # Build arguments
            $arguments = @($pythonScript)

            # Add location if provided
            if ($Location) {
                $arguments += $Location
            }

            # Add glyphs option
            if (-not $Glyphs) {
                $arguments += "--no-glyphs"
            }

            # Add moon option
            if ($Moon) {
                $arguments += "--moon"
            }

            # Add format if provided
            if ($Format) {
                $arguments += "--format"
                $arguments += $Format
            }

            # Add language
            if ($Lang -ne "en") {
                $arguments += "--lang"
                $arguments += $Lang
            }

            # Invoke Python script
            & $pythonPath $arguments 2>&1

        }
        catch {
            Write-Error "Failed to retrieve weather forecast: $_"
        }
    }
}

function Test-WeatherService {
    <#
    .SYNOPSIS
        Tests connectivity to the wttr.in weather service.

    .DESCRIPTION
        This function tests whether the wttr.in service is accessible and responding.
        Useful for troubleshooting connectivity issues.

    .INPUTS
        None. You cannot pipe objects to this function.

    .OUTPUTS
        System.Boolean. Returns $true if service is accessible, $false otherwise.

    .EXAMPLE
        Test-WeatherService
        Tests the weather service and displays the result.

    .NOTES
        Requires internet connectivity.

    .LINK
        https://wttr.in/
        https://github.com/MKAbuMattar/powershell-profile
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param ()

    begin {
        # Get the script directory
        $scriptDir = Split-Path -Parent $PSCommandPath

        # Build path to Python script
        $pythonScript = Join-Path $scriptDir "weather_forecast.py"

        # Check if Python script exists
        if (-not (Test-Path $pythonScript)) {
            Write-Error "weather_forecast.py not found at: $pythonScript"
            return $false
        }

        # Check if Python is available
        $pythonCmd = Get-Command python3, python -ErrorAction SilentlyContinue | Select-Object -First 1

        if (-not $pythonCmd) {
            Write-Error "Python 3 is not installed or not available in PATH"
            return $false
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            # Call Python script with --test flag
            $output = & $pythonPath $pythonScript --test 2>&1

            # Check for success indicator
            if ($output -match "\[+\]") {
                Write-Output $true
                return $true
            }
            else {
                Write-Output $false
                return $false
            }
        }
        catch {
            Write-Error "Error testing weather service: $_"
            return $false
        }
    }
}
