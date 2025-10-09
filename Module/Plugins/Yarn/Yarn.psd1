#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Yarn Manifest
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
#       This module provides Yarn CLI shortcuts and utility functions for JavaScript/Node.js
#       package management, workspace handling, and development workflows in PowerShell
#       environments. Supports both Classic and Berry Yarn versions with automatic detection
#       and version-specific functionality.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'Yarn.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @(
        'Desktop',
        'Core'
    )
    GUID                   = 'b9f8c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive Yarn CLI integration with PowerShell functions and convenient aliases for JavaScript/Node.js package management, workspace handling, and development workflows with support for both Classic and Berry Yarn versions.'
    PowerShellVersion      = '5.0'
    PowerShellHostName     = ''
    PowerShellHostVersion  = ''
    DotNetFrameworkVersion = ''
    CLRVersion             = ''
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @(
        'Get-YarnVersion',
        'Test-YarnBerry',
        'Get-YarnGlobalPath',
        'Initialize-YarnPath',
        'Invoke-Yarn',
        'Invoke-YarnAdd',
        'Invoke-YarnAddDev',
        'Invoke-YarnAddPeer',
        'Invoke-YarnBuild',
        'Invoke-YarnCacheClean',
        'Invoke-YarnDev',
        'Invoke-YarnFormat',
        'Invoke-YarnHelp',
        'Invoke-YarnInit',
        'Invoke-YarnInstall',
        'Invoke-YarnInstallImmutable',
        'Invoke-YarnInstallFrozenLockfile',
        'Invoke-YarnLint',
        'Invoke-YarnLintFix',
        'Invoke-YarnPack',
        'Invoke-YarnRemove',
        'Invoke-YarnRun',
        'Invoke-YarnServe',
        'Invoke-YarnStart',
        'Invoke-YarnTest',
        'Invoke-YarnTestCoverage',
        'Invoke-YarnUpgradeInteractive',
        'Invoke-YarnUpgradeInteractiveLatest',
        'Invoke-YarnUpgrade',
        'Invoke-YarnVersion',
        'Invoke-YarnWorkspace',
        'Invoke-YarnWorkspaces',
        'Invoke-YarnWhy',
        'Invoke-YarnDlx',
        'Invoke-YarnNode',
        'Invoke-YarnGlobalAdd',
        'Invoke-YarnGlobalList',
        'Invoke-YarnGlobalRemove',
        'Invoke-YarnGlobalUpgrade',
        'Invoke-YarnList',
        'Invoke-YarnOutdated',
        'Invoke-YarnGlobalUpgradeAndClean'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'y',
        'ya',
        'yad',
        'yap',
        'yb',
        'ycc',
        'yd',
        'yf',
        'yh',
        'yi',
        'yin',
        'yii',
        'yifl',
        'yln',
        'ylnf',
        'yp',
        'yrm',
        'yrun',
        'ys',
        'yst',
        'yt',
        'ytc',
        'yui',
        'yuil',
        'yup',
        'yv',
        'yw',
        'yws',
        'yy',
        'ydlx',
        'yn',
        'yga',
        'ygls',
        'ygrm',
        'ygu',
        'yls',
        'yout',
        'yuca'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'Yarn',
                'JavaScript',
                'Node.js',
                'PackageManager',
                'Frontend',
                'Development',
                'CLI',
                'Workspace',
                'Berry',
                'Classic'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()

        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Yarn/README.md'
    DefaultCommandPrefix   = ''
}
