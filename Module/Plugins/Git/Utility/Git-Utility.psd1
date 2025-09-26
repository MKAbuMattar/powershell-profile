@{
  RootModule        = 'Git-Utility.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = 'a2a7d067-ddb2-4a53-a14c-717dbcc43153'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Git Utility Functions - Git branch management and utility operations'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Rename-GitBranch'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @()
  PrivateData       = @{
    PSData = @{
      Tags       = @('Git', 'Utility', 'Branch', 'Management')
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
