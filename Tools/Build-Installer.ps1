#Requires -Version 5.1
<#
.SYNOPSIS
    Compiles the Setup module into one script that runs from a bare shell.

.DESCRIPTION
    winutil is one file behind a short URL, and the reason is that the person running it has
    nothing installed yet. The same applies here: the picker lives in Module/Setup, and Module/Setup
    is one of the things the installer installs, so it cannot be imported before it exists.

    This concatenates the module's sources into profileutil.ps1, appends a launcher, and writes it
    where the release workflow can attach it. The result needs no clone and no module: piping it
    into Invoke-Expression opens the picker.

    Two things the launcher has to handle, both because Invoke-Expression is the entry point:

      $PSScriptRoot and $PSCommandPath are empty, so the repository the file units copy from is
      downloaded rather than assumed to be beside the script.

      #Requires is not enforced, so the version check is a plain comparison that runs.

    Tools/Test-Installer.ps1 is the enforcement half: it fails when the built file is stale or
    does not parse.

.PARAMETER Path
    Repository root. Defaults to the parent of the directory holding this script.

.PARAMETER OutputPath
    Where to write the built script. Defaults to build/profileutil.ps1 under the repository root.

.EXAMPLE
    ./Tools/Build-Installer.ps1
    Writes build/profileutil.ps1.

.EXAMPLE
    ./Tools/Build-Installer.ps1 -WhatIf
    Reports what it would write.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path,

    [Parameter(Position = 1)]
    [string]$OutputPath
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1, so the repository
# root is resolved here instead.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }
$Path = (Resolve-Path -LiteralPath $Path).Path
if (-not $OutputPath) { $OutputPath = Join-Path $Path 'build/profileutil.ps1' }

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'Get-InstallerSource.ps1')

$built = Format-InstallerScript -Path $Path

$existing = if (Test-Path -LiteralPath $OutputPath) {
    (Get-Content -LiteralPath $OutputPath -Raw) -replace "`r`n", "`n"
}
else {
    ''
}

if ($existing -eq $built) {
    Write-Host "build/profileutil.ps1 is already current."
    exit 0
}

$parent = Split-Path -Parent $OutputPath
if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    if ($PSCmdlet.ShouldProcess($parent, 'Create build directory')) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }
}

if ($PSCmdlet.ShouldProcess($OutputPath, 'Write the installer')) {
    Set-Content -LiteralPath $OutputPath -Value $built -NoNewline -Encoding UTF8
}

$size = [math]::Round($built.Length / 1KB, 1)
Write-Host ("Wrote {0} ({1} KB)." -f $OutputPath, $size)
exit 0
