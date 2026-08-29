#---------------------------------------------------------------------------------------------------
# Try the installer against this checkout, without pushing or downloading anything.
#
# build/profileutil.ps1 downloads the repository, because someone running it from a URL has no
# checkout. You have one, so this loads the same built file and points the picker at it.
#
# Run it with no arguments:
#
#   ./try-local.ps1
#
# The first run installs into a throwaway directory, so a wrong click costs nothing while you are
# still learning what the buttons do. Every run after that installs for real, into your profile
# directory. Which one it picked is printed before the window opens.
#
# -Real and -Sandbox override that. -Terminal uses the console list instead of the window.
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
    [switch]$Real,

    [Parameter()]
    [switch]$Sandbox
)

$ErrorActionPreference = 'Stop'
$repository = $PSScriptRoot

if ($Real -and $Sandbox) {
    throw 'Pass -Real or -Sandbox, not both.'
}

# The built file with its final launcher call removed, so it defines everything and opens nothing.
# This is the same text a user would pipe into Invoke-Expression.
$built = Get-Content -LiteralPath (Join-Path $repository 'build/profileutil.ps1') -Raw
$built = $built -replace '(?m)^Invoke-ProfileInstaller.*$', ''
$built | Invoke-Expression

# Whether this machine has run the picker before. Kept beside the install receipt rather than in
# the repository, so a fresh clone on a machine that has used it does not start over in the
# sandbox, and a clone carried to a new machine does.
$marker = Join-Path (Split-Path -Parent (Get-ProfileSetupPath).Receipt) 'try-local.json'
$seen = Test-Path -LiteralPath $marker

$useReal = if ($Real) { $true }
elseif ($Sandbox) { $false }
else { $seen }

Write-Host ''

if ($useReal) {
    $target = @{}
    $reason = if ($Real) { 'you asked for it' } else { 'you have run this before' }

    Write-Host ("Installing for real, because {0}." -f $reason) -ForegroundColor Yellow
    Write-Host ('  ' + (Get-ProfileSetupPath).InstallPath)
    Write-Host '  Pass -Sandbox to try it against a throwaway directory instead.'
}
else {
    $scratch = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-try-" + [guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $scratch -Force
    $target = @{ InstallPath = $scratch; ReceiptPath = (Join-Path $scratch 'receipt.json') }

    $reason = if ($Sandbox) { 'you asked for it' } else { 'this is the first run on this machine' }

    Write-Host ("Sandbox run, because {0}." -f $reason) -ForegroundColor Cyan
    Write-Host "  $scratch"
    Write-Host '  Nothing outside that directory is touched. The next run installs for real.'
}

# Written after the mode is decided and before the window opens, so the next run knows this one
# happened even if the person closes the window without installing anything.
if (-not $seen) {
    $parent = Split-Path -Parent $marker
    if (-not (Test-Path -LiteralPath $parent)) { $null = New-Item -ItemType Directory -Path $parent -Force }

    [PSCustomObject]@{ FirstRun = (Get-Date).ToString('o'); Repository = $repository } |
        ConvertTo-Json | Set-Content -LiteralPath $marker -Encoding UTF8
}

Write-Host ''

if ($Terminal -or -not (Get-ProfileSetupWindowSupport).Supported) {
    Show-ProfileSetup -Repository $repository @target
}
else {
    Show-ProfileSetupWindow -Repository $repository @target
}
