#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - NPM Manifest
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
#       This module provides npm CLI shortcuts and utility functions for improved Node.js
#       package management workflow in PowerShell environments. Supports package installation,
#       updating, removal, script execution, publishing, and configuration management with
#       automatic PowerShell completion for modern JavaScript/Node.js development.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'NPM.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @(
        'Desktop',
        'Core'
    )
    GUID                   = '7b2e8f3a-9c1d-4e5f-8a7b-1c2d3e4f5a6b'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'A comprehensive PowerShell module that provides npm CLI shortcuts and utility functions for Node.js package management workflow. Includes automatic PowerShell completion, package management, dependency handling, and advanced npm operations.'
    PowerShellVersion      = '5.0'
    DotNetFrameworkVersion = '4.5'
    CLRVersion             = '4.0'
    FunctionsToExport      = @(
        'Invoke-NpmInstallGlobal',
        'Invoke-NpmInstallSave',
        'Invoke-NpmInstallDev',
        'Invoke-NpmInstallForce',
        'Invoke-NpmExecute',
        'Invoke-NpmOutdated',
        'Invoke-NpmUpdate',
        'Invoke-NpmVersion',
        'Invoke-NpmList',
        'Invoke-NpmListTopLevel',
        'Invoke-NpmStart',
        'Invoke-NpmTest',
        'Invoke-NpmRun',
        'Invoke-NpmPublish',
        'Invoke-NpmInit',
        'Invoke-NpmInfo',
        'Invoke-NpmSearch',
        'Invoke-NpmRunDev',
        'Invoke-NpmRunBuild',
        'Invoke-NpmInstall',
        'Invoke-NpmUninstall',
        'Invoke-NpmAudit',
        'Invoke-NpmAuditFix',
        'Invoke-NpmCache',
        'Invoke-NpmDoctor',
        'Invoke-NpmPing',
        'Invoke-NpmWhoami',
        'Invoke-NpmLogin',
        'Invoke-NpmLogout',
        'Invoke-NpmRunScript',
        'Invoke-NpmConfigList',
        'Invoke-NpmConfigGet',
        'Invoke-NpmConfigSet',
        'Invoke-NpmLink',
        'Invoke-NpmUnlink'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'npmg',
        'npmS',
        'npmD',
        'npmF',
        'npmE',
        'npmO',
        'npmU',
        'npmV',
        'npmL',
        'npmL0',
        'npmst',
        'npmt',
        'npmR',
        'npmP',
        'npmI',
        'npmi',
        'npmSe',
        'npmrd',
        'npmrb',
        'npma',
        'npmaf',
        'npmc',
        'npmdoc',
        'npmping',
        'npmwho',
        'npmlogin',
        'npmlogout',
        'npmrs',
        'npmcl',
        'npmcg',
        'npmcs',
        'npmln',
        'npmunln'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'npm',
                'nodejs',
                'node',
                'javascript',
                'package-manager',
                'powershell',
                'cli',
                'development',
                'workflow',
                'automation'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://github.com/MKAbuMattar/powershell-profile/raw/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/NPM/README.md'
    DefaultCommandPrefix   = ''
}
