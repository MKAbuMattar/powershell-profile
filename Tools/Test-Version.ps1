#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when a committed file disagrees with the VERSION file.

.DESCRIPTION
    Every module in this repository ships as part of one profile and carries one version. This is
    the enforcement half of that: it runs the same derivation as Tools/Update-Version.ps1 and
    reports any file whose version text has drifted.

    A failure here means someone edited VERSION without running the stamper, or hand-edited a
    ModuleVersion. Fix it with:

        ./Tools/Update-Version.ps1

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Version.ps1
    Reports drifted files and exits non-zero if any exist.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1, so the repository
# root is resolved here instead.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }
$Path = (Resolve-Path -LiteralPath $Path).Path

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-VersionStamp.ps1')

$target = Get-ProfileVersionFile -Path $Path
Write-Host "VERSION declares $target."
Write-Host ""

$drifted = @(Get-VersionStamp -Path $Path)

if (-not $drifted.Count) {
    Write-Host "Every version matches." -ForegroundColor Green
    exit 0
}

Write-Host ("{0} file(s) disagree with VERSION:" -f $drifted.Count) -ForegroundColor Red
foreach ($stamp in $drifted) {
    $found = [regex]::Matches($stamp.Current, "(?m)^\s*(?:#\s*Version:\s*|ModuleVersion\s*=\s*'|\`$script:ProfileVersion\s*=\s*')(\d+\.\d+\.\d+)") |
        ForEach-Object { $_.Groups[1].Value } |
        Sort-Object -Unique

    Write-Host ("  {0,-58} says {1}" -f $stamp.Relative, ($found -join ', '))
}

Write-Host ""
Write-Host "Fix with: ./Tools/Update-Version.ps1"
exit 1
