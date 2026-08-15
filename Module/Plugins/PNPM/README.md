# PNPM Plugin

Comprehensive PNPM CLI integration with PowerShell functions and convenient aliases for fast, disk space efficient package management. Provides complete workspace support, dependency management, development workflow automation, and advanced PNPM features with automatic PowerShell completion for modern JavaScript/Node.js development.

## Features

-   🚀 Complete PNPM command coverage with PowerShell functions
-   🔧 Convenient short aliases for common operations
-   📦 Package management (add, remove, update) with dependency types
-   🛠️ Development workflow automation (build, test, lint, format)
-   🏪 Advanced store management and optimization
-   🔗 Package linking and patching capabilities
-   ⚙️ Configuration management
-   🌐 Node.js environment management
-   📋 Workspace and monorepo support
-   🎯 Tab completion for commands and packages

## Installation

This module is included in MKAbuMattar's PowerShell Profile. It will be automatically loaded when PNPM is detected on your system.

## Quick Reference

### Core Commands

| Function             | Alias | Description                |
| -------------------- | ----- | -------------------------- |
| `Invoke-PNPM`        | `p`   | Base PNPM command wrapper  |
| `Test-PNPMInstalled` | -     | Check if PNPM is installed |
| `Get-PNPMVersion`    | -     | Get PNPM version           |
| `Get-PNPMStorePath`  | -     | Get PNPM store path        |

### Package Management

| Function                       | Alias  | Description                           |
| ------------------------------ | ------ | ------------------------------------- |
| `Invoke-PNPMAdd`               | `pa`   | Add packages to dependencies          |
| `Invoke-PNPMAddDev`            | `pad`  | Add packages to dev-dependencies      |
| `Invoke-PNPMAddOptional`       | `pao`  | Add packages to optional dependencies |
| `Invoke-PNPMAddPeer`           | `pap`  | Add packages to peer dependencies     |
| `Invoke-PNPMRemove`            | `prm`  | Remove packages                       |
| `Invoke-PNPMUpdate`            | `pup`  | Update packages                       |
| `Invoke-PNPMUpdateInteractive` | `pupi` | Interactive package updates           |

### Installation & Initialization

| Function                   | Alias | Description                  |
| -------------------------- | ----- | ---------------------------- |
| `Invoke-PNPMInstall`       | `pi`  | Install dependencies         |
| `Invoke-PNPMInstallFrozen` | `pif` | Install from frozen lockfile |
| `Invoke-PNPMInit`          | `pin` | Initialize new package.json  |

### Script Execution

| Function                  | Alias | Description                  |
| ------------------------- | ----- | ---------------------------- |
| `Invoke-PNPMRun`          | `pr`  | Run script from package.json |
| `Invoke-PNPMStart`        | `ps`  | Run start script             |
| `Invoke-PNPMDev`          | `pd`  | Run dev script               |
| `Invoke-PNPMBuild`        | `pb`  | Run build script             |
| `Invoke-PNPMServe`        | `psv` | Run serve script             |
| `Invoke-PNPMTest`         | `pt`  | Run test script              |
| `Invoke-PNPMTestCoverage` | `ptc` | Run tests with coverage      |

### Development Tools

| Function             | Alias  | Description                            |
| -------------------- | ------ | -------------------------------------- |
| `Invoke-PNPMLint`    | `pln`  | Run lint script                        |
| `Invoke-PNPMLintFix` | `plnf` | Run lint with auto-fix                 |
| `Invoke-PNPMFormat`  | `pf`   | Run format script                      |
| `Invoke-PNPMExec`    | `px`   | Execute command from node_modules/.bin |
| `Invoke-PNPMDlx`     | `pdlx` | Execute package without installing     |
| `Invoke-PNPMCreate`  | `pc`   | Create project from template           |

### Information & Analysis

| Function              | Alias   | Description                   |
| --------------------- | ------- | ----------------------------- |
| `Invoke-PNPMList`     | `pls`   | List installed packages       |
| `Invoke-PNPMOutdated` | `pout`  | Check for outdated packages   |
| `Invoke-PNPMAudit`    | `paud`  | Run security audit            |
| `Invoke-PNPMAuditFix` | `paudf` | Fix security audit issues     |
| `Invoke-PNPMWhy`      | `pw`    | Show why package is installed |

### Publishing & Distribution

| Function             | Alias  | Description                 |
| -------------------- | ------ | --------------------------- |
| `Invoke-PNPMPublish` | `ppub` | Publish package to registry |
| `Invoke-PNPMPack`    | `ppk`  | Create tarball from package |
| `Invoke-PNPMPrune`   | `ppr`  | Remove extraneous packages  |
| `Invoke-PNPMRebuild` | `prb`  | Rebuild packages            |

### Store Management

| Function                 | Alias  | Description                 |
| ------------------------ | ------ | --------------------------- |
| `Invoke-PNPMStore`       | `pst`  | Manage PNPM store           |
| `Invoke-PNPMStorePath`   | `pstp` | Get store path              |
| `Invoke-PNPMStoreStatus` | `psts` | Check store status          |
| `Invoke-PNPMStorePrune`  | `pspr` | Prune unreferenced packages |

### Environment & Configuration

| Function                  | Alias    | Description                |
| ------------------------- | -------- | -------------------------- |
| `Invoke-PNPMEnv`          | `penv`   | Manage Node.js environment |
| `Invoke-PNPMSetup`        | `psetup` | Setup PNPM                 |
| `Invoke-PNPMConfig`       | `pcfg`   | Manage configuration       |
| `Invoke-PNPMConfigGet`    | `pcfgg`  | Get configuration value    |
| `Invoke-PNPMConfigSet`    | `pcfgs`  | Set configuration value    |
| `Invoke-PNPMConfigDelete` | `pcfgd`  | Delete configuration value |
| `Invoke-PNPMConfigList`   | `pcfgl`  | List all configuration     |

### Advanced Features

| Function                 | Alias     | Description                   |
| ------------------------ | --------- | ----------------------------- |
| `Invoke-PNPMPatch`       | `ppatch`  | Create package patch          |
| `Invoke-PNPMPatchCommit` | `ppatchc` | Commit package patch          |
| `Invoke-PNPMFetch`       | `pfetch`  | Fetch packages to store       |
| `Invoke-PNPMLink`        | `plnk`    | Link packages for development |
| `Invoke-PNPMUnlink`      | `punlnk`  | Unlink packages               |
| `Invoke-PNPMImport`      | `pimp`    | Import from another lockfile  |
| `Invoke-PNPMDeploy`      | `pdep`    | Deploy for production         |
| `Invoke-PNPMCatalog`     | `pcat`    | Browse package catalog        |

## Usage Examples

### Basic Package Management

```powershell
# Install dependencies
pi

# Add packages
pa express lodash
pad -D typescript jest
pao fsevents
pap react vue

# Remove packages
prm unused-package

# Update packages
pup
pupi  # Interactive update
```

### Development Workflow

```powershell
# Start development
pd

# Run scripts
pr build
pr test
pt --watch
ptc  # with coverage

# Linting and formatting
pln
plnf  # auto-fix
pf
```

### Store Management

```powershell
# Check store status
psts

# Prune unused packages
pspr

# Get store path
pstp
```

### Advanced Features

```powershell
# Execute without installing
pdlx create-react-app my-app

# Create from template
pc vite my-vite-app

# Patch a package
ppatch lodash@4.17.21
# Make changes...
ppatchc /tmp/patch-dir

# Link local package
plnk ../my-local-package
```

### Workspace Operations

```powershell
# Install frozen lockfile (CI/CD)
pif

# Deploy to production
pdep dist

# Import from npm lockfile
pimp
```

### Configuration

```powershell
# View all config
pcfgl

# Set registry
pcfgs registry https://registry.npmjs.org

# Get config value
pcfgg store-dir
```

## PNPM Advantages

-   ⚡ **Fast** - Up to 2x faster than npm/yarn
-   💾 **Efficient** - Uses hard links and symlinks to save disk space
-   🔒 **Strict** - Creates non-flat node_modules preventing phantom dependencies
-   🏗️ **Monorepo** - Built-in workspace support
-   🛡️ **Secure** - Checks package integrity and prevents hijacking

## Tips

1. **Use frozen lockfile in CI/CD**: `pif` ensures reproducible builds
2. **Leverage workspaces**: PNPM excels at monorepo management
3. **Regular store maintenance**: Use `pspr` to clean up unused packages
4. **Interactive updates**: `pupi` helps review updates before applying
5. **Store queries**: Use `pw <package>` to understand dependency trees

## Requirements

-   PNPM installed on your system
-   PowerShell 5.0 or later

## Links

-   [PNPM Official Documentation](https://pnpm.io/)
-   [MKAbuMattar PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile)

## Commands

<!-- BEGIN GENERATED COMMANDS -->

<!-- Generated by Tools/Update-Readme.ps1 from the comment-based help in PNPM.psm1. -->
<!-- Edit the help in the source, then re-run the tool. Changes here are overwritten. -->

| Command | Alias | Description |
| --- | --- | --- |
| `Get-PNPMStorePath` |  | Gets the pnpm store path. |
| `Get-PNPMVersion` |  | Gets the current pnpm version. |
| `Invoke-PNPM` | `p` | Base pnpm command wrapper. |
| `Invoke-PNPMAdd` | `pa` | Add packages to dependencies. |
| `Invoke-PNPMAddDev` | `pad` | Add packages to dev-dependencies. |
| `Invoke-PNPMAddOptional` | `pao` | Add packages to optional dependencies. |
| `Invoke-PNPMAddPeer` | `pap` | Add packages to peer dependencies. |
| `Invoke-PNPMAudit` | `paud` | Run security audit. |
| `Invoke-PNPMAuditFix` | `paudf` | Fix security audit issues. |
| `Invoke-PNPMBuild` | `pb` | Run the build script. |
| `Invoke-PNPMCatalog` | `pcat` | Browse package catalog. |
| `Invoke-PNPMConfig` | `pcfg` | Manage pnpm configuration. |
| `Invoke-PNPMConfigDelete` | `pcfgd` | Delete pnpm configuration value. |
| `Invoke-PNPMConfigGet` | `pcfgg` | Get pnpm configuration value. |
| `Invoke-PNPMConfigList` | `pcfgl` | List all pnpm configuration. |
| `Invoke-PNPMConfigSet` | `pcfgs` | Set pnpm configuration value. |
| `Invoke-PNPMCreate` | `pc` | Create a new project using a template. |
| `Invoke-PNPMDeploy` | `pdep` | Deploy for production. |
| `Invoke-PNPMDev` | `pd` | Run the dev script. |
| `Invoke-PNPMDlx` | `pdlx` | Execute a package without installing it globally. |
| `Invoke-PNPMEnv` | `penv` | Manage Node.js environment. |
| `Invoke-PNPMExec` | `px` | Execute a command from node_modules/.bin. |
| `Invoke-PNPMFetch` | `pfetch` | Fetch packages to store. |
| `Invoke-PNPMFormat` | `pf` | Run the format script. |
| `Invoke-PNPMImport` | `pimp` | Import from another lockfile. |
| `Invoke-PNPMInit` | `pin` | Initialize a new package.json file. |
| `Invoke-PNPMInstall` | `pi` | Install dependencies. |
| `Invoke-PNPMInstallFrozen` | `pif` | Install dependencies from lockfile. |
| `Invoke-PNPMLink` | `plnk` | Link packages for development. |
| `Invoke-PNPMLint` | `pln` | Run the lint script. |
| `Invoke-PNPMLintFix` | `plnf` | Run lint with auto-fix. |
| `Invoke-PNPMList` | `pls` | List installed packages. |
| `Invoke-PNPMOutdated` | `pout` | Check for outdated packages. |
| `Invoke-PNPMPack` | `ppk` | Create a tarball from package. |
| `Invoke-PNPMPatch` | `ppatch` | Patch a package. |
| `Invoke-PNPMPatchCommit` | `ppatchc` | Commit a patch. |
| `Invoke-PNPMPrune` | `ppr` | Remove extraneous packages. |
| `Invoke-PNPMPublish` | `ppub` | Publish package to registry. |
| `Invoke-PNPMRebuild` | `prb` | Rebuild packages. |
| `Invoke-PNPMRemove` | `prm` | Remove packages from dependencies. |
| `Invoke-PNPMRun` | `pr` | Run a script defined in package.json. |
| `Invoke-PNPMServe` | `psv` | Run the serve script. |
| `Invoke-PNPMSetup` | `psetup` | Setup pnpm. |
| `Invoke-PNPMStart` | `ps` | Run the start script. |
| `Invoke-PNPMStore` | `pst` | Manage pnpm store. |
| `Invoke-PNPMStorePath` | `pstp` | Get pnpm store path. |
| `Invoke-PNPMStorePrune` | `pspr` | Prune pnpm store. |
| `Invoke-PNPMStoreStatus` | `psts` | Check pnpm store status. |
| `Invoke-PNPMTest` | `pt` | Run the test script. |
| `Invoke-PNPMTestCoverage` | `ptc` | Run tests with coverage. |
| `Invoke-PNPMUnlink` | `punlnk` | Unlink packages. |
| `Invoke-PNPMUpdate` | `pup` | Update packages to latest versions. |
| `Invoke-PNPMUpdateInteractive` | `pupi` | Update packages interactively. |
| `Invoke-PNPMWhy` | `pw` | Show why a package is installed. |

54 command(s).

<!-- END GENERATED COMMANDS -->
