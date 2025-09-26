@{
  RootModule        = 'RandomQuote.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = 'af0e8545-14df-4432-9658-b33fa8e6d6fa'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = ''
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Get-RandomQuote'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @(
    'quote'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @()
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
