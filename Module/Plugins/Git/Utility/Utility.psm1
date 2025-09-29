function Rename-GitBranch {
    <#
    .SYNOPSIS
        Renames a Git branch both locally and remotely.

    .DESCRIPTION
        This function renames a Git branch both locally and remotely. It takes the old branch name and the new branch name as parameters. It first renames the branch locally using `git branch -m`, and then it deletes the old branch from the remote repository and pushes the new branch to the remote repository, setting the upstream tracking.

    .PARAMETER OldBranch
        The name of the branch to be renamed.

    .PARAMETER NewBranch
        The new name for the branch.

    .INPUTS
        OldBranch: The name of the branch to be renamed.
        NewBranch: The new name for the branch.

    .OUTPUTS
        This function does not return any output.

    .EXAMPLE
        Rename-GitBranch -OldBranch "feature/old-name" -NewBranch "feature/new-name"
        Renames the branch "feature/old-name" to "feature/new-name" both locally and remotely.

    .NOTES
        This function requires Git to be installed and available in the system's PATH.
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
