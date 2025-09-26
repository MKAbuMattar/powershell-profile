# PIP Plugin

A comprehensive PowerShell module that provides pip CLI shortcuts and utility functions for improved Python package management workflow in PowerShell environments.

## Overview

This plugin converts 25+ common pip aliases and commands from zsh/bash to PowerShell functions with full parameter support and comprehensive help documentation. It includes automatic PowerShell completion support and seamlessly integrates Python package management into your PowerShell workflow.

## Features

-   **Complete pip Integration**: All essential pip commands with short aliases
-   **PowerShell Completion**: Automatic tab completion for pip commands and packages
-   **Full Parameter Support**: All pip arguments and options are supported
-   **Comprehensive Help**: Detailed help documentation for each function
-   **PowerShell Integration**: Native PowerShell function names with familiar aliases
-   **25+ Aliases**: Complete coverage of pip package management operations
-   **GitHub Integration**: Direct installation from GitHub repositories, branches, and PRs
-   **Bulk Operations**: Upgrade all packages, uninstall all packages
-   **Requirements Management**: Create and install from requirements files

## Installation

This plugin is automatically loaded when the PowerShell profile is imported. No additional installation is required.

## Prerequisites

-   **Python**: Must be installed with pip included
-   **pip**: Latest version recommended for full compatibility (prefers pip3 if available)
-   **PowerShell 5.0+**: Required for completion support

## Available Functions and Aliases

### Core Commands

| Alias   | Function              | Description                         |
| ------- | --------------------- | ----------------------------------- |
| `pip`   | `Invoke-Pip`          | Base pip command wrapper            |
| `pipi`  | `Invoke-PipInstall`   | Install Python packages             |
| `pipu`  | `Invoke-PipUpgrade`   | Upgrade packages to latest versions |
| `pipun` | `Invoke-PipUninstall` | Uninstall Python packages           |

### Package Management

| Alias   | Function                    | Description                          |
| ------- | --------------------------- | ------------------------------------ |
| `pipi`  | `Invoke-PipInstall`         | Install packages                     |
| `pipu`  | `Invoke-PipUpgrade`         | Upgrade packages                     |
| `pipun` | `Invoke-PipUninstall`       | Uninstall packages                   |
| `pipiu` | `Invoke-PipInstallUser`     | Install packages for current user    |
| `pipie` | `Invoke-PipInstallEditable` | Install in editable/development mode |

### Information & Discovery

| Alias   | Function                 | Description               |
| ------- | ------------------------ | ------------------------- |
| `pipgi` | `Invoke-PipFreezeGrep`   | Search installed packages |
| `piplo` | `Invoke-PipListOutdated` | List outdated packages    |
| `pipl`  | `Invoke-PipList`         | List installed packages   |
| `pips`  | `Invoke-PipShow`         | Show package information  |
| `pipsr` | `Invoke-PipSearch`       | Search PyPI (deprecated)  |

### Requirements & Bulk Operations

| Alias      | Function                        | Description                        |
| ---------- | ------------------------------- | ---------------------------------- |
| `pipreq`   | `Invoke-PipRequirements`        | Create requirements.txt file       |
| `pipir`    | `Invoke-PipInstallRequirements` | Install from requirements file     |
| `pipupall` | `Invoke-PipUpgradeAll`          | Upgrade all outdated packages      |
| `pipunall` | `Invoke-PipUninstallAll`        | Uninstall all packages (dangerous) |

### GitHub Integration

| Alias    | Function                        | Description                    |
| -------- | ------------------------------- | ------------------------------ |
| `pipig`  | `Invoke-PipInstallGitHub`       | Install from GitHub repository |
| `pipigb` | `Invoke-PipInstallGitHubBranch` | Install from specific branch   |
| `pipigp` | `Invoke-PipInstallGitHubPR`     | Install from pull request      |

### Advanced Operations

| Alias    | Function             | Description                          |
| -------- | -------------------- | ------------------------------------ |
| `pipck`  | `Invoke-PipCheck`    | Check package dependencies           |
| `pipw`   | `Invoke-PipWheel`    | Build wheel archives                 |
| `pipd`   | `Invoke-PipDownload` | Download packages without installing |
| `pipc`   | `Invoke-PipConfig`   | Manage pip configuration             |
| `pipdbg` | `Invoke-PipDebug`    | Show pip debug information           |
| `piph`   | `Invoke-PipHash`     | Compute package hashes               |
| `pipcc`  | `Invoke-PipCache`    | Manage pip cache                     |

## Usage Examples

### Basic Package Management

```powershell
# Install packages
pipi requests
pipi numpy pandas matplotlib

# Upgrade packages
pipu requests
pipu numpy

# Uninstall packages
pipun old-package
pipun package1 package2

# Install for current user only
pipiu some-package

# Install in editable mode (for development)
pipie .
```

### Package Information & Discovery

```powershell
# List installed packages
pipl
pipl --format=json

# Show package information
pips requests
pips numpy

# List outdated packages
piplo

# Search installed packages
pipgi flask
pipgi numpy
```

### Requirements Management

```powershell
# Create requirements file
pipreq
pipreq my-requirements.txt

# Install from requirements file
pipir
pipir requirements-dev.txt
pipir requirements.txt --upgrade
```

### Bulk Operations

```powershell
# Upgrade all outdated packages
pipupall

# Uninstall all packages (use with extreme caution!)
pipunall
pipunall -Force  # Skip confirmation
```

### GitHub Integration

```powershell
# Install from GitHub repository
pipig psf/requests
pipig user/my-awesome-package

# Install from specific branch
pipigb psf/requests main
pipigb user/package feature-branch

# Install from pull request
pipigp psf/requests 123
pipigp user/package 456
```

### Advanced Operations

```powershell
# Check package dependencies
pipck

# Build wheel for package
pipw .
pipw my-package

# Download without installing
pipd requests
pipd numpy -d downloads/

# Manage configuration
pipc list
pipc set global.index-url https://pypi.org/simple/

# Debug information
pipdbg

# Manage cache
pipcc info
pipcc purge
```

## Advanced Features

### PowerShell Completion

The plugin automatically initializes pip completion for PowerShell:

-   Tab completion for pip commands and subcommands
-   Package name completion for common operations
-   Cached package index for improved performance
-   Integration with PowerShell's argument completion system

### Parameter Passing

All functions accept the same parameters as their pip counterparts:

```powershell
# Multiple packages
pipi requests flask django

# With options
pipi numpy --no-cache-dir
pipu package --user
pipun package --yes

# Complex installations
pipi "package>=1.0,<2.0"
pipi package[extra]
pipi -e git+https://github.com/user/repo.git#egg=package
```

### Help System Integration

Each function includes comprehensive help documentation:

```powershell
# Get help for any function
Get-Help Invoke-PipInstall -Full
Get-Help pipi -Examples
Get-Help Invoke-PipUpgradeAll -Detailed
```

## Common Workflows

### New Project Setup

```powershell
# Create new project environment
python -m venv venv
venv\Scripts\Activate.ps1  # Windows
# or: source venv/bin/activate  # Unix

# Install basic packages
pipi pip setuptools wheel --upgrade
pipi requests flask pytest black

# Create requirements file
pipreq
```

### Development Workflow

```powershell
# Install development dependencies
pipir requirements-dev.txt

# Install current package in editable mode
pipie .

# Run checks
pipck  # Check dependencies
```

### Package Maintenance

```powershell
# Check for outdated packages
piplo

# Upgrade all packages
pipupall

# Clean up unused packages (manual process)
pipl | # Review and manually uninstall unused packages
```

### GitHub Development

```powershell
# Install development version from GitHub
pipig user/cutting-edge-package

# Test specific branch
pipigb user/package experimental-feature

# Test pull request
pipigp upstream/package 789
```

### Virtual Environment Management

```powershell
# Create and activate virtual environment
python -m venv myproject
myproject\Scripts\Activate.ps1

# Install from requirements
pipir requirements.txt

# Work on project...

# Create updated requirements
pipreq requirements-new.txt

# Deactivate when done
deactivate
```

## Configuration Examples

### Custom Index/Registry

```powershell
# Set custom PyPI index
pipc set global.index-url https://my-pypi.company.com/simple/
pipc set global.trusted-host my-pypi.company.com

# View current configuration
pipc list
```

### Development Settings

```powershell
# Set development-friendly defaults
pipc set global.timeout 60
pipc set install.user true
pipc set install.no-cache-dir true
```

## Performance and Optimization

### Cache Management

```powershell
# View cache information
pipcc info

# Clear cache to free space
pipcc purge

# Remove specific package from cache
pipcc remove package-name
```

### Faster Installations

```powershell
# Use wheels when available
pipi package --only-binary=all

# Skip cache for problematic packages
pipi package --no-cache-dir

# Use local index for corporate environments
pipi package --index-url https://local-pypi/simple/
```

## Troubleshooting

### Common Issues

1. **pip not found**: Ensure Python and pip are installed and in PATH
2. **Permission errors**: Use `pipiu` for user installations or run as administrator
3. **SSL errors**: Update pip and certificates: `python -m pip install --upgrade pip`
4. **Package conflicts**: Use `pipck` to identify dependency issues

### Diagnostic Commands

```powershell
# Check pip installation
pip --version

# Show pip debug information
pipdbg

# Check package dependencies
pipck

# List configuration
pipc list

# View cache information
pipcc info
```

### Getting Help

```powershell
# pip help
pip help
pip help install

# PowerShell help
Get-Help pipi -Full
Get-Command *pip*
```

## Security Considerations

-   Always verify packages before installing from unknown sources
-   Use virtual environments to isolate project dependencies
-   Regularly update pip: `pipu pip`
-   Review requirements files before installation
-   Use `pipck` to identify vulnerable packages
-   Consider using `pip-audit` for security scanning
-   Be cautious with `pipunall` - it removes ALL packages

## Best Practices

### Package Management

-   Use virtual environments for project isolation
-   Pin specific versions in requirements files for reproducibility
-   Regularly update packages with `pipupall`
-   Use `pipreq` to maintain accurate requirements files

### Development Workflow

-   Use `pipie` for editable installs during development
-   Test with `pipck` before committing dependency changes
-   Use GitHub integration for testing development versions
-   Maintain separate requirements files for dev/prod

### Security & Maintenance

-   Regularly audit installed packages
-   Keep pip updated to latest version
-   Use trusted package sources
-   Review package permissions and dependencies

## Requirements

-   **Python**: Version 3.7+ recommended for full compatibility
-   **pip**: Latest version for optimal performance (pip3 preferred)
-   **PowerShell 5.0+**: For completion and advanced features

## Compatibility

This plugin works with:

-   pip 20.0+ (pip 23.0+ recommended)
-   Python 3.7+ (Python 3.11+ recommended)
-   Windows PowerShell 5.1
-   PowerShell Core 6.0+
-   All major Python package indexes (PyPI, private indexes, etc.)

## Contributing

When adding new pip commands:

1. Follow the naming convention: `Invoke-Pip[Command]`
2. Add appropriate aliases matching the zsh/bash equivalents
3. Include comprehensive help documentation
4. Test with multiple pip versions
5. Update this README with new functions

## Version History

-   **v4.1.0**: Initial PowerShell conversion from zsh/bash aliases
    -   25+ pip commands with aliases
    -   PowerShell completion support
    -   Comprehensive help documentation
    -   Full parameter support for all pip operations
    -   GitHub integration for repository installations
    -   Bulk operations (upgrade all, uninstall all)
    -   Requirements file management
    -   Advanced pip operations (cache, config, debug, etc.)
    -   Integration with PowerShell profile ecosystem
