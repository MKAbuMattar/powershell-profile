#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when two commands would silently overwrite each other.

.DESCRIPTION
    PowerShell function names are case-insensitive. zsh alias names are not. Porting oh-my-zsh
    conventions directly therefore produces pairs that collapse onto one another, and the second
    definition wins with no warning:

        function gcb { git checkout -b ... }    # lost
        function gcB { git checkout -B ... }    # wins

    That one mattered: `gcb feature` silently reset an existing branch instead of creating one.

    Two collisions are checked:

    Within a module   two functions whose names differ only by case. One is unreachable.
    Across modules    two modules exporting the same function name. Which one you get depends on
                      import order, which is not something the user chose.

    Names in -Allow are known and accepted.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER Allow
    Function names that are legitimately defined more than once across modules.

.EXAMPLE
    ./Tools/Test-Duplicate.ps1
    Reports every collision and exits non-zero if any exist.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path,

    [string[]]$Allow = @()
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1, so the repository
# root is resolved here instead.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$problems = 0
$acrossModules = @{}

foreach ($file in Get-ChildItem -LiteralPath $Path -Recurse -File |
    Where-Object { $_.Extension -eq '.psm1' } |
    Where-Object { $_.FullName -notmatch '[\\/](\.git|Tools)[\\/]' }) {

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
    if ($errors) { continue }

    $relative = $file.FullName.Substring($Path.Length).TrimStart('\', '/')
    $module = $file.BaseName

    # Case-insensitive, matching how PowerShell itself resolves names.
    $seen = @{}

    foreach ($function in $ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] },
            $true)) {

        $name = $function.Name

        if ($seen.ContainsKey($name)) {
            $problems++
            Write-Host ("FAIL {0}" -f $relative) -ForegroundColor Red
            Write-Host ("     '{0}' is defined twice, at lines {1} and {2}. The first is unreachable." -f `
                    $name, $seen[$name], $function.Extent.StartLineNumber)
            Write-Host "     PowerShell function names are case-insensitive; rename one of them."
        }
        else {
            $seen[$name] = $function.Extent.StartLineNumber
        }

        if (-not $acrossModules.ContainsKey($name)) { $acrossModules[$name] = [System.Collections.Generic.List[string]]::new() }
        if (-not $acrossModules[$name].Contains($module)) { $acrossModules[$name].Add($module) }
    }
}

foreach ($name in $acrossModules.Keys | Sort-Object) {
    if ($acrossModules[$name].Count -le 1) { continue }
    if ($name -in $Allow) { continue }

    $problems++
    Write-Host ("FAIL {0}" -f $name) -ForegroundColor Red
    Write-Host ("     defined in {0}. Import order decides which one wins." -f ($acrossModules[$name] -join ', '))
}

Write-Host ""
if ($problems -gt 0) {
    Write-Host ("{0} collision(s) found." -f $problems)
    exit 1
}

Write-Host "No command would be silently overwritten." -ForegroundColor Green
exit 0
