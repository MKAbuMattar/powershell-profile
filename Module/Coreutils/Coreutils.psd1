#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Coreutils Manifest
#
# Author: Mohammad Abu Mattar
#
# Description:
#       Detects, installs and manages Microsoft coreutils, and reports which names it and this
#       profile are both claiming.
#
# Created: 2026-08-15
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Coreutils.psm1'
    ModuleVersion        = '5.1.0'
    CompatiblePSEditions = @(
        'Core'
    )
    GUID                 = 'b7e4c918-2a3d-4f6b-8c5e-9d1a7f3b2e64'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2026 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Integration with Microsoft coreutils: detection, installation, per-utility enable and disable, and reporting of names contested with the profile.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Get-CoreutilsInstallation',
        'Get-CoreutilsUtility',
        'Enable-CoreutilsUtility',
        'Disable-CoreutilsUtility',
        'Install-Coreutils',
        'Show-CoreutilsConflict'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'coreutils-info',
        'coreutils-list',
        'coreutils-enable',
        'coreutils-disable',
        'coreutils-install',
        'coreutils-conflicts'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Coreutils',
                'GNU',
                'Windows',
                'Integration',
                'Microsoft'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Coreutils/README.md'
    DefaultCommandPrefix = ''
}
