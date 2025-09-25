@{
  RootModule        = 'Matrix.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = 'eb364d21-be46-4811-b668-1f3cb0531d41'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = ''
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Start-Matrix'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @(
    'matrix'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @()
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
