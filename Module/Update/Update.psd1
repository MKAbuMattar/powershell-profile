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
#       This Module provides functions to update the PowerShell profile and
#       its modules from the GitHub repository.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Update.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '74b25afc-cc1a-4658-9257-e4645e00c7b2'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'This module provides functions to update the local profile module directory, profile, and PowerShell.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Update-LocalProfileModuleDirectory',
        'Update-Profile',
        'Update-PowerShell',
        'Update-WindowsTerminalConfig'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'update-local-module',
        'update-profile',
        'update-ps1',
        'update-terminal-config'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Update',
                'System'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Update/README.md'
    DefaultCommandPrefix = ''
}

