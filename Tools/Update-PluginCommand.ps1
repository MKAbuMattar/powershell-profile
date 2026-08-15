#Requires -Version 5.1
<#
.SYNOPSIS
    Generates wrapper functions from a plugin's commands.psd1.

.DESCRIPTION
    Turns each row of commands.psd1 into a function with comment-based help, writing them to
    <Plugin>.Generated.ps1. The hand-written module dot-sources that file.

    Generation is static and the result is committed. Generating the same functions at import time
    with Invoke-Expression was measured at 971 ms for 132 functions, against 48 ms to import the
    entire hand-written module -- twenty times worse. The maintainability win is in editing one
    row instead of 25 lines; there is no reason to pay for it at every shell start as well.

    Because the output is ordinary committed source, every existing check keeps working on it:
    Test-Syntax parses it, Test-Manifest reads its exports, Test-Duplicate catches collisions, and
    Test-Readme generates its documentation.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER WhatIf
    Report what would change without writing.

.EXAMPLE
    ./Tools/Update-PluginCommand.ps1
    Regenerates every plugin that has a commands.psd1.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
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

$changed = 0

foreach ($table in Get-ChildItem -LiteralPath (Join-Path $Path 'Module') -Recurse -File -Filter 'commands.psd1') {

    $directory = $table.DirectoryName
    $plugin = Split-Path -Leaf $directory
    $target = Join-Path $directory "$plugin.Generated.ps1"

    $data = Import-PowerShellDataFile -LiteralPath $table.FullName
    $generated = Format-PluginCommandModule -Plugin $plugin -Tool $data.Tool -Command $data.Commands

    $existing = if (Test-Path -LiteralPath $target) {
        (Get-Content -LiteralPath $target -Raw) -replace "`r`n", "`n"
    }
    else {
        ''
    }

    if ($existing -eq $generated) { continue }

    $changed++
    Write-Host ("  update {0,-46} {1,4} command(s)" -f "$plugin.Generated.ps1", @($data.Commands).Count)

    if ($PSCmdlet.ShouldProcess($target, 'Generate wrapper functions')) {
        Set-Content -LiteralPath $target -Value $generated -NoNewline -Encoding UTF8
    }
}

Write-Host ""
Write-Host ("{0} generated module(s) differ from their table." -f $changed)
exit 0
