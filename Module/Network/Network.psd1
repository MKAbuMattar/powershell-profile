@{
  RootModule        = 'Network.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '508e211f-6649-4616-9253-b4a803cdb653'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Network module'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Get-MyIPAddress',
    'Clear-FlushDNS'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'my-ip',
    'flush-dns'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Network'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
