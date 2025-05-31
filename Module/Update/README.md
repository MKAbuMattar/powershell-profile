<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Update\README.md -->

# Update Module

## **Module Overview:**

The Update module provides a set of functions dedicated to keeping the PowerShell environment and the profile itself up-to-date. This includes updating the local profile modules from a Git repository, checking for and applying updates to the main profile script, updating PowerShell to the latest version, and refreshing the Windows Terminal configuration.

## **Key Features:**

- Automated updates for profile modules from a source repository.
- Self-update capability for the PowerShell profile.
- PowerShell version update management.
- Windows Terminal configuration synchronization.

## **Functions:**

- **`Update-LocalProfileModuleDirectory`** (Alias: `update-local-module`):

  - _Description:_ Updates the `Modules` directory within the local PowerShell profile path. It typically fetches the latest version of the modules from a specified GitHub repository (or other version control source) and replaces the local copies.
  - _Usage:_ `Update-LocalProfileModuleDirectory`
  - _Details:_ This ensures that all helper modules used by the profile are current.

- **`Update-Profile`** (Alias: `update-profile`):

  - _Description:_ Checks a designated GitHub repository (or other source) for updates to the main PowerShell profile script (e.g., `Microsoft.PowerShell_profile.ps1`). If new changes are detected, it downloads and applies them to the local profile.
  - _Usage:_ `Update-Profile`
  - _Details:_ Often configured to run automatically if `$AutoUpdateProfile` (from the Environment module) is `$true`.

- **`Update-PowerShell`** (Alias: `update-ps1`):

  - _Description:_ Checks for newer stable releases of PowerShell and, if found, initiates an upgrade to the latest version. This helps in keeping the PowerShell engine itself current with the latest features and security patches.
  - _Usage:_ `Update-PowerShell`
  - _Details:_ May use `winget` or other package managers for the update process. Often configured to run automatically if `$AutoUpdatePowerShell` (from the Environment module) is `$true`.

- **`Update-WindowsTerminalConfig`** (Alias: `update-terminal-config`):
  - _Description:_ Updates the Windows Terminal settings file (`settings.json`) with the latest configuration, potentially from a backed-up or version-controlled copy. This is useful for synchronizing terminal appearance, profiles, and keybindings across different environments or after a fresh setup.
  - _Usage:_ `Update-WindowsTerminalConfig`
  - _Details:_ The source for the updated configuration needs to be defined (e.g., a specific file path, a Gist, or a file in a repository).

## **Dependencies and Configuration:**

- These update functions often rely on Git being installed and accessible in the PATH.
- Internet connectivity is required to check for and download updates.
- The specific GitHub repository URL for profile and module updates is typically configured within the profile scripts or as environment variables.

[Back to Modules](../../README.md#modules)

**Contribution:**
Improvements to the update mechanisms, such as adding support for different update sources, more robust error handling, or interactive update prompts, are welcome. Please consult the main [Contributing Guidelines](../../README.md#contributing).
