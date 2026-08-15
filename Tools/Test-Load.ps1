#Requires -Version 5.1
<#
.SYNOPSIS
    Imports every module in the repository and fails on any that does not load.

.DESCRIPTION
    Test-Syntax.ps1 catches files that do not parse. This check goes further and actually imports
    each leaf module, so a manifest pointing at a missing RootModule, a bad GUID, or a runtime
    error at import time is caught too.

    Every module in the repository is tested, not just the ones enabled in profile.config.psd1,
    so a module that is disabled by default cannot rot unnoticed.

    Imports are deliberately not silenced. The whole point is to see what breaks.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Load.ps1
    Imports every module and exits non-zero if any fails.

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

$moduleRoot = Join-Path $Path 'Module'

# Git.psd1 imports Core and Utility itself, so testing it too would report the same failure twice.
$aggregators = @('Git.psd1')

$manifests = Get-ChildItem -LiteralPath $moduleRoot -Recurse -File -Filter '*.psd1' |
    Where-Object { $_.Name -notin $aggregators } |
    Sort-Object FullName

$failed = 0

foreach ($manifest in $manifests) {
    $relative = $manifest.FullName.Substring($Path.Length).TrimStart('\', '/')

    try {
        Import-Module -Name $manifest.FullName -Force -ErrorAction Stop
        $module = Get-Module -Name $manifest.BaseName
        Write-Host ("  ok   {0,-52} {1,3} fn  {2,3} alias" -f $relative, $module.ExportedFunctions.Count, $module.ExportedAliases.Count)
    }
    catch {
        $failed++
        Write-Host ("  FAIL {0}" -f $relative) -ForegroundColor Red
        Write-Host ("       {0}" -f $_.Exception.Message.Split([Environment]::NewLine)[0])
    }
}

Write-Host ""
Write-Host ("Imported {0} modules, {1} failed." -f $manifests.Count, $failed)

if ($failed -gt 0) {
    exit 1
}

Write-Host "Every module loads." -ForegroundColor Green
exit 0
