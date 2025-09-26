function Invoke-GitPromptGit {
  <#
  .SYNOPSIS
    Invokes a Git command with optional arguments while managing the GIT_OPTIONAL_LOCKS environment variable.

  .DESCRIPTION
    This function invokes a Git command with the provided arguments. It sets the GIT_OPTIONAL_LOCKS environment variable to "0" to disable optional locks during the execution of the Git command. After the command is executed, it removes the GIT_OPTIONAL_LOCKS environment variable to clean up the environment.

  .PARAMETER Arguments
    The arguments to pass to the Git command.

  .INPUTS
    Arguments: (Optional) The arguments to pass to the Git command.

  .OUTPUTS
    The output of the Git command.

  .EXAMPLE
    Invoke-GitPromptGit status
    Invokes the 'git status' command.

  .NOTES
    This function is useful for executing Git commands in a PowerShell script while ensuring that optional locks are disabled.
  #>
  [CmdletBinding()]
  [OutputType([object])]
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
  )

  $env:GIT_OPTIONAL_LOCKS = "0"

  try {
    & git @Arguments
  }
  finally {
    Remove-Item env:GIT_OPTIONAL_LOCKS -ErrorAction SilentlyContinue
  }
}

function Test-GitVersionAtLeast {
  <#
  .SYNOPSIS
    Checks if the installed Git version is at least the specified version.

  .DESCRIPTION
    This function checks if the installed Git version is at least the specified version. It compares the major and minor version numbers of the installed Git version with the provided version.

  .PARAMETER RequiredVersion
    The minimum required Git version in the format "major.minor" (e.g., "2.20").

  .INPUTS
    RequiredVersion: (Mandatory) The minimum required Git version in the format "major.minor" (e.g., "2.20").

  .OUTPUTS
    Returns $true if the installed Git version is at least the specified version; otherwise, returns $false.

  .EXAMPLE
    Test-GitVersionAtLeast -RequiredVersion "2.20"
    Checks if the installed Git version is at least 2.20.

  .NOTES
    This function is useful for ensuring that the required Git version is installed before executing Git-related commands in a script.
  #>
  [CmdletBinding()]
  [OutputType([bool])]
  param(
    [Parameter(Mandatory)]
    [string]$RequiredVersion
  )

  try {
    $gitVersion = (git --version 2>$null) -replace 'git version ', ''
    if ([string]::IsNullOrEmpty($gitVersion)) {
      return $false
    }

    $currentParts = $gitVersion.Split('.') | ForEach-Object {
      if ($_ -match '^\d+') { [int]$matches[0] } else { 0 }
    }

    $requiredParts = $RequiredVersion.Split('.') | ForEach-Object {
      if ($_ -match '^\d+') { [int]$matches[0] } else { 0 }
    }

    $currentMajor = if ($currentParts.Count -gt 0) { $currentParts[0] } else { 0 }
    $currentMinor = if ($currentParts.Count -gt 1) { $currentParts[1] } else { 0 }

    $requiredMajor = if ($requiredParts.Count -gt 0) { $requiredParts[0] } else { 0 }
    $requiredMinor = if ($requiredParts.Count -gt 1) { $requiredParts[1] } else { 0 }

    if ($currentMajor -gt $requiredMajor) {
      return $true
    }
    elseif ($currentMajor -eq $requiredMajor -and $currentMinor -ge $requiredMinor) {
      return $true
    }
    else {
      return $false
    }
  }
  catch {
    return $false
  }
}

function Get-GitCurrentBranch {
  <#
  .SYNOPSIS
    Gets the name of the current Git branch.

  .DESCRIPTION
    This function retrieves the name of the current Git branch in the repository. If the repository is in a detached HEAD state, it returns the short SHA of the current commit. If the command fails or if not in a Git repository, it returns $null.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The name of the current Git branch as a string, or $null if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitCurrentBranch
    Returns the name of the current Git branch.

  .NOTES
    This function is useful for scripts that need to determine the current branch context in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $ref = Invoke-GitPromptGit symbolic-ref --quiet HEAD 2>$null

    if ($LASTEXITCODE -ne 0) {
      if ($LASTEXITCODE -eq 128) {
        return
      }

      $ref = Invoke-GitPromptGit rev-parse --short HEAD 2>$null
      if ($LASTEXITCODE -ne 0) {
        return
      }
    }

    if ($ref -and $ref.StartsWith('refs/heads/')) {
      return $ref.Substring('refs/heads/'.Length)
    }

    return $ref
  }
  catch {
    return
  }
}

function Get-GitPreviousBranch {
  <#
  .SYNOPSIS
    Gets the name of the previous Git branch.

  .DESCRIPTION
    This function retrieves the name of the previous Git branch in the repository. It uses the Git command to find the symbolic reference of the previous branch. If the command fails or if not in a Git repository, it returns $null.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The name of the previous Git branch as a string, or $null if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitPreviousBranch
    Returns the name of the previous Git branch.

  .NOTES
    This function is useful for scripts that need to determine the previous branch context in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $ref = Invoke-GitPromptGit rev-parse --quiet --symbolic-full-name '@{-1}' 2>$null

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrEmpty($ref)) {
      return
    }

    if ($ref.StartsWith('refs/heads/')) {
      return $ref.Substring('refs/heads/'.Length)
    }

    return $ref
  }
  catch {
    return
  }
}

function Get-GitCommitsAhead {
  <#
  .SYNOPSIS
    Gets the number of commits the current branch is ahead of its upstream branch.

  .DESCRIPTION
    This function retrieves the number of commits that the current Git branch is ahead of its upstream branch. It uses the Git command to count the commits. If the command fails, if not in a Git repository, or if there are no commits ahead, it returns $null.

  .PARAMETER Prefix
    A string to prefix the output with.

  .PARAMETER Suffix
    A string to suffix the output with.

  .INPUTS
    Prefix: (Optional) A string to prefix the output with.
    Suffix: (Optional) A string to suffix the output with.

  .OUTPUTS
    A string representing the number of commits ahead, prefixed and suffixed as specified, or $null if there are no commits ahead or if an error occurs.

  .EXAMPLE
    Get-GitCommitsAhead -Prefix "↑" -Suffix " commits"
    Returns the number of commits the current branch is ahead of its upstream branch, formatted with the specified prefix and suffix.

  .NOTES
    This function is useful for scripts that need to display the status of the current branch in relation to its upstream branch.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$Prefix = "",
    [string]$Suffix = ""
  )

  try {
    $null = Invoke-GitPromptGit rev-parse --git-dir 2>$null
    if ($LASTEXITCODE -ne 0) {
      return
    }

    $commits = Invoke-GitPromptGit rev-list --count '@{upstream}..HEAD' 2>$null

    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($commits) -and $commits -ne "0") {
      return "$Prefix$commits$Suffix"
    }
  }
  catch {
    return
  }
}

function Get-GitCommitsBehind {
  <#
  .SYNOPSIS
    Gets the number of commits the current branch is behind its upstream branch.

  .DESCRIPTION
    This function retrieves the number of commits that the current Git branch is behind its upstream branch. It uses the Git command to count the commits. If the command fails, if not in a Git repository, or if there are no commits behind, it returns $null.

  .PARAMETER Prefix
    A string to prefix the output with.

  .PARAMETER Suffix
    A string to suffix the output with.

  .INPUTS
    Prefix: (Optional) A string to prefix the output with.
    Suffix: (Optional) A string to suffix the output with.

  .OUTPUTS
    A string representing the number of commits behind, prefixed and suffixed as specified, or $null if there are no commits behind or if an error occurs.

  .EXAMPLE
    Get-GitCommitsBehind -Prefix "↓" -Suffix " commits"
    Returns the number of commits the current branch is behind its upstream branch, formatted with the specified prefix and suffix.

  .NOTES
    This function is useful for scripts that need to display the status of the current branch in relation to its upstream branch.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$Prefix = "",
    [string]$Suffix = ""
  )

  try {
    $null = Invoke-GitPromptGit rev-parse --git-dir 2>$null
    if ($LASTEXITCODE -ne 0) {
      return
    }

    $commits = Invoke-GitPromptGit rev-list --count 'HEAD..@{upstream}' 2>$null

    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($commits) -and $commits -ne "0") {
      return "$Prefix$commits$Suffix"
    }
  }
  catch {
    return
  }
}

function Get-GitPromptInfo {
  <#
  .SYNOPSIS
    Gets the current Git branch name with optional upstream information.

  .DESCRIPTION
    This function retrieves the current Git branch name. If the repository is in a detached HEAD state, it returns the short SHA of the current commit. It can also include upstream branch information if specified. The output can be customized with prefixes and suffixes, and the display of branch information can be suppressed based on configuration settings.

  .PARAMETER ShowUpstream
    A switch to indicate whether to show upstream branch information.

  .PARAMETER Prefix
    A string to prefix the output with.

  .PARAMETER Suffix
    A string to suffix the output with.

  .PARAMETER HideInfo
    A switch to indicate whether to hide the branch information.

  .INPUTS
    ShowUpstream: (Optional) A switch to indicate whether to show upstream branch information.
    Prefix: (Optional) A string to prefix the output with.
    Suffix: (Optional) A string to suffix the output with.
    HideInfo: (Optional) A switch to indicate whether to hide the branch information.

  .OUTPUTS
    A string representing the current Git branch name with optional upstream information, prefixed and suffixed as specified, or an empty string if branch information is hidden or if not in a Git repository.

  .EXAMPLE
    Get-GitPromptInfo -ShowUpstream -Prefix "[" -Suffix "]"
    Returns the current Git branch name with upstream information, formatted with the specified prefix and suffix.

  .EXAMPLE
    Get-GitPromptInfo -HideInfo
    Returns an empty string, hiding the branch information.

  .NOTES
    This function is useful for customizing the display of Git branch information in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [switch]$ShowUpstream,
    [string]$Prefix = "",
    [string]$Suffix = "",
    [switch]$HideInfo
  )

  $null = Invoke-GitPromptGit rev-parse --git-dir 2>$null
  if ($LASTEXITCODE -ne 0) {
    return ""
  }

  if ($HideInfo) {
    return ""
  }

  $hideInfoConfig = Invoke-GitPromptGit config --get oh-my-zsh.hide-info 2>$null
  if ($LASTEXITCODE -eq 0 -and $hideInfoConfig -eq "1") {
    return ""
  }

  $ref = $null

  $ref = Invoke-GitPromptGit symbolic-ref --short HEAD 2>$null
  if ($LASTEXITCODE -ne 0) {
    $ref = Invoke-GitPromptGit describe --tags --exact-match HEAD 2>$null
    if ($LASTEXITCODE -ne 0) {
      $ref = Invoke-GitPromptGit rev-parse --short HEAD 2>$null
      if ($LASTEXITCODE -ne 0) {
        return ""
      }
    }
  }

  $upstream = ""
  if ($ShowUpstream) {
    $upstreamRef = Invoke-GitPromptGit rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($upstreamRef)) {
      $upstream = " -> $upstreamRef"
    }
  }

  $ref = $ref -replace '%', '%%'
  $upstream = $upstream -replace '%', '%%'

  return "$Prefix$ref$upstream$Suffix"
}

function Test-GitDirty {
  <#
  .SYNOPSIS
    Checks if the Git repository has uncommitted changes.

  .DESCRIPTION
    This function checks if the current Git repository has uncommitted changes (i.e., if it is "dirty"). It uses the Git status command with specific flags to determine the state of the working directory. The output can be customized with text for clean and dirty states, and various options can be set to control the behavior of the check.

  .PARAMETER CleanText
    The text to return if the repository is clean (no uncommitted changes).

  .PARAMETER DirtyText
    The text to return if the repository is dirty (has uncommitted changes).

  .PARAMETER DisableUntrackedFiles
    A switch to indicate whether to ignore untracked files when checking for a dirty state.

  .PARAMETER IgnoreSubmodules
    Specifies how to handle submodules when checking for a dirty state. Accepts values like "all", "dirty", "none", or "git".

  .INPUTS
    CleanText: (Optional) The text to return if the repository is clean (no uncommitted changes).
    DirtyText: (Optional) The text to return if the repository is dirty (has uncommitted changes).
    DisableUntrackedFiles: (Optional) A switch to indicate whether to ignore untracked files when checking for a dirty state.
    IgnoreSubmodules: (Optional) Specifies how to handle submodules when checking for a dirty state. Accepts values like "all", "dirty", "none", or "git".

  .OUTPUTS
    A string representing the clean or dirty state of the repository, based on the specified texts, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Test-GitDirty -CleanText "Clean" -DirtyText "Dirty"
    Returns "Clean" if the repository has no uncommitted changes, or "Dirty" if it does.

  .NOTES
    This function is useful for scripts that need to display the status of the Git repository in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$CleanText = "",
    [string]$DirtyText = "*",
    [switch]$DisableUntrackedFiles,
    [string]$IgnoreSubmodules = "dirty"
  )

  $hideDirtyConfig = Invoke-GitPromptGit config --get oh-my-zsh.hide-dirty 2>$null
  if ($LASTEXITCODE -eq 0 -and $hideDirtyConfig -eq "1") {
    return $CleanText
  }

  $flags = @('--porcelain')

  if ($DisableUntrackedFiles) {
    $flags += '--untracked-files=no'
  }

  switch ($IgnoreSubmodules) {
    "git" {
    }
    default {
      $flags += "--ignore-submodules=$IgnoreSubmodules"
    }
  }

  try {
    $status = Invoke-GitPromptGit status @flags 2>$null
    if ($LASTEXITCODE -eq 128) {
      return $CleanText
    }

    $statusLines = $status -split "`n"
    $lastLine = $statusLines[-1]

    if (![string]::IsNullOrEmpty($lastLine)) {
      return $DirtyText
    }
    else {
      return $CleanText
    }
  }
  catch {
    return $CleanText
  }
}

function Get-GitRemoteStatus {
  <#
  .SYNOPSIS
    Gets the remote status of the current Git branch.

  .DESCRIPTION
    This function retrieves the remote status of the current Git branch, indicating whether it is ahead, behind, diverged, or equal to its upstream branch. The output can be customized with various symbols and text for different states, and prefixes and suffixes can be added to the output.

  .PARAMETER Branch
    The name of the branch to check the remote status for. If not provided, the current branch is used.

  .PARAMETER ShowDetailed
    A switch to indicate whether to show detailed information about the number of commits ahead and behind.

  .PARAMETER EqualText
    The text to use when the branch is equal to its upstream.

  .PARAMETER AheadText
    The text to use when the branch is ahead of its upstream.

  .PARAMETER BehindText
    The text to use when the branch is behind its upstream.

  .PARAMETER DivergedText
    The text to use when the branch has diverged from its upstream.

  .PARAMETER Prefix
    A string to prefix the output with.

  .PARAMETER Suffix
    A string to suffix the output with.

  .INPUTS
    Branch: (Optional) The name of the branch to check the remote status for. If not provided, the current branch is used.
    ShowDetailed: (Optional) A switch to indicate whether to show detailed information about the number of commits ahead and behind.
    EqualText: (Optional) The text to use when the branch is equal to its upstream.
    AheadText: (Optional) The text to use when the branch is ahead of its upstream.
    BehindText: (Optional) The text to use when the branch is behind its upstream.
    DivergedText: (Optional) The text to use when the branch has diverged from its upstream.
    Prefix: (Optional) A string to prefix the output with.
    Suffix: (Optional) A string to suffix the output with.

  .OUTPUTS
    A string representing the remote status of the branch, formatted with the specified texts, prefix, and suffix, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitRemoteStatus -ShowDetailed -Prefix "[" -Suffix "]"
    Returns the remote status of the current branch with detailed information, formatted with the specified prefix and suffix.

  .EXAMPLE
    Get-GitRemoteStatus -Branch "feature-branch" -AheadText "Ahead" -BehindText "Behind"
    Returns the remote status of the specified branch, using custom text for ahead and behind states.

  .NOTES
    This function is useful for scripts that need to display the remote status of a Git branch in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$Branch,
    [switch]$ShowDetailed,
    [string]$EqualText = "=",
    [string]$AheadText = "↑",
    [string]$BehindText = "↓",
    [string]$DivergedText = "↕",
    [string]$Prefix = "",
    [string]$Suffix = ""
  )

  try {
    if ([string]::IsNullOrEmpty($Branch)) {
      $Branch = Get-GitCurrentBranch
      if ([string]::IsNullOrEmpty($Branch)) {
        return ""
      }
    }

    $remote = Invoke-GitPromptGit rev-parse --verify "$Branch@{upstream}" --symbolic-full-name 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrEmpty($remote)) {
      return ""
    }

    $remote = $remote -replace '^refs/remotes/', ''
    $ahead = Invoke-GitPromptGit rev-list "$Branch@{upstream}..HEAD" 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines
    $behind = Invoke-GitPromptGit rev-list "HEAD..$Branch@{upstream}" 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines

    if ($LASTEXITCODE -ne 0) {
      return ""
    }

    $gitRemoteStatus = ""
    $gitRemoteStatusDetailed = ""

    if ($ahead -eq 0 -and $behind -eq 0) {
      $gitRemoteStatus = $EqualText
    }
    elseif ($ahead -gt 0 -and $behind -eq 0) {
      $gitRemoteStatus = $AheadText
      if ($ShowDetailed) {
        $gitRemoteStatusDetailed = "$AheadText$ahead"
      }
    }
    elseif ($behind -gt 0 -and $ahead -eq 0) {
      $gitRemoteStatus = $BehindText
      if ($ShowDetailed) {
        $gitRemoteStatusDetailed = "$BehindText$behind"
      }
    }
    elseif ($ahead -gt 0 -and $behind -gt 0) {
      $gitRemoteStatus = $DivergedText
      if ($ShowDetailed) {
        $gitRemoteStatusDetailed = "$AheadText$ahead$BehindText$behind"
      }
    }

    if ($ShowDetailed -and ![string]::IsNullOrEmpty($gitRemoteStatusDetailed)) {
      $remote = $remote -replace '%', '%%'
      return "$Prefix$remote $gitRemoteStatusDetailed$Suffix"
    }
    else {
      return $gitRemoteStatus
    }
  }
  catch {
    return ""
  }
}

function Test-GitPromptAhead {
  <#
  .SYNOPSIS
    Checks if the current Git branch is ahead of its remote counterpart.

  .DESCRIPTION
    This function checks if the current Git branch is ahead of its remote counterpart (i.e., if there are commits in the local branch that are not yet pushed to the remote branch). It uses the Git rev-list command to determine if there are any commits ahead. The output can be customized with a specific text to indicate the ahead status.

  .PARAMETER AheadText
    The text to return if the branch is ahead of its remote counterpart.

  .INPUTS
    AheadText: (Optional) The text to return if the branch is ahead of its remote counterpart.

  .OUTPUTS
    A string representing the ahead status of the branch, or an empty string if not ahead or if an error occurs.

  .EXAMPLE
    Test-GitPromptAhead -AheadText "↑"
    Returns "↑" if the current branch is ahead of its remote counterpart, or an empty string if not.

  .NOTES
    This function is useful for scripts that need to display the ahead status of a Git branch in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$AheadText = "↑"
  )

  try {
    $currentBranch = Get-GitCurrentBranch
    if ([string]::IsNullOrEmpty($currentBranch)) {
      return ""
    }

    $commits = Invoke-GitPromptGit rev-list "origin/$currentBranch..HEAD" 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($commits)) {
      return $AheadText
    }
    return ""
  }
  catch {
    return ""
  }
}

function Test-GitPromptBehind {
  <#
  .SYNOPSIS
    Checks if the current Git branch is behind its remote counterpart.

  .DESCRIPTION
    This function checks if the current Git branch is behind its remote counterpart (i.e., if there are commits in the remote branch that are not yet pulled into the local branch). It uses the Git rev-list command to determine if there are any commits behind. The output can be customized with a specific text to indicate the behind status.

  .PARAMETER BehindText
    The text to return if the branch is behind its remote counterpart.

  .INPUTS
    BehindText: (Optional) The text to return if the branch is behind its remote counterpart.

  .OUTPUTS
    A string representing the behind status of the branch, or an empty string if not behind or if an error occurs.

  .EXAMPLE
    Test-GitPromptBehind -BehindText "↓"
    Returns "↓" if the current branch is behind its remote counterpart, or an empty string if not.

  .NOTES
    This function is useful for scripts that need to display the behind status of a Git branch in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$BehindText = "↓"
  )

  try {
    $currentBranch = Get-GitCurrentBranch
    if ([string]::IsNullOrEmpty($currentBranch)) {
      return ""
    }

    $commits = Invoke-GitPromptGit rev-list "HEAD..origin/$currentBranch" 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($commits)) {
      return $BehindText
    }
    return ""
  }
  catch {
    return ""
  }
}

function Test-GitPromptRemote {
  <#
  .SYNOPSIS
    Checks if the current Git branch has a remote counterpart.

  .DESCRIPTION
    This function checks if the current Git branch has a remote counterpart (i.e., if it is tracking a remote branch). It uses the Git show-ref command to determine if the remote branch exists. The output can be customized with specific texts to indicate whether the remote branch exists or is missing.

  .PARAMETER ExistsText
    The text to return if the remote branch exists.

  .PARAMETER MissingText
    The text to return if the remote branch is missing.

  .INPUTS
    ExistsText: (Optional) The text to return if the remote branch exists.
    MissingText: (Optional) The text to return if the remote branch is missing.

  .OUTPUTS
    A string representing the remote status of the branch, or a specific text if the remote branch is missing or if an error occurs.

  .EXAMPLE
    Test-GitPromptRemote -ExistsText "✓" -MissingText "✗"
    Returns "✓" if the current branch has a remote counterpart, or "✗" if it does not.

  .NOTES
    This function is useful for scripts that need to display the remote status of a Git branch in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$ExistsText = "✓",
    [string]$MissingText = "✗"
  )

  try {
    $currentBranch = Get-GitCurrentBranch
    if ([string]::IsNullOrEmpty($currentBranch)) {
      return $MissingText
    }

    $null = Invoke-GitPromptGit show-ref "origin/$currentBranch" 2>$null
    if ($LASTEXITCODE -eq 0) {
      return $ExistsText
    }
    else {
      return $MissingText
    }
  }
  catch {
    return $MissingText
  }
}

function Get-GitPromptShortSha {
  <#
  .SYNOPSIS
    Gets the short SHA of the current Git commit.

  .DESCRIPTION
    This function retrieves the short SHA of the current Git commit in the repository. The output can be customized with prefixes and suffixes. If the command fails or if not in a Git repository, it returns an empty string.

  .PARAMETER Prefix
    A string to prefix the output with.

  .PARAMETER Suffix
    A string to suffix the output with.

  .INPUTS
    Prefix: (Optional) A string to prefix the output with.
    Suffix: (Optional) A string to suffix the output with.

  .OUTPUTS
    A string representing the short SHA of the current Git commit, prefixed and suffixed as specified, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitPromptShortSha -Prefix "[" -Suffix "]"
    Returns the short SHA of the current Git commit, formatted with the specified prefix and suffix.

  .NOTES
    This function is useful for scripts that need to display the current commit SHA in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$Prefix = "[",
    [string]$Suffix = "]"
  )

  try {
    $sha = Invoke-GitPromptGit rev-parse --short HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($sha)) {
      return "$Prefix$sha$Suffix"
    }
    return ""
  }
  catch {
    return ""
  }
}

function Get-GitPromptLongSha {
  <#
  .SYNOPSIS
    Gets the long SHA of the current Git commit.

  .DESCRIPTION
    This function retrieves the long SHA of the current Git commit in the repository. The output can be customized with prefixes and suffixes. If the command fails or if not in a Git repository, it returns an empty string.

  .PARAMETER Prefix
    A string to prefix the output with.

  .PARAMETER Suffix
    A string to suffix the output with.

  .INPUTS
    Prefix: (Optional) A string to prefix the output with.
    Suffix: (Optional) A string to suffix the output with.

  .OUTPUTS
    A string representing the long SHA of the current Git commit, prefixed and suffixed as specified, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitPromptLongSha -Prefix "[" -Suffix "]"
    Returns the long SHA of the current Git commit, formatted with the specified prefix and suffix.

  .NOTES
    This function is useful for scripts that need to display the current commit SHA in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [string]$Prefix = "[",
    [string]$Suffix = "]"
  )

  try {
    $sha = Invoke-GitPromptGit rev-parse HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($sha)) {
      return "$Prefix$sha$Suffix"
    }
    return ""
  }
  catch {
    return ""
  }
}

function Get-GitCurrentUserName {
  <#
  .SYNOPSIS
    Gets the current Git user's name.

  .DESCRIPTION
    This function retrieves the current Git user's name from the Git configuration. If the command fails or if not in a Git repository, it returns an empty string.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The current Git user's name as a string, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitCurrentUserName
    Returns the current Git user's name.

  .NOTES
    This function is useful for scripts that need to display the current Git user's name in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $userName = Invoke-GitPromptGit config user.name 2>$null
    if ($LASTEXITCODE -eq 0) {
      return $userName
    }
    return ""
  }
  catch {
    return ""
  }
}

function Get-GitCurrentUserEmail {
  <#
  .SYNOPSIS
    Gets the current Git user's email.

  .DESCRIPTION
    This function retrieves the current Git user's email from the Git configuration. If the command fails or if not in a Git repository, it returns an empty string.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The current Git user's email as a string, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitCurrentUserEmail
    Returns the current Git user's email.

  .NOTES
    This function is useful for scripts that need to display the current Git user's email in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $userEmail = Invoke-GitPromptGit config user.email 2>$null
    if ($LASTEXITCODE -eq 0) {
      return $userEmail
    }
    return ""
  }
  catch {
    return ""
  }
}

function Get-GitRepoName {
  <#
  .SYNOPSIS
    Gets the name of the current Git repository.

  .DESCRIPTION
    This function retrieves the name of the current Git repository by determining the top-level directory of the repository. If the command fails or if not in a Git repository, it returns an empty string.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The name of the current Git repository as a string, or an empty string if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitRepoName
    Returns the name of the current Git repository.

  .NOTES
    This function is useful for scripts that need to display the current Git repository name in a PowerShell prompt or script.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $repoPath = Invoke-GitPromptGit rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($repoPath)) {
      return [System.IO.Path]::GetFileName($repoPath)
    }
    return ""
  }
  catch {
    return ""
  }
}

function Get-GitCurrentBranchAlias {
  <#
  .SYNOPSIS
    Gets the name of the current Git branch.

  .DESCRIPTION
    This function retrieves the name of the current Git branch in the repository. It uses the Git command to find the symbolic reference of the current branch. If the command fails or if not in a Git repository, it returns $null.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The name of the current Git branch as a string, or $null if not in a Git repository or if an error occurs.

  .EXAMPLE
    Get-GitCurrentBranchAlias
    Returns the name of the current Git branch.

  .NOTES
    This function is useful for scripts that need to determine the current branch context in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  return Get-GitCurrentBranch
}

function Get-GitDevelopBranch {
  <#
  .SYNOPSIS
    Gets the name of the development branch in a Git repository.

  .DESCRIPTION
    This function retrieves the name of the development branch in a Git repository. It checks for common development branch names such as "dev", "devel", "develop", and "development". If none of these branches exist, it defaults to returning "develop". If not in a Git repository, it also returns "develop".

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The name of the development branch as a string, or "develop" if none of the common development branches exist or if not in a Git repository.

  .EXAMPLE
    Get-GitDevelopBranch
    Returns the name of the development branch, such as "develop", "dev", "devel", or "development".

  .NOTES
    This function is useful for scripts that need to determine the development branch in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $null = Invoke-GitPromptGit rev-parse --git-dir 2>$null
    if ($LASTEXITCODE -ne 0) {
      return "develop"
    }

    $branches = @('dev', 'devel', 'develop', 'development')
    foreach ($branch in $branches) {
      $null = Invoke-GitPromptGit show-ref -q --verify "refs/heads/$branch" 2>$null
      if ($LASTEXITCODE -eq 0) {
        return $branch
      }
    }

    return "develop"
  }
  catch {
    return "develop"
  }
}

function Get-GitMainBranch {
  <#
  .SYNOPSIS
    Gets the name of the main branch in a Git repository.

  .DESCRIPTION
    This function retrieves the name of the main branch in a Git repository. It checks for common main branch names such as "main", "trunk", "mainline", "default", "stable", and "master". It also checks for remote branches under "origin" and "upstream". If none of these branches exist, it defaults to returning "master". If not in a Git repository, it also returns "master".

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    The name of the main branch as a string, or "master" if none of the common main branches exist or if not in a Git repository.

  .EXAMPLE
    Get-GitMainBranch
    Returns the name of the main branch, such as "main", "trunk", "mainline", "default", "stable", or "master".

  .NOTES
    This function is useful for scripts that need to determine the main branch in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $null = Invoke-GitPromptGit rev-parse --git-dir 2>$null
    if ($LASTEXITCODE -ne 0) {
      return "master"
    }

    $refs = @(
      'refs/heads/main',
      'refs/heads/trunk',
      'refs/heads/mainline',
      'refs/heads/default',
      'refs/heads/stable',
      'refs/heads/master',
      'refs/remotes/origin/main',
      'refs/remotes/origin/trunk',
      'refs/remotes/origin/mainline',
      'refs/remotes/origin/default',
      'refs/remotes/origin/stable',
      'refs/remotes/origin/master',
      'refs/remotes/upstream/main',
      'refs/remotes/upstream/trunk',
      'refs/remotes/upstream/mainline',
      'refs/remotes/upstream/default',
      'refs/remotes/upstream/stable',
      'refs/remotes/upstream/master'
    )

    foreach ($ref in $refs) {
      $null = Invoke-GitPromptGit show-ref -q --verify $ref 2>$null
      if ($LASTEXITCODE -eq 0) {
        return [System.IO.Path]::GetFileName($ref)
      }
    }

    $remotes = @('origin', 'upstream')
    foreach ($remote in $remotes) {
      $ref = Invoke-GitPromptGit rev-parse --abbrev-ref "$remote/HEAD" 2>$null
      if ($LASTEXITCODE -eq 0 -and $ref -like "$remote/*") {
        return $ref -replace "^$remote/", ""
      }
    }

    return "master"
  }
  catch {
    return "master"
  }
}

function Rename-GitBranch {
  <#
  .SYNOPSIS
    Renames a Git branch both locally and remotely.

  .DESCRIPTION
    This function renames a Git branch both locally and remotely. It takes the old branch name and the new branch name as parameters. It first renames the branch locally using the Git branch command, and then it deletes the old branch from the remote repository and pushes the new branch to set it as the upstream branch.

  .PARAMETER OldBranch
    The name of the branch to be renamed.

  .PARAMETER NewBranch
    The new name for the branch.

  .INPUTS
    OldBranch: (Mandatory) The name of the branch to be renamed.
    NewBranch: (Mandatory) The new name for the branch.

  .OUTPUTS
    This function does not return any output. It performs the branch renaming operation.

  .EXAMPLE
    Rename-GitBranch -OldBranch "feature-old" -NewBranch "feature-new"
    Renames the branch "feature-old" to "feature-new" both locally and remotely.

  .NOTES
    This function is useful for managing branch names in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(Mandatory)]
    [string]$OldBranch,
    [Parameter(Mandatory)]
    [string]$NewBranch
  )

  if ([string]::IsNullOrEmpty($OldBranch) -or [string]::IsNullOrEmpty($NewBranch)) {
    Write-Error "Usage: Rename-GitBranch -OldBranch <old_branch> -NewBranch <new_branch>"
    return
  }

  & git branch -m $OldBranch $NewBranch

  if (& git push origin ":$OldBranch") {
    & git push --set-upstream origin $NewBranch
  }
}

function Remove-GitWipAll {
  <#
  .SYNOPSIS
    Removes all WIP (Work In Progress) commits from the current Git branch.

  .DESCRIPTION
    This function removes all WIP (Work In Progress) commits from the current Git branch. It searches for the most recent commit that does not contain the '--wip--' marker in its message and resets the branch to that commit. If no such commit is found, or if the command fails, it does nothing.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    This function does not return any output. It performs the WIP commit removal operation.

  .EXAMPLE
    Remove-GitWipAll
    Removes all WIP commits from the current Git branch.

  .NOTES
    This function is useful for cleaning up WIP commits in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([void])]
  param()

  try {
    $commit = Invoke-GitPromptGit log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H 2>$null

    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrEmpty($commit)) {
      $currentHead = Invoke-GitPromptGit rev-parse HEAD 2>$null

      if ($commit -ne $currentHead) {
        & git reset $commit
        if ($LASTEXITCODE -ne 0) {
          return
        }
      }
    }
  }
  catch {
    Write-Error "Failed to remove WIP commits"
  }
}

function Test-GitWorkInProgress {
  <#
  .SYNOPSIS
    Checks if the current Git branch has WIP (Work In Progress) commits.

  .DESCRIPTION
    This function checks if the current Git branch has WIP (Work In Progress) commits by looking for the '--wip--' marker in the most recent commit message. If such a commit is found, it returns "WIP!!"; otherwise, it returns an empty string. If the command fails or if not in a Git repository, it also returns an empty string.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    A string indicating the presence of WIP commits ("WIP!!") or an empty string if no WIP commits are found or if an error occurs.

  .EXAMPLE
    Test-GitWorkInProgress
    Returns "WIP!!" if the current branch has WIP commits, or an empty string if not.

  .NOTES
    This function is useful for scripts that need to indicate the presence of WIP commits in a Git repository.
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param()

  try {
    $logOutput = Invoke-GitPromptGit -c log.showSignature=false log -n 1 2>$null
    if ($LASTEXITCODE -eq 0 -and $logOutput -match '--wip--') {
      return "WIP!!"
    }
    return ""
  }
  catch {
    return ""
  }
}

function Test-IsGitRepository {
  <#
  .SYNOPSIS
    Checks if the current directory is inside a Git repository.

  .DESCRIPTION
    This function checks if the current directory is inside a Git repository by using the Git rev-parse command. It returns $true if the directory is part of a Git repository, and $false otherwise.

  .INPUTS
    This function does not take any input.

  .OUTPUTS
    A boolean value indicating whether the current directory is inside a Git repository ($true) or not ($false).

  .EXAMPLE
    Test-IsGitRepository
    Returns $true if the current directory is inside a Git repository, or $false if not.

  .NOTES
    This function is useful for scripts that need to determine if they are operating within a Git repository context.
  #>
  [CmdletBinding()]
  [OutputType([bool])]
  param()

  try {
    $null = Invoke-GitPromptGit rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -eq 0) {
      return $true
    }
    return $false
  }
  catch {
    return $false
  }
}
