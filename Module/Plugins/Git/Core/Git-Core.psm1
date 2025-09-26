function Invoke-GitPromptGit {
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
  [CmdletBinding()]
  [OutputType([string])]
  param()

  return Get-GitCurrentBranch
}

function Get-GitDevelopBranch {
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
