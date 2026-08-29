#---------------------------------------------------------------------------------------------------
# Runs the built installer against this checkout instead of downloading one.
#
# build/profileutil.ps1 is the real thing and holds all of the behaviour, including which install
# mode a run picks. This exists only because that file downloads the repository, and you have one
# already. It loads the same built text and points the picker at your checkout.
#
#   ./try-local.ps1              first run sandboxes, every run after installs for real
#   ./try-local.ps1 -Sandbox     a throwaway directory, whatever the marker says
#   ./try-local.ps1 -Real        your profile directory, whatever the marker says
#   ./try-local.ps1 -Terminal    the console list instead of the window
#
# The parameters are deliberately not named -Console or -Branch. The built file starts with its own
# param($Console, $Branch, $Real, $Sandbox), and Invoke-Expression declares those in the calling
# scope; a local of the same name here is already compiled and PowerShell refuses to overwrite it.
#---------------------------------------------------------------------------------------------------
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Terminal,

    [Parameter()]
    [switch]$UseReal,

    [Parameter()]
    [switch]$UseSandbox
)

$ErrorActionPreference = 'Stop'
$repository = $PSScriptRoot

# The built file with its final launcher call removed, so it defines everything and opens nothing.
# This is the same text a user would pipe into Invoke-Expression.
$built = Get-Content -LiteralPath (Join-Path $repository 'build/profileutil.ps1') -Raw
$built = $built -replace '(?m)^Invoke-ProfileInstaller.*$', ''
$built | Invoke-Expression

# Every decision below comes from the installer, not from here. This file adds one thing: the
# repository is the checkout it sits in rather than a download.
$mode = Get-ProfileSetupMode -Real:$UseReal -Sandbox:$UseSandbox
Write-ProfileSetupMode -Mode $mode

$target = @{}
if ($mode.InstallPath) { $target['InstallPath'] = $mode.InstallPath }
if ($mode.ReceiptPath) { $target['ReceiptPath'] = $mode.ReceiptPath }

Set-ProfileSetupSeen -Repository $repository -Confirm:$false

if ($Terminal -or -not (Get-ProfileSetupWindowSupport).Supported) {
    Show-ProfileSetup -Repository $repository @target
}
else {
    Show-ProfileSetupWindow -Repository $repository @target
}
