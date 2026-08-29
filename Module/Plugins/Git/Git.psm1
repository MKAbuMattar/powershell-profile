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
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Generated command wrappers
#
# Git.Generated.ps1 holds the pure tool wrappers, generated from commands.psd1 by
# Tools/Update-PluginCommand.ps1. Add a command by adding a row there, not by writing a function
# here. Everything below is hand-written because it does something a table cannot express.
#---------------------------------------------------------------------------------------------------
. (Join-Path $PSScriptRoot 'Git.Generated.ps1')

#---------------------------------------------------------------------------------------------------
# Import the custom Git modules
#---------------------------------------------------------------------------------------------------
$BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath '/'

$ModuleList = @(
    @{ Name = 'Core'; Path = 'Core/Core.psd1' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name

    if (Test-Path $ModulePath) {
        # Silencing this hid a broken Core.psm1 completely: 23 functions would simply not exist
        # and nothing would say why.
        try {
            Import-Module $ModulePath -Force -ErrorAction Stop
        }
        catch {
            Write-Warning "$ModuleName module failed to import from ${ModulePath}: $($_.Exception.Message)"
        }
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
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

function gbgdf {
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
