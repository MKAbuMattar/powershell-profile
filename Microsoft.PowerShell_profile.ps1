#------------------------------------------------------
# MKAbuMattar's PowerShell Profile
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This profile is used to configure the
#       PowerShell environment.
#
# Created: 2021-09-01
# Updated: 2024-05-08
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 1.0.0
#------------------------------------------------------

######################################################
# Profile Setup
######################################################

#------------------------------------------------------
# Set the console encoding to UTF-8
#------------------------------------------------------
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#------------------------------------------------------
# Test if we can connect to GitHub
#------------------------------------------------------
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

#------------------------------------------------------
# Check if Terminal Icons module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}

#------------------------------------------------------
# Check if PSReadLine module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
  Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
}

#------------------------------------------------------
# Check if Posh-Git module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Posh-Git)) {
  Install-Module -Name Posh-Git -Scope CurrentUser -Force -SkipPublisherCheck
}

#------------------------------------------------------
# Load the modules
#------------------------------------------------------
Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine
Import-Module -Name Posh-Git

#------------------------------------------------------
# Set the PSReadLine options
#------------------------------------------------------
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionViewStyle InlineView

#------------------------------------------------------
# Check if Starship is installed
#------------------------------------------------------
function Invoke-Starship-TransientFunction {
  &starship module character
}

#------------------------------------------------------
# Invoke Starship Transient Function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-Starship-TransientFunction} -ErrorAction SilentlyContinue

#------------------------------------------------------
# Load Starship
#------------------------------------------------------
Invoke-Expression (&starship init powershell)

#------------------------------------------------------
# Set Chocolatey Profile
#------------------------------------------------------
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

if (Test-Path $ChocolateyProfile) {
  Import-Module $ChocolateyProfile
}

#------------------------------------------------------
# Check for Profile updates
#------------------------------------------------------
function Update-Profile {
  if (-not $global:canConnectToGitHub) {
    Write-Host "Skipping profile update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
    return
  }

  try {
    $url = "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $oldhash = Get-FileHash $PROFILE
    Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
    $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
    if ($newhash.Hash -ne $oldhash.Hash) {
      Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
      Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
    }
  }
  catch {
    Write-Error "Unable to check for `$profile updates"
  }
  finally {
    Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
  }
}

#------------------------------------------------------
# Invoke the profile update function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Update-Profile} -ErrorAction SilentlyContinue

#------------------------------------------------------
# Check for PowerShell updates
#------------------------------------------------------
function Update-PowerShell {
  if (-not $global:canConnectToGitHub) {
    Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
    return
  }

  try {
    Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
    $updateNeeded = $false
    $currentVersion = $PSVersionTable.PSVersion.ToString()
    $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
    $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
    if ($currentVersion -lt $latestVersion) {
      $updateNeeded = $true
    }

    if ($updateNeeded) {
      Write-Host "Updating PowerShell..." -ForegroundColor Yellow
      winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
      Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
    }
    else {
      Write-Host "Your PowerShell is up to date." -ForegroundColor Green
    }
  }
  catch {
    Write-Error "Failed to update PowerShell. Error: $_"
  }
}

#------------------------------------------------------
# Invoke the PowerShell update function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Update-PowerShell} -ErrorAction SilentlyContinue

#------------------------------------------------------
# Utility function to check if a command exists
#------------------------------------------------------
function Test-CommandExists {
  param($command)
  $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
  return $exists
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

#------------------------------------------------------
# Edit the profile
#------------------------------------------------------
function Edit-Profile {
  vim $PROFILE.CurrentUserAllHosts
}

######################################################
# Utility Functions
######################################################

#------------------------------------------------------
# Utility function to Create a new empty file
#------------------------------------------------------
function touch($file) {
  "" | Out-File $file -Encoding ASCII
}

#------------------------------------------------------
# Utility function to find a file
#------------------------------------------------------
function ff($name) {
  Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Output "$($_.directory)\$($_)"
  }
}

#------------------------------------------------------
# Utility function to get the uptime
#------------------------------------------------------
function uptime {
  if ($PSVersionTable.PSVersion.Major -eq 5) {
    Get-WmiObject win32_operatingsystem | Select-Object @{Name = 'LastBootUpTime'; Expression = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
  }
  else {
    net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
  }
}

#------------------------------------------------------
# Utility function to reload the profile
#------------------------------------------------------
function reload-profile {
  & $profile
}

#------------------------------------------------------
# Utility function to unzip a file
#------------------------------------------------------
function unzip ($file) {
  Write-Output("Extracting", $file, "to", $pwd)
  $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
  Expand-Archive -Path $fullFile -DestinationPath $pwd
}

#------------------------------------------------------
# Utility function to search for a string in a file
#------------------------------------------------------
function grep($regex, $dir) {
  if ( $dir ) {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}

#------------------------------------------------------
# Utility function to get the volume information
#------------------------------------------------------
function df {
  get-volume
}

#------------------------------------------------------
# Utility function to search for a string in a file
#------------------------------------------------------
function sed($file, $find, $replace) {
  (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

#------------------------------------------------------
# Utility function to get the definition of a command
#------------------------------------------------------
function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}

#------------------------------------------------------
# Utility function to export an environment variable
#------------------------------------------------------
function export($name, $value) {
  set-item -force -path "env:$name" -value $value;
}

#------------------------------------------------------
# Utility function to kill a process
#------------------------------------------------------
function pkill($name) {
  Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

#------------------------------------------------------
# Utility function to find a process
#------------------------------------------------------
function pgrep($name) {
  Get-Process $name
}

#------------------------------------------------------
# Utility function to get the top processes
#------------------------------------------------------
function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

#------------------------------------------------------
# Utility function to get the bottom processes
#------------------------------------------------------
function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

#------------------------------------------------------
# Utility function to create a new file
#------------------------------------------------------
function nf { 
  param($name) New-Item -ItemType "file" -Path . -Name $name
}

#------------------------------------------------------
# Utility function to create a new directory
#------------------------------------------------------
function mkcd { 
  param($dir) mkdir $dir -Force; Set-Location $dir
}

#------------------------------------------------------
# Utility function Search through the command history
#------------------------------------------------------
function history($searchTerm) {
  Get-Content (Get-PSReadlineOption).HistorySavePath | Where-Object { $_ -like "*$searchTerm*" }
}

######################################################
# Navigation Shortcuts
######################################################

#------------------------------------------------------
# Go to the Root directory
#------------------------------------------------------
function root {
  Set-Location -Path $HOME
}

#------------------------------------------------------
# Go to the Documents directory
#------------------------------------------------------
function doc {
  Set-Location -Path $HOME\Documents
}

#------------------------------------------------------
# Go to the Downloads directory
#------------------------------------------------------
function dl {
  Set-Location -Path $HOME\Downloads
}

#------------------------------------------------------
# Go to the Desktop directory
#------------------------------------------------------
function dt {
  Set-Location -Path $HOME\Desktop
}

#------------------------------------------------------
# Go to the D:\ directory
#------------------------------------------------------
function d {
  Set-Location -Path "D:\"
}

######################################################
# Profile Shortcuts
######################################################

#------------------------------------------------------
# Edit the profile
#------------------------------------------------------
function ep { 
  vim $PROFILE
}

#------------------------------------------------------
# Get System Information
#------------------------------------------------------
function sysinfo { 
  Get-ComputerInfo 
}

#------------------------------------------------------
# Simplified Process Management
#------------------------------------------------------
function k9 { 
  Stop-Process -Name $args[0] 
}

#------------------------------------------------------
# Flush the DNS cache
#------------------------------------------------------
function flushdns { 
  Clear-DnsClientCache 
}


#------------------------------------------------------
# List all files and directories
#------------------------------------------------------
function la {
  Get-ChildItem -Path . -Force | Format-Table -AutoSize
}

#------------------------------------------------------
# List all files and directories including hidden
#------------------------------------------------------
function ll {
  Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize 
}
