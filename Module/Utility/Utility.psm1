#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Update Module
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
#       This Module provides a set of utility functions for various common tasks in PowerShell.
#       It includes functions for checking administrator privileges,
#       checking command existence, reloading the profile, getting system uptime,
#       getting command definitions, starting countdown timers, and starting stopwatches.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Import the custom utility modules
#---------------------------------------------------------------------------------------------------
$BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath '/'

# Get utility enable/disable settings from config
$utilityEnabled = Get-ProfileConfig -Key "modules.utilityEnabled" -Default @{}

$ModuleList = @(
    @{ Name = 'Utility-Base64'; Path = 'Base64/Base64.psd1'; ConfigKey = 'Base64' }
    @{ Name = 'Utility-Clock'; Path = 'Clock/Clock.psd1'; ConfigKey = 'Clock' }
    @{ Name = 'Utility-GitIgnore'; Path = 'GitIgnore/GitIgnore.psd1'; ConfigKey = 'GitIgnore' }
    @{ Name = 'Utility-Matrix'; Path = 'Matrix/Matrix.psd1'; ConfigKey = 'Matrix' }
    @{ Name = 'Utility-Misc'; Path = 'Misc/Misc.psd1'; ConfigKey = 'Misc' }
    @{ Name = 'Utility-PrayerTimes'; Path = 'PrayerTimes/PrayerTimes.psd1'; ConfigKey = 'PrayerTimes' }
    @{ Name = 'Utility-QRCode'; Path = 'QRCode/QRCode.psd1'; ConfigKey = 'QRCode' }
    @{ Name = 'Utility-RandomQuote'; Path = 'RandomQuote/RandomQuote.psd1'; ConfigKey = 'RandomQuote' }
    @{ Name = 'Utility-WeatherForecast'; Path = 'WeatherForecast/WeatherForecast.psd1'; ConfigKey = 'WeatherForecast' }
    @{ Name = 'Utility-WebSearch'; Path = 'WebSearch/WebSearch.psd1'; ConfigKey = 'WebSearch' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name
    $ConfigKey = $Module.ConfigKey

    # Check if utility is enabled in config (default to true if not specified)
    $isEnabled = if ($utilityEnabled.PSObject.Properties.Name -contains $ConfigKey) {
        $utilityEnabled.$ConfigKey
    }
    else {
        $true
    }

    if (-not $isEnabled) {
        Write-Verbose "$ModuleName is disabled in configuration. Skipping..."
        continue
    }

    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
}
