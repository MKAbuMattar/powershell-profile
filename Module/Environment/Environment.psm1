<#
.SYNOPSIS
  Set environment variables for the PowerShell profile Auto Update.

.DESCRIPTION
  This script sets environment variables to disable the Auto Update feature for the PowerShell profile.

.INPUTS
  None.

.OUTPUTS
  Environment variables for the PowerShell profile Auto Update.

.NOTES
  This script is used to disable/enable the Auto Update feature for the PowerShell profile.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
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

INPUTS
  None.

.OUTPUTS
  Environment variables for Testing GitHub connectivity.

.NOTES
  This script is used to test if the machine can connect to GitHub.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
$global:CanConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

<#
.SYNOPSIS
  Exports an environment variable.

.DESCRIPTION
  This function exports an environment variable with the specified name and value. It sets the specified environment variable with the provided value.

.PARAMETER Name
  Specifies the name of the environment variable.

.PARAMETER Value
  Specifies the value of the environment variable.

.INPUTS
  Name: (Required) The name of the environment variable to export.
  Value: (Required) The value of the environment variable to export.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for exporting environment variables within a PowerShell session.

.EXAMPLE
  Set-EnvVar "name" "value"
  Exports an environment variable named "name" with the value "value".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Set-EnvVar {
  [CmdletBinding()]
  [Alias("set-env", "export")]
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [Alias("n")]
    [string]$Name,

    [Parameter(
      Mandatory = $true,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [Alias("v")]
    [string]$Value
  )
  Begin {}
  Process {
    try {
      Set-Item -Force -Path "env:$Name" -Value $Value -ErrorAction Stop
    }
    catch {
      Write-LogMessage -Message "Failed to export environment variable '$Name'." -Level "ERROR"
    }
  }
  End {}
}

<#
.SYNOPSIS
  Retrieves the value of an environment variable.

.DESCRIPTION
  This function retrieves the value of the specified environment variable. It returns the value of the environment variable if it exists.

.PARAMETER Name
  Specifies the name of the environment variable to retrieve the value for.

.INPUTS
  Name: (Required) The name of the environment variable to retrieve the value for.

.OUTPUTS
  The value of the specified environment variable.

.NOTES
  This function is useful for retrieving the value of environment variables within a PowerShell session.

.EXAMPLE
  Get-EnvVar "name"
  Retrieves the value of the environment variable named "name".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-EnvVar {
  [CmdletBinding()]
  [Alias("get-env")]
  [OutputType([string])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [Alias("n")]
    [string]$Name
  )
  Begin {}
  Process {
    try {
      $value = Get-Item -Path "env:$Name" -ErrorAction Stop | Select-Object -ExpandProperty Value
      if ($value) {
        Write-Output $value
      }
      else {
        Write-LogMessage -Message "Environment variable '$Name' not found." -Level "WARNING"
      }
    }
    catch {
      Write-LogMessage -Message "An error occurred while retrieving the value of environment variable '$Name'." -Level "ERROR"
    }
  }
  End {}
}
