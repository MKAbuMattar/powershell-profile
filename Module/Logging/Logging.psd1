#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Logging Module
# Version: 5.0.0
# Author: Mohammad Abu Mattar
# Description: Enhanced logging and error handling system with debug mode support
# Created: 2021-09-01
# Updated: 2026-01-11
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Logging.psm1'
    ModuleVersion        = '5.0.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '508e211f-6649-4616-9253-b4a803cdb653'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2026 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Enhanced logging and error handling system with debug mode, error reporting, log rotation, and recovery mechanisms'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Write-LogMessage',
        'Write-ErrorReport',
        'Get-ErrorHistory',
        'Clear-OldLogs',
        'Export-LogArchive',
        'Set-DebugMode',
        'Set-VerboseMode',
        'Get-LoggingConfig',
        'Clear-ErrorHistory'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'log-message',
        'log',
        'log-error',
        'errors',
        'error-history',
        'clean-logs',
        'export-logs',
        'debug-mode',
        'verbose-mode',
        'log-config',
        'clear-errors'
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
