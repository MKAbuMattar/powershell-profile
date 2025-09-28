#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Poetry Manifest
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
#       This module provides Poetry CLI shortcuts and utility functions for improved Python
#       dependency management workflow in PowerShell environments. Includes functions for
#       initializing, adding, removing, and managing Python packages with convenient aliases
#       and virtual environment handling.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Poetry.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'f9a4c2e1-8b3d-4a5e-9c7f-6d8e2a1b4c9e'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Comprehensive Poetry CLI integration for PowerShell with 30+ functions and aliases for modern Python dependency management, virtual environment handling, package building, and project lifecycle management.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Test-PoetryInstalled',
        'Initialize-PoetryCompletion',
        'Invoke-Poetry',
        'Invoke-PoetryInit',
        'Invoke-PoetryNew',
        'Invoke-PoetryCheck',
        'Invoke-PoetryList',
        'Invoke-PoetryAdd',
        'Invoke-PoetryRemove',
        'Invoke-PoetryUpdate',
        'Invoke-PoetryInstall',
        'Invoke-PoetrySync',
        'Invoke-PoetryLock',
        'Invoke-PoetryExport',
        'Invoke-PoetryShell',
        'Invoke-PoetryRun',
        'Invoke-PoetryEnvInfo',
        'Invoke-PoetryEnvPath',
        'Invoke-PoetryEnvUse',
        'Invoke-PoetryEnvRemove',
        'Invoke-PoetryBuild',
        'Invoke-PoetryPublish',
        'Invoke-PoetryShow',
        'Invoke-PoetryShowLatest',
        'Invoke-PoetryShowTree',
        'Invoke-PoetryConfig',
        'Disable-PoetryVirtualenv',
        'Invoke-PoetrySelfUpdate',
        'Invoke-PoetrySelfAdd',
        'Invoke-PoetrySelfShowPlugins'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'poetry',
        'pin',         
        'pnew',        
        'pch',         
        'pcmd',        
        'pad',         
        'prm',           
        'pup',         
        'pinst',       
        'psync',        
        'plck',        
        'pexp',        
        'psh',         
        'prun',        
        'pvinf',        
        'ppath',         
        'pvu',          
        'pvrm',         
        'pbld',        
        'ppub',        
        'pshw',        
        'pslt',         
        'ptree',        
        'pconf',        
        'pvoff',         
        'psup',         
        'psad',         
        'pplug'          
    )
    DscResourcesToExport = @()
    ModuleList           = @()
    FileList             = @(
        'Poetry.psm1',
        'Poetry.psd1',
        'README.md'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Poetry', 'Python', 'PackageManager', 'Dependencies', 'VirtualEnv', 'Build', 'Publishing', 'CLI', 'PowerShell', 'Productivity')
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Poetry/README.md'
    DefaultCommandPrefix = ''
}
