#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Conda Manifest
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
#       This module provides Conda CLI shortcuts and utility functions for Python environment
#       and package management in PowerShell environments. Supports environment lifecycle
#       management, package installation, configuration management, and comprehensive Conda
#       workflow automation for data science and Python development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'Conda.psm1'
    ModuleVersion          = '4.2.0'
    CompatiblePSEditions   = @()
    GUID                   = '34d0a0f5-6e1c-4d0f-1f4c-0e9f8g7h6i5j'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive Conda CLI integration with PowerShell functions and convenient aliases for Python environment and package management. Provides complete environment lifecycle management, package installation, configuration management, and advanced Conda workflow automation with automatic PowerShell completion for data science and Python development.'
    PowerShellVersion      = '5.0'
    PowerShellHostName     = ''
    PowerShellHostVersion  = ''
    DotNetFrameworkVersion = ''
    ClrVersion             = ''
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @(
        'Get-CondaVersion',
        'Get-CondaInfo',
        'Get-CondaEnvs',
        'Get-CurrentCondaEnv',
        'Invoke-Conda',
        'Invoke-CondaActivate',
        'Invoke-CondaActivateBase',
        'Invoke-CondaDeactivate',
        'Invoke-CondaCreate',
        'Invoke-CondaCreateFromFile',
        'Invoke-CondaCreateName',
        'Invoke-CondaCreatePath',
        'Invoke-CondaCreateNameYes',
        'Invoke-CondaRemoveEnv',
        'Invoke-CondaRemoveEnvName',
        'Invoke-CondaRemoveEnvPath',
        'Invoke-CondaEnvList',
        'Invoke-CondaEnvExport',
        'Invoke-CondaEnvUpdate',
        'Invoke-CondaInstall',
        'Invoke-CondaInstallYes',
        'Invoke-CondaRemove',
        'Invoke-CondaRemoveYes',
        'Invoke-CondaUpdate',
        'Invoke-CondaUpdateAll',
        'Invoke-CondaUpdateConda',
        'Invoke-CondaList',
        'Invoke-CondaListExport',
        'Invoke-CondaListExplicit',
        'Invoke-CondaSearch',
        'Invoke-CondaConfig',
        'Invoke-CondaConfigShowSources',
        'Invoke-CondaConfigGet',
        'Invoke-CondaConfigSet',
        'Invoke-CondaConfigRemove',
        'Invoke-CondaConfigAdd',
        'Invoke-CondaClean',
        'Invoke-CondaCleanAll'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'cn',
        'cna',
        'cnab',
        'cnde',
        'cnc',
        'cncf',
        'cncn',
        'cncp',
        'cncr',
        'cnrn',
        'cnrp',
        'cnel',
        'cnee',
        'cneu',
        'cni',
        'cniy',
        'cnr',
        'cnry',
        'cnu',
        'cnua',
        'cnuc',
        'cnl',
        'cnle',
        'cnles',
        'cnsr',
        'cnconf',
        'cncss',
        'cnconfg',
        'cnconfs',
        'cnconfr',
        'cnconfa',
        'cncl',
        'cncla'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'Conda.psm1',
        'Conda.psd1',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'Conda',
                'Python',
                'Environment',
                'PackageManager',
                'DataScience',
                'CLI',
                'Development',
                'PowerShell',
                'Automation',
                'Anaconda',
                'Miniconda'
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
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md'
    DefaultCommandPrefix   = ''
}
