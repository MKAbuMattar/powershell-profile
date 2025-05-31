@{
  RootModule        = 'Utility.psm1'
  ModuleVersion     = '4.0.0'
  GUID              = '69fba7f4-822d-4201-bec5-7f7f03edfca3'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
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
    'Start-Stopwatch',
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
}
