@{
  RootModule        = 'Environment.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = 'efc9d380-babd-422a-b4e3-90606e59073b'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'This module provides functions to manage environment variables and test GitHub connectivity.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Set-EnvVar',
    'Get-EnvVar'
  )
  CmdletsToExport   = @()
  VariablesToExport = @(
    'AutoUpdateProfile',
    'AutoUpdatePowerShell',
    'CanConnectToGitHub'
  )
  AliasesToExport   = @(
    'set-env',
    'export',
    'get-env'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Environment variables',
        'GitHub connectivity'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
