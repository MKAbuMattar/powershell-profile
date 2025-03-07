@{
  RootModule        = 'Utility.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '69fba7f4-822d-4201-bec5-7f7f03edfca3'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'The Utility module provides a collection of functions for system management, process handling, and various other utilities to enhance the PowerShell experience.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Test-CommandExists',
    'Invoke-ReloadProfile',
    'Get-Uptime',
    'Get-CommandDefinition',
    'Get-AllProcesses',
    'Get-ProcessByName',
    'Get-ProcessByPort',
    'Stop-ProcessByName',
    'Stop-ProcessByPort',
    'Get-SystemInfo',
    'Invoke-ClearCache',
    'Get-RandomQuote',
    'Get-WeatherForecast',
    'Start-Countdown',
    'Start-Stopwatch',
    'Get-WallClock',
    'Start-Matrix'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'command-exists',
    'reload-profile',
    'uptime',
    'def',
    'pall',
    'pgrep',
    'portgrep',
    'pkill',
    'portkill',
    'sysinfo',
    'clear-cache',
    'quote',
    'weather',
    'countdown',
    'stopwatch',
    'wallclock',
    'matrix'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Utility',
        'System',
        'Process',
        'Management',
        'PowerShell'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
