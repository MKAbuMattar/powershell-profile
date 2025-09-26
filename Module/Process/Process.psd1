@{
    RootModule        = 'Process.psm1'
    ModuleVersion     = '4.1.0'
    GUID              = '17cd86a1-e7e6-4d3c-88cf-5942a4d58f4b'
    Author            = 'Mohammad Abu Mattar'
    Copyright         = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description       = 'The Process module provides a collection of functions for retrieving system information, managing processes, and clearing caches to enhance the PowerShell experience.'
    PowerShellVersion = '5.0'
    FunctionsToExport = @(
        'Get-SystemInfo',
        'Get-AllProcesses',
        'Get-ProcessByName',
        'Get-ProcessByPort',
        'Stop-ProcessByName',
        'Stop-ProcessByPort',
        'Invoke-ClearCache'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @(
        'sysinfo',
        'pall',
        'pgrep',
        'portgrep',
        'pkill',
        'portkill',
        'clear-cache'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @(
                'System',
                'Process',
                'Management'
            )
            LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
    HelpInfoURI       = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Process/README.md'
}
