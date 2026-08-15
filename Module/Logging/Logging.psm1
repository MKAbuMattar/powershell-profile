#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Logging Module
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
# Version: 4.2.0
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

    process {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Output "[$timestamp][$Level] $Message"
    }
}

function Invoke-ErrorHandling {
    <#
    .SYNOPSIS
        Reports a failure with its underlying exception.

    .DESCRIPTION
        Writes the caller's summary and the exception behind it as a single ERROR line, then emits
        a non-terminating error so the caller's own error handling still applies.

        This function was previously defined only in setup.ps1, yet Update.psm1 called it twice.
        Those calls failed with "The term 'Invoke-ErrorHandling' is not recognized", so a genuine
        update failure produced a confusing second error instead of the real reason. Defining it
        here puts it alongside Write-LogMessage, where both callers can reach it.

    .PARAMETER ErrorMessage
        A short description of what failed, in the caller's terms.

    .PARAMETER ErrorRecord
        The error record that caused the failure, normally $_ from a catch block.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes to the error stream.

    .NOTES
        Does not stop the pipeline. Use `throw` when the caller must not continue.

    .EXAMPLE
        try { Update-Thing } catch { Invoke-ErrorHandling -ErrorMessage 'Could not update.' -ErrorRecord $_ }

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("handle-error")]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$ErrorMessage,

        [Parameter(Position = 1)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    $detail = if ($ErrorRecord) { $ErrorRecord.Exception.Message } else { 'No exception detail available.' }

    Write-LogMessage -Message "$ErrorMessage $detail" -Level 'ERROR'
    Write-Error -Message "$ErrorMessage $detail"
}
