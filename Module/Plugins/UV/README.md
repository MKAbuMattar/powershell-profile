# UV Plugin

A comprehensive PowerShell module that provides UV (Python package manager) CLI shortcuts and utility functions for modern Python dependency management, virtual environment handling, and project workflows. This plugin converts 25+ common UV operations to PowerShell functions with full parameter support and comprehensive Python project management.

## Features

-   **🚀 Complete UV CLI Integration**: 25+ functions covering all major UV operations
-   **⚡ Convenient Aliases**: Short aliases for frequent operations (e.g., `uv`, `uva`, `uvr`, `uvs`)
-   **📦 Dependency Management**: Functions for adding, removing, and synchronizing dependencies
-   **🐍 Python Version Management**: Python installation and version switching
-   **🛠️ Tool Management**: Install and run Python CLI tools with uvx
-   **🏗️ Project Lifecycle**: Complete project management from init to publish
-   **🔧 Virtual Environment**: Virtual environment creation and management
-   **📋 Tab Completion**: Full PowerShell tab completion for UV commands and tools
-   **🛡️ Error Handling**: Robust error handling and validation for safe operations
-   **📖 Comprehensive Help**: Detailed help documentation for all functions

## Prerequisites

-   **UV**: Must be installed and accessible in your system PATH
-   **PowerShell 5.0+**: Required for module functionality
-   **Python**: Required by UV (automatically managed by UV)

## Installation

This plugin is part of the MKAbuMattar PowerShell Profile. To install:

```powershell
# Clone the profile repository
git clone https://github.com/MKAbuMattar/powershell-profile.git

# Import the UV plugin
Import-Module .\powershell-profile\Module\Plugins\UV\UV.psm1
```

## Function Reference

### Core Functions

| Function                  | Alias | Description              |
| ------------------------- | ----- | ------------------------ |
| `Invoke-UV`               | `uv`  | Base UV command wrapper  |
| `Test-UVInstalled`        | -     | Tests if UV is available |
| `Initialize-UVCompletion` | -     | Sets up tab completion   |

### Dependency Management Functions

| Function               | Alias  | Description                      |
| ---------------------- | ------ | -------------------------------- |
| `Invoke-UVAdd`         | `uva`  | Add dependencies to project      |
| `Invoke-UVRemove`      | `uvrm` | Remove dependencies from project |
| `Invoke-UVSync`        | `uvs`  | Synchronize project dependencies |
| `Invoke-UVSyncRefresh` | `uvsr` | Sync with dependency refresh     |
| `Invoke-UVSyncUpgrade` | `uvsu` | Sync with dependency upgrades    |

### Lock File Management Functions

| Function               | Alias  | Description                    |
| ---------------------- | ------ | ------------------------------ |
| `Invoke-UVLock`        | `uvl`  | Create or update lock file     |
| `Invoke-UVLockRefresh` | `uvlr` | Refresh lock file resolution   |
| `Invoke-UVLockUpgrade` | `uvlu` | Upgrade lock file dependencies |

### Export and Requirements Functions

| Function          | Alias   | Description                             |
| ----------------- | ------- | --------------------------------------- |
| `Invoke-UVExport` | `uvexp` | Export dependencies to requirements.txt |

### Execution Functions

| Function       | Alias | Description                   |
| -------------- | ----- | ----------------------------- |
| `Invoke-UVRun` | `uvr` | Run command in UV environment |

### Python and Pip Integration Functions

| Function          | Alias  | Description                      |
| ----------------- | ------ | -------------------------------- |
| `Invoke-UVPython` | `uvpy` | Manage Python versions           |
| `Invoke-UVPip`    | `uvp`  | Use pip functionality through UV |

### Virtual Environment Functions

| Function        | Alias | Description                |
| --------------- | ----- | -------------------------- |
| `Invoke-UVVenv` | `uvv` | Create virtual environment |

### Project Lifecycle Functions

| Function           | Alias   | Description                   |
| ------------------ | ------- | ----------------------------- |
| `Invoke-UVInit`    | `uvi`   | Initialize new UV project     |
| `Invoke-UVBuild`   | `uvb`   | Build project distributions   |
| `Invoke-UVPublish` | `uvpub` | Publish project to repository |

### Tool Management Functions

| Function                 | Alias         | Description             |
| ------------------------ | ------------- | ----------------------- |
| `Invoke-UVTool`          | `uvt`         | Manage UV tools         |
| `Invoke-UVToolRun`       | `uvtr`, `uvx` | Run tool with UV        |
| `Invoke-UVToolInstall`   | `uvti`        | Install Python tools    |
| `Invoke-UVToolUninstall` | `uvtu`        | Uninstall Python tools  |
| `Invoke-UVToolList`      | `uvtl`        | List installed tools    |
| `Invoke-UVToolUpgrade`   | `uvtup`       | Upgrade installed tools |

### Utility Functions

| Function              | Alias   | Description      |
| --------------------- | ------- | ---------------- |
| `Invoke-UVSelfUpdate` | `uvup`  | Update UV itself |
| `Invoke-UVVersion`    | `uvver` | Show UV version  |

### Project Information Functions

| Function               | Alias | Description                             |
| ---------------------- | ----- | --------------------------------------- |
| `Test-UVProject`       | -     | Test if current directory is UV project |
| `Get-UVProjectInfo`    | -     | Get UV project information              |
| `Get-UVVirtualEnvPath` | -     | Get virtual environment path            |

## Usage Examples

### Basic Project Operations

```powershell
# Initialize a new Python project
uvi myproject

# Add dependencies
uva requests "django>=4.0"

# Add development dependencies
uva pytest black --dev

# Synchronize environment
uvs

# Run commands in environment
uvr python script.py
uvr pytest
```

### Advanced Dependency Management

```powershell
# Lock dependencies
uvl

# Sync with refresh
uvsr

# Upgrade dependencies
uvsu

# Export to requirements.txt
uvexp

# Export development requirements
uvexp -OutputFile dev-requirements.txt --dev
```

### Python Version Management

```powershell
# List available Python versions
uvpy list

# Install specific Python version
uvpy install 3.12

# Use specific Python for project
uvr --python 3.12 python --version
```

### Tool Management

```powershell
# Install Python tools
uvti black flake8 mypy

# List installed tools
uvtl

# Run tools
uvx black .
uvx flake8 src/

# Upgrade tools
uvtup black
uvtup  # Upgrade all tools
```

### Virtual Environment Operations

```powershell
# Create virtual environment
uvv

# Create named environment
uvv myenv --python 3.12

# Get environment information
Get-UVProjectInfo
Get-UVVirtualEnvPath
```

### Project Lifecycle

```powershell
# Initialize library project
uvi mylib --lib

# Build distributions
uvb

# Publish to PyPI
uvpub

# Publish to test PyPI
uvpub --repository testpypi
```

## Configuration

The plugin automatically detects:

-   **UV Installation**: Checks for uv command availability
-   **Project Structure**: Locates pyproject.toml and uv.lock files
-   **Virtual Environments**: Finds .venv, venv, or .env directories
-   **Python Versions**: Integrates with UV's Python management

## Common Workflows

### New Project Setup

```powershell
# Create and setup new project
uvi myproject
Set-Location myproject
uva requests flask pytest --dev
uvs
```

### Daily Development

```powershell
# Add new dependency
uva pandas

# Run tests
uvr pytest

# Format code
uvx black .

# Sync environment
uvs
```

### Tool Usage

```powershell
# Run formatters and linters
uvx black .
uvx flake8 src/
uvx mypy src/

# Run project scripts
uvr python manage.py migrate
uvr python -m mypackage
```

### Dependency Updates

```powershell
# Update lock file
uvlu

# Sync with upgrades
uvsu

# Export updated requirements
uvexp
```

## Environment Variables

The plugin respects standard UV environment variables:

-   `UV_PYTHON`: Default Python interpreter
-   `UV_VENV`: Virtual environment directory
-   `UV_CACHE_DIR`: Cache directory location
-   `UV_CONFIG_FILE`: Configuration file path
-   `UV_INDEX_URL`: Package index URL

## Error Handling

All functions include robust error handling:

-   **Installation Check**: Validates UV availability before operations
-   **Parameter Validation**: Ensures required parameters are provided
-   **Project Detection**: Confirms UV project structure exists
-   **Command Execution**: Captures and displays UV command output

## Integration

This plugin integrates with:

-   **PowerShell Profile**: Automatic loading and completion setup
-   **VS Code**: Enhanced development experience with IntelliSense
-   **Python Ecosystem**: Seamless integration with Python tools
-   **CI/CD Pipelines**: Suitable for automation scripts

## Tool Compatibility

Compatible with popular Python tools via uvx:

-   **Code Formatters**: black, autopep8, yapf
-   **Linters**: flake8, pylint, mypy, bandit
-   **Testing**: pytest, nose2, tox
-   **Documentation**: sphinx, mkdocs
-   **Development**: pre-commit, cookiecutter
-   **Web Tools**: httpie, pipx

## Common Commands Quick Reference

```powershell
# Project Management
uvi                    # Initialize project
uva package            # Add dependency
uvrm package           # Remove dependency
uvs                    # Sync dependencies

# Environment Management
uvv                    # Create virtual environment
uvr command            # Run in environment
uvpy install 3.12      # Install Python version

# Tool Operations
uvti tool              # Install tool
uvx tool args          # Run tool
uvtl                   # List tools

# Maintenance
uvup                   # Update UV
uvver                  # Show version
uvexp                  # Export requirements
```

## Error Troubleshooting

### UV Not Found

```powershell
# Check if UV is installed
Test-UVInstalled

# Install UV (if not installed)
# Visit https://docs.astral.sh/uv/getting-started/installation/
```

### Project Issues

```powershell
# Check project status
Test-UVProject
Get-UVProjectInfo

# Reinitialize if needed
uvi --force
```

### Dependency Conflicts

```powershell
# Refresh lock file
uvlr

# Sync with refresh
uvsr

# Check for conflicts
uvr pip check
```

## Contributing

This plugin is part of the [MKAbuMattar PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile) project. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

## Author

**Mohammad Abu Mattar**

-   GitHub: [@MKAbuMattar](https://github.com/MKAbuMattar)
-   Profile: [powershell-profile](https://github.com/MKAbuMattar/powershell-profile)

---

_"The only way to do great work is to love what you do." - Steve Jobs_
