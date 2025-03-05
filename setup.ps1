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
#       This script is used to setup the PowerShell
#       environment by installing required modules
#       and tools.
#
# Created: 2021-09-01
# Updated: 2025-03-04
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 3.0.0
#---------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
  Logs a message with a timestamp and log level.

.DESCRIPTION
  This function logs a message with a timestamp and log level. The default log level is "INFO".

.PARAMETER Message
  Specifies the message to log.

.PARAMETER Level
  Specifies the log level. Default is "INFO".

.OUTPUTS
  A log message with a timestamp and log level.

.EXAMPLE
  Write-LogMessage -Message "This is an informational message."
  Logs an informational message with the default log level "INFO".
  Write-LogMessage -Message "This is a warning message." -Level "WARNING"
  Logs a warning message with the log level "WARNING".

.NOTES
  This function is used to log messages with a timestamp and log level.
#>
function Write-LogMessage {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Message,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Level = "INFO"
  )

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Write-Output "[$timestamp][$Level] $Message"
}

<#
.SYNOPSIS
  Eeror handling function to log the error message and break the script.

.DESCRIPTION
  This function logs the error message and the exception message and then breaks the script.

.PARAMETER ErrorMessage
  Specifies the error message to log.

.PARAMETER ErrorRecord
  Specifies the error record object.

.OUTPUTS
  A log message with the error message and exception message.

.EXAMPLE
  Invoke-ErrorHandling -ErrorMessage "An error occurred." -ErrorRecord $Error
  Logs an error message and the exception message and breaks the script.

.NOTES
  This function is used to handle errors by logging the error message and exception message.
#>
function Invoke-ErrorHandling {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$ErrorMessage,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [System.Management.Automation.ErrorRecord]$ErrorRecord
  )

  Write-LogMessage -Message "$ErrorMessage`n$($ErrorRecord.Exception.Message)" -Level "ERROR"
  break
}

#---------------------------------------------------------------------------------------------------
# Check if the script is running as an Administrator
#---------------------------------------------------------------------------------------------------
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-LogMessage -Message "Please run this script as an Administrator!" -Level "WARNING"
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

.NOTES
  This function is used to check for internet connection before proceeding with the script.
#>
function Test-InternetConnection {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$HostName = "www.google.com"
  )

  try {
    Test-Connection -ComputerName $HostName -Count 1 -ErrorAction Stop | Out-Null
    return $true
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Internet connection is required but not available. Please check your connection." -ErrorRecord $_
    return $false
  }
}

#---------------------------------------------------------------------------------------------------
# Check for internet connection before proceeding
#---------------------------------------------------------------------------------------------------
if (-not (Test-InternetConnection)) {
  break
}

<#
.SYNOPSIS
  Copies the Module directory and its contents from the repository to the specified local path.

.DESCRIPTION
  This function copies the Module directory and its contents from the GitHub repository to the specified local path. If the file already exists, it will be removed before copying the new file.

.PARAMETER LocalPath
  Specifies the local path where the Module directory will be copied.

.OUTPUTS
  The Module directory and its contents are copied to the specified local path.

.EXAMPLE
  Copy-ModuleDirectory -LocalPath "$HOME\Documents\PowerShell"
  Copies the Module directory to the specified local path.

.NOTES
  This function is used to copy the Module directory from the repository to the local path.
#>
function Copy-ModuleDirectory {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$LocalPath = "$HOME\Documents\PowerShell"
  )

  try {
    $baseRepoUrl = "https://github.com/MKAbuMattar/powershell-profile"
    $moduleDirUrl = "$baseRepoUrl/raw/main/Module"

    # Create the local Module directory if it does not exist
    $localModuleDir = Join-Path -Path $LocalPath -ChildPath "Module"
    if (-not (Test-Path -Path $localModuleDir)) {
      New-Item -Path $localModuleDir -ItemType Directory -Force
      Write-LogMessage -Message "Created directory: $localModuleDir"
    }

    # Define the files to be copied from the Module directory
    $files = @(
      "Directory/Directory.psd1",
      "Directory/Directory.psm1",
      "Docs/Docs.psd1",
      "Docs/Docs.psm1",
      "Environment/Environment.psd1",
      "Environment/Environment.psm1",
      "Logging/Logging.psd1",
      "Logging/Logging.psm1",
      "Starship/Starship.psd1",
      "Starship/Starship.psm1",
      "Update/Update.psd1",
      "Update/Update.psm1",
      "Utility/Utility.psd1",
      "Utility/Utility.psm1"
    )

    foreach ($file in $files) {
      $fileUrl = "$moduleDirUrl/$file"
      $localFilePath = Join-Path -Path $localModuleDir -ChildPath $file

      # Ensure the local directory for the file exists
      $localFileDir = Split-Path -Path $localFilePath -Parent
      if (-not (Test-Path -Path $localFileDir)) {
        New-Item -Path $localFileDir -ItemType Directory -Force
        Write-LogMessage -Message "Created directory: $localFileDir"
      }

      # Remove the file if it exists
      if (Test-Path -Path $localFilePath) {
        Remove-Item -Path $localFilePath -Force
        Write-LogMessage -Message "Removed existing file: $localFilePath"
      }

      # Copy the new file
      Invoke-WebRequest -Uri $fileUrl -OutFile $localFilePath
      Write-LogMessage -Message "Copied $file to: $localFilePath"
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to copy Module directory from the repository." -ErrorRecord $_
  }
}

#---------------------------------------------------------------------------------------------------
# Copy the Module directory from the repository to the local path
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Copying the Module directory from the repository to the local path..."
Invoke-Command -ScriptBlock ${function:Copy-ModuleDirectory} -ErrorAction Stop

<#
.SYNOPSIS
  Initializes the PowerShell profile by creating or updating the profile script.

.DESCRIPTION
  This function initializes the PowerShell profile by creating or updating the profile script. The profile script is downloaded from the GitHub repository and saved to the appropriate location based on the PowerShell edition (Core or Desktop). If the profile already exists, it is backed up before being updated.

.OUTPUTS
  The required modules and tools are installed or updated.

.EXAMPLE
  Initialize-PowerShellProfile
  Initializes the PowerShell profile by creating or updating the profile script.

.NOTES
  This function is used to initialize the PowerShell profile by creating or updating the profile script.
#>
function Initialize-PowerShellProfile {
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
      $profilePath = if ($PSVersionTable.PSEdition -eq "Core") {
        "$ENV:USERPROFILE\Documents\Powershell"
      }
      elseif ($PSVersionTable.PSEdition -eq "Desktop") {
        "$ENV:USERPROFILE\Documents\WindowsPowerShell"
      }

      if (!(Test-Path -Path $profilePath)) {
        New-Item -Path $profilePath -ItemType "directory"
      }

      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
      Write-LogMessage -Message "The profile @ [$PROFILE] has been created."
      Write-LogMessage -Message "If you want to add any persistent components, please do so at [$profilePath\Profile.ps1] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
    else {
      Get-Item -Path $PROFILE | Move-Item -Destination "oldprofile.ps1" -Force
      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
      Write-LogMessage -Message "The profile @ [$PROFILE] has been created and old profile removed."
      Write-LogMessage -Message "Please back up any persistent components of your old profile to [$HOME\Documents\PowerShell\Profile.ps1] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create or update the profile." -ErrorRecord $_
  }
}

<#
.SYNOPSIS
  Initializes the Starship configuration by creating the ~/.config directory and copying the starship.toml file.

.DESCRIPTION
  This function initializes the Starship configuration by creating the ~/.config directory and copying the starship.toml file from the GitHub repository.

.OUTPUTS
  The ~/.config directory is created, and the starship.toml file is copied.

.EXAMPLE
  Initialize-StarshipConfig
  Initializes the Starship configuration by creating the ~/.config directory and copying the starship.toml file.

.NOTES
  This function is used to initialize the Starship configuration by creating the ~/.config directory and copying the starship.toml file.
#>
function Initialize-StarshipConfig {
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    $configDir = "$ENV:USERPROFILE\.config"
    if (!(Test-Path -Path $configDir -PathType Container)) {
      New-Item -Path $configDir -ItemType Directory
      Write-LogMessage -Message "Created directory: $configDir"
    }

    $starshipTomlUrl = "https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/starship.toml"
    $starshipTomlPath = Join-Path -Path $configDir -ChildPath "starship.toml"

    if (!(Test-Path -Path $starshipTomlPath)) {
      Invoke-WebRequest -Uri $starshipTomlUrl -OutFile $starshipTomlPath
      Write-LogMessage -Message "Copied starship.toml to: $starshipTomlPath"
    }
    else {
      Write-LogMessage -Message "starship.toml already exists in: $configDir"
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create ~/.config directory or copy starship.toml." -ErrorRecord $_
  }
}

<#
.SYNOPSIS
  Initializes the FastFetch configuration by creating the ~/.config/fastfetch directory and copying the config.jsonc file.

.DESCRIPTION
  This function initializes the FastFetch configuration by creating the ~/.config/fastfetch directory and copying the config.jsonc file from the GitHub repository.

.OUTPUTS
  The ~/.config/fastfetch directory is created, and the config.jsonc file is copied.

.EXAMPLE
  Initialize-FastFetchConfig
  Initializes the FastFetch configuration by creating the ~/.config/fastfetch directory and copying the config.jsonc file.

.NOTES
  This function is used to initialize the FastFetch configuration by creating the ~/.config/fastfetch directory and copying the config.jsonc file.
#>
function Initialize-FastFetchConfig {
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    $configDir = "$ENV:USERPROFILE\.config"
    if (!(Test-Path -Path $configDir -PathType Container)) {
      New-Item -Path $configDir -ItemType Directory
      Write-LogMessage -Message "Created directory: $configDir"
    }

    $configPath = Join-Path -Path $configDir -ChildPath "fastfetch"
    if (!(Test-Path -Path $configPath -PathType Container)) {
      New-Item -Path $configPath -ItemType Directory
      Write-LogMessage -Message "Created directory: $configPath"
    }

    $fastfetchConfigUrl = "https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/fastfetch/config.jsonc"
    $fastfetchConfigPath = Join-Path -Path $configPath -ChildPath "config.jsonc"

    if (!(Test-Path -Path $fastfetchConfigPath)) {
      Invoke-WebRequest -Uri $fastfetchConfigUrl -OutFile $fastfetchConfigPath
      Write-LogMessage -Message "Copied config.jsonc to: $fastfetchConfigPath"
    }
    else {
      Write-LogMessage -Message "config.jsonc already exists in: $configPath"
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create ~/.config/fastfetch directory or copy config.jsonc." -ErrorRecord $_
  }
}

<#
.SYNOPSIS
  Initializes the Figlet configuration by creating the ~/.config/.figlet directory and copying the ANSI_Shadow.flf file.

.DESCRIPTION
  This function initializes the Figlet configuration by creating the ~/.config/.figlet directory and copying the ANSI_Shadow.flf file from the GitHub repository.

.OUTPUTS
  The ~/.config/.figlet directory is created, and the ANSI_Shadow.flf file is copied.

.EXAMPLE
  Initialize-FigletConfig
  Initializes the Figlet configuration by creating the ~/.config/.figlet directory and copying the ANSI_Shadow.flf file.

.NOTES
  This function is used to initialize the Figlet configuration by creating the ~/.config/.figlet directory and copying the ANSI_Shadow.flf file.
#>
function Initialize-FigletConfig {
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    $configDir = "$ENV:USERPROFILE\.config"
    if (!(Test-Path -Path $configDir -PathType Container)) {
      New-Item -Path $configDir -ItemType Directory
      Write-LogMessage -Message "Created directory: $configDir"
    }

    $configPath = Join-Path -Path $configDir -ChildPath ".figlet"
    if (!(Test-Path -Path $configPath -PathType Container)) {
      New-Item -Path $configPath -ItemType Directory
      Write-LogMessage -Message "Created directory: $configPath"
    }

    $figletConfigUrl = "https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/.figlet/ANSI_Shadow.flf"
    $figletConfigPath = Join-Path -Path $configPath -ChildPath "ANSI_Shadow.flf"

    if (!(Test-Path -Path $figletConfigPath)) {
      Invoke-WebRequest -Uri $figletConfigUrl -OutFile $figletConfigPath
      Write-LogMessage -Message "Copied ANSI_Shadow.flf to: $figletConfigPath"
    }
    else {
      Write-LogMessage -Message "ANSI_Shadow.flf already exists in: $configPath"
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create ~/.config/.figlet directory or copy ANSI_Shadow.flf." -ErrorRecord $_
  }
}

<#
.SYNOPSIS
  Installs the Cascadia Code font if it is not already installed.

.DESCRIPTION
  This function installs the Cascadia Code font if it is not already installed. The font is downloaded from the GitHub repository and installed in the Windows Fonts directory.

.PARAMETER FontName
  Specifies the name of the font to install. Default is "CascadiaCode".

.PARAMETER FontDisplayName
  Specifies the display name of the font. Default is "CaskaydiaCove NF".

.PARAMETER Version
  Specifies the version of the font to download. Default is "3.2.1".

.OUTPUTS
  The Cascadia Code font is installed.

.EXAMPLE
  Install-CascadiaCodeFont
  Installs the Cascadia Code font with the default parameters.
  Install-CascadiaCodeFont -FontName "CascadiaCode" -FontDisplayName "CaskaydiaCove NF" -Version "3.2.1"
  Installs the Cascadia Code font with the specified parameters.

.NOTES
  This function is used to install the Cascadia Code font if it is not already installed.
#>
function Install-CascadiaCodeFont {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$FontName = "CascadiaCode",

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$FontDisplayName = "CaskaydiaCove NF",

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Version = "3.2.1"
  )

  try {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
    if ($fontFamilies -notcontains "${FontDisplayName}") {
      $fontZipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${Version}/${FontName}.zip"
      $zipFilePath = "$env:TEMP\${FontName}.zip"
      $extractPath = "$env:TEMP\${FontName}"

      $webClient = New-Object System.Net.WebClient
      $webClient.DownloadFileAsync((New-Object System.Uri($fontZipUrl)), $zipFilePath)

      while ($webClient.IsBusy) {
        Start-Sleep -Seconds 2
      }

      Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
      $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
      Get-ChildItem -Path $extractPath -Recurse -Filter "*.ttf" | ForEach-Object {
        If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
          $destination.CopyHere($_.FullName, 0x10)
        }
      }

      Remove-Item -Path $extractPath -Recurse -Force
      Remove-Item -Path $zipFilePath -Force
    }
    else {
      Write-LogMessage -Message "${FontDisplayName} font is already installed."
    }
  }
  catch {
    Invoke-ErrorHandling "Failed to download or install ${FontDisplayName} font. Error: $_"
  }
}

<#
.SYNOPSIS
  Installs Chocolatey package manager.

.DESCRIPTION
  This function installs the Chocolatey package manager by setting the execution policy to Bypass, updating the security protocol, and invoking the Chocolatey installation script.

.OUTPUTS
  The Chocolatey package manager is installed.

.EXAMPLE
  Install-Chocolatey
  Installs the Chocolatey package manager.

.NOTES
  This function is used to install the Chocolatey package manager.
#>
function Install-Chocolatey {
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to install Chocolatey." -ErrorRecord $_
  }
}

<#
.SYNOPSIS
  Installs or updates the required PowerShell modules.

.DESCRIPTION
  This function installs or updates the required PowerShell modules based on the provided module list. If the module is not found, it is installed; otherwise, it is updated.

.PARAMETER ModuleList
  Specifies the list of modules to install or update.

.OUTPUTS
  The required modules are installed or updated.

.EXAMPLE
  Invoke-UpdateInstallPSModules -ModuleList @("Module1", "Module2", "Module3")
  Installs or updates the modules "Module1", "Module2", and "Module3".

.NOTES
  This function is used to install or update the required PowerShell modules.
#>
function Invoke-UpdateInstallPSModules {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]$ModuleList
  )

  foreach ($module in $ModuleList) {
    Write-LogMessage -Message "Checking $module"
    try {
      $installedModule = Get-InstalledModule -Name $module -ErrorAction SilentlyContinue
      if ($installedModule) {
        $installedVersion = $installedModule.Version
        $latestVersion = (Find-Module -Name $module).Version

        if ($installedVersion -ne $latestVersion) {
          Write-LogMessage -Message "Updating $module from version $installedVersion to $latestVersion"
          Update-Module -Name $module -Force
        }
        else {
          Write-LogMessage -Message "$module is already up-to-date (version $installedVersion)"
        }
      }
      else {
        Write-LogMessage -Message "Installing $module"
        Install-Module -Name $module -Force
      }
    }
    catch {
      Invoke-ErrorHandling -ErrorMessage "Failed to process module $module." -ErrorRecord $_
    }
  }
}

<#
.SYNOPSIS
  Installs or updates the required Chocolatey packages.

.DESCRIPTION
  This function installs or updates the required Chocolatey packages based on the provided package list. If the package is not found, it is installed; otherwise, it is updated if it is outdated.

.PARAMETER PackageList
  Specifies the list of packages to install or update.

.OUTPUTS
  The required packages are installed or updated.

.EXAMPLE
  Invoke-UpdateInstallChocoPackages -PackageList @("Package1", "Package2", "Package3")
  Installs or updates the packages "Package1", "Package2", and "Package3".

.NOTES
  This function is used to install or update the required Chocolatey packages.
#>
function Invoke-UpdateInstallChocoPackages {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]$PackageList
  )

  foreach ($package in $PackageList) {
    Write-LogMessage -Message "Checking $package"
    try {
      $installedPackage = choco list --local-only --exact $package -r -e | Select-String -Pattern $package
      if ($installedPackage) {
        $installedVersion = $installedPackage.ToString().Split('|')[1].Trim()
        $latestVersion = (choco search $package --exact --limit-output | Select-String -Pattern $package).ToString().Split('|')[1].Trim()

        if ($installedVersion -ne $latestVersion) {
          Write-LogMessage -Message "Updating $package from version $installedVersion to $latestVersion"
          choco upgrade $package -y
        }
        else {
          Write-LogMessage -Message "$package is already up-to-date (version $installedVersion)"
        }
      }
      else {
        Write-LogMessage -Message "Installing $package"
        choco install $package -y
      }
    }
    catch {
      Invoke-ErrorHandling -ErrorMessage "Failed to process package $package." -ErrorRecord $_
    }
  }
}

#---------------------------------------------------------------------------------------------------
# Start the setup process
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Starting the setup process..."

#---------------------------------------------------------------------------------------------------
# Initialize the PowerShell profile
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Initializing the PowerShell profile..."
Invoke-Command -ScriptBlock ${function:Initialize-PowerShellProfile} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Initialize the Starship configuration
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Initializing the Starship configuration..."
Invoke-Command -ScriptBlock ${function:Initialize-StarshipConfig} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Initialize the FastFetch configuration
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Initializing the FastFetch configuration..."
Invoke-Command -ScriptBlock ${function:Initialize-FastFetchConfig} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Install the Cascadia Code font
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Installing the Cascadia Code font..."
Invoke-Command -ScriptBlock ${function:Install-CascadiaCodeFont} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Install Chocolatey package manager
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Installing Chocolatey..."
Invoke-Command -ScriptBlock ${function:Install-Chocolatey} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Install or update required PowerShell modules
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Installing or updating required PowerShell modules..."
$modules = @('Terminal-Icons', 'PowerShellGet', 'PSReadLine', 'Posh-Git', 'CompletionPredictor')
Invoke-UpdateInstallPSModules -ModuleList $modules

#---------------------------------------------------------------------------------------------------
# Install or update required Chocolatey packages
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Installing or updating required Chocolatey packages..."
$packages = @('fastfetch', 'microsoft-windows-terminal', 'powershell-core', 'starship', 'zoxide')
Invoke-UpdateInstallChocoPackages -PackageList $packages

#---------------------------------------------------------------------------------------------------
# End the setup process
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Setup process completed successfully."

#---------------------------------------------------------------------------------------------------
# Check if the setup completed successfully
#---------------------------------------------------------------------------------------------------
if (Test-Path -Path $PROFILE) {
  Write-LogMessage -Message "Setup completed successfully. Please restart your PowerShell session to apply changes."
}
else {
  Write-LogMessage -Message "Setup completed with errors. Please check the error messages above." -Level "WARNING"
}
