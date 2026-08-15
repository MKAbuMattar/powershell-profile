#Requires -Version 5.1
<#
.SYNOPSIS
    Regenerates the command reference in each module README from comment-based help.

.DESCRIPTION
    Writes a command table into every module README between two markers:

        <!-- BEGIN GENERATED COMMANDS -->
        <!-- END GENERATED COMMANDS -->

    Only the text between the markers is replaced, so hand-written introductions, notes and
    examples around it survive untouched. A README with no markers gets them appended once.

    This is the last of the three copies of the documentation to be brought under control.
    Docs.psm1 was deleted and Show-ProfileHelp now reads the live session, but these README files
    were still typed by hand -- which is how the Kubectl README came to document 45 aliases that
    did not exist.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER WhatIf
    Report what would change without writing.

.EXAMPLE
    ./Tools/Update-Readme.ps1
    Regenerates every module README's command table.

.EXAMPLE
    ./Tools/Update-Readme.ps1 -WhatIf
    Shows which READMEs are out of date.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
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
$changed = 0

foreach ($readme in Get-ChildItem -LiteralPath (Join-Path $Path 'Module') -Recurse -File -Filter 'README.md') {

    # A README documents the module sitting beside it.
    $module = Get-ChildItem -LiteralPath $readme.DirectoryName -File -Filter '*.psm1' | Select-Object -First 1
    if (-not $module) { continue }

    $relative = $readme.FullName.Substring($Path.Length).TrimStart('\', '/')

    $commands = Get-ModuleCommand -ModulePath $module.FullName -Policy $policy
    $table = Format-CommandTable -Command $commands -ModuleName $module.BaseName

    $original = (Get-Content -LiteralPath $readme.FullName -Raw) -replace "`r`n", "`n"
    $updated = Merge-ReadmeContent -Content $original -Table $table

    if ($updated -eq $original) { continue }

    $changed++
    Write-Host ("  update {0,-56} {1,3} command(s)" -f $relative, @($commands).Count)

    if ($PSCmdlet.ShouldProcess($relative, 'Regenerate command table')) {
        Set-Content -LiteralPath $readme.FullName -Value $updated -NoNewline -Encoding UTF8
    }
}

Write-Host ""
Write-Host ("{0} README(s) differ from their module." -f $changed)
exit 0
