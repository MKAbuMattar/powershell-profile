#######################################################
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
#  MKAbuMattar's PowerShell Profile
#######################################################

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
# Updated: 2024-05-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 2.0.0
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

<#
.SYNOPSIS
    Updates or installs the specified modules.

.DESCRIPTION
    This function checks if the specified modules are installed and updates them if they are already installed. If a module is not found, it installs the module. The function provides feedback on the installation or update process and handles any errors that may occur.

.PARAMETER ModuleList
    Specifies an array of module names to update or install.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpdateInstallPSModules -ModuleList @('Module1', 'Module2', 'Module3')
    Updates or installs the modules 'Module1', 'Module2', and 'Module3'.

.EXAMPLE
    $modules = @('Module1', 'Module2', 'Module3')
    Invoke-UpdateInstallPSModules -ModuleList $modules
    Updates or installs the modules 'Module1', 'Module2', and 'Module3'.
#>
function Private:Invoke-UpdateInstallPSModules {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string[]]$ModuleList
  )

  foreach ($module in $ModuleList) {
    Write-Output "Checking $module"
    try {
      if (-not (Find-Module -Name $module)) {
        Write-Output "Installing $module"
        Install-Module -Name $module -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
      }
      else {
        Write-Output "Updating $module"
        Update-Module -Name $module -Scope CurrentUser -Force -ErrorAction Stop
      }
    }
    catch {
      Write-Warning "Failed to process module ${module}: $_"
    }
  }
}

#------------------------------------------------------
# Install required PowerShell modules
#------------------------------------------------------
$modules = @( 'Terminal-Icons', 'PowerShellGet', 'PSReadLine', 'Posh-Git', 'CompletionPredictor' )

try {
  Invoke-UpdateInstallPSModules -ModuleList $modules
}
catch {
  Write-Error "Failed to install or update the required PowerShell modules. Error: $_"
}

<#
.SYNOPSIS
    Updates or installs the specified Chocolatey packages.

.DESCRIPTION
    This function checks if the specified Chocolatey packages are installed and updates them if they are already installed. If a package is not found, it installs the package. The function provides feedback on the installation or update process and handles any errors that may occur.

.PARAMETER PackageList
    Specifies an array of Chocolatey package names to update or install.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpdateInstallChocoPackages -PackageList @('Package1', 'Package2', 'Package3')
    Updates or installs the Chocolatey packages 'Package1', 'Package2', and 'Package3'.

.EXAMPLE
    $packages = @('Package1', 'Package2', 'Package3')
    Invoke-UpdateInstallChocoPackages -PackageList $packages
    Updates or installs the Chocolatey packages 'Package1', 'Package2', and 'Package3'.
#>
function Private:Invoke-UpdateInstallChocoPackages {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string[]]$PackageList
  )

  foreach ($package in $PackageList) {
    Write-Output "Checking $package"
    try {
      if (-not (Get-Package -Name $package -ErrorAction SilentlyContinue)) {
        Write-Output "Installing $package"
        choco install $package -y
      }
      else {
        Write-Output "Updating $package"
        choco upgrade $package -y
      }
    }
    catch {
      Write-Warning "Failed to process package ${package}: $_"
    }
  }
}

#------------------------------------------------------
# Install required Chocolatey packages
#------------------------------------------------------
$packages = @( 'starship', 'microsoft-windows-terminal', 'powershell' )

try {
  Invoke-UpdateInstallChocoPackages -PackageList $packages
}
catch {
  Write-Error "Failed to install or update the required Chocolatey packages. Error: $_"
}

#------------------------------------------------------
# Create MKAbuMattar.Environment_Variables.ps1
#------------------------------------------------------

try {
  # Prompt user for environment variable values
  $AutoUpdateProfileInput = Read-Host "Enter value for AutoUpdateProfile (true/false):"
  $AutoUpdateProfile = [bool]::Parse($AutoUpdateProfileInput)

  $AutoUpdatePowerShellInput = Read-Host "Enter value for AutoUpdatePowerShell (true/false):"
  $AutoUpdatePowerShell = [bool]::Parse($AutoUpdatePowerShellInput)

  $EnvironmentVariablesScript = @"
#######################################################
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
#  MKAbuMattar's PowerShell Profile
#######################################################

#------------------------------------------------------
# MKAbuMattar's PowerShell Profile
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
# Updated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 2.0.1
#------------------------------------------------------

#######################################################
# Environment Variables
#######################################################

<#
.SYNOPSIS
    Set environment variables for the PowerShell profile Auto Update.

.DESCRIPTION
    This environment variable determines whether the PowerShell profile should automatically check for updates. If set to true, it enables the profile update function, which checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected. Default value is false.

.EXAMPLE
    AutoUpdateProfile = false
    Disables the automatic update of the PowerShell profile.
#>
\$env:AutoUpdateProfile = $AutoUpdateProfile

<#
.SYNOPSIS
    Set environment variables for the PowerShell Auto Update.

.DESCRIPTION
    This environment variable determines whether the PowerShell should automatically check for updates. If set to true, it enables the PowerShell update function, which checks for updates to the PowerShell from a specified GitHub repository and updates the local PowerShell if changes are detected. Default value is false.

.EXAMPLE
    AutoUpdatePowerShell = false
    Disables the automatic update of the PowerShell.
#>
\$env:AutoUpdatePowerShell = $AutoUpdatePowerShell
"@

  # Write the script content to file

  $ProfileDirectory = [System.IO.Path]::GetDirectoryName($PROFILE.CurrentUserAllHosts)
  $EnvironmentVariablesPath = Join-Path -Path $ProfileDirectory -ChildPath "MKAbuMattar.Environment_Variables.ps1"

  Set-Content -Path $EnvironmentVariablesPath -Value $EnvironmentVariablesScript -Force

  # Check if the setup completed successfully
  if (Test-Path -Path $EnvironmentVariablesPath) {
    Write-Host "Setup completed successfully. Please restart your PowerShell session to apply changes."
  }
  else {
    Write-Warning "Setup completed with errors. Please check the error messages above."
  }  
}
catch {
  Write-Error "Failed to create the environment variables script. Error: $_"
}
