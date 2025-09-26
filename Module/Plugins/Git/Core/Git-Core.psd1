@{
  RootModule        = 'Git-Core.psm1'
  ModuleVersion     = '4.1.0'
  GUID              = '5eb0ffb0-a70b-478a-8163-1e57982ef80b'
  Author            = 'Mohammad Abu Mattar'
  Copyright         = '(c) 2024 Mohammad Abu Mattar'
  Description       = 'Git Core Functions - Core Git operations and prompt functions'
  PowerShellVersion = '5.0'
  FunctionsToExport = @(
    'Invoke-GitPromptGit',
    'Test-GitVersionAtLeast',
    'Get-GitCurrentBranch',
    'Get-GitPreviousBranch',
    'Get-GitCommitsAhead',
    'Get-GitCommitsBehind',
    'Get-GitPromptInfo',
    'Test-GitDirty',
    'Get-GitRemoteStatus',
    'Test-GitPromptAhead',
    'Test-GitPromptBehind',
    'Test-GitPromptRemote',
    'Get-GitPromptShortSha',
    'Get-GitPromptLongSha',
    'Get-GitCurrentUserName',
    'Get-GitCurrentUserEmail',
    'Get-GitRepoName',
    'Get-GitCurrentBranchAlias',
    'Get-GitDevelopBranch',
    'Get-GitMainBranch',
    'Rename-GitBranch',
    'Remove-GitWipAll',
    'Test-GitWorkInProgress',
    'Test-IsGitRepository'
  )
  CmdletsToExport   = @()
  VariablesToExport = @()
  AliasesToExport   = @()
  PrivateData       = @{
    PSData = @{
      Tags       = @('Git', 'Core', 'Prompt', 'VCS')
      LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
      ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
    }
  }
}
