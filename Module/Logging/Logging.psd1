@{
  RootModule        = 'Logging.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '508e211f-6649-4616-9253-b4a803cdb653'
  Author            = 'Mohammad Abu Mattar'
  CompanyName       = 'Your Company Name'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'This module provides logging functionality with timestamp and log level.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Write-LogMessage'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'log-message'
  )
  PrivateData       = @{
    PSData = @{
      Tags         = @(
        'Logging', 'Timestamp', 'Log Level'
      )
      LicenseUri   = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri   = 'https://github.com/MKAbuMattar/powershell-profile'
      ReleaseNotes = @(
        "Initial release of the Logging module.",
        "Provides Write-LogMessage function to log messages with timestamp and log level."
      )
    }
  }
}
