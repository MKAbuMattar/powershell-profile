# VSCode Plugin

Comprehensive VS Code CLI integration with PowerShell functions and convenient aliases for Visual Studio Code, VS Code Insiders, and VSCodium. Provides automatic VS Code flavour detection, file operations, extension management, and comprehensive VS Code workflow automation with automatic PowerShell completion for modern development.

## Features

-   🔍 **Automatic VS Code flavour detection** (VS Code, VS Code Insiders, VSCodium)
-   🎯 **Manual VS Code preference** via `$env:VSCODE` environment variable
-   📂 **File and folder operations** (open, add, diff, goto)
-   🪟 **Window management** (new window, reuse window, wait mode)
-   🔧 **Extension management** (install, uninstall, list, disable)
-   👤 **Profile and user data** directory customization
-   🐛 **Debug and logging** options (verbose, log levels)
-   🎯 **Tab completion** for VS Code commands and options
-   🛡️ **Error handling** with comprehensive validation and informative messages
-   🚀 **Performance optimized** with cached executable detection

## Installation

This module is included in MKAbuMattar's PowerShell Profile. It will be automatically loaded when any VS Code flavour is detected on your system.

## Quick Reference

### Core Commands

| Function               | Alias | Description                       |
| ---------------------- | ----- | --------------------------------- |
| `Invoke-VSCode`        | `vsc` | Base VS Code command wrapper      |
| `Get-VSCodeVersion`    | -     | Get VS Code version information   |
| `Get-VSCodeExtensions` | -     | List installed VS Code extensions |

### File Operations

| Function            | Alias  | Description                          |
| ------------------- | ------ | ------------------------------------ |
| `Invoke-VSCodeAdd`  | `vsca` | Add folder to last active window     |
| `Invoke-VSCodeDiff` | `vscd` | Open VS Code in diff mode            |
| `Invoke-VSCodeGoto` | `vscg` | Go to specific line and column       |
| `Invoke-VSCodeWait` | `vscw` | Open and wait for files to be closed |

### Window Management

| Function                   | Alias  | Description                     |
| -------------------------- | ------ | ------------------------------- |
| `Invoke-VSCodeNewWindow`   | `vscn` | Open VS Code in new window      |
| `Invoke-VSCodeReuseWindow` | `vscr` | Open VS Code in existing window |

### Customization

| Function                     | Alias   | Description                     |
| ---------------------------- | ------- | ------------------------------- |
| `Invoke-VSCodeUserDataDir`   | `vscu`  | Use custom user data directory  |
| `Invoke-VSCodeProfile`       | `vscp`  | Open with specific profile      |
| `Invoke-VSCodeExtensionsDir` | `vsced` | Use custom extensions directory |

### Extension Management

| Function                          | Alias   | Description                       |
| --------------------------------- | ------- | --------------------------------- |
| `Invoke-VSCodeInstallExtension`   | `vscie` | Install VS Code extension         |
| `Invoke-VSCodeUninstallExtension` | `vscue` | Uninstall VS Code extension       |
| `Invoke-VSCodeDisableExtensions`  | `vscde` | Open with all extensions disabled |

### Debug & Logging

| Function               | Alias  | Description                  |
| ---------------------- | ------ | ---------------------------- |
| `Invoke-VSCodeVerbose` | `vscv` | Open with verbose logging    |
| `Invoke-VSCodeLog`     | `vscl` | Open with specific log level |

## Usage Examples

### Basic File Operations

```powershell
# Open current directory in VS Code
vsc

# Open specific file
vsc myfile.txt

# Open multiple files
vsc file1.js file2.css

# Open specific folder
vsc ./src

# Add folders to existing VS Code window
vsca ./src ./docs ./tests
```

### File Navigation

```powershell
# Open file and go to specific line
vscg file.js:25

# Open file and go to line and column
vscg app.py:100:15

# Compare two files in diff mode
vscd old-version.js new-version.js

# Open file and wait until closed (useful for git commits)
vscw COMMIT_EDITMSG
```

### Window Management

```powershell
# Open in new window
vscn ./project

# Force reuse existing window
vscr ./another-project

# Open and wait for file to be closed
vscw config.json
```

### Extension Management

```powershell
# Install extensions
vscie ms-python.python
vscie ms-vscode.powershell
vscie bradlc.vscode-tailwindcss

# Uninstall extensions
vscue old.extension.id

# List all installed extensions
Get-VSCodeExtensions

# Open without any extensions (troubleshooting)
vscde ./project
```

### Custom Profiles and Data Directories

```powershell
# Open with specific profile
vscp web-development ./my-web-project

# Use custom user data directory (portable mode)
vscu ./vscode-portable ./project

# Use custom extensions directory
vsced ./custom-extensions ./project
```

### Debug and Logging

```powershell
# Open with verbose logging
vscv ./project

# Open with specific log level
vscl debug ./project
vscl trace

# Available log levels: trace, debug, info, warn, error, critical, off
```

### Manual VS Code Flavour Selection

```powershell
# Set preferred VS Code flavour
$env:VSCODE = 'code-insiders'

# Or use VSCodium
$env:VSCODE = 'codium'

# Reset to auto-detection
$env:VSCODE = $null
```

## Best Practices

### 1. **Use Short Aliases for Frequent Operations**

```powershell
# Instead of
Invoke-VSCode ./project

# Use
vsc ./project
```

### 2. **Leverage Window Management**

```powershell
# Open related projects in separate windows
vscn ./frontend
vscn ./backend
vscn ./docs
```

### 3. **Use Profiles for Different Development Environments**

```powershell
# Web development profile
vscp web-dev ./web-project

# Data science profile
vscp data-science ./analysis-project

# System administration profile
vscp sysadmin ./automation-scripts
```

### 4. **Extension Management Workflow**

```powershell
# Install essential extensions for new setup
vscie ms-vscode.powershell
vscie ms-python.python
vscie bradlc.vscode-tailwindcss
vscie esbenp.prettier-vscode

# Check installed extensions
Get-VSCodeExtensions | Sort-Object
```

### 5. **Debugging and Troubleshooting**

```powershell
# Start with clean slate (no extensions)
vscde ./problematic-project

# Enable verbose logging for issues
vscv ./project

# Use trace logging for detailed debugging
vscl trace ./project
```

## Advanced Features

### VS Code Flavour Detection

The plugin automatically detects available VS Code flavours in this order:

1. **Manual preference**: Uses `$env:VSCODE` if set and valid
2. **VS Code**: Checks for `code` command
3. **VS Code Insiders**: Checks for `code-insiders` command
4. **VSCodium**: Checks for `codium` command

```powershell
# Check detected flavour
Get-VSCodeExecutable

# Force specific flavour
$env:VSCODE = 'code-insiders'

# Verify detection
Test-VSCodeInstalled
```

### Integration with Git Workflow

```powershell
# Set VS Code as Git editor (wait mode)
git config --global core.editor "code --wait"

# Use for commit messages
git commit # Opens VS Code, waits for file to be closed

# Use for interactive rebase
git rebase -i HEAD~3 # Opens VS Code for editing
```

### Project-Specific Workflows

```powershell
# Open project with specific setup
function Open-WebProject {
    param($ProjectPath)

    # Open in new window with web-dev profile
    vscp web-dev $ProjectPath

    # Add related directories
    vsca "./docs" "./tests"
}

# Open data science project
function Open-DataProject {
    param($ProjectPath)

    # Open with custom extensions for data science
    vsced "./data-science-extensions" $ProjectPath
}
```

## Configuration

### Environment Variables

| Variable      | Description                       | Example           |
| ------------- | --------------------------------- | ----------------- |
| `$env:VSCODE` | Manual VS Code flavour preference | `'code-insiders'` |

### Supported VS Code Flavours

| Executable      | Description                | Detection Priority |
| --------------- | -------------------------- | ------------------ |
| `code`          | VS Code (stable)           | 1st (after manual) |
| `code-insiders` | VS Code Insiders (preview) | 2nd                |
| `codium`        | VSCodium (open source)     | 3rd                |

## Troubleshooting

### VS Code Not Detected

**Problem**: Plugin reports no VS Code flavour detected.

**Solutions**:

```powershell
# Check if VS Code is in PATH
Get-Command code -ErrorAction SilentlyContinue
Get-Command code-insiders -ErrorAction SilentlyContinue
Get-Command codium -ErrorAction SilentlyContinue

# Manually set preferred flavour
$env:VSCODE = 'code'  # or 'code-insiders', 'codium'

# Verify detection
Test-VSCodeInstalled
Get-VSCodeExecutable
```

### Extensions Not Installing

**Problem**: Extensions fail to install.

**Solutions**:

```powershell
# Try with verbose logging
vscv --install-extension ms-python.python

# Check extensions directory permissions
vsced ./temp-extensions --install-extension ms-python.python

# Install without running VS Code
code --install-extension ms-python.python --force
```

### Performance Issues

**Problem**: VS Code opens slowly.

**Solutions**:

```powershell
# Start without extensions
vscde ./project

# Use minimal logging
vscl error ./project

# Check startup performance
vscv --prof-startup
```

### Profile/Settings Conflicts

**Problem**: Settings or extensions conflict between projects.

**Solutions**:

```powershell
# Use project-specific profiles
vscp project-specific ./my-project

# Use isolated user data directory
vscu ./project-settings ./my-project

# Combine both for complete isolation
vscu ./project-data --profile project-profile ./my-project
```

## Tips and Tricks

### 1. **Quick Project Access**

```powershell
# Create functions for frequent projects
function vsc-main { vsc ~/projects/main-project }
function vsc-web { vscp web-dev ~/projects/web-app }
function vsc-api { vscn ~/projects/api-server }
```

### 2. **Batch Extension Management**

```powershell
# Install multiple extensions
$extensions = @(
    'ms-vscode.powershell',
    'ms-python.python',
    'bradlc.vscode-tailwindcss',
    'esbenp.prettier-vscode'
)
$extensions | ForEach-Object { vscie $_ }
```

### 3. **Development Environment Setup**

```powershell
# Setup new machine with essential extensions
$essentialExtensions = Get-Content './essential-extensions.txt'
$essentialExtensions | ForEach-Object { vscie $_ }
```

### 4. **Temporary Workspace**

```powershell
# Create temporary workspace with isolated settings
$tempDir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
vscu $tempDir ./my-project
```

### 5. **Performance Monitoring**

```powershell
# Monitor VS Code performance
vscv --prof-startup | Tee-Object -FilePath './vscode-perf.log'
```

## Keyboard Integration

While this plugin focuses on CLI operations, you can integrate with PowerShell keyboard shortcuts:

```powershell
# Add to your PowerShell profile for quick access
Set-PSReadLineKeyHandler -Key 'Ctrl+Shift+c' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('vsc .')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
```

## Contributing

This plugin is part of the MKAbuMattar PowerShell Profile. To contribute:

1. Fork the repository
2. Make your changes
3. Test thoroughly with different VS Code flavours
4. Submit a pull request
