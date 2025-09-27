@{
    RootModule           = 'Rsync.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '9a3c4e5f-6b7d-8e9f-0a1b-2c3d4e5f6a7b'
    Author               = 'MKAbuMattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 MKAbuMattar. All rights reserved.'
    Description          = 'Rsync plugin for PowerShell Profile - File synchronization and transfer operations. Provides PowerShell functions for common rsync operations including copy, move, update, and synchronize with progress reporting and cross-platform support.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Invoke-RsyncCopy',
        'Invoke-RsyncMove',
        'Invoke-RsyncUpdate',
        'Sync-RsyncDirectories',
        'Test-RsyncInstalled',
        'Get-RsyncVersion',
        'Test-RsyncPath',
        'Show-RsyncHelp'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'rsync-copy',
        'rsync-move',
        'rsync-update',
        'rsync-synchronize'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Rsync',
                'Sync',
                'Synchronization',
                'Copy',
                'Move',
                'Transfer',
                'Files',
                'Directories',
                'Backup',
                'Unix',
                'Linux',
                'Cross-Platform'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/assets/icon.png'
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md'
}
