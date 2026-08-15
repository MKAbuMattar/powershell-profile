#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when a committed manifest disagrees with what Update-Manifest.ps1 would generate.

.DESCRIPTION
    Export lists are generated from module source, not maintained by hand. This check is the
    enforcement half of that: it runs the same derivation as Tools/Update-Manifest.ps1 and
    reports any manifest whose committed lists differ.

    Because both halves call Get-ModuleExport, "generated" and "checked" cannot drift apart.
    A failure here means someone added or renamed a function without running the generator.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Manifest.ps1
    Reports stale manifests and exits non-zero if any exist.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path = (Split-Path -Parent $PSScriptRoot)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-ModuleExport.ps1')

$policy = Import-PowerShellDataFile -LiteralPath (Join-Path $PSScriptRoot 'ExportPolicy.psd1')

function Compare-NameList {
    <#
    .SYNOPSIS
        Describes how a committed list differs from the generated one, or $null if identical.
    #>
    param(
        [string]$Label,
        [string[]]$Committed,
        [string[]]$Generated
    )

    $committedSet = @($Committed | Where-Object { $_ })
    $generatedSet = @($Generated | Where-Object { $_ })

    if (($committedSet -join '|') -eq ($generatedSet -join '|')) { return $null }

    $extra = @($committedSet | Where-Object { $_ -notin $generatedSet })
    $absent = @($generatedSet | Where-Object { $_ -notin $committedSet })

    $parts = @()
    if ($extra.Count) { $parts += "{0} exported but not defined: {1}" -f $extra.Count, ($extra -join ', ') }
    if ($absent.Count) { $parts += "{0} defined but not exported: {1}" -f $absent.Count, ($absent -join ', ') }
    if (-not $parts.Count) { $parts += 'same names, different order' }

    return "$Label - " + ($parts -join '; ')
}

$stale = 0

foreach ($manifest in Get-ChildItem -LiteralPath $Path -Recurse -File -Filter '*.psd1' |
    Where-Object { $_.FullName -notmatch '[\\/](\.git|Tools)[\\/]' }) {

    $module = Join-Path $manifest.DirectoryName ($manifest.BaseName + '.psm1')
    if (-not (Test-Path -LiteralPath $module)) { continue }

    $relative = $manifest.FullName.Substring($Path.Length).TrimStart('\', '/')

    try {
        $data = Import-PowerShellDataFile -LiteralPath $manifest.FullName
    }
    catch {
        $stale++
        Write-Host "FAIL $relative" -ForegroundColor Red
        Write-Host "     manifest is not valid PowerShell data: $($_.Exception.Message)"
        continue
    }

    # Aggregators re-export whatever their children exported; a static list would be wrong.
    if (@($data.FunctionsToExport) -contains '*') { continue }

    $exports = Get-ModuleExport -ModulePath $module -Policy $policy
    if ($exports.ParseErrors.Count) { continue }

    $findings = @(@(
            Compare-NameList -Label 'FunctionsToExport' -Committed $data.FunctionsToExport -Generated $exports.Functions
            Compare-NameList -Label 'AliasesToExport' -Committed $data.AliasesToExport -Generated $exports.Aliases
        ) | Where-Object { $_ })

    if ($findings.Count) {
        $stale++
        Write-Host "FAIL $relative" -ForegroundColor Red
        foreach ($finding in $findings) { Write-Host "     $finding" }
    }
}

Write-Host ""
if ($stale -gt 0) {
    Write-Host ("{0} manifest(s) out of date. Run ./Tools/Update-Manifest.ps1 to regenerate." -f $stale)
    exit 1
}

Write-Host "Every manifest matches its module." -ForegroundColor Green
exit 0
