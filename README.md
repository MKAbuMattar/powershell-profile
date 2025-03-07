# My PowerShell Profile

Welcome to my PowerShell profile! Here, you'll find a curated collection of functions, aliases, and settings tailored to enhance my PowerShell workflow, making it both more enjoyable and productive.

## Table of Contents

- [Quick Setup (Windows)](#quick-setup-windows)
- [The Profile Architecture](#the-profile-architecture)
- [Features](#features)
- [Modules](#modules)
  - [Directory Module](#directory-module)
  - [Docs Module](#docs-module)
  - [Environment Module](#environment-module)
  - [Logging Module](#logging-module)
  - [Network Module](#network-module)
  - [Process Module](#process-module)
  - [Starship Module](#starship-module)
  - [Update Module](#update-module)
  - [Utility Module](#utility-module)
- [Contributing](#contributing)

## Quick Setup (Windows)

Jumpstart your PowerShell experience with just one command:

```powershell
irm "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/setup.ps1" | iex
```

## Features

This PowerShell profile script includes:

- **UTF-8 Encoding**: Sets the console encoding to UTF-8.
- **Module Management**: Checks and installs necessary modules like Terminal-Icons, PowerShellGet, CompletionPredictor, PSReadLine, and Posh-Git.
- **PSReadLine Configuration**: Customizes PSReadLine options and key handlers for an enhanced command-line experience.
- **Custom Modules**: Imports custom modules for environment settings, logging, starship prompt, updates, and utilities.
- **Starship Prompt**: Loads and configures the Starship prompt.
- **Chocolatey Integration**: Sets and imports the Chocolatey profile if available.
- **Auto Updates**: Invokes functions to update the profile and PowerShell if the auto-update flags are set.
- **Editor Configuration**: Sets the default editor based on availability (nvim, vi, code, notepad).
- **FastFetch**: Runs FastFetch if available to quickly fetch and display system information.
- **Directory Modules**: Imports directory modules for file management and navigation.
- **Network Modules**: Imports network modules for network-related functions and aliases.
- **Utility Modules**: Imports utility modules for additional functions and aliases.

## Modules

### Directory Module

The Directory module provides functions to navigate directories and manage files:

- **Find-Files** (Alias: `ff`): Finds files matching a specified name pattern in the current directory and its subdirectories.
  - Example: `ff "*.ps1"`
- **Set-FreshFile** (Alias: `touch`): Creates a new empty file or updates the timestamp of an existing file.
  - Example: `touch "file.txt"`
- **Expand-File** (Alias: `unzip`): Extracts a file to the current directory.
  - Example: `unzip "file.zip"`
- **Compress-Files** (Alias: `zip`): Compresses files into a zip archive.
  - Example: `zip -Files "file1.txt", "file2.txt" -Archive "files.zip"`
- **Get-ContentMatching** (Alias: `grep`): Searches for text in files using regular expressions.
  - Example: `grep -Pattern "pattern" -Path "file.txt"`
- **Set-ContentMatching** (Alias: `sed`): Searches for a string in a file and replaces it with another string.
  - Example: `sed -file "file.txt" -find "pattern" -replace "replacement"`
- **z**: Windows equivalent of the 'cd' command, z will print the matched directory before navigating to it.
  - Example: `z ~/Documents`
- **zi**: Windows equivalent of the 'cd' command, but with interactive selection (using fzf)
  - Example: `zi ~/doc/my-pjet`
- **Get-FileHead** (Alias: `head`): Retrieves the first few lines of a file.
  - Example: `head "file.txt"`
- **Get-FileTail** (Alias: `tail`): Retrieves the last few lines of a file.
  - Example: `tail "file.txt"`
- **Get-ShortPath** (Alias: `shortpath`): Retrieves the short path of a file or directory.
  - Example: `shortpath "C:\Users\Username\Documents"`
- **Invoke-UpOneDirectoryLevel** (Aliases: `cd.1`, `..`): Moves up one directory level.
  - Example: `cd.1`
- **Invoke-UpTwoDirectoryLevels** (Aliases: `cd.2`, `...`): Moves up two directory levels.
  - Example: `cd.2`
- **Invoke-UpThreeDirectoryLevels** (Aliases: `cd.3`, `....`): Moves up three directory levels.
  - Example: `cd.3`
- **Invoke-UpFourDirectoryLevels** (Aliases: `cd.4`, `.....`): Moves up four directory levels.
  - Example: `cd.4`
- **Invoke-UpFiveDirectoryLevels** (Aliases: `cd.5`, `......`): Moves up five directory levels.
  - Example: `cd.5`

### Docs Module

The Docs module provides functions to display help documentation for the PowerShell Profile Helper module:

- **Show-ProfileHelp** (Alias: `profile-help`): Displays the help documentation for the PowerShell Profile Helper module.
  - Example: `Show-ProfileHelp`
  - Example: `Show-ProfileHelp -Section 'Directory'`

### Environment Module

The Environment module provides functions to manage environment variables, test GitHub connectivity, and manipulate the PATH environment variable:

- **Invoke-ReloadPathEnvironmentVariable** (Aliases: `reload-env-path`, `reload-path`): Reloads the PATH environment variable.
  - Example: `reload-path`
- **Get-PathEnvironmentVariable** (Aliases: `get-env-path`, `get-path`): Retrieves the PATH environment variable.
  - Example: `get-path`
- **Add-PathEnvironmentVariable** (Aliases: `add-path`, `set-path`): Sets the PATH environment variable.
  - Example: `add-path "C:\Program Files\Example"`
- **Remove-PathEnvironmentVariable**: Removes a path from the PATH environment variable.
  - Example: `Remove-PathEnvironmentVariable "C:\Program Files\Example"`
- **Set-EnvVar** (Aliases: `export`, `set-env`): Exports an environment variable.
  - Example: `set-env "name" "value"`
- **Get-EnvVar** (Alias: `get-env`): Retrieves the value of an environment variable.
  - Example: `get-env "name"`
- **AutoUpdateProfile**: A global variable to disable/enable the Auto Update feature for the PowerShell profile.
- **AutoUpdatePowerShell**: A global variable to disable/enable the Auto Update feature for PowerShell.
- **CanConnectToGitHub**: A global variable to test if the machine can connect to GitHub.

### Logging Module

The Logging module provides functions to log messages with a timestamp and log level:

- **Write-LogMessage** (Alias: `log-message`): Logs a message with a timestamp and log level. The default log level is "INFO".
  - Example: `Write-LogMessage -Message "This is an informational message."`
  - Example: `Write-LogMessage -Message "This is a warning message." -Level "WARNING"`

### Network Module

The Network module provides functions to manage network settings and perform network-related tasks:

- **Get-MyIPAddress** (Alias: `my-ip`): Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.
  - Example: `Get-MyIPAddress -Local -IPv4 -IPv6`
  - Example: `Get-MyIPAddress -Local`
  - Example: `Get-MyIPAddress -IPv4`
  - Example: `Get-MyIPAddress -IPv6`
- **Clear-FlushDNS** (Alias: `flush-dns`): Clears and flushes the DNS cache.
  - Example: `flush-dns`

### Process Module

The Process module provides functions to manage processes and retrieve process information:

- **Get-SystemInfo** (Alias: `sysinfo`): Retrieves system information.
  - Example: `sysinfo`
- **Get-AllProcesses** (Alias: `pall`): Retrieves a list of all running processes.
  - Example: `pall`
- **Get-ProcessByName** (Alias: `pgrep`): Finds a process by name.
  - Example: `pgrep "process"`
- **Get-ProcessByPort** (Alias: `portgrep`): Finds a process by port.
  - Example: `portgrep 80`
- **Stop-ProcessByName** (Alias: `pkill`): Terminates a process by name.
  - Example: `pkill "process"`
- **Stop-ProcessByPort** (Alias: `portkill`): Terminates a process by port.
  - Example: `portkill 80`
- **Invoke-ClearCache** (Alias: `cache-clear`): Clears the cache of a specified application.
  - Example: `cache-clear "All"`

### Starship Module

The Starship module provides functions to transiently invoke the Starship prompt:

- **Invoke-StarshipTransientFunction** (Alias: `starship-transient`): Invokes the Starship module transiently to load the Starship prompt.
  - Example: `Invoke-StarshipTransientFunction`

### Update Module

The Update module provides functions to update the local profile module directory, profile, and PowerShell:

- **Update-LocalProfileModuleDirectory** (Alias: `update-local-module`): Updates the Modules directory in the local profile with the latest version from the GitHub repository.
  - Example: `Update-LocalProfileModuleDirectory`
- **Update-Profile** (Alias: `update-profile`): Checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected.
  - Example: `Update-Profile`
- **Update-PowerShell** (Alias: `update-ps1`): Checks for updates to PowerShell and upgrades to the latest version if available.
  - Example: `Update-PowerShell`

### Utility Module

The Utility module provides a set of useful functions to enhance your PowerShell experience:

- **Test-Administrator** (Alias: `is-admin`): Checks if the current user has administrator privileges.
  - Example: `is-admin`
- **Test-CommandExists** (Alias: `command-exists`): Checks if a command exists in the current environment.
  - Example: `command-exists "ls"`
- **Invoke-ReloadProfile** (Alias: `reload-profile`): Reloads the PowerShell profile to apply changes.
  - Example: `reload-profile`
- **Get-Uptime** (Alias: `uptime`): Retrieves the system uptime in a human-readable format.
  - Example: `uptime`
- **Get-CommandDefinition** (Alias: `def`): Retrieves the definition of a command.
  - Example: `def "ls"`
- **Get-RandomQuote** (Alias: `quote`): Retrieves a random quote from an online API.
  - Example: `quote`
- **Get-WeatherForecast** (Alias: `weather`): Retrieves the weather forecast for a specified location.
  - Example: `weather -Location "Amman"`
- **Start-Countdown** (Alias: `countdown`): Starts a countdown timer.
  - Example: `countdown -Duration "25s" -Title "Break Time"`
  - Example: `countdown -Duration "02:15PM" -Title "Lunch Time"`
- **Start-Stopwatch** (Alias: `stopwatch`): Starts a stopwatch timer.
  - Example: `stopwatch -Title "Workout"`
- **Get-WallClock** (Alias: `clock`): Retrieves the current time in a specified timezone.
  - Example: `wallclock -TimeZone "Asia/Amman"`
- **Start-Matrix** (Alias: `matrix`): Displays a matrix rain animation in the console.
  - Example: `matrix`

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please open an issue or submit a pull request on [GitHub](https://github.com/MKAbuMattar/powershell-profile). Make sure to follow the project's code of conduct and guidelines for contributing.
