@{
    RootModule           = 'Docker.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'c616992d-3bc1-4c78-a210-5e4d139a9a6f'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Docker command aliases and utility functions for improved Docker workflow in PowerShell'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Invoke-DockerBuild',
        'Invoke-DockerContainerInspect',
        'Invoke-DockerContainerList',
        'Invoke-DockerContainerListAll',
        'Invoke-DockerImageBuild',
        'Invoke-DockerImageInspect',
        'Invoke-DockerImageList',
        'Invoke-DockerImagePush',
        'Invoke-DockerImagePrune',
        'Invoke-DockerImageRemove',
        'Invoke-DockerImageTag',
        'Invoke-DockerContainerLogs',
        'Invoke-DockerNetworkCreate',
        'Invoke-DockerNetworkConnect',
        'Invoke-DockerNetworkDisconnect',
        'Invoke-DockerNetworkInspect',
        'Invoke-DockerNetworkList',
        'Invoke-DockerNetworkRemove',
        'Invoke-DockerContainerPort',
        'Invoke-DockerPs',
        'Invoke-DockerPsAll',
        'Invoke-DockerPull',
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
        'Invoke-DockerVolumeInspect',
        'Invoke-DockerVolumeList',
        'Invoke-DockerVolumePrune',
        'Invoke-DockerContainerExec',
        'Invoke-DockerContainerExecInteractive'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'dbl',
        'dcin',
        'dcls',
        'dclsa',
        'dib',
        'dii',
        'dils',
        'dipu',
        'dipru',
        'dirm',
        'dit',
        'dlo',
        'dnc',
        'dncn',
        'dndcn',
        'dni',
        'dnls',
        'dnrm',
        'dpo',
        'dps',
        'dpsa',
        'dpu',
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
        'dvi',
        'dvls',
        'dvprune',
        'dxc',
        'dxcit'
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
