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
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------


function Update-LocalProfileModuleDirectory {
    <#
    .SYNOPSIS
        Updates the local Module directory from the repository.

    .DESCRIPTION
        Downloads the repository as a single tarball and replaces the local Module tree with the
        copy it contains.

        The previous implementation walked the GitHub Contents API directory by directory, then
        downloaded every one of roughly 135 module files to a temporary path purely to compare
        hashes. That is well over a hundred HTTP requests per check, against an unauthenticated
        rate limit of 60 per hour, so in practice it exhausted the limit and then reported failures
        for the remainder of the hour.

        One archive request replaces all of it. When the profile lives in a git clone, use
        `git pull` instead: this function is for installs made by setup.ps1, which are not clones.

        The existing Module directory is moved aside before the new one is put in place, so a
        failed download cannot leave a half-updated tree.

    .PARAMETER LocalPath
        Directory holding the Module tree. Defaults to the profile directory.

    .PARAMETER Branch
        Repository branch to fetch. Defaults to main.

    .INPUTS
        [string] A path.

    .OUTPUTS
        None.

    .NOTES
        Automatic invocation is off by default. Set $global:AutoUpdateProfile = $true to enable it.

    .EXAMPLE
        Update-LocalProfileModuleDirectory
        Refreshes the Module directory from the main branch.

    .EXAMPLE
        Update-LocalProfileModuleDirectory -WhatIf
        Reports what would be replaced without downloading anything.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("update-local-module")]
    [OutputType([void])]
    param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$LocalPath = (Split-Path -Parent $PROFILE),

        [Parameter(Position = 1)]
        [string]$Branch = 'main'
    )

    process {
        if (-not (Test-GitHubConnection)) {
            Write-LogMessage -Message "Skipping module update because github.com did not respond within 1 second." -Level "WARNING"
            return
        }

        $gitDirectory = Join-Path $LocalPath '.git'
        if (Test-Path -LiteralPath $gitDirectory) {
            Write-LogMessage -Message "$LocalPath is a git clone. Use 'git pull' rather than this function." -Level "WARNING"
            return
        }

        $targetModule = Join-Path $LocalPath 'Module'

        # Checked before the download so a dry run stays free of side effects, network included.
        if (-not $PSCmdlet.ShouldProcess($targetModule, 'Replace with the copy from the repository')) {
            return
        }

        $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-update-" + [guid]::NewGuid().ToString('N'))
        $archive = "$workspace.tar.gz"

        try {
            $null = New-Item -ItemType Directory -Path $workspace -Force

            $url = "https://codeload.github.com/MKAbuMattar/powershell-profile/tar.gz/refs/heads/$Branch"
            Write-LogMessage -Message "Downloading $Branch as a single archive..."
            Invoke-WebRequest -Uri $url -OutFile $archive -UseBasicParsing

            # tar ships with Windows 10 1803 and later, and with every supported PowerShell host.
            & tar -xzf $archive -C $workspace
            if ($LASTEXITCODE -ne 0) {
                throw "tar exited with code $LASTEXITCODE while extracting the archive."
            }

            $extracted = Get-ChildItem -LiteralPath $workspace -Directory | Select-Object -First 1
            if (-not $extracted) {
                throw "The archive did not contain the expected directory."
            }

            $sourceModule = Join-Path $extracted.FullName 'Module'
            if (-not (Test-Path -LiteralPath $sourceModule)) {
                throw "The archive did not contain a Module directory."
            }

            # Move the old tree aside rather than deleting it, so a failure here is recoverable.
            if (Test-Path -LiteralPath $targetModule) {
                $backup = "$targetModule.old"
                if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }
                Move-Item -LiteralPath $targetModule -Destination $backup -Force
            }

            Copy-Item -LiteralPath $sourceModule -Destination $targetModule -Recurse -Force

            $count = @(Get-ChildItem -LiteralPath $targetModule -Recurse -File).Count
            Write-LogMessage -Message "Module directory updated ($count files). Restart your shell to reflect changes." -Level "INFO"
        }
        catch {
            Invoke-ErrorHandling -ErrorMessage "Failed to update the Module directory from the repository." -ErrorRecord $_
        }
        finally {
            Remove-Item -LiteralPath $workspace -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue
        }
    }
}

function Get-ForeignProfileSection {
    <#
    .SYNOPSIS
        Extracts blocks that another installer injected into a profile file.

    .DESCRIPTION
        Microsoft coreutils appends a marked block to Microsoft.PowerShell_profile.ps1 to install
        its GNU tool shims, and records the profile path under
        HKLM:\SOFTWARE\Microsoft\coreutils\PowerShellProfiles so it can clean up later.

        Update-Profile used to overwrite $PROFILE wholesale, which deleted that block while
        leaving the registry entry pointing at a file that no longer contained it. This finds any
        such block so it can be carried across an update.

        A section is recognised by a line containing "DO NOT MODIFY" and an owner name, and runs
        to the end of the file. That is the shape coreutils uses.

    .PARAMETER Path
        The profile file to inspect.

    .INPUTS
        None.

    .OUTPUTS
        [string] The foreign section including its marker line, or an empty string.

    .EXAMPLE
        Get-ForeignProfileSection -Path $PROFILE
        Returns the coreutils block, if one is present.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) { return '' }

    $lines = @(Get-Content -LiteralPath $Path)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*#\s*DO NOT MODIFY') {
            return ($lines[$i..($lines.Count - 1)] -join [Environment]::NewLine)
        }
    }

    return ''
}

function Update-Profile {
    <#
    .SYNOPSIS
        Updates the local profile from GitHub, preserving any third-party section.

    .DESCRIPTION
        Downloads Microsoft.PowerShell_profile.ps1 from the repository and installs it over the
        local copy only when the content differs.

        Two things are protected that the previous implementation destroyed:

        A symlinked $PROFILE is written through rather than replaced, so a profile linked into a
        cloned repository stays a link.

        A marked third-party block - the one Microsoft coreutils injects - is carried across and
        re-appended after the update. Without this, enabling $AutoUpdateProfile silently removed
        the coreutils shims while its registry entry still claimed they were installed.

        The previous copy is kept alongside the profile with a .bak extension.

    .PARAMETER Path
        Profile file to update. Defaults to $PROFILE.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        Update-Profile
        Updates $PROFILE if the repository copy differs.

    .EXAMPLE
        Update-Profile -WhatIf
        Reports whether an update is available without writing anything.

    .NOTES
        Automatic invocation is off by default. Set $global:AutoUpdateProfile = $true to enable it.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("update-profile")]
    [OutputType([void])]
    param (
        [Parameter(Position = 0)]
        [string]$Path = $PROFILE
    )

    if (-not (Test-GitHubConnection)) {
        Write-LogMessage -Message "Skipping profile update check because github.com did not respond within 1 second." -Level "WARNING"
        return
    }

    $url = "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $temp = Join-Path ([System.IO.Path]::GetTempPath()) "Microsoft.PowerShell_profile.$PID.ps1"

    try {
        Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing

        $incoming = Get-Content -LiteralPath $temp -Raw
        $current = if (Test-Path -LiteralPath $Path) { Get-Content -LiteralPath $Path -Raw } else { '' }

        $foreign = Get-ForeignProfileSection -Path $Path

        if ($foreign) {
            $incoming = $incoming.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $foreign + [Environment]::NewLine
        }

        if ($incoming -eq $current) {
            Write-LogMessage -Message "Profile is already up to date." -Level "INFO"
            return
        }

        if (-not $PSCmdlet.ShouldProcess($Path, 'Update profile')) { return }

        if (Test-Path -LiteralPath $Path) {
            Copy-Item -LiteralPath $Path -Destination "$Path.bak" -Force
        }

        # Set-Content writes through a symlink; Copy-Item -Force would replace the link itself.
        Set-Content -LiteralPath $Path -Value $incoming -NoNewline -Encoding UTF8

        if ($foreign) {
            Write-LogMessage -Message "Preserved a third-party section already present in the profile." -Level "INFO"
        }

        Write-LogMessage -Message "Profile updated. Previous copy saved to $Path.bak. Restart your shell to reflect changes." -Level "INFO"
    }
    catch {
        Write-LogMessage -Message "Unable to check for profile updates: $($_.Exception.Message)" -Level "WARNING"
    }
    finally {
        Remove-Item -LiteralPath $temp -ErrorAction SilentlyContinue
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

    if (-not (Test-GitHubConnection)) {
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

    process {
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
}