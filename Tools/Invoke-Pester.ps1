#Requires -Version 5.1
<#
.SYNOPSIS
    Runs the Pester suite in Tests/.

.DESCRIPTION
    Wraps Pester 5 configuration so CI and a local run behave identically.

.PARAMETER Path
    Repository root. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Invoke-Pester.ps1
    Runs every test and exits non-zero on failure.

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

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$pester = Get-Module -ListAvailable -Name Pester |
    Where-Object { $_.Version -ge [version]'5.0' } |
    Sort-Object Version -Descending |
    Select-Object -First 1

if (-not $pester) {
    Write-Host 'Pester 5 or later is not installed. Install it with:' -ForegroundColor Yellow
    Write-Host '    Install-Module Pester -MinimumVersion 5.0 -Scope CurrentUser'
    exit 1
}

Import-Module $pester

$configuration = New-PesterConfiguration
$configuration.Run.Path = Join-Path $Path 'Tests'
$configuration.Run.Exit = $false
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = 'Detailed'
$configuration.TestResult.Enabled = $false

$result = Invoke-Pester -Configuration $configuration

Write-Host ""
Write-Host ("{0} passed, {1} failed, {2} skipped." -f $result.PassedCount, $result.FailedCount, $result.SkippedCount)

if ($result.FailedCount -gt 0) { exit 1 }
exit 0
