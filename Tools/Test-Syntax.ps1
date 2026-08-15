#Requires -Version 5.1
<#
.SYNOPSIS
    Parses every PowerShell file in the repository and fails on any syntax error.

.DESCRIPTION
    The profile loader imports modules with -ErrorAction SilentlyContinue, which means a module
    that fails to parse disappears without a warning. This check is the safety net: it parses
    every .ps1/.psm1/.psd1 in the repository with the PowerShell parser and reports every error
    with its file, line, and message.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Syntax.ps1
    Parses the whole repository and exits non-zero if anything fails to parse.

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

# Filter on Extension rather than -Include: with -LiteralPath and no wildcard in the path,
# Windows PowerShell 5.1 ignores -Include and returns every file, so this script tried to parse
# LICENSE and README.md as PowerShell and failed the 5.1 CI job.
$files = Get-ChildItem -LiteralPath $Path -Recurse -File |
    Where-Object { $_.Extension -in '.ps1', '.psm1', '.psd1' } |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }

$failed = 0

foreach ($file in $files) {
    $tokens = $null
    $errors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)

    if ($errors) {
        $failed++
        $relative = $file.FullName.Substring($Path.Length).TrimStart('\', '/')
        Write-Host "FAIL $relative" -ForegroundColor Red
        foreach ($parseError in $errors) {
            Write-Host ("     line {0}: {1}" -f $parseError.Extent.StartLineNumber, $parseError.Message)
        }
    }
}

Write-Host ""
Write-Host ("Parsed {0} files, {1} failed." -f $files.Count, $failed)

if ($failed -gt 0) {
    exit 1
}

Write-Host "All files parse cleanly." -ForegroundColor Green
exit 0
