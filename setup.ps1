#------------------------------------------------------
# MKAbuMattar's PowerShell Profile Setup
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This script is used to setup the PowerShell
#       environment by installing required modules
#       and tools.
#
# Created: 2021-09-01
# Updated: 2024-05-09
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 1.5.0
#------------------------------------------------------

#------------------------------------------------------
# Check if the script is running as an Administrator
#------------------------------------------------------
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Warning "Please run this script as an Administrator!"
  break
}

<#
.SYNOPSIS
Checks if the script has an internet connection by attempting to ping a specified host.

.DESCRIPTION
This function attempts to ping a specified host (by default, www.google.com) to determine if the script has an internet connection. If the ping is successful, it returns $true; otherwise, it returns $false. If no internet connection is available, it displays a warning message.

.PARAMETER HostName
Specifies the host to ping to check for internet connectivity. Default is www.google.com.

.OUTPUTS
$true if the internet connection is available; otherwise, $false.

.EXAMPLE
Test-InternetConnection
Checks for internet connection using the default host (www.google.com).
#>
function Test-InternetConnection {
  param(
    [string]$HostName = "www.google.com"
  )

  try {
    Test-Connection -ComputerName $HostName -Count 1 -ErrorAction Stop | Out-Null
    return $true
  }
  catch {
    Write-Warning "Internet connection is required but not available. Please check your connection."
    return $false
  }
}

#------------------------------------------------------
# Check for internet connection before proceeding
#------------------------------------------------------
if (-not (Test-InternetConnection)) {
  break
}

#------------------------------------------------------
# Prepare the environment for creating/updating the profile
#------------------------------------------------------
if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
  try {
    $profilePath = ""
    if ($PSVersionTable.PSEdition -eq "Core") { 
      $profilePath = "$env:userprofile\Documents\Powershell"
    }
    elseif ($PSVersionTable.PSEdition -eq "Desktop") {
      $profilePath = "$env:userprofile\Documents\WindowsPowerShell"
    }

    if (!(Test-Path -Path $profilePath)) {
      New-Item -Path $profilePath -ItemType "directory"
    }

    Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
    Write-Host "The profile @ [$PROFILE] has been created."
    Write-Host "If you want to add any persistent components, please do so at [$profilePath\Profile.ps1] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes"
  }
  catch {
    Write-Error "Failed to create or update the profile. Error: $_"
  }
}
else {
  try {
    Get-Item -Path $PROFILE | Move-Item -Destination "oldprofile.ps1" -Force
    Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
    Write-Host "The profile @ [$PROFILE] has been created and old profile removed."
    Write-Host "Please back up any persistent components of your old profile to [$HOME\Documents\PowerShell\Profile.ps1] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes"
  }
  catch {
    Write-Error "Failed to backup and update the profile. Error: $_"
  }
}

#------------------------------------------------------
# Create ~/.config directory and copy starship.toml
#------------------------------------------------------
try {
  $configDir = "$env:USERPROFILE\.config"
  if (!(Test-Path -Path $configDir -PathType Container)) {
    New-Item -Path $configDir -ItemType Directory
    Write-Host "Created directory: $configDir"
  }

  $starshipTomlUrl = "https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/starship.toml"
  $starshipTomlPath = Join-Path -Path $configDir -ChildPath "starship.toml"
  
  if (!(Test-Path -Path $starshipTomlPath)) {
    Invoke-WebRequest -Uri $starshipTomlUrl -OutFile $starshipTomlPath
    Write-Host "Copied starship.toml to: $starshipTomlPath"
  }
  else {
    Write-Host "starship.toml already exists in: $configDir"
  }
}
catch {
  Write-Error "Failed to create ~/.config directory or copy starship.toml. Error: $_"
}


#------------------------------------------------------
# Install Cascadia Code font
#------------------------------------------------------
try {
  [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
  $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name

  if ($fontFamilies -notcontains "CaskaydiaCove NF") {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFileAsync((New-Object System.Uri("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip")), ".\CascadiaCode.zip")
      
    while ($webClient.IsBusy) {
      Start-Sleep -Seconds 2
    }

    Expand-Archive -Path ".\CascadiaCode.zip" -DestinationPath ".\CascadiaCode" -Force
    $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    Get-ChildItem -Path ".\CascadiaCode" -Recurse -Filter "*.ttf" | ForEach-Object {
      If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {        
        $destination.CopyHere($_.FullName, 0x10)
      }
    }

    Remove-Item -Path ".\CascadiaCode" -Recurse -Force
    Remove-Item -Path ".\CascadiaCode.zip" -Force
  }
}
catch {
  Write-Error "Failed to download or install the Cascadia Code font. Error: $_"
}

#------------------------------------------------------
# Check if the setup completed successfully
#------------------------------------------------------
if ((Test-Path -Path $PROFILE) -and ($fontFamilies -contains "CaskaydiaCove NF")) {
  Write-Host "Setup completed successfully. Please restart your PowerShell session to apply changes."
}
else {
  Write-Warning "Setup completed with errors. Please check the error messages above."
}

#------------------------------------------------------
# Install Chocolatey
#------------------------------------------------------
try {
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
catch {
  Write-Error "Failed to install Chocolatey. Error: $_"
}

#------------------------------------------------------
# Install Terminal Icons module
#------------------------------------------------------
try {
  Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}
catch {
  Write-Error "Failed to install Terminal Icons module. Error: $_"
}

#------------------------------------------------------
# Install PSReadLine Module
#------------------------------------------------------
try {
  Install-Module -Name PSReadLine -Repository PSGallery -Force
}
catch {
  Write-Error "Failed to install PSReadLine module. Error: $_"
}

#------------------------------------------------------
# Install Posh-Git Module
#------------------------------------------------------
try {
  Install-Module -Name Posh-Git -Repository PSGallery -Force
}
catch {
  Write-Error "Failed to install Posh-Git module. Error: $_"
}

#------------------------------------------------------
# Install Starship
#------------------------------------------------------
try {
  choco install starship -y
}
catch {
  Write-Error "Failed to install Starship. Error: $_"
}

#------------------------------------------------------
# Install Windows Terminal
#------------------------------------------------------
try {
  choco install microsoft-windows-terminal -y
}
catch {
  Write-Error "Failed to install Windows Terminal. Error: $_"
}

#------------------------------------------------------
# Install PowerShell
#------------------------------------------------------
try {
  choco install powershell -y
}
catch {
  Write-Error "Failed to install PowerShell. Error: $_"
}