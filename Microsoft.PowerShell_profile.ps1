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
#       Mohammad Abu Mattar to tailor and optimize the
#       PowerShell environment according to specific
#       preferences and requirements. It includes various
#       settings, module imports, utility functions, and
#       shortcuts to enhance productivity and streamline
#       workflow.
#
# Created: 2021-09-01
# Updated: 2024-07-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 3.0.0-beta
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Set the console encoding to UTF-8
#---------------------------------------------------------------------------------------------------
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#---------------------------------------------------------------------------------------------------
# Check if Terminal Icons module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if PowerShellGet module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PowerShellGet)) {
    Install-Module -Name PowerShellGet -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if CompletionPredictor module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name CompletionPredictor)) {
    Install-Module -Name CompletionPredictor -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if PSReadLine module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if Posh-Git module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Posh-Git)) {
    Install-Module -Name Posh-Git -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Load the modules
#---------------------------------------------------------------------------------------------------
Import-Module -Name Terminal-Icons
Import-Module -Name PowerShellGet
Import-Module -Name CompletionPredictor
Import-Module -Name PSReadLine
Import-Module -Name Posh-Git

#---------------------------------------------------------------------------------------------------
# Set the PSReadLine options and key handlers
#---------------------------------------------------------------------------------------------------
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadLineKeyHandler -Chord '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
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

#---------------------------------------------------------------------------------------------------
# Import the custom modules
#---------------------------------------------------------------------------------------------------
$EnvironmentModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Environment/Environment.psm1'
Import-Module $EnvironmentModulePath -Force -ErrorAction SilentlyContinue

$LoggingModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Logging/Logging.psm1'
Import-Module $LoggingModulePath -Force -ErrorAction SilentlyContinue

$StarshipModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Starship/Starship.psm1'
Import-Module $StarshipModulePath -Force -ErrorAction SilentlyContinue

$UpdateModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Update/Update.psm1'
Import-Module $UpdateModulePath -Force -ErrorAction SilentlyContinue

$UtilityModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Utility/Utility.psm1'
Import-Module $UtilityModulePath -Force -ErrorAction SilentlyContinue

#---------------------------------------------------------------------------------------------------
# Invoke Starship Transient Function
#---------------------------------------------------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-StarshipTransientFunction} -ErrorAction SilentlyContinue

#---------------------------------------------------------------------------------------------------
# Load Starship
#---------------------------------------------------------------------------------------------------
Invoke-Expression (&starship init powershell)

#---------------------------------------------------------------------------------------------------
# Set Chocolatey Profile
#---------------------------------------------------------------------------------------------------
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

#---------------------------------------------------------------------------------------------------
# Import Chocolatey Profile
#---------------------------------------------------------------------------------------------------
if (Test-Path $ChocolateyProfile) {
    Import-Module $ChocolateyProfile
}

#---------------------------------------------------------------------------------------------------
# Invoke the profile update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true) {
    Invoke-Command -ScriptBlock ${function:Update-LocalProfileModuleDirectory} -ErrorAction SilentlyContinue
}

#---------------------------------------------------------------------------------------------------
# Invoke the profile update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true) {
    Invoke-Command -ScriptBlock ${function:Update-Profile} -ErrorAction SilentlyContinue
}

#---------------------------------------------------------------------------------------------------
# Invoke the PowerShell update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdatePowerShell -eq $true) {
    Invoke-Command -ScriptBlock ${function:Update-PowerShell} -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Editor Configuration
#------------------------------------------------------
$EDITOR = if (Test-CommandExists nvim) { 'vim' }
elseif (Test-CommandExists vi) { 'vi' }
elseif (Test-CommandExists code) { 'code' }
else { 'notepad' }

#------------------------------------------------------
# Set the editor alias
#------------------------------------------------------
Set-Alias -Name vim -Value $EDITOR
