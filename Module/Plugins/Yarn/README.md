# Yarn Plugin for PowerShell

This plugin provides comprehensive Yarn CLI shortcuts and utility functions for JavaScript/Node.js package management, workspace handling, and development workflows in PowerShell environments. It supports both Classic (v1.x) and Berry (v2+) Yarn versions with automatic detection and version-specific functionality.

## Features

-   **Universal Compatibility**: Works with both Yarn Classic (1.x) and Berry (2+) versions
-   **Automatic Version Detection**: Intelligently detects Yarn version and provides appropriate commands
-   **Comprehensive Alias Set**: Covers all common Yarn operations with intuitive shortcuts
-   **Tab Completion**: PowerShell tab completion for Yarn commands and parameters
-   **Global Path Management**: Automatically manages Yarn global bin directory in PATH
-   **Workspace Support**: Full support for Yarn workspaces and monorepo operations
-   **Development Workflow**: Shortcuts for build, test, lint, and serve operations
-   **Error Handling**: Robust error checking and user-friendly messages

## Prerequisites

-   PowerShell 5.0 or later
-   Yarn installed and accessible in PATH
-   Node.js (required by Yarn)

## Installation

This plugin is automatically loaded as part of MKAbuMattar's PowerShell Profile. No additional installation required.

## Available Commands

### Core Functions

| Function             | Alias | Description                     | Example              |
| -------------------- | ----- | ------------------------------- | -------------------- |
| `Invoke-Yarn`        | `y`   | Base Yarn command wrapper       | `y --version`        |
| `Get-YarnVersion`    | -     | Get installed Yarn version      | `Get-YarnVersion`    |
| `Test-YarnBerry`     | -     | Check if using Yarn Berry (v2+) | `Test-YarnBerry`     |
| `Get-YarnGlobalPath` | -     | Get global bin directory path   | `Get-YarnGlobalPath` |

### Package Management

| Function                              | Alias  | Description                  | Example               |
| ------------------------------------- | ------ | ---------------------------- | --------------------- |
| `Invoke-YarnAdd`                      | `ya`   | Add packages to project      | `ya react vue`        |
| `Invoke-YarnAddDev`                   | `yad`  | Add development dependencies | `yad jest typescript` |
| `Invoke-YarnAddPeer`                  | `yap`  | Add peer dependencies        | `yap react react-dom` |
| `Invoke-YarnRemove`                   | `yrm`  | Remove packages              | `yrm lodash`          |
| `Invoke-YarnUpgrade`                  | `yup`  | Upgrade dependencies         | `yup`                 |
| `Invoke-YarnUpgradeInteractive`       | `yui`  | Interactive upgrade          | `yui`                 |
| `Invoke-YarnUpgradeInteractiveLatest` | `yuil` | Interactive latest upgrade   | `yuil`                |

### Installation

| Function                           | Alias  | Description                      | Example |
| ---------------------------------- | ------ | -------------------------------- | ------- |
| `Invoke-YarnInstall`               | `yin`  | Install dependencies             | `yin`   |
| `Invoke-YarnInstallImmutable`      | `yii`  | Install without lockfile changes | `yii`   |
| `Invoke-YarnInstallFrozenLockfile` | `yifl` | Install with frozen lockfile     | `yifl`  |

### Development

| Function                  | Alias  | Description             | Example      |
| ------------------------- | ------ | ----------------------- | ------------ |
| `Invoke-YarnInit`         | `yi`   | Initialize new project  | `yi -y`      |
| `Invoke-YarnRun`          | `yrun` | Run package script      | `yrun build` |
| `Invoke-YarnStart`        | `yst`  | Run start script        | `yst`        |
| `Invoke-YarnDev`          | `yd`   | Run dev script          | `yd`         |
| `Invoke-YarnBuild`        | `yb`   | Run build script        | `yb`         |
| `Invoke-YarnServe`        | `ys`   | Run serve script        | `ys`         |
| `Invoke-YarnTest`         | `yt`   | Run tests               | `yt --watch` |
| `Invoke-YarnTestCoverage` | `ytc`  | Run tests with coverage | `ytc`        |
| `Invoke-YarnLint`         | `yln`  | Run linting             | `yln`        |
| `Invoke-YarnLintFix`      | `ylnf` | Run linting with fixes  | `ylnf`       |
| `Invoke-YarnFormat`       | `yf`   | Run code formatting     | `yf`         |

### Workspace Management

| Function                | Alias | Description           | Example             |
| ----------------------- | ----- | --------------------- | ------------------- |
| `Invoke-YarnWorkspace`  | `yw`  | Run workspace command | `yw frontend build` |
| `Invoke-YarnWorkspaces` | `yws` | Manage workspaces     | `yws info`          |

### Information & Utility

| Function                | Alias | Description                   | Example     |
| ----------------------- | ----- | ----------------------------- | ----------- |
| `Invoke-YarnWhy`        | `yy`  | Show why package is installed | `yy lodash` |
| `Invoke-YarnVersion`    | `yv`  | Manage project version        | `yv patch`  |
| `Invoke-YarnHelp`       | `yh`  | Show Yarn help                | `yh add`    |
| `Invoke-YarnPack`       | `yp`  | Pack project                  | `yp`        |
| `Invoke-YarnCacheClean` | `ycc` | Clean cache                   | `ycc`       |

### Berry-Specific (Yarn 2+)

| Function          | Alias  | Description          | Example                        |
| ----------------- | ------ | -------------------- | ------------------------------ |
| `Invoke-YarnDlx`  | `ydlx` | Download and execute | `ydlx create-react-app my-app` |
| `Invoke-YarnNode` | `yn`   | Run Node with PnP    | `yn script.js`                 |

### Classic-Specific (Yarn 1.x)

| Function                           | Alias  | Description             | Example         |
| ---------------------------------- | ------ | ----------------------- | --------------- |
| `Invoke-YarnGlobalAdd`             | `yga`  | Add global packages     | `yga nodemon`   |
| `Invoke-YarnGlobalList`            | `ygls` | List global packages    | `ygls`          |
| `Invoke-YarnGlobalRemove`          | `ygrm` | Remove global packages  | `ygrm nodemon`  |
| `Invoke-YarnGlobalUpgrade`         | `ygu`  | Upgrade global packages | `ygu`           |
| `Invoke-YarnList`                  | `yls`  | List packages           | `yls --depth=0` |
| `Invoke-YarnOutdated`              | `yout` | Show outdated packages  | `yout`          |
| `Invoke-YarnGlobalUpgradeAndClean` | `yuca` | Upgrade globals + clean | `yuca`          |

## Usage Examples

### Basic Package Management

```powershell
# Initialize new project
yi -y

# Install dependencies
ya react react-dom
yad @types/react @types/react-dom
yin

# Upgrade packages
yui
```

### Development Workflow

```powershell
# Start development
yd

# Run tests in watch mode
yt --watch

# Build for production
yb

# Lint and fix issues
ylnf
```

### Workspace Operations

```powershell
# Work with specific workspace
yw frontend install
yw api test

# Run command across all workspaces
yws foreach run build
```

### Global Package Management (Classic Only)

```powershell
# Install global tools
yga typescript nodemon

# List global packages
ygls

# Upgrade and clean
yuca
```

### Berry-Specific Operations

```powershell
# Execute without installing
ydlx create-react-app my-app

# Run Node with PnP
yn --version
```

## Version Detection

The plugin automatically detects whether you're using Yarn Classic (1.x) or Berry (2+) and provides appropriate commands:

-   **Classic (1.x)**: Includes global commands, list, outdated
-   **Berry (2+)**: Includes dlx, node, immutable installs

Commands not available in your Yarn version will show helpful warning messages.

## Configuration

### Global Path Management

The plugin automatically adds Yarn's global bin directory to your PATH if available:

```powershell
# Check global path
Get-YarnGlobalPath

# Manually initialize if needed
Initialize-YarnPath
```

### Tab Completion

Tab completion is automatically initialized when the module loads, providing completion for:

-   Yarn commands (add, remove, install, etc.)
-   Common script names (build, test, start, dev)
-   Version-specific commands

## Integration

This plugin integrates with:

-   **PowerShell Profile**: Automatic loading and initialization
-   **Node.js Projects**: Full package.json script support
-   **Monorepo Workflows**: Complete workspace management
-   **CI/CD Pipelines**: Immutable installs and caching

## Troubleshooting

### Common Issues

1. **Yarn not found**

    ```powershell
    # Verify Yarn installation
    Get-Command yarn
    yarn --version
    ```

2. **Global packages not in PATH**

    ```powershell
    # Check and fix global path
    Get-YarnGlobalPath
    Initialize-YarnPath
    ```

3. **Version-specific commands not working**
    ```powershell
    # Check Yarn version
    Get-YarnVersion
    Test-YarnBerry
    ```

### Performance Tips

-   Use `yii` for CI environments (immutable installs)
-   Use `ycc` regularly to clean cache
-   Use workspace commands for monorepos
-   Use `ydlx` instead of global installs in Berry

## Advanced Usage

### Custom Scripts Integration

```powershell
# Create custom function combining multiple operations
function Deploy-Frontend {
    yin           # Install dependencies
    yb            # Build
    yt            # Test
    yp            # Pack
}
```

### Workspace Automation

```powershell
# Build all workspaces in dependency order
yws foreach --topological-dev run build

# Run tests only in changed workspaces
yws foreach --since=origin/main run test
```

### Berry Zero-Install Setup

```powershell
# Set up zero-install project
yi
y set version berry
y config set nodeLinker pnp
yii
```

## Contributing

To contribute to this plugin:

1. Test changes with both Yarn Classic and Berry
2. Update function documentation with examples
3. Add new aliases following naming conventions
4. Update this README with new features

## Support

For issues and questions:

-   Check function help: `Get-Help Invoke-YarnAdd -Full`
-   Yarn documentation: https://yarnpkg.com/
-   PowerShell Profile: https://github.com/MKAbuMattar/powershell-profile

---

_This plugin is part of MKAbuMattar's PowerShell Profile - providing a consistent, powerful shell experience for developers._
