<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Plugins\Git\README.md -->

# Git Module

## **Module Overview:**

The Git module is a comprehensive collection of PowerShell functions that provide convenient aliases and shortcuts for Git commands. This module is inspired by popular Git alias collections and aims to streamline Git workflows by offering intuitive, short aliases for commonly used Git operations. The module automatically imports Git-Core and Git-Utility submodules to provide additional Git functionality including repository status, branch management, and prompt integration.

## **Key Features:**

- **Comprehensive Git Aliases**: Over 160+ Git command shortcuts covering all major Git operations
- **Repository Safety**: All functions automatically check if you're in a Git repository before executing
- **Smart Branch Detection**: Automatically detects main/master and develop/development branches
- **Enhanced Git Operations**: Includes advanced operations like interactive rebasing, stashing, and worktree management
- **Modular Design**: Imports specialized Git-Core and Git-Utility modules for extended functionality
- **Version Awareness**: Adapts commands based on Git version capabilities
- **Cross-platform Support**: Works seamlessly across different operating systems

## **Functions:**

### **Basic Git Operations:**

- **`g`**: Direct Git command wrapper - executes any Git command with arguments

  - _Usage:_ `g status` (equivalent to `git status`)

- **`grt`**: Navigate to Git repository root directory
  - _Usage:_ `grt`

### **Add Operations:**

- **`ga`**: Git add - stage files for commit

  - _Usage:_ `ga file1.txt file2.txt`

- **`gaa`**: Git add all - stage all modified and new files

  - _Usage:_ `gaa`

- **`gapa`**: Git add patch - interactively choose chunks to stage

  - _Usage:_ `gapa`

- **`gau`**: Git add update - stage all modified files (excluding new files)

  - _Usage:_ `gau`

- **`gav`**: Git add verbose - stage files with detailed output
  - _Usage:_ `gav file1.txt`

### **Apply/Am Operations:**

- **`gam`**: Git apply mailbox - apply patches from mailbox format

  - _Usage:_ `gam patch.mbox`

- **`gama`**: Git am abort - abort current mailbox apply operation

  - _Usage:_ `gama`

- **`gamc`**: Git am continue - continue mailbox apply after resolving conflicts

  - _Usage:_ `gamc`

- **`gamscp`**: Git am show current patch - show the patch being applied

  - _Usage:_ `gamscp`

- **`gams`**: Git am skip - skip current patch during mailbox apply

  - _Usage:_ `gams`

- **`gap`**: Git add patch - alias for interactive patch mode

  - _Usage:_ `gap`

- **`gapt`**: Git add patch (alternative) - interactive staging
  - _Usage:_ `gapt`

### **Branch Operations:**

- **`gb`**: Git branch - list, create, or manage branches

  - _Usage:_ `gb` (list branches), `gb new-feature` (create branch)

- **`gba`**: Git branch all - show all branches including remotes

  - _Usage:_ `gba`

- **`gbd`**: Git branch delete - delete specified branch

  - _Usage:_ `gbd feature-branch`

- **`gbD`**: Git branch force delete - force delete branch even if not merged

  - _Usage:_ `gbD feature-branch`

- **`gbm`**: Git branch move - rename current or specified branch

  - _Usage:_ `gbm new-name`

- **`gbnm`**: Git branch no-merged - show branches not merged into current branch

  - _Usage:_ `gbnm`

- **`gbr`**: Git branch remote - show remote tracking branches
  - _Usage:_ `gbr`

### **Branch Status Operations:**

- **`gbs`**: Git bisect start - start bisecting to find problematic commit

  - _Usage:_ `gbs`

- **`gbsb`**: Git bisect bad - mark current commit as bad

  - _Usage:_ `gbsb`

- **`gbsg`**: Git bisect good - mark current commit as good

  - _Usage:_ `gbsg`

- **`gbsn`**: Git bisect new - mark current commit as new (Git 2.7+)

  - _Usage:_ `gbsn`

- **`gbso`**: Git bisect old - mark current commit as old (Git 2.7+)

  - _Usage:_ `gbso`

- **`gbsr`**: Git bisect reset - end bisecting and return to original branch

  - _Usage:_ `gbsr`

- **`gbss`**: Git bisect skip - skip current commit during bisecting
  - _Usage:_ `gbss`

### **Checkout Operations:**

- **`gco`**: Git checkout - switch branches or restore files

  - _Usage:_ `gco main`, `gco file.txt`

- **`gcor`**: Git checkout recurse-submodules - checkout with submodule updates

  - _Usage:_ `gcor branch-name`

- **`gcb`**: Git checkout new branch - create and switch to new branch

  - _Usage:_ `gcb feature-branch`

- **`gcB`**: Git checkout force new branch - create/reset and switch to branch

  - _Usage:_ `gcB feature-branch`

- **`gcd`**: Git checkout develop - switch to develop branch

  - _Usage:_ `gcd`

- **`gcm`**: Git checkout main - switch to main/master branch
  - _Usage:_ `gcm`

### **Cherry-pick Operations:**

- **`gcp`**: Git cherry-pick - apply specific commit to current branch

  - _Usage:_ `gcp abc123`

- **`gcpa`**: Git cherry-pick abort - abort current cherry-pick operation

  - _Usage:_ `gcpa`

- **`gcpc`**: Git cherry-pick continue - continue cherry-pick after resolving conflicts
  - _Usage:_ `gcpc`

### **Clean Operations:**

- **`gclean`**: Git clean interactive - interactively clean untracked files
  - _Usage:_ `gclean`

### **Clone Operations:**

- **`gcl`**: Git clone - clone repository with submodules

  - _Usage:_ `gcl https://github.com/user/repo.git`

- **`gclf`**: Git clone fast - clone with optimized settings for large repositories

  - _Usage:_ `gclf https://github.com/user/repo.git`

- **`gccd`**: Git clone and cd - clone repository and change into directory
  - _Usage:_ `gccd https://github.com/user/repo.git`

### **Commit Operations:**

- **`gcam`**: Git commit all message - stage all changes and commit with message

  - _Usage:_ `gcam "Fix bug in user authentication"`

- **`gcas`**: Git commit all signoff - stage all changes and commit with signoff

  - _Usage:_ `gcas`

- **`gcasm`**: Git commit all signoff message - stage all, signoff, and commit with message

  - _Usage:_ `gcasm "Add new feature"`

- **`gcs`**: Git commit gpg-sign - commit with GPG signature

  - _Usage:_ `gcs`

- **`gcss`**: Git commit gpg-sign signoff - commit with GPG signature and signoff

  - _Usage:_ `gcss`

- **`gcssm`**: Git commit gpg-sign signoff message - GPG sign, signoff, and commit with message

  - _Usage:_ `gcssm "Secure commit message"`

- **`gcmsg`**: Git commit message - commit staged changes with message

  - _Usage:_ `gcmsg "Update documentation"`

- **`gcsm`**: Git commit signoff message - commit with signoff and message

  - _Usage:_ `gcsm "Add feature with signoff"`

- **`gcv`**: Git commit verbose - commit with verbose output

  - _Usage:_ `gcv`

- **`gca`**: Git commit all verbose - stage all and commit with verbose output
  - _Usage:_ `gca`

### **Config Operations:**

- **`gcf`**: Git config list - show Git configuration

  - _Usage:_ `gcf`

- **`gcfu`**: Git commit fixup - create fixup commit for specified commit
  - _Usage:_ `gcfu abc123`

### **Diff Operations:**

- **`gd`**: Git diff - show changes between commits, branches, etc.

  - _Usage:_ `gd`, `gd HEAD~1`

- **`gdca`**: Git diff cached - show staged changes

  - _Usage:_ `gdca`

- **`gdcw`**: Git diff cached word-diff - show staged changes with word-level diff

  - _Usage:_ `gdcw`

- **`gds`**: Git diff staged - show staged changes (alias for gdca)

  - _Usage:_ `gds`

- **`gdw`**: Git diff word-diff - show changes with word-level differences

  - _Usage:_ `gdw`

- **`gdup`**: Git diff upstream - show changes compared to upstream branch

  - _Usage:_ `gdup`

- **`gdt`**: Git diff-tree - show files changed in a commit

  - _Usage:_ `gdt HEAD`

- **`gdv`**: Git diff visual - show diff with better formatting

  - _Usage:_ `gdv`

- **`gdnolock`**: Git diff excluding lock files - show diff excluding package lock files

  - _Usage:_ `gdnolock`

- **`gdct`**: Git describe tags - show most recent tag
  - _Usage:_ `gdct`

### **Fetch Operations:**

- **`gf`**: Git fetch - download objects and refs from remote

  - _Usage:_ `gf`

- **`gfa`**: Git fetch all - fetch from all remotes with tags and prune

  - _Usage:_ `gfa`

- **`gfo`**: Git fetch origin - fetch from origin remote
  - _Usage:_ `gfo`

### **GUI Operations:**

- **`gg`**: Git gui citool - launch Git GUI commit tool

  - _Usage:_ `gg`

- **`gga`**: Git gui citool amend - launch Git GUI to amend last commit
  - _Usage:_ `gga`

### **Help Operations:**

- **`ghh`**: Git help - show help for Git commands
  - _Usage:_ `ghh commit`

### **Log Operations:**

- **`glgg`**: Git log graph - show commit history as a graph

  - _Usage:_ `glgg`

- **`glgga`**: Git log graph all - show all branches in commit graph

  - _Usage:_ `glgga`

- **`glgm`**: Git log graph max-count - show last 10 commits as graph

  - _Usage:_ `glgm`

- **`glo`**: Git log oneline - show commit history in one line per commit

  - _Usage:_ `glo`

- **`glog`**: Git log oneline graph - show commit history as one-line graph

  - _Usage:_ `glog`

- **`gloga`**: Git log oneline graph all - show all branches as one-line graph

  - _Usage:_ `gloga`

- **`glg`**: Git log stat - show commit history with file statistics

  - _Usage:_ `glg`

- **`glgp`**: Git log stat patch - show commit history with stats and patches

  - _Usage:_ `glgp`

- **`glol`**: Git log oneline relative - show commits with relative dates

  - _Usage:_ `glol`

- **`glola`**: Git log oneline relative all - show all branches with relative dates

  - _Usage:_ `glola`

- **`glols`**: Git log oneline relative stat - show commits with relative dates and stats

  - _Usage:_ `glols`

- **`glod`**: Git log oneline date - show commits with absolute dates

  - _Usage:_ `glod`

- **`glods`**: Git log oneline date short - show commits with short dates

  - _Usage:_ `glods`

- **`glp`**: Git log pretty - show log with custom pretty format
  - _Usage:_ `glp format-string`

### **Grep Operations:**

- **`gfg`**: Git find grep - search for pattern in tracked files
  - _Usage:_ `gfg "function name"`

### **Merge Operations:**

- **`gm`**: Git merge - merge branches

  - _Usage:_ `gm feature-branch`

- **`gma`**: Git merge abort - abort current merge operation

  - _Usage:_ `gma`

- **`gmc`**: Git merge continue - continue merge after resolving conflicts

  - _Usage:_ `gmc`

- **`gms`**: Git merge squash - squash merge without creating merge commit

  - _Usage:_ `gms feature-branch`

- **`gmff`**: Git merge fast-forward only - merge only if fast-forward possible

  - _Usage:_ `gmff feature-branch`

- **`gmtl`**: Git mergetool - launch merge conflict resolution tool

  - _Usage:_ `gmtl`

- **`gmtlvim`**: Git mergetool vim - use Vim as merge conflict resolution tool

  - _Usage:_ `gmtlvim`

- **`gmom`**: Git merge origin main - merge origin's main branch

  - _Usage:_ `gmom`

- **`gmum`**: Git merge upstream main - merge upstream's main branch
  - _Usage:_ `gmum`

### **Pull Operations:**

- **`gl`**: Git pull - pull changes from remote

  - _Usage:_ `gl`

- **`gpr`**: Git pull rebase - pull with rebase instead of merge

  - _Usage:_ `gpr`

- **`gprv`**: Git pull rebase verbose - pull with rebase and verbose output

  - _Usage:_ `gprv`

- **`gpra`**: Git pull rebase autostash - pull with rebase and automatic stashing

  - _Usage:_ `gpra`

- **`gprav`**: Git pull rebase autostash verbose - pull with rebase, autostash, and verbose output

  - _Usage:_ `gprav`

- **`gprom`**: Git pull rebase origin main - pull and rebase on origin's main branch

  - _Usage:_ `gprom`

- **`gpromi`**: Git pull rebase origin main interactive - interactive rebase on origin's main

  - _Usage:_ `gpromi`

- **`gprum`**: Git pull rebase upstream main - pull and rebase on upstream's main branch

  - _Usage:_ `gprum`

- **`gprumi`**: Git pull rebase upstream main interactive - interactive rebase on upstream's main

  - _Usage:_ `gprumi`

- **`ggpull`**: Git pull current branch - pull current branch from origin

  - _Usage:_ `ggpull`

- **`ggu`**: Git pull rebase current - pull current branch with rebase

  - _Usage:_ `ggu`

- **`ggl`**: Git pull origin current - pull current branch from origin

  - _Usage:_ `ggl`

- **`gluc`**: Git pull upstream current - pull current branch from upstream

  - _Usage:_ `gluc`

- **`glum`**: Git pull upstream main - pull main branch from upstream
  - _Usage:_ `glum`

### **Push Operations:**

- **`gp`**: Git push - push commits to remote repository

  - _Usage:_ `gp`

- **`gpd`**: Git push dry-run - show what would be pushed without actually pushing

  - _Usage:_ `gpd`

- **`gpf`**: Git push force-with-lease - safely force push with lease check

  - _Usage:_ `gpf`

- **`gpv`**: Git push verbose - push with detailed output

  - _Usage:_ `gpv`

- **`gpoat`**: Git push origin all tags - push all branches and tags to origin

  - _Usage:_ `gpoat`

- **`gpod`**: Git push origin delete - delete remote branch

  - _Usage:_ `gpod branch-name`

- **`gpu`**: Git push upstream - push to upstream remote

  - _Usage:_ `gpu`

- **`ggpush`**: Git push current branch - push current branch to origin

  - _Usage:_ `ggpush`

- **`gpsup`**: Git push set upstream - push and set upstream tracking

  - _Usage:_ `gpsup`

- **`gpsupf`**: Git push set upstream force - force push and set upstream tracking

  - _Usage:_ `gpsupf`

- **`ggp`**: Git push origin current - push current branch to origin

  - _Usage:_ `ggp`

- **`ggf`**: Git push force current - force push current branch to origin

  - _Usage:_ `ggf`

- **`ggfl`**: Git push force-with-lease current - safely force push current branch

  - _Usage:_ `ggfl`

- **`ggpnp`**: Git pull and push - pull then push current branch
  - _Usage:_ `ggpnp`

### **Rebase Operations:**

- **`grb`**: Git rebase - reapply commits on top of another base

  - _Usage:_ `grb main`

- **`grba`**: Git rebase abort - abort current rebase operation

  - _Usage:_ `grba`

- **`grbc`**: Git rebase continue - continue rebase after resolving conflicts

  - _Usage:_ `grbc`

- **`grbi`**: Git rebase interactive - start interactive rebase

  - _Usage:_ `grbi HEAD~3`

- **`grbo`**: Git rebase onto - rebase commits onto specific commit

  - _Usage:_ `grbo main feature~5`

- **`grbs`**: Git rebase skip - skip current commit during rebase

  - _Usage:_ `grbs`

- **`grbd`**: Git rebase develop - rebase current branch on develop

  - _Usage:_ `grbd`

- **`grbm`**: Git rebase main - rebase current branch on main

  - _Usage:_ `grbm`

- **`grbom`**: Git rebase origin main - rebase current branch on origin's main

  - _Usage:_ `grbom`

- **`grbum`**: Git rebase upstream main - rebase current branch on upstream's main
  - _Usage:_ `grbum`

### **Reflog Operations:**

- **`grf`**: Git reflog - show reference logs
  - _Usage:_ `grf`

### **Remote Operations:**

- **`gr`**: Git remote - manage remote repositories

  - _Usage:_ `gr` (list remotes), `gr add origin url`

- **`grv`**: Git remote verbose - show remote repositories with URLs

  - _Usage:_ `grv`

- **`gra`**: Git remote add - add new remote repository

  - _Usage:_ `gra upstream https://github.com/original/repo.git`

- **`grrm`**: Git remote remove - remove remote repository

  - _Usage:_ `grrm origin`

- **`grmv`**: Git remote rename - rename remote repository

  - _Usage:_ `grmv old-name new-name`

- **`grset`**: Git remote set-url - change remote repository URL

  - _Usage:_ `grset origin https://new-url.git`

- **`grup`**: Git remote update - fetch updates from all remotes
  - _Usage:_ `grup`

### **Reset Operations:**

- **`grh`**: Git reset - reset current HEAD to specified state

  - _Usage:_ `grh HEAD~1`

- **`gru`**: Git reset unstage - unstage files

  - _Usage:_ `gru file.txt`

- **`grhh`**: Git reset hard - reset hard to specified commit

  - _Usage:_ `grhh HEAD~1`

- **`grhk`**: Git reset keep - reset keeping working directory changes

  - _Usage:_ `grhk HEAD~1`

- **`grhs`**: Git reset soft - reset soft to specified commit

  - _Usage:_ `grhs HEAD~1`

- **`groh`**: Git reset origin hard - reset hard to origin's current branch
  - _Usage:_ `groh`

### **Restore Operations:**

- **`grs`**: Git restore - restore working tree files

  - _Usage:_ `grs file.txt`

- **`grss`**: Git restore source - restore files from specific source

  - _Usage:_ `grss HEAD~1 file.txt`

- **`grst`**: Git restore staged - restore staged files
  - _Usage:_ `grst file.txt`

### **Revert Operations:**

- **`grev`**: Git revert - create new commit that undoes previous commits

  - _Usage:_ `grev HEAD`

- **`greva`**: Git revert abort - abort current revert operation

  - _Usage:_ `greva`

- **`grevc`**: Git revert continue - continue revert after resolving conflicts
  - _Usage:_ `grevc`

### **Remove Operations:**

- **`grm`**: Git rm - remove files from working tree and index

  - _Usage:_ `grm file.txt`

- **`grmc`**: Git rm cached - remove files from index only
  - _Usage:_ `grmc file.txt`

### **Show Operations:**

- **`gsh`**: Git show - show commit information and changes

  - _Usage:_ `gsh HEAD`

- **`gsps`**: Git show pretty short with signature - show commit with signature info
  - _Usage:_ `gsps HEAD`

### **Statistics Operations:**

- **`gcount`**: Git shortlog summary - show commit count by author
  - _Usage:_ `gcount`

### **Stash Operations:**

- **`gstall`**: Git stash all - stash all changes including untracked files

  - _Usage:_ `gstall`

- **`gstaa`**: Git stash apply - apply most recent stash

  - _Usage:_ `gstaa`

- **`gstc`**: Git stash clear - remove all stashed entries

  - _Usage:_ `gstc`

- **`gstd`**: Git stash drop - remove single stash entry

  - _Usage:_ `gstd stash@{0}`

- **`gstl`**: Git stash list - list all stash entries

  - _Usage:_ `gstl`

- **`gstp`**: Git stash pop - apply and remove most recent stash

  - _Usage:_ `gstp`

- **`gsta`**: Git stash push - stash current changes

  - _Usage:_ `gsta "Work in progress"`

- **`gsts`**: Git stash show - show stash entry changes

  - _Usage:_ `gsts stash@{0}`

- **`gstu`**: Git stash untracked - stash including untracked files
  - _Usage:_ `gstu`

### **Status Operations:**

- **`gst`**: Git status - show working tree status

  - _Usage:_ `gst`

- **`gss`**: Git status short - show status in short format

  - _Usage:_ `gss`

- **`gsb`**: Git status short branch - show short status with branch info
  - _Usage:_ `gsb`

### **Submodule Operations:**

- **`gsi`**: Git submodule init - initialize submodules

  - _Usage:_ `gsi`

- **`gsu`**: Git submodule update - update submodules
  - _Usage:_ `gsu`

### **SVN Operations:**

- **`gsd`**: Git svn dcommit - commit to SVN repository

  - _Usage:_ `gsd`

- **`gsr`**: Git svn rebase - rebase against SVN repository
  - _Usage:_ `gsr`

### **Switch Operations:**

- **`gsw`**: Git switch - switch branches (Git 2.23+)

  - _Usage:_ `gsw main`

- **`gswc`**: Git switch create - create and switch to new branch

  - _Usage:_ `gswc feature-branch`

- **`gswd`**: Git switch develop - switch to develop branch

  - _Usage:_ `gswd`

- **`gswm`**: Git switch main - switch to main branch
  - _Usage:_ `gswm`

### **Tag Operations:**

- **`gta`**: Git tag annotate - create annotated tag

  - _Usage:_ `gta v1.0.0 "Release version 1.0.0"`

- **`gts`**: Git tag sign - create signed tag

  - _Usage:_ `gts v1.0.0`

- **`gtv`**: Git tag verify - list tags sorted by version

  - _Usage:_ `gtv`

- **`gtl`**: Git tag list - list tags matching pattern
  - _Usage:_ `gtl "v*"`

### **Update Index Operations:**

- **`gignore`**: Git update-index assume-unchanged - ignore changes to tracked file

  - _Usage:_ `gignore file.txt`

- **`gunignore`**: Git update-index no-assume-unchanged - stop ignoring changes to tracked file

  - _Usage:_ `gunignore file.txt`

- **`gignored`**: Show files that are being ignored by assume-unchanged
  - _Usage:_ `gignored`

### **Worktree Operations:**

- **`gwt`**: Git worktree - manage multiple working trees

  - _Usage:_ `gwt list`

- **`gwta`**: Git worktree add - add new working tree

  - _Usage:_ `gwta ../hotfix hotfix-branch`

- **`gwtls`**: Git worktree list - list working trees

  - _Usage:_ `gwtls`

- **`gwtmv`**: Git worktree move - move working tree

  - _Usage:_ `gwtmv ../old-location ../new-location`

- **`gwtrm`**: Git worktree remove - remove working tree
  - _Usage:_ `gwtrm ../feature-worktree`

### **Workflow Operations:**

- **`gwip`**: Git work in progress - quickly save work in progress

  - _Usage:_ `gwip`

- **`gunwip`**: Git undo work in progress - undo the last --wip-- commit

  - _Usage:_ `gunwip`

- **`gwch`**: Git whatchanged - show commit logs with changed files

  - _Usage:_ `gwch`

- **`gpristine`**: Git pristine - reset to pristine state (hard reset + clean)

  - _Usage:_ `gpristine`

- **`gwipe`**: Git wipe - reset and clean working directory
  - _Usage:_ `gwipe`

### **Branch Cleanup Operations:**

- **`gbda`**: Git branch delete all merged - delete all merged branches

  - _Usage:_ `gbda`

- **`gbds`**: Git branch delete squashed - delete branches that have been squash-merged

  - _Usage:_ `gbds`

- **`gbg`**: Git branch gone - show branches with deleted remotes

  - _Usage:_ `gbg`

- **`gbgd`**: Git branch gone delete - delete branches with deleted remotes

  - _Usage:_ `gbgd`

- **`gbgD`**: Git branch gone force delete - force delete branches with deleted remotes
  - _Usage:_ `gbgD`

### **Upstream Operations:**

- **`ggsup`**: Git set upstream - set upstream tracking for current branch
  - _Usage:_ `ggsup`

## **Imported Modules:**

### **Git-Core Module:**

Provides core Git functionality including repository detection, branch management, prompt integration, and version checking utilities.

### **Git-Utility Module:**

Provides additional utility functions for advanced Git operations and branch management.

## **Requirements:**

- Git must be installed and available in PATH
- PowerShell 5.0 or later
- Must be run from within a Git repository (most functions include automatic validation)

## **Installation Notes:**

This module automatically imports the Git-Core and Git-Utility submodules. If these modules are not found, warnings will be displayed, but the main Git alias functions will still be available.

[Back to Modules](../../../README.md#modules)

**Contribution:**
Contributions are welcome! This could include adding more Git aliases, improving existing functions, adding new Git workflow helpers, or enhancing the repository detection logic. Please adhere to the main [Contributing Guidelines](../../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../../LICENSE) file for details.
