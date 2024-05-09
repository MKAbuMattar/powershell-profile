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
# Updated: 2024-05-09
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 1.5.0
#------------------------------------------------------

######################################################
# Profile Setup
######################################################

#------------------------------------------------------
# Set the console encoding to UTF-8
#------------------------------------------------------
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#------------------------------------------------------
# Test if we can connect to GitHub
#------------------------------------------------------
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

#------------------------------------------------------
# Check if Terminal Icons module is installed
#------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
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
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

<#
.SYNOPSIS
    Invokes the Starship module transiently to load the Starship prompt.

.DESCRIPTION
    This function transiently invokes the Starship module to load the Starship prompt, which enhances the appearance and functionality of the PowerShell prompt. It ensures that the Starship prompt is loaded dynamically without permanently modifying the PowerShell environment.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Invoke-Starship-TransientFunction
    Invokes the Starship module transiently to load the Starship prompt.
#>
function Private:Invoke-Starship-TransientFunction {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  &starship module character
}

#------------------------------------------------------
# Invoke Starship Transient Function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-Starship-TransientFunction} -ErrorAction SilentlyContinue

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

<#
.SYNOPSIS
    Checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected.

.DESCRIPTION
    This function checks for updates to the PowerShell profile from the GitHub repository specified in the script. It compares the hash of the local profile with the hash of the profile on GitHub. If updates are found, it downloads the updated profile and replaces the local profile with the updated one. The function provides feedback on whether the profile has been updated and prompts the user to restart the shell to reflect changes.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Update-Profile
    Checks for updates to the PowerShell profile and updates the local profile if changes are detected.
#>
function Private:Update-Profile {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  if (-not $global:canConnectToGitHub) {
    Write-Host "Skipping profile update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
    return
  }

  try {
    $url = "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $oldhash = Get-FileHash $PROFILE
    Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
    $newhash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
    if ($newhash.Hash -ne $oldhash.Hash) {
      Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
      Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
    }
  }
  catch {
    Write-Error "Unable to check for `$profile updates"
  }
  finally {
    Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
  }
}

#------------------------------------------------------
# Invoke the profile update function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Update-Profile} -ErrorAction SilentlyContinue

<#
.SYNOPSIS
    Checks for updates to PowerShell and upgrades to the latest version if available.

.DESCRIPTION
    This function checks for updates to PowerShell by querying the GitHub releases. If updates are found, it upgrades PowerShell to the latest version using the Windows Package Manager (winget). It provides information about the update process and whether the system is already up to date.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Update-PowerShell
    Checks for updates to PowerShell and upgrades to the latest version if available.
#>
function Private:Update-PowerShell {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  if (-not $global:canConnectToGitHub) {
    Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
    return
  }

  try {
    Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
    $updateNeeded = $false
    $currentVersion = $PSVersionTable.PSVersion.ToString()
    $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
    $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
    if ($currentVersion -lt $latestVersion) {
      $updateNeeded = $true
    }

    if ($updateNeeded) {
      Write-Host "Updating PowerShell..." -ForegroundColor Yellow
      winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
      Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
    }
    else {
      Write-Host "Your PowerShell is up to date." -ForegroundColor Green
    }
  }
  catch {
    Write-Error "Failed to update PowerShell. Error: $_"
  }
}

#------------------------------------------------------
# Invoke the PowerShell update function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Update-PowerShell} -ErrorAction SilentlyContinue

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
function Private:Test-CommandExists {
  [CmdletBinding()]
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

######################################################
# Utility Functions
######################################################

<#
.SYNOPSIS
    Creates a new empty file or updates the timestamp of an existing file with the specified name.

.DESCRIPTION
    This function serves a dual purpose: it can create a new empty file with the specified name, or if a file with the same name already exists, it updates the timestamp of that file to reflect the current time. This operation is particularly useful in scenarios where you want to ensure a file's existence or update its timestamp without modifying its content. The function utilizes the Out-File cmdlet to achieve this.

.PARAMETER File
    Specifies the name of the file to create or update. If the file already exists, its timestamp will be updated.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-FreshFile "file.txt"
    Creates a new empty file named "file.txt" if it doesn't exist. If "file.txt" already exists, its timestamp is updated.

.EXAMPLE
    Set-FreshFile "existing_file.txt"
    Updates the timestamp of the existing file named "existing_file.txt" without modifying its content.
#>
function Private:Set-FreshFile {
  [CmdletBinding()]
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

#------------------------------------------------------
# Set the alias for Set-FreshFile
#------------------------------------------------------
Set-Alias -Name touch -Value Set-FreshFile

<#
.SYNOPSIS
    Finds files matching a specified name pattern in the current directory and its subdirectories.

.DESCRIPTION
    This function searches for files that match the specified name pattern in the current directory and its subdirectories. It returns the full path of each file found. If no matching files are found, it does not output anything.

.PARAMETER Name
    Specifies the name pattern to search for. You can use wildcard characters such as '*' and '?' to represent multiple characters or single characters in the file name.

.OUTPUTS
    None. This function does not return any output directly. It writes the full paths of matching files to the pipeline.

.EXAMPLE
    Find-Files "file.txt"
    Searches for files matching the pattern "file.txt" and returns their full paths.

.EXAMPLE
    Find-Files "*.ps1"
    Searches for files with the extension ".ps1" and returns their full paths.
#>
function Private:Find-Files {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Name
  )
  
  # Search for files matching the specified name pattern
  Get-ChildItem -Recurse -Filter $Name -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Output $_.FullName
  }
}

#------------------------------------------------------
# Set the alias for Find-Files
#------------------------------------------------------
Set-Alias -Name ff -Value Find-Files

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
#>
function Private:Get-Uptime {
  [CmdletBinding()]
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

#------------------------------------------------------
# Set the alias for Get-Uptime
#------------------------------------------------------
Set-Alias -Name uptime -Value Get-Uptime

<#
.SYNOPSIS
    Reloads the PowerShell profile to apply changes.

.DESCRIPTION
    This function reloads the current PowerShell profile to apply any changes made to it. It is useful for immediately applying modifications to the profile without restarting the shell.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Invoke-ProfileReload
    Reloads the PowerShell profile.
#>
function Private:Invoke-ProfileReload {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  try {
    & $profile
    Write-Host "PowerShell profile reloaded successfully." -ForegroundColor Green
  }
  catch {
    Write-Error "Failed to reload the PowerShell profile. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for reloading the profile
#------------------------------------------------------
Set-Alias -Name reload-profile -Value Invoke-ProfileReload

<#
.SYNOPSIS
    Extracts a file to the current directory.

.DESCRIPTION
    This function extracts the specified file to the current directory using the Expand-Archive cmdlet.

.PARAMETER file
    Specifies the file to extract.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Expand-File "file.zip"
    Extracts the file "file.zip" to the current directory.
#>
function Private:Expand-File {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File
  )

  try {
    Write-Host "Extracting file '$File' to '$PWD'..." -ForegroundColor Cyan
    $FullFilePath = Get-Item -Path $File -ErrorAction Stop | Select-Object -ExpandProperty FullName
    Expand-Archive -Path $FullFilePath -DestinationPath $PWD -Force -ErrorAction Stop
    Write-Host "File extraction completed successfully." -ForegroundColor Green
  }
  catch {
    Write-Error "Failed to extract file '$File'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Expand-File
#------------------------------------------------------
Set-Alias -Name unzip -Value Expand-File

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
#>
function Private:Get-ContentMatching {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [string]$Pattern,

    [Parameter(Position = 1)]
    [string]$Path = $PWD
  )

  try {
    if (-not (Test-Path $Path)) {
      Write-Error "The specified path '$Path' does not exist."
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
      Write-Error "The specified path '$Path' is neither a file nor a directory."
    }
  }
  catch {
    Write-Error "An error occurred: $_"
  }
}

#------------------------------------------------------
# Set the alias for Get-ContentMatching
#------------------------------------------------------
Set-Alias -Name grep -Value Get-ContentMatching

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
#>
function Private:Get-VolumeInfo {
  [CmdletBinding()]
  param(
    # This function does not accept any parameters
  )

  try {
    Get-Volume
  }
  catch {
    Write-Error "An error occurred while retrieving volume information: $_"
  }
}

#------------------------------------------------------
# Set the alias for Get-VolumeInfo
#------------------------------------------------------
Set-Alias -Name df -Value Get-VolumeInfo

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

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-ContentMatching "file.txt" "pattern" "replacement"
    Searches for "pattern" in "file.txt" and replaces it with "replacement".
#>
function Private:Set-ContentMatching {
  [CmdletBinding()]
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
    Write-Error "An error occurred while performing text replacement: $_"
  }
}

#------------------------------------------------------
# Set the alias for Set-ContentMatching
#------------------------------------------------------
Set-Alias -Name sed -Value Set-ContentMatching

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
#>
function Private:Get-CommandDefinition {
  [CmdletBinding()]
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
      Write-Warning "Command '$name' not found."
    }
  }
  catch {
    Write-Error "An error occurred while retrieving the definition of '$name': $_"
  }
}

#------------------------------------------------------
# Set the alias for Get-CommandDefinition
#------------------------------------------------------
Set-Alias -Name def -Value Get-CommandDefinition

<#
.SYNOPSIS
    Exports an environment variable.

.DESCRIPTION
    This function exports an environment variable with the specified name and value. It sets the specified environment variable with the provided value.

.PARAMETER name
    Specifies the name of the environment variable.

.PARAMETER value
    Specifies the value of the environment variable.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-EnvVar "name" "value"
    Exports an environment variable named "name" with the value "value".
#>
function Private:Set-EnvVar {
  [CmdletBinding()]
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
    Write-Error "Failed to export environment variable '$name': $_"
  }
}

#------------------------------------------------------
# Set the alias for Set-EnvVar
#------------------------------------------------------
Set-Alias -Name export -Value Set-EnvVar

<#
.SYNOPSIS
    Terminates a process by name.

.DESCRIPTION
    This function terminates a process by its name. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER name
    Specifies the name of the process to terminate.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Stop-ProcessByName "process"
    Terminates the process named "process".
#>
function Private:Stop-ProcessByName {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]$name
  )

  $process = Get-Process $name -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-Warning "No process with the name '$name' found."
  }
}

#------------------------------------------------------
# Set the alias for Stop-ProcessByName
#------------------------------------------------------
Set-Alias -Name pkill -Value Stop-ProcessByName

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
#>
function Private:Get-ProcessByName {
  [CmdletBinding()]
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

#------------------------------------------------------
# Set the alias for Get-ProcessByName
#------------------------------------------------------
Set-Alias -Name pgrep -Value Get-ProcessByName

<#
.SYNOPSIS
    Gets the first n lines of a file.

.DESCRIPTION
    This function retrieves the top n lines of the specified file. It is useful for quickly viewing the beginning of log files or other large text files.

.PARAMETER Path
    Specifies the path to the file to retrieve the content from.

.PARAMETER n
    Specifies the number of lines to retrieve from the beginning of the file. The default value is 10.

.OUTPUTS
    The top n lines of the file content.

.EXAMPLE
    Get-HeadContent "file.txt" 10
    Retrieves the first 10 lines of the file "file.txt".
#>
function Private:Get-HeadContent {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path,

    [Parameter(Position = 1)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$n = 10
  )

  try {
    Get-Content -Path $Path -TotalCount $n -ErrorAction Stop
  }
  catch {
    Write-Warning "Failed to retrieve the top $n lines of '$Path'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Get-HeadContent
#------------------------------------------------------
Set-Alias -Name head -Value Get-HeadContent

<#
.SYNOPSIS
    Gets the last n lines of a file.

.DESCRIPTION
    This function retrieves the bottom n lines of the specified file. It is useful for quickly viewing the end of log files or other large text files.

.PARAMETER Path
    Specifies the path to the file to retrieve the content from.

.PARAMETER n
    Specifies the number of lines to retrieve from the end of the file. The default value is 10.

.OUTPUTS
    The bottom n lines of the file content.

.EXAMPLE
    Get-TailContent "file.txt" 10
    Retrieves the last 10 lines of the file "file.txt".
#>
function Private:Get-TailContent {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path,

    [Parameter(Position = 1)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$n = 10
  )

  try {
    Get-Content -Path $Path -Tail $n -ErrorAction Stop
  }
  catch {
    Write-Warning "Failed to retrieve the last $n lines of '$Path'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Get-TailContent
#------------------------------------------------------
Set-Alias -Name tail -Value Get-TailContent

<#
.SYNOPSIS
    Creates a new file with the specified name.

.DESCRIPTION
    This function creates a new file with the specified name in the current directory. It is a shorthand for creating a new file using the `New-Item` cmdlet.

.PARAMETER name
    Specifies the name of the file to create.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    New-File "file.txt"
    Creates a new file named "file.txt" in the current directory.
#>
function Private:New-File {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$name
  )

  try {
    New-Item -ItemType File -Path $PWD -Name $name -ErrorAction Stop | Out-Null
  }
  catch {
    Write-Warning "Failed to create file '$name'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for New-File
#------------------------------------------------------
Set-Alias -Name nf -Value New-File

<#
.SYNOPSIS
    Creates a new directory with the specified name and sets the current location to that directory.

.DESCRIPTION
    This function creates a new directory with the specified name and then changes the current working directory to that newly created directory. It is a combination of the `New-Item` and `Set-Location` cmdlets.

.PARAMETER name
    Specifies the name of the directory to create.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    New-Directory "NewDirectory"
    Creates a new directory named "NewDirectory" and changes the current location to it.
#>
function Private:New-Directory {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$name
  )

  try {
    $newDir = New-Item -Path $PWD -Name $name -ItemType Directory -ErrorAction Stop
    Set-Location -Path $newDir.FullName
  }
  catch {
    Write-Warning "Failed to create directory '$name'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for New-Directory
#------------------------------------------------------
Set-Alias -Name mkcd -Value New-Directory

<#
.SYNOPSIS
    Searches through the full command history for occurrences of a specified term.

.DESCRIPTION
    This function searches through the full command history for occurrences of the specified term. It retrieves commands that match the search term from the entire command history. The function uses the `-like` operator to perform a wildcard search.

.PARAMETER searchTerm
    Specifies the term to search for in the command history.

.OUTPUTS
    The commands from the command history that match the search term.

.EXAMPLE
    hist "command"
    Searches the full command history for occurrences of the term "command".
#>
function Private:Find-InHistory {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
    [string]$searchTerm
  )

  if (-not $searchTerm) {
    Write-Warning "Please provide a search term."
    return
  }

  Write-Host "Finding in full history using {`$_ -like `"*$searchTerm*`"}"
  Get-Content (Get-PSReadlineOption).HistorySavePath |
  Where-Object { $_ -like "*$searchTerm*" } | Select-Object -Unique | more
}

#------------------------------------------------------
# Set the alias for Find-InHistory
#------------------------------------------------------
Set-Alias -Name hist -Value Find-InHistory

######################################################
# Navigation Shortcuts
######################################################

<#
.SYNOPSIS
    Changes the current location to the root directory.

.DESCRIPTION
    This function changes the current working directory to the root directory, typically the user's home directory or the root of the filesystem.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-Home
    Changes the current location to the root directory.
#>
function Private:Set-Home {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path $HOME
}

#------------------------------------------------------
# Set the alias for Set-Home
#------------------------------------------------------
Set-Alias -Name root -Value Set-Home

<#
.SYNOPSIS
    Changes the current location to the Documents directory.

.DESCRIPTION
    This function changes the current working directory to the Documents directory, where user documents are typically stored.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-Documents
    Changes the current location to the Documents directory.
#>
function Private:Set-Documents {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path $HOME\Documents
}

#------------------------------------------------------
# Set the alias for Set-Documents
#------------------------------------------------------
Set-Alias -Name doc -Value Set-Documents

<#
.SYNOPSIS
    Changes the current location to the Downloads directory.

.DESCRIPTION
    This function changes the current working directory to the Downloads directory, where downloaded files are typically stored.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-Downloads
    Changes the current location to the Downloads directory.
#>
function Private:Set-Downloads {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path $HOME\Downloads
}

#------------------------------------------------------
# Set the alias for Set-Downloads
#------------------------------------------------------
Set-Alias -Name dl -Value Set-Downloads

<#
.SYNOPSIS
    Changes the current location to the Desktop directory.

.DESCRIPTION
    This function changes the current working directory to the Desktop directory, which is typically where user desktop files and shortcuts are stored.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-Desktop
    Changes the current location to the Desktop directory.
#>
function Private:Set-Desktop {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path $HOME\Desktop
}

#------------------------------------------------------
# Set the alias for Set-Desktop
#------------------------------------------------------
Set-Alias -Name dtop -Value Set-Desktop

<#
.SYNOPSIS
    Changes the current location to the D:\ directory.

.DESCRIPTION
    This function changes the current working directory to the D:\ directory. It is useful for quickly navigating to a specific drive.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Set-DDisk
    Changes the current location to the D:\ directory.
#>
function Private:Set-DDisk {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path "D:\"
}

#------------------------------------------------------
# Set the alias for Set-DDisk
#------------------------------------------------------
Set-Alias -Name dc -Value Set-DDisk

######################################################
# Profile Shortcuts
######################################################

<#
.SYNOPSIS
    Opens the PowerShell profile in the default text editor.

.DESCRIPTION
    This function opens the PowerShell profile file (`Microsoft.PowerShell_profile.ps1`) in the default text editor. You can modify this file to customize your PowerShell environment.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Edit-Profile
    Opens the PowerShell profile in the default text editor.
#>
function Private:Edit-Profile {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  $PROFILE | Invoke-Item
}

#------------------------------------------------------
# Set the alias for Edit-Profile
#------------------------------------------------------
Set-Alias -Name ep -Value Edit-Profile

<#
.SYNOPSIS
    Retrieves detailed system information.

.DESCRIPTION
    This function retrieves various details about the system, including hardware and operating system information, such as the manufacturer, model, operating system version, and more.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The system information retrieved by the Get-ComputerInfo cmdlet.

.EXAMPLE
    Get-SystemInfo
    Retrieves and displays detailed system information.
#>
function Private:Get-SystemInfo {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )
  
  Get-ComputerInfo 
}

#------------------------------------------------------
# Set the alias for Get-SystemInfo
#------------------------------------------------------
Set-Alias -Name sysinfo -Value Get-SystemInfo

<#
.SYNOPSIS
    Terminates a process by name.

.DESCRIPTION
    This function terminates a process by its name. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER Name
    Specifies the name of the process to terminate.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Stop-TerminateProcess "notepad"
    Terminates the "notepad" process.
#>
function Private:Stop-TerminateProcess {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Name
  )
  
  Stop-Process -Name $Name 
}

#------------------------------------------------------
# Set the alias for Stop-TerminateProcess
#------------------------------------------------------
Set-Alias -Name k9 -Value Stop-TerminateProcess

<#
.SYNOPSIS
    Flushes the DNS cache to resolve DNS-related issues.

.DESCRIPTION
    This function clears the DNS cache on the local machine, which can help resolve DNS-related problems such as DNS resolution failures or outdated DNS records.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    None. This function does not return any output.

.EXAMPLE
    Clear-DnsClientCache
    Flushes the DNS cache on the local machine.
#>
function Private:Clear-DnsCache {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )
  
  Clear-DnsClientCache 
}

#------------------------------------------------------
# Set the alias for Clear-DnsCache
#------------------------------------------------------
Set-Alias -Name flushdns -Value Clear-DnsCache

<#
.SYNOPSIS
    Lists files and directories.

.DESCRIPTION
    This function lists files and directories either in the current directory or in the specified path.

.PARAMETER Path
    Specifies the path of the directory to list. If no path is provided, the current directory is listed.

.OUTPUTS
    The files and directories in the specified path.

.EXAMPLE
    Get-ChildItemFormatted
    Lists files and directories in the current directory.

.EXAMPLE
    Get-ChildItemFormatted "C:\Users"
    Lists files and directories in the "C:\Users" directory.
#>
function Private:Get-ChildItemFormatted {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [string]$Path = "."
  )

  Get-ChildItem -Path $Path -Force | Format-Table -AutoSize
}

#------------------------------------------------------
# Set the alias for Get-ChildItem-Formatted
#------------------------------------------------------
Set-Alias -Name la -Value Get-ChildItemFormatted

<#
.SYNOPSIS
    Performs a domain name lookup and returns information such as domain availability, ownership, and name servers.

.DESCRIPTION
    This function performs a domain name lookup using the Whois web service and returns information such as domain availability, creation and expiration date, ownership, and name servers.

.PARAMETER Domain
    Specifies the domain name to perform the lookup for. Enter the domain name without http:// and www (e.g., "power-shell.com").

.OUTPUTS
    Domain information including availability, creation and expiration date, ownership, and name servers.

.EXAMPLE
    Get-WhoIs -Domain "power-shell.com"
    Performs a domain name lookup for "power-shell.com" and returns information.

.EXAMPLE
    Get-WhoIs "power-shell.com"
    Performs a domain name lookup for "power-shell.com" and returns information.
#>
function Private:Get-WhoIs {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
    [string]$Domain
  )
  
  # Validate domain format
  if ($Domain -notmatch '^[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$') {
    Write-Error "Please enter a valid domain name (e.g., microsoft.com)." -ForegroundColor Red
    return
  }

  Write-Host "Connecting to Web Services URL..." -ForegroundColor Green
  try {
    # Retrieve data from web service WSDL
    $WhoisService = New-WebServiceProxy -Uri "http://www.webservicex.net/whois.asmx?WSDL"
    if ($WhoisService) {
      Write-Host "Connected successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Failed to connect to the web service." -ForegroundColor Red
      return
    }

    Write-Host "Gathering information for domain '$Domain'..." -ForegroundColor Green
      
    # Perform Whois lookup
    $WhoisResult = $WhoisService.GetWhoIs("=$Domain").Split("<<<")[0]

    # Output result
    $WhoisResult
  }
  catch {
    Write-Error "An error occurred: $_" -ForegroundColor Red
  }
}

#------------------------------------------------------
# Set the alias for Get-WhoIs
#------------------------------------------------------
Set-Alias -Name whois -Value Get-WhoIs
