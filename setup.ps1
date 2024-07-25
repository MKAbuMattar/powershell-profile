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
# Updated: 2024-07-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 3.0.0-beta
#------------------------------------------------------

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

.EXAMPLE
    Write-LogMessage -Message "This is a warning message." -Level "WARNING"
    Logs a warning message with the log level "WARNING".
#>
Function Write-LogMessage {
    [CmdletBinding()]
    param (
        [string]$Message,
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
#>
Function Invoke-ErrorHandling {
    [CmdletBinding()]
    param (
        [string]$ErrorMessage,
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    Write-LogMessage -Message "$ErrorMessage`n$($ErrorRecord.Exception.Message)" -Level "ERROR"
    break
}

#------------------------------------------------------
# Check if the script is running as an Administrator
#------------------------------------------------------
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
#>
Function Test-InternetConnection {
    [CmdletBinding()]
    param(
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

#------------------------------------------------------
# Check for internet connection before proceeding
#------------------------------------------------------
if (-not (Test-InternetConnection)) {
    break
}

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
#>
Function Initialize-PowerShellProfile {
    [CmdletBinding()]
    param(
        # This function does not accept any parameters
    )

    try {
        if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
            $profilePath = if ($PSVersionTable.PSEdition -eq "Core") {
                "$env:userprofile\Documents\Powershell"
            }
            elseif ($PSVersionTable.PSEdition -eq "Desktop") {
                "$env:userprofile\Documents\WindowsPowerShell"
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
#>
Function Initialize-StarshipConfig { 
    [CmdletBinding()]
    param(
        # This function does not accept any parameters
    )

    try {
        $configDir = "$env:USERPROFILE\.config"
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
    Installs the Cascadia Code font if it is not already installed.

.DESCRIPTION
    This function installs the Cascadia Code font if it is not already installed. The font is downloaded from the GitHub repository and installed in the Windows Fonts directory.

.OUTPUTS
    The Cascadia Code font is installed in the Windows Fonts directory.

.EXAMPLE
    Install-CascadiaCodeFont
    Installs the Cascadia Code font if it is not already installed.
#>
Function Install-CascadiaCodeFont {
    [CmdletBinding()]
    param(
        # This function does not accept any parameters
    )
    
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
        Invoke-ErrorHandling -ErrorMessage "Failed to download or install the Cascadia Code font." -ErrorRecord $_
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
#>
Function Install-Chocolatey {
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
#>
function Invoke-UpdateInstallPSModules {
    [CmdletBinding()]
    param (
        [string[]]$ModuleList
    )

    foreach ($module in $ModuleList) {
        Write-LogMessage -Message "Checking $module"
        try {
            if (-not (Find-Module -Name $module)) {
                Write-LogMessage -Message "Installing $module"
                Install-Module -Name $module -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
            }
            else {
                Write-LogMessage -Message "Updating $module"
                Update-Module -Name $module -Scope CurrentUser -Force -ErrorAction Stop
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
    This function installs or updates the required Chocolatey packages based on the provided package list. If the package is not found, it is installed; otherwise, it is updated.

.PARAMETER PackageList
    Specifies the list of packages to install or update.

.OUTPUTS
    The required packages are installed or updated.

.EXAMPLE
    Invoke-UpdateInstallChocoPackages -PackageList @("Package1", "Package2", "Package3")
    Installs or updates the packages "Package1", "Package2", and "Package3".
#>
function Invoke-UpdateInstallChocoPackages {
    [CmdletBinding()]
    param (
        [string[]]$PackageList
    )

    foreach ($package in $PackageList) {
        Write-LogMessage -Message "Checking $package"
        try {
            if (-not (Get-Package -Name $package -ErrorAction SilentlyContinue)) {
                Write-LogMessage -Message "Installing $package"
                choco install $package -y
            }
            else {
                Write-LogMessage -Message "Updating $package"
                choco upgrade $package -y
            }
        }
        catch {
            Invoke-ErrorHandling -ErrorMessage "Failed to process package $package." -ErrorRecord $_
        }
    }
}

#------------------------------------------------------
# Start the setup process
#------------------------------------------------------
Write-LogMessage -Message "Starting the setup process..."

#------------------------------------------------------
# Initialize the PowerShell profile
#------------------------------------------------------
Write-LogMessage -Message "Initializing the PowerShell profile..."
Invoke-Command -ScriptBlock ${Function:Initialize-PowerShellProfile} -ErrorAction Stop

#------------------------------------------------------
# Initialize the Starship configuration
#------------------------------------------------------
Write-LogMessage -Message "Initializing the Starship configuration..."
Invoke-Command -ScriptBlock ${Function:Initialize-StarshipConfig} -ErrorAction Stop

#------------------------------------------------------
# Install the Cascadia Code font
#------------------------------------------------------
Write-LogMessage -Message "Installing the Cascadia Code font..."
Invoke-Command -ScriptBlock ${Function:Install-CascadiaCodeFont} -ErrorAction Stop

#------------------------------------------------------
# Install Chocolatey package manager
#------------------------------------------------------
Write-LogMessage -Message "Installing Chocolatey..."
Invoke-Command -ScriptBlock ${Function:Install-Chocolatey} -ErrorAction Stop

#------------------------------------------------------
# Install or update required PowerShell modules
#------------------------------------------------------
Write-LogMessage -Message "Installing or updating required PowerShell modules..."
$modules = @('Terminal-Icons', 'PowerShellGet', 'PSReadLine', 'Posh-Git', 'CompletionPredictor')
Invoke-Command -ScriptBlock ${Function:Invoke-UpdateInstallPSModules} -ArgumentList $modules -ErrorAction Stop

#------------------------------------------------------
# Install or update required Chocolatey packages
#------------------------------------------------------
Write-LogMessage -Message "Installing or updating required Chocolatey packages..."
$packages = @('starship', 'microsoft-windows-terminal', 'powershell-core')
Invoke-UpdateInstallChocoPackages -PackageList $packages

#------------------------------------------------------
# End the setup process
#------------------------------------------------------
Write-LogMessage -Message "Setup process completed successfully."

#------------------------------------------------------
# Check if the setup completed successfully
#------------------------------------------------------
if ((Test-Path -Path $PROFILE) -and ($fontFamilies -contains "CaskaydiaCove NF")) {
    Write-LogMessage -Message "Setup completed successfully. Please restart your PowerShell session to apply changes."
}
else {
    Write-LogMessage -Message "Setup completed with errors. Please check the error messages above." -Level "WARNING"
}
