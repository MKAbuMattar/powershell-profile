@{
    RootModule           = 'AWS.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'd018c9e3-a978-4656-8557-495e86b160f1'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'AWS CLI shortcuts and utility functions with profile management, MFA support, and role assumption for PowerShell environments'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Get-AWSCurrentProfile',
        'Get-AWSCurrentRegion',
        'Update-AWSState',
        'Clear-AWSState',
        'Set-AWSProfile',
        'Set-AWSRegion',
        'Switch-AWSProfile',
        'Update-AWSAccessKey',
        'Get-AWSRegions',
        'Get-AWSProfiles',
        'Get-AWSPromptInfo',
        'Initialize-AWSState'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'agp',
        'agr',
        'asp',
        'asr',
        'acp',
        'aws-change-key',
        'aws-regions',
        'aws-profiles'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'AWS',
                'Cloud',
                'CLI',
                'Shortcuts',
                'Profile',
                'MFA',
                'SSO',
                'DevOps'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/AWS/README.md'
    DefaultCommandPrefix = ''
}
