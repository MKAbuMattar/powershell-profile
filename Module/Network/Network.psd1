@{
  RootModule        = 'Network.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = '7763387b-5179-43c4-84bc-f24a2f62b534'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'This module provides functions to retrieve IP addresses and flush DNS cache.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Get-MyIPAddress',
    'Clear-FlushDNS'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @(
    'my-ip',
    'flush-dns'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Network',
        'IP',
        'DNS'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
