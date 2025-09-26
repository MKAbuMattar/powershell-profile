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
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Write-LogMessage {
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
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The message to log."
    )]
    [string]$Message,

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The log level. Default is 'INFO'."
    )]
    [string]$Level = "INFO"
  )

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Write-Output "[$timestamp][$Level] $Message"
}

function Invoke-ErrorHandling {
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
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The error message to log."
    )]
    [string]$ErrorMessage,

    [Parameter(
      Mandatory = $true,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The error record object."
    )]
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

function Test-InternetConnection {
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
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The host to ping to check for internet connectivity."
    )]
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

function Copy-ModuleDirectory {
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
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The local path where the Module directory will be copied."
    )]
    [string]$LocalPath = "$HOME\Documents\PowerShell"
  )

  function Get-GitHubDirectoryFiles {
    param(
      [string]$Owner,
      [string]$Repo,
      [string]$Path,
      [string]$Branch = "main"
    )

    $apiUrl = "https://api.github.com/repos/$Owner/$Repo/contents/$Path" + "?ref=$Branch"

    try {
      Write-LogMessage -Message "Exploring directory: $Path"
      $response = Invoke-RestMethod -Uri $apiUrl -Headers @{"Accept" = "application/vnd.github.v3+json" }
      $files = @()

      foreach ($item in $response) {
        if ($item.type -eq "file" -and ($item.name -match "\.(psd1|psm1)$")) {
          Write-LogMessage -Message "Found PowerShell module file: $($item.path)"
          if ($item.download_url) {
            $files += @{
              Path        = $item.path
              DownloadUrl = $item.download_url
            }
          }
          else {
            Write-LogMessage -Message "Warning: No download URL for file $($item.path)" -Level "WARNING"
          }
        }
        elseif ($item.type -eq "dir") {
          Write-LogMessage -Message "Found subdirectory: $($item.path), recursing..."
          $subFiles = Get-GitHubDirectoryFiles -Owner $Owner -Repo $Repo -Path $item.path -Branch $Branch
          $files += $subFiles
        }
      }

      return $files
    }
    catch {
      Write-LogMessage -Message "Failed to get directory contents for $Path`: $($_.Exception.Message)" -Level "ERROR"
      return @()
    }
  }

  try {
    $localModuleDir = Join-Path -Path $LocalPath -ChildPath "Module"
    if (-not (Test-Path -Path $localModuleDir)) {
      New-Item -Path $localModuleDir -ItemType Directory -Force
      Write-LogMessage -Message "Created directory: $localModuleDir"
    }

    Write-LogMessage -Message "Discovering PowerShell module files from repository (main branch)..."
    $moduleFiles = Get-GitHubDirectoryFiles -Owner "MKAbuMattar" -Repo "powershell-profile" -Path "Module" -Branch "main"

    if ($moduleFiles.Count -eq 0) {
      Write-LogMessage -Message "No PowerShell module files found in the repository." -Level "WARNING"
      return
    }

    Write-LogMessage -Message "Found $($moduleFiles.Count) PowerShell module files to copy."

    foreach ($fileInfo in $moduleFiles) {
      $relativePath = $fileInfo.Path -replace "^Module/", ""
      $localFilePath = Join-Path -Path $localModuleDir -ChildPath $relativePath

      $localFileDir = Split-Path -Path $localFilePath -Parent
      if (-not (Test-Path -Path $localFileDir)) {
        New-Item -Path $localFileDir -ItemType Directory -Force
        Write-LogMessage -Message "Created directory: $localFileDir"
      }

      if (Test-Path -Path $localFilePath) {
        $tmpDir = "$HOME\.tmp"
        if (-not (Test-Path -Path $tmpDir)) {
          New-Item -Path $tmpDir -ItemType Directory -Force
        }
        $backupName = "$($relativePath -replace '[\\/]', '_').old"
        Get-Item -Path $localFilePath | Move-Item -Destination "$tmpDir\$backupName" -Force
        Write-LogMessage -Message "Backed up existing file: $localFilePath to $tmpDir\$backupName"
      }

      try {
        Invoke-WebRequest -Uri $fileInfo.DownloadUrl -OutFile $localFilePath
        Write-LogMessage -Message "Copied $relativePath to: $localFilePath"
      }
      catch {
        Write-LogMessage -Message "Failed to download $($fileInfo.Path)`: $($_.Exception.Message)" -Level "ERROR"
      }
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to copy Module directory from the repository." -ErrorRecord $_
  }
}

function Initialize-PowerShellProfile {
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
      Write-LogMessage -Message "If you want to add any persistent components, please do so at [$profilePath\Microsoft.PowerShell_profile.ps1] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
    else {
      $tmpDir = "$HOME\.tmp"
      if (-not (Test-Path -Path $tmpDir)) {
        New-Item -Path $tmpDir -ItemType Directory -Force
      }
      Get-Item -Path $PROFILE | Move-Item -Destination "$tmpDir\Microsoft.PowerShell_profile.ps1.old" -Force
      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
      Write-LogMessage -Message "The profile @ [$PROFILE] has been created and old profile moved to $tmpDir\Microsoft.PowerShell_profile.ps1.old."
      Write-LogMessage -Message "Please back up any persistent components of your old profile to [$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create or update the profile." -ErrorRecord $_
  }
}

function Initialize-StarshipConfig {
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
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    $configDir = "$ENV:USERPROFILE\.config"
    $starshipTomlPath = Join-Path -Path $configDir -ChildPath "starship.toml"

    if (!(Test-Path -Path $starshipTomlPath -PathType Leaf)) {
      if (!(Test-Path -Path $configDir)) {
        New-Item -Path $configDir -ItemType "directory"
      }

      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/starship.toml -OutFile $starshipTomlPath
      Write-LogMessage -Message "The starship.toml @ [$starshipTomlPath] has been created."
      Write-LogMessage -Message "If you want to add any persistent components, please do so at [$configDir\starship.toml] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
    else {
      $tmpDir = "$HOME\.tmp"
      if (-not (Test-Path -Path $tmpDir)) {
        New-Item -Path $tmpDir -ItemType Directory -Force
      }
      Get-Item -Path $starshipTomlPath | Move-Item -Destination "$tmpDir\starship.toml.old" -Force
      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/starship.toml -OutFile $starshipTomlPath
      Write-LogMessage -Message "The starship.toml @ [$starshipTomlPath] has been created and old starship.toml moved to $tmpDir\starship.toml.old."
      Write-LogMessage -Message "Please back up any persistent components of your old starship.toml to [$configDir\starship.toml] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create or update the starship.toml." -ErrorRecord $_
  }
}

function Initialize-FastFetchConfig {
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
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    $configDir = "$ENV:USERPROFILE\.config"
    $configPath = Join-Path -Path $configDir -ChildPath "fastfetch"
    $fastfetchConfigPath = Join-Path -Path $configPath -ChildPath "config.jsonc"

    if (!(Test-Path -Path $fastfetchConfigPath -PathType Leaf)) {
      if (!(Test-Path -Path $configDir)) {
        New-Item -Path $configDir -ItemType "directory"
      }

      if (!(Test-Path -Path $configPath)) {
        New-Item -Path $configPath -ItemType "directory"
      }

      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/fastfetch/config.jsonc -OutFile $fastfetchConfigPath
      Write-LogMessage -Message "The config.jsonc @ [$fastfetchConfigPath] has been created."
      Write-LogMessage -Message "If you want to add any persistent components, please do so at [$configPath\config.jsonc] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
    else {
      $tmpDir = "$HOME\.tmp"
      if (-not (Test-Path -Path $tmpDir)) {
        New-Item -Path $tmpDir -ItemType Directory -Force
      }
      Get-Item -Path $fastfetchConfigPath | Move-Item -Destination "$tmpDir\config.jsonc.old" -Force
      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/fastfetch/config.jsonc -OutFile $fastfetchConfigPath
      Write-LogMessage -Message "The config.jsonc @ [$fastfetchConfigPath] has been created and old config.jsonc moved to $tmpDir\config.jsonc.old."
      Write-LogMessage -Message "Please back up any persistent components of your old config.jsonc to [$configPath\config.jsonc] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create or update the config.jsonc." -ErrorRecord $_
  }
}

function Initialize-FigletConfig {
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
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    $configDir = "$ENV:USERPROFILE\.config"
    $configPath = Join-Path -Path $configDir -ChildPath ".figlet"
    $figletConfigPath = Join-Path -Path $configPath -ChildPath "ANSI_Shadow.flf"

    if (!(Test-Path -Path $figletConfigPath -PathType Leaf)) {
      if (!(Test-Path -Path $configDir)) {
        New-Item -Path $configDir -ItemType "directory"
      }

      if (!(Test-Path -Path $configPath)) {
        New-Item -Path $configPath -ItemType "directory"
      }

      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/.figlet/ANSI_Shadow.flf -OutFile $figletConfigPath
      Write-LogMessage -Message "The ANSI_Shadow.flf @ [$figletConfigPath] has been created."
      Write-LogMessage -Message "If you want to add any persistent components, please do so at [$configPath\ANSI_Shadow.flf] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
    else {
      $tmpDir = "$HOME\.tmp"
      if (-not (Test-Path -Path $tmpDir)) {
        New-Item -Path $tmpDir -ItemType Directory -Force
      }
      Get-Item -Path $figletConfigPath | Move-Item -Destination "$tmpDir\ANSI_Shadow.flf.old" -Force
      Invoke-RestMethod https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/.figlet/ANSI_Shadow.flf -OutFile $figletConfigPath
      Write-LogMessage -Message "The ANSI_Shadow.flf @ [$figletConfigPath] has been created and old ANSI_Shadow.flf moved to $tmpDir\ANSI_Shadow.flf.old."
      Write-LogMessage -Message "Please back up any persistent components of your old ANSI_Shadow.flf to [$configPath\ANSI_Shadow.flf] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create or update the ANSI_Shadow.flf." -ErrorRecord $_
  }
}

function Install-CascadiaCodeFont {
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

  .EXAMPLE
    Install-CascadiaCodeFont -FontName "CascadiaCode" -FontDisplayName "CaskaydiaCove NF" -Version "3.2.1"
    Installs the Cascadia Code font with the specified parameters.

  .NOTES
    This function is used to install the Cascadia Code font if it is not already installed.
  #>
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The name of the font to install."
    )]
    [string]$FontName = "CascadiaCode",

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The display name of the font."
    )]
    [string]$FontDisplayName = "CaskaydiaCove NF",

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The version of the font to download."
    )]
    [string]$Version = "3.3.0"
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

function Install-Chocolatey {
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

function Invoke-UpdateInstallPSModules {
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
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The list of modules to install or update."
    )]
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

function Invoke-UpdateInstallChocoPackages {
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
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The list of packages to install or update."
    )]
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

function Initialize-WindowsTerminalConfig {
  <#
  .SYNOPSIS
    Initializes the Windows Terminal configuration by downloading the settings.json file from the GitHub repository.

  .DESCRIPTION
    This function initializes the Windows Terminal configuration by downloading the settings.json file from the GitHub repository and saving it to the appropriate location. If the destination file already exists, it will be overwritten.

  .PARAMETER SourceUrl
    Specifies the URL of the settings.json file to download. Default is "https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/windows-terminal/settings.json".

  .PARAMETER DestinationPath
    Specifies the destination path where the settings.json file will be saved. Default is "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json".

  .INPUTS
    SourceUrl: (Optional) The URL of the settings.json file to download.
    DestinationPath: (Optional) The destination path where the settings.json file will be saved.

  .OUTPUTS
    The settings.json file is downloaded and saved to the destination path.

  .EXAMPLE
    Initialize-WindowsTerminalConfig
    Initializes the Windows Terminal configuration by downloading the settings.json file from the GitHub repository.

  .NOTES
    This function is used to initialize the Windows Terminal configuration by downloading the settings.json file from the GitHub repository.
  #>
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The URL of the settings.json file to download."
    )]
    [string]$SourceUrl = "https://github.com/MKAbuMattar/powershell-profile/raw/main/.config/windows-terminal/settings.json",

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The destination path where the settings.json file will be saved."
    )]
    [string]$DestinationPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  )

  try {
    if (!(Test-Path -Path $DestinationPath -PathType Leaf)) {
      $destinationDir = Split-Path -Path $DestinationPath -Parent
      if (!(Test-Path -Path $destinationDir)) {
        New-Item -Path $destinationDir -ItemType "directory"
      }

      Invoke-RestMethod $SourceUrl -OutFile $DestinationPath
      Write-LogMessage -Message "The settings.json @ [$DestinationPath] has been created."
      Write-LogMessage -Message "If you want to add any persistent components, please do so at [$destinationDir\settings.json] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
    else {
      $tmpDir = "$HOME\.tmp"
      if (-not (Test-Path -Path $tmpDir)) {
        New-Item -Path $tmpDir -ItemType Directory -Force
      }
      Get-Item -Path $DestinationPath | Move-Item -Destination "$tmpDir\settings.json.old" -Force
      Invoke-RestMethod $SourceUrl -OutFile $DestinationPath
      Write-LogMessage -Message "The settings.json @ [$DestinationPath] has been created and old settings.json moved to $tmpDir\settings.json.old."
      Write-LogMessage -Message "Please back up any persistent components of your old settings.json to [$destinationDir\settings.json] as there is an updater in the installed profile which uses the hash to update the profile and will lead to loss of changes."
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to create or update the settings.json." -ErrorRecord $_
  }
}

#---------------------------------------------------------------------------------------------------
# Start the setup process
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Starting the setup process..."

#---------------------------------------------------------------------------------------------------
# Copy the Module directory from the repository to the local path
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Copying the Module directory from the repository to the local path..."
Invoke-Command -ScriptBlock ${function:Copy-ModuleDirectory} -ErrorAction Stop

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
# Initialize the Figlet configuration
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Initializing the Figlet configuration..."
Invoke-Command -ScriptBlock ${function:Initialize-FigletConfig} -ErrorAction Stop

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
$modules = @(
  'Terminal-Icons',
  'PowerShellGet',
  'PSReadLine',
  'Posh-Git',
  'CompletionPredictor'
)
Invoke-Command -ScriptBlock ${function:Invoke-UpdateInstallPSModules} -ArgumentList $modules

#---------------------------------------------------------------------------------------------------
# Install or update required Chocolatey packages
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Installing or updating required Chocolatey packages..."
$packages = @(
  'fastfetch',
  'powershell-core',
  'starship',
  'zoxide',
  'fzf'
)
Invoke-Command -ScriptBlock ${function:Invoke-UpdateInstallChocoPackages} -ArgumentList $packages

#---------------------------------------------------------------------------------------------------
# Initialize the Windows Terminal configuration
#---------------------------------------------------------------------------------------------------
Write-LogMessage -Message "Initializing the Windows Terminal configuration..."
Invoke-Command -ScriptBlock ${function:Initialize-WindowsTerminalConfig} -ErrorAction Stop

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
  Invoke-ErrorHandling -ErrorMessage "Setup completed with errors. Please check the error messages above." -ErrorRecord $_
}
