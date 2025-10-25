#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PNPM Manifest
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
#       This module provides comprehensive PNPM CLI integration with PowerShell functions and
#       convenient aliases for fast, disk space efficient package management. Provides complete
#       workspace support, dependency management, development workflow automation, and advanced
#       PNPM features with automatic PowerShell completion for modern JavaScript/Node.js development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'PNPM.psm1'
    ModuleVersion          = '4.2.0'
    CompatiblePSEditions   = @()
    GUID                   = '23c9f9e4-5d0b-4c9f-0f3b-9d8e7f6a5b4c'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive PNPM CLI integration with PowerShell functions and convenient aliases for fast, disk space efficient package management. Provides complete workspace support, dependency management, development workflow automation, and advanced PNPM features with automatic PowerShell completion for modern JavaScript/Node.js development.'
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
        'Get-PNPMVersion',
        'Get-PNPMStorePath',
        'Invoke-PNPM',
        'Invoke-PNPMAdd',
        'Invoke-PNPMAddDev',
        'Invoke-PNPMAddOptional',
        'Invoke-PNPMAddPeer',
        'Invoke-PNPMRemove',
        'Invoke-PNPMUpdate',
        'Invoke-PNPMUpdateInteractive',
        'Invoke-PNPMInstall',
        'Invoke-PNPMInstallFrozen',
        'Invoke-PNPMInit',
        'Invoke-PNPMRun',
        'Invoke-PNPMStart',
        'Invoke-PNPMDev',
        'Invoke-PNPMBuild',
        'Invoke-PNPMServe',
        'Invoke-PNPMTest',
        'Invoke-PNPMTestCoverage',
        'Invoke-PNPMLint',
        'Invoke-PNPMLintFix',
        'Invoke-PNPMFormat',
        'Invoke-PNPMExec',
        'Invoke-PNPMDlx',
        'Invoke-PNPMCreate',
        'Invoke-PNPMList',
        'Invoke-PNPMOutdated',
        'Invoke-PNPMAudit',
        'Invoke-PNPMAuditFix',
        'Invoke-PNPMWhy',
        'Invoke-PNPMPublish',
        'Invoke-PNPMPack',
        'Invoke-PNPMPrune',
        'Invoke-PNPMRebuild',
        'Invoke-PNPMStore',
        'Invoke-PNPMStorePath',
        'Invoke-PNPMStoreStatus',
        'Invoke-PNPMStorePrune',
        'Invoke-PNPMEnv',
        'Invoke-PNPMSetup',
        'Invoke-PNPMConfig',
        'Invoke-PNPMConfigGet',
        'Invoke-PNPMConfigSet',
        'Invoke-PNPMConfigDelete',
        'Invoke-PNPMConfigList',
        'Invoke-PNPMPatch',
        'Invoke-PNPMPatchCommit',
        'Invoke-PNPMFetch',
        'Invoke-PNPMLink',
        'Invoke-PNPMUnlink',
        'Invoke-PNPMImport',
        'Invoke-PNPMDeploy',
        'Invoke-PNPMCatalog'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'p',
        'pa',
        'pad',
        'pao',
        'pap',
        'prm',
        'pup',
        'pupi',
        'pi',
        'pif',
        'pin',
        'pr',
        'ps',
        'pd',
        'pb',
        'psv',
        'pt',
        'ptc',
        'pln',
        'plnf',
        'pf',
        'px',
        'pdlx',
        'pc',
        'pls',
        'pout',
        'paud',
        'paudf',
        'pw',
        'ppub',
        'ppk',
        'ppr',
        'prb',
        'pst',
        'pstp',
        'psts',
        'pspr',
        'penv',
        'psetup',
        'pcfg',
        'pcfgg',
        'pcfgs',
        'pcfgd',
        'pcfgl',
        'ppatch',
        'ppatchc',
        'pfetch',
        'plnk',
        'punlnk',
        'pimp',
        'pdep',
        'pcat'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'PNPM.psm1',
        'PNPM.psd1',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'PNPM',
                'PackageManager',
                'Node.js',
                'JavaScript',
                'TypeScript',
                'CLI',
                'Development',
                'PowerShell',
                'Automation',
                'Workspace',
                'Monorepo'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        } 
    } 
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PNPM/README.md'
    DefaultCommandPrefix   = ''
}
