# GitIgnore Utility Module

## Overview

The GitIgnore utility module provides a simple PowerShell wrapper for **igntui**, an interactive Terminal User Interface (TUI) for generating `.gitignore` files. This module automatically handles installation and provides easy access to the powerful igntui tool directly from PowerShell.

## Features

-   **🎨 Interactive TUI**: Beautiful terminal interface for browsing and selecting gitignore templates
-   **🔍 Smart Search**: Filter through 450+ available gitignore templates
-   **📋 Multi-Select**: Select multiple technologies at once
-   **👁️ Live Preview**: See generated .gitignore content in real-time
-   **💾 Direct Save**: Save generated .gitignore files directly from the TUI
-   **📦 Auto-Install**: Automatically prompts to install igntui from PyPI if not found
-   **🌐 Cross-Platform**: Works on Windows, macOS, and Linux

## Installation

This module is part of the MKAbuMattar PowerShell Profile and is automatically loaded with the Utility module.

### Requirements

-   PowerShell 5.1 or later
-   Python 3.9+ (for igntui)
-   pipx or pip (for installing igntui)

The igntui package will be automatically installed from PyPI when you first run the command.

## Quick Start

Simply run:

```powershell
gitui
```

Or use the full function name:

```powershell
Start-GitIgnoreTUI
```

If igntui is not installed, you'll be prompted to install it automatically using pipx.

## TUI Interface

The igntui TUI provides a modern, interactive interface with the following features:

### Three-Panel Layout

```
┌─── Available Templates ───┐┌──── Generated .gitignore ────┐
│ ✓ node                    ││ # Node.js                     │
│ ✓ python                  ││ node_modules/                 │
│   visual-studio           ││ npm-debug.log*                │
│   visual-studio-code      ││ # Python                      │
│   webpack                 ││ __pycache__/                  │
│   windows                 ││ *.py[cod]                     │
└───────────────────────────┘└───────────────────────────────┘
┌─────────── Selected Templates ──────────────────────────────┐
│ • node                                                       │
│ • python                                                     │
└──────────────────────────────────────────────────────────────┘
```

### Navigation Controls

| Key           | Action                         |
| ------------- | ------------------------------ |
| `↑/↓`         | Navigate template list         |
| `Space/Enter` | Select/deselect template       |
| `Tab`         | Switch between panels          |
| `/`           | Filter/search templates        |
| `s`           | Save generated .gitignore file |
| `r`           | Refresh templates list         |
| `c`           | Clear all selections           |
| `q/Esc`       | Quit application               |

## Available Functions

### Start-GitIgnoreTUI (Alias: gitui)

Launches the igntui TUI application. If not installed, prompts to install from PyPI.

```powershell
# Launch the TUI
gitui

# Or use the full function name
Start-GitIgnoreTUI
```

### Auto-Installation

If igntui is not installed, the module will display:

```
❌ igntui is not installed.

💡 igntui is an interactive TUI for generating .gitignore files.
   It can be installed from PyPI using pipx or pip:

   pipx install igntui
   pip install igntui

Would you like to install it now using pipx? (Y/n)
```

Select `Y` to automatically install igntui, or install it manually later.

## Usage Examples

### Basic Usage

```powershell
# Launch the interactive TUI
gitui

# The TUI will open and you can:
# 1. Browse through 450+ templates
# 2. Use / to search for specific technologies
# 3. Press Space to select/deselect templates
# 4. Press s to save the generated .gitignore file
# 5. Press q to quit
```

### Typical Workflow

1. **Launch TUI**: `gitui`
2. **Search for templates**: Press `/` and type (e.g., "python", "node")
3. **Select technologies**: Navigate with `↑/↓` and press `Space` to select
4. **Preview content**: View the generated .gitignore in the right panel
5. **Save file**: Press `s` to save .gitignore to the current directory
6. **Exit**: Press `q` or `Esc` when done

### Manual Installation (Optional)

If you prefer to install igntui manually:

```powershell
# Using pipx (recommended)
pipx install igntui

# Or using pip
pip install igntui
```

## About igntui

igntui is a Python package that provides an interactive TUI for generating .gitignore files using the gitignore.io API. It offers a modern, user-friendly alternative to command-line tools.

**Features:**

-   Browse 450+ gitignore templates
-   Multi-select capability
-   Real-time preview
-   Search/filter functionality
-   Direct file saving

**PyPI Package**: [https://pypi.org/project/igntui/](https://pypi.org/project/igntui/)

## Troubleshooting

### igntui not found after installation

If you installed igntui but the command is not found, try:

1. Close and reopen your PowerShell session
2. Verify pipx is in your PATH: `pipx --version`
3. Manually add to PATH or use: `python -m igntui`

### Python not found

The module requires Python to be installed. Install Python from:

-   Windows: [python.org](https://python.org) or `winget install Python.Python.3.12`
-   macOS: `brew install python3`
-   Linux: Use your package manager (e.g., `apt install python3`)

### pipx not found

If pipx is not installed:

```powershell
# Install pipx
python -m pip install --user pipx
python -m pipx ensurepath
```

Then restart your terminal.

## Module Information

-   **Module**: GitIgnore Utility
-   **Version**: 5.0.0
-   **Author**: Mohammad Abu Mattar
-   **Created**: 2025-09-27
-   **Updated**: 2026-01-10

## See Also

-   [Utility Module README](../README.md) - Complete utility module documentation
-   [PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile) - Main profile repository
-   [igntui on PyPI](https://pypi.org/project/igntui/) - Python package information
-   [gitignore.io](https://gitignore.io) - Template source

## License

This module is part of the MKAbuMattar PowerShell Profile and is available under the same license.
