#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup Module
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
#       Describes what the profile installs, reports what is on the machine, and records what
#       this installer put there so it can be removed again.
#
# Created: 2026-08-29
# Updated: 2026-08-29
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Setup.psm1'
    ModuleVersion        = '5.1.0'
    CompatiblePSEditions = @(
        'Core'
    )
    GUID                 = '728cbf81-3127-4e2c-ba65-0d8004304dfa'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'This module describes what the profile installs, reports what is present, and records what the installer added so it can be removed.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Get-ProfileSetupPath',
        'Get-ProfileSetupCatalog',
        'Test-ProfileSetupPresent',
        'Get-ProfileSetupState',
        'Get-ProfileSetupReceipt',
        'Add-ProfileSetupReceiptEntry',
        'Remove-ProfileSetupReceiptEntry',
        'Save-ProfileSetupReceipt'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Setup',
                'Install'
            )
            LicenseUri                 = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            ReleaseNotes               = ''
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Setup/README.md'
    DefaultCommandPrefix = ''
}
