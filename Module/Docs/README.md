<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Docs\README.md -->

# Docs Module

## **Module Overview:**

The Docs module is dedicated to providing easy access to help and documentation for the entire PowerShell Profile Helper system. Its primary function, `Show-ProfileHelp`, allows users to quickly view documentation sections for different modules and functions, making it easier to understand and utilize the various features available within the profile.

## **Key Features:**

- Centralized access to all profile documentation directly from PowerShell.
- Ability to view documentation for specific modules or individual functions.
- Supports fetching documentation from local Markdown files.

## **Functions:**

- **`Show-ProfileHelp`** (Alias: `profile-help`):
  - _Description:_ Displays the help documentation for the PowerShell Profile Helper system. Users can specify a module name (e.g., 'Directory') or a specific function name (e.g., 'Find-Files') to view its detailed documentation. If no argument is provided, it may display general help or a table of contents for all available documentation.
  - _Usage Examples:_
    - `Show-ProfileHelp` (Displays general help or a list of documented modules/functions)
    - `Show-ProfileHelp -Section 'Directory'` (Displays help specifically for the Directory module)
    - `profile-help Find-Files` (Displays help for the `Find-Files` function if available)
  - _Details:_ This function is the main entry point for accessing help. It is designed to parse Markdown files located within each module's directory (typically `README.md`) to display relevant help content. It can be extended to support other documentation sources in the future.

[Back to Modules](../../README.md#modules)

## **Contribution:**

Suggestions for improving the documentation structure, the `Show-ProfileHelp` function (e.g., adding search capabilities, more output formats), or the content of the documentation itself are welcome. Please follow the main [Contributing Guidelines](../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
