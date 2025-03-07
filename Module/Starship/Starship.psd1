@{
  RootModule        = 'Starship.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '1e2ead21-fa02-4d39-9c29-4c2d1b7d22d0'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'This module transiently invokes the Starship prompt to enhance the appearance and functionality of the PowerShell prompt.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Invoke-StarshipTransientFunction'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @(
    'starship-transient'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Starship',
        'Prompt',
        'Appearance',
        'Functionality'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
