@{
  RootModule        = 'Update.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '74b25afc-cc1a-4658-9257-e4645e00c7b2'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Update module'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Update-LocalProfileModuleDirectory',
    'Update-Profile',
    'Update-PowerShell'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'update-local-module',
    'update-profile',
    'update-ps1'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Update',
        'System'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
