#Requires -Version 5.1
<#
.SYNOPSIS
    Opens a shell running this checkout's profile, without installing anything.

.DESCRIPTION
    Launches a new PowerShell session that loads the profile from this repository instead of the
    one in your Documents folder. Nothing is copied, symlinked or overwritten: the installed
    profile at $PROFILE is untouched, and closing the window ends the experiment.

    Use it to try a branch, or to see what a change to profile.config.psd1 actually does, before
    committing to it.

    Two differences you are likely to notice against an older installed profile:

      - grep, head, tail, touch and sed go back to the coreutils binaries, because
        PreferNativeTools is on.
      - Plugins whose tool is not installed do not load at all. Measure-ProfileLoad -All lists them.

.PARAMETER NoExit
    Keep the shell open after loading. On by default; -NoExit:$false loads and exits, which is
    what you want for timing.

.PARAMETER Measure
    Load the profile, print the load report and timing, then exit.

.EXAMPLE
    ./Tools/Start-TestShell.ps1
    Opens an interactive shell running this checkout's profile.

.EXAMPLE
    ./Tools/Start-TestShell.ps1 -Measure
    Prints what loaded and how long it took, then exits.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([void])]
param(
    [switch]$NoExit = $true,
    [switch]$Measure
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$profileScript = Join-Path $root 'Microsoft.PowerShell_profile.ps1'

if (-not (Test-Path -LiteralPath $profileScript)) {
    Write-Error "No profile at $profileScript."
    exit 1
}

$host_ = (Get-Process -Id $PID).Path
if (-not $host_) { $host_ = 'pwsh' }

Write-Host ""
Write-Host "Loading the profile from this checkout:" -ForegroundColor Cyan
Write-Host "  $profileScript"
Write-Host "Your installed profile is not touched:" -ForegroundColor Cyan
Write-Host "  $PROFILE"
Write-Host ""

if ($Measure) {
    $command = @"
`$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
. '$profileScript'
`$stopwatch.Stop()
Write-Host ''
Write-Host ("Profile loaded in {0:N0} ms." -f `$stopwatch.Elapsed.TotalMilliseconds) -ForegroundColor Green
Measure-ProfileLoad -All | Format-Table -AutoSize
Test-ProfileAliasContention | Format-Table -AutoSize
"@

    & $host_ -NoProfile -NoLogo -Command $command
    return
}

$command = @"
. '$profileScript'
Write-Host ''
Write-Host 'Test shell: running the profile from $root' -ForegroundColor Yellow
Write-Host 'Your installed profile is untouched. Close this window to end the test.' -ForegroundColor DarkGray
Write-Host 'Try: Measure-ProfileLoad -All   Show-ProfileHelp   Test-ProfileAliasContention' -ForegroundColor DarkGray
Write-Host ''
"@

$arguments = @('-NoProfile', '-NoLogo')
if ($NoExit) { $arguments += '-NoExit' }
$arguments += @('-Command', $command)

& $host_ @arguments
