# NPM Plugin

A comprehensive PowerShell module that provides npm CLI shortcuts and utility functions for improved Node.js package management workflow in PowerShell environments.

## Overview

This plugin converts 35+ common npm aliases and commands from zsh/bash to PowerShell functions with full parameter support and comprehensive help documentation. It includes automatic PowerShell completion support and seamlessly integrates Node.js package management into your PowerShell workflow.

## Features

-   **Complete npm Integration**: All essential npm commands with short aliases
-   **PowerShell Completion**: Automatic tab completion for npm commands and packages
-   **Full Parameter Support**: All npm arguments and options are supported
-   **Comprehensive Help**: Detailed help documentation for each function
-   **PowerShell Integration**: Native PowerShell function names with familiar aliases
-   **35+ Aliases**: Complete coverage of npm package management operations
-   **Security & Maintenance**: Built-in audit, cache management, and diagnostics

## Installation

This plugin is automatically loaded when the PowerShell profile is imported. No additional installation is required.

## Prerequisites

-   **Node.js**: Must be installed with npm included
-   **npm**: Latest version recommended for full compatibility
-   **PowerShell 5.0+**: Required for completion support

## Available Functions and Aliases

### Core Commands

| Alias  | Function                  | Description                          |
| ------ | ------------------------- | ------------------------------------ |
| `npm`  | `Invoke-Npm`              | Base npm command wrapper             |
| `npmg` | `Invoke-NpmInstallGlobal` | Install packages globally            |
| `npmS` | `Invoke-NpmInstallSave`   | Install and save to dependencies     |
| `npmD` | `Invoke-NpmInstallDev`    | Install and save to dev-dependencies |
| `npmF` | `Invoke-NpmInstallForce`  | Force npm to fetch remote resources  |

### Package Management

| Alias  | Function                  | Description                          |
| ------ | ------------------------- | ------------------------------------ |
| `npmS` | `Invoke-NpmInstallSave`   | Install and save to dependencies     |
| `npmD` | `Invoke-NpmInstallDev`    | Install and save to dev-dependencies |
| `npmg` | `Invoke-NpmInstallGlobal` | Install packages globally            |
| `npmF` | `Invoke-NpmInstallForce`  | Force reinstall packages             |
| `npmO` | `Invoke-NpmOutdated`      | Check for outdated packages          |
| `npmU` | `Invoke-NpmUpdate`        | Update packages                      |

### Development & Execution

| Alias   | Function              | Description                    |
| ------- | --------------------- | ------------------------------ |
| `npmE`  | `Invoke-NpmExecute`   | Execute from node_modules/.bin |
| `npmst` | `Invoke-NpmStart`     | Run npm start script           |
| `npmt`  | `Invoke-NpmTest`      | Run npm test script            |
| `npmR`  | `Invoke-NpmRun`       | Run custom npm scripts         |
| `npmrd` | `Invoke-NpmRunDev`    | Run development script         |
| `npmrb` | `Invoke-NpmRunBuild`  | Run build script               |
| `npmrs` | `Invoke-NpmRunScript` | Run custom script (alias)      |

### Information & Discovery

| Alias   | Function                 | Description             |
| ------- | ------------------------ | ----------------------- |
| `npmV`  | `Invoke-NpmVersion`      | Show npm version        |
| `npmL`  | `Invoke-NpmList`         | List installed packages |
| `npmL0` | `Invoke-NpmListTopLevel` | List top-level packages |
| `npmi`  | `Invoke-NpmInfo`         | Get package information |
| `npmSe` | `Invoke-NpmSearch`       | Search npm packages     |

### Publishing & Project Management

| Alias  | Function            | Description            |
| ------ | ------------------- | ---------------------- |
| `npmP` | `Invoke-NpmPublish` | Publish package        |
| `npmI` | `Invoke-NpmInit`    | Initialize new package |

### Security & Maintenance

| Alias    | Function             | Description                  |
| -------- | -------------------- | ---------------------------- |
| `npma`   | `Invoke-NpmAudit`    | Run security audit           |
| `npmaf`  | `Invoke-NpmAuditFix` | Fix security vulnerabilities |
| `npmc`   | `Invoke-NpmCache`    | Manage npm cache             |
| `npmdoc` | `Invoke-NpmDoctor`   | Run npm diagnostics          |

### Authentication & Configuration

| Alias       | Function               | Description                    |
| ----------- | ---------------------- | ------------------------------ |
| `npmwho`    | `Invoke-NpmWhoami`     | Show current npm user          |
| `npmlogin`  | `Invoke-NpmLogin`      | Login to npm registry          |
| `npmlogout` | `Invoke-NpmLogout`     | Logout from npm registry       |
| `npmping`   | `Invoke-NpmPing`       | Test npm registry connectivity |
| `npmcl`     | `Invoke-NpmConfigList` | List npm configuration         |
| `npmcg`     | `Invoke-NpmConfigGet`  | Get configuration value        |
| `npmcs`     | `Invoke-NpmConfigSet`  | Set configuration value        |

### Package Linking

| Alias     | Function           | Description                  |
| --------- | ------------------ | ---------------------------- |
| `npmln`   | `Invoke-NpmLink`   | Link package for development |
| `npmunln` | `Invoke-NpmUnlink` | Unlink package               |

## Usage Examples

### Basic Package Management

```powershell
# Install packages
npm install express
npmS express          # Install and save to dependencies
npmD jest            # Install and save to dev-dependencies
npmg nodemon         # Install globally

# Update and maintain packages
npmO                 # Check outdated packages
npmU                 # Update all packages
npmU express         # Update specific package
```

### Development Workflow

```powershell
# Initialize new project
npmI                 # Interactive init
npmI -y             # Init with defaults

# Development commands
npmst               # npm start
npmt                # npm test
npmrd               # npm run dev
npmrb               # npm run build
npmR lint           # npm run lint
npmR "test:unit"    # npm run test:unit
```

### Package Information & Discovery

```powershell
# Get information
npmV                # npm version
npmL                # List installed packages
npmL0               # List top-level packages only
npmi express        # Get package info
npmSe react         # Search for packages
```

### Advanced Features

```powershell
# Execute local binaries
npmE gulp           # Execute gulp from node_modules/.bin
npmE webpack --mode development

# Security and maintenance
npma                # Run security audit
npmaf               # Fix vulnerabilities automatically
npmc clean          # Clean npm cache
npmdoc              # Run diagnostics
```

### Configuration Management

```powershell
# View and manage config
npmcl               # List all configuration
npmcg registry      # Get registry setting
npmcs registry https://my-registry.com  # Set custom registry
```

### Authentication

```powershell
# Registry authentication
npmwho              # Check current user
npmping             # Test registry connectivity
npmlogin            # Login to registry
npmlogout           # Logout from registry
```

### Package Development

```powershell
# Package linking for local development
npmln               # Link current package globally
npmln my-package    # Link specific package to project
npmunln my-package  # Unlink package
```

### Publishing Workflow

```powershell
# Complete publishing workflow
npmI -y             # Initialize package
# ... develop your package ...
npmt                # Run tests
npma                # Security audit
npmV patch          # Bump version
npmP                # Publish to registry
```

## Advanced Features

### PowerShell Completion

The plugin automatically initializes npm completion for PowerShell:

-   Tab completion for npm commands and subcommands
-   Package name completion for installation operations
-   Script name completion for npm run commands
-   Configuration option completion

### Parameter Passing

All functions accept the same parameters as their npm counterparts:

```powershell
# Multiple packages
npmS express mongoose dotenv

# With options
npmS express --save-exact
npmD jest --save-exact
npmg typescript --latest

# Complex commands
npmR build -- --env production
npmR test -- --coverage --watch
```

### Help System Integration

Each function includes comprehensive help documentation:

```powershell
# Get help for any function
Get-Help Invoke-NpmInstallSave -Full
Get-Help npmS -Examples
Get-Help Invoke-NpmRun -Detailed
```

## Common Workflows

### New Project Setup

```powershell
# Create new project
mkdir my-app
cd my-app
npmI -y

# Install core dependencies
npmS express cors helmet
npmD jest supertest nodemon

# Set up scripts and start development
npmrd
```

### Package Maintenance

```powershell
# Check for issues
npmO                # Check outdated packages
npma                # Security audit
npmdoc              # Run diagnostics

# Update packages
npmU                # Update all packages
npmaf               # Fix vulnerabilities

# Clean up
npmc clean          # Clean cache
```

### Development Environment

```powershell
# Install development tools globally
npmg typescript ts-node nodemon
npmg @angular/cli @vue/cli create-react-app

# Project-specific development
npmD @types/node @types/express
npmD eslint prettier husky

# Run development tasks
npmrd               # Start dev server
npmR lint           # Run linting
npmR "test:watch"   # Run tests in watch mode
```

### Publishing Workflow

```powershell
# Pre-publish checks
npmt                # Run tests
npma                # Security audit
npmL0               # Check dependencies
npmV patch          # Version bump

# Publish
npmP                # Publish to registry
```

### Team Development

```powershell
# Fresh clone setup
npm install         # Install all dependencies
npmD husky          # Install development tools
npmR prepare        # Run setup scripts

# Daily workflow
npmst               # Start development
npmR dev            # Or run custom dev script
npmR test           # Run tests before commits
```

## Configuration Examples

### Custom Registry Setup

```powershell
# Set custom registry
npmcs registry https://my-company-registry.com

# Login to custom registry
npmlogin --registry https://my-company-registry.com

# Verify configuration
npmcg registry
npmping
```

### Development Environment Config

```powershell
# Set npm init defaults
npmcs init.author.name "Your Name"
npmcs init.author.email "your.email@example.com"
npmcs init.license "MIT"

# Set save preferences
npmcs save-exact true
npmcs save-prefix ""
```

## Performance and Optimization

### Cache Management

```powershell
# Cache operations
npmc verify         # Verify cache integrity
npmc clean          # Clean cache (frees space)
npmc clean --force  # Force clean cache
```

### Package Installation Optimization

```powershell
# Fast installations
npm ci              # Clean install from package-lock.json
npmF                # Force fresh installation
npm install --production  # Install only production dependencies
```

## Troubleshooting

### Common Issues

1. **npm not found**: Ensure Node.js and npm are installed and in PATH
2. **Permission errors**: Use npmg with appropriate permissions or configure npm prefix
3. **Registry connectivity**: Use npmping to test registry connection
4. **Cache issues**: Use npmc clean to clear npm cache

### Diagnostic Commands

```powershell
# Check installation
npmV                # Verify npm version
npmdoc              # Run npm doctor
npmcl               # Check configuration

# Debug network issues
npmping             # Test registry connectivity
npmcg registry      # Check registry setting

# Debug package issues
npmL                # Check installed packages
npmO                # Check for outdated packages
npma                # Run security audit
```

### Getting Help

```powershell
# npm help
npm help install    # Get help for specific commands
npm help config     # Configuration help

# PowerShell help
Get-Help npmS -Full    # Function-specific help
Get-Command *npm*      # List all npm functions
```

## Security Considerations

-   Always run `npma` before deploying to production
-   Use `npmaf` to automatically fix known vulnerabilities
-   Keep npm and Node.js updated to latest stable versions
-   Review package permissions before installing global packages
-   Use specific versions in package.json for reproducible builds
-   Regularly audit dependencies with `npma`

## Best Practices

### Package Management

-   Use `npmS` for runtime dependencies, `npmD` for development dependencies
-   Specify exact versions for critical dependencies
-   Regularly update packages with `npmU`
-   Keep package.json and package-lock.json in version control

### Development Workflow

-   Use `npmrd` and `npmrb` for standardized dev/build processes
-   Set up proper scripts in package.json for team consistency
-   Use `npmE` to run local binaries instead of global installations
-   Implement pre-commit hooks with `npmt` for testing

### Security & Maintenance

-   Run `npma` regularly, especially before releases
-   Use `npmaf` to automatically fix vulnerabilities
-   Keep npm cache clean with periodic `npmc clean`
-   Monitor outdated packages with `npmO`

## Requirements

-   **Node.js**: Version 14+ recommended for full compatibility
-   **npm**: Latest version for optimal performance
-   **PowerShell 5.0+**: For completion and advanced features

## Compatibility

This plugin works with:

-   npm 6.0+ (npm 9.0+ recommended)
-   Node.js 14.0+ (Node.js 18.0+ recommended)
-   Windows PowerShell 5.1
-   PowerShell Core 6.0+
-   All major npm registries (npmjs.org, private registries, etc.)

## Contributing

When adding new npm commands:

1. Follow the naming convention: `Invoke-Npm[Command]`
2. Add appropriate aliases matching the zsh/bash equivalents
3. Include comprehensive help documentation
4. Test with multiple npm versions
5. Update this README with new functions

## Version History

-   **v4.1.0**: Initial PowerShell conversion from zsh/bash aliases
    -   35+ npm commands with aliases
    -   PowerShell completion support
    -   Comprehensive help documentation
    -   Full parameter support for all npm operations
    -   Security and maintenance functions
    -   Configuration and authentication management
    -   Integration with PowerShell profile ecosystem
