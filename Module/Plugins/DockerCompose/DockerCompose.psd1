#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Docker Compose Manifest
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
#       This module provides Docker Compose CLI shortcuts and utility functions for improved
#       Docker Compose workflow in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'DockerCompose.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'd8a1e2b3-4c5f-6789-abc0-def123456789'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Docker Compose command aliases and utility functions for improved Docker Compose workflow in PowerShell environments'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Invoke-DockerCompose',
        'Invoke-DockerComposeBuild',
        'Invoke-DockerComposeExec',
        'Invoke-DockerComposePs',
        'Invoke-DockerComposeRestart',
        'Invoke-DockerComposeRemove',
        'Invoke-DockerComposeRun',
        'Invoke-DockerComposeStop',
        'Invoke-DockerComposeUp',
        'Invoke-DockerComposeUpBuild',
        'Invoke-DockerComposeUpDetached',
        'Invoke-DockerComposeUpDetachedBuild',
        'Invoke-DockerComposeDown',
        'Invoke-DockerComposeLogs',
        'Invoke-DockerComposeLogsFollow',
        'Invoke-DockerComposeLogsFollowTail',
        'Invoke-DockerComposePull',
        'Invoke-DockerComposeStart',
        'Invoke-DockerComposeKill'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'dco',
        'dcb',
        'dce',
        'dcps',
        'dcrestart',
        'dcrm',
        'dcr',
        'dcstop',
        'dcup',
        'dcupb',
        'dcupd',
        'dcupdb',
        'dcdn',
        'dcl',
        'dclf',
        'dclF',
        'dcpull',
        'dcstart',
        'dck'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Docker',
                'DockerCompose',
                'Container',
                'DevOps',
                'CLI',
                'Shortcuts'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/DockerCompose/README.md'
    DefaultCommandPrefix = ''
}
