#------------------------------------------------------
#------------------------------------------------------

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
# Check if Starship is installed
#------------------------------------------------------
function Invoke-Starship-TransientFunction {
  &starship module character
}

Invoke-Command -ScriptBlock ${function:Invoke-Starship-TransientFunction} -ErrorAction SilentlyContinue

#------------------------------------------------------
# Load Starship
#------------------------------------------------------
Invoke-Expression (&starship init powershell)

#------------------------------------------------------
#------------------------------------------------------
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

if (Test-Path $ChocolateyProfile) {
  Import-Module $ChocolateyProfile
}

#------------------------------------------------------
# Check for Profile updates
#------------------------------------------------------
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

Update-Profile

#------------------------------------------------------
# Check for PowerShell updates
#------------------------------------------------------
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

Update-PowerShell