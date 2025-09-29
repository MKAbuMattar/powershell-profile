<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Environment\README.md -->

# Environment Module

## **Module Overview:**

The Environment module provides a suite of functions for managing and interacting with the PowerShell environment. This includes operations like reloading and modifying the system PATH, setting and getting environment variables (both session-specific and persistently), and checking network connectivity. It also houses global variables that control automatic update features for the profile and PowerShell itself.

## **Key Features:**

- Simplified management of the system and user PATH environment variable (reload, get, add, remove persistently).
- Easy setting and retrieval of custom environment variables (session and persistent).
- Control over auto-update mechanisms for the PowerShell profile and PowerShell itself.
- Utility to test network connectivity to GitHub.com, crucial for update processes.

## **Functions and Variables:**

- **`Invoke-ReloadPathEnvironmentVariable`** (Aliases: `reload-env-path`, `reload-path`):

  - _Description:_ Reloads the PATH environment variable from the system registry, making newly added paths (e.g., by installers) available in the current PowerShell session without needing to restart it.
  - _Usage:_ `reload-path`

- **`Get-PathEnvironmentVariable`** (Aliases: `get-env-path`, `get-path`):

  - _Description:_ Retrieves and displays the current PATH environment variable, with each path typically listed on a new line for improved readability.
  - _Usage:_ `get-path`

- **`Add-PathEnvironmentVariable`** (Aliases: `add-path`, `set-path`):

  - _Description:_ Adds a new path to the user's PATH environment variable persistently (i.e., it will be available in future sessions). It also updates the PATH for the current session.
  - _Parameters:_
    - `Path` (String, Mandatory): The directory path to add.
    - `Scope` (String, Optional): Specifies whether to add to 'User' or 'Machine' PATH. Defaults to 'User'. Machine scope requires administrator privileges.
  - _Usage:_ `add-path "C:\NewTool\bin"`
  - _Details:_ Warns if the path does not exist or is already in the PATH.

- **`Remove-PathEnvironmentVariable`**:

  - _Description:_ Removes a specified path from the user's PATH environment variable persistently. Also updates the PATH for the current session.
  - _Parameters:_
    - `Path` (String, Mandatory): The directory path to remove.
    - `Scope` (String, Optional): Specifies whether to remove from 'User' or 'Machine' PATH. Defaults to 'User'. Machine scope requires administrator privileges.
  - _Usage:_ `Remove-PathEnvironmentVariable "C:\OldTool\bin"`

- **`Set-EnvVar`** (Aliases: `export`, `set-env`):

  - _Description:_ Sets or modifies an environment variable. Can set it for the current session or persistently for the user or machine.
  - _Parameters:_
    - `Name` (String, Mandatory): The name of the environment variable.
    - `Value` (String, Mandatory): The value to assign to the variable.
    - `Persistent` (Switch, Optional): If specified, sets the variable persistently for the current user. Requires admin rights for machine-wide persistence.
    - `Scope` (String, Optional): 'User' or 'Machine' for persistent variables. Defaults to 'User'.
  - _Details:_ Similar to `export` in Unix-like shells for session variables. Persistent changes modify the registry.
  - _Usage:_
    - `set-env MY_VARIABLE "my_value"` (sets for current session)
    - `export MY_TEMP_VAR "temp_data"` (alias for session)
    - `set-env MY_APP_KEY "secret_key" -Persistent` (sets persistently for user)

- **`Get-EnvVar`** (Alias: `get-env`):
  - _Description:_ Retrieves the value of a specified environment variable. Checks session, user, and machine scopes.
  - _Parameters:_
    - `Name` (String, Mandatory): The name of the environment variable.
  - _Usage:_ `get-env "MY_VARIABLE"`

## **Global Variables:**

These variables are typically defined in the main profile script and can be used by various modules.

- **`$AutoUpdateProfile`** (Boolean):

  - _Description:_ Controls whether the PowerShell profile should attempt to automatically update itself (e.g., by pulling changes from a Git repository).
  - _Default:_ Typically `$true`.

- **`$AutoUpdatePowerShell`** (Boolean):

  - _Description:_ Controls whether the profile should attempt to automatically update the PowerShell version itself (e.g., using `winget`).
  - _Default:_ Typically `$true`.

- **`$CanConnectToGitHub`** (Boolean, Read-only):
  - _Description:_ A global variable that is set at profile load time based on a test to see if the machine can successfully connect to `GitHub.com`. This is often used by update functions to determine if they can fetch updates.
  - _Details:_ Its value is determined by attempting a lightweight network request to GitHub.

[Back to Modules](../../README.md#modules)

## **Contribution:**

Contributions to enhance environment management capabilities, such as more sophisticated PATH management or support for different environment variable scopes, are welcome. Please refer to the main [Contributing Guidelines](../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
