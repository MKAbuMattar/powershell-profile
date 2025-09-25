#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile
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
#       This Module provides logging functionality for PowerShell scripts and modules.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Write-LogMessage {
  <#
  .SYNOPSIS
    Logs a message with a timestamp and log level.

  .DESCRIPTION
    This function logs a message with a timestamp and log level. The default log level is "INFO".

  .PARAMETER Message
    Specifies the message to log.

  .PARAMETER Level
    Specifies the log level. Default is "INFO".

  .INPUTS
    Message: (Required) The message to log.
    Level: (Optional) The log level. Default is "INFO".

  .OUTPUTS
    A log message with a timestamp and log level.

  .NOTES
    This function is used to log messages with a timestamp and log level.

  .EXAMPLE
    Write-LogMessage -Message "This is an informational message."
    Logs an informational message with the default log level "INFO".

  .EXAMPLE
    Write-LogMessage -Message "This is a warning message." -Level "WARNING"
    Logs a warning message with the log level "WARNING".

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
  [CmdletBinding()]
  [Alias("log-message")]
  [OutputType([string])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The message to log."
    )]
    [string]$Message,

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The log level. Default is 'INFO'."
    )]
    [ValidateSet(
      "INFO",
      "WARNING",
      "ERROR"
    )]
    [string]$Level = "INFO"
  )

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Write-Output "[$timestamp][$Level] $Message"
}
