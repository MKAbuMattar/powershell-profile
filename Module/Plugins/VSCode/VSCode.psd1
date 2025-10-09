#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - VSCode Manifest
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
#       This module provides VS Code CLI shortcuts and utility functions for Visual Studio Code,
#       VS Code Insiders, and VSCodium in PowerShell environments. Supports automatic VS Code
#       flavour detection, file operations, extension management, and comprehensive VS Code
#       workflow automation for modern development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule             = 'VSCode.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @()
    GUID                   = '5e2d1f8a-7b3c-4d0e-2f5a-6b9c8d1e2f3a'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive VS Code CLI integration with PowerShell functions and convenient aliases for Visual Studio Code, VS Code Insiders, and VSCodium. Provides automatic VS Code flavour detection, file operations, extension management, and comprehensive VS Code workflow automation with automatic PowerShell completion for modern development.'
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
        'Get-VSCodeExecutable',
        'Initialize-VSCodeCompletion',
        'Invoke-VSCode',
        'Invoke-VSCodeAdd',
        'Invoke-VSCodeDiff',
        'Invoke-VSCodeGoto',
        'Invoke-VSCodeNewWindow',
        'Invoke-VSCodeReuseWindow',
        'Invoke-VSCodeWait',
        'Invoke-VSCodeUserDataDir',
        'Invoke-VSCodeProfile',
        'Invoke-VSCodeExtensionsDir',
        'Invoke-VSCodeInstallExtension',
        'Invoke-VSCodeUninstallExtension',
        'Invoke-VSCodeVerbose',
        'Invoke-VSCodeLog',
        'Invoke-VSCodeDisableExtensions',
        'Get-VSCodeVersion',
        'Get-VSCodeExtensions'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'vsc',
        'vsca',
        'vscd',
        'vscg',
        'vscn',
        'vscr',
        'vscw',
        'vscu',
        'vscp',
        'vsced',
        'vscie',
        'vscue',
        'vscv',
        'vscl',
        'vscde'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'VSCode.psm1',
        'VSCode.psd1',
        'README.md',
        'Completion/VSCode.Completion.psm1',
        'Completion/VSCode.Completion.psd1',
        'Completion/VSCode.Completion.xml',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'VSCode',
                'VisualStudioCode',
                'Editor',
                'IDE',
                'Development',
                'CLI',
                'PowerShell',
                'Productivity'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }

    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/VSCode/README.md'
    DefaultCommandPrefix   = ''
}
