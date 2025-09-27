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
# Import the custom modules and plugins
#---------------------------------------------------------------------------------------------------
$BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath 'Module'

$ModuleList = @(
    # Core Modules
    @{ Name = 'Directory'; Path = 'Directory/Directory.psd1' },
    @{ Name = 'Docs'; Path = 'Docs/Docs.psd1' },
    @{ Name = 'Environment'; Path = 'Environment/Environment.psd1' },
    @{ Name = 'Logging'; Path = 'Logging/Logging.psd1' },
    @{ Name = 'Network'; Path = 'Network/Network.psd1' },
    @{ Name = 'Process'; Path = 'Process/Process.psd1' },
    @{ Name = 'Starship'; Path = 'Starship/Starship.psd1' },
    @{ Name = 'Update'; Path = 'Update/Update.psd1' },
    @{ Name = 'Utility'; Path = 'Utility/Utility.psd1' },

    # Plugin Modules (Grouped for readability)
    @{ Name = 'Plugin-AWS'; Path = 'Plugins/AWS/AWS.psd1' },
    @{ Name = 'Plugin-Conda'; Path = 'Plugins/Conda/Conda.psd1' },
    @{ Name = 'Plugin-Deno'; Path = 'Plugins/Deno/Deno.psd1' },
    @{ Name = 'Plugin-Docker'; Path = 'Plugins/Docker/Docker.psd1' },
    @{ Name = 'Plugin-DockerCompose'; Path = 'Plugins/DockerCompose/DockerCompose.psd1' },
    @{ Name = 'Plugin-Git'; Path = 'Plugins/Git/Git.psd1' },
    @{ Name = 'Plugin-Helm'; Path = 'Plugins/Helm/Helm.psd1' },
    @{ Name = 'Plugin-Kubectl'; Path = 'Plugins/Kubectl/Kubectl.psd1' },
    @{ Name = 'Plugin-NPM'; Path = 'Plugins/NPM/NPM.psd1' },
    @{ Name = 'Plugin-PIP'; Path = 'Plugins/PIP/PIP.psd1' },
    @{ Name = 'Plugin-Pipenv'; Path = 'Plugins/Pipenv/Pipenv.psd1' },
    @{ Name = 'Plugin-PNPM'; Path = 'Plugins/PNPM/PNPM.psd1' },
    @{ Name = 'Plugin-Poetry'; Path = 'Plugins/Poetry/Poetry.psd1' },
    @{ Name = 'Plugin-QRCode'; Path = 'Plugins/QRCode/QRCode.psd1' },
    @{ Name = 'Plugin-Ruby'; Path = 'Plugins/Ruby/Ruby.psd1' },
    @{ Name = 'Plugin-Rsync'; Path = 'Plugins/Rsync/Rsync.psd1' },
    @{ Name = 'Plugin-Terraform'; Path = 'Plugins/Terraform/Terraform.psd1' },
    @{ Name = 'Plugin-Terragrunt'; Path = 'Plugins/Terragrunt/Terragrunt.psd1' },
    @{ Name = 'Plugin-UV'; Path = 'Plugins/UV/UV.psd1' },
    @{ Name = 'Plugin-VSCode'; Path = 'Plugins/VSCode/VSCode.psd1' },
    @{ Name = 'Plugin-Yarn'; Path = 'Plugins/Yarn/Yarn.psd1' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name

    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
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
