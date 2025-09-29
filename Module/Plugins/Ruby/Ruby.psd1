#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Ruby Manifest
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
#       This module provides Ruby CLI shortcuts and utility functions for Ruby development
#       and gem management in PowerShell environments. Supports Ruby execution, gem operations,
#       file searching, development server, and comprehensive Ruby workflow automation for
#       modern Ruby development and scripting.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'Ruby.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @()
    GUID                   = '6f3e2a9b-8c4d-5e1f-3a6b-9c2d5e8f1a4b'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive Ruby CLI integration with PowerShell functions and convenient aliases for Ruby development and gem management. Provides Ruby execution, gem operations, file searching, development server, and comprehensive Ruby workflow automation with automatic PowerShell completion for modern Ruby development and scripting.'
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
        'Test-RubyInstalled',
        'Test-GemInstalled',
        'Initialize-RubyCompletion',
        'Get-RubyVersion',
        'Get-GemVersion',
        'Invoke-Ruby',
        'Invoke-RubyExecute',
        'Start-RubyServer',
        'Find-RubyFiles',
        'Invoke-Gem',
        'Invoke-SudoGem',
        'Install-Gem',
        'Uninstall-Gem',
        'Get-GemList',
        'Get-GemInfo',
        'Get-GemInfoAll',
        'Add-GemCert',
        'Remove-GemCert',
        'Build-GemCert',
        'Invoke-GemCleanup',
        'Invoke-GemGenerateIndex',
        'Get-GemHelp',
        'Lock-Gem',
        'Open-Gem',
        'Open-GemEditor'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'rb',
        'rrun',
        'rserver',
        'rfind',
        'sgem',
        'gein',
        'geun',
        'geli',
        'gei',
        'geiall',
        'geca',
        'gecr',
        'gecb',
        'geclup',
        'gegi',
        'geh',
        'gel',
        'geo',
        'geoe'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'Ruby.psm1',
        'Ruby.psd1',
        'README.md',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'Ruby', 
                'Gem',
                'RubyGems',
                'Development',
                'CLI',
                'PowerShell',
                'Programming',
                'Scripting'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    } 
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md'
    DefaultCommandPrefix   = ''
}
