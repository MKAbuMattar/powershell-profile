<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Process\README.md -->

# Process Module

## **Module Overview:**

The Process module is designed to provide robust tools for managing and inspecting system processes from the PowerShell command line. It includes functions for retrieving system information, listing processes, finding processes by name or port, and terminating them. Additionally, it offers a utility for clearing application caches.

## **Key Features:**

- Comprehensive system information retrieval.
- Listing all running processes or filtering by name/port.
- Terminating processes by name or port.
- Utility for clearing caches of various applications.

## **Functions:**

- **`Get-SystemInfo`** (Alias: `sysinfo`):

  - _Description:_ Retrieves and displays a summary of system information. This can include OS version, hardware details, memory usage, etc.
  - _Usage:_ `sysinfo`

- **`Get-AllProcesses`** (Alias: `pall`):

  - _Description:_ Retrieves a list of all currently running processes on the system.
  - _Usage:_ `pall`
  - _Details:_ Similar to `Get-Process` but potentially with custom formatting or additional info.

- **`Get-ProcessByName`** (Alias: `pgrep`):

  - _Description:_ Finds and displays processes that match a specified name or pattern.
  - _Usage:_ `pgrep "chrome"`
  - _Details:_ Acts like `grep` for processes.

- **`Get-ProcessByPort`** (Alias: `portgrep`):

  - _Description:_ Finds and displays processes that are listening on a specific network port.
  - _Usage:_ `portgrep 8080`
  - _Details:_ Useful for identifying which application is using a particular port.

- **`Stop-ProcessByName`** (Alias: `pkill`):

  - _Description:_ Terminates processes that match a specified name or pattern.
  - _Usage:_ `pkill "notepad"`
  - _Details:_ Use with caution. May prompt for confirmation by default.

- **`Stop-ProcessByPort`** (Alias: `portkill`):

  - _Description:_ Terminates the process(es) listening on a specific network port.
  - _Usage:_ `portkill 8080`
  - _Details:_ Use with caution. Identifies the process by port and then terminates it.

- **`Invoke-ClearCache`** (Alias: `cache-clear`):
  - _Description:_ Clears cached files for specified applications or system components to free up disk space or resolve issues related to outdated cache data.
  - _Usage:_ `cache-clear "browsers"` or `cache-clear "All"`
  - _Details:_ The specific applications or cache types supported would be defined within the function (e.g., "browsers", "npm", "pip", "windows_update").

[Back to Modules](../../README.md#modules)

## **Contribution:**

Ideas for new process management utilities or enhancements to existing cache clearing capabilities are welcome. Please follow the main [Contributing Guidelines](../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
