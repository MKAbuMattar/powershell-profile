#Requires -Version 5.1
<#
.SYNOPSIS
    Runs PSScriptAnalyzer over the repository.

.DESCRIPTION
    Analyses every PowerShell file using PSScriptAnalyzerSettings.psd1 at the repository root.
    Errors fail the run. Warnings and information are printed as a summary so they stay visible
    without blocking a 1.5 MB codebase that predates the analyzer.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER FailOn
    Lowest severity that should fail the run. Defaults to Error.

.EXAMPLE
    ./Tools/Invoke-Analyzer.ps1
    Analyses the repository and exits non-zero if any Error-severity finding exists.

.EXAMPLE
    ./Tools/Invoke-Analyzer.ps1 -FailOn Warning
    Tightens the gate once the existing warnings have been worked through.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path,

    [ValidateSet('Error', 'Warning', 'Information')]
    [string]$FailOn = 'Error'
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1, so the repository
# root is resolved here instead.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Host "PSScriptAnalyzer is not installed. Install it with:" -ForegroundColor Yellow
    Write-Host "    Install-Module PSScriptAnalyzer -Scope CurrentUser"
    exit 1
}

Import-Module PSScriptAnalyzer

$settings = Join-Path $Path 'PSScriptAnalyzerSettings.psd1'

$results = @(Invoke-ScriptAnalyzer -Path $Path -Recurse -Settings $settings)

$order = @{ Error = 0; Warning = 1; Information = 2 }
$threshold = $order[$FailOn]

$blocking = @($results | Where-Object { $order[[string]$_.Severity] -le $threshold })

foreach ($group in $results | Group-Object Severity | Sort-Object { $order[$_.Name] }) {
    Write-Host ("{0,-12} {1}" -f $group.Name, $group.Count)
}

if ($blocking.Count) {
    Write-Host ""
    foreach ($finding in $blocking | Sort-Object ScriptName, Line) {
        $relative = $finding.ScriptPath
        if ($relative -and $relative.StartsWith($Path)) {
            $relative = $relative.Substring($Path.Length).TrimStart('\', '/')
        }
        Write-Host ("{0} [{1}] {2}:{3}" -f $finding.Severity, $finding.RuleName, $relative, $finding.Line) -ForegroundColor Red
        Write-Host ("     {0}" -f $finding.Message)
    }
    Write-Host ""
    Write-Host ("{0} finding(s) at or above {1}." -f $blocking.Count, $FailOn)
    exit 1
}

Write-Host ""
Write-Host ("No findings at or above {0}." -f $FailOn) -ForegroundColor Green
exit 0
