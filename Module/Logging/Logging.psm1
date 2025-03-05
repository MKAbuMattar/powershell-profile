<#
.SYNOPSIS
  Logs a message with a timestamp and log level.

.DESCRIPTION
  This function logs a message with a timestamp and log level. The default log level is "INFO".

.PARAMETER Message
  Specifies the message to log.

.PARAMETER Level
  Specifies the log level. Default is "INFO".

.OUTPUTS
  A log message with a timestamp and log level.

.EXAMPLE
  Write-LogMessage -Message "This is an informational message."
  Logs an informational message with the default log level "INFO".
  Write-LogMessage -Message "This is a warning message." -Level "WARNING"
  Logs a warning message with the log level "WARNING".

.NOTES
  This function is used to log messages with a timestamp and log level.
#>
function Write-LogMessage {
  [CmdletBinding()]
  [Alias("log-message")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Message,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Level = "INFO"
  )

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Write-Output "[$timestamp][$Level] $Message"
}
