<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Logging\README.md -->

# Logging Module

## **Module Overview:**

The Logging module provides a simple yet effective function for recording log messages within PowerShell scripts and profile operations. It allows for messages to be timestamped and categorized by log levels (e.g., INFO, WARNING, ERROR), facilitating easier debugging and monitoring of script execution.

## **Key Features:**

- Timestamped log entries for chronological tracking.
- Support for different log levels to categorize message severity.
- Customizable log output (e.g., console, file).

## **Functions:**

- **`Write-LogMessage`** (Alias: `log-message`):
  - _Description:_ Logs a message with a prepended timestamp and a specified log level. If no level is provided, it defaults to "INFO".
  - _Parameters:_
    - `Message` (String, Mandatory): The content of the log message.
    - `Level` (String, Optional): The severity level of the log message (e.g., "INFO", "WARNING", "ERROR", "DEBUG"). Defaults to "INFO".
    - `LogPath` (String, Optional): Specifies a file path to write the log message to. If not provided, logs may go to the console or a default log file.
  - _Usage Examples:_
    - `Write-LogMessage -Message "Script execution started."`
    - `log-message -Message "An unexpected issue occurred." -Level "ERROR"`
    - `Write-LogMessage -Message "User preference loaded." -Level "DEBUG" -LogPath "C:\logs\profile.log"`
  - _Details:_ The format of the log output typically includes the timestamp, log level, and the message itself. Configuration for log file location and rotation can be extended.

[Back to Modules](../../README.md#modules)

## **Contribution:**

Enhancements to the logging capabilities, such as adding more log output options (e.g., Event Log), log rotation, or structured logging, are welcome. Please see the main [Contributing Guidelines](../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
