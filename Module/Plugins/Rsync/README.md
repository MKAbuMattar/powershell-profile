# Rsync Plugin

PowerShell functions for file synchronization and transfer operations using rsync with comprehensive progress reporting and cross-platform support.

## 📋 Table of Contents

-   [Overview](#overview)
-   [Installation](#installation)
-   [Functions](#functions)
-   [Quick Reference](#quick-reference)
-   [Usage Examples](#usage-examples)
-   [Advanced Usage](#advanced-usage)
-   [Troubleshooting](#troubleshooting)
-   [Tips](#tips)
-   [Related Links](#related-links)

## 🔍 Overview

The Rsync plugin provides PowerShell functions that wrap common rsync operations with predefined flags for typical use cases. It converts bash-style rsync aliases to PowerShell functions with enhanced parameter handling, error checking, and user feedback.

### ✨ Key Features

-   **Copy Operations**: Archive-mode copying with progress and compression
-   **Move Operations**: Copy files and remove source (with confirmation)
-   **Update Operations**: Transfer only newer files to destination
-   **Synchronization**: Full directory sync with deletion of extra files
-   **Progress Reporting**: Visual progress indicators for all operations
-   **Safety Features**: Confirmation prompts for destructive operations
-   **Cross-Platform**: Works on Windows, Linux, and macOS
-   **Path Validation**: Local and remote path accessibility testing

## 🚀 Installation

This plugin requires `rsync` to be installed and accessible in your system PATH.

### Installing rsync:

**Windows:**

```powershell
# Using Chocolatey
choco install rsync

# Using Windows Subsystem for Linux (WSL)
wsl --install
```

**macOS:**

```bash
# Using Homebrew
brew install rsync

# Using MacPorts
sudo port install rsync
```

**Linux:**

```bash
# Ubuntu/Debian
sudo apt install rsync

# CentOS/RHEL/Fedora
sudo yum install rsync
# or
sudo dnf install rsync
```

Verify installation:

```powershell
Get-RsyncVersion
Test-RsyncInstalled
```

## 📚 Functions

| Function                | Alias               | Description                                       |
| ----------------------- | ------------------- | ------------------------------------------------- |
| `Invoke-RsyncCopy`      | `rsync-copy`        | Copy with archive, verbose, compression, progress |
| `Invoke-RsyncMove`      | `rsync-move`        | Move (copy + remove source files)                 |
| `Invoke-RsyncUpdate`    | `rsync-update`      | Update only newer files                           |
| `Sync-RsyncDirectories` | `rsync-synchronize` | Full sync with deletion                           |
| `Test-RsyncInstalled`   | -                   | Check if rsync is available                       |
| `Get-RsyncVersion`      | -                   | Display rsync version info                        |
| `Test-RsyncPath`        | -                   | Validate local/remote paths                       |
| `Show-RsyncHelp`        | -                   | Display comprehensive help                        |

## ⚡ Quick Reference

```powershell
# Copy operations
rsync-copy "source/" "destination/"          # Basic copy
Invoke-RsyncCopy "./docs/" "./backup/"       # Using full function name

# Move operations (with confirmation)
rsync-move "old/" "new/"                     # Move files
Invoke-RsyncMove "./temp/" "./archive/"      # Using function name

# Update operations
rsync-update "source/" "destination/"        # Update newer files only
Invoke-RsyncUpdate "./local/" "user@host:/remote/"  # Remote update

# Synchronization (with confirmation)
rsync-synchronize "master/" "mirror/"        # Full sync with deletion
Sync-RsyncDirectories "./src/" "./dest/"     # Using function name

# Utility functions
Test-RsyncInstalled                          # Check rsync availability
Get-RsyncVersion                            # Show version info
Test-RsyncPath "./folder/"                  # Test local path
Test-RsyncPath "user@host:/path/" -Remote   # Test remote path
Show-RsyncHelp                              # Display help
```

## 📖 Usage Examples

### Basic Copy Operations

```powershell
# Copy local directory with progress
rsync-copy "source-folder/" "backup-folder/"

# Copy to remote server
rsync-copy "./documents/" "user@server:/home/user/documents/"

# Copy from remote server
rsync-copy "user@server:/var/www/" "./website-backup/"

# Copy with additional options
Invoke-RsyncCopy "./src/" "./dest/" -AdditionalArgs @("--exclude", "*.tmp", "--dry-run")
```

### Move Operations

```powershell
# Move files locally (prompts for confirmation)
rsync-move "temporary-files/" "archived-files/"

# Move to remote location
rsync-move "./uploads/" "user@server:/storage/uploads/"

# Test move operation first
Invoke-RsyncMove "./test/" "./moved/" -AdditionalArgs @("--dry-run")
```

### Update Operations

```powershell
# Update backup with newer files only
rsync-update "working-directory/" "backup-directory/"

# Update remote server with local changes
rsync-update "./website/" "user@server:/var/www/html/"

# Update from remote source
rsync-update "user@server:/data/" "./local-data/"
```

### Directory Synchronization

```powershell
# Full synchronization (prompts for confirmation)
rsync-synchronize "master-copy/" "mirror-copy/"

# Synchronize with remote server
Sync-RsyncDirectories "./local/" "user@server:/remote/"

# Preview synchronization changes
Sync-RsyncDirectories "./src/" "./dest/" -AdditionalArgs @("--dry-run")
```

### Path Testing and Validation

```powershell
# Test local paths
Test-RsyncPath "./source-folder/"           # Returns $true if exists
Test-RsyncPath "./nonexistent/"            # Returns $false

# Test remote paths
Test-RsyncPath "user@server:/remote/path/" -Remote
Test-RsyncPath "user@server:/invalid/path/" -Remote

# Use in conditional operations
if (Test-RsyncPath "./source/") {
    rsync-copy "./source/" "./backup/"
} else {
    Write-Warning "Source path not found"
}
```

## 🔧 Advanced Usage

### Custom Rsync Options

```powershell
# Exclude patterns
rsync-copy "./project/" "./backup/" -AdditionalArgs @(
    "--exclude", "node_modules/",
    "--exclude", "*.log",
    "--exclude", ".git/"
)

# Bandwidth limiting
rsync-copy "./large-files/" "user@server:/storage/" -AdditionalArgs @(
    "--bwlimit=1000"  # Limit to 1MB/s
)

# Preserve specific attributes
Invoke-RsyncCopy "./source/" "./dest/" -AdditionalArgs @(
    "--perms",        # Preserve permissions
    "--times",        # Preserve modification times
    "--owner",        # Preserve owner
    "--group"         # Preserve group
)
```

### Batch Operations

```powershell
# Backup multiple directories
$directories = @("Documents", "Pictures", "Videos")
foreach ($dir in $directories) {
    if (Test-RsyncPath "C:\Users\$env:USERNAME\$dir\") {
        rsync-copy "C:\Users\$env:USERNAME\$dir\" "D:\Backup\$dir\"
    }
}

# Update multiple remote servers
$servers = @("server1", "server2", "server3")
foreach ($server in $servers) {
    rsync-update "./website/" "deploy@${server}:/var/www/html/"
}
```

### Scheduled Backups

```powershell
# Create backup script
$backupScript = {
    $source = "C:\ImportantData\"
    $destination = "\\BackupServer\Backups\$(Get-Date -Format 'yyyy-MM-dd')\"

    if (Test-RsyncInstalled) {
        Write-Host "Starting backup: $source -> $destination"
        rsync-copy $source $destination -AdditionalArgs @("--delete-after")
    }
}

# Run backup
& $backupScript

# Schedule with Windows Task Scheduler (requires additional setup)
```

### Error Handling

```powershell
# Robust rsync operation with error handling
function Invoke-SafeRsyncCopy {
    param($Source, $Destination)

    if (-not (Test-RsyncInstalled)) {
        Write-Error "Rsync is not installed"
        return
    }

    if (-not (Test-RsyncPath $Source)) {
        Write-Error "Source path does not exist: $Source"
        return
    }

    try {
        rsync-copy $Source $Destination -AdditionalArgs @("--dry-run")
        $confirm = Read-Host "Proceed with actual copy? (y/N)"

        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            rsync-copy $Source $Destination
        }
    }
    catch {
        Write-Error "Copy operation failed: $($_.Exception.Message)"
    }
}
```

## 🛠 Troubleshooting

### Common Issues

**Issue**: "rsync: command not found"

-   **Solution**: Install rsync using your system's package manager
-   **Check**: Run `Test-RsyncInstalled` to verify installation

**Issue**: Permission denied errors

-   **Solution**: Ensure proper file permissions and SSH key access for remote operations
-   **Check**: Test with `Test-RsyncPath` for remote paths

**Issue**: Network connectivity problems

-   **Solution**: Verify SSH access and network connectivity
-   **Test**: Use `ssh user@host` manually to test connection

**Issue**: Files not being transferred

-   **Solution**: Check if files are newer at destination (for update operations)
-   **Debug**: Use `--dry-run` flag to see what would be transferred

### Diagnostic Commands

```powershell
# Check rsync installation and version
Test-RsyncInstalled
Get-RsyncVersion

# Test paths before operations
Test-RsyncPath "./source/"
Test-RsyncPath "user@server:/remote/" -Remote

# Preview operations with dry-run
rsync-copy "./src/" "./dest/" -AdditionalArgs @("--dry-run")
rsync-synchronize "./master/" "./mirror/" -AdditionalArgs @("--dry-run")

# Verbose output for debugging
$VerbosePreference = "Continue"
rsync-update "./source/" "./destination/"
$VerbosePreference = "SilentlyContinue"
```

### Performance Optimization

```powershell
# Optimize for network transfers
rsync-copy "./local/" "user@server:/remote/" -AdditionalArgs @(
    "--compress-level=6",     # Compression level (1-9)
    "--partial",              # Keep partially transferred files
    "--partial-dir=.rsync-partial"  # Directory for partial files
)

# Optimize for local copies
rsync-copy "./source/" "./destination/" -AdditionalArgs @(
    "--whole-file",           # Don't use delta-transfer
    "--no-compress"           # Disable compression for local copies
)
```

## 💡 Tips

### Best Practices

-   Always test operations with `--dry-run` first for destructive operations
-   Use `Test-RsyncPath` to validate paths before running operations
-   Include trailing slashes on directory paths for consistent behavior
-   Use exclusion patterns to avoid transferring unnecessary files

### Efficiency Tips

```powershell
# Efficient backup strategy
function Invoke-IncrementalBackup {
    param($Source, $BackupRoot)

    $today = Get-Date -Format "yyyy-MM-dd"
    $latest = Join-Path $BackupRoot "latest"
    $current = Join-Path $BackupRoot $today

    # Create current backup linking to previous
    rsync-copy $Source $current -AdditionalArgs @(
        "--link-dest=$latest"     # Hard link unchanged files
    )

    # Update latest symlink
    if (Test-Path $latest) { Remove-Item $latest }
    New-Item -ItemType SymbolicLink -Path $latest -Value $current
}
```

### Integration Tips

```powershell
# Add to PowerShell profile for quick access
function Backup-Documents {
    rsync-update "$env:USERPROFILE\Documents\" "D:\Backup\Documents\"
}

function Sync-Projects {
    rsync-synchronize "C:\Projects\" "\\Server\Projects\"
}

# Create custom aliases
Set-Alias -Name backup -Value Backup-Documents
Set-Alias -Name sync -Value Sync-Projects
```

## 🔗 Related Links

-   **Plugin Documentation**: [Rsync Plugin README](https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md)
-   **PowerShell Profile**: [Main Repository](https://github.com/MKAbuMattar/powershell-profile)
-   **Rsync Official Documentation**: [rsync.samba.org](https://rsync.samba.org/)
-   **All Available Plugins**: [Plugins Overview](https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/README.md)
-   **Plugin Documentation System**: [Docs Module](https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Docs/README.md)

---

> **Note**: This plugin requires rsync to be installed and accessible in your system PATH. Rsync is available on most Unix-like systems and can be installed on Windows through various methods.

_Part of the [PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile) plugin ecosystem._
