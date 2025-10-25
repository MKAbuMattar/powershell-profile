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

$ModuleList = @(
    @{ Name = 'Utility-Base64'; Path = 'Base64/Base64.psd1' }
    @{ Name = 'Utility-GitIgnore'; Path = 'GitIgnore/GitIgnore.psd1' }
    @{ Name = 'Utility-Matrix'; Path = 'Matrix/Matrix.psd1' }
    @{ Name = 'Utility-Misc'; Path = 'Misc/Misc.psd1' }
    @{ Name = 'Utility-PrayerTimes'; Path = 'PrayerTimes/PrayerTimes.psd1' }
    @{ Name = 'Utility-QRCode'; Path = 'QRCode/QRCode.psd1' }
    @{ Name = 'Utility-RandomQuote'; Path = 'RandomQuote/RandomQuote.psd1' }
    @{ Name = 'Utility-Utility'; Path = 'Utility/Utility.psd1' }
    @{ Name = 'Utility-WeatherForecast'; Path = 'WeatherForecast/WeatherForecast.psd1' }
    @{ Name = 'Utility-WebSearch'; Path = 'WebSearch/WebSearch.psd1' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name

    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
}
