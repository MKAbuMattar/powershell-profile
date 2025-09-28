# My PowerShell Profile

Welcome to my PowerShell profile! Here, you'll find a curated collection of functions, aliases, and settings tailored to enhance my PowerShell workflow, making it both more enjoyable and productive.

## Table of Contents

- [Quick Setup (Windows)](#quick-setup-windows)
- [The Profile Architecture](#the-profile-architecture)
- [Features](#features)
- [Modules](#modules)
- [Contributing](#contributing)

## Quick Setup (Windows)

Jumpstart your PowerShell experience with just one command. This script will download and execute `setup.ps1`, which initializes the profile, installs necessary modules, and configures basic settings.

```powershell
irm "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/setup.ps1" | iex
```

## The Profile Architecture

This PowerShell profile is organized into several modules, each with its own specific functionality. This modular design allows for better organization, easier maintenance, and the ability to load only the necessary components.

## Features

This PowerShell profile script includes:

- **UTF-8 Encoding**: Ensures consistent character display by setting console encoding to UTF-8.
- **Comprehensive Module Management**: Automatically checks for and installs essential PowerShell modules such as Terminal-Icons, PowerShellGet, CompletionPredictor, PSReadLine, and Posh-Git to enrich the shell experience.
- **Enhanced PSReadLine Configuration**: Customizes PSReadLine options and key handlers for a more intuitive and powerful command-line editing experience (e.g., history search, custom keybindings).
- **Custom Modular Functionality**: Imports a suite of custom modules for specialized tasks including environment management, logging, Starship prompt integration, automated updates, and various utilities. See the [Modules](#modules) section for details.
- **Dynamic Starship Prompt**: Integrates the Starship cross-shell prompt, providing a rich, context-aware, and customizable command-line interface.
- **Chocolatey Integration**: Automatically sets up and imports the Chocolatey profile if Chocolatey package manager is installed, streamlining software management.
- **Automated Profile and PowerShell Updates**: Includes functions to automatically update the profile itself and the PowerShell version, keeping the environment current (controlled by global variables).
- **Intelligent Default Editor Configuration**: Sets the default text editor by detecting the availability of preferred editors like Neovim (nvim), Vim (vi), VS Code (code), or falling back to Notepad.
- **FastFetch System Information**: Optionally runs FastFetch (if available) on startup to display a quick summary of system information.

## Modules

Below is a list of the available modules. Click on a module name to view its detailed documentation.

- [Directory Module](./Module/Directory/README.md)
- [Docs Module](./Module/Docs/README.md)
- [Environment Module](./Module/Environment/README.md)
- [Logging Module](./Module/Logging/README.md)
- [Network Module](./Module/Network/README.md)
- [Plugins Module](./Module/Plugins/README.md)
- [Process Module](./Module/Process/README.md)
- [Starship Module](./Module/Starship/README.md)
- [Update Module](./Module/Update/README.md)
- [Utility Module](./Module/Utility/README.md)

## Contributing

Contributions are welcome! Please consider creating a [CONTRIBUTING](.github/CONTRIBUTING.md) file with guidelines for how others can contribute to this project.

## **License:**

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
