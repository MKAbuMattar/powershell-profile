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
# Updated: 2024-07-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 3.0.0-beta
#------------------------------------------------------

$LoggingModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Module/Logging/Logging.psm1'
Import-Module $LoggingModulePath -Force -ErrorAction SilentlyContinue

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
$AutoUpdateProfile = [bool]$false

<#
.SYNOPSIS
    Set environment variables for the PowerShell Auto Update.

.DESCRIPTION
    This environment variable determines whether the PowerShell should automatically check for updates. If set to true, it enables the PowerShell update function, which checks for updates to the PowerShell from a specified GitHub repository and updates the local PowerShell if changes are detected. Default value is false.

.EXAMPLE
    AutoUpdatePowerShell = false
    Disables the automatic update of the PowerShell.
#>
$AutoUpdatePowerShell = [bool]$false

#######################################################
# Profile Setup
#######################################################

#------------------------------------------------------
# Set the console encoding to UTF-8
#------------------------------------------------------
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#------------------------------------------------------
# Test if we can connect to GitHub
#------------------------------------------------------
$CanConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

#------------------------------------------------------
# Check if Terminal Icons module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}

#------------------------------------------------------
# Check if PowerShellGet module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PowerShellGet)) {
    Install-Module -Name PowerShellGet -Scope CurrentUser -Force -SkipPublisherCheck
}

#------------------------------------------------------
# Check if CompletionPredictor module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name CompletionPredictor)) {
    Install-Module -Name CompletionPredictor -Scope CurrentUser -Force -SkipPublisherCheck
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
Import-Module -Name PowerShellGet
Import-Module -Name CompletionPredictor
Import-Module -Name PSReadLine
Import-Module -Name Posh-Git

#------------------------------------------------------
# Set the PSReadLine options and key handlers
#------------------------------------------------------
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadLineKeyHandler -Chord '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        # Insert matching quotes, move cursor to be in between the quotes
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

<#
.SYNOPSIS
    Invokes the Starship module transiently to load the Starship prompt.

.DESCRIPTION
    This function transiently invokes the Starship module to load the Starship prompt, which enhances the appearance and functionality of the PowerShell prompt. It ensures that the Starship prompt is loaded dynamically without permanently modifying the PowerShell environment.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Invoke-Starship-TransientFunction
    Invokes the Starship module transiently to load the Starship prompt.

.ALIASES
    starship-transient -> Use the alias `starship-transient` to quickly load the Starship prompt transiently.

.NOTES
    This function is used to load the Starship prompt transiently without permanently modifying the PowerShell environment.
#>
function Invoke-StarshipTransientFunction {
    [CmdletBinding()]
    [Alias("starship-transient")]
    param (
        # This function does not accept any parameters
    )

    &starship module character
}

#------------------------------------------------------
# Invoke Starship Transient Function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-StarshipTransientFunction} -ErrorAction SilentlyContinue

#------------------------------------------------------
# Load Starship
#------------------------------------------------------
Invoke-Expression (&starship init powershell)

#------------------------------------------------------
# Set Chocolatey Profile
#------------------------------------------------------
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

#------------------------------------------------------
# Import Chocolatey Profile
#------------------------------------------------------
if (Test-Path $ChocolateyProfile) {
    Import-Module $ChocolateyProfile
}

#------------------------------------------------------
# Load zoxide
#------------------------------------------------------
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#------------------------------------------------------
# Load the profile for the current user
#------------------------------------------------------

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

#------------------------------------------------------
# Invoke the profile update function
#------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true) {
    Invoke-Command -ScriptBlock ${function:Update-Profile} -ErrorAction SilentlyContinue
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

#------------------------------------------------------
# Invoke the PowerShell update function
#------------------------------------------------------
if ($global:AutoUpdatePowerShell -eq $true) {
    Invoke-Command -ScriptBlock ${function:Update-PowerShell} -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
    Checks if a command exists in the current environment.

.DESCRIPTION
    This function checks whether a specified command exists in the current PowerShell environment. It returns a boolean value indicating whether the command is available.

.PARAMETER command
    Specifies the command to check for existence.

.OUTPUTS
    $exists: True if the command exists, false otherwise.

.EXAMPLE
    Test-CommandExists "ls"
    Checks if the "ls" command exists in the current environment.
#>
function Test-CommandExists {
    [CmdletBinding()]
    [Alias("command-exists")]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$command
    )

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

#######################################################
# Utility Functions
#######################################################

<#
.SYNOPSIS
    Creates a new empty file or updates the timestamp of an existing file with the specified name.

.DESCRIPTION
    This function serves a dual purpose: it can create a new empty file with the specified name, or if a file with the same name already exists, it updates the timestamp of that file to reflect the current time. This operation is particularly useful in scenarios where you want to ensure a file's existence or update its timestamp without modifying its content. The function utilizes the Out-File cmdlet to achieve this.

.PARAMETER File
    Specifies the name of the file to create or update. If the file already exists, its timestamp will be updated.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Set-FreshFile "file.txt"
    Creates a new empty file named "file.txt" if it doesn't exist. If "file.txt" already exists, its timestamp is updated.

.EXAMPLE
    Set-FreshFile "existing_file.txt"
    Updates the timestamp of the existing file named "existing_file.txt" without modifying its content.

.ALIASES
    touch -> Use the alias `touch` to quickly create a new file or update the timestamp of an existing file.

.NOTES
    This function can be used as an alias "touch" to quickly create a new file or update the timestamp of an existing file.
#>
function Set-FreshFile {
    [CmdletBinding()]
    [Alias("touch")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$File
    )

    # Check if the file exists
    if (Test-Path $File) {
        # If the file exists, update its timestamp
        (Get-Item $File).LastWriteTime = Get-Date
    }
    else {
        # If the file doesn't exist, create it with an empty content
        "" | Out-File $File -Encoding ASCII
    }
}

<#
.SYNOPSIS
    Finds files matching a specified name pattern in the current directory and its subdirectories.

.DESCRIPTION
    This function searches for files that match the specified name pattern in the current directory and its subdirectories. It returns the full path of each file found. If no matching files are found, it does not output anything.

.PARAMETER Name
    Specifies the name pattern to search for. You can use wildcard characters such as '*' and '?' to represent multiple characters or single characters in the file name.

.OUTPUTS None
    This function does not return any output directly. It writes the full paths of matching files to the pipeline.

.EXAMPLE
    Find-Files "file.txt"
    Searches for files matching the pattern "file.txt" and returns their full paths.

.EXAMPLE
    Find-Files "*.ps1"
    Searches for files with the extension ".ps1" and returns their full paths.

.ALIASES
    ff -> Use the alias `ff` to quickly find files matching a name pattern.

.NOTES
    This function is useful for quickly finding files that match a specific name pattern in the current directory and its subdirectories.
#>
function Find-Files {
    [CmdletBinding()]
    [Alias("ff")]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name
    )

    # Search for files matching the specified name pattern
    Get-ChildItem -Recurse -Filter $Name -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output $_.FullName
    }
}

<#
.SYNOPSIS
    Retrieves the system uptime in a human-readable format.

.DESCRIPTION
    This function retrieves the system uptime in a human-readable format. It provides information about how long the system has been running since the last boot.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The system uptime in a human-readable format.

.EXAMPLE
    Get-Uptime
    Retrieves the system uptime.

.ALIASES
    uptime -> Use the alias `uptime` to quickly get the system uptime.

.NOTES
    This function is useful for checking how long the system has been running since the last boot.
#>
function Get-Uptime {
    [CmdletBinding()]
    [Alias("uptime")]
    param (
        # This function does not accept any parameters
    )

    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject Win32_OperatingSystem | ForEach-Object {
            $uptime = (Get-Date) - $_.ConvertToDateTime($_.LastBootUpTime)
            [PSCustomObject]@{
                Uptime = $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds -join ':'
            }
        }
    }
    else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

<#
.SYNOPSIS
    Reloads the PowerShell profile to apply changes.

.DESCRIPTION
    This function reloads the current PowerShell profile to apply any changes made to it. It is useful for immediately applying modifications to the profile without restarting the shell.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Invoke-ProfileReload
    Reloads the PowerShell profile.

.ALIASES
    reload-profile -> Use the alias `reload-profile` to quickly reload the profile.

.NOTES
    This function is useful for quickly reloading the PowerShell profile to apply changes without restarting the shell.
#>
function Invoke-ProfileReload {
    [CmdletBinding()]
    [Alias("reload-profile")]
    param (
        # This function does not accept any parameters
    )

    try {
        & $profile
        Write-LogMessage -Message "PowerShell profile reloaded successfully." -Level "INFO"
    }
    catch {
        Write-LogMessage -Message "Failed to reload the PowerShell profile." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Extracts a file to the current directory.

.DESCRIPTION
    This function extracts the specified file to the current directory using the Expand-Archive cmdlet.

.PARAMETER File
    Specifies the file to extract.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Expand-File "file.zip"
    Extracts the file "file.zip" to the current directory.

.ALIASES
    unzip -> Use the alias `unzip` to quickly extract a file.

.NOTES
    This function is useful for quickly extracting files to the current directory.
#>
function Expand-File {
    [CmdletBinding()]
    [Alias("unzip")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$File
    )

    BEGIN {
        Write-LogMessage -Message "Starting file extraction process..." -Level "INFO"
    }

    PROCESS {
        try {
            Write-LogMessage -Message "Extracting file '$File' to '$PWD'..." -Level "INFO"
            $FullFilePath = Get-Item -Path $File -ErrorAction Stop | Select-Object -ExpandProperty FullName
            Expand-Archive -Path $FullFilePath -DestinationPath $PWD -Force -ErrorAction Stop
            Write-LogMessage -Message "File extraction completed successfully." -Level "INFO"
        }
        catch {
            Write-LogMessage -Message "Failed to extract file '$File'." -Level "ERROR"
        }
    }

    END {
        if (-not $Error) {
            Write-LogMessage -Message "File extraction process completed." -Level "INFO"
        }
    }
}

<#
.SYNOPSIS
    Searches for a string in a file and returns matching lines.

.DESCRIPTION
    This function searches for a specified string or regular expression pattern in a file or files within a directory. It returns the lines that contain the matching string or pattern. It is useful for finding occurrences of specific patterns in text files.

.PARAMETER Pattern
    Specifies the string or regular expression pattern to search for.

.PARAMETER Path
    Specifies the path to the file or directory to search in. If not provided, the function searches in the current directory.

.OUTPUTS
    The lines in the file(s) that match the specified string or regular expression pattern.

.EXAMPLE
    Get-ContentMatching "pattern" "file.txt"
    Searches for occurrences of the pattern "pattern" in the file "file.txt" and returns matching lines.

.ALIASES
    grep -> Use the alias `grep` to quickly search for a string in a file.
#>
function Get-ContentMatching {
    [CmdletBinding()]
    [Alias("grep")]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Pattern,

        [Parameter(Position = 1)]
        [string]$Path = $PWD
    )

    try {
        if (-not (Test-Path $Path)) {
            Write-LogMessage -Message "The specified path '$Path' does not exist." -Level "WARNING"
            return
        }

        if (Test-Path $Path -PathType Leaf) {
            Get-Content $Path | Select-String $Pattern
        }
        elseif (Test-Path $Path -PathType Container) {
            Get-ChildItem -Path $Path -File | ForEach-Object {
                Get-Content $_.FullName | Select-String $Pattern
            }
        }
        else {
            Write-LogMessage -Message "The specified path '$Path' is neither a file nor a directory." -Level "WARNING"
        }
    }
    catch {
        Write-LogMessage -Message "An error occurred while searching for the pattern." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Retrieves volume information for all available volumes.

.DESCRIPTION
    This function retrieves information about all available volumes on the system. It provides details such as volume label, drive letter, file system, and capacity.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The volume information for all available volumes.

.EXAMPLE
    Get-VolumeInfo
    Retrieves volume information for all available volumes.

.ALIASES
    df -> Use the alias `df` to quickly get volume information.
#>
function Get-VolumeInfo {
    [CmdletBinding()]
    [Alias("df")]
    param(
        # This function does not accept any parameters
    )

    try {
        Get-Volume
    }
    catch {
        Write-LogMessage -Message "An error occurred while retrieving volume information." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Searches for a string in a file and replaces it with another string.

.DESCRIPTION
    This function searches for a specified string in a file and replaces it with another string. It is useful for performing text replacements in files.

.PARAMETER file
    Specifies the file to search and perform replacements in.

.PARAMETER find
    Specifies the string to search for.

.PARAMETER replace
    Specifies the string to replace the found string with.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-ContentMatching "file.txt" "pattern" "replacement"
    Searches for "pattern" in "file.txt" and replaces it with "replacement".

.ALIASES
    sed -> Use the alias `sed` to quickly perform text replacements.
#>
function Set-ContentMatching {
    [CmdletBinding()]
    [Alias("sed")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$file,

        [Parameter(Mandatory = $true)]
        [string]$find,

        [Parameter(Mandatory = $true)]
        [string]$replace
    )

    try {
        $content = Get-Content $file -ErrorAction Stop
        $content -replace $find, $replace | Set-Content $file -ErrorAction Stop
    }
    catch {
        Write-LogMessage -Message "An error occurred while performing text replacement." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Gets the definition of a command.

.DESCRIPTION
    This function retrieves the definition of a specified command. It is useful for understanding the functionality and usage of PowerShell cmdlets and functions.

.PARAMETER name
    Specifies the name of the command to retrieve the definition for.

.OUTPUTS
    The definition of the specified command.

.EXAMPLE
    Get-CommandDefinition "ls"
    Retrieves the definition of the "ls" command.

.ALIASES
    def -> Use the alias `def` to quickly get the definition of a command.
#>
function Get-CommandDefinition {
    [CmdletBinding()]
    [Alias("def")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$name
    )

    try {
        $definition = Get-Command $name -ErrorAction Stop | Select-Object -ExpandProperty Definition
        if ($definition) {
            Write-Output $definition
        }
        else {
            Write-LogMessage -Message "Command '$name' not found." -Level "WARNING"
        }
    }
    catch {
        Write-LogMessage -Message "An error occurred while retrieving the definition of '$name'." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Exports an environment variable.

.DESCRIPTION
    This function exports an environment variable with the specified name and value. It sets the specified environment variable with the provided value.

.PARAMETER name
    Specifies the name of the environment variable.

.PARAMETER value
    Specifies the value of the environment variable.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-EnvVar "name" "value"
    Exports an environment variable named "name" with the value "value".

.ALIASES
    env-var -> Use the alias `env-var` to quickly export an environment variable.
#>
function Set-EnvVar {
    [CmdletBinding()]
    [Alias("env-var")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$name,

        [Parameter(Mandatory = $true)]
        [string]$value
    )

    try {
        Set-Item -Force -Path "env:$name" -Value $value -ErrorAction Stop
    }
    catch {
        Write-LogMessage -Message "Failed to export environment variable '$name'." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Retrieves a list of all running processes.

.DESCRIPTION
    This function retrieves information about all running processes on the system. It provides details such as the process name, ID, CPU usage, and memory usage.

.PARAMETER Name
    Specifies the name of a specific process to retrieve information for. If not provided, information for all processes is retrieved.

.OUTPUTS
    The process information for all running processes.

.EXAMPLE
    Get-AllProcesses
    Retrieves information about all running processes.

.ALIASES
    pall -> Use the alias `pall` to quickly get information about all running processes.
#>
function Get-AllProcesses {
    [CmdletBinding()]
    [Alias("pall")]
    param (
        [Parameter(Mandatory = $false)]
        [string]$name
    )

    try {
        if ($name) {
            Get-Process $name -ErrorAction Stop
        }
        else {
            Get-Process
        }
    }
    catch {
        Write-LogMessage -Message "Failed to retrieve process information." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Finds a process by name.

.DESCRIPTION
    This function searches for a process by its name. It retrieves information about the specified process, if found.

.PARAMETER name
    Specifies the name of the process to find.

.OUTPUTS
    The process information if found.

.EXAMPLE
    Get-ProcessByName "process"
    Retrieves information about the process named "process".

.ALIASES
    pgrep -> Use the alias `pgrep` to quickly find a process by name.
#>
function Get-ProcessByName {
    [CmdletBinding()]
    [Alias("pgrep")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$name
    )

    try {
        Get-Process $name -ErrorAction Stop
    }
    catch {
        Write-Warning "No process with the name '$name' found."
    }
}

<#
.SYNOPSIS
    Terminates a process by name.

.DESCRIPTION
    This function terminates a process by its name. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER name
    Specifies the name of the process to terminate.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Stop-ProcessByName "process"
    Terminates the process named "process".

.ALIASES
    pkill -> Use the alias `pkill` to quickly stop a process by name.
#>
function Stop-ProcessByName {
    [CmdletBinding()]
    [Alias("pkill")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$name
    )

    $process = Get-Process $name -ErrorAction SilentlyContinue
    if ($process) {
        $process | Stop-Process -Force
    }
    else {
        Write-LogMessage -Message "No process with the name '$name' found." -Level "WARNING"
    }
}
