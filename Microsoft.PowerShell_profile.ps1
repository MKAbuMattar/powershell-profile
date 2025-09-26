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
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
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
$DirectoryModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Directory/Directory.psd1'
if (Test-Path $DirectoryModulePath) {
    Import-Module $DirectoryModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Directory module not found at: $DirectoryModulePath"
}

$DocsModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Docs/Docs.psd1'
if (Test-Path $DocsModulePath) {
    Import-Module $DocsModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Docs module not found at: $DocsModulePath"
}

$EnvironmentModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Environment/Environment.psd1'
if (Test-Path $EnvironmentModulePath) {
    Import-Module $EnvironmentModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Environment module not found at: $EnvironmentModulePath"
}

$PluginAWSModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Plugins/AWS/AWS.psd1'
if (Test-Path $PluginAWSModulePath) {
    Import-Module $PluginAWSModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Plugin-AWS module not found at: $PluginAWSModulePath"
}

$PluginDockerModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Plugins/Docker/Docker.psd1'
if (Test-Path $PluginDockerModulePath) {
    Import-Module $PluginDockerModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Plugin-Docker module not found at: $PluginDockerModulePath"
}

$PluginDockerComposeModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Plugins/DockerCompose/DockerCompose.psd1'
if (Test-Path $PluginDockerComposeModulePath) {
    Import-Module $PluginDockerComposeModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Plugin-DockerCompose module not found at: $PluginDockerComposeModulePath"
}

$PluginGitModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Plugins/Git/Git.psd1'
if (Test-Path $PluginGitModulePath) {
    Import-Module $PluginGitModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Plugin-Git module not found at: $PluginGitModulePath"
}

$PluginHelmModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Plugins/Helm/Helm.psd1'
if (Test-Path $PluginHelmModulePath) {
    Import-Module $PluginHelmModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Plugin-Helm module not found at: $PluginHelmModulePath"
}

$PluginKubectlModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Plugins/Kubectl/Kubectl.psd1'
if (Test-Path $PluginKubectlModulePath) {
    Import-Module $PluginKubectlModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Plugin-Kubectl module not found at: $PluginKubectlModulePath"
}

$LoggingModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Logging/Logging.psd1'
if (Test-Path $LoggingModulePath) {
    Import-Module $LoggingModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Logging module not found at: $LoggingModulePath"
}
Import-Module $LoggingModulePath -Force -ErrorAction SilentlyContinue

$NetworkModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Network/Network.psd1'
if (Test-Path $NetworkModulePath) {
    Import-Module $NetworkModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Network module not found at: $NetworkModulePath"
}

$ProcessModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Process/Process.psd1'
if (Test-Path $ProcessModulePath) {
    Import-Module $ProcessModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Process module not found at: $ProcessModulePath"
}

$StarshipModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Starship/Starship.psd1'
if (Test-Path $StarshipModulePath) {
    Import-Module $StarshipModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Starship module not found at: $StarshipModulePath"
}

$UpdateModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Update/Update.psd1'
if (Test-Path $UpdateModulePath) {
    Import-Module $UpdateModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Update module not found at: $UpdateModulePath"
}

$UtilityModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Utility/Utility.psd1'
if (Test-Path $UtilityModulePath) {
    Import-Module $UtilityModulePath -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "Utility module not found at: $UtilityModulePath"
}

#---------------------------------------------------------------------------------------------------
# Invoke Starship Transient Function
#---------------------------------------------------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-StarshipTransientFunction} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Load Starship
#---------------------------------------------------------------------------------------------------
Invoke-Expression (&starship init powershell)

#---------------------------------------------------------------------------------------------------
# Set Chocolatey Profile
#---------------------------------------------------------------------------------------------------
$ChocolateyProfile = "$ENV:CHOCOLATEYINSTALL\helpers\chocolateyProfile.psm1"

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
    &${function:Update-LocalProfileModuleDirectory} -ErrorAction SilentlyContinue
}

#---------------------------------------------------------------------------------------------------
# Invoke the profile update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true) {
    &${function:Update-Profile} -ErrorAction SilentlyContinue
}

#---------------------------------------------------------------------------------------------------
# Invoke the PowerShell update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdatePowerShell -eq $true) {
    &${function:Update-PowerShell} -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Editor Configuration
#------------------------------------------------------
$EDITOR = if (Test-CommandExists nvim) { 'nvim' }
elseif (Test-CommandExists pvim) { 'pvim' }
elseif (Test-CommandExists vim) { 'vim' }
elseif (Test-CommandExists vi) { 'vi' }
elseif (Test-CommandExists code) { 'code' }
elseif (Test-CommandExists notepad++) { 'notepad++' }
elseif (Test-CommandExists sublime_text) { 'sublime_text' }
else { 'notepad' }

#------------------------------------------------------
# Set the editor alias
#------------------------------------------------------
Set-Alias -Name vim -Value $EDITOR

#------------------------------------------------------
# Run FastFetch
#------------------------------------------------------
# if (Test-CommandExists FastFetch) {
#     Invoke-Expression -Command "Clear-Host"
#     Invoke-Expression -Command "FastFetch"
# }
