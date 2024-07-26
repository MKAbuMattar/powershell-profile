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

.ALIASES
    update-profile -> Use the alias `update-profile` to quickly check for updates to the PowerShell profile.

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

.ALIASES
    update-ps1 -> Use the alias `update-ps1` to quickly check for updates to PowerShell.

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
