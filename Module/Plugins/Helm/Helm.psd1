#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Helm Manifest
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
#       This module provides Helm CLI shortcuts and utility functions for improved
#       Kubernetes package management workflow in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Helm.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'a8b9c0d1-e2f3-4567-8901-234567890abc'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Helm plugin for MKAbuMattar PowerShell Profile - provides Helm CLI shortcuts and utility functions for Kubernetes package management workflows.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Invoke-Helm',
        'Invoke-HelmInstall',
        'Invoke-HelmUninstall',
        'Invoke-HelmSearch',
        'Invoke-HelmUpgrade'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'h',
        'hin',
        'hun',
        'hse',
        'hup'
    )
    DscResourcesToExport = @()
    ModuleList           = @()
    FileList             = @(
        'Helm.psm1',
        'Helm.psd1',
        'README.md'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Helm',
                'Kubernetes',
                'K8s',
                'DevOps',
                'CLI',
                'PowerShell', 
                'Profile',
                'Aliases'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            ReleaseNotes               = ''
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Helm/README.md'
    DefaultCommandPrefix = ''
}
