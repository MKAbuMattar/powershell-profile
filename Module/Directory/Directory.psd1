@{
  RootModule        = 'Directory.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = '23724530-b558-4a50-bc83-98525b46d859'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'A PowerShell utility module for file and directory management, including file search, creation, compression, extraction, and content manipulation.'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Find-Files',
    'Set-FreshFile',
    'Expand-File',
    'Compress-Files',
    'Get-ContentMatching',
    'Set-ContentMatching',
    'Get-FileHead',
    'Get-FileTail',
    'Get-ShortPath',
    'Invoke-UpOneDirectoryLevel',
    'Invoke-UpTwoDirectoryLevels',
    'Invoke-UpThreeDirectoryLevels',
    'Invoke-UpFourDirectoryLevels',
    'Invoke-UpFiveDirectoryLevels'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @(
    'ff',
    'touch',
    'unzip',
    'zip',
    'grep',
    'sed',
    'z',
    'zi',
    'head',
    'tail',
    'shortpath',
    'cd.1',
    '..',
    'cd.2',
    '...',
    'cd.3',
    '....',
    'cd.4',
    '.....',
    'cd.5',
    '......'
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Files Management',
        'Directory Navigation',
        'Compression',
        'Extraction',
        'Content Manipulation'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
