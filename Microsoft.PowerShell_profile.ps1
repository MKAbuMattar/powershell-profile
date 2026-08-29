#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This PowerShell profile script is crafted by
#       Mohammad Abu Mattar to enhance the PowerShell
#       experience and productivity.
#
#       What loads is decided by profile.config.psd1, not by this file.
#       Run `Measure-ProfileLoad` to see what the last startup cost.
#
# Created: 2021-09-01
# Updated: 2026-08-15
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Set the console encoding to UTF-8
#---------------------------------------------------------------------------------------------------
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#---------------------------------------------------------------------------------------------------
# Where this profile lives. When $PROFILE is a symlink into the repository, resolve through it so
# the Module tree and profile.config.psd1 are found in the repository rather than beside the link.
#---------------------------------------------------------------------------------------------------
$ProfileRoot = $PSScriptRoot

$ProfileItem = Get-Item -LiteralPath $PSCommandPath -ErrorAction SilentlyContinue
if ($ProfileItem -and $ProfileItem.LinkType -eq 'SymbolicLink' -and $ProfileItem.Target) {
    $LinkTarget = @($ProfileItem.Target)[0]
    if (Test-Path -LiteralPath $LinkTarget) {
        $ProfileRoot = Split-Path -Parent (Resolve-Path -LiteralPath $LinkTarget).Path
    }
}

#---------------------------------------------------------------------------------------------------
# Load the profile modules named in profile.config.psd1
#---------------------------------------------------------------------------------------------------
$LoaderManifest = Join-Path -Path $ProfileRoot -ChildPath 'Module/Loader/Loader.psd1'

if (Test-Path -LiteralPath $LoaderManifest) {
    Import-Module -Name $LoaderManifest -Global -Force -DisableNameChecking
    Import-ProfileModule -RepositoryRoot $ProfileRoot
}
else {
    Write-Warning "Profile loader not found at $LoaderManifest. Only built-in PowerShell commands are available."
}

#---------------------------------------------------------------------------------------------------
# PSReadLine options and key handlers
#
# Prediction needs a console that supports virtual terminal processing. Redirected and
# non-interactive hosts (CI, `pwsh -Command`, piped output) do not, and these calls throw there.
#---------------------------------------------------------------------------------------------------
if ((Get-Module -Name PSReadLine) -and -not [System.Console]::IsOutputRedirected -and $Host.Name -eq 'ConsoleHost') {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -Colors @{ 'Selection' = "`e[7m" }

    Set-PSReadLineKeyHandler -Chord '"', "'" `
        -BriefDescription SmartInsertQuote `
        -LongDescription 'Insert paired quotes if not already on a quote' `
        -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
            # Just move the cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        }
        else {
            # Insert matching quotes, move cursor to be in between the quotes
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
        }
    }
}

#---------------------------------------------------------------------------------------------------
# Starship prompt
#---------------------------------------------------------------------------------------------------
if (Get-Command -Name starship -CommandType Application -ErrorAction SilentlyContinue) {
    if (Get-Command -Name Invoke-StarshipTransientFunction -ErrorAction SilentlyContinue) {
        Invoke-StarshipTransientFunction
    }

    (& starship init powershell) -join "`n" | Invoke-Expression
}

#---------------------------------------------------------------------------------------------------
# Directory jumping
#
# zoxide replaces `cd` and installs a prompt hook, so it initialises after Starship rather than
# during module import.
#---------------------------------------------------------------------------------------------------
if (Get-Command -Name zoxide -CommandType Application -ErrorAction SilentlyContinue) {
    (& zoxide init --cmd cd powershell) -join "`n" | Invoke-Expression
}

#---------------------------------------------------------------------------------------------------
# Automatic updates
#
# Both default to off. Update-Profile preserves any third-party section in $PROFILE, so turning
# these on no longer risks the block that Microsoft coreutils injects.
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true -and (Get-Command -Name Update-Profile -ErrorAction SilentlyContinue)) {
    Update-Profile
}

if ($global:AutoUpdatePowerShell -eq $true -and (Get-Command -Name Update-PowerShell -ErrorAction SilentlyContinue)) {
    Update-PowerShell
}

#---------------------------------------------------------------------------------------------------
# Editor
#
# A foreach with break, not a Where-Object pipeline: Where-Object has no early exit, so the old
# version probed all seven editors even when the first one matched.
#---------------------------------------------------------------------------------------------------
$EDITOR = $env:EDITOR

if (-not $EDITOR) {
    foreach ($Candidate in 'nvim', 'pvim', 'vim', 'vi', 'code', 'notepad++', 'sublime_text') {
        if (Get-Command -Name $Candidate -ErrorAction SilentlyContinue) {
            $EDITOR = $Candidate
            break
        }
    }
}

if (-not $EDITOR) { $EDITOR = 'notepad' }

Set-Alias -Name vim -Value $EDITOR

#---------------------------------------------------------------------------------------------------
# Run FastFetch
#---------------------------------------------------------------------------------------------------
# if (Get-Command -Name fastfetch -CommandType Application -ErrorAction SilentlyContinue) {
#     Clear-Host
#     fastfetch
# }
