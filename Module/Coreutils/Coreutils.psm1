#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Coreutils Module
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
#       Manages Microsoft coreutils from PowerShell: detection, installation, and turning
#       individual GNU utilities on and off.
#
#       coreutils and this profile compete for the same names. `grep`, `head`, `tail`, `touch`
#       and `sed` are all both a GNU binary and a profile alias, and PowerShell resolves an alias
#       before an application, so whoever wins is a decision rather than an accident. This module
#       is the reporting half of that decision; PreferNativeTools in profile.config.psd1 is the
#       acting half.
#
# Created: 2026-08-15
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

# coreutils records itself here. Detecting by registry rather than by probing Program Files means
# a relocated install is still found, and an uninstalled one is not falsely detected from leftovers.
$script:CoreutilsRegistryPath = 'HKLM:\SOFTWARE\Microsoft\coreutils'
$script:CoreutilsDisabledValue = 'DisabledUtilities'
$script:CoreutilsWingetId = 'Microsoft.Coreutils'

function Get-CoreutilsInstallation {
    <#
    .SYNOPSIS
        Reports whether Microsoft coreutils is installed, and where.

    .DESCRIPTION
        Looks for the registry key coreutils writes on install, then locates the manager
        executable relative to it. Every other function in this module goes through here, so an
        absent coreutils produces one clear answer rather than a scattering of errors.

    .INPUTS
        None.

    .OUTPUTS
        [PSCustomObject] Installed, Root, Manager, CommandDirectory and Version.

    .EXAMPLE
        Get-CoreutilsInstallation
        Reports the installation state.

    .EXAMPLE
        if ((Get-CoreutilsInstallation).Installed) { 'present' }

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('coreutils-info')]
    [OutputType([PSCustomObject])]
    param()

    $manager = Get-Command -Name 'coreutils-manager' -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1

    $registered = Test-Path -LiteralPath $script:CoreutilsRegistryPath

    if (-not $manager -and -not $registered) {
        return [PSCustomObject]@{
            Installed        = $false
            Root             = $null
            Manager          = $null
            CommandDirectory = $null
            Version          = $null
        }
    }

    $root = if ($manager) { Split-Path -Parent (Split-Path -Parent $manager.Source) } else { $null }

    $version = $null
    if ($manager) {
        $reported = & $manager.Source '--version' 2>&1
        if ($reported -match '([\d]+\.[\d.]+)') { $version = $Matches[1] }
    }

    return [PSCustomObject]@{
        Installed        = $true
        Root             = $root
        Manager          = if ($manager) { $manager.Source } else { $null }
        CommandDirectory = if ($root) { Join-Path $root 'cmd' } else { $null }
        Version          = $version
    }
}

function Get-CoreutilsUtility {
    <#
    .SYNOPSIS
        Lists every coreutils utility, whether it is enabled, and whether the profile contests it.

    .DESCRIPTION
        Combines three sources so the whole picture is in one table:

        coreutils-manager status  the utilities that ship, and their enabled state
        the live session          what each name actually resolves to right now
        Tools/ExportPolicy.psd1   the names this profile also wants

        The Contested column is the interesting one. `grep` is shipped by coreutils and also
        exported as a profile alias for Get-ContentMatching; only one of them answers when you
        type it, and Resolves tells you which.

    .PARAMETER Name
        Limit to the named utilities. Accepts wildcards.

    .PARAMETER ContestedOnly
        Show only utilities whose name the profile also claims.

    .INPUTS
        [string] A utility name.

    .OUTPUTS
        [PSCustomObject[]] Name, Enabled, Contested, Resolves.

    .EXAMPLE
        Get-CoreutilsUtility
        Lists all utilities with their state.

    .EXAMPLE
        Get-CoreutilsUtility -ContestedOnly
        Shows only the names the profile and coreutils both want.

    .EXAMPLE
        Get-CoreutilsUtility -Name 'sha*'
        Lists the checksum utilities.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('coreutils-list')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Name,

        [switch]$ContestedOnly
    )

    begin {
        $installation = Get-CoreutilsInstallation

        if (-not $installation.Installed) {
            Write-Warning 'Microsoft coreutils is not installed. Run Install-Coreutils to add it.'
            return
        }

        # The profile's own claim on these names.
        $contested = @()
        $policyPath = Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'Tools/ExportPolicy.psd1'
        if (Test-Path -LiteralPath $policyPath) {
            $contested = @((Import-PowerShellDataFile -LiteralPath $policyPath).NativeToolNames)
        }

        $status = & $installation.Manager 'status' 2>&1
    }

    process {
        if (-not $installation.Installed) { return }

        foreach ($line in $status) {
            if ($line -notmatch '^\s*(\S+)\s+(enabled|disabled)\s*$') { continue }

            $utility = $Matches[1]
            $enabled = $Matches[2] -eq 'enabled'

            if ($Name -and $utility -notlike $Name) { continue }

            $isContested = $utility -in $contested
            if ($ContestedOnly -and -not $isContested) { continue }

            $resolved = Get-Command -Name $utility -ErrorAction SilentlyContinue
            $resolves = if (-not $resolved) {
                'nothing'
            }
            elseif ($resolved.CommandType -eq 'Application') {
                'coreutils'
            }
            else {
                "$($resolved.CommandType): $($resolved.Name)"
            }

            [PSCustomObject]@{
                Name      = $utility
                Enabled   = $enabled
                Contested = $isContested
                Resolves  = $resolves
            }
        }
    }
}

function Enable-CoreutilsUtility {
    <#
    .SYNOPSIS
        Turns one or more coreutils utilities back on.

    .DESCRIPTION
        Wraps `coreutils-manager enable`. Requires an elevated session, because the enabled list
        lives under HKLM.

    .PARAMETER Name
        Utilities to enable.

    .INPUTS
        [string[]] Utility names.

    .OUTPUTS
        None.

    .EXAMPLE
        Enable-CoreutilsUtility ls, cat
        Re-enables the ls and cat utilities.

    .EXAMPLE
        Get-CoreutilsUtility | Where-Object { -not $_.Enabled } | Enable-CoreutilsUtility
        Re-enables everything currently disabled.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('coreutils-enable')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    process {
        Invoke-CoreutilsManager -Action 'enable' -Name $Name
    }
}

function Disable-CoreutilsUtility {
    <#
    .SYNOPSIS
        Turns one or more coreutils utilities off.

    .DESCRIPTION
        Wraps `coreutils-manager disable`. Requires an elevated session.

        Disabling is the other way to settle a contested name: rather than letting the profile
        yield with PreferNativeTools, take the name away from coreutils entirely.

    .PARAMETER Name
        Utilities to disable.

    .INPUTS
        [string[]] Utility names.

    .OUTPUTS
        None.

    .EXAMPLE
        Disable-CoreutilsUtility find
        Stops coreutils shadowing PowerShell's own find.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('coreutils-disable')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    process {
        Invoke-CoreutilsManager -Action 'disable' -Name $Name
    }
}

function Invoke-CoreutilsManager {
    <#
    .SYNOPSIS
        Runs coreutils-manager, checking the things that make it fail confusingly.

    .PARAMETER Action
        enable or disable.

    .PARAMETER Name
        Utilities to act on.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('enable', 'disable')]
        [string]$Action,

        [Parameter(Mandatory)]
        [string[]]$Name
    )

    $installation = Get-CoreutilsInstallation
    if (-not $installation.Installed) {
        Write-Warning 'Microsoft coreutils is not installed. Run Install-Coreutils to add it.'
        return
    }

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not ([Security.Principal.WindowsPrincipal]$identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Changing which utilities are enabled writes to HKLM and needs an elevated session."
        return
    }

    foreach ($utility in $Name) {
        if (-not $PSCmdlet.ShouldProcess($utility, "coreutils-manager $Action")) { continue }

        & $installation.Manager $Action $utility
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "coreutils-manager $Action $utility exited with code $LASTEXITCODE."
        }
    }

    Write-Host 'Restart your shell for the change to take effect.' -ForegroundColor DarkGray
}

function Install-Coreutils {
    <#
    .SYNOPSIS
        Installs Microsoft coreutils.

    .DESCRIPTION
        Installs via winget. There are several packages matching "coreutils"; this uses
        Microsoft.Coreutils specifically, which is the one that provides coreutils-manager and the
        PowerShell integration this module talks to. uutils.coreutils is a different project.

        The installer appends a marked block to $PROFILE. Update-Profile and setup.ps1 both
        preserve marked blocks, so installing coreutils after the profile, or the profile after
        coreutils, works either way round.

    .PARAMETER Force
        Reinstall even when already present.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        Install-Coreutils
        Installs coreutils if it is not already present.

    .EXAMPLE
        Install-Coreutils -WhatIf
        Reports what would be installed.

    .LINK
        https://github.com/microsoft/coreutils
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('coreutils-install')]
    [OutputType([void])]
    param(
        [switch]$Force
    )

    $installation = Get-CoreutilsInstallation

    if ($installation.Installed -and -not $Force) {
        Write-Host "Microsoft coreutils $($installation.Version) is already installed at $($installation.Root)." -ForegroundColor Green
        return
    }

    if (-not (Get-Command -Name winget -CommandType Application -ErrorAction SilentlyContinue)) {
        Write-Warning 'winget is not available. Install "App Installer" from the Microsoft Store, or download coreutils from https://github.com/microsoft/coreutils/releases.'
        return
    }

    if (-not $PSCmdlet.ShouldProcess($script:CoreutilsWingetId, 'winget install')) { return }

    & winget install --exact --id $script:CoreutilsWingetId --accept-source-agreements --accept-package-agreements

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "winget exited with code $LASTEXITCODE."
        return
    }

    Write-Host ''
    Write-Host 'coreutils installed. Restart your shell, then:' -ForegroundColor Green
    Write-Host '    Get-CoreutilsUtility -ContestedOnly    see which names it and the profile both want'
    Write-Host ''
}

function Show-CoreutilsConflict {
    <#
    .SYNOPSIS
        Explains, per contested name, which implementation currently answers and why.

    .DESCRIPTION
        `grep` can mean GNU grep or the profile's Get-ContentMatching. PowerShell resolves an
        alias before an application, so the profile wins unless PreferNativeTools removed its
        alias at load. This prints the current outcome and the two ways to change it.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes to the host.

    .EXAMPLE
        Show-CoreutilsConflict
        Lists every contested name and what it resolves to.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('coreutils-conflicts')]
    [OutputType([void])]
    param()

    $installation = Get-CoreutilsInstallation
    if (-not $installation.Installed) {
        Write-Host 'Microsoft coreutils is not installed, so nothing is contested.' -ForegroundColor DarkGray
        return
    }

    $contested = @(Get-CoreutilsUtility -ContestedOnly)

    if (-not $contested.Count) {
        Write-Host 'coreutils is installed and nothing is contested.' -ForegroundColor Green
        return
    }

    Write-Host ''
    Write-Host 'Names claimed by both coreutils and this profile' -ForegroundColor Cyan
    Write-Host '------------------------------------------------' -ForegroundColor DarkGray

    foreach ($utility in $contested) {
        $winner = if ($utility.Resolves -eq 'coreutils') { 'coreutils' } else { $utility.Resolves }
        Write-Host ("  {0,-10} -> {1}" -f $utility.Name, $winner)
    }

    Write-Host ''
    Write-Host 'To change the outcome:' -ForegroundColor DarkGray
    Write-Host '  PreferNativeTools = $true  in profile.config.psd1   coreutils wins (current default)'
    Write-Host '  PreferNativeTools = $false                          the profile wins'
    Write-Host '  Disable-CoreutilsUtility <name>                     take the name from coreutils entirely'
    Write-Host ''
}
