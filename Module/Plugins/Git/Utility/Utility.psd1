@{
    RootModule           = 'Utility.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'a2a7d067-ddb2-4a53-a14c-717dbcc43153'
    Author               = 'Mohammad Abu Mattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Git Utility Functions - Git branch management and utility operations'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Rename-GitBranch'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Git',
                'Utility',
                'Branch',
                'Management'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Git/README.md'
    DefaultCommandPrefix = ''
}
