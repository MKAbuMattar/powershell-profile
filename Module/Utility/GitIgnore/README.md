# GitIgnore Utility Module

## Overview

The GitIgnore utility module provides comprehensive integration with the [gitignore.io](https://gitignore.io) API service, allowing you to generate, manage, and update `.gitignore` files directly from PowerShell. It offers both command-line and TUI (Text User Interface) modes for an optimal user experience.

## Features

-   **🎯 Generate GitIgnore Content**: Create .gitignore content for any combination of technologies
-   **📋 List Available Templates**: Browse and filter available gitignore templates
-   **📝 File Management**: Create new .gitignore files with backup support
-   **➕ Content Addition**: Add templates to existing .gitignore files
-   **🔍 Service Testing**: Test connectivity to gitignore.io API
-   **⚡ Tab Completion**: PowerShell tab completion for technology names
-   **🌐 Cross-Platform**: Works on Windows, macOS, and Linux
-   **💾 Caching**: Smart caching of available templates for performance
-   **🖥️ TUI Mode**: Interactive Text User Interface for visual template selection

## Installation

This module is part of the MKAbuMattar PowerShell Profile and is automatically loaded with the Utility module.

## TUI (Text User Interface) Mode

### Quick Start

```bash
python gitignore.py --tui
```

### TUI Features

-   **Three-Panel Layout**:
    -   **Left Panel**: Browse available .gitignore templates
    -   **Bottom Panel**: View selected templates
    -   **Right Panel**: Live preview of generated .gitignore content

### TUI Controls

| Key           | Action                         |
| ------------- | ------------------------------ |
| `↑/↓`         | Navigate template list         |
| `Space/Enter` | Select/deselect template       |
| `Tab`         | Switch between panels          |
| `/`           | Filter templates               |
| `s`           | Save generated .gitignore file |
| `r`           | Refresh templates list         |
| `c`           | Clear all selections           |
| `q/Esc`       | Quit application               |

### TUI Screenshot Concept

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
Controls: ↑↓ Navigate | Space Select | s Save | q Quit
```

## Python CLI Mode

For users who prefer command-line interfaces, the Python script also provides a traditional CLI mode:

### CLI Commands

```bash
# Generate .gitignore for specific technologies
python gitignore.py --get node python react

# List all available templates
python gitignore.py --list

# Filter templates by pattern
python gitignore.py --list --filter python

# Test API connectivity
python gitignore.py --test

# Launch TUI mode
python gitignore.py --tui
```

### CLI Examples

```bash
# Create .gitignore for a Node.js project
python gitignore.py --get node > .gitignore

# Find all Python-related templates
python gitignore.py --list --filter python

# Generate for multiple technologies
python gitignore.py --get python django react node > .gitignore

# Test if gitignore.io is accessible
python gitignore.py --test
```

## Functions and Aliases

### Core Functions

| Function                | Alias    | Description                                           |
| ----------------------- | -------- | ----------------------------------------------------- |
| `Get-GitIgnore`         | `gi`     | Generate gitignore content for specified technologies |
| `Get-GitIgnoreList`     | `gilist` | List all available gitignore templates                |
| `New-GitIgnoreFile`     | `ginew`  | Create new .gitignore file                            |
| `Add-GitIgnoreContent`  | `giadd`  | Add content to existing .gitignore file               |
| `Test-GitIgnoreService` | `gitest` | Test API connectivity                                 |

## Quick Start

### Basic Usage

```powershell
# Generate gitignore for Node.js and Python (equivalent to original gi() function)
gi node python

# List available templates
gilist

# Search for specific templates
gilist -Filter python

# Create a new .gitignore file
ginew visualstudio windows

# Add templates to existing .gitignore
giadd docker kubernetes

# Test service connectivity
gitest
```

### Advanced Usage

```powershell
# Save gitignore content to file
gi node python react -OutputPath .\.gitignore

# Create .gitignore with backup of existing file
ginew python django flask -Backup

# Filter templates and view in grid (Windows only)
gilist -Filter java -GridView

# Force overwrite existing .gitignore
ginew macos xcode -Force

# Append to existing file
gi linux vim -OutputPath .\.gitignore -Append
```

## Detailed Examples

### 1. Web Development Workflow

```powershell
# Start new web project
mkdir my-web-app
cd my-web-app

# Create comprehensive .gitignore
ginew node react visualstudio windows macos

# Later add Docker support
giadd docker docker-compose

# View the generated file
Get-Content .gitignore
```

### 2. Python Development

```powershell
# Python project with virtual environment
ginew python django pycharm windows

# Add Jupyter notebooks later
giadd jupyternotebooks

# Check what Python-related templates are available
gilist -Filter python
```

### 3. Multi-Platform Development

```powershell
# Cross-platform mobile development
ginew android ios react-native gradle maven

# Add platform-specific ignores
giadd windows macos linux
```

### 4. Exploring Available Templates

```powershell
# See all available templates
gilist

# Find all Java-related templates
gilist -Filter java

# Find IDE templates
gilist -Filter "studio"

# View in interactive grid (Windows)
gilist -GridView
```

## Function Reference

### Get-GitIgnore (gi)

Generate .gitignore content for specified technologies.

```powershell
Get-GitIgnore [-Technologies] <string[]> [-OutputPath <string>] [-Append]

# Examples
gi node python                           # Output to console
gi visualstudio -OutputPath .\.gitignore # Save to file
gi macos -OutputPath .\.gitignore -Append # Append to file
```

**Parameters:**

-   `Technologies`: Array of technology names (supports multiple values)
-   `OutputPath`: Optional file path to save content
-   `Append`: Append to file instead of overwriting

### Get-GitIgnoreList (gilist)

List available gitignore templates with optional filtering.

```powershell
Get-GitIgnoreList [-Filter <string>] [-GridView]

# Examples
gilist                      # List all templates
gilist -Filter python       # Filter by name
gilist -GridView            # Interactive grid (Windows)
```

**Parameters:**

-   `Filter`: Optional filter string for technology names
-   `GridView`: Display in interactive grid view (Windows only)

### New-GitIgnoreFile (ginew)

Create a new .gitignore file with specified technologies.

```powershell
New-GitIgnoreFile [-Technologies] <string[]> [-Path <string>] [-Backup] [-Force]

# Examples
ginew node python                    # Create in current directory
ginew visualstudio -Path ./project   # Create in specific directory
ginew python -Backup                # Backup existing file
ginew django -Force                 # Force overwrite
```

**Parameters:**

-   `Technologies`: Array of technology names
-   `Path`: Directory path (defaults to current directory)
-   `Backup`: Create backup of existing .gitignore
-   `Force`: Overwrite without prompting

### Add-GitIgnoreContent (giadd)

Add additional technologies to existing .gitignore file.

```powershell
Add-GitIgnoreContent [-Technologies] <string[]> [-Path <string>]

# Examples
giadd docker kubernetes             # Add to existing file
giadd macos -Path ./project        # Add to specific directory
```

**Parameters:**

-   `Technologies`: Array of technology names to add
-   `Path`: Directory path (defaults to current directory)

### Test-GitIgnoreService (gitest)

Test connectivity to the gitignore.io API.

```powershell
Test-GitIgnoreService

# Examples
gitest                              # Test API connectivity
```

## Tab Completion

The module provides intelligent tab completion for technology names:

```powershell
gi node<TAB>           # Completes to available node-related templates
ginew python<TAB>      # Shows Python-related options
giadd visual<TAB>      # Shows Visual Studio related templates
```

The completion system:

-   Caches available templates for 30 minutes for performance
-   Falls back to common technologies if API is unavailable
-   Provides real-time filtering as you type

## Error Handling

The module includes comprehensive error handling:

-   **Network Issues**: Graceful handling of connectivity problems
-   **Invalid Technologies**: Clear error messages for unknown templates
-   **File Conflicts**: Safe handling of existing .gitignore files
-   **API Limitations**: Fallback behavior when service is unavailable

## Performance Features

-   **Template Caching**: Available templates are cached for 30 minutes
-   **Efficient API Calls**: Minimal requests to gitignore.io service
-   **Background Loading**: Tab completion works even with slow connections
-   **Fallback Support**: Works offline with cached/common templates

## Integration with Git Workflow

```powershell
# Complete project setup workflow
mkdir my-project
cd my-project

git init                           # Initialize git repository
ginew node python windows         # Create .gitignore
git add .gitignore                # Stage .gitignore
git commit -m "Add .gitignore"    # Commit

# Later add more templates
giadd docker
git add .gitignore
git commit -m "Add Docker to .gitignore"
```

## Troubleshooting

### Common Issues

1. **Network Connectivity**

    ```powershell
    gitest  # Test API connectivity
    ```

2. **Unknown Technology Names**

    ```powershell
    gilist -Filter <technology>  # Check available templates
    ```

3. **File Permission Issues**

    ```powershell
    # Ensure you have write permissions to the target directory
    Test-Path .\ -IsValid
    ```

4. **PowerShell Version Compatibility**
    ```powershell
    $PSVersionTable.PSVersion  # Check PowerShell version (requires 5.1+)
    ```

### Getting Help

```powershell
# Get detailed help for any function
Get-Help Get-GitIgnore -Full
Get-Help gilist -Examples
Get-Help ginew -Parameter Technologies
```

| PowerShell Equivalent          | Enhancement                             |
| ------------------------------ | --------------------------------------- |
| `Get-GitIgnore` / `gi`         | File output, error handling, validation |
| `Get-GitIgnoreList` / `gilist` | Filtering, grid view, formatting        |
| Built-in tab completion        | Smart caching, fallback support         |

### Advantages of PowerShell Version

-   **Better Error Handling**: Comprehensive error messages and recovery
-   **File Management**: Direct file creation and management capabilities
-   **Tab Completion**: Native PowerShell completion with caching
-   **Parameter Validation**: Strong typing and parameter validation
-   **Help System**: Complete PowerShell help documentation
-   **Cross-Platform**: Works consistently across Windows, macOS, and Linux
-   **Integration**: Seamless integration with PowerShell workflows

## Requirements

-   **PowerShell**: Version 5.1 or later
-   **Internet**: Required for API access to gitignore.io
-   **Permissions**: Write access to target directories for file creation

## Contributing

This module is part of the MKAbuMattar PowerShell Profile project. Contributions are welcome through the main repository.

## License

This module is licensed under the same terms as the main PowerShell Profile project.
