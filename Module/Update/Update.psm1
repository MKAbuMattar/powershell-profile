#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Update Module
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
#       This Module provides functions to update the PowerShell profile and
#       its modules from the GitHub repository.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Update-LocalProfileModuleDirectory {
    <#
    .SYNOPSIS
        Updates the Modules directory in the local profile with the latest version from the GitHub repository.

    .DESCRIPTION
        This function checks for updates to the Modules directory in the local profile from the GitHub repository specified in the script. It compares the hash of the local Modules directory with the hash of the Modules directory on GitHub. If updates are found, it downloads the updated Modules directory and replaces the local Modules directory with the updated one. The function provides feedback on whether the Modules directory has been updated and prompts the user to restart the shell to reflect changes.

    .PARAMETER LocalPath
        Specifies the local path where the Modules directory should be updated. The default value is "$HOME\Documents\PowerShell".

    .INPUTS
        LocalPath: (Required) Specifies the local path where the Modules directory should be updated.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        The local profile update function is disabled by default. To enable it, uncomment the line that invokes the function at the end of the script.

    .EXAMPLE
        Update-LocalProfileModuleDirectory
        Checks for updates to the Modules directory in the local profile and updates the local Modules directory if changes are detected.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("update-local-module")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Specifies the local path where the Modules directory should be updated."
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
                if ($item.type -eq "file" -and ($item.name -match "\.(psd1|psm1|py)$")) {
                    Write-LogMessage -Message "Found PowerShell module file: $($item.path)"
                    if ($item.download_url -and $item.download_url.Trim() -ne "" -and $item.path -and $item.path.Trim() -ne "") {
                        $files += @{
                            Path        = $item.path
                            DownloadUrl = $item.download_url
                        }
                    }
                    else {
                        Write-LogMessage -Message "Warning: Invalid download URL or path for file $($item.path)" -Level "WARNING"
                    }
                }
                elseif ($item.type -eq "dir") {
                    Write-LogMessage -Message "Found subdirectory: $($item.path), recursing..."
                    $subFiles = Get-GitHubDirectoryFiles -Owner $Owner -Repo $Repo -Path $item.path -Branch $Branch
                    if ($subFiles -and $subFiles.Count -gt 0) {
                        foreach ($subFile in $subFiles) {
                            if ($subFile.Path -and $subFile.DownloadUrl) {
                                $files += $subFile
                            }
                        }
                    }
                }
            }

            return $files
        }
        catch {
            Write-LogMessage -Message "Failed to get directory contents for $Path`: $($_.Exception.Message)" -Level "ERROR"
            return @()
        }
    }

    if (-not $global:CanConnectToGitHub) {
        Write-LogMessage -Message "Skipping profile update check due to GitHub.com not responding within 1 second." -Level "WARNING"
        return
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

        Write-LogMessage -Message "Found $($moduleFiles.Count) PowerShell module files to update."

        foreach ($fileInfo in $moduleFiles) {
            $relativePath = $fileInfo.Path -replace "^Module/", ""
            $localFilePath = Join-Path -Path $localModuleDir -ChildPath $relativePath

            $localFileDir = Split-Path -Path $localFilePath -Parent
            if (-not (Test-Path -Path $localFileDir)) {
                New-Item -Path $localFileDir -ItemType Directory -Force
                Write-LogMessage -Message "Created directory: $localFileDir"
            }

            $downloadFile = $true

            if (Test-Path -Path $localFilePath) {
                try {
                    $localFileHash = Get-FileHash -Path $localFilePath
                    $tempFilePath = [System.IO.Path]::GetTempFileName()
                    Invoke-WebRequest -Uri $fileInfo.DownloadUrl -OutFile $tempFilePath
                    $remoteFileHash = Get-FileHash -Path $tempFilePath

                    if ($localFileHash.Hash -eq $remoteFileHash.Hash) {
                        Write-LogMessage -Message "File $relativePath is already up-to-date."
                        $downloadFile = $false
                    }
                    else {
                        Write-LogMessage -Message "File $relativePath has changed, updating..."
                        Remove-Item -Path $localFilePath -Force
                    }

                    Remove-Item -Path $tempFilePath -Force
                }
                catch {
                    Write-LogMessage -Message "Failed to compare hashes for $relativePath`: $($_.Exception.Message)" -Level "ERROR"
                }
            }

            if ($downloadFile) {
                try {
                    Invoke-WebRequest -Uri $fileInfo.DownloadUrl -OutFile $localFilePath
                    Write-LogMessage -Message "Updated $relativePath to: $localFilePath"
                }
                catch {
                    Write-LogMessage -Message "Failed to download $($fileInfo.Path)`: $($_.Exception.Message)" -Level "ERROR"
                }
            }
        }
    }
    catch {
        Invoke-ErrorHandling -ErrorMessage "Failed to update Module directory from the repository." -ErrorRecord $_
    }
    finally {
        Write-LogMessage -Message "Module directory update check completed. Please restart your shell to reflect changes." -Level "INFO"
    }
}

function Update-Profile {
    <#
    .SYNOPSIS
        Checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected.

    .DESCRIPTION
        This function checks for updates to the PowerShell profile from the GitHub repository specified in the script. It compares the hash of the local profile with the hash of the profile on GitHub. If updates are found, it downloads the updated profile and replaces the local profile with the updated one. The function provides feedback on whether the profile has been updated and prompts the user to restart the shell to reflect changes.

    .PARAMETER None
        This function does not accept any parameters.

    .OUTPUTS
        This function does not return any output.

    .EXAMPLE
        Update-Profile
        Checks for updates to the PowerShell profile and updates the local profile if changes are detected.

    .NOTES
        The profile update function is disabled by default. To enable it, uncomment the line that invokes the function at the end of the script.
    #>
    [CmdletBinding()]
    [Alias("update-profile")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    if (-not $global:CanConnectToGitHub) {
        Write-LogMessage -Message "Skipping profile update check due to GitHub.com not responding within 1 second." -Level "WARNING"
        return
    }

    try {
        $url = "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
        $oldhash = Get-FileHash $PROFILE
        Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
        $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
        if ($newhash.Hash -ne $oldhash.Hash) {
            Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
            Write-LogMessage -Message "Profile has been updated. Please restart your shell to reflect changes" -Level "INFO"
        }
    }
    catch {
        Write-LogMessage -Message "Unable to check for `$profile updates" -Level "WARNING"
    }
    finally {
        Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
    }
}

function Update-PowerShell {
    <#
    .SYNOPSIS
        Checks for updates to PowerShell and upgrades to the latest version if available.

    .DESCRIPTION
        This function checks for updates to PowerShell by querying the GitHub releases. If updates are found, it upgrades PowerShell to the latest version using the Windows Package Manager (winget). It provides information about the update process and whether the system is already up to date.

    .PARAMETER None
        This function does not accept any parameters.

    .OUTPUTS
        This function does not return any output.

    .EXAMPLE
        Update-PowerShell
        Checks for updates to PowerShell and upgrades to the latest version if available.

    .NOTES
        The PowerShell update function is disabled by default. To enable it, uncomment the line that invokes the function at the end of the script.
    #>
    [CmdletBinding()]
    [Alias("update-ps1")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    if (-not $global:CanConnectToGitHub) {
        Write-LogMessage -Message "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -Level "WARNING"
        return
    }

    try {
        Write-LogMessage -Message "Checking for PowerShell updates..." -Level "INFO"
        $updateNeeded = $false
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
        $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
        if ($currentVersion -lt $latestVersion) {
            $updateNeeded = $true
        }

        if ($updateNeeded) {
            Write-LogMessage -Message "Updating PowerShell..." -Level "INFO"
            choco upgrade powershell -y
            Write-LogMessage -Message "PowerShell has been updated. Please restart your shell to reflect changes" -Level "INFO"
        }
        else {
            Write-LogMessage -Message "Your PowerShell is up to date." -Level "INFO"
        }
    }
    catch {
        Write-LogMessage -Message "Failed to update PowerShell" -Level "WARNING"
    }
}

function Update-WindowsTerminalConfig {
    <#
    .SYNOPSIS
        Update the Windows Terminal configuration by downloading the settings.json file from the GitHub repository.

    .DESCRIPTION
        This function update the Windows Terminal configuration by downloading the settings.json file from the GitHub repository and saving it to the appropriate location. If the destination file already exists, it will be overwritten.

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
        Update-WindowsTerminalConfig
        Update the Windows Terminal configuration by downloading the settings.json file from the GitHub repository.

    .NOTES
        This function is used to update the Windows Terminal configuration by downloading the settings.json file from the GitHub repository.
    #>
    [CmdletBinding()]
    [Alias("update-terminal-config")]
    [OutputType([void])]
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
