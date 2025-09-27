@{
    RootModule           = 'Flutter.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'b8c4e8a2-3d5f-4a7b-9e1c-6f8a2b4d3e5c'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Flutter Plugin for PowerShell Profile - Provides comprehensive Flutter CLI integration with PowerShell aliases and functions for Flutter development, including building, running, device management, and package management.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Invoke-Flutter',
        'Invoke-FlutterAttach',
        'Invoke-FlutterBuild',
        'Invoke-FlutterChannel',
        'Invoke-FlutterClean',
        'Get-FlutterDevices',
        'Invoke-FlutterDoctor',
        'Invoke-FlutterPub',
        'Get-FlutterPubPackages',
        'Start-FlutterApp',
        'Start-FlutterAppDebug',
        'Start-FlutterAppProfile',
        'Start-FlutterAppRelease',
        'Update-Flutter'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'flu',
        'flattach',
        'flb',
        'flchnl',
        'flc',
        'fldvcs',
        'fldoc',
        'flpub',
        'flget',
        'flr',
        'flrd',
        'flrp',
        'flrr',
        'flupgrd'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Flutter',
                'Mobile',
                'Development',
                'CLI',
                'Cross-Platform',
                'Dart',
                'Android',
                'iOS',
                'Web'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
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
