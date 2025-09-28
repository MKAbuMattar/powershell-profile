<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Starship\README.md -->

# Starship Module

## **Module Overview:**

The Starship module is focused on integrating the [Starship cross-shell prompt](https://starship.rs/) into the PowerShell environment. It primarily provides a mechanism to load or temporarily invoke the Starship prompt, allowing users to benefit from its rich, customizable, and context-aware features without necessarily making it the default permanent prompt.

## **Key Features:**

- Easy invocation of the Starship prompt.
- Allows for transient or session-specific use of Starship.

## **Background on Starship:**

Starship is a minimal, blazing-fast, and infinitely customizable prompt for any shell! It shows the information you need while you're working, while staying sleek and out of the way.

- **Context-aware:** Shows relevant information depending on the directory and system state (e.g., Git branch, Node.js version, Python virtual environment).
- **Customizable:** Configure every aspect of the prompt using a simple TOML file.
- **Fast:** Written in Rust for optimal performance.

**Functions:**

- **`Invoke-StarshipTransientFunction`** (Alias: `starship-transient`):
  - _Description:_ Loads and activates the Starship prompt for the current PowerShell session or a specific scope. This allows users to try Starship or use it on demand without altering their default PowerShell prompt configuration permanently.
  - _Usage:_ `Invoke-StarshipTransientFunction` or `starship-transient`
  - _Details:_ This function would typically execute the necessary Starship initialization commands (`starship init powershell`) and might handle the Starship binary path. If Starship is not installed, it might prompt the user to install it or provide instructions.

## **Prerequisites:**

- **Starship Installation:** To use this module effectively, Starship must be installed on your system. You can find installation instructions on the [official Starship website](https://starship.rs/guide/#installation).

**Configuration:**
Starship itself is configured via a `starship.toml` file, usually located in `~/.config/starship.toml`. This module does not manage Starship's configuration but enables its use within PowerShell.

[Back to Modules](../../README.md#modules)

## **Contribution:**

Contributions could include adding functions to help manage Starship installation, configuration, or providing different ways to integrate Starship (e.g., toggling it as the default prompt). Please refer to the main [Contributing Guidelines](../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
