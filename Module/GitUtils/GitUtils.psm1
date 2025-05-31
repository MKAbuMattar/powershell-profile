<#
.SYNOPSIS
  Gets the status of the current Git branch or summarizes status for multiple repositories.
.DESCRIPTION
  If run within a Git repository, displays the status of the current Git branch, including information about pending changes and uncommitted files.
  If a parent directory is specified or implied, it can summarize the status of multiple repositories within that directory.
.PARAMETER Path
  Specifies the path to the Git repository or a parent directory containing multiple Git repositories. Defaults to the current location.
.PARAMETER Recurse
  If specified, and Path is a directory, the function will search for Git repositories in subdirectories.
.INPUTS
  Path: (Optional) The path to the Git repository or parent directory.
.OUTPUTS
  String: The status of the current Git branch or a summary for multiple repositories.
.NOTES
  This function is useful for quickly checking the status of Git repositories.
.EXAMPLE
  Get-GitBranchStatus
  Displays the status of the current Git branch.
.EXAMPLE
  Get-GitBranchStatus -Path "C:\\Projects" -Recurse
  Summarizes the status of all Git repositories found under C:\\Projects.
.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-GitBranchStatus {
  [CmdletBinding()]
  [Alias("ggbs")]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Path to the Git repository or parent directory containing multiple repositories."
    )]
    [Alias('p')]
    [ValidateNotNullOrEmpty()]
    [string]$Path = (Get-Location),

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "If specified, searches for Git repositories in subdirectories."
    )]
    [switch]$Recurse
  )

  if (Test-Path -Path (Join-Path -Path $Path -ChildPath ".git") -PathType Container) {
    Write-Host "Git branch status for $($Path):"
    git -C $Path status --short --branch
  }
  else {
    $gciParams = @{
      Path        = $Path
      Directory   = $true
      ErrorAction = 'SilentlyContinue'
    }
    if ($Recurse.IsPresent) {
      $gciParams.Recurse = $true
    }
    $gitRepos = Get-ChildItem @gciParams | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath ".git") -PathType Container }
    if ($gitRepos) {
      Write-Host "Summary of Git repositories in $Path`n"
      foreach ($repo in $gitRepos) {
        Write-Host "Repository: $($repo.FullName)"
        git -C $repo.FullName status --short --branch
        Write-Host ""
      }
    }
    else {
      Write-Warning "No Git repositories found in $Path."
    }
  }
}

<#
.SYNOPSIS
  Interactively cleans local Git branches that have been merged into the current branch or are old.
.DESCRIPTION
  This function lists local Git branches (excluding the current one and common main branches like main, master, develop)
  and allows the user to select branches for deletion. It can identify branches already merged into the current HEAD
  and optionally filter by branches older than a specified number of days.
.PARAMETER Path
  Specifies the path to the Git repository. Defaults to the current location.
.PARAMETER PruneRemote
  If specified, also prunes remote-tracking branches that no longer exist on the remote. (git remote prune origin)
.PARAMETER Force
  If specified, deletes branches without confirmation (use with caution).
.EXAMPLE
  Invoke-GitCleanBranches
  Lists local branches (excluding current, main, master, develop) and prompts for deletion if they are merged.
.EXAMPLE
  Invoke-GitCleanBranches -PruneRemote
  Also runs 'git remote prune origin' before checking local branches.
.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Invoke-GitCleanBranches {
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  [Alias("igcb")]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Path to the Git repository."
    )]
    [Alias('p')]
    [ValidateNotNullOrEmpty()]
    [string]$Path = (Get-Location),

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "If specified, also prunes remote-tracking branches that no longer exist on the remote."
    )]
    [Alias('prune')]
    [switch]$PruneRemote,

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "If specified, deletes branches without confirmation (use with caution)."
    )]
    [Alias('f')]
    [ValidateSet('True', 'False')]
    [switch]$Force
  )

  if (-not (Test-Path -Path (Join-Path -Path $Path -ChildPath ".git") -PathType Container)) {
    Write-Error "Not a Git repository: $Path"
    return
  }

  if ($PruneRemote.IsPresent) {
    if ($PSCmdlet.ShouldProcess("origin", "Prune remote-tracking branches for remote")) {
      git -C $Path remote prune origin
    }
  }

  $currentBranch = git -C $Path rev-parse --abbrev-ref HEAD
  Write-Verbose "Current branch: $currentBranch"

  $mergedBranches = git -C $Path branch --merged HEAD | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "* $currentBranch" -and $_ -ne $currentBranch -and $_ -ne "main" -and $_ -ne "master" -and $_ -ne "develop" }

  if (-not $mergedBranches) {
    Write-Host "No local branches found that are merged into $currentBranch (excluding main, master, develop)."
    return
  }

  Write-Host "The following local branches are merged into $currentBranch and can be deleted:"
  $mergedBranches | ForEach-Object { Write-Host "- $_" }

  if ($Force.IsPresent) {
    $mergedBranches | ForEach-Object {
      if ($PSCmdlet.ShouldProcess($_, "Delete local branch")) {
        Write-Host "Deleting branch $_..."
        git -C $Path branch -d $_
      }
    }
  }
  else {
    foreach ($branch in $mergedBranches) {
      $choice = Read-Host "Delete branch '$branch'? (y/n/q)"
      if ($choice -eq 'y') {
        if ($PSCmdlet.ShouldProcess($branch, "Delete local branch")) {
          Write-Host "Deleting branch $branch..."
          git -C $Path branch -d $branch
        }
      }
      elseif ($choice -eq 'q') {
        Write-Host "Quitting branch cleanup."
        break
      }
      else {
        Write-Host "Skipping branch $branch."
      }
    }
  }
  Write-Host "Branch cleanup process complete."
}

<#
.SYNOPSIS
  Searches commit messages or code changes across local Git repositories.
.DESCRIPTION
  This function allows searching for a specific pattern in commit messages (git log --grep)
  or in the code changes (git log -S or git grep) within one or more Git repositories.
.PARAMETER Query
  The search pattern (string or regex).
.PARAMETER Path
  The root directory to search for Git repositories, or a specific Git repository path. Defaults to current location.
.PARAMETER SearchType
  Specifies what to search: 'CommitMessage', 'CodeChanges' (diff content), 'TrackedFiles' (current tracked files). Default is 'CommitMessage'.
.PARAMETER Recurse
  If specified and Path is a directory, search recursively for Git repositories.
.EXAMPLE
  Start-GitRepoSearch -Query "Fix bug #123"
  Searches commit messages in the current repository.
.EXAMPLE
  Start-GitRepoSearch -Query "MyFunction" -Path "C:\\Projects" -SearchType CodeChanges -Recurse
  Searches for "MyFunction" in code changes within all Git repositories under C:\\Projects.
.EXAMPLE
  Start-GitRepoSearch -Query "API_KEY" -Path "C:\\Projects" -SearchType TrackedFiles -Recurse
  Searches for "API_KEY" in all currently tracked files within all Git repositories under C:\\Projects.
.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Start-GitRepoSearch {
  [CmdletBinding()]
  [Alias("sgrs")]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The search pattern (string or regex)."
    )]
    [Alias('q')]
    [ValidateNotNullOrEmpty()]
    [string]$Query,

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "The root directory to search for Git repositories, or a specific Git repository path. Defaults to current location."
    )]
    [Alias('p')]
    [ValidateNotNullOrEmpty()]
    [string]$Path = (Get-Location),

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "Specifies what to search: 'CommitMessage', 'CodeChanges' (diff content), 'TrackedFiles' (current tracked files). Default is 'CommitMessage'."
    )]
    [Alias('st')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('CommitMessage', 'CodeChanges', 'TrackedFiles')]
    [string]$SearchType = 'CommitMessage',

    [Parameter(
      Mandatory = $false,
      Position = 3,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "If specified and Path is a directory, search recursively for Git repositories."
    )]
    [Alias('r')]
    [ValidateNotNullOrEmpty()]
    [switch]$Recurse
  )

  $reposToSearch = @()
  if (Test-Path -Path (Join-Path -Path $Path -ChildPath ".git") -PathType Container) {
    $reposToSearch += $Path
  }
  else {
    $gciParams = @{
      Path        = $Path
      Directory   = $true
      ErrorAction = 'SilentlyContinue'
    }
    if ($Recurse.IsPresent) {
      $gciParams.Recurse = $true
    }
    $foundRepos = Get-ChildItem @gciParams | Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath ".git") -PathType Container }
    if ($foundRepos) {
      $reposToSearch += $foundRepos.FullName
    }
  }

  if ($reposToSearch.Count -eq 0) {
    Write-Warning "No Git repositories found in $Path to search."
    return
  }

  foreach ($repoPath in $reposToSearch) {
    Write-Host "Searching in repository: $repoPath"
    switch ($SearchType) {
      'CommitMessage' {
        git -C $repoPath log --all --grep=$Query --color=always | Out-String -Stream | Write-Host
      }
      'CodeChanges' {
        git -C $repoPath log --all -S$Query --color=always --patch | Out-String -Stream | Write-Host
      }
      'TrackedFiles' {
        git -C $repoPath grep --color=always -n -i $Query -- '*.*'
      }
    }
    Write-Host ("-" * 30)
  }
}

<#
.SYNOPSIS
  Lists recent contributors to a Git repository.
.DESCRIPTION
  This function shows a list of contributors to the repository, ordered by the date of their last commit,
  along with the number of commits they've made.
.PARAMETER Path
  Specifies the path to the Git repository. Defaults to the current location.
.PARAMETER TopN
  The number of top recent contributors to display. Defaults to 10.
.EXAMPLE
  Get-GitRecentContributors
  Shows the top 10 recent contributors in the current repository.
.EXAMPLE
  Get-GitRecentContributors -TopN 5
  Shows the top 5 recent contributors.
.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-GitRecentContributors {
  [CmdletBinding()]
  [Alias("ggrc")]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Path to the Git repository."
    )]
    [Alias('p')]
    [ValidateNotNullOrEmpty()]
    [string]$Path = (Get-Location),

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "Number of top recent contributors to display."
    )]
    [Alias('n')]
    [ValidateRange(1, 100)]
    [int]$TopN = 10
  )

  if (-not (Test-Path -Path (Join-Path -Path $Path -ChildPath ".git") -PathType Container)) {
    Write-Error "Not a Git repository: $Path"
    return
  }

  Write-Host "Recent contributors for repository: $Path"
  git -C $Path shortlog -sne --all --no-merges | Select-Object -First $TopN
}

<#
.SYNOPSIS
  Helps create and push a new Git release (tag).
.DESCRIPTION
  This function simplifies the process of creating a new annotated Git tag and pushing it to the remote.
  It prompts for a tag name (e.g., v1.0.0) and an annotation message.
.PARAMETER TagName
  The name for the new tag (e.g., "v1.2.3"). If not provided, the user will be prompted.
.PARAMETER Message
  The annotation message for the tag. If not provided, the user will be prompted.
.PARAMETER Path
  Specifies the path to the Git repository. Defaults to the current location.
.PARAMETER Push
  If specified, pushes the new tag to the default remote (origin).
.PARAMETER Force
  If specified with -Push, forces the push (e.g., to overwrite an existing remote tag - use with caution).
.EXAMPLE
  New-GitRelease -TagName "v1.0.0" -Message "Initial release" -Push
  Creates an annotated tag v1.0.0 with the given message and pushes it.
.EXAMPLE
  New-GitRelease
  Prompts for tag name and message, then creates the tag locally.
.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function New-GitRelease {
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
  [Alias("ngr")]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The name for the new tag (e.g., 'v1.2.3'). If not provided, the user will be prompted."
    )]
    [Alias('tn')]
    [ValidateNotNullOrEmpty()]
    [string]$TagName,

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "The annotation message for the tag. If not provided, the user will be prompted."
    )]
    [Alias('m')]
    [ValidateNotNullOrEmpty()]
    [string]$Message,

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "Specifies the path to the Git repository. Defaults to the current location."
    )]
    [Alias('p')]
    [ValidateNotNullOrEmpty()]
    [string]$Path = (Get-Location),

    [Parameter(
      Mandatory = $false,
      Position = 3,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "If specified, pushes the new tag to the default remote (origin)."
    )]
    [Alias('push')]
    [ValidateNotNullOrEmpty()]
    [switch]$Push,

    [Parameter(
      Mandatory = $false,
      Position = 4,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false,
      ValueFromRemainingArguments = $false,
      HelpMessage = "If specified with -Push, forces the push (e.g., to overwrite an existing remote tag - use with caution)."
    )]
    [Alias('f')]
    [ValidateNotNullOrEmpty()]
    [switch]$Force
  )

  if (-not (Test-Path -Path (Join-Path -Path $Path -ChildPath ".git") -PathType Container)) {
    Write-Error "Not a Git repository: $Path"
    return
  }

  if ([string]::IsNullOrWhiteSpace($TagName)) {
    $TagName = Read-Host "Enter tag name (e.g., v1.0.0)"
    if ([string]::IsNullOrWhiteSpace($TagName)) {
      Write-Error "Tag name cannot be empty."
      return
    }
  }

  if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = Read-Host "Enter annotation message for tag '$TagName'"
    if ([string]::IsNullOrWhiteSpace($Message)) {
      Write-Error "Annotation message cannot be empty."
      return
    }
  }

  if ($PSCmdlet.ShouldProcess($TagName, "Create annotated Git tag")) {
    git -C $Path tag -a $TagName -m $Message
    Write-Host "Tag '$TagName' created locally."

    if ($Push.IsPresent) {
      if ($PSCmdlet.ShouldProcess("origin", "Push tag '$TagName' to remote")) {
        $pushArguments = @("-C", $Path, "push", "origin", $TagName)
        if ($Force.IsPresent) {
          $pushArguments += "--force"
        }
        git @pushArguments
        Write-Host "Tag '$TagName' pushed to origin."
      }
    }
  }
}
