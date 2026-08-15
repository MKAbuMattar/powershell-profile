#Requires -Version 5.1
<#
.SYNOPSIS
    Rewrites FunctionsToExport and AliasesToExport in every manifest from the module source.

.DESCRIPTION
    Manifests used to be maintained by hand, which is how Kubectl came to promise 91 functions
    nobody had written. This regenerates both export lists from the abstract syntax tree of each
    .psm1, filtered through Tools/ExportPolicy.psd1.

    Only the two export arrays are touched. Every other key, comment and blank line in the
    manifest is preserved byte for byte, because the value's exact source extent is spliced
    rather than the file being re-serialised.

    Aggregator manifests that export '*' are left alone: they re-export whatever their children
    exported, and enumerating that statically would be wrong the moment a child changes.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER WhatIf
    Report what would change without writing.

.EXAMPLE
    ./Tools/Update-Manifest.ps1
    Regenerates every manifest and reports which ones changed.

.EXAMPLE
    ./Tools/Update-Manifest.ps1 -WhatIf
    Shows the drift without touching the working tree.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path = (Split-Path -Parent $PSScriptRoot)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-ModuleExport.ps1')

$policy = Import-PowerShellDataFile -LiteralPath (Join-Path $PSScriptRoot 'ExportPolicy.psd1')

function Format-ExportArray {
    <#
    .SYNOPSIS
        Renders a name list as a psd1 array literal indented to match the key it belongs to.
    #>
    param(
        [string[]]$Name,
        [int]$Indent
    )

    if (-not $Name -or $Name.Count -eq 0) { return '@()' }

    $pad = ' ' * ($Indent + 4)
    $lines = $Name | ForEach-Object { "$pad'$_'" }

    return "@(" + [Environment]::NewLine + ($lines -join ("," + [Environment]::NewLine)) + [Environment]::NewLine + (' ' * $Indent) + ")"
}

function Set-ManifestKey {
    <#
    .SYNOPSIS
        Replaces the value of a top-level manifest key, preserving the rest of the file.

    .OUTPUTS
        The updated file content, or the original if the key was absent or exports '*'.
    #>
    param(
        [string]$Content,
        [string]$Key,
        [string[]]$Value
    )

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Content, [ref]$tokens, [ref]$errors)
    if ($errors) { return $Content }

    $hashtable = $ast.Find(
        { param($node) $node -is [System.Management.Automation.Language.HashtableAst] },
        $false)
    if (-not $hashtable) { return $Content }

    foreach ($pair in $hashtable.KeyValuePairs) {
        if ($pair.Item1.Extent.Text.Trim("'", '"') -ne $Key) { continue }

        $existing = $pair.Item2.Extent.Text
        if ($existing -match "@\(\s*'\*'\s*\)") { return $Content }

        $indent = $pair.Item1.Extent.StartColumnNumber - 1
        $replacement = Format-ExportArray -Name $Value -Indent $indent

        $start = $pair.Item2.Extent.StartOffset
        $end = $pair.Item2.Extent.EndOffset

        return $Content.Substring(0, $start) + $replacement + $Content.Substring($end)
    }

    return $Content
}

$changed = 0
$skippedTotal = @{}

foreach ($manifest in Get-ChildItem -LiteralPath $Path -Recurse -File -Filter '*.psd1' |
    Where-Object { $_.FullName -notmatch '[\\/](\.git|Tools)[\\/]' }) {

    $module = Join-Path $manifest.DirectoryName ($manifest.BaseName + '.psm1')
    if (-not (Test-Path -LiteralPath $module)) { continue }

    $relative = $manifest.FullName.Substring($Path.Length).TrimStart('\', '/')
    $exports = Get-ModuleExport -ModulePath $module -Policy $policy

    if ($exports.ParseErrors.Count) {
        Write-Host ("  skip {0} (does not parse)" -f $relative) -ForegroundColor Yellow
        continue
    }

    $original = Get-Content -LiteralPath $manifest.FullName -Raw
    $updated = Set-ManifestKey -Content $original -Key 'FunctionsToExport' -Value $exports.Functions
    $updated = Set-ManifestKey -Content $updated -Key 'AliasesToExport' -Value $exports.Aliases

    foreach ($name in $exports.Skipped) { $skippedTotal[$name] = $relative }

    if ($updated -eq $original) { continue }

    $changed++
    Write-Host ("  update {0,-52} {1,3} fn  {2,3} alias" -f $relative, $exports.Functions.Count, $exports.Aliases.Count)

    if ($PSCmdlet.ShouldProcess($relative, 'Rewrite export lists')) {
        Set-Content -LiteralPath $manifest.FullName -Value $updated -NoNewline -Encoding UTF8
    }
}

if ($skippedTotal.Count) {
    Write-Host ""
    Write-Host "Reserved aliases withheld (a real executable owns the name):" -ForegroundColor Yellow
    foreach ($name in $skippedTotal.Keys | Sort-Object) {
        Write-Host ("  {0,-14} declared in {1}" -f $name, $skippedTotal[$name])
    }
}

Write-Host ""
Write-Host ("{0} manifest(s) updated." -f $changed)
exit 0
