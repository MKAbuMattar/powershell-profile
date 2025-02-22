@{
  ModuleVersion     = '0.0.0'
  GUID              = '69fba7f4-822d-4201-bec5-7f7f03edfca3'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Utility module'
  FunctionsToExport = @(
    'Test-CommandExists',
    'Invoke-ProfileReload',
    'Find-Files',
    'Set-FreshFile',
    'Get-Uptime',
    'Expand-File',
    'Compress-Files',
    'Get-ContentMatching',
    'Set-ContentMatching',
    'Get-CommandDefinition',
    'Set-EnvVar',
    'Get-EnvVar',
    'Get-AllProcesses',
    'Get-ProcessByName',
    'Get-ProcessByPort',
    'Stop-ProcessByName',
    'Stop-ProcessByPort',
    'Get-RandomQuote'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'command-exists',
    'reload-profile',
    'ff',
    'touch',
    'uptime',
    'unzip',
    'zip',
    'grep',
    'sed',
    'command-definition',
    'set-env',
    'get-env',
    'pall',
    'pgrep',
    'portgrep',
    'pkill',
    'portkill',
    'quote'
  )
}
