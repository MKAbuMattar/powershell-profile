#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Update Manifest
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
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Utility.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '69fba7f4-822d-4201-bec5-7f7f03edfca3'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'A collection of utility functions for system and process management.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Test-Administrator',
        'Test-CommandExists',
        'Invoke-ReloadProfile',
        'Get-Uptime',
        'Get-CommandDefinition',
        'Get-RandomQuote',
        'Get-WeatherForecast',
        'Start-Countdown',
        'Start-StopWatch',
        'Get-WallClock',
        'Get-PrayerTimes',
        'Start-Matrix',
        'Get-DiskUsage',
        'ConvertTo-Base64',
        'ConvertTo-Base64File',
        'ConvertFrom-Base64',
        'Get-GitIgnore',
        'Get-GitIgnoreList', 
        'New-GitIgnoreFile',
        'Add-GitIgnoreContent',
        'Test-GitIgnoreService'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'is-admin',
        'command-exists',
        'reload-profile',
        'uptime',
        'def',
        'quote',
        'weather',
        'countdown',
        'stopwatch',
        'wallclock',
        'prayer',
        'matrix',
        'du',
        'e64',
        'ef64',
        'd64',
        'gitignore',
        'gilist',
        'ginew', 
        'giadd',
        'gitest'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Utility',
                'System',
                'Process',
                'Management'
            )
            LicenseUri                 = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            ReleaseNotes               = ''
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Utility/README.md'
    DefaultCommandPrefix = ''
}
