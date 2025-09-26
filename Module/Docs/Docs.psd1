@{
    RootModule           = 'Docs.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '8a971646-bb14-46e6-be7a-8a632a7e1e43'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'This module provides documentation for the PowerShell Profile Helper module. It includes functions for displaying help documentation for various sections of the module.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Show-ProfileHelp'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'profile-help'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Docs',
                'PowerShell',
                'Profile',
                'Helper',
                'Utility'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Docs/README.md'
    DefaultCommandPrefix = ''
}
