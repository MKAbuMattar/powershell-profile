#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Process Manifest
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
#       This Module provides process management functions for PowerShell scripts and modules.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Process.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '17cd86a1-e7e6-4d3c-88cf-5942a4d58f4b'
    Author               = 'Mohammad Abu Mattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'The Process module provides a collection of functions for retrieving system information, managing processes, and clearing caches to enhance the PowerShell experience.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Get-SystemInfo',
        'Get-AllProcesses',
        'Get-ProcessByName',
        'Get-ProcessByPort',
        'Stop-ProcessByName',
        'Stop-ProcessByPort',
        'Invoke-ClearCache'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'sysinfo',
        'pall',
        'pgrep',
        'portgrep',
        'pkill',
        'portkill',
        'clear-cache'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Process/README.md'
    DefaultCommandPrefix = ''
}
