<#
.SYNOPSIS
  Updates the Modules directory in the local profile with the latest version from the GitHub repository.

.DESCRIPTION
  This function checks for updates to the Modules directory in the local profile from the GitHub repository specified in the script. It compares the hash of the local Modules directory with the hash of the Modules directory on GitHub. If updates are found, it downloads the updated Modules directory and replaces the local Modules directory with the updated one. The function provides feedback on whether the Modules directory has been updated and prompts the user to restart the shell to reflect changes.

.PARAMETER LocalPath
  Specifies the local path where the Modules directory should be updated. The default value is "$HOME\Documents\PowerShell".

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Update-LocalProfileModuleDirectory
  Checks for updates to the Modules directory in the local profile and updates the local Modules directory if changes are detected.

.NOTES
  The local profile update function is disabled by default. To enable it, uncomment the line that invokes the function at the end of the script.
#>
function Update-LocalProfileModuleDirectory {
  [CmdletBinding()]
  [Alias("update-local-module")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$LocalPath = "$HOME\Documents\PowerShell"
  )

  if (-not $global:CanConnectToGitHub) {
    Write-LogMessage -Message "Skipping profile update check due to GitHub.com not responding within 1 second." -Level "WARNING"
    return
  }

  try {
    $baseRepoUrl = "https://github.com/MKAbuMattar/powershell-profile"
    $moduleDirUrl = "$baseRepoUrl/raw/main/Module"

    $localModuleDir = Join-Path -Path $LocalPath -ChildPath "Module"
    if (-not (Test-Path -Path $localModuleDir)) {
      New-Item -Path $localModuleDir -ItemType Directory -Force
      Write-LogMessage -Message "Created directory: $localModuleDir"
    }

    $files = @(
      "Directory/Directory.psd1",
      "Directory/Directory.psm1",
      "Docs/Docs.psd1",
      "Docs/Docs.psm1",
      "Environment/Environment.psd1",
      "Environment/Environment.psm1",
      "Logging/Logging.psd1",
      "Logging/Logging.psm1",
      "Network/Network.psd1",
      "Network/Network.psm1",
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
          Invoke-WebRequest -Uri $fileUrl -OutFile $tempFilePath
          $remoteFileHash = Get-FileHash -Path $tempFilePath

          if ($localFileHash.Hash -eq $remoteFileHash.Hash) {
            Write-LogMessage -Message "File $file is already up-to-date."
            $downloadFile = $false
          }
          else {
            Write-LogMessage -Message "Removing existing file: $localFilePath"
            Remove-Item -Path $localFilePath -Force
          }

          Remove-Item -Path $tempFilePath -Force
        }
        catch {
          Invoke-ErrorHandling -ErrorMessage "Failed to compare hashes for $file." -ErrorRecord $_
        }
      }

      if ($downloadFile) {
        Invoke-WebRequest -Uri $fileUrl -OutFile $localFilePath
        Write-LogMessage -Message "Copied $file to: $localFilePath"
      }
    }
  }
  catch {
    Invoke-ErrorHandling -ErrorMessage "Failed to copy Module directory from the repository." -ErrorRecord $_
  }
}

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
function Update-Profile {
  [CmdletBinding()]
  [Alias("update-profile")]
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
function Update-PowerShell {
  [CmdletBinding()]
  [Alias("update-ps1")]
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
