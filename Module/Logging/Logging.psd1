@{
    RootModule           = 'Logging.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '508e211f-6649-4616-9253-b4a803cdb653'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'This module provides logging functionality with timestamp and log level.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Write-LogMessage'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'log-message'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Logging', 'Timestamp', 'Log Level'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Logging/README.md'
    DefaultCommandPrefix = ''
}
