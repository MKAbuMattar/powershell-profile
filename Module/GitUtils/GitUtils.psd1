@{
  RootModule        = 'GitUtils.psm1'
  ModuleVersion     = '1.0.0'
  GUID              = '04793fa8-6602-49ff-9f13-800c7df444eb'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2025 Mohammad Abu Mattar'
  Description       = 'A collection of Git utility functions.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Get-GitBranchStatus',
    'Invoke-GitCleanBranches',
    'Start-GitRepoSearch',
    'Get-GitRecentContributors',
    'New-GitRelease'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @(
    'ggbs',
    'igcb',
    'sgrs',
    'ggrc',
    'ngr'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Git',
        'Utility'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
