@{
  RootModule        = 'Docs.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '8a971646-bb14-46e6-be7a-8a632a7e1e43'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Docs module'
  FunctionsToExport = @(
    'Show-ProfileHelp'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'profile-help'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Docs'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
