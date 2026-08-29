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
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'Yarn.psm1'
    ModuleVersion          = '5.1.0'
    CompatiblePSEditions   = @(
        'Core'
    )
    GUID                   = 'b9f8c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive Yarn CLI integration with PowerShell functions and convenient aliases for JavaScript/Node.js package management, workspace handling, and development workflows with support for both Classic and Berry Yarn versions.'
    PowerShellVersion      = '7.0'
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
        'Invoke-YarnRemove',
        'Invoke-YarnUpgrade',
        'Invoke-YarnUpgradeInteractive',
        'Invoke-YarnUpgradeInteractiveLatest',
        'Invoke-YarnInstall',
        'Invoke-YarnInstallImmutable',
        'Invoke-YarnInstallFrozenLockfile',
        'Invoke-YarnInit',
        'Invoke-YarnRun',
        'Invoke-YarnStart',
        'Invoke-YarnDev',
        'Invoke-YarnBuild',
        'Invoke-YarnServe',
        'Invoke-YarnTest',
        'Invoke-YarnTestCoverage',
        'Invoke-YarnLint',
        'Invoke-YarnLintFix',
        'Invoke-YarnFormat',
        'Invoke-YarnWorkspace',
        'Invoke-YarnWorkspaces',
        'Invoke-YarnWhy',
        'Invoke-YarnVersion',
        'Invoke-YarnHelp',
        'Invoke-YarnPack',
        'Invoke-YarnCacheClean',
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
        'yrm',
        'yup',
        'yui',
        'yuil',
        'yin',
        'yii',
        'yifl',
        'yi',
        'yrun',
        'yst',
        'yd',
        'yb',
        'ys',
        'yt',
        'ytc',
        'yln',
        'ylnf',
        'yf',
        'yw',
        'yws',
        'yy',
        'yv',
        'yh',
        'yp',
        'ycc',
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
