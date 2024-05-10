#############################################
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
#############################################

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
# Updated: 2024-05-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 2.0.0
#------------------------------------------------------

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
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-Starship-TransientFunction
    Invokes the Starship module transiently to load the Starship prompt.
#>
function Private:Invoke-StarshipTransientFunction {
  [CmdletBinding()]
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

<#
.SYNOPSIS
    Checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected.

.DESCRIPTION
    This function checks for updates to the PowerShell profile from the GitHub repository specified in the script. It compares the hash of the local profile with the hash of the profile on GitHub. If updates are found, it downloads the updated profile and replaces the local profile with the updated one. The function provides feedback on whether the profile has been updated and prompts the user to restart the shell to reflect changes.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

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

.OUTPUTS None
    This function does not return any output.

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
    Loads the personal profile script if it exists.

.DESCRIPTION
    This function loads the personal profile script if it exists in the user's profile directory. It checks for the presence of the personal profile script and sources it if found. This allows users to define custom settings, functions, and aliases in their personal profile script to customize their PowerShell environment.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-LoadPersonalProfile
    Loads the personal profile script if it exists.
#>
function Private:Invoke-LoadPersonalProfile {
  $ProfileDirectory = [System.IO.Path]::GetDirectoryName($PROFILE.CurrentUserAllHosts)
  $PersonalProfilePath = Join-Path -Path $ProfileDirectory -ChildPath "personal.ps1"
  if (Test-Path $PersonalProfilePath -PathType Leaf) {
    Write-Output "Loading personal profile: $PersonalProfilePath"
    . $PersonalProfilePath
  }
}

#------------------------------------------------------
# Invoke the personal profile loading function
#------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-LoadPersonalProfile} -ErrorAction SilentlyContinue

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

<#
.SYNOPSIS
    Updates all installed PowerShell modules to their latest versions.

.DESCRIPTION
    This function updates all installed PowerShell modules to their latest versions. It retrieves the list of installed modules, checks for updates, and updates each module to the latest version if available. The function provides feedback on the update process for each module.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Update-InstalledModules
    Updates all installed PowerShell modules to their latest versions.

.ALIASES
    update-modules -> Use the alias `update-modules` to quickly update all installed modules.

.NOTES
    This function requires an active internet connection to check for module updates.
#>
function Private:Invoke-UpdateInstalledModules {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )
  
  $installedModules = Get-Module -ListAvailable | Select-Object -ExpandProperty Name

  foreach ($module in $installedModules) {
    $moduleInfo = Get-Module -Name $module -ListAvailable | Select-Object -First 1
    $latestVersion = (Find-Module -Name $module).Version
    $installedVersion = $moduleInfo.Version

    if ($latestVersion -gt $installedVersion) {
      Write-Host "Updating module $module from version $installedVersion to version $latestVersion"
      Update-Module -Name $module -Scope CurrentUser -Force -ErrorAction SilentlyContinue Stop
    }
    else {
      Write-Host "Module $module is up to date"
    }
  }
}

#------------------------------------------------------
# Set the alias for updating installed modules
#------------------------------------------------------
Set-Alias -Name update-modules -Value Invoke-UpdateInstalledModules

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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-FreshFile "file.txt"
    Creates a new empty file named "file.txt" if it doesn't exist. If "file.txt" already exists, its timestamp is updated.

.EXAMPLE
    Set-FreshFile "existing_file.txt"
    Updates the timestamp of the existing file named "existing_file.txt" without modifying its content.

.ALIASES
    touch -> Use the alias `touch` to quickly create a new file or update the timestamp of an existing file.
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

.ALIASES
    uptime -> Use the alias `uptime` to quickly get the system uptime.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-ProfileReload
    Reloads the PowerShell profile.

.ALIASES
    reload-profile -> Use the alias `reload-profile` to quickly reload the profile.
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

.PARAMETER File
    Specifies the file to extract.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Expand-File "file.zip"
    Extracts the file "file.zip" to the current directory.

.ALIASES
    unzip -> Use the alias `unzip` to quickly extract a file.
#>
function Private:Expand-File {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File
  )

  BEGIN {
    Write-Host "Starting file extraction process..." -ForegroundColor Cyan
  }

  PROCESS {
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

  END {
    if (-not $Error) {
      Write-Host "File extraction process completed." -ForegroundColor Cyan
    }
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

.ALIASES
    grep -> Use the alias `grep` to quickly search for a string in a file.
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

.ALIASES
    df -> Use the alias `df` to quickly get volume information.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-ContentMatching "file.txt" "pattern" "replacement"
    Searches for "pattern" in "file.txt" and replaces it with "replacement".

.ALIASES
    sed -> Use the alias `sed` to quickly perform text replacements.
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

.ALIASES
    def -> Use the alias `def` to quickly get the definition of a command.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-EnvVar "name" "value"
    Exports an environment variable named "name" with the value "value".

.ALIASES
    export -> Use the alias `export` to quickly set an environment variable.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Stop-ProcessByName "process"
    Terminates the process named "process".

.ALIASES
    pkill -> Use the alias `pkill` to quickly stop a process by name.
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

.ALIASES
    pgrep -> Use the alias `pgrep` to quickly find a process by name.
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

.ALIASES
    head -> Use the alias `head` to quickly retrieve the top n lines of a file.
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

.ALIASES
    tail -> Use the alias `tail` to quickly retrieve the last n lines of a file.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    New-File "file.txt"
    Creates a new file named "file.txt" in the current directory.

.ALIASES
    nf -> Use the alias `nf` to quickly create a new file.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    New-Directory "NewDirectory"
    Creates a new directory named "NewDirectory" and changes the current location to it.

.ALIASES
    mkcd -> Use the alias `mkcd` to quickly create a new directory and change to it.
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

.ALIASES
    hist -> Use the alias `hist` to quickly search the full command history.
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

<#
.SYNOPSIS
    Displays the process tree of the system.

.DESCRIPTION
    This function retrieves the process tree of the system, showing the parent-child relationships between processes. It provides a hierarchical view of the processes running on the system.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The process tree of the system.

.EXAMPLE
    Get-ProcessTree
    Displays the process tree of the system.

.ALIASES
    pstree -> Use the alias `pstree` to quickly display the process tree.
#>
function Private:Get-ProcessTree {
  $ProcessesById = @{}
  foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
    $ProcessesById[$Process.ProcessId] = $Process
  }

  $ProcessesWithoutParents = @()
  $ProcessesByParent = @{}
  foreach ($Pair in $ProcessesById.GetEnumerator()) {
    $Process = $Pair.Value

    if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
      $ProcessesWithoutParents += $Process
      continue
    }

    if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
      $ProcessesByParent[$Process.ParentProcessId] = @()
    }
    $Siblings = $ProcessesByParent[$Process.ParentProcessId]
    $Siblings += $Process
    $ProcessesByParent[$Process.ParentProcessId] = $Siblings
  }

  function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
    $Process = $ProcessesById[$ProcessId]
    $Indent = " " * $IndentLevel
    if ($Process.CommandLine) {
      $Description = $Process.CommandLine
    }
    else {
      $Description = $Process.Caption
    }

    Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
    foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
      Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
    }
  }

  Write-Output ("{0,6} {1}" -f "PID", "Command Line")
  Write-Output ("{0,6} {1}" -f "---", "------------")

  foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
    Show-ProcessTree $Process.ProcessId 0
  }
}

#------------------------------------------------------
# Set the alias for Get-ProcessTree
#------------------------------------------------------
Set-Alias -Name pstree -Value Get-ProcessTree

#######################################################
# Navigation Shortcuts
#######################################################

<#
.SYNOPSIS
    Changes the current location to the root directory.

.DESCRIPTION
    This function changes the current working directory to the root directory, typically the user's home directory or the root of the filesystem.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-Home
    Changes the current location to the root directory.

.ALIASES
    root -> Use the alias `root` to quickly change to the root directory.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-Documents
    Changes the current location to the Documents directory.

.ALIASES
    doc -> Use the alias `doc` to quickly change to the Documents directory.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-Downloads
    Changes the current location to the Downloads directory.

.ALIASES
    dl -> Use the alias `dl` to quickly change to the Downloads directory.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-Desktop
    Changes the current location to the Desktop directory.

.ALIASES
    dtop -> Use the alias `dtop` to quickly change to the Desktop directory.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-DDisk
    Changes the current location to the D:\ directory.

.ALIASES
    dc -> Use the alias `dc` to quickly change to the D:\ directory.
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

#######################################################
# Profile Shortcuts
#######################################################

<#
.SYNOPSIS
    Opens the PowerShell profile in the default text editor.

.DESCRIPTION
    This function opens the PowerShell profile file (`Microsoft.PowerShell_profile.ps1`) in the default text editor. You can modify this file to customize your PowerShell environment.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Edit-Profile
    Opens the PowerShell profile in the default text editor.

.ALIASES
    ep -> Use the alias `ep` to quickly edit the PowerShell profile.
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

.ALIASES
    sysinfo -> Use the alias `sysinfo` to quickly get system information.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Stop-TerminateProcess "notepad"
    Terminates the "notepad" process.

.ALIASES
    k9 -> Use the alias `k9` to quickly terminate a process by name.
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

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Clear-DnsClientCache
    Flushes the DNS cache on the local machine.

.ALIASES
    flushdns -> Use the alias `flushdns` to quickly flush the DNS cache.
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

.ALIASES
    la -> Use the alias `la` to list files and directories in the current directory.
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

#######################################################
# Move Up Directory
#######################################################

<#
.SYNOPSIS
    Moves up one directory level.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the current directory. It is useful for navigating up one level in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpOneDirectoryLevel
    Moves up one directory level.

.ALIASES
    cd.1 -> Use the alias `cd.1` to quickly move up one directory level.
    .. -> Use the alias `..` to quickly move up one directory level.
#>
function Private:Invoke-UpOneDirectoryLevel {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path .. -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Set the alias for Invoke-UpOneDirectoryLevel
#------------------------------------------------------
Set-Alias -Name cd.1 -Value Private:Invoke-UpOneDirectoryLevel
Set-Alias -Name .. -Value Private:Invoke-UpOneDirectoryLevel

<#
.SYNOPSIS
    Moves up two directory levels.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the parent directory of the current directory. It is useful for navigating up two levels in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpTwoDirectoryLevels
    Moves up two directory levels.

.ALIASES
    cd.2 -> Use the alias `cd.2` to quickly move up two directory levels.
    ... -> Use the alias `...` to quickly move up two directory levels.
#>
function Private:Invoke-UpTwoDirectoryLevels {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\.. -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Set the alias for Invoke-UpTwoDirectoryLevels
#------------------------------------------------------
Set-Alias -Name cd.2 -Value Invoke-UpTwoDirectoryLevels
Set-Alias -Name ... -Value Invoke-UpTwoDirectoryLevels

<#
.SYNOPSIS
    Moves up three directory levels.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up three levels in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpThreeDirectoryLevels
    Moves up three directory levels.

.ALIASES
    cd.3 -> Use the alias `cd.3` to quickly move up three directory levels.
    .... -> Use the alias `....` to quickly move up three directory levels.
#>
function Private:Invoke-UpThreeDirectoryLevels {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\.. -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Set the alias for Invoke-UpThreeDirectoryLevels
#------------------------------------------------------
Set-Alias -Name cd.3 -Value Invoke-UpThreeDirectoryLevels
Set-Alias -Name .... -Value Invoke-UpThreeDirectoryLevels

<#
.SYNOPSIS
    Moves up four directory levels.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up four levels in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpFourDirectoryLevels
    Moves up four directory levels.

.ALIASES
    cd.4 -> Use the alias `cd.4` to quickly move up four directory levels.
    ..... -> Use the alias `.....` to quickly move up four directory levels.
#>
function Private:Invoke-UpFourDirectoryLevels {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\.. -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Set the alias for Invoke-UpFourDirectoryLevels
#------------------------------------------------------
Set-Alias -Name cd.4 -Value Invoke-UpFourDirectoryLevels
Set-Alias -Name ..... -Value Invoke-UpFourDirectoryLevels

<#
.SYNOPSIS
    Moves up five directory levels.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up five levels in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpFiveDirectoryLevels
    Moves up five directory levels.

.ALIASES
    cd.5 -> Use the alias `cd.5` to quickly move up five directory levels.
    ...... -> Use the alias `......` to quickly move up five directory levels.
#>
function Private:Invoke-UpFiveDirectoryLevels {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\..\.. -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Set the alias for Invoke-UpFiveDirectoryLevels
#------------------------------------------------------
Set-Alias -Name cd.5 -Value Invoke-UpFiveDirectoryLevels
Set-Alias -Name ...... -Value Invoke-UpFiveDirectoryLevels

<#
.SYNOPSIS
    Moves up six directory levels.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up six levels in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpSixDirectoryLevels
    Moves up six directory levels.

.ALIASES
    cd.6 -> Use the alias `cd.6` to quickly move up six directory levels.
    ....... -> Use the alias `.......` to quickly move up six directory levels.
#>
function Private:Invoke-UpSixDirectoryLevels {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\..\..\.. -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Set the alias for Invoke-UpSixDirectoryLevels
#------------------------------------------------------
Set-Alias -Name cd.6 -Value Invoke-UpSixDirectoryLevels
Set-Alias -Name ....... -Value Invoke-UpSixDirectoryLevels

#######################################################
# Git Functions
#######################################################

<#
.SYNOPSIS
    Initializes a new Git repository in the current directory.

.DESCRIPTION
    This function initializes a new Git repository in the current directory. It creates the necessary Git configuration files and directories to start tracking changes in the directory.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-InitializeGitRepository
    Initializes a new Git repository in the current directory.

.ALIASES
    init -> Use the alias `init` to quickly initialize a Git repository.
#>
function Private:Invoke-InitializeGitRepository {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  git init
}

#------------------------------------------------------
# Set the alias for Invoke-InitializeGitRepository
#------------------------------------------------------
Set-Alias -Name init -Value Invoke-InitializeGitRepository

<#
.SYNOPSIS
    Adds all changes in the current directory to the staging area.

.DESCRIPTION
    This function adds all changes in the current directory to the staging area in preparation for committing the changes to the Git repository.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitAllChanges
    Adds all changes in the current directory to the staging area.

.ALIASES
    add-all -> Use the alias `add-all` to quickly add all changes to the staging area.
#>
function Private:Invoke-GitAllChanges {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  git add .
}

#------------------------------------------------------
# Set the alias for Invoke-GitAllChanges
#------------------------------------------------------
Set-Alias -Name add-all -Value Invoke-GitAllChanges

<#
.SYNOPSIS
    Commits the changes in the staging area to the Git repository.

.DESCRIPTION
    This function commits the changes in the staging area to the Git repository. It creates a new commit with the specified message to track the changes made to the repository.

.PARAMETER Message
    Specifies the message for the commit.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitCommitChanges -Message "Initial commit"
    Commits the changes in the staging area with the message "Initial commit".

.ALIASES
    commit -> Use the alias `commit` to quickly commit changes to the repository.
#>
function Private:Invoke-GitCommitChanges {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Message
  )

  git commit -m $Message
}

#------------------------------------------------------
# Set the alias for Invoke-GitCommitChanges
#------------------------------------------------------
Set-Alias -Name commit -Value Invoke-GitCommitChanges

<#
.SYNOPSIS
    Pushes the committed changes to a remote Git repository.

.DESCRIPTION
    This function pushes the committed changes to a remote Git repository. It updates the remote repository with the changes made locally.

.PARAMETER Branch
    Specifies the branch to push the changes to. If not provided, the current branch is used.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitPushChanges
    Pushes the committed changes to the remote repository.

.EXAMPLE
    Invoke-GitPushChanges -Branch "main"
    Pushes the committed changes to the "main" branch of the remote repository.

.ALIASES
    push -> Use the alias `push` to quickly push changes to the remote repository.
#>
function Private:Invoke-GitPushChanges {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [string]$Branch
  )

  try {
    if ($null -eq $Branch) {
      $Branch = (git branch --show-current)
      if (-not $Branch) {
        Write-Error "No branch specified, and unable to determine the current branch."
        return
      }
    }

    Write-Host "Pushing changes to branch '$Branch'..." -ForegroundColor Cyan
    git push origin $Branch
    Write-Host "Changes pushed successfully to branch '$Branch'." -ForegroundColor Green
  }
  catch {
    Write-Error "Failed to push changes to branch '$Branch'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitPushChanges
#------------------------------------------------------
Set-Alias -Name push -Value Invoke-GitPushChanges

<#
.SYNOPSIS
    Pulls changes from a remote Git repository to the local repository.

.DESCRIPTION
    This function pulls changes from a remote Git repository to the local repository. It updates the local repository with the changes made in the remote repository.

.PARAMETER Branch
    Specifies the branch to pull changes from. If not provided, the current branch is used.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitPullChanges
    Pulls changes from the remote repository to the local repository.

.EXAMPLE
    Invoke-GitPullChanges -Branch "main"
    Pulls changes from the "main" branch of the remote repository to the local repository.

.ALIASES
    pull -> Use the alias `pull` to quickly pull changes from the remote repository.
#>
function Private:Invoke-GitPullChanges {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [string]$Branch
  )

  try {
    if ($null -eq $Branch) {
      $Branch = (git branch --show-current)
      if (-not $Branch) {
        Write-Error "No branch specified, and unable to determine the current branch."
        return
      }
    }

    Write-Host "Pulling changes from branch '$Branch'..." -ForegroundColor Cyan
    git pull origin $Branch
    Write-Host "Changes pulled successfully from branch '$Branch'." -ForegroundColor Green
  }
  catch {
    Write-Error "Failed to pull changes from branch '$Branch'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitPullChanges
#------------------------------------------------------
Set-Alias -Name pull -Value Invoke-GitPullChanges

<#
.SYNOPSIS
    Clones a Git repository from a remote URL.

.DESCRIPTION
    This function clones a Git repository from a remote URL to the local machine. It creates a copy of the remote repository in the specified directory.

.PARAMETER Url
    Specifies the URL of the remote Git repository to clone.

.PARAMETER Directory
    Specifies the directory to clone the repository into. If not provided, the repository is cloned into a directory with the same name as the repository.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitCloneRepository -Url "git@github.com:MKAbuMattar/powershell-profile.git"
    Clones the repository from the specified URL.

.EXAMPLE
    Invoke-GitCloneRepository -Url "git@github.com:MKAbuMattar/powershell-profile.git" -Directory "C:\Projects"
    Clones the repository into the "C:\Projects" directory.

.ALIASES
    clone -> Use the alias `clone` to quickly clone a Git repository.
#>
function Private:Invoke-GitCloneRepository {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Url,

    [Parameter(Position = 1)]
    [string]$Directory
  )

  try {
    if ($null -eq $Directory) {
      git clone $Url
    }
    else {
      git clone $Url $Directory
    }
  }
  catch {
    Write-Error "Failed to clone the repository from '$Url'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitCloneRepository
#------------------------------------------------------
Set-Alias -Name clone -Value Invoke-GitCloneRepository

<#
.SYNOPSIS
    Displays the status of the Git repository.
    
.DESCRIPTION
    This function displays the status of the Git repository, including information about modified files, untracked files, and the current branch.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The status of the Git repository.

.EXAMPLE
    Get-GitRepositoryStatus
    Displays the status of the Git repository.

.ALIASES
    status -> Use the alias `status` to quickly display the repository status.
#>
function Private:Get-GitRepositoryStatus {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  git status
}

#------------------------------------------------------
# Set the alias for Get-GitRepositoryStatus
#------------------------------------------------------
Set-Alias -Name status -Value Get-GitRepositoryStatus

<#
.SYNOPSIS
    Displays the commit history of the Git repository.

.DESCRIPTION
    This function displays the commit history of the Git repository, including information about past commits, commit messages, and commit authors.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The commit history of the Git repository.

.EXAMPLE
    Get-GitCommitHistory
    Displays the commit history of the Git repository.

.ALIASES
    log -> Use the alias `log` to quickly view the commit history.
#>
function Private:Get-GitCommitHistory {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  git log
}

#------------------------------------------------------
# Set the alias for Get-GitCommitHistory
#------------------------------------------------------
Set-Alias -Name log -Value Get-GitCommitHistory

<#
.SYNOPSIS
    Fetches changes from a remote Git repository.

.DESCRIPTION
    This function fetches changes from a remote Git repository to the local repository. It updates the local repository with the changes made in the remote repository without merging the changes.

.PARAMETER Branch
    Specifies the branch to fetch changes from. If not provided, the current branch is used.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitFetchRepository
    Fetches changes from the remote repository to the local repository.

.EXAMPLE
    Invoke-GitFetchRepository -Branch "main"
    Fetches changes from the "main" branch of the remote repository to the local repository.

.ALIASES
    fetch -> Use the alias `fetch` to quickly fetch changes from the remote repository.
#>
function Private:Invoke-GitFetchRepository {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [string]$Branch
  )

  try {
    if ($null -eq $Branch) {
      $Branch = (git branch --show-current)
      if (-not $Branch) {
        Write-Error "No branch specified, and unable to determine the current branch."
        return
      }
    }

    Write-Host "Syncing with branch '$Branch'..." -ForegroundColor Cyan
    git fetch origin $Branch
    git merge origin/$Branch
    Write-Host "Sync completed with branch '$Branch'." -ForegroundColor Green
  }
  catch {
    Write-Error "Failed to sync with branch '$Branch'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitFetchRepository
#------------------------------------------------------
Set-Alias -Name fetch -Value Invoke-GitFetchRepository

<#
.SYNOPSIS
    Creates a new branch in the Git repository.

.DESCRIPTION
    This function creates a new branch in the Git repository based on the current branch. It allows you to work on new features or changes in isolation from the main branch.

.PARAMETER Name
    Specifies the name of the new branch to create.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitCreateBranch -Name "feature-branch"
    Creates a new branch named "feature-branch" in the Git repository.

.ALIASES
    branch -> Use the alias `branch` to quickly create a new branch.
#>
function Private:Invoke-GitCreateBranch {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Name
  )

  try {
    git checkout -b $Name
  }
  catch {
    Write-Error "Failed to create branch '$Name'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitCreateBranch
#------------------------------------------------------
Set-Alias -Name branch -Value Invoke-GitCreateBranch

<#
.SYNOPSIS
    Checkout/Switches to an existing branch in the Git repository.

.DESCRIPTION
    This function switches to an existing branch in the Git repository. It allows you to work on different branches of the repository.

.PARAMETER Name
    Specifies the name of the branch to switch to.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitCheckoutBranch -Name "main"
    Switches to the "main" branch in the Git repository.

.EXAMPLE
    Invoke-GitCheckoutBranch -Name "feature-branch"
    Switches to the "feature-branch" branch in the Git repository.

.ALIASES
    checkout -> Use the alias `checkout` to quickly switch to a branch.
#>
function Invoke-GitCheckoutBranch {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Name
  )

  try {
    $existingBranches = git branch --list $Name
    if (-not $existingBranches) {
      Write-Error "Branch '$Name' does not exist in the repository."
      return
    }
    
    git checkout $Name
  }
  catch {
    Write-Error "Failed to switch to branch '$Name'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitCheckoutBranch
#------------------------------------------------------
Set-Alias -Name checkout -Value Invoke-GitCheckoutBranch

<#
.SYNOPSIS
    Deletes a branch in the Git repository.

.DESCRIPTION
    This function deletes a branch in the Git repository. It removes the specified branch from the repository.

.PARAMETER Name
    Specifies the name of the branch to delete.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitDeleteBranch -Name "feature-branch"
    Deletes the "feature-branch" branch from the Git repository.

.ALIASES
    delete-branch -> Use the alias `delete-branch` to quickly delete a branch.
#>
function Private:Invoke-GitDeleteBranch {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Name
  )

  try {
    $existingBranches = git branch --list $Name
    if (-not $existingBranches) {
      Write-Error "Branch '$Name' does not exist in the repository."
      return
    }

    git branch -D $Name
  }
  catch {
    Write-Error "Failed to delete branch '$Name'. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitDeleteBranch
#------------------------------------------------------
Set-Alias -Name delete-branch -Value Invoke-GitDeleteBranch

<#
.SYNOPSIS
    Merges changes from one branch into the current branch.

.DESCRIPTION
    This function merges changes from one branch into the current branch in the Git repository. It combines the changes made in the specified branch with the changes in the current branch.

.PARAMETER Name
    Specifies the name of the branch to merge into the current branch.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitMergeBranch -Name "feature-branch"
    Merges changes from the "feature-branch" into the current branch.

.ALIASES
    merge-branch -> Use the alias `merge-branch` to quickly merge changes from a branch into the current branch.
#>
function Private:Invoke-GitMergeBranch {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Name
  )

  try {
    git merge $Name
  }
  catch {
    Write-Error "Failed to merge branch '$Name' into the current branch. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitMergeBranch
#------------------------------------------------------
Set-Alias -Name merge-branch -Value Invoke-GitMergeBranch

<#
.SYNOPSIS
    Reverts changes in the working directory to the last commit.

.DESCRIPTION
    This function reverts changes in the working directory to the last commit in the Git repository. It resets the working directory to the state of the last commit without losing current changes.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitRevertChanges
    Reverts changes in the working directory to the last commit.

.ALIASES
    revert -> Use the alias `revert` to quickly revert changes to the last commit.
#>
function Private:Invoke-GitRevertChanges {
  [CmdletBinding()]
  param (
    # This function does not accept any parameters
  )

  try {
    git reset --hard HEAD
  }
  catch {
    Write-Error "Failed to revert changes to the last commit. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitRevertChanges
#------------------------------------------------------
Set-Alias -Name revert -Value Invoke-GitRevertChanges

<#
.SYNOPSIS
    Deletes all local branches and keep only the master/main branch or branches that are specified.
    
.DESCRIPTION
    This function deletes all local branches except the master/main branch or branches that are specified. It is useful for cleaning up local branches after merging changes.

.PARAMETER Branches
    Specifies the branches to keep. If not provided, only the master/main branch is kept.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-GitCleanupBranches
    Deletes all local branches except the master/main branch.

.EXAMPLE
    Invoke-GitCleanupBranches -Branches "feature-branch1", "feature-branch2"
    Deletes all local branches except the master/main branch and "feature-branch1" and "feature-branch2".

.ALIASES
    cleanup-branches -> Use the alias `cleanup-branches` to quickly clean up local branches.
#>

function Invoke-GitCleanupBranches {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [string[]]$Branches
  )

  try {
    # If no branches are specified, keep only the current branch
    if (-not $Branches) {
      $currentBranch = git branch --show-current
      if ($currentBranch -eq 'master' -or $currentBranch -eq 'main') {
        $Branches = @($currentBranch)
      }
      else {
        $Branches = @('master', 'main', $currentBranch)
      }
    }
    else {
      # If branches are specified, ensure master/main is included
      if ('master' -notin $Branches -and 'main' -notin $Branches) {
        $Branches += 'master', 'main'
      }
    }

    # Get all local branches except the ones specified to keep
    $branchesToDelete = (git branch | ForEach-Object { $_.Trim() }) | Where-Object { $_ -notin $Branches }

    # If there are no branches to delete, inform the user and exit
    if (-not $branchesToDelete) {
      Write-Host "No branches to delete." -ForegroundColor Yellow
      return
    }

    # Loop through the branches to delete and delete them
    foreach ($branch in $branchesToDelete) {
      git branch -D $branch
    }
  }
  catch {
    Write-Error "Failed to delete branches. Error: $_"
  }
}

#------------------------------------------------------
# Set the alias for Invoke-GitCleanupBranches
#------------------------------------------------------
Set-Alias -Name cleanup-branches -Value Invoke-GitCleanupBranches
