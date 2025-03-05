@{
  RootModule        = 'Directory.psm1'
  ModuleVersion     = '0.0.0'
  GUID              = '23724530-b558-4a50-bc83-98525b46d859'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Utility module'
  FunctionsToExport = @(
    'Find-Files',
    "Set-FreshFile",
    "Expand-File",
    "Compress-Files",
    "Get-ContentMatching",
    "Set-ContentMatching",
    "Get-FileHash",
    "Get-FileHead",
    "Get-FileTail",
    "Invoke-UpOneDirectoryLevel",
    "Invoke-UpTwoDirectoryLevels",
    "Invoke-UpThreeDirectoryLevels",
    "Invoke-UpFourDirectoryLevels",
    "Invoke-UpFiveDirectoryLevels"
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @(
    'ff',
    "touch",
    "unzip",
    "zip",
    "grep",
    "sed",
    "z",
    "zi",
    "fh",
    "head",
    "tail",
    "cd.1",
    ".."
    "cd.2"
    "...",
    "cd.3",
    "....",
    "cd.4",
    ".....",
    "cd.5",
    "......"
  )
  PrivateData       = @{
    PSData = @{
      Tags       = @(
        'Files Management',
        'Directory Navigation'
      )
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
