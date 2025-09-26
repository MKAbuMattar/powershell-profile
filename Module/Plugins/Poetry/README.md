# Poetry Plugin

A comprehensive PowerShell module that provides convenient aliases and functions for Python dependency management using Poetry. This plugin converts all common zsh/bash Poetry shortcuts to PowerShell equivalents with enhanced functionality and cross-platform support.

## Overview

The Poetry plugin streamlines Python development workflows by providing:

-   **30+ optimized Poetry aliases** for all Poetry operations
-   **Tab completion** for Poetry commands and options
-   **Comprehensive project lifecycle management** from init to publish
-   **Advanced dependency resolution** and virtual environment handling
-   **Cross-platform compatibility** (Windows, Linux, macOS)

## Prerequisites

-   **PowerShell 5.1+** or **PowerShell Core 7.0+**
-   **Poetry** installed and accessible in PATH
-   **Python 3.7+** (required by Poetry)

### Installing Poetry

```powershell
# Using the official installer (recommended)
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Using pip
pip install poetry

# Using package managers
# Windows (Chocolatey)
choco install poetry

# Windows (Scoop)
scoop install poetry

# macOS (Homebrew)
brew install poetry

# Linux (varies by distribution)
# Ubuntu/Debian
curl -sSL https://install.python-poetry.org | python3 -

# Conda
conda install poetry
```

## Installation

The Poetry plugin is automatically loaded as part of the PowerShell profile system. No additional installation steps required.

## Features

### Project Management Aliases

| Alias  | Full Command         | Description                       |
| ------ | -------------------- | --------------------------------- |
| `pin`  | `Invoke-PoetryInit`  | Initialize new Poetry project     |
| `pnew` | `Invoke-PoetryNew`   | Create new project with structure |
| `pch`  | `Invoke-PoetryCheck` | Check project configuration       |
| `pcmd` | `Invoke-PoetryList`  | List available packages           |

### Dependency Management Aliases

| Alias   | Full Command           | Description                |
| ------- | ---------------------- | -------------------------- |
| `pad`   | `Invoke-PoetryAdd`     | Add dependencies           |
| `prm`   | `Invoke-PoetryRemove`  | Remove dependencies        |
| `pup`   | `Invoke-PoetryUpdate`  | Update dependencies        |
| `pinst` | `Invoke-PoetryInstall` | Install all dependencies   |
| `psync` | `Invoke-PoetrySync`    | Sync with lock file        |
| `plck`  | `Invoke-PoetryLock`    | Update lock file           |
| `pexp`  | `Invoke-PoetryExport`  | Export to requirements.txt |

### Environment Management Aliases

| Alias   | Full Command             | Description                 |
| ------- | ------------------------ | --------------------------- |
| `psh`   | `Invoke-PoetryShell`     | Activate Poetry shell       |
| `prun`  | `Invoke-PoetryRun`       | Run commands in environment |
| `pvinf` | `Invoke-PoetryEnvInfo`   | Show environment info       |
| `ppath` | `Invoke-PoetryEnvPath`   | Show environment path       |
| `pvu`   | `Invoke-PoetryEnvUse`    | Use specific Python version |
| `pvrm`  | `Invoke-PoetryEnvRemove` | Remove virtual environment  |

### Build and Publishing Aliases

| Alias  | Full Command           | Description            |
| ------ | ---------------------- | ---------------------- |
| `pbld` | `Invoke-PoetryBuild`   | Build project packages |
| `ppub` | `Invoke-PoetryPublish` | Publish to repository  |

### Information & Discovery Aliases

| Alias   | Full Command              | Description                  |
| ------- | ------------------------- | ---------------------------- |
| `pshw`  | `Invoke-PoetryShow`       | Show package information     |
| `pslt`  | `Invoke-PoetryShowLatest` | Show latest package versions |
| `ptree` | `Invoke-PoetryShowTree`   | Show dependency tree         |

### Configuration & Self-Management Aliases

| Alias   | Full Command                   | Description                 |
| ------- | ------------------------------ | --------------------------- |
| `pconf` | `Invoke-PoetryConfig`          | Manage Poetry configuration |
| `pvoff` | `Disable-PoetryVirtualenv`     | Disable venv creation       |
| `psup`  | `Invoke-PoetrySelfUpdate`      | Update Poetry itself        |
| `psad`  | `Invoke-PoetrySelfAdd`         | Add Poetry plugins          |
| `pplug` | `Invoke-PoetrySelfShowPlugins` | Show installed plugins      |

## Usage Examples

### Project Initialization and Setup

```powershell
# Create new project from scratch
pnew myproject
cd myproject

# Or initialize in existing directory
mkdir existing-project
cd existing-project
pin

# Check project configuration
pch
poetry check
```

### Dependency Management

```powershell
# Add production dependencies
pad requests flask fastapi
poetry add requests flask fastapi

# Add development dependencies
pad pytest black flake8 --group dev
poetry add pytest black flake8 --group dev

# Add specific versions
pad "django>=3.2,<4.0"
poetry add "django>=3.2,<4.0"

# Remove dependencies
prm old-package
poetry remove old-package

# Update all dependencies
pup
poetry update

# Update specific package
pup requests
poetry update requests

# Install all dependencies
pinst
poetry install

# Install without development dependencies
pinst --no-dev
poetry install --no-dev

# Synchronize environment with lock file
psync
poetry install --sync
```

### Lock File and Requirements Management

```powershell
# Update lock file
plck
poetry lock

# Lock without updating dependencies
plck --no-update
poetry lock --no-update

# Export to requirements.txt
pexp
poetry export --without-hashes > requirements.txt

# Export including development dependencies
pexp --dev --output dev-requirements.txt
poetry export --dev --output dev-requirements.txt

# Export with hashes for security
pexp --with-credentials
poetry export --with-credentials
```

### Virtual Environment Management

```powershell
# Show environment information
pvinf
poetry env info

# Show only environment path
ppath
poetry env info --path

# Use specific Python version
pvu python3.9
poetry env use python3.9

pvu 3.10
poetry env use 3.10

# Remove environment
pvrm python3.9
poetry env remove python3.9

# Activate shell
psh
poetry shell

# Run commands in environment
prun python app.py
poetry run python app.py

# Run tests
prun pytest tests/
poetry run pytest tests/

# Run with specific script
prun python -m flask run
poetry run python -m flask run
```

### Package Information and Discovery

```powershell
# Show all installed packages
pshw
poetry show

# Show specific package information
pshw requests
poetry show requests

# Show latest available versions
pslt
poetry show --latest

# Show latest version of specific package
pslt django
poetry show django --latest

# Show dependency tree
ptree
poetry show --tree

# Show tree without development dependencies
ptree --no-dev
poetry show --tree --no-dev

# List available packages (commands)
pcmd
poetry list
```

### Build and Publishing

```powershell
# Build project
pbld
poetry build

# Build specific format only
pbld --format wheel
poetry build --format wheel

pbld --format sdist
poetry build --format sdist

# Publish to PyPI
ppub
poetry publish

# Publish to test PyPI
ppub --repository testpypi
poetry publish --repository testpypi

# Build and publish in one step
ppub --build
poetry publish --build
```

### Configuration Management

```powershell
# Show all configuration
pconf
poetry config --list

# Set configuration values
pconf repositories.testpypi.url https://test.pypi.org/legacy/
poetry config repositories.testpypi.url https://test.pypi.org/legacy/

pconf pypi-token.pypi your-token-here
poetry config pypi-token.pypi your-token-here

# Disable virtual environment creation
pvoff
poetry config virtualenvs.create false

# Enable in-project virtual environments
pconf virtualenvs.in-project true
poetry config virtualenvs.in-project true

# Set virtual environment path
pconf virtualenvs.path /custom/venv/path
poetry config virtualenvs.path /custom/venv/path
```

### Self-Management

```powershell
# Update Poetry itself
psup
poetry self update

# Update to preview version
psup --preview
poetry self update --preview

# Add Poetry plugins
psad poetry-plugin-export
poetry self add poetry-plugin-export

psad poetry-plugin-bundle
poetry self add poetry-plugin-bundle

# Show installed plugins
pplug
poetry self show plugins
```

## Advanced Features

### Tab Completion

The plugin provides intelligent tab completion for:

```powershell
# Poetry commands
poetry <TAB>
# Shows: add, build, check, config, env, export, init, install, etc.

# Common options
poetry add --<TAB>
# Shows: --group, --editable, --extras, --optional, --python, etc.

# Environment commands
poetry env <TAB>
# Shows: info, list, remove, use
```

### Error Handling

All functions include comprehensive error handling:

-   **Availability checks**: Verifies Poetry installation before execution
-   **Graceful failures**: Displays helpful error messages
-   **Verbose output**: Optional detailed logging with `-Verbose`

### Cross-Platform Support

The plugin works seamlessly across platforms:

-   **Windows**: PowerShell 5.1+ and PowerShell Core
-   **Linux**: PowerShell Core with proper PATH configuration
-   **macOS**: PowerShell Core with Homebrew or manual installation

## Configuration

### Environment Variables

The plugin respects standard Poetry environment variables:

```powershell
# Set Poetry home directory
$env:POETRY_HOME = "C:\poetry"

# Set cache directory
$env:POETRY_CACHE_DIR = "C:\poetry-cache"

# Set virtual environment location
$env:POETRY_VENV_PATH = "C:\venvs"

# Disable virtual environment creation
$env:POETRY_VIRTUALENVS_CREATE = "false"

# Use in-project virtual environments
$env:POETRY_VIRTUALENVS_IN_PROJECT = "true"
```

### Poetry Configuration

Common Poetry configuration settings:

```powershell
# Configure repositories
pconf repositories.private.url https://private-repo.com/simple/
pconf repositories.private.username your-username

# Configure PyPI tokens
pconf pypi-token.pypi your-token
pconf pypi-token.testpypi your-test-token

# Configure virtual environments
pconf virtualenvs.create true
pconf virtualenvs.in-project false
pconf virtualenvs.path "{cache-dir}/virtualenvs"

# Configure installer settings
pconf installer.parallel true
pconf installer.max-workers 8
```

## Troubleshooting

### Common Issues

**Poetry command not found:**

```powershell
# Check if Poetry is installed
Get-Command poetry

# Install Poetry
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Add to PATH (Windows)
$env:PATH += ";$env:APPDATA\Python\Scripts"
```

**Virtual environment issues:**

```powershell
# Check environment information
pvinf

# Verify Python version
prun python --version

# Recreate environment
pvrm python3.9
pvu python3.9
```

**Dependency resolution problems:**

```powershell
# Check project configuration
pch

# Update lock file
plck --no-update

# Clear cache and reinstall
poetry cache clear pypi --all
pinst
```

**Build/publish errors:**

```powershell
# Verify project structure
pch

# Build with verbose output
pbld --verbose

# Check configuration
pconf
```

### Debug Information

Enable verbose output for troubleshooting:

```powershell
# Enable verbose output for all Poetry functions
$VerbosePreference = "Continue"

# Run commands with verbose output
pad requests -Verbose
```

### Performance Tips

1. **Use lock files**: Always commit `poetry.lock` for consistent installs
2. **Enable parallel installation**: `pconf installer.parallel true`
3. **Use in-project environments**: `pconf virtualenvs.in-project true`
4. **Configure cache appropriately**: Set `POETRY_CACHE_DIR` for better performance

## Integration

### VS Code Integration

The plugin works seamlessly with VS Code:

```json
// .vscode/settings.json
{
    "python.defaultInterpreterPath": "./.venv/Scripts/python.exe",
    "python.poetryPath": "poetry",
    "python.terminal.activateEnvironment": true,
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true
}
```

### Git Integration

Recommended `.gitignore` entries:

```gitignore
# Virtual environments
.venv/
venv/
__pycache__/
*.pyc

# Poetry files (keep pyproject.toml and poetry.lock)
# Don't ignore pyproject.toml and poetry.lock

# Distribution
dist/
build/
*.egg-info/
```

## Examples and Workflows

### New Project Workflow

```powershell
# Create and setup new project
pnew my-awesome-project
cd my-awesome-project

# Add dependencies
pad fastapi uvicorn[standard]
pad pytest black flake8 mypy --group dev

# Configure environment
pvu python3.9
pconf virtualenvs.in-project true

# Install dependencies
pinst

# Update lock file
plck

# Run application
prun uvicorn main:app --reload
```

### Existing Project Workflow

```powershell
# Clone and setup existing project
git clone https://github.com/user/project.git
cd project

# Install dependencies
pinst

# Show project information
pvinf
ptree

# Run tests
prun pytest

# Update dependencies
pup
plck
```

### Library Development Workflow

```powershell
# Development cycle
cd my-library

# Add new dependencies
pad new-package

# Update lock file
plck

# Run tests
prun pytest tests/

# Check code quality
prun black .
prun flake8 .
prun mypy .

# Build and test
pbld
prun twine check dist/*

# Publish to test PyPI
ppub --repository testpypi

# Publish to PyPI
ppub
```

### Multi-Environment Workflow

```powershell
# Setup different Python environments
pvu python3.8
pinst
prun pytest  # Test with Python 3.8

pvu python3.9
pinst
prun pytest  # Test with Python 3.9

pvu python3.10
pinst
prun pytest  # Test with Python 3.10

# Show all environments
poetry env list
```

## Contributing

Contributions are welcome! Please ensure:

1. **Consistent alias naming**: Follow established Poetry alias patterns
2. **Comprehensive help**: Include detailed `.SYNOPSIS`, `.DESCRIPTION`, and `.EXAMPLE`
3. **Error handling**: Implement proper error checking and user feedback
4. **Cross-platform**: Test on Windows, Linux, and macOS

## Version History

-   **v4.1.0**: Full Poetry plugin with 30+ aliases and comprehensive functionality
-   **v4.0.0**: Initial Poetry integration and alias conversion

## Related Documentation

-   [Poetry Official Documentation](https://python-poetry.org/docs/)
-   [PowerShell Profile System](https://github.com/MKAbuMattar/powershell-profile)
-   [Python Packaging Guide](https://packaging.python.org/)

## License

This module is part of the MKAbuMattar PowerShell Profile project and is licensed under the MIT License.
