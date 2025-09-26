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
