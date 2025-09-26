@{
    RootModule        = 'Utility.psm1'
    ModuleVersion     = '4.1.0'
    GUID              = '69fba7f4-822d-4201-bec5-7f7f03edfca3'
    Author            = 'Mohammad Abu Mattar'
    CompanyName       = 'MKAbuMattar'
    Copyright         = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description       = 'A collection of utility functions for system and process management.'
    PowerShellVersion = '5.0'
    FunctionsToExport = @(
        'Test-Administrator',
        'Test-CommandExists',
        'Invoke-ReloadProfile',
        'Get-Uptime',
        'Get-CommandDefinition',
        'Get-RandomQuote',
        'Get-WeatherForecast',
        'Start-Countdown',
        'Start-StopWatch',
        'Get-WallClock',
        'Get-PrayerTimes',
        'Start-Matrix',
        'Get-DiskUsage'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @(
        'is-admin',
        'command-exists',
        'reload-profile',
        'uptime',
        'def',
        'quote',
        'weather',
        'countdown',
        'stopwatch',
        'wallclock',
        'prayer',
        'matrix',
        'du'
    )
    PrivateData       = @{
        PSData = @{
            Tags       = @(
                'Utility',
                'System',
                'Process',
                'Management'
            )
            LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
    HelpInfoURI       = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Utility/README.md'
}

