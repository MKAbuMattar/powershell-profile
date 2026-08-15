#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Git generated commands
#
# GENERATED FILE. Do not edit.
#
# Source of truth is commands.psd1 beside this file. Add or change a command there and run
# Tools/Update-PluginCommand.ps1. Tools/Test-PluginCommand.ps1 fails CI when the two disagree.
#
# Every function here wraps $Tool and passes the remaining arguments through unchanged.
#---------------------------------------------------------------------------------------------------

function g {
    <#
    .SYNOPSIS
        A PowerShell function that wraps the `git` command.

    .DESCRIPTION
        Runs `git` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        g
        Runs `git`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git @Arguments
}

function ga {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git add`.

    .DESCRIPTION
        Runs `git add` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git add` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        ga
        Runs `git add`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git add --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git add --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gaa
        Runs `git add --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git add --patch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git add --patch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gapa
        Runs `git add --patch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git add --update` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git add --update` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gau
        Runs `git add --update`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git add --verbose` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git add --verbose` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gav
        Runs `git add --verbose`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git am` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git am` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gam
        Runs `git am`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git am --abort` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git am --abort` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gama
        Runs `git am --abort`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git am --continue` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git am --continue` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gamc
        Runs `git am --continue`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git am --show-current-patch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git am --show-current-patch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gamscp
        Runs `git am --show-current-patch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git am --skip` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git am --skip` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gams
        Runs `git am --skip`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git apply` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git apply` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gap
        Runs `git apply`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git apply --3way` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git apply --3way` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gapt
        Runs `git apply --3way`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbs
        Runs `git bisect`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect bad` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect bad` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbsb
        Runs `git bisect bad`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect good` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect good` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbsg
        Runs `git bisect good`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect new` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect new` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbsn
        Runs `git bisect new`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect old` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect old` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbso
        Runs `git bisect old`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect reset` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect reset` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbsr
        Runs `git bisect reset`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git bisect start` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git bisect start` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbss
        Runs `git bisect start`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git blame -w` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git blame -w` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbl
        Runs `git blame -w`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git branch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gb
        Runs `git branch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git branch --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gba
        Runs `git branch --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git branch --delete` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --delete` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbd
        Runs `git branch --delete`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git branch --delete @Arguments
}

function gbdf {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git branch --delete --force`.

    .DESCRIPTION
        Runs `git branch --delete --force` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --delete --force` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbdf
        Runs `git branch --delete --force`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git branch --move` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --move` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbm
        Runs `git branch --move`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git branch --no-merged` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --no-merged` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbnm
        Runs `git branch --no-merged`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git branch --remote` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --remote` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gbr
        Runs `git branch --remote`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git checkout` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git checkout` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gco
        Runs `git checkout`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git checkout --recurse-submodules` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git checkout --recurse-submodules` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcor
        Runs `git checkout --recurse-submodules`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Runs `git checkout -b` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git checkout -b` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcb
        Runs `git checkout -b`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git checkout -b @Arguments
}

function gcbf {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `git checkout -B`.

    .DESCRIPTION
        Runs `git checkout -B` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git checkout -B` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcbf
        Runs `git checkout -B`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git cherry-pick @Arguments`.

    .DESCRIPTION
        Runs `git cherry-pick` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git cherry-pick` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcp
        Runs `git cherry-pick`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git cherry-pick --abort @Arguments`.

    .DESCRIPTION
        Runs `git cherry-pick --abort` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git cherry-pick --abort` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcpa
        Runs `git cherry-pick --abort`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git cherry-pick --continue @Arguments`.

    .DESCRIPTION
        Runs `git cherry-pick --continue` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git cherry-pick --continue` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcpc
        Runs `git cherry-pick --continue`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git clean --interactive -d @Arguments`.

    .DESCRIPTION
        Runs `git clean --interactive -d` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git clean --interactive -d` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gclean
        Runs `git clean --interactive -d`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git clone --recurse-submodules @Arguments`.

    .DESCRIPTION
        Runs `git clone --recurse-submodules` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git clone --recurse-submodules` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcl
        Runs `git clone --recurse-submodules`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules @Arguments`.

    .DESCRIPTION
        Runs `git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gclf
        Runs `git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --all --message @Arguments`.

    .DESCRIPTION
        Runs `git commit --all --message` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --all --message` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcam
        Runs `git commit --all --message`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --all --signoff @Arguments`.

    .DESCRIPTION
        Runs `git commit --all --signoff` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --all --signoff` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcas
        Runs `git commit --all --signoff`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --all --signoff --message @Arguments`.

    .DESCRIPTION
        Runs `git commit --all --signoff --message` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --all --signoff --message` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcasm
        Runs `git commit --all --signoff --message`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --gpg-sign @Arguments`.

    .DESCRIPTION
        Runs `git commit --gpg-sign` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --gpg-sign` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcs
        Runs `git commit --gpg-sign`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --gpg-sign --signoff @Arguments`.

    .DESCRIPTION
        Runs `git commit --gpg-sign --signoff` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --gpg-sign --signoff` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcss
        Runs `git commit --gpg-sign --signoff`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --gpg-sign --signoff --message @Arguments`.

    .DESCRIPTION
        Runs `git commit --gpg-sign --signoff --message` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --gpg-sign --signoff --message` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcssm
        Runs `git commit --gpg-sign --signoff --message`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --message @Arguments`.

    .DESCRIPTION
        Runs `git commit --message` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --message` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcmsg
        Runs `git commit --message`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --signoff --message @Arguments`.

    .DESCRIPTION
        Runs `git commit --signoff --message` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --signoff --message` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcsm
        Runs `git commit --signoff --message`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --verbose @Arguments`.

    .DESCRIPTION
        Runs `git commit --verbose` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --verbose` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcv
        Runs `git commit --verbose`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --verbose --all @Arguments`.

    .DESCRIPTION
        Runs `git commit --verbose --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --verbose --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gca
        Runs `git commit --verbose --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git config --list @Arguments`.

    .DESCRIPTION
        Runs `git config --list` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git config --list` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcf
        Runs `git config --list`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git commit --fixup @Arguments`.

    .DESCRIPTION
        Runs `git commit --fixup` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git commit --fixup` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcfu
        Runs `git commit --fixup`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git diff @Arguments`.

    .DESCRIPTION
        Runs `git diff` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git diff` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gd
        Runs `git diff`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git diff --cached @Arguments`.

    .DESCRIPTION
        Runs `git diff --cached` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git diff --cached` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gdca
        Runs `git diff --cached`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git diff --cached --word-diff @Arguments`.

    .DESCRIPTION
        Runs `git diff --cached --word-diff` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git diff --cached --word-diff` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gdcw
        Runs `git diff --cached --word-diff`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git diff --staged @Arguments`.

    .DESCRIPTION
        Runs `git diff --staged` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git diff --staged` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gds
        Runs `git diff --staged`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git diff --word-diff @Arguments`.

    .DESCRIPTION
        Runs `git diff --word-diff` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git diff --word-diff` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gdw
        Runs `git diff --word-diff`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff --word-diff @Arguments
}

function gdt {
    <#
    .SYNOPSIS
        Wraps `& git diff-tree --no-commit-id --name-only -r @Arguments`.

    .DESCRIPTION
        Runs `git diff-tree --no-commit-id --name-only -r` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git diff-tree --no-commit-id --name-only -r` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gdt
        Runs `git diff-tree --no-commit-id --name-only -r`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git diff-tree --no-commit-id --name-only -r @Arguments
}

function gf {
    <#
    .SYNOPSIS
        Wraps `& git fetch @Arguments`.

    .DESCRIPTION
        Runs `git fetch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git fetch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gf
        Runs `git fetch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git fetch --all --tags --prune @Arguments`.

    .DESCRIPTION
        Runs `git fetch --all --tags --prune` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git fetch --all --tags --prune` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gfa
        Runs `git fetch --all --tags --prune`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git fetch origin @Arguments`.

    .DESCRIPTION
        Runs `git fetch origin` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git fetch origin` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gfo
        Runs `git fetch origin`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git gui citool @Arguments`.

    .DESCRIPTION
        Runs `git gui citool` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git gui citool` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gg
        Runs `git gui citool`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git gui citool --amend @Arguments`.

    .DESCRIPTION
        Runs `git gui citool --amend` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git gui citool --amend` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gga
        Runs `git gui citool --amend`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git help @Arguments`.

    .DESCRIPTION
        Runs `git help` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git help` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        ghh
        Runs `git help`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph @Arguments`.

    .DESCRIPTION
        Runs `git log --graph` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glgg
        Runs `git log --graph`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph --decorate --all @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --decorate --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --decorate --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glgga
        Runs `git log --graph --decorate --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph --max-count=10 @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --max-count=10` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --max-count=10` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glgm
        Runs `git log --graph --max-count=10`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --oneline --decorate @Arguments`.

    .DESCRIPTION
        Runs `git log --oneline --decorate` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --oneline --decorate` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glo
        Runs `git log --oneline --decorate`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --oneline --decorate --graph @Arguments`.

    .DESCRIPTION
        Runs `git log --oneline --decorate --graph` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --oneline --decorate --graph` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glog
        Runs `git log --oneline --decorate --graph`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --oneline --decorate --graph --all @Arguments`.

    .DESCRIPTION
        Runs `git log --oneline --decorate --graph --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --oneline --decorate --graph --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gloga
        Runs `git log --oneline --decorate --graph --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --stat @Arguments`.

    .DESCRIPTION
        Runs `git log --stat` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --stat` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glg
        Runs `git log --stat`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --stat --patch @Arguments`.

    .DESCRIPTION
        Runs `git log --stat --patch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --stat --patch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glgp
        Runs `git log --stat --patch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git ls-files | grep @Arguments`.

    .DESCRIPTION
        Runs `git ls-files | grep` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git ls-files | grep` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gfg
        Runs `git ls-files | grep`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge @Arguments`.

    .DESCRIPTION
        Runs `git merge` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gm
        Runs `git merge`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge --abort @Arguments`.

    .DESCRIPTION
        Runs `git merge --abort` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge --abort` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gma
        Runs `git merge --abort`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge --continue @Arguments`.

    .DESCRIPTION
        Runs `git merge --continue` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge --continue` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gmc
        Runs `git merge --continue`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge --squash @Arguments`.

    .DESCRIPTION
        Runs `git merge --squash` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge --squash` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gms
        Runs `git merge --squash`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge --ff-only @Arguments`.

    .DESCRIPTION
        Runs `git merge --ff-only` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge --ff-only` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gmff
        Runs `git merge --ff-only`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git mergetool --no-prompt @Arguments`.

    .DESCRIPTION
        Runs `git mergetool --no-prompt` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git mergetool --no-prompt` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gmtl
        Runs `git mergetool --no-prompt`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git mergetool --no-prompt --tool=vimdiff @Arguments`.

    .DESCRIPTION
        Runs `git mergetool --no-prompt --tool=vimdiff` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git mergetool --no-prompt --tool=vimdiff` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gmtlvim
        Runs `git mergetool --no-prompt --tool=vimdiff`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull @Arguments`.

    .DESCRIPTION
        Runs `git pull` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gl
        Runs `git pull`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpr
        Runs `git pull --rebase`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase -v @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase -v` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase -v` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gprv
        Runs `git pull --rebase -v`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase --autostash @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase --autostash` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase --autostash` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpra
        Runs `git pull --rebase --autostash`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase --autostash -v @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase --autostash -v` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase --autostash -v` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gprav
        Runs `git pull --rebase --autostash -v`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git push @Arguments`.

    .DESCRIPTION
        Runs `git push` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gp
        Runs `git push`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git push --dry-run @Arguments`.

    .DESCRIPTION
        Runs `git push --dry-run` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push --dry-run` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpd
        Runs `git push --dry-run`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push --dry-run @Arguments
}

function gpv {
    <#
    .SYNOPSIS
        Wraps `& git push --verbose @Arguments`.

    .DESCRIPTION
        Runs `git push --verbose` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push --verbose` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpv
        Runs `git push --verbose`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push --verbose @Arguments
}

function gpod {
    <#
    .SYNOPSIS
        Wraps `& git push origin --delete @Arguments`.

    .DESCRIPTION
        Runs `git push origin --delete` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push origin --delete` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpod
        Runs `git push origin --delete`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git push upstream @Arguments`.

    .DESCRIPTION
        Runs `git push upstream` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push upstream` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpu
        Runs `git push upstream`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase @Arguments`.

    .DESCRIPTION
        Runs `git rebase` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grb
        Runs `git rebase`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase --abort @Arguments`.

    .DESCRIPTION
        Runs `git rebase --abort` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase --abort` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grba
        Runs `git rebase --abort`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase --continue @Arguments`.

    .DESCRIPTION
        Runs `git rebase --continue` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase --continue` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbc
        Runs `git rebase --continue`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase --interactive @Arguments`.

    .DESCRIPTION
        Runs `git rebase --interactive` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase --interactive` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbi
        Runs `git rebase --interactive`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase --onto @Arguments`.

    .DESCRIPTION
        Runs `git rebase --onto` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase --onto` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbo
        Runs `git rebase --onto`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase --skip @Arguments`.

    .DESCRIPTION
        Runs `git rebase --skip` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase --skip` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbs
        Runs `git rebase --skip`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git reflog @Arguments`.

    .DESCRIPTION
        Runs `git reflog` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reflog` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grf
        Runs `git reflog`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote @Arguments`.

    .DESCRIPTION
        Runs `git remote` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gr
        Runs `git remote`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote --verbose @Arguments`.

    .DESCRIPTION
        Runs `git remote --verbose` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote --verbose` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grv
        Runs `git remote --verbose`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote add @Arguments`.

    .DESCRIPTION
        Runs `git remote add` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote add` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gra
        Runs `git remote add`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote remove @Arguments`.

    .DESCRIPTION
        Runs `git remote remove` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote remove` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grrm
        Runs `git remote remove`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote rename @Arguments`.

    .DESCRIPTION
        Runs `git remote rename` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote rename` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grmv
        Runs `git remote rename`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote set-url @Arguments`.

    .DESCRIPTION
        Runs `git remote set-url` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote set-url` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grset
        Runs `git remote set-url`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git remote update @Arguments`.

    .DESCRIPTION
        Runs `git remote update` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git remote update` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grup
        Runs `git remote update`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git reset @Arguments`.

    .DESCRIPTION
        Runs `git reset` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reset` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grh
        Runs `git reset`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git reset -- @Arguments`.

    .DESCRIPTION
        Runs `git reset --` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reset --` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gru
        Runs `git reset --`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git reset --hard @Arguments`.

    .DESCRIPTION
        Runs `git reset --hard` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reset --hard` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grhh
        Runs `git reset --hard`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git reset --keep @Arguments`.

    .DESCRIPTION
        Runs `git reset --keep` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reset --keep` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grhk
        Runs `git reset --keep`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git reset --soft @Arguments`.

    .DESCRIPTION
        Runs `git reset --soft` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reset --soft` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grhs
        Runs `git reset --soft`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git restore @Arguments`.

    .DESCRIPTION
        Runs `git restore` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git restore` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grs
        Runs `git restore`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git restore --source @Arguments`.

    .DESCRIPTION
        Runs `git restore --source` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git restore --source` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grss
        Runs `git restore --source`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git restore --staged @Arguments`.

    .DESCRIPTION
        Runs `git restore --staged` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git restore --staged` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grst
        Runs `git restore --staged`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git revert @Arguments`.

    .DESCRIPTION
        Runs `git revert` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git revert` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grev
        Runs `git revert`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git revert --abort @Arguments`.

    .DESCRIPTION
        Runs `git revert --abort` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git revert --abort` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        greva
        Runs `git revert --abort`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git revert --continue @Arguments`.

    .DESCRIPTION
        Runs `git revert --continue` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git revert --continue` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grevc
        Runs `git revert --continue`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rm @Arguments`.

    .DESCRIPTION
        Runs `git rm` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rm` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grm
        Runs `git rm`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rm --cached @Arguments`.

    .DESCRIPTION
        Runs `git rm --cached` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rm --cached` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grmc
        Runs `git rm --cached`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git shortlog --summary --numbered @Arguments`.

    .DESCRIPTION
        Runs `git shortlog --summary --numbered` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git shortlog --summary --numbered` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcount
        Runs `git shortlog --summary --numbered`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git show @Arguments`.

    .DESCRIPTION
        Runs `git show` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git show` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsh
        Runs `git show`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git show --pretty=short --show-signature @Arguments`.

    .DESCRIPTION
        Runs `git show --pretty=short --show-signature` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git show --pretty=short --show-signature` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsps
        Runs `git show --pretty=short --show-signature`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash --all @Arguments`.

    .DESCRIPTION
        Runs `git stash --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstall
        Runs `git stash --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash apply @Arguments`.

    .DESCRIPTION
        Runs `git stash apply` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash apply` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstaa
        Runs `git stash apply`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash clear @Arguments`.

    .DESCRIPTION
        Runs `git stash clear` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash clear` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstc
        Runs `git stash clear`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash drop @Arguments`.

    .DESCRIPTION
        Runs `git stash drop` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash drop` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstd
        Runs `git stash drop`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash list @Arguments`.

    .DESCRIPTION
        Runs `git stash list` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash list` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstl
        Runs `git stash list`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash pop @Arguments`.

    .DESCRIPTION
        Runs `git stash pop` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash pop` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstp
        Runs `git stash pop`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git stash pop @Arguments
}

function gsts {
    <#
    .SYNOPSIS
        Wraps `& git stash show --patch @Arguments`.

    .DESCRIPTION
        Runs `git stash show --patch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash show --patch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsts
        Runs `git stash show --patch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git stash --include-untracked @Arguments`.

    .DESCRIPTION
        Runs `git stash --include-untracked` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git stash --include-untracked` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gstu
        Runs `git stash --include-untracked`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git status @Arguments`.

    .DESCRIPTION
        Runs `git status` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git status` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gst
        Runs `git status`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git status --short @Arguments`.

    .DESCRIPTION
        Runs `git status --short` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git status --short` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gss
        Runs `git status --short`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git status --short --branch @Arguments`.

    .DESCRIPTION
        Runs `git status --short --branch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git status --short --branch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsb
        Runs `git status --short --branch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git submodule init @Arguments`.

    .DESCRIPTION
        Runs `git submodule init` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git submodule init` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsi
        Runs `git submodule init`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git submodule update @Arguments`.

    .DESCRIPTION
        Runs `git submodule update` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git submodule update` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsu
        Runs `git submodule update`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git svn dcommit @Arguments`.

    .DESCRIPTION
        Runs `git svn dcommit` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git svn dcommit` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsd
        Runs `git svn dcommit`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git svn rebase @Arguments`.

    .DESCRIPTION
        Runs `git svn rebase` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git svn rebase` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsr
        Runs `git svn rebase`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git switch @Arguments`.

    .DESCRIPTION
        Runs `git switch` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git switch` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gsw
        Runs `git switch`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git switch --create @Arguments`.

    .DESCRIPTION
        Runs `git switch --create` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git switch --create` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gswc
        Runs `git switch --create`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git tag --annotate @Arguments`.

    .DESCRIPTION
        Runs `git tag --annotate` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git tag --annotate` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gta
        Runs `git tag --annotate`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git tag --sign @Arguments`.

    .DESCRIPTION
        Runs `git tag --sign` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git tag --sign` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gts
        Runs `git tag --sign`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git tag | Sort-Object -V @Arguments`.

    .DESCRIPTION
        Runs `git tag | Sort-Object -V` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git tag | Sort-Object -V` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gtv
        Runs `git tag | Sort-Object -V`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git update-index --assume-unchanged @Arguments`.

    .DESCRIPTION
        Runs `git update-index --assume-unchanged` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git update-index --assume-unchanged` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gignore
        Runs `git update-index --assume-unchanged`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git update-index --no-assume-unchanged @Arguments`.

    .DESCRIPTION
        Runs `git update-index --no-assume-unchanged` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git update-index --no-assume-unchanged` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gunignore
        Runs `git update-index --no-assume-unchanged`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git whatchanged -p --abbrev-commit --pretty=medium @Arguments`.

    .DESCRIPTION
        Runs `git whatchanged -p --abbrev-commit --pretty=medium` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git whatchanged -p --abbrev-commit --pretty=medium` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gwch
        Runs `git whatchanged -p --abbrev-commit --pretty=medium`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git worktree @Arguments`.

    .DESCRIPTION
        Runs `git worktree` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git worktree` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gwt
        Runs `git worktree`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git worktree add @Arguments`.

    .DESCRIPTION
        Runs `git worktree add` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git worktree add` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gwta
        Runs `git worktree add`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git worktree list @Arguments`.

    .DESCRIPTION
        Runs `git worktree list` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git worktree list` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gwtls
        Runs `git worktree list`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git worktree move @Arguments`.

    .DESCRIPTION
        Runs `git worktree move` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git worktree move` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gwtmv
        Runs `git worktree move`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git worktree remove @Arguments`.

    .DESCRIPTION
        Runs `git worktree remove` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git worktree remove` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gwtrm
        Runs `git worktree remove`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git worktree remove @Arguments
}

function gcd {
    <#
    .SYNOPSIS
        Wraps `& git checkout (Get-GitDevelopBranch) @Arguments`.

    .DESCRIPTION
        Runs `git checkout (Get-GitDevelopBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git checkout (Get-GitDevelopBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcd
        Runs `git checkout (Get-GitDevelopBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git checkout (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git checkout (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git checkout (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gcm
        Runs `git checkout (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git switch (Get-GitDevelopBranch) @Arguments`.

    .DESCRIPTION
        Runs `git switch (Get-GitDevelopBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git switch (Get-GitDevelopBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gswd
        Runs `git switch (Get-GitDevelopBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git switch (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git switch (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git switch (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gswm
        Runs `git switch (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase (Get-GitDevelopBranch) @Arguments`.

    .DESCRIPTION
        Runs `git rebase (Get-GitDevelopBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase (Get-GitDevelopBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbd
        Runs `git rebase (Get-GitDevelopBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git rebase (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbm
        Runs `git rebase (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase "origin/$(Get-GitMainBranch)" @Arguments`.

    .DESCRIPTION
        Runs `git rebase "origin/$(Get-GitMainBranch)"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase "origin/$(Get-GitMainBranch)"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbom
        Runs `git rebase "origin/$(Get-GitMainBranch)"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git rebase "upstream/$(Get-GitMainBranch)" @Arguments`.

    .DESCRIPTION
        Runs `git rebase "upstream/$(Get-GitMainBranch)"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git rebase "upstream/$(Get-GitMainBranch)"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        grbum
        Runs `git rebase "upstream/$(Get-GitMainBranch)"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git branch --set-upstream-to="origin/$(Get-GitCurrentBranch)" @Arguments`.

    .DESCRIPTION
        Runs `git branch --set-upstream-to="origin/$(Get-GitCurrentBranch)"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git branch --set-upstream-to="origin/$(Get-GitCurrentBranch)"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        ggsup
        Runs `git branch --set-upstream-to="origin/$(Get-GitCurrentBranch)"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge "origin/$(Get-GitMainBranch)" @Arguments`.

    .DESCRIPTION
        Runs `git merge "origin/$(Get-GitMainBranch)"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge "origin/$(Get-GitMainBranch)"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gmom
        Runs `git merge "origin/$(Get-GitMainBranch)"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git merge "upstream/$(Get-GitMainBranch)" @Arguments`.

    .DESCRIPTION
        Runs `git merge "upstream/$(Get-GitMainBranch)"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git merge "upstream/$(Get-GitMainBranch)"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gmum
        Runs `git merge "upstream/$(Get-GitMainBranch)"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase origin (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase origin (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase origin (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gprom
        Runs `git pull --rebase origin (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase=interactive origin (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase=interactive origin (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase=interactive origin (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpromi
        Runs `git pull --rebase=interactive origin (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase upstream (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase upstream (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase upstream (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gprum
        Runs `git pull --rebase upstream (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull --rebase=interactive upstream (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull --rebase=interactive upstream (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull --rebase=interactive upstream (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gprumi
        Runs `git pull --rebase=interactive upstream (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull origin (Get-GitCurrentBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull origin (Get-GitCurrentBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull origin (Get-GitCurrentBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        ggpull
        Runs `git pull origin (Get-GitCurrentBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git push origin (Get-GitCurrentBranch) @Arguments`.

    .DESCRIPTION
        Runs `git push origin (Get-GitCurrentBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push origin (Get-GitCurrentBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        ggpush
        Runs `git push origin (Get-GitCurrentBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git push --set-upstream origin (Get-GitCurrentBranch) @Arguments`.

    .DESCRIPTION
        Runs `git push --set-upstream origin (Get-GitCurrentBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git push --set-upstream origin (Get-GitCurrentBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gpsup
        Runs `git push --set-upstream origin (Get-GitCurrentBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git push --set-upstream origin (Get-GitCurrentBranch) @Arguments
}

function groh {
    <#
    .SYNOPSIS
        Wraps `& git reset "origin/$(Get-GitCurrentBranch)" --hard @Arguments`.

    .DESCRIPTION
        Runs `git reset "origin/$(Get-GitCurrentBranch)" --hard` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git reset "origin/$(Get-GitCurrentBranch)" --hard` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        groh
        Runs `git reset "origin/$(Get-GitCurrentBranch)" --hard`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git pull upstream (Get-GitCurrentBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull upstream (Get-GitCurrentBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull upstream (Get-GitCurrentBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gluc
        Runs `git pull upstream (Get-GitCurrentBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git pull upstream (Get-GitCurrentBranch) @Arguments
}

function glum {
    <#
    .SYNOPSIS
        Wraps `& git pull upstream (Get-GitMainBranch) @Arguments`.

    .DESCRIPTION
        Runs `git pull upstream (Get-GitMainBranch)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git pull upstream (Get-GitMainBranch)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glum
        Runs `git pull upstream (Get-GitMainBranch)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git describe --tags (git rev-list --tags --max-count=1) @Arguments`.

    .DESCRIPTION
        Runs `git describe --tags (git rev-list --tags --max-count=1)` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git describe --tags (git rev-list --tags --max-count=1)` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        gdct
        Runs `git describe --tags (git rev-list --tags --max-count=1)`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git describe --tags (git rev-list --tags --max-count=1) @Arguments
}

function glods {
    <#
    .SYNOPSIS
        Wraps `& git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glods
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glod
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glola
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glols
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        Wraps `& git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" @Arguments`.

    .DESCRIPTION
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever git writes.

    .EXAMPLE
        glol
        Runs `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" @Arguments
}
