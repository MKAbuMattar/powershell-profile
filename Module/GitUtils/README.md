<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\GitUtils\README.md -->

# GitUtils Module

## **Module Overview:**

The GitUtils module offers a collection of PowerShell functions to simplify and enhance common Git operations. From checking branch statuses and cleaning up local branches to searching repositories and creating releases, this module aims to make Git workflows more efficient directly from the PowerShell command line.

## **Key Features:**

- Quick insights into current Git branch status.
- Automated cleanup of merged local branches.
- Interactive Git repository searching (requires fzf).
- Easy retrieval of recent project contributors.
- Streamlined process for creating new Git releases.
- Access to general Git repository information.

## **Functions:**

- **`Get-GitBranchStatus`** (Alias: `ggbs`):

  - _Description:_ Retrieves and displays the status of the current Git branch. This typically includes the branch name, current commit hash, and its relationship to the remote tracking branch (e.g., ahead, behind, diverged).
  - _Usage:_ `ggbs`

- **`Invoke-GitCleanBranches`** (Alias: `igcb`):

  - _Description:_ Cleans up local Git branches that have already been merged into the current branch (usually `main` or `master`) and deleted on the remote.
  - _Usage:_ `igcb`
  - _Details:_ Prompts for confirmation before deleting branches by default.

- **`Start-GitRepoSearch`** (Alias: `sgrs`):

  - _Description:_ Initiates an interactive search for Git repositories within the current directory and its subdirectories. Uses `fzf` (fuzzy finder) for selection, then navigates to the chosen repository's root.
  - _Usage:_ `sgrs`
  - _Details:_ Requires `fzf` to be installed and accessible in the PATH.

- **`Get-GitRecentContributors`** (Alias: `ggrc`):

  - _Description:_ Retrieves a list of recent contributors to the current Git repository, based on commit history.
  - _Usage:_ `ggrc`
  - _Details:_ Output can be formatted to show contributor names and commit counts.

- **`New-GitRelease`** (Alias: `ngr`):

  - _Description:_ Facilitates the creation of a new Git release. This typically involves creating a new tag, pushing the tag to the remote, and optionally creating a release on platforms like GitHub.
  - _Usage:_ `ngr -Tag "v1.2.0" -Description "Release of new feature X and bug fixes."`
  - _Details:_ May interact with Git hosting platform APIs if configured.

- **`Get-GitRepoInfo`** (Alias: `gri`):
  - _Description:_ Retrieves general information about the current Git repository, such as the remote URL, default branch name, and other relevant metadata.
  - _Usage:_ `gri`

[Back to Modules](../../README.md#modules)

**Contribution:**
If you have ideas for new Git utilities or improvements to existing ones, please contribute! Check the main [Contributing Guidelines](../../README.md#contributing) for how to proceed.
