#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Docker Manifest
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
#       This module provides Docker command aliases and utility functions
#       for improved Docker workflow in PowerShell.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Docker.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Core'
    )
    GUID                 = 'c616992d-3bc1-4c78-a210-5e4d139a9a6f'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Docker command aliases and utility functions for improved Docker workflow in PowerShell'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Invoke-DockerBuild',
        'Invoke-DockerImageBuild',
        'Invoke-DockerContainerInspect',
        'Invoke-DockerContainerList',
        'Invoke-DockerContainerListAll',
        'Invoke-DockerContainerLogs',
        'Invoke-DockerContainerPort',
        'Invoke-DockerPs',
        'Invoke-DockerPsAll',
        'Invoke-DockerContainerRun',
        'Invoke-DockerContainerRunInteractive',
        'Invoke-DockerContainerRemove',
        'Invoke-DockerContainerRemoveForce',
        'Invoke-DockerContainerStart',
        'Invoke-DockerContainerRestart',
        'Invoke-DockerStopAll',
        'Invoke-DockerContainerStop',
        'Invoke-DockerStats',
        'Invoke-DockerTop',
        'Invoke-DockerContainerExec',
        'Invoke-DockerContainerExecInteractive',
        'Invoke-DockerImageInspect',
        'Invoke-DockerImageList',
        'Invoke-DockerImagePush',
        'Invoke-DockerImagePrune',
        'Invoke-DockerImageRemove',
        'Invoke-DockerImageTag',
        'Invoke-DockerPull',
        'Invoke-DockerNetworkCreate',
        'Invoke-DockerNetworkConnect',
        'Invoke-DockerNetworkDisconnect',
        'Invoke-DockerNetworkInspect',
        'Invoke-DockerNetworkList',
        'Invoke-DockerNetworkRemove',
        'Invoke-DockerVolumeInspect',
        'Invoke-DockerVolumeList',
        'Invoke-DockerVolumePrune'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'dbl',
        'dib',
        'dcin',
        'dcls',
        'dclsa',
        'dlo',
        'dpo',
        'dps',
        'dpsa',
        'dr',
        'drit',
        'drm',
        'drm!',
        'dst',
        'drs',
        'dsta',
        'dstp',
        'dsts',
        'dtop',
        'dxc',
        'dxcit',
        'dii',
        'dils',
        'dipu',
        'dipru',
        'dirm',
        'dit',
        'dpu',
        'dnc',
        'dncn',
        'dndcn',
        'dni',
        'dnls',
        'dnrm',
        'dvi',
        'dvls',
        'dvprune'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Docker',
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Docker/README.md'
    DefaultCommandPrefix = ''
}
