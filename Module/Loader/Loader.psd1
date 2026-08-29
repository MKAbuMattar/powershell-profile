#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Loader Manifest
#
# Author: Mohammad Abu Mattar
#
# Description:
#       Loads the modules named in profile.config.psd1, reports failures instead of swallowing
#       them, and resolves alias collisions with native tools and built-in PowerShell aliases.
#
# Created: 2026-08-15
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Loader.psm1'
    ModuleVersion        = '5.1.0'
    CompatiblePSEditions = @(
        'Core'
    )
    GUID                 = 'f2b7c4a1-9d3e-4f8a-b6c5-1e7d9a2f4b83'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2026 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Configuration-driven module loader for the PowerShell profile.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Get-ProfileConfig',
        'Test-ProfileTool',
        'Import-ProfileComponent',
        'Resolve-ProfileConflict',
        'Test-ProfileAliasContention',
        'Import-ProfileModule',
        'Measure-ProfileLoad',
        'Get-PythonExecutable',
        'Invoke-ProfilePython',
        'Resolve-ProfilePackageManager',
        'Get-ProfileDependency',
        'Install-ProfileDependency',
        'Get-ProfileModuleName',
        'Show-ProfileHelp',
        'Register-ProfileLazyCommand',
        'Register-ProfileDeferredModule',
        'Enable-ProfileDeferredImport',
        'Invoke-ProfileDeferredImport',
        'Get-ProfilePluginTool',
        'Get-ProfilePluginRoot',
        'Get-ProfilePlugin',
        'Enable-ProfilePlugin',
        'Disable-ProfilePlugin',
        'New-ProfilePlugin'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'profile-alias-conflicts',
        'load-profile',
        'profile-load',
        'profile-python',
        'profile-deps',
        'install-profile-deps',
        'profile-help',
        'profile-plugins',
        'enable-plugin',
        'disable-plugin',
        'new-plugin'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Loader',
                'Profile',
                'Startup',
                'Configuration'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Loader/README.md'
    DefaultCommandPrefix = ''
}
