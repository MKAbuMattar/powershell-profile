#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Deno Manifest
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
#       This module provides Deno CLI shortcuts and utility functions for TypeScript/JavaScript
#       runtime operations in PowerShell environments. Supports bundling, compilation, caching,
#       formatting, linting, running, testing, and upgrade functionality with comprehensive
#       development workflow automation.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{  
    RootModule             = 'Deno.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @()
    GUID                   = '12b8e8d3-4c9a-4b8e-9f2a-8c7b6d5e4f3a'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive Deno CLI integration with PowerShell functions and convenient aliases for TypeScript/JavaScript runtime operations. Provides bundle, compile, cache, format, lint, run, test, and upgrade functionality with automatic PowerShell completion and enhanced workflow automation for modern Deno development.'
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
        'Get-DenoVersion',
        'Invoke-Deno',
        'Invoke-DenoBundle',
        'Invoke-DenoCompile',
        'Invoke-DenoCache',
        'Invoke-DenoFormat',
        'Invoke-DenoHelp',
        'Invoke-DenoLint',
        'Invoke-DenoRun',
        'Invoke-DenoRunAll',
        'Invoke-DenoRunWatch',
        'Invoke-DenoRunUnstable',
        'Invoke-DenoTest',
        'Invoke-DenoUpgrade',
        'Invoke-DenoInstall',
        'Invoke-DenoUninstall',
        'Invoke-DenoInfo',
        'Invoke-DenoEval',
        'Invoke-DenoRepl',
        'Invoke-DenoDoc',
        'Invoke-DenoCheck',
        'Invoke-DenoTypes',
        'Invoke-DenoInit',
        'Invoke-DenoTask',
        'Invoke-DenoServe',
        'Invoke-DenoPublish'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'd',
        'db',
        'dc', 
        'dca',
        'dfmt',
        'dh',
        'dli',
        'drn',
        'drA',
        'drw',
        'dru',
        'dts',
        'dup',
        'di',
        'dun',
        'dinf',
        'de',
        'dr',
        'ddoc',
        'dch',
        'dt',
        'dinit',
        'dtask',
        'dsv',
        'dpub'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'Deno.psm1',
        'Deno.psd1',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @('Deno', 'TypeScript', 'JavaScript', 'Runtime', 'CLI', 'Development', 'PowerShell', 'Automation')
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Deno/README.md'
    DefaultCommandPrefix   = ''
}
