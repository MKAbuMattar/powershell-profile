@{
  RootModule        = 'Network.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '7763387b-5179-43c4-84bc-f24a2f62b534'
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
