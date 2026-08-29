#Requires -Version 5.1
<#
.SYNOPSIS
    Stamps the version from the VERSION file into every file that carries one.

.DESCRIPTION
    Run this after editing VERSION. It rewrites the header comment, the ModuleVersion key in each
    manifest, and the $script:ProfileVersion constant in the loader, then reports what changed.

    Tools/Test-Version.ps1 is the enforcement half and runs the same derivation, so a file this
    script would rewrite is a file that check fails on.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER Version
    Write this version to VERSION first, then stamp it. Omit to stamp what VERSION already says.

.EXAMPLE
    ./Tools/Update-Version.ps1
    Stamps the current VERSION into every file and reports the count.

.EXAMPLE
    ./Tools/Update-Version.ps1 -Version 5.2.0
    Bumps VERSION to 5.2.0 and stamps it everywhere.

.EXAMPLE
    ./Tools/Update-Version.ps1 -WhatIf
    Lists the files that have drifted without writing.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path,

    [Parameter(Position = 1)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1, so the repository
# root is resolved here instead.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }
$Path = (Resolve-Path -LiteralPath $Path).Path

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-VersionStamp.ps1')

if ($Version) {
    $versionFile = Join-Path $Path 'VERSION'
    if ($PSCmdlet.ShouldProcess('VERSION', "Set to $Version")) {
        Set-Content -LiteralPath $versionFile -Value $Version -Encoding UTF8
    }
}

$target = Get-ProfileVersionFile -Path $Path
Write-Host "Stamping $target from VERSION."
Write-Host ""

$changed = 0

foreach ($stamp in Get-VersionStamp -Path $Path) {
    $changed++
    Write-Host ("  update {0}" -f $stamp.Relative)

    if ($PSCmdlet.ShouldProcess($stamp.Relative, "Stamp version $target")) {
        Set-Content -LiteralPath $stamp.Full -Value $stamp.Updated -NoNewline -Encoding UTF8
    }
}

Write-Host ""
Write-Host ("{0} file(s) stamped." -f $changed)
exit 0
