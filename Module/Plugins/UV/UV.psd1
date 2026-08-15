#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - UV Manifest
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
#       This module provides UV (Python package manager) CLI shortcuts and utility functions
#       for modern Python dependency management, virtual environment handling, and project
#       workflows in PowerShell environments. Converts 25+ common UV operations to PowerShell
#       functions with full parameter support and comprehensive Python project management.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'UV.psm1'
    ModuleVersion          = '4.2.0'
    CompatiblePSEditions   = @(
        'Core'
    )
    GUID                   = 'a8f7b2c3-4d5e-6f7a-8b9c-0d1e2f3a4b5c'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive UV (Python package manager) CLI integration with PowerShell functions and convenient aliases for modern Python dependency management, virtual environment handling, and project workflows.'
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
        'Get-UVProjectInfo',
        'Get-UVVirtualEnvPath',
        'Invoke-UVAdd',
        'Invoke-UVRemove',
        'Invoke-UVSync',
        'Invoke-UVSyncRefresh',
        'Invoke-UVSyncUpgrade',
        'Invoke-UVLock',
        'Invoke-UVLockRefresh',
        'Invoke-UVLockUpgrade',
        'Invoke-UVExport',
        'Invoke-UVRun',
        'Invoke-UVPython',
        'Invoke-UVPip',
        'Invoke-UVVenv',
        'Invoke-UVInit',
        'Invoke-UVBuild',
        'Invoke-UVPublish',
        'Invoke-UVTool',
        'Invoke-UVToolRun',
        'Invoke-UVToolInstall',
        'Invoke-UVToolUninstall',
        'Invoke-UVToolList',
        'Invoke-UVToolUpgrade',
        'Invoke-UVSelfUpdate',
        'Invoke-UVVersion'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'uva',
        'uvrm',
        'uvs',
        'uvsr',
        'uvsu',
        'uvl',
        'uvlr',
        'uvlu',
        'uvexp',
        'uvr',
        'uvpy',
        'uvp',
        'uvv',
        'uvi',
        'uvb',
        'uvpub',
        'uvt',
        'uvtr',
        'uvx',
        'uvti',
        'uvtu',
        'uvtl',
        'uvtup',
        'uvup',
        'uvver'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'UV.psm1',
        'UV.psd1',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'UV',
                'Python',
                'PackageManager',
                'VirtualEnvironment', 
                'Dependencies',
                'PyPI',
                'Poetry',
                'CLI',
                'Development',
                'Tools'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://github.com/MKAbuMattar/powershell-profile/raw/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md'
    DefaultCommandPrefix   = ''
}
