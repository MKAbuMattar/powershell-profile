@{
  RootModule        = 'Update.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '508e211f-6649-4616-9253-b4a803cdb653'
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
