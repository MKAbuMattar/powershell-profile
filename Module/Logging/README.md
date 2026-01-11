# Logging Module v5.0.0

Enhanced logging and error handling system with debug mode, error tracking, log rotation, and recovery mechanisms.

## Features

-   ✅ Structured logging with multiple levels (DEBUG, VERBOSE, INFO, WARNING, ERROR, CRITICAL, SUCCESS)
-   ✅ Comprehensive error tracking with stack traces
-   ✅ Automatic log rotation and cleanup
-   ✅ Debug and verbose modes
-   ✅ File and console logging
-   ✅ Error recovery and graceful degradation
-   ✅ Log archiving and export

## Quick Start

```powershell
# Basic logging
log "Operation completed"
log "Warning message" -Level WARNING
log "Critical error" -Level ERROR

# Error tracking
try { Get-Item "missing" } catch { Write-ErrorReport $_ -Context "File ops" }
Get-ErrorHistory -Last 10

# Debug mode
Set-DebugMode -Enabled
log "Debug info" -Level DEBUG

# Log maintenance
Clear-OldLogs -DaysToKeep 30
Export-LogArchive
```

## Functions

### Write-LogMessage (Aliases: log, log-message)

Logs messages with timestamp and level. Supports DEBUG, VERBOSE, INFO, WARNING, ERROR, CRITICAL, SUCCESS levels.

### Write-ErrorReport (Alias: log-error)

Captures detailed error information including stack trace and context.

### Get-ErrorHistory (Aliases: errors, error-history)

Retrieves error history with filtering by severity, context, time period, or count.

### Clear-OldLogs (Alias: clean-logs)

Removes log files older than specified days (default: 30).

### Export-LogArchive (Alias: export-logs)

Creates compressed archive of logs with optional error history.

### Set-DebugMode (Alias: debug-mode)

Enables/disables DEBUG level logging output.

### Set-VerboseMode (Alias: verbose-mode)

Enables/disables VERBOSE level logging output.

### Get-LoggingConfig (Alias: log-config)

Returns current logging configuration and statistics.

### Clear-ErrorHistory (Alias: clear-errors)

Clears all stored error reports from memory.

## Configuration

Configure in `config.json`:

```json
{
    "logging": {
        "enabled": true,
        "debugMode": false,
        "verboseMode": false,
        "errorReporting": {
            "enabled": true,
            "maxErrorHistory": 100
        },
        "logRotation": {
            "maxLogAgeDays": 30,
            "maxLogSizeMB": 10
        },
        "errorRecovery": {
            "gracefulDegradation": true,
            "continueOnError": true
        }
    }
}
```

## Log Levels

| Level    | Color    | Usage                                     |
| -------- | -------- | ----------------------------------------- |
| DEBUG    | Gray     | Debugging (only when debug mode on)       |
| VERBOSE  | DarkGray | Detailed info (only when verbose mode on) |
| INFO     | Green    | General messages                          |
| WARNING  | Yellow   | Warnings                                  |
| ERROR    | Red      | Errors                                    |
| CRITICAL | Magenta  | Critical failures                         |
| SUCCESS  | Cyan     | Success confirmations                     |

## Examples

```powershell
# Enable debug mode for troubleshooting
Set-DebugMode -Enabled
log "Starting process" -Level DEBUG

# Log with context
try {
    Import-Module "MyModule"
    log "Module loaded" -Level SUCCESS
} catch {
    Write-ErrorReport $_ -Context "Module Loading" -Severity High
}

# Review recent errors
Get-ErrorHistory -Last 5 | Format-Table Timestamp, Context, Message

# Clean up old logs
Clear-OldLogs -DaysToKeep 7

# Export for backup
Export-LogArchive -IncludeErrorHistory
```

## Best Practices

1. Use appropriate log levels (DEBUG for development, ERROR for failures)
2. Always provide context when logging errors
3. Enable debug mode only when needed
4. Run log cleanup regularly
5. Export logs before major changes

## Location

Logs are stored in `~/.logs/ps1-profile/` with format `profile-{timestamp}.log`.

## Version History

**v5.0.0** (2026-01-11): Complete rewrite with error handling, recovery, rotation, debug mode, and comprehensive tracking.

---

For more details: [GitHub](https://github.com/MKAbuMattar/powershell-profile)
