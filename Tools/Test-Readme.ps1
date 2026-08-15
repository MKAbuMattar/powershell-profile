#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when a module README's command table is out of date.

.DESCRIPTION
    The enforcement half of Tools/Update-Readme.ps1. Both call Format-CommandTable and
    Merge-ReadmeContent from Tools/Get-ModuleCommand.ps1, so "generated" and "checked" cannot
    drift apart.

    This closes the last of the three documentation copies. The Kubectl README documented 45
    aliases that did not exist, and nothing noticed because nothing compared the prose to the code.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Readme.ps1
    Reports stale READMEs and exits non-zero if any exist.

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

. (Join-Path $PSScriptRoot 'Get-ModuleCommand.ps1')

$policy = Import-PowerShellDataFile -LiteralPath (Join-Path $PSScriptRoot 'ExportPolicy.psd1')
$stale = 0

foreach ($readme in Get-ChildItem -LiteralPath (Join-Path $Path 'Module') -Recurse -File -Filter 'README.md') {

    $module = Get-ChildItem -LiteralPath $readme.DirectoryName -File -Filter '*.psm1' | Select-Object -First 1
    if (-not $module) { continue }

    $relative = $readme.FullName.Substring($Path.Length).TrimStart('\', '/')

    $commands = Get-ModuleCommand -ModulePath $module.FullName -Policy $policy
    $table = Format-CommandTable -Command $commands -ModuleName $module.BaseName

    $original = (Get-Content -LiteralPath $readme.FullName -Raw) -replace "`r`n", "`n"
    $updated = Merge-ReadmeContent -Content $original -Table $table

    if ($updated -eq $original) { continue }

    $stale++
    Write-Host ("FAIL {0}" -f $relative) -ForegroundColor Red
    Write-Host '     command table does not match the module source'
}

Write-Host ""
if ($stale -gt 0) {
    Write-Host ("{0} README(s) out of date. Run ./Tools/Update-Readme.ps1 to regenerate." -f $stale)
    exit 1
}

Write-Host "Every README command table matches its module." -ForegroundColor Green
exit 0
