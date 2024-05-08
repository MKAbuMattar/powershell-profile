#------------------------------------------------------
# MKAbuMattar's PowerShell Profile
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This profile is used to configure the
#       PowerShell environment.
#
# Created: 2021-09-01
# Updated: 2024-05-08
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 1.0.0
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
Import-Module -Name PSReadLine
Import-Module -Name Posh-Git

#------------------------------------------------------
# Set the PSReadLine options
#------------------------------------------------------
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionViewStyle InlineView

<#
.DESCRIPTION
This function invokes the Starship module transiently to load the Starship prompt.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
Invoke-Starship-TransientFunction
#>
function Invoke-Starship-TransientFunction {
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

if (Test-Path $ChocolateyProfile) {
  Import-Module $ChocolateyProfile
}

<#
.DESCRIPTION
This function checks for updates to the PowerShell profile from the GitHub repository specified in the script. If updates are found, it copies the updated profile to the current user's profile path.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
Update-Profile
#>
function Update-Profile {
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
.DESCRIPTION
This function checks for updates to PowerShell. If updates are found, it upgrades PowerShell to the latest version.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
Update-PowerShell
#>
function Update-PowerShell {
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
.DESCRIPTION
This function checks if a command exists in the current environment.

.PARAMETER command
The command to check.

.OUTPUTS
$exists: True if the command exists, false otherwise.

.EXAMPLE
Test-CommandExists "ls"
#>
function Test-CommandExists {
  param($command)
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
.DESCRIPTION
This function opens the current user's profile in the editor specified by the $EDITOR variable.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
Edit-Profile
#>
function Edit-Profile {
  vim $PROFILE.CurrentUserAllHosts
}

######################################################
# Utility Functions
######################################################

<#
.DESCRIPTION
This function creates a new empty file with the specified name.

.PARAMETER file
The file to create.

.OUTPUTS
None

.EXAMPLE
touch "file.txt"
#>
function touch($file) {
  "" | Out-File $file -Encoding ASCII
}

<#
.DESCRIPTION
This function finds a file by name.

.PARAMETER name
The name of the file to find.

.OUTPUTS
None

.EXAMPLE
ff "file.txt"
#>
function ff($name) {
  Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Output "$($_.directory)\$($_)"
  }
}

<#
.DESCRIPTION
This function gets the system uptime in a human-readable format.

.PARAMETER None

.OUTPUTS
The system uptime in a human-readable format.

.EXAMPLE
uptime
#>
function uptime {
  if ($PSVersionTable.PSVersion.Major -eq 5) {
    Get-WmiObject win32_operatingsystem | Select-Object @{Name = 'LastBootUpTime'; Expression = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
  }
  else {
    net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
  }
}

<#
.DESCRIPTION
This function reloads the profile to apply changes.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
reload-profile
#>
function reload-profile {
  & $profile
}

<#
.DESCRIPTION
This function extracts a file to the current directory.

.PARAMETER file
The file to extract.

.OUTPUTS
None

.EXAMPLE
unzip "file.zip"
#>
function unzip ($file) {
  Write-Output("Extracting", $file, "to", $pwd)
  $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
  Expand-Archive -Path $fullFile -DestinationPath $pwd
}

<#
.DESCRIPTION
This function searches for a string in a file and returns the line that contains the string.

.PARAMETER regex
The regular expression to search for.

.PARAMETER dir
The directory to search in.

.OUTPUTS
The lines that match the regular expression.

.EXAMPLE
grep "pattern" "file.txt"
#>
function grep($regex, $dir) {
  if ( $dir ) {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}

#------------------------------------------------------
# Utility function to get the volume information
#------------------------------------------------------
<#
.DESCRIPTION
This function gets the volume information.

.PARAMETER None

.OUTPUTS
The volume information.

.EXAMPLE
df
#>
function df {
  get-volume
}


<#
.DESCRIPTION
This function searches for a string in a file and replaces it with another string.

.PARAMETER file
The file to search in.

.PARAMETER find
The string to search for.

.PARAMETER replace
The string to replace the found string with.

.OUTPUTS
None

.EXAMPLE
sed "file.txt" "pattern" "replacement"
#>
function sed($file, $find, $replace) {
  (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

<#
.DESCRIPTION
This function gets the definition of a command by name.

.PARAMETER name
The name of the command.

.OUTPUTS
The definition of the command.

.EXAMPLE
which "ls"
#>
function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}

<#
.DESCRIPTION
This function exports an environment variable with the specified name and value.

.PARAMETER name
The name of the environment variable.

.PARAMETER value
The value of the environment variable.

.OUTPUTS
None

.EXAMPLE
export "name" "value"
#>
function export($name, $value) {
  set-item -force -path "env:$name" -value $value;
}

<#
.DESCRIPTION
This function kills a process by name or ID.

.PARAMETER name
The name of the process to kill.

.OUTPUTS
None

.EXAMPLE
pkill "process"
#>
function pkill($name) {
  Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

<#
.DESCRIPTION
This function finds a process by name or ID.

.PARAMETER name
The name of the process to find.

.OUTPUTS
The process.

.EXAMPLE
pgrep "process"
#>
function pgrep($name) {
  Get-Process $name
}

<#
.DESCRIPTION
This function gets the top file.

.PARAMETER Path
The path to the file to get the top content.

.PARAMETER n
The number of file to get.

.OUTPUTS
The top file content.

.EXAMPLE
head "file.txt" 10
#>
function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

<#
.DESCRIPTION
This function gets the bottom file content.

.PARAMETER Path
The path to the file to get the bottom content.

.PARAMETER n
The number of file to get.

.OUTPUTS
The bottom file content.

.EXAMPLE
tail "file.txt" 10
#>
function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

<#
.DESCRIPTION
This function creates a new file with the specified name.

.PARAMETER name
The name of the file to create.

.OUTPUTS
None

.EXAMPLE
nf "file.txt"
#>
function nf { 
  param($name) New-Item -ItemType "file" -Path . -Name $name
}

<#
.DESCRIPTION
This function creates a new directory with the specified name.

.PARAMETER name
The name of the directory to create.

.OUTPUTS
None

.EXAMPLE
mkdir "directory"
#>
function mkcd { 
  param($dir) mkdir $dir -Force; Set-Location $dir
}

<#
.DESCRIPTION
This function searches through the command history.

.PARAMETER searchTerm
The term to search for in the command history.

.OUTPUTS
The command history.

.EXAMPLE
history "command"
#>
function history {
  Get-Content (Get-PSReadlineOption).HistorySavePath | Where-Object { $_ -like "*$args[0]*" } 
}

######################################################
# Navigation Shortcuts
######################################################

<#
.DESCRIPTION
This function goes to the root directory.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
root
#>
function root {
  Set-Location -Path $HOME
}

<#
.DESCRIPTION
This function goes to the Documents directory.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
doc
#>
function doc {
  Set-Location -Path $HOME\Documents
}

<#
.DESCRIPTION
This function goes to the Downloads directory.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
dl
#>
function downl {
  Set-Location -Path $HOME\Downloads
}

<#
.DESCRIPTION
This function goes to the Desktop directory.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
dtop
#>
function dtop {
  Set-Location -Path $HOME\Desktop
}

<#
.DESCRIPTION
This function goes to the D:\ directory.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
dc
#>
function dc {
  Set-Location -Path "D:\"
}

######################################################
# Profile Shortcuts
######################################################

<#
.DESCRIPTION
This function opens the profile in the editor.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
ep
#>
function ep { 
  vim $PROFILE
}

<#
.DESCRIPTION
This function gets the system information.

.PARAMETER None

.OUTPUTS
The system information.

.EXAMPLE
sysinfo
#>
function sysinfo { 
  Get-ComputerInfo 
}

<#
.DESCRIPTION
This function kills a process by name or ID.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
k9 "process"
#>
function k9 { 
  Stop-Process -Name $args[0] 
}

<#
.DESCRIPTION
This function flushes the DNS cache to resolve DNS issues.

.PARAMETER None

.OUTPUTS
None

.EXAMPLE
flushdns
#>
function flushdns { 
  Clear-DnsClientCache 
}

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
ll
Lists files and directories in the current directory.

.EXAMPLE
ll "C:\Users"
Lists files and directories in the "C:\Users" directory.
#>
function ll {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [string]$Path = "."
  )

  Get-ChildItem -Path $Path -Force | Format-Table -AutoSize
}
