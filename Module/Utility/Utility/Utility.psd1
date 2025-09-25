@{
  RootModule        = 'Utility.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = '6bb34050-aa50-44dc-8acc-8a9ed0200839'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = ''
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Read-FigletFont',
    'Convert-TextToAscii',
    'Get-ParseTime',
    'Format-ConvertSize'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @()
  PrivateData       = @{
    PSData = @{
      Tags       = @()
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
