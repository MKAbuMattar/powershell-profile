# Config Module

Centralized configuration management system for PowerShell profile settings.

## Overview

The Config module provides a robust JSON-based configuration management system with full CRUD operations, validation, import/export capabilities, and schema support. It enables centralized management of all profile settings with user-specific customization.

## Features

-   **JSON-based Storage**: All configuration stored in JSON format
-   **Schema Validation**: Ensures configuration integrity
-   **CRUD Operations**: Complete Create, Read, Update, Delete functionality
-   **Import/Export**: Share configurations across machines
-   **Merge Support**: Combine configurations intelligently
-   **Editor Integration**: Quick access to edit configuration files
-   **Default Templates**: Sensible defaults included
-   **Dot-Notation Access**: Easy nested property access
-   **Type Safety**: Validation for configuration values

## Installation

The module is automatically loaded with your PowerShell profile.

## Configuration Locations

-   **User Config**: `~/.config/ps1-profile-cfg.json` (user-specific settings)
-   **Default Config**: `Module/Config/config.default.json` (template)

## Commands

### Get-ProfileConfig

Retrieves configuration values from the user's config file.

**Syntax:**

```powershell
Get-ProfileConfig [-Key <string>] [-Default <object>]
```

**Examples:**

```powershell
# Get entire configuration
Get-ProfileConfig
cfg  # alias

# Get specific value
Get-ProfileConfig -Key "profile.theme"
cfg "profile.theme"

# Get value with default fallback
Get-ProfileConfig -Key "modules.lazyLoad" -Default $true
```

### Set-ProfileConfig

Sets a configuration value in the user's config file.

**Syntax:**

```powershell
Set-ProfileConfig -Key <string> -Value <object> [-Force] [-WhatIf] [-Confirm]
```

**Examples:**

```powershell
# Set a value
Set-ProfileConfig -Key "profile.theme" -Value "dark"
cfg-set "profile.theme" "dark"

# Create new nested property
Set-ProfileConfig -Key "custom.newSetting" -Value "value" -Force

# Enable lazy loading
cfg-set "modules.lazyLoad" $true

# Change editor
cfg-set "environment.editor" "vim"
```

### Reset-ProfileConfig

Resets configuration to default values.

**Syntax:**

```powershell
Reset-ProfileConfig [-Section <string>] [-Force] [-WhatIf] [-Confirm]
```

**Examples:**

```powershell
# Reset entire configuration (with confirmation)
Reset-ProfileConfig
cfg-reset

# Reset specific section
Reset-ProfileConfig -Section "modules"

# Reset without confirmation
Reset-ProfileConfig -Force
```

**Sections:**

-   `profile` - Profile appearance settings
-   `modules` - Module loading configuration
-   `aliases` - Custom aliases
-   `environment` - Environment variables and paths
-   `performance` - Performance settings

### Export-ProfileConfig

Exports configuration to a file for backup or sharing.

**Syntax:**

```powershell
Export-ProfileConfig -Path <string> [-Force] [-WhatIf] [-Confirm]
```

**Examples:**

```powershell
# Export configuration
Export-ProfileConfig -Path "C:\backup\my-config.json"
cfg-export ".\config-backup.json"

# Overwrite existing file
Export-ProfileConfig -Path ".\config.json" -Force
```

### Import-ProfileConfig

Imports configuration from a file.

**Syntax:**

```powershell
Import-ProfileConfig -Path <string> [-Merge] [-Force] [-WhatIf] [-Confirm]
```

**Examples:**

```powershell
# Import and replace configuration
Import-ProfileConfig -Path "C:\backup\my-config.json"
cfg-import ".\config.json"

# Merge with existing configuration
Import-ProfileConfig -Path ".\config.json" -Merge

# Import without validation
Import-ProfileConfig -Path ".\config.json" -Force
```

### Edit-ProfileConfig

Opens configuration file in an editor.

**Syntax:**

```powershell
Edit-ProfileConfig [-Editor <string>]
```

**Examples:**

```powershell
# Open in default editor
Edit-ProfileConfig
cfg-edit

# Open in VS Code
Edit-ProfileConfig -Editor VSCode

# Open in Notepad
Edit-ProfileConfig -Editor Notepad
```

**Editors:**

-   `Default` - System default editor
-   `VSCode` - Visual Studio Code
-   `Notepad` - Windows Notepad

### Test-ProfileConfig

Validates the configuration file.

**Syntax:**

```powershell
Test-ProfileConfig [-Path <string>]
```

**Examples:**

```powershell
# Validate current configuration
Test-ProfileConfig
cfg-test

# Validate specific file
Test-ProfileConfig -Path ".\my-config.json"
```

### Show-ProfileConfigInfo

Displays configuration system information.

**Syntax:**

```powershell
Show-ProfileConfigInfo
```

**Examples:**

```powershell
# Show configuration info
Show-ProfileConfigInfo
cfg-info
```

## Configuration Schema

### Top-Level Properties

```json
{
    "version": "5.0.0",
    "lastUpdated": "2026-01-10T00:00:00Z",
    "profile": {},
    "modules": {},
    "aliases": {},
    "environment": {},
    "performance": {},
    "logging": {},
    "starship": {},
    "psReadLine": {},
    "git": {},
    "docker": {},
    "aws": {},
    "azure": {},
    "customSettings": {}
}
```

### Profile Settings

Appearance and behavior settings.

```json
{
    "profile": {
        "theme": "default",
        "colorScheme": "auto",
        "showWelcomeMessage": true,
        "showLoadTime": true,
        "enableTimestamp": true
    }
}
```

### Module Settings

Module loading and enablement configuration.

```json
{
    "modules": {
        "lazyLoad": false,
        "loadTimeout": 5000,
        "autoUpdate": false,
        "enabled": {
            "Directory": true,
            "Docs": true,
            "Utility": true
        },
        "pluginsEnabled": {
            "Git": true,
            "Docker": true,
            "AWS": true
        }
    }
}
```

### Aliases

Custom command aliases.

```json
{
    "aliases": {
        "enableCustomAliases": true,
        "custom": {
            "ll": "Get-ChildItem -Force",
            "grep": "Select-String"
        }
    }
}
```

### Environment

Environment variables and tool paths.

```json
{
    "environment": {
        "editor": "code",
        "browser": "chrome",
        "terminal": "wt",
        "pythonPath": "",
        "customPath": []
    }
}
```

### Performance

Performance optimization settings.

```json
{
    "performance": {
        "enableCache": true,
        "cacheTimeout": 3600,
        "enableParallelLoading": false,
        "maxLoadJobs": 4
    }
}
```

## Usage Examples

### Basic Configuration Management

```powershell
# View current theme
cfg "profile.theme"

# Change theme
cfg-set "profile.theme" "dark"

# Enable lazy loading
cfg-set "modules.lazyLoad" $true

# Check if module is enabled
cfg "modules.enabled.Docker"

# Disable a plugin
cfg-set "modules.pluginsEnabled.AWS" $false
```

### Custom Aliases

```powershell
# Add custom alias
cfg-set "aliases.custom.gst" "git status" -Force

# Remove custom alias by setting to null
cfg-set "aliases.custom.gst" $null
```

### Environment Configuration

```powershell
# Set default editor
cfg-set "environment.editor" "vim"

# Set Python path
cfg-set "environment.pythonPath" "C:\Python39\python.exe"

# Add custom PATH entry
$paths = cfg "environment.customPath"
$paths += "C:\MyTools"
cfg-set "environment.customPath" $paths
```

### Backup and Restore

```powershell
# Backup configuration
cfg-export "$env:USERPROFILE\Documents\ps-config-backup.json"

# Restore configuration
cfg-import "$env:USERPROFILE\Documents\ps-config-backup.json"

# Merge with another configuration
cfg-import ".\team-config.json" -Merge
```

### Configuration Management Workflow

```powershell
# 1. View current configuration
cfg-info

# 2. Edit configuration
cfg-edit

# 3. Validate changes
cfg-test

# 4. If needed, reset specific section
cfg-reset -Section "modules"

# 5. Backup your configuration
cfg-export ".\my-config-$(Get-Date -Format 'yyyyMMdd').json"
```

## Advanced Usage

### Dot-Notation Access

Access nested properties using dot notation:

```powershell
# Get nested value
cfg "modules.pluginsEnabled.Git"

# Set nested value
cfg-set "docker.autoCleanup" $true

# Create new nested structure
cfg-set "customSettings.myApp.apiKey" "abc123" -Force
```

### Conditional Configuration

```powershell
# Enable feature based on condition
if ($env:COMPUTERNAME -eq "WORKSTATION") {
    cfg-set "performance.enableParallelLoading" $true
    cfg-set "performance.maxLoadJobs" 8
}

# Set editor based on availability
if (Get-Command code -ErrorAction SilentlyContinue) {
    cfg-set "environment.editor" "code"
} elseif (Get-Command vim -ErrorAction SilentlyContinue) {
    cfg-set "environment.editor" "vim"
}
```

### Migrating From Hardcoded Settings

```powershell
# Before (hardcoded in profile)
$MyTheme = "dark"
$EnableLazyLoad = $true

# After (configuration-based)
cfg-set "profile.theme" "dark"
cfg-set "modules.lazyLoad" $true

# Read from config in your profile
$MyTheme = cfg "profile.theme"
$EnableLazyLoad = cfg "modules.lazyLoad"
```

## Aliases

| Alias        | Command                | Description             |
| ------------ | ---------------------- | ----------------------- |
| `cfg`        | Get-ProfileConfig      | Get configuration value |
| `cfg-set`    | Set-ProfileConfig      | Set configuration value |
| `cfg-reset`  | Reset-ProfileConfig    | Reset configuration     |
| `cfg-export` | Export-ProfileConfig   | Export configuration    |
| `cfg-import` | Import-ProfileConfig   | Import configuration    |
| `cfg-edit`   | Edit-ProfileConfig     | Edit configuration file |
| `cfg-test`   | Test-ProfileConfig     | Validate configuration  |
| `cfg-info`   | Show-ProfileConfigInfo | Show configuration info |

## Troubleshooting

### Configuration File Not Found

If the configuration file doesn't exist, it will be created from defaults:

```powershell
# Manually create default configuration
Reset-ProfileConfig -Force
```

### Invalid JSON

If your configuration file contains invalid JSON:

```powershell
# Validate the file
cfg-test

# Reset to defaults if corrupted
cfg-reset -Force

# Or restore from backup
cfg-import ".\backup-config.json"
```

### Permission Issues

If you encounter permission errors accessing `~/.config/`:

```powershell
# Create directory manually
New-Item -Path "$env:USERPROFILE\.config" -ItemType Directory -Force

# Set appropriate permissions
icacls "$env:USERPROFILE\.config" /grant "${env:USERNAME}:(OI)(CI)F" /T
```

### Merge Conflicts

When merging configurations, later values override earlier ones:

```powershell
# Import base configuration
cfg-import ".\base-config.json"

# Merge with overrides
cfg-import ".\overrides.json" -Merge
```

## Best Practices

1. **Backup Regularly**: Export your configuration periodically
2. **Use Version Control**: Store your config in a Git repository
3. **Validate After Changes**: Always run `cfg-test` after manual edits
4. **Document Custom Settings**: Add comments to your configuration files
5. **Use Sections**: Organize settings logically in appropriate sections
6. **Test Before Committing**: Validate configuration works before sharing

## Integration with Profile

The Config module is designed to integrate seamlessly with your PowerShell profile:

```powershell
# In your Microsoft.PowerShell_profile.ps1

# Load Config module first
Import-Module "$PSScriptRoot\Module\Config\Config.psd1"

# Use configuration to control profile behavior
$ShowWelcome = Get-ProfileConfig -Key "profile.showWelcomeMessage" -Default $true
if ($ShowWelcome) {
    Write-Host "Welcome to PowerShell!" -ForegroundColor Cyan
}

# Conditionally load modules based on configuration
$EnableDocker = Get-ProfileConfig -Key "modules.pluginsEnabled.Docker" -Default $true
if ($EnableDocker) {
    Import-Module "$PSScriptRoot\Module\Plugins\Docker\Docker.psd1"
}
```

## Version History

### 1.0.0 (2026-01-10)

-   Initial release
-   JSON-based configuration management
-   Full CRUD operations
-   Schema validation
-   Import/Export functionality
-   Merge capabilities
-   Editor integration
-   Default configuration template

## Author

**MKAbuMattar**

## License

MIT License - See LICENSE file for details

---

For more information about other modules, use:

```powershell
Get-Help about_PowerShellProfile
docs
```
