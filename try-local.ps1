#---------------------------------------------------------------------------------------------------
# Try the installer without pushing anything.
#
# build/profileutil.ps1 downloads the repository, because someone running it from a URL has no
# checkout. You have one, so this loads the same built file and points the picker at it. Nothing is
# downloaded, and by default nothing outside a scratch directory is touched.
#
# Run it with:
#
#   ./try-local.ps1              the window
#   ./try-local.ps1 -Terminal    the console list instead
#   ./try-local.ps1 -Real        install into your actual profile directory, not a scratch one
#
# The parameters are deliberately not named -Console or -Branch. The built file starts with its own
# param($Console, $Branch), and Invoke-Expression declares those in the calling scope; a local of
# the same name here is already compiled and PowerShell refuses to overwrite it.
#---------------------------------------------------------------------------------------------------
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Terminal,

    [Parameter()]
    [switch]$Real
)

$ErrorActionPreference = 'Stop'
$repository = $PSScriptRoot

# The built file with its final launcher call removed, so it defines everything and opens nothing.
# This is the same text a user would pipe into Invoke-Expression.
$built = Get-Content -LiteralPath (Join-Path $repository 'build/profileutil.ps1') -Raw
$built = $built -replace '(?m)^Invoke-ProfileInstaller.*$', ''
$built | Invoke-Expression

if ($Real) {
    $target = @{}
    Write-Host ''
    Write-Host 'Installing into your real profile directory.' -ForegroundColor Yellow
    Write-Host ("  " + (Get-ProfileSetupPath).InstallPath)
}
else {
    # A scratch directory and a scratch receipt, so a wrong click costs nothing.
    $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-try-" + [guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $scratch -Force
    $target = @{ InstallPath = $scratch; ReceiptPath = (Join-Path $scratch 'receipt.json') }

    Write-Host ''
    Write-Host 'Sandbox run. Installing into:' -ForegroundColor Cyan
    Write-Host "  $scratch"
    Write-Host 'Pass -Real to use your actual profile directory instead.'
}

if ($Terminal -or -not (Get-ProfileSetupWindowSupport).Supported) {
    Show-ProfileSetup -Repository $repository @target
}
else {
    Show-ProfileSetupWindow -Repository $repository @target
}
