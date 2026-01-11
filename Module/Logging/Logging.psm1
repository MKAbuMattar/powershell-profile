#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Logging Module
# Version: 5.0.0
# Author: Mohammad Abu Mattar
# Description: Enhanced logging and error handling system with debug mode support
# Created: 2021-09-01
# Updated: 2026-01-11
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

#region Private Variables

# Initialize module-level variables
$script:LogDirectory = Join-Path $HOME '.logs' 'ps1-profile'
$script:ErrorHistory = [System.Collections.ArrayList]::new()
$script:LogFile = $null
$script:DebugMode = $false
$script:VerboseMode = $false
$script:MaxErrorHistory = 100
$script:MaxLogAgeDays = 30
$script:MaxLogSizeMB = 10

#endregion

#region Private Functions

<#
.SYNOPSIS
    Initializes the logging directory structure.
#>
function Initialize-LogDirectory {
    [CmdletBinding()]
    param()
    
    if (-not (Test-Path $script:LogDirectory)) {
        New-Item -Path $script:LogDirectory -ItemType Directory -Force | Out-Null
    }
    
    # Set log file for current session
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $script:LogFile = Join-Path $script:LogDirectory "profile-$timestamp.log"
}

<#
.SYNOPSIS
    Writes a message to the log file.
#>
function Write-ToLogFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        
        [Parameter()]
        [string]$Level = 'INFO'
    )
    
    if (-not $script:LogFile) {
        Initialize-LogDirectory
    }
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp][$Level] $Message"
    
    try {
        Add-Content -Path $script:LogFile -Value $logEntry -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to write to log file: $_"
    }
}

<#
.SYNOPSIS
    Gets color for log level.
#>
function Get-LogLevelColor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Level
    )
    
    switch ($Level.ToUpper()) {
        'DEBUG' { return 'Gray' }
        'VERBOSE' { return 'DarkGray' }
        'INFO' { return 'Green' }
        'WARNING' { return 'Yellow' }
        'ERROR' { return 'Red' }
        'CRITICAL' { return 'Magenta' }
        'SUCCESS' { return 'Cyan' }
        default { return 'White' }
    }
}

#endregion

#region Public Functions

<#
.SYNOPSIS
    Logs a message with timestamp and level.
.DESCRIPTION
    The Write-LogMessage function logs messages with various severity levels,
    supports both console and file output, and respects debug/verbose mode settings.
    All messages are automatically logged to file for audit purposes.
.PARAMETER Message
    The message to log.
.PARAMETER Level
    The severity level (DEBUG, VERBOSE, INFO, WARNING, ERROR, CRITICAL, SUCCESS).
.PARAMETER ToFile
    Force writing to log file even if normally skipped.
.PARAMETER NoConsole
    Skip console output and only write to file.
.INPUTS
    String - Message can be piped to this function.
.OUTPUTS
    None. Outputs to console and/or log file.
.NOTES
    Module: Logging
    Version: 5.0.0
    Author: Mohammad Abu Mattar
.EXAMPLE
    Write-LogMessage "Operation completed successfully"
    Logs an informational message.
.EXAMPLE
    Write-LogMessage "Configuration loaded" -Level SUCCESS
    Logs a success message in cyan.
.EXAMPLE
    Write-LogMessage "Debug info" -Level DEBUG
    Only visible when debug mode is enabled.
#>
function Write-LogMessage {
    [CmdletBinding()]
    [Alias('log-message', 'log')]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$Message,
        
        [Parameter(Position = 1)]
        [ValidateSet('DEBUG', 'VERBOSE', 'INFO', 'WARNING', 'ERROR', 'CRITICAL', 'SUCCESS')]
        [string]$Level = 'INFO',
        
        [Parameter()]
        [switch]$ToFile,
        
        [Parameter()]
        [switch]$NoConsole
    )
    
    process {
        # Check debug/verbose filtering
        if ($Level -eq 'DEBUG' -and -not $script:DebugMode) {
            return
        }
        
        if ($Level -eq 'VERBOSE' -and -not $script:VerboseMode) {
            return
        }
        
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $formattedMessage = "[$timestamp][$Level] $Message"
        
        # Console output
        if (-not $NoConsole) {
            $color = Get-LogLevelColor -Level $Level
            Write-Host $formattedMessage -ForegroundColor $color
        }
        
        # File output
        if ($ToFile -or $Level -in @('ERROR', 'CRITICAL', 'WARNING')) {
            Write-ToLogFile -Message $Message -Level $Level
        }
    }
}

<#
.SYNOPSIS
    Records an error in the error history.
.DESCRIPTION
    The Write-ErrorReport function captures error details including stack trace,
    context, and timestamp. Errors are stored in memory and logged to file for
    later analysis and recovery.
.PARAMETER ErrorRecord
    The ErrorRecord object to log.
.PARAMETER Context
    Additional context information about where the error occurred.
.PARAMETER Severity
    Error severity level (Low, Medium, High, Critical).
.INPUTS
    ErrorRecord - Can pipe ErrorRecord objects.
.OUTPUTS
    PSCustomObject containing the error report.
.NOTES
    Module: Logging
    Version: 5.0.0
    
    Error history is limited to the most recent $MaxErrorHistory errors.
    Old errors are automatically pruned.
.EXAMPLE
    try { Get-Item "nonexistent" } catch { Write-ErrorReport $_ -Context "File operation" }
    Captures and logs an error with context.
.EXAMPLE
    Write-ErrorReport $Error[0] -Severity Critical
    Logs the most recent error as critical.
#>
function Write-ErrorReport {
    [CmdletBinding()]
    [Alias('log-error')]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        
        [Parameter(Position = 1)]
        [string]$Context = 'Unknown',
        
        [Parameter()]
        [ValidateSet('Low', 'Medium', 'High', 'Critical')]
        [string]$Severity = 'Medium'
    )
    
    process {
        $errorReport = [PSCustomObject]@{
            Timestamp      = Get-Date
            Context        = $Context
            Severity       = $Severity
            Message        = $ErrorRecord.Exception.Message
            FullyQualified = $ErrorRecord.FullyQualifiedErrorId
            Category       = $ErrorRecord.CategoryInfo.Category
            TargetObject   = $ErrorRecord.TargetObject
            ScriptStack    = $ErrorRecord.ScriptStackTrace
            InvocationInfo = $ErrorRecord.InvocationInfo
            Exception      = $ErrorRecord.Exception
        }
        
        # Add to history
        $script:ErrorHistory.Add($errorReport) | Out-Null
        
        # Prune old errors
        if ($script:ErrorHistory.Count -gt $script:MaxErrorHistory) {
            $script:ErrorHistory.RemoveAt(0)
        }
        
        # Log to file
        $logMessage = @"
ERROR REPORT
Context: $Context
Severity: $Severity
Message: $($ErrorRecord.Exception.Message)
Category: $($ErrorRecord.CategoryInfo.Category)
Target: $($ErrorRecord.TargetObject)
Stack Trace:
$($ErrorRecord.ScriptStackTrace)
"@
        
        Write-ToLogFile -Message $logMessage -Level 'ERROR'
        Write-LogMessage "Error logged: $($ErrorRecord.Exception.Message)" -Level ERROR
        
        return $errorReport
    }
}

<#
.SYNOPSIS
    Retrieves error history.
.DESCRIPTION
    The Get-ErrorHistory function returns logged errors with filtering options.
    Use this to analyze error patterns, troubleshoot issues, or generate reports.
.PARAMETER Last
    Return only the most recent N errors.
.PARAMETER Severity
    Filter by error severity level.
.PARAMETER Context
    Filter by context string (supports wildcards).
.PARAMETER Since
    Return errors since specified datetime.
.INPUTS
    None.
.OUTPUTS
    Array of error report objects.
.NOTES
    Module: Logging
    Version: 5.0.0
    
    Error history is stored in memory for the current session only.
.EXAMPLE
    Get-ErrorHistory -Last 10
    Returns the 10 most recent errors.
.EXAMPLE
    Get-ErrorHistory -Severity Critical
    Returns all critical errors.
.EXAMPLE
    Get-ErrorHistory -Context "*module*" -Since (Get-Date).AddHours(-1)
    Returns module-related errors from the last hour.
#>
function Get-ErrorHistory {
    [CmdletBinding()]
    [Alias('errors', 'error-history')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter()]
        [int]$Last,
        
        [Parameter()]
        [ValidateSet('Low', 'Medium', 'High', 'Critical')]
        [string]$Severity,
        
        [Parameter()]
        [string]$Context,
        
        [Parameter()]
        [datetime]$Since
    )
    
    $errors = $script:ErrorHistory
    
    # Apply filters
    if ($Severity) {
        $errors = $errors | Where-Object { $_.Severity -eq $Severity }
    }
    
    if ($Context) {
        $errors = $errors | Where-Object { $_.Context -like $Context }
    }
    
    if ($Since) {
        $errors = $errors | Where-Object { $_.Timestamp -ge $Since }
    }
    
    # Return last N errors
    if ($Last) {
        $errors = $errors | Select-Object -Last $Last
    }
    
    return $errors
}

<#
.SYNOPSIS
    Clears old log files.
.DESCRIPTION
    The Clear-OldLogs function removes log files older than the specified number of days.
    Use this for log rotation and maintenance to prevent disk space issues.
.PARAMETER DaysToKeep
    Number of days of logs to retain (default: 30).
.PARAMETER WhatIf
    Shows what would be deleted without actually deleting.
.INPUTS
    None.
.OUTPUTS
    Summary of deleted files.
.NOTES
    Module: Logging
    Version: 5.0.0
    
    This function only affects files in the profile log directory.
    Active log files are never deleted.
.EXAMPLE
    Clear-OldLogs
    Removes logs older than 30 days.
.EXAMPLE
    Clear-OldLogs -DaysToKeep 7
    Removes logs older than 7 days.
.EXAMPLE
    Clear-OldLogs -WhatIf
    Shows what would be deleted without deleting.
#>
function Clear-OldLogs {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('clean-logs')]
    param(
        [Parameter()]
        [int]$DaysToKeep = $script:MaxLogAgeDays,
        
        [Parameter()]
        [switch]$Force
    )
    
    Initialize-LogDirectory
    
    $cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
    $logFiles = Get-ChildItem -Path $script:LogDirectory -Filter "*.log" -File
    
    $filesToDelete = $logFiles | Where-Object {
        $_.LastWriteTime -lt $cutoffDate -and $_.FullName -ne $script:LogFile
    }
    
    if ($filesToDelete.Count -eq 0) {
        Write-LogMessage "No old log files to delete" -Level INFO
        return
    }
    
    $totalSize = ($filesToDelete | Measure-Object -Property Length -Sum).Sum
    $totalSizeMB = [math]::Round($totalSize / 1MB, 2)
    
    Write-LogMessage "Found $($filesToDelete.Count) log files to delete ($totalSizeMB MB)" -Level INFO
    
    if ($PSCmdlet.ShouldProcess("$($filesToDelete.Count) log files", "Delete")) {
        foreach ($file in $filesToDelete) {
            try {
                Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                Write-LogMessage "Deleted: $($file.Name)" -Level DEBUG
            }
            catch {
                Write-LogMessage "Failed to delete $($file.Name): $_" -Level WARNING
            }
        }
        
        Write-LogMessage "Deleted $($filesToDelete.Count) log files ($totalSizeMB MB)" -Level SUCCESS
    }
    
    return [PSCustomObject]@{
        FilesDeleted = $filesToDelete.Count
        SpaceFreed   = $totalSizeMB
        CutoffDate   = $cutoffDate
    }
}

<#
.SYNOPSIS
    Exports logs to an archive.
.DESCRIPTION
    The Export-LogArchive function creates a compressed archive of log files
    for backup or transfer purposes.
.PARAMETER OutputPath
    Path where the archive will be created.
.PARAMETER IncludeErrorHistory
    Include error history in the archive.
.INPUTS
    None.
.OUTPUTS
    FileInfo object for the created archive.
.NOTES
    Module: Logging
    Version: 5.0.0
.EXAMPLE
    Export-LogArchive -OutputPath "C:\Backup\logs.zip"
    Creates an archive of all log files.
.EXAMPLE
    Export-LogArchive -IncludeErrorHistory
    Creates archive with error history JSON.
#>
function Export-LogArchive {
    [CmdletBinding()]
    [Alias('export-logs')]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter()]
        [string]$OutputPath,
        
        [Parameter()]
        [switch]$IncludeErrorHistory
    )
    
    Initialize-LogDirectory
    
    if (-not $OutputPath) {
        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $OutputPath = Join-Path $HOME "logs-archive-$timestamp.zip"
    }
    
    # Ensure .zip extension
    if ([System.IO.Path]::GetExtension($OutputPath) -ne '.zip') {
        $OutputPath += '.zip'
    }
    
    Write-LogMessage "Creating log archive: $OutputPath" -Level INFO
    
    try {
        # Export error history if requested
        if ($IncludeErrorHistory -and $script:ErrorHistory.Count -gt 0) {
            $errorHistoryPath = Join-Path $script:LogDirectory 'error-history.json'
            $script:ErrorHistory | ConvertTo-Json -Depth 10 | Set-Content -Path $errorHistoryPath
        }
        
        # Create archive
        Compress-Archive -Path "$script:LogDirectory\*" -DestinationPath $OutputPath -Force -ErrorAction Stop
        
        # Clean up temp error history file
        if ($IncludeErrorHistory) {
            $errorHistoryPath = Join-Path $script:LogDirectory 'error-history.json'
            if (Test-Path $errorHistoryPath) {
                Remove-Item -Path $errorHistoryPath -Force
            }
        }
        
        $archiveInfo = Get-Item $OutputPath
        $sizeMB = [math]::Round($archiveInfo.Length / 1MB, 2)
        
        Write-LogMessage "Archive created successfully ($sizeMB MB)" -Level SUCCESS
        
        return $archiveInfo
    }
    catch {
        Write-LogMessage "Failed to create archive: $_" -Level ERROR
        Write-ErrorReport $_ -Context 'Export-LogArchive' -Severity High
        throw
    }
}

<#
.SYNOPSIS
    Enables or disables debug mode.
.DESCRIPTION
    The Set-DebugMode function controls whether DEBUG level messages are displayed.
    Debug mode is useful for troubleshooting and development.
.PARAMETER Enabled
    Enable or disable debug mode.
.INPUTS
    None.
.OUTPUTS
    None. Updates debug mode state.
.NOTES
    Module: Logging
    Version: 5.0.0
.EXAMPLE
    Set-DebugMode -Enabled
    Enables debug logging.
.EXAMPLE
    Set-DebugMode
    Disables debug logging.
#>
function Set-DebugMode {
    [CmdletBinding()]
    [Alias('debug-mode')]
    param(
        [Parameter()]
        [switch]$Enabled
    )
    
    $script:DebugMode = $Enabled.IsPresent
    $status = if ($Enabled) { 'enabled' } else { 'disabled' }
    Write-LogMessage "Debug mode $status" -Level INFO
}

<#
.SYNOPSIS
    Enables or disables verbose mode.
.DESCRIPTION
    The Set-VerboseMode function controls whether VERBOSE level messages are displayed.
.PARAMETER Enabled
    Enable or disable verbose mode.
.INPUTS
    None.
.OUTPUTS
    None. Updates verbose mode state.
.NOTES
    Module: Logging
    Version: 5.0.0
.EXAMPLE
    Set-VerboseMode -Enabled
    Enables verbose logging.
#>
function Set-VerboseMode {
    [CmdletBinding()]
    [Alias('verbose-mode')]
    param(
        [Parameter()]
        [switch]$Enabled
    )
    
    $script:VerboseMode = $Enabled.IsPresent
    $status = if ($Enabled) { 'enabled' } else { 'disabled' }
    Write-LogMessage "Verbose mode $status" -Level INFO
}

<#
.SYNOPSIS
    Gets current logging configuration.
.DESCRIPTION
    Returns the current state of the logging system including paths and settings.
.INPUTS
    None.
.OUTPUTS
    PSCustomObject with logging configuration.
.NOTES
    Module: Logging
    Version: 5.0.0
.EXAMPLE
    Get-LoggingConfig
    Returns current logging configuration.
#>
function Get-LoggingConfig {
    [CmdletBinding()]
    [Alias('log-config')]
    [OutputType([PSCustomObject])]
    param()
    
    Initialize-LogDirectory
    
    $logFiles = Get-ChildItem -Path $script:LogDirectory -Filter "*.log" -File -ErrorAction SilentlyContinue
    $totalSize = ($logFiles | Measure-Object -Property Length -Sum).Sum
    
    return [PSCustomObject]@{
        LogDirectory      = $script:LogDirectory
        CurrentLogFile    = $script:LogFile
        DebugMode         = $script:DebugMode
        VerboseMode       = $script:VerboseMode
        ErrorHistoryCount = $script:ErrorHistory.Count
        MaxErrorHistory   = $script:MaxErrorHistory
        MaxLogAgeDays     = $script:MaxLogAgeDays
        MaxLogSizeMB      = $script:MaxLogSizeMB
        LogFileCount      = $logFiles.Count
        TotalLogSizeMB    = [math]::Round($totalSize / 1MB, 2)
    }
}

<#
.SYNOPSIS
    Clears the error history.
.DESCRIPTION
    Removes all stored error reports from memory.
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    Module: Logging
    Version: 5.0.0
.EXAMPLE
    Clear-ErrorHistory
    Clears all error history.
#>
function Clear-ErrorHistory {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('clear-errors')]
    param()
    
    if ($PSCmdlet.ShouldProcess("Error History", "Clear")) {
        $count = $script:ErrorHistory.Count
        $script:ErrorHistory.Clear()
        Write-LogMessage "Cleared $count errors from history" -Level INFO
    }
}

#endregion

#region Module Initialization

# Initialize logging on module load
Initialize-LogDirectory

# Load debug/verbose settings from config if available
if (Get-Command -Name Get-ProfileConfig -ErrorAction SilentlyContinue) {
    $loggingConfig = Get-ProfileConfig -Key 'logging' -Default @{}
    
    if ($loggingConfig.debugMode) {
        $script:DebugMode = $loggingConfig.debugMode
    }
    
    if ($loggingConfig.verboseMode) {
        $script:VerboseMode = $loggingConfig.verboseMode
    }
    
    if ($loggingConfig.maxLogAgeDays) {
        $script:MaxLogAgeDays = $loggingConfig.maxLogAgeDays
    }
}

#endregion

# Export module members
Export-ModuleMember -Function @(
    'Write-LogMessage',
    'Write-ErrorReport',
    'Get-ErrorHistory',
    'Clear-OldLogs',
    'Export-LogArchive',
    'Set-DebugMode',
    'Set-VerboseMode',
    'Get-LoggingConfig',
    'Clear-ErrorHistory'
) -Alias @(
    'log-message',
    'log',
    'log-error',
    'errors',
    'error-history',
    'clean-logs',
    'export-logs',
    'debug-mode',
    'verbose-mode',
    'log-config',
    'clear-errors'
)
