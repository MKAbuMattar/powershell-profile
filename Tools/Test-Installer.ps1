#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when the built installer is stale or does not parse.

.DESCRIPTION
    The enforcement half of Tools/Build-Installer.ps1. Both call Format-InstallerScript, so built
    and checked cannot drift apart.

    A failure means someone changed Module/Setup without rebuilding. Fix it with:

        ./Tools/Build-Installer.ps1

    The parse check matters more than the staleness check. The built file is what a person runs
    before they have anything installed, and a syntax error in it is the worst possible first
    impression of the profile.

.PARAMETER Path
    Repository root. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Installer.ps1
    Reports a stale or broken installer and exits non-zero.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }
$Path = (Resolve-Path -LiteralPath $Path).Path

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-InstallerSource.ps1')

$target = Join-Path $Path 'build/profileutil.ps1'
$expected = Format-InstallerScript -Path $Path

if (-not (Test-Path -LiteralPath $target)) {
    Write-Host "build/profileutil.ps1 has not been built. Run ./Tools/Build-Installer.ps1." -ForegroundColor Red
    exit 1
}

$actual = (Get-Content -LiteralPath $target -Raw) -replace "`r`n", "`n"

if ($actual -ne $expected) {
    Write-Host "FAIL build/profileutil.ps1" -ForegroundColor Red
    Write-Host "     does not match Module/Setup. Run ./Tools/Build-Installer.ps1."
    exit 1
}

$errors = $null
$null = [System.Management.Automation.Language.Parser]::ParseInput($actual, [ref]$null, [ref]$errors)

if ($errors) {
    Write-Host "FAIL build/profileutil.ps1" -ForegroundColor Red
    foreach ($item in $errors) {
        Write-Host ("     line {0}: {1}" -f $item.Extent.StartLineNumber, $item.Message)
    }
    exit 1
}

# The built file carries no dot-source of $PSScriptRoot: every source is already inlined, and one
# of those lines would throw on a machine where Module/Setup does not exist yet, which is every
# machine this runs on.
if ($actual -match '(?m)^\s*\.\s+\(Join-Path \$PSScriptRoot') {
    Write-Host "FAIL build/profileutil.ps1" -ForegroundColor Red
    Write-Host "     still dot-sources a path that will not exist when it runs."
    exit 1
}

$size = [math]::Round($actual.Length / 1KB, 1)
Write-Host ("build/profileutil.ps1 is current and parses ({0} KB)." -f $size) -ForegroundColor Green
exit 0
