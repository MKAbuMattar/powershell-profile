@{
  RootModule        = 'Logging.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '508e211f-6649-4616-9253-b4a803cdb653'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Logging module'
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
      Tags       = @(
        'Logging'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
