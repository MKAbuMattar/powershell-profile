@{
    RootModule           = 'Helm.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'a8b9c0d1-e2f3-4567-8901-234567890abc'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Helm plugin for MKAbuMattar PowerShell Profile - provides Helm CLI shortcuts and utility functions for Kubernetes package management workflows.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Test-HelmInstalled',
        'Initialize-HelmCompletion',
        'Invoke-Helm',
        'Invoke-HelmInstall',
        'Invoke-HelmUninstall',
        'Invoke-HelmSearch',
        'Invoke-HelmUpgrade'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'h',
        'hin',
        'hun',
        'hse',
        'hup'
    )
    DscResourcesToExport = @()
    ModuleList           = @()
    FileList             = @('Helm.psm1', 'Helm.psd1', 'README.md')
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Helm', 'Kubernetes', 'K8s', 'DevOps', 'CLI', 'PowerShell', 'Profile', 'Aliases')
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            ReleaseNotes               = @"
v4.1.0 - Initial Helm plugin release
- Complete Helm CLI integration with PowerShell aliases
- 5 PowerShell functions with convenient aliases
- Comprehensive help documentation for all functions
- Full parameter support for all Helm commands and options
- PowerShell completion support for enhanced productivity
"@
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Helm/README.md'
    DefaultCommandPrefix = ''
}
