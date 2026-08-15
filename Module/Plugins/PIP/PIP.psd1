#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PIP Manifest
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
#       This module provides pip CLI shortcuts and utility functions for improved Python
#       package management workflow in PowerShell environments. Includes features such
#       as package installation, upgrading, uninstallation, requirements file management,
#       and GitHub integration, all with full parameter support and PowerShell completion.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'PIP.psm1'
    ModuleVersion          = '4.2.0'
    CompatiblePSEditions   = @(
        'Core'
    )
    GUID                   = '8c3f9e4b-0d2e-5f6a-9b8c-2d3e4f5a6b7c'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'A comprehensive PowerShell module that provides pip CLI shortcuts and utility functions for Python package management workflow. Includes automatic completion, package management, requirements handling, GitHub installations, and advanced pip operations.'
    PowerShellVersion      = '7.0'
    DotNetFrameworkVersion = '4.5'
    CLRVersion             = '4.0'
    FunctionsToExport      = @(
        'Get-PipCacheFile',
        'Clear-PipCache',
        'Update-PipPackageCache',
        'Invoke-PipInstall',
        'Invoke-PipUpgrade',
        'Invoke-PipUninstall',
        'Invoke-PipInstallUser',
        'Invoke-PipInstallEditable',
        'Invoke-PipFreeze',
        'Invoke-PipFreezeGrep',
        'Invoke-PipListOutdated',
        'Invoke-PipList',
        'Invoke-PipShow',
        'Invoke-PipSearch',
        'Invoke-PipRequirements',
        'Invoke-PipInstallRequirements',
        'Invoke-PipUpgradeAll',
        'Invoke-PipUninstallAll',
        'Invoke-PipInstallGitHub',
        'Invoke-PipInstallGitHubBranch',
        'Invoke-PipInstallGitHubPR',
        'Invoke-PipCheck',
        'Invoke-PipWheel',
        'Invoke-PipDownload',
        'Invoke-PipConfig',
        'Invoke-PipDebug',
        'Invoke-PipHash',
        'Invoke-PipHelp',
        'Invoke-PipCache'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'pipi',
        'pipu',
        'pipun',
        'pipiu',
        'pipie',
        'pipgi',
        'piplo',
        'pipl',
        'pips',
        'pipsr',
        'pipreq',
        'pipir',
        'pipupall',
        'pipunall',
        'pipig',
        'pipigb',
        'pipigp',
        'pipck',
        'pipw',
        'pipd',
        'pipc',
        'pipdbg',
        'piph',
        'pipcc'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'pip',
                'python',
                'package-manager',
                'powershell',
                'cli',
                'development',
                'workflow',
                'automation',
                'requirements',
                'virtualenv'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://github.com/MKAbuMattar/powershell-profile/raw/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md'
    DefaultCommandPrefix   = ''
}
