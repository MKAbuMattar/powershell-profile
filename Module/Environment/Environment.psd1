@{
  RootModule        = 'Environment.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = 'efc9d380-babd-422a-b4e3-90606e59073b'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'This module provides functions to manage environment variables, test GitHub connectivity, and manipulate the PATH environment variable.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Set-EnvVar',
    'Get-EnvVar',
    'Invoke-ReloadPathEnvironmentVariable',
    'Get-PathEnvironmentVariable',
    'Add-PathEnvironmentVariable',
    'Remove-PathEnvironmentVariable'
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
    'get-env',
    'reload-env-path',
    'reload-path',
    'get-env-path',
    'get-path',
    'add-path',
    'set-path'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'GitHub connectivity',
        'Environment variables',
        'PATH management'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
