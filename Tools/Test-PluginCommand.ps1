#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when a generated wrapper module is out of date.

.DESCRIPTION
    The enforcement half of Tools/Update-PluginCommand.ps1. Both call Format-PluginCommandModule
    from Tools/Format-PluginCommand.ps1, so "generated" and "checked" cannot drift apart.

    A failure means someone edited a <Plugin>.Generated.ps1 by hand, or changed commands.psd1
    without regenerating.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-PluginCommand.ps1
    Reports stale generated modules and exits non-zero if any exist.

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

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Format-PluginCommand.ps1')

$stale = 0

foreach ($table in Get-ChildItem -LiteralPath (Join-Path $Path 'Module') -Recurse -File -Filter 'commands.psd1') {

    $directory = $table.DirectoryName
    $plugin = Split-Path -Leaf $directory
    $target = Join-Path $directory "$plugin.Generated.ps1"

    $data = Import-PowerShellDataFile -LiteralPath $table.FullName
    $expected = Format-PluginCommandModule -Plugin $plugin -Tool $data.Tool -Command $data.Commands

    $actual = if (Test-Path -LiteralPath $target) {
        (Get-Content -LiteralPath $target -Raw) -replace "`r`n", "`n"
    }
    else {
        ''
    }

    if ($actual -eq $expected) { continue }

    $stale++
    $relative = $target.Substring($Path.Length).TrimStart('\', '/')
    Write-Host ("FAIL {0}" -f $relative) -ForegroundColor Red
    Write-Host '     does not match commands.psd1'
}

Write-Host ""
if ($stale -gt 0) {
    Write-Host ("{0} generated module(s) out of date. Run ./Tools/Update-PluginCommand.ps1." -f $stale)
    exit 1
}

Write-Host "Every generated wrapper module matches its table." -ForegroundColor Green
exit 0
