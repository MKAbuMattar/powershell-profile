#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - AWS Module Manifest
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
#       This module provides AWS CLI shortcuts and utility functions for improved AWS workflow
#       in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'AWS.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'd018c9e3-a978-4656-8557-495e86b160f1'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'AWS CLI shortcuts and utility functions with profile management, MFA support, and role assumption for PowerShell environments'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Get-AWSCurrentProfile',
        'Get-AWSCurrentRegion',
        'Update-AWSState',
        'Clear-AWSState',
        'Set-AWSProfile',
        'Set-AWSRegion',
        'Switch-AWSProfile',
        'Update-AWSAccessKey',
        'Get-AWSRegions',
        'Get-AWSProfiles',
        'Get-AWSPromptInfo',
        'Initialize-AWSState'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'agp',
        'agr',
        'asp',
        'asr',
        'acp',
        'aws-change-key',
        'aws-regions',
        'aws-profiles'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'AWS',
                'Cloud',
                'CLI',
                'Shortcuts',
                'Profile',
                'MFA',
                'SSO',
                'DevOps'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/AWS/README.md'
    DefaultCommandPrefix = ''
}
