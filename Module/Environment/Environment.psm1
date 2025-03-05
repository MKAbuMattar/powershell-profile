<#
.SYNOPSIS
  Set environment variables for the PowerShell profile Auto Update.

.DESCRIPTION
  This script sets environment variables to disable the Auto Update feature for the PowerShell profile.

.OUTPUTS
  Environment variables for the PowerShell profile Auto Update.

.NOTES
  This script is used to disable/enable the Auto Update feature for the PowerShell profile.
#>
$global:AutoUpdateProfile = [bool]$false

<#
.SYNOPSIS
  Set environment variables for the PowerShell Auto Update.

.DESCRIPTION
  This script sets environment variables to disable the Auto Update feature for PowerShell.

.OUTPUTS
  Environment variables for the PowerShell Auto Update.

.NOTES
  This script is used to disable/enable the Auto Update feature for PowerShell.
#>
$global:AutoUpdatePowerShell = [bool]$false

<#
.SYNOPSIS
  Set environment variables for Testing GitHub connectivity.

.DESCRIPTION
  This script sets environment variables to test if the machine can connect to GitHub.

.OUTPUTS
  Environment variables for Testing GitHub connectivity.

.NOTES
  This script is used to test if the machine can connect to GitHub.
#>
$global:CanConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1
