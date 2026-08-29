#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Environment Manifest
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
#       This Module contains functions to manage environment variables and the PATH variable.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Environment.psm1'
    ModuleVersion        = '5.1.0'
    CompatiblePSEditions = @(
        'Core'
    )
    GUID                 = 'efc9d380-babd-422a-b4e3-90606e59073b'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'This module provides functions to manage environment variables, test GitHub connectivity, and manipulate the PATH environment variable.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Test-GitHubConnection',
        'Invoke-ReloadPathEnvironmentVariable',
        'Get-PathEnvironmentVariable',
        'Add-PathEnvironmentVariable',
        'Remove-PathEnvironmentVariable',
        'Set-EnvVar',
        'Get-EnvVar'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @(
        'AutoUpdateProfile',
        'AutoUpdatePowerShell'
    )
    AliasesToExport      = @(
        'test-github',
        'reload-env-path',
        'reload-path',
        'get-env-path',
        'get-path',
        'add-path',
        'set-path',
        'set-env',
        'export',
        'get-env'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'GitHub connectivity',
                'Environment variables',
                'PATH management'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Environment/README.md'
    DefaultCommandPrefix = ''
}
