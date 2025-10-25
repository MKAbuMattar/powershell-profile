#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Git Plugin
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This module provides Git command aliases and utility functions for improved Git workflow
#       in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Import the custom Git modules
#---------------------------------------------------------------------------------------------------
$BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath '/'

$ModuleList = @(
    @{ Name = 'Core'; Path = 'Core/Core.psd1' }
    @{ Name = 'Utility'; Path = 'Utility/Utility.psd1' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name

    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
}

function g {
    <#
    .SYNOPSIS
        A PowerShell function that wraps the `git` command.

    .DESCRIPTION
        This function is a shortcut for running the `git` command with any provided arguments.
        It allows you to execute Git commands directly from PowerShell by passing the desired
        arguments to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        g status
        Displays the status of the current Git repository.

        g commit -m "Your commit message"
        Commits changes in the current Git repository with the specified commit message.

        g push origin main
        Pushes the local "main" branch to the "origin" remote repository.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository for most commands to work.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git @Arguments
}

function  grt {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git rev-parse --show-toplevel`.

    .DESCRIPTION
        This function is a shortcut for running the `git rev-parse --show-toplevel` command.
        It outputs the absolute path of the top-level directory of the current Git repository.
        This is useful for determining the root directory of your repository from any subdirectory.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        None. This function writes the top-level directory path to the console but does not return objects.

    .EXAMPLE
        grt
        Outputs the absolute path of the top-level directory of the current Git repository.

        grt | Set-Location
        Changes the current directory to the top-level directory of the current Git repository.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    Set-Location (git rev-parse --show-toplevel)
}

function ga {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git add`.

    .DESCRIPTION
        This function is a shortcut for running the `git add` command.
        It allows you to stage changes in your Git repository by passing the desired
        arguments to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git add` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git add`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        ga .
        Stages all changes in the current directory.

        ga file.txt
        Stages the specified file.

        ga -u
        Stages all modified and deleted files, but not new untracked files.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git add @Arguments
}

function gaa {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git add --all`.

    .DESCRIPTION
        This function is a shortcut for running the `git add --all` command.
        It stages all changes in your Git repository, including new, modified, and deleted files.

    .PARAMETER Arguments
        Additional arguments to pass to the `git add --all` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git add --all`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gaa
        Stages all changes in the current Git repository.

        gaa .
        Stages all changes in the current directory.

        gaa file.txt
        Stages the specified file.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git add --all @Arguments
}

function gapa {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git add --patch`.

    .DESCRIPTION
        This function is a shortcut for running the `git add --patch` command.
        It allows you to interactively stage changes in your Git repository by selecting
        specific hunks of changes to add.

    .PARAMETER Arguments
        Additional arguments to pass to the `git add --patch` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git add --patch`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gapa
        Starts an interactive session to stage changes in the current Git repository.

        gapa file.txt
        Starts an interactive session to stage changes in the specified file.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git add --patch @Arguments
}

function gau {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git add --update`.

    .DESCRIPTION
        This function is a shortcut for running the `git add --update` command.
        It stages changes to tracked files in your Git repository, including modifications
        and deletions, but does not stage new untracked files.

    .PARAMETER Arguments
        Additional arguments to pass to the `git add --update` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git add --update`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gau
        Stages all modifications and deletions of tracked files in the current Git repository.

        gau .
        Stages all modifications and deletions of tracked files in the current directory.

        gau file.txt
        Stages modifications and deletions of the specified tracked file.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git add --update @Arguments
}

function gav {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git add --verbose`.

    .DESCRIPTION
        This function is a shortcut for running the `git add --verbose` command.
        It stages changes in your Git repository and provides detailed output about
        the files being added.

    .PARAMETER Arguments
        Additional arguments to pass to the `git add --verbose` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git add --verbose`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gav
        Stages all changes in the current Git repository with verbose output.

        gav .
        Stages all changes in the current directory with verbose output.

        gav file.txt
        Stages the specified file with verbose output.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git add --verbose @Arguments
}

function gam {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git am`.

    .DESCRIPTION
        This function is a shortcut for running the `git am` command.
        It applies a series of patches from a mailbox file to the current branch in your Git repository.

    .PARAMETER Arguments
        Additional arguments to pass to the `git am` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git am`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gam patch.mbox
        Applies the patches from the specified mailbox file to the current branch.

        gam --signoff patch.mbox
        Applies the patches with a sign-off message.

        gam --3way patch.mbox
        Applies the patches using a three-way merge if necessary.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git am @Arguments
}

function gama {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git am --abort`.

    .DESCRIPTION
        This function is a shortcut for running the `git am --abort` command.
        It aborts the current `git am` operation and resets the repository to the state
        before the operation began.

    .PARAMETER Arguments
        Additional arguments to pass to the `git am --abort` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git am --abort`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gama
        Aborts the current `git am` operation.

        gama --quiet
        Aborts the current `git am` operation with minimal output.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git am --abort @Arguments
}

function gamc {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git am --continue`.

    .DESCRIPTION
        This function is a shortcut for running the `git am --continue` command.
        It continues the current `git am` operation after resolving any conflicts.

    .PARAMETER Arguments
        Additional arguments to pass to the `git am --continue` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git am --continue`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gamc
        Continues the current `git am` operation.

        gamc --quiet
        Continues the current `git am` operation with minimal output.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git am --continue @Arguments
}

function gamscp {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git am --show-current-patch`.

    .DESCRIPTION
        This function is a shortcut for running the `git am --show-current-patch` command.
        It displays the current patch being applied during a `git am` operation.

    .PARAMETER Arguments
        Additional arguments to pass to the `git am --show-current-patch` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git am --show-current-patch`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gamscp
        Displays the current patch being applied during a `git am` operation.

        gamscp --stat
        Displays the current patch with statistics.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git am --show-current-patch @Arguments
}

function gams {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git am --skip`.

    .DESCRIPTION
        This function is a shortcut for running the `git am --skip` command.
        It skips the current patch being applied during a `git am` operation and
        continues with the next patch.

    .PARAMETER Arguments
        Additional arguments to pass to the `git am --skip` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git am --skip`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gams
        Skips the current patch being applied during a `git am` operation.

        gams --quiet
        Skips the current patch with minimal output.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git am --skip @Arguments
}

function gap {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git apply`.

    .DESCRIPTION
        This function is a shortcut for running the `git apply` command.
        It applies a patch to files in your Git repository.

    .PARAMETER Arguments
        Additional arguments to pass to the `git apply` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git apply`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gap patch.diff
        Applies the specified patch file to the current Git repository.

        gap --stat patch.diff
        Displays statistics about the changes that would be made by applying the patch.

        gap --check patch.diff
        Checks if the patch can be applied cleanly without actually applying it.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git apply @Arguments
}

function gapt {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git apply --3way`.

    .DESCRIPTION
        This function is a shortcut for running the `git apply --3way` command.
        It applies a patch to files in your Git repository using a three-way merge
        if there are conflicts.

    .PARAMETER Arguments
        Additional arguments to pass to the `git apply --3way` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git apply --3way`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gapt patch.diff
        Applies the specified patch file to the current Git repository using a three-way merge if necessary.

        gapt --stat patch.diff
        Displays statistics about the changes that would be made by applying the patch.

        gapt --check patch.diff
        Checks if the patch can be applied cleanly without actually applying it.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git apply --3way @Arguments
}

function gbs {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect` command.
        It helps you find the commit that introduced a bug by performing a binary search
        through the commit history.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbs start
        Starts a bisect session.

        gbs good <commit>
        Marks the specified commit as good.

        gbs bad <commit>
        Marks the specified commit as bad.

        gbs reset
        Ends the bisect session and resets to the original HEAD.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect @Arguments
}

function gbsb {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect bad`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect bad` command.
        It marks the current commit as bad during a bisect session.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect bad` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect bad`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbsb
        Marks the current commit as bad.

        gbsb <commit>
        Marks the specified commit as bad.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect bad @Arguments
}

function gbsg {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect good`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect good` command.
        It marks the current commit as good during a bisect session.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect good` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect good`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbsg
        Marks the current commit as good.

        gbsg <commit>
        Marks the specified commit as good.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect good @Arguments
}

function gbsn {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect new`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect new` command.
        It starts a new bisect session by specifying the known good and bad commits.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect new` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect new`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbsn <bad-commit> <good-commit>
        Starts a new bisect session with the specified bad and good commits.

        gbsn --term-old <bad-commit> --term-new <good-commit>
        Starts a new bisect session with custom terms for bad and good commits.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect new @Arguments
}

function gbso {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect old`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect old` command.
        It marks the current commit as old (bad) during a bisect session.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect old` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect old`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbso
        Marks the current commit as old (bad).

        gbso <commit>
        Marks the specified commit as old (bad).

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect old @Arguments
}

function gbsr {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect reset`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect reset` command.
        It ends the current bisect session and resets the repository to the original HEAD.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect reset` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect reset`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbsr
        Ends the current bisect session and resets to the original HEAD.

        gbsr <commit>
        Ends the current bisect session and resets to the specified commit.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect reset @Arguments
}

function gbss {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git bisect start`.

    .DESCRIPTION
        This function is a shortcut for running the `git bisect start` command.
        It initiates a bisect session to help find the commit that introduced a bug.

    .PARAMETER Arguments
        Additional arguments to pass to the `git bisect start` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git bisect start`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbss
        Starts a bisect session.

        gbss <bad-commit> <good-commit>
        Starts a bisect session with the specified bad and good commits.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git bisect start @Arguments
}

function gbl {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git blame -w`.

    .DESCRIPTION
        This function is a shortcut for running the `git blame -w` command.
        It shows what revision and author last modified each line of a file,
        ignoring whitespace changes.

    .PARAMETER Arguments
        Additional arguments to pass to the `git blame -w` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git blame -w`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbl file.txt
        Shows the blame information for the specified file, ignoring whitespace changes.

        gbl -L 10,20 file.txt
        Shows the blame information for lines 10 to 20 of the specified file, ignoring whitespace changes.

        gbl -C -C file.txt
        Shows the blame information for the specified file, including copies and ignoring whitespace changes.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git blame -w @Arguments
}

function gb {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch` command.
        It allows you to manage branches in your Git repository by passing the desired
        arguments to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gb
        Lists all local branches in the current Git repository.

        gb new-branch
        Creates a new branch named "new-branch".

        gb -d old-branch
        Deletes the branch named "old-branch".

        gb -m old-name new-name
        Renames the branch from "old-name" to "new-name".

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch @Arguments
}

function gba {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --all`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch --all` command.
        It lists all branches in your Git repository, including both local and remote branches.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch --all` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch --all`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gba
        Lists all local and remote branches in the current Git repository.

        gba -r
        Lists only remote branches.

        gba -v
        Lists all branches with the latest commit on each branch.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --all @Arguments
}

function gbd {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --delete`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch --delete` command.
        It deletes one or more branches in your Git repository.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch --delete` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch --delete`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbd branch-name
        Deletes the specified branch.

        gbd -r origin/branch-name
        Deletes the specified remote-tracking branch.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --delete @Arguments
}

function gbD {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --delete --force`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch --delete --force` command.
        It forcefully deletes one or more branches in your Git repository, even if they
        have unmerged changes.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch --delete --force` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch --delete --force`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbD branch-name
        Forcefully deletes the specified branch, even if it has unmerged changes.

        gbD -r origin/branch-name
        Forcefully deletes the specified remote-tracking branch, even if it has unmerged changes.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --delete --force @Arguments
}

function gbm {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --move`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch --move` command.
        It renames a branch in your Git repository.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch --move` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch --move`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbm old-branch new-branch
        Renames the branch from "old-branch" to "new-branch".

        gbm -f old-branch new-branch
        Forcefully renames the branch, even if "new-branch" already exists.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --move @Arguments
}

function gbnm {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --move --no-ff`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch --move --no-ff` command.
        It renames a branch in your Git repository without fast-forwarding.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch --move --no-ff` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch --move --no-ff`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbnm old-branch new-branch
        Renames the branch from "old-branch" to "new-branch" without fast-forwarding.

        gbnm -f old-branch new-branch
        Forcefully renames the branch, even if "new-branch" already exists, without fast-forwarding.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --no-merged @Arguments
}

function gbr {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --remote`.

    .DESCRIPTION
        This function is a shortcut for running the `git branch --remote` command.
        It lists all remote branches in your Git repository.

    .PARAMETER Arguments
        Additional arguments to pass to the `git branch --remote` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git branch --remote`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gbr
        Lists all remote branches in the current Git repository.

        gbr -v
        Lists all remote branches with the latest commit on each branch.

        gbr origin
        Lists all remote branches for the specified remote (e.g., "origin").

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --remote @Arguments
}

function gco {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git checkout`.

    .DESCRIPTION
        This function is a shortcut for running the `git checkout` command.
        It allows you to switch branches or restore working tree files in your Git repository.
        Any arguments you would normally pass to `git checkout` can be provided to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git checkout` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git checkout`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gco branch-name
        Switches to the specified branch.

        gco -b new-branch
        Creates and switches to a new branch named "new-branch".

        gco file.txt
        Restores the specified file to its state in the index or the specified commit.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout @Arguments
}

function gcor {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git checkout --recurse-submodules`.

    .DESCRIPTION
        This function is a shortcut for running the `git checkout --recurse-submodules` command.
        It allows you to switch branches or restore working tree files in your Git repository,
        while also updating submodules recursively. Any arguments you would normally pass to
        `git checkout --recurse-submodules` can be provided to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git checkout --recurse-submodules` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git checkout --recurse-submodules`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gcor branch-name
        Switches to the specified branch and updates submodules recursively.

        gcor -b new-branch
        Creates and switches to a new branch named "new-branch", updating submodules recursively.

        gcor file.txt
        Restores the specified file to its state in the index or the specified commit,
        updating submodules recursively.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout --recurse-submodules @Arguments
}

function gcb {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git checkout -b`.

    .DESCRIPTION
        This function is a shortcut for running the `git checkout -b` command.
        It creates and switches to a new branch in your Git repository.
        Any arguments you would normally pass to `git checkout -b` can be provided to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git checkout -b` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git checkout -b`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gcb new-branch
        Creates and switches to a new branch named "new-branch".

        gcb new-branch start-point
        Creates and switches to a new branch named "new-branch" starting from "start-point".

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout -b @Arguments
}

function gcB {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git checkout -B`.

    .DESCRIPTION
        This function is a shortcut for running the `git checkout -B` command.
        It creates or resets a branch to a specified state and switches to it in your Git repository.
        Any arguments you would normally pass to `git checkout -B` can be provided to this function.

    .PARAMETER Arguments
        Additional arguments to pass to the `git checkout -B` command.

    .INPUTS
        [string[]] Arguments — arguments are passed directly to `git checkout -B`.

    .OUTPUTS
        None. This function writes Git output to the console but does not return objects.

    .EXAMPLE
        gcB branch-name
        Creates or resets the branch named "branch-name" to the current HEAD and switches to it.

        gcB branch-name start-point
        Creates or resets the branch named "branch-name" to "start-point" and switches to it.

    .NOTES
        - Requires Git to be installed and available in the system's PATH.
        - Must be run inside a Git repository.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout -B @Arguments
}

function gcp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git cherry-pick @Arguments
}

function gcpa {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git cherry-pick --abort @Arguments
}

function gcpc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git cherry-pick --continue @Arguments
}

function gclean {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git clean --interactive -d @Arguments
}

function gcl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git clone --recurse-submodules @Arguments
}

function gclf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules @Arguments
}

function gcam {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --all --message @Arguments
}

function gcas {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --all --signoff @Arguments
}

function gcasm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --all --signoff --message @Arguments
}

function gcs {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --gpg-sign @Arguments
}

function gcss {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --gpg-sign --signoff @Arguments
}

function gcssm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --gpg-sign --signoff --message @Arguments
}

function gcmsg {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --message @Arguments
}

function gcsm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --signoff --message @Arguments
}

function gcv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --verbose @Arguments
}

function gca {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --verbose --all @Arguments
}

function gcf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git config --list @Arguments
}

function gcfu {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git commit --fixup @Arguments
}

function gd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff @Arguments
}

function gdca {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff --cached @Arguments
}

function gdcw {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff --cached --word-diff @Arguments
}

function gds {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff --staged @Arguments
}

function gdw {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff --word-diff @Arguments
}

function gdup {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff '@{upstream}' @Arguments
}

function gdt {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff-tree --no-commit-id --name-only -r @Arguments
}

function  gf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git fetch @Arguments
}

function gfa {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git fetch --all --tags --prune @Arguments
}

function gfo {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git fetch origin @Arguments
}

function gg {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git gui citool @Arguments
}

function gga {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git gui citool --amend @Arguments
}

function ghh {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git help @Arguments
}

function glgg {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph @Arguments
}

function glgga {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --decorate --all @Arguments
}

function glgm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --max-count=10 @Arguments
}

function glo {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --oneline --decorate @Arguments
}

function glog {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --oneline --decorate --graph @Arguments
}

function gloga {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --oneline --decorate --graph --all @Arguments
}

function glg {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --stat @Arguments
}

function glgp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --stat --patch @Arguments
}

function gfg {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git ls-files | grep @Arguments
}

function gm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge @Arguments
}

function gma {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge --abort @Arguments
}

function gmc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge --continue @Arguments
}

function gms {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge --squash @Arguments
}

function gmff {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge --ff-only @Arguments
}

function gmtl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git mergetool --no-prompt @Arguments
}

function gmtlvim {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git mergetool --no-prompt --tool=vimdiff @Arguments
}

function gl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull @Arguments
}

function gpr {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase @Arguments
}

function gprv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase -v @Arguments
}

function gpra {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase --autostash @Arguments
}

function gprav {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase --autostash -v @Arguments
}

function gp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push @Arguments
}

function gpd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push --dry-run @Arguments
}


function gpf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if (Test-GitVersionAtLeast -RequiredVersion "2.30") {
        & git push --force-with-lease --force-if-includes @Arguments
    }
    else {
        & git push --force-with-lease @Arguments
    }
}

function gpv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push --verbose @Arguments
}

function gpoat {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push origin --all; git push origin --tags
}

function gpod {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push origin --delete @Arguments
}

function gpu {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push upstream @Arguments
}

function grb {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase @Arguments
}

function grba {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase --abort @Arguments
}

function grbc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase --continue @Arguments
}

function grbi {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase --interactive @Arguments
}

function grbo {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase --onto @Arguments
}

function grbs {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase --skip @Arguments
}

function grf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reflog @Arguments
}

function gr {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote @Arguments
}

function grv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote --verbose @Arguments
}

function gra {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote add @Arguments
}

function grrm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote remove @Arguments
}

function grmv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote rename @Arguments
}

function grset {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote set-url @Arguments
}

function grup {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git remote update @Arguments
}

function grh {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset @Arguments
}

function gru {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset -- @Arguments
}

function grhh {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset --hard @Arguments
}

function grhk {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset --keep @Arguments
}

function grhs {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset --soft @Arguments
}

function grs {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git restore @Arguments
}

function grss {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git restore --source @Arguments
}

function grst {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git restore --staged @Arguments
}

function grev {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git revert @Arguments
}

function greva {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git revert --abort @Arguments
}

function grevc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git revert --continue @Arguments
}

function grm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rm @Arguments
}

function grmc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rm --cached @Arguments
}

function gcount {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git shortlog --summary --numbered @Arguments
}

function gsh {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git show @Arguments
}

function gsps {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git show --pretty=short --show-signature @Arguments
}

function gstall {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash --all @Arguments
}

function gstaa {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash apply @Arguments
}

function gstc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash clear @Arguments
}

function gstd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash drop @Arguments
}

function gstl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash list @Arguments
}

function gstp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash pop @Arguments
}

function gsta {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if (Test-GitVersionAtLeast -RequiredVersion "2.13") {
        & git stash push @Arguments
    }
    else {
        & git stash save @Arguments
    }
}

function gsts {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash show --patch @Arguments
}

function gstu {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash --include-untracked @Arguments
}

function gst {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git status @Arguments
}

function gss {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git status --short @Arguments
}

function gsb {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git status --short --branch @Arguments
}

function gsi {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git submodule init @Arguments
}

function gsu {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git submodule update @Arguments
}

function gsd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git svn dcommit @Arguments
}

function gsr {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git svn rebase @Arguments
}

function gsw {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git switch @Arguments
}

function gswc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git switch --create @Arguments
}

function gta {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git tag --annotate @Arguments
}

function gts {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git tag --sign @Arguments
}

function gtv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git tag | Sort-Object -V @Arguments
}

function gignore {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git update-index --assume-unchanged @Arguments
}

function gunignore {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git update-index --no-assume-unchanged @Arguments
}

function gwch {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git whatchanged -p --abbrev-commit --pretty=medium @Arguments
}

function gwt {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git worktree @Arguments
}

function gwta {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git worktree add @Arguments
}

function gwtls {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git worktree list @Arguments
}

function gwtmv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git worktree move @Arguments
}

function gwtrm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git worktree remove @Arguments
}

function gwip {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git add -A
    & git rm (git ls-files --deleted) 2>$null
    & git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]" @Arguments
}

function gunwip {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $commitMessage = git rev-list --max-count=1 --format="%s" HEAD
    if ($commitMessage -match "--wip--") {
        & git reset HEAD~1
    }
}

function gcd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout (Get-GitDevelopBranch) @Arguments
}

function gcm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout (Get-GitMainBranch) @Arguments
}

function gswd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git switch (Get-GitDevelopBranch) @Arguments
}

function gswm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git switch (Get-GitMainBranch) @Arguments
}

function grbd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase (Get-GitDevelopBranch) @Arguments
}

function grbm {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase (Get-GitMainBranch) @Arguments
}

function grbom {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase "origin/$(Get-GitMainBranch)" @Arguments
}

function grbum {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git rebase "upstream/$(Get-GitMainBranch)" @Arguments
}

function ggsup {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --set-upstream-to="origin/$(Get-GitCurrentBranch)" @Arguments
}

function gmom {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge "origin/$(Get-GitMainBranch)" @Arguments
}

function gmum {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git merge "upstream/$(Get-GitMainBranch)" @Arguments
}

function gprom {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase origin (Get-GitMainBranch) @Arguments
}

function gpromi {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase=interactive origin (Get-GitMainBranch) @Arguments
}

function gprum {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase upstream (Get-GitMainBranch) @Arguments
}

function gprumi {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull --rebase=interactive upstream (Get-GitMainBranch) @Arguments
}

function ggpull {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull origin (Get-GitCurrentBranch) @Arguments
}

function ggpush {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push origin (Get-GitCurrentBranch) @Arguments
}

function gpsup {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push --set-upstream origin (Get-GitCurrentBranch) @Arguments
}

function gpsupf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if (Test-GitVersionAtLeast -RequiredVersion "2.30") {
        & git push --set-upstream origin (Get-GitCurrentBranch) --force-with-lease --force-if-includes @Arguments
    }
    else {
        & git push --set-upstream origin (Get-GitCurrentBranch) --force-with-lease @Arguments
    }
}

function groh {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset "origin/$(Get-GitCurrentBranch)" --hard @Arguments
}

function gluc {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull upstream (Get-GitCurrentBranch) @Arguments
}

function  glum {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull upstream (Get-GitMainBranch) @Arguments
}

function gdct {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git describe --tags (git rev-list --tags --max-count=1) @Arguments
}

function gdnolock {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff @Arguments ":(exclude)package-lock.json" ":(exclude)*.lock"
}
function gdv {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff -w @Arguments | Out-Host
}

function gpristine {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset --hard; & git clean --force -dfx
}

function gwipe {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git reset --hard; & git clean --force -df
}

function gignored {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git ls-files -v | Where-Object { $_ -match "^[a-z]" }
}

function gbda {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $mainBranch = Get-GitMainBranch
    $developBranch = Get-GitDevelopBranch
    & git branch --no-color --merged | Where-Object {
        $_ -notmatch "^[\*\+]" -and
        $_ -notmatch "^\s*($mainBranch|$developBranch)\s*$"
    } | ForEach-Object {
        & git branch --delete $_.Trim() 2>$null
    }
}

function gbds {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $defaultBranch = Get-GitMainBranch
    if ($LASTEXITCODE -ne 0) { $defaultBranch = Get-GitDevelopBranch }

    & git for-each-ref refs/heads/ "--format=%(refname:short)" | ForEach-Object {
        $branch = $_
        $mergeBase = git merge-base $defaultBranch $branch
        $cherry = git cherry $defaultBranch (git commit-tree (git rev-parse "$branch^{tree}") -p $mergeBase -m "_")
        if ($cherry -match "^-") {
            git branch -D $branch
        }
    }
}

function gbgd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --no-color -vv | Where-Object { $_ -match ": gone\]" } | ForEach-Object {
        $branchName = ($_ -replace "^.{3}" -split "\s+")[0]
        & git branch -d $branchName
    }
}

function gbgD {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --no-color -vv | Where-Object { $_ -match ": gone\]" } | ForEach-Object {
        $branchName = ($_ -replace "^.{3}" -split "\s+")[0]
        & git branch -D $branchName
    }
}

function gbg {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch -vv | Where-Object { $_ -match ": gone\]" }
}

function gccd {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $repo = $args | Where-Object { $_ -match "(ssh://|git://|ftp(s)?://|http(s)?://|.*@)" }
    if (!$repo) { $repo = $args[-1] }

    & git clone --recurse-submodules @Arguments
    if ($LASTEXITCODE -eq 0) {
        if (Test-Path $args[-1]) {
            Set-Location $args[-1]
        }
        else {
            $repoName = [System.IO.Path]::GetFileNameWithoutExtension($repo)
            Set-Location $repoName
        }
    }
}

function ggpnp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -eq 0) {
        &  ggl; & ggp
    }
    else {
        & ggl @Arguments; & ggp @Arguments
    }
}

function ggu {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -eq 0) {
        $branch = Get-GitCurrentBranch
        & git pull --rebase origin $branch
    }
    else {
        & git pull --rebase origin @Arguments
    }
}

function ggl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -eq 0) {
        $branch = Get-GitCurrentBranch
        & git pull origin $branch
    }
    else {
        & git pull origin @Arguments
    }
}

function ggp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -eq 0) {
        $branch = Get-GitCurrentBranch
        & git push origin $branch
    }
    else {
        & git push origin @Arguments
    }
}

function ggf {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -eq 0) {
        $branch = Get-GitCurrentBranch
        & git push --force origin $branch
    }
    else {
        & git push --force origin @Arguments
    }
}

function ggfl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -eq 0) {
        $branch = Get-GitCurrentBranch
        & git push --force-with-lease origin $branch
    }
    else {
        & git push --force-with-lease origin @Arguments
    }
}

function glods {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short @Arguments
}

function glod {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" @Arguments
}

function glola {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all @Arguments
}

function glols {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat @Arguments
}

function glol {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" @Arguments
}


function glp {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    if ($Arguments.Count -gt 0) {
        & git log --pretty=$Arguments[0]
    }
    else {
        & git log
    }
}

function gtl {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Arguments

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $pattern = if ($Arguments.Count -gt 0) { "$($Arguments[0])*" } else { "*" }
    & git tag --sort=-v:refname -n --list $pattern
}
