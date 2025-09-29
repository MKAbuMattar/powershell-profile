# Pipenv Plugin

A comprehensive PowerShell module that provides convenient aliases and functions for Python virtual environment management using pipenv. This plugin converts common pipenv CLI commands into easy-to-use PowerShell functions with full parameter support, automatic shell activation, and project lifecycle management.

## Overview

The Pipenv plugin streamlines Python development workflows by providing:

-   **15+ optimized pipenv aliases** for common operations
-   **Automatic shell activation/deactivation** when entering/leaving project directories
-   **Tab completion** for pipenv commands and options
-   **Comprehensive help system** with detailed examples
-   **Cross-platform compatibility** (Windows, Linux, macOS)

## Prerequisites

-   **PowerShell 5.1+** or **PowerShell Core 7.0+**
-   **pipenv** installed and accessible in PATH
-   **Python 3.6+** (required by pipenv)

### Installing pipenv

```powershell
# Using pip
pip install --user pipenv

# Using package managers
# Windows (Chocolatey)
choco install pipenv

# Windows (Scoop)
scoop install pipenv

# macOS (Homebrew)
brew install pipenv

# Linux (varies by distribution)
# Ubuntu/Debian
sudo apt install pipenv

# Fedora
sudo dnf install pipenv
```

## Installation

The Pipenv plugin is automatically loaded as part of the PowerShell profile system. No additional installation steps required.

## Features

### Package Management Aliases

| Alias   | Full Command              | Description                      |
| ------- | ------------------------- | -------------------------------- |
| `pi`    | `Invoke-PipenvInstall`    | Install packages                 |
| `pidev` | `Invoke-PipenvInstallDev` | Install development dependencies |
| `pu`    | `Invoke-PipenvUninstall`  | Uninstall packages               |
| `pupd`  | `Invoke-PipenvUpdate`     | Update packages                  |

### Environment Management Aliases

| Alias   | Full Command          | Description                         |
| ------- | --------------------- | ----------------------------------- |
| `psh`   | `Invoke-PipenvShell`  | Activate pipenv shell               |
| `prun`  | `Invoke-PipenvRun`    | Run commands in virtual environment |
| `pwh`   | `Invoke-PipenvWhere`  | Show project directory              |
| `pvenv` | `Invoke-PipenvVenv`   | Show virtual environment path       |
| `ppy`   | `Invoke-PipenvPython` | Show Python interpreter path        |

### Dependency Management Aliases

| Alias  | Full Command                | Description               |
| ------ | --------------------------- | ------------------------- |
| `pl`   | `Invoke-PipenvLock`         | Generate Pipfile.lock     |
| `psy`  | `Invoke-PipenvSync`         | Install from Pipfile.lock |
| `preq` | `Invoke-PipenvRequirements` | Generate requirements.txt |

### Information & Maintenance Aliases

| Alias  | Full Command          | Description                        |
| ------ | --------------------- | ---------------------------------- |
| `pch`  | `Invoke-PipenvCheck`  | Check for security vulnerabilities |
| `pcl`  | `Invoke-PipenvClean`  | Clean unused dependencies          |
| `pgr`  | `Invoke-PipenvGraph`  | Show dependency graph              |
| `po`   | `Invoke-PipenvOpen`   | Open package in editor             |
| `pscr` | `Invoke-PipenvScript` | Run predefined scripts             |

## Usage Examples

### Basic Package Management

```powershell
# Install packages
pi requests flask
pipenv install requests flask

# Install development dependencies
pidev pytest black flake8
pipenv install --dev pytest black flake8

# Uninstall packages
pu old-package
pipenv uninstall old-package

# Update all packages
pupd
pipenv update

# Update specific package
pupd requests
pipenv update requests
```

### Virtual Environment Management

```powershell
# Activate pipenv shell
psh
pipenv shell

# Run commands in virtual environment
prun python app.py
pipenv run python app.py

# Run tests
prun pytest tests/
pipenv run pytest tests/

# Show project directory
pwh
pipenv --where

# Show virtual environment path
pvenv
pipenv --venv

# Show Python interpreter path
ppy
pipenv --py
```

### Dependency Management

```powershell
# Generate lock file
pl
pipenv lock

# Lock with development dependencies
pl --dev
pipenv lock --dev

# Install from lock file
psy
pipenv sync

# Sync with development dependencies
psy --dev
pipenv sync --dev

# Generate requirements.txt
preq > requirements.txt
pipenv requirements > requirements.txt

# Generate dev requirements
preq --dev > requirements-dev.txt
pipenv requirements --dev > requirements-dev.txt
```

### Project Information and Maintenance

```powershell
# Check for security vulnerabilities
pch
pipenv check

# Show dependency graph
pgr
pipenv graph

# Clean unused packages
pcl
pipenv clean

# Dry-run clean (show what would be removed)
pcl --dry-run
pipenv clean --dry-run

# Open package source code
po requests
pipenv open requests

# Run predefined scripts
pscr test
pipenv run test

# Run script with arguments
pscr lint --fix
pipenv run lint --fix
```

### Automatic Shell Management

The plugin includes intelligent automatic shell activation:

```powershell
# Enable auto-shell (enabled by default)
Enable-PipenvAutoShell

# Disable auto-shell
Disable-PipenvAutoShell

# Check auto-shell status
Test-PipenvAutoShell
```

**How it works:**

-   Automatically activates pipenv when entering directories with `Pipfile`
-   Deactivates when leaving project directories
-   Tracks nested directory navigation
-   Works with both `cd` and `Set-Location`

## Advanced Features

### Tab Completion

The plugin provides intelligent tab completion for:

```powershell
# pipenv commands
pipenv <TAB>
# Shows: install, uninstall, lock, sync, update, run, shell, etc.

# Common options
pipenv --<TAB>
# Shows: --venv, --where, --py, --version, --help
```

### Error Handling

All functions include comprehensive error handling:

-   **Availability checks**: Verifies pipenv installation before execution
-   **Graceful failures**: Displays helpful error messages
-   **Verbose output**: Optional detailed logging with `-Verbose`

### Cross-Platform Support

The plugin works seamlessly across platforms:

-   **Windows**: PowerShell 5.1+ and PowerShell Core
-   **Linux**: PowerShell Core with proper PATH configuration
-   **macOS**: PowerShell Core with Homebrew or manual installation

## Configuration

### Environment Variables

The plugin respects standard pipenv environment variables:

```powershell
# Set custom virtual environment location
$env:PIPENV_VENV_IN_PROJECT = "1"

# Set custom pipenv directory
$env:PIPENV_PIPFILE = "C:\path\to\custom\Pipfile"

# Disable automatic virtual environment creation
$env:PIPENV_IGNORE_VIRTUALENVS = "1"
```

### Module Variables

Internal module variables can be customized:

```powershell
# Check auto-shell status
Test-PipenvAutoShell

# Toggle auto-shell manually
Invoke-PipenvShellToggle
```

## Troubleshooting

### Common Issues

**pipenv command not found:**

```powershell
# Check if pipenv is installed
Get-Command pipenv

# Install pipenv
pip install --user pipenv

# Add to PATH (Windows)
$env:PATH += ";$env:APPDATA\Python\Scripts"
```

**Virtual environment not activating:**

```powershell
# Check project directory
pwh

# Verify Pipfile exists
Test-Path "Pipfile"

# Check virtual environment path
pvenv
```

**Auto-shell not working:**

```powershell
# Verify auto-shell is enabled
Test-PipenvAutoShell

# Enable if disabled
Enable-PipenvAutoShell

# Manual toggle
Invoke-PipenvShellToggle
```

### Debug Information

Enable verbose output for troubleshooting:

```powershell
# Enable verbose output for all pipenv functions
$VerbosePreference = "Continue"

# Run commands with verbose output
pi requests -Verbose
```

### Performance Tips

1. **Use lock files**: Always commit `Pipfile.lock` for consistent installs
2. **Development dependencies**: Use `--dev` flag appropriately
3. **Clean regularly**: Run `pcl` to remove unused packages
4. **Check security**: Regular `pch` for vulnerability scanning

## Integration

### VS Code Integration

The plugin works seamlessly with VS Code:

```json
// .vscode/settings.json
{
    "python.defaultInterpreterPath": "./venv/Scripts/python.exe",
    "python.pipenvPath": "pipenv",
    "python.terminal.activateEnvironment": true
}
```

### Git Integration

Recommended `.gitignore` entries:

```gitignore
# Virtual environments
.venv/
venv/

# Pipenv files (keep Pipfile and Pipfile.lock)
# Don't ignore Pipfile and Pipfile.lock
```

## Examples and Workflows

### New Project Setup

```powershell
# Create new project
mkdir my-python-project
cd my-python-project

# Initialize pipenv (auto-activates)
pi --python 3.9

# Install dependencies
pi requests flask pytest

# Install dev dependencies
pidev black flake8 mypy

# Generate lock file
pl

# Create requirements file for deployment
preq > requirements.txt
```

### Existing Project Setup

```powershell
# Clone repository
git clone https://github.com/user/project.git
cd project

# Install dependencies (auto-activates)
psy --dev

# Run tests
prun pytest

# Run application
prun python app.py
```

### Development Workflow

```powershell
# Daily development cycle
cd project          # Auto-activates environment
pupd                # Update dependencies
pch                 # Check security
prun pytest         # Run tests
pcl                 # Clean unused packages
pl                  # Update lock file
```

## Contributing

Contributions are welcome! Please ensure:

1. **Consistent alias naming**: Follow established `p[command]` pattern
2. **Comprehensive help**: Include detailed `.SYNOPSIS`, `.DESCRIPTION`, and `.EXAMPLE`
3. **Error handling**: Implement proper error checking and user feedback
4. **Cross-platform**: Test on Windows, Linux, and macOS

## Version History

-   **v4.1.0**: Full pipenv plugin with auto-shell management
-   **v4.0.0**: Initial pipenv integration and alias conversion

## Related Documentation

-   [pipenv Official Documentation](https://pipenv.pypa.io/)
-   [PowerShell Profile System](https://github.com/MKAbuMattar/powershell-profile)
-   [Python Virtual Environments Guide](https://docs.python.org/3/tutorial/venv.html)

## License

This module is part of the MKAbuMattar PowerShell Profile project and is licensed under the MIT License.
