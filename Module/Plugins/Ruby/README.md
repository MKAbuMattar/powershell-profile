# Ruby Plugin

Comprehensive Ruby CLI integration with PowerShell functions and convenient aliases for Ruby development and gem management. Provides Ruby execution, gem operations, file searching, development server, and comprehensive Ruby workflow automation with automatic PowerShell completion for modern Ruby development and scripting.

## Features

-   💎 **Complete Ruby command coverage** with PowerShell functions
-   🔧 **Convenient short aliases** for common operations
-   📦 **Comprehensive gem management** (install, uninstall, list, info)
-   🔍 **Ruby file searching** with pattern matching
-   🌐 **Built-in development server** using Ruby's webrick
-   📜 **Inline Ruby execution** with code snippets
-   🔒 **Gem certificate management** for security
-   🧹 **Gem cleanup and maintenance** tools
-   🎯 **Tab completion** for Ruby and gem commands
-   🛡️ **Error handling** with comprehensive validation and informative messages
-   🚀 **Cross-platform support** with Windows/Unix adaptation

## Installation

This module is included in MKAbuMattar's PowerShell Profile. It will be automatically loaded when Ruby is detected on your system.

## Quick Reference

### Core Ruby Commands

| Function             | Alias     | Description                   |
| -------------------- | --------- | ----------------------------- |
| `Invoke-Ruby`        | `rb`      | Base Ruby command wrapper     |
| `Invoke-RubyExecute` | `rrun`    | Execute Ruby code inline      |
| `Start-RubyServer`   | `rserver` | Start simple Ruby HTTP server |
| `Find-RubyFiles`     | `rfind`   | Find and search in Ruby files |
| `Get-RubyVersion`    | -         | Get Ruby version              |
| `Test-RubyInstalled` | -         | Check if Ruby is installed    |

### Gem Management

| Function            | Alias    | Description                      |
| ------------------- | -------- | -------------------------------- |
| `Invoke-Gem`        | -        | Base gem command wrapper         |
| `Invoke-SudoGem`    | `sgem`   | Run gem with elevated privileges |
| `Install-Gem`       | `gein`   | Install Ruby gems                |
| `Uninstall-Gem`     | `geun`   | Uninstall Ruby gems              |
| `Get-GemList`       | `geli`   | List installed gems              |
| `Get-GemInfo`       | `gei`    | Get information about gems       |
| `Get-GemInfoAll`    | `geiall` | Get info about all gem versions  |
| `Get-GemVersion`    | -        | Get RubyGems version             |
| `Test-GemInstalled` | -        | Check if gem is installed        |

### Gem Certificates

| Function         | Alias  | Description            |
| ---------------- | ------ | ---------------------- |
| `Add-GemCert`    | `geca` | Add gem certificate    |
| `Remove-GemCert` | `gecr` | Remove gem certificate |
| `Build-GemCert`  | `gecb` | Build gem certificate  |

### Gem Utilities

| Function                  | Alias    | Description                     |
| ------------------------- | -------- | ------------------------------- |
| `Invoke-GemCleanup`       | `geclup` | Preview gem cleanup operation   |
| `Invoke-GemGenerateIndex` | `gegi`   | Generate gem index              |
| `Get-GemHelp`             | `geh`    | Get gem help                    |
| `Lock-Gem`                | `gel`    | Lock gem dependencies           |
| `Open-Gem`                | `geo`    | Open gem in default application |
| `Open-GemEditor`          | `geoe`   | Open gem in editor              |

## Usage Examples

### Basic Ruby Operations

```powershell
# Run Ruby commands
rb --version                    # Check Ruby version
rb script.rb                    # Run Ruby script
rb -c script.rb                 # Check Ruby script syntax

# Execute inline Ruby code
rrun "puts 'Hello World'"       # Simple output
rrun "puts RUBY_VERSION"        # Show Ruby version
rrun "p Dir.pwd"                # Show current directory
```

### Ruby Development Server

```powershell
# Start development server
rserver                         # Serve current directory on port 8080
Start-RubyServer -Port 3000     # Serve on port 3000
Start-RubyServer ./public -Port 4000  # Serve ./public on port 4000

# Server with custom options
rserver ./dist -Port 8080       # Serve specific directory
```

### File Searching

```powershell
# Search Ruby files
rfind "class"                   # Find all Ruby files containing "class"
rfind "def initialize"          # Find constructor definitions
Find-RubyFiles "module" ./src   # Search in specific directory
rfind "require" --include "*.rb"  # Search with additional options
```

### Gem Management

```powershell
# Install gems
gein rails                      # Install rails gem
gein bundler rake --no-document # Install multiple gems without docs
Install-Gem sinatra -v 2.2.0   # Install specific version

# List and search gems
geli                            # List all installed gems
geli rails                      # List gems matching "rails"
geli --local                    # List only local gems
```

### Gem Information

```powershell
# Get gem information
gei rails                       # Get rails gem info
gei bundler --remote            # Get remote gem info
geiall rails                    # Get info for all rails versions

# Gem help
geh                             # General gem help
geh install                     # Help for install command
geh uninstall                   # Help for uninstall command
```

### Gem Maintenance

```powershell
# Cleanup operations
geclup                          # Preview what cleanup would remove
gem cleanup                     # Actually perform cleanup
gegi --directory ./gems         # Generate index for gem repository

# Gem locking
gel                             # Create lock file
gel --strict                    # Create strict lock file
```

### Advanced Gem Operations

```powershell
# Open gems
geo rails                       # Open rails gem source
geoe bundler                    # Open bundler gem in editor

# Certificate management
geca certificate.pem            # Add certificate
gecr old_certificate            # Remove certificate
gecb developer@company.com      # Build new certificate
```

### System Administration

```powershell
# Elevated gem operations (requires admin on Windows)
sgem install system_gem         # Install gem with elevated privileges
sgem uninstall old_system_gem   # Uninstall system gem

# On Unix-like systems, uses sudo
# On Windows, requires running as administrator
```

## Best Practices

### 1. **Use Short Aliases for Frequent Operations**

```powershell
# Instead of
Invoke-Ruby script.rb

# Use
rb script.rb
```

### 2. **Gem Management Workflow**

```powershell
# Check what's installed
geli

# Install development gems
gein bundler rake minitest

# Install without documentation for faster installs
gein rails --no-document

# Regular maintenance
geclup                          # See what can be cleaned
gem cleanup                     # Clean up old versions
```

### 3. **Development Workflow**

```powershell
# Quick Ruby testing
rrun "puts 'Testing...'"

# Start development server for testing
rserver ./public -Port 3000

# Search for patterns in codebase
rfind "TODO"
rfind "FIXME"
rfind "def.*private"
```

### 4. **Gem Information Gathering**

```powershell
# Before installing, check gem info
gei proposed_gem --remote

# Check all available versions
geiall important_gem

# Get help for unfamiliar commands
geh command_name
```

### 5. **File Searching Best Practices**

```powershell
# Search for class definitions
rfind "^class.*"

# Find method definitions
rfind "def\s+\w+"

# Search for specific patterns in subdirectories
Find-RubyFiles "ActiveRecord" ./app/models
```

## Advanced Features

### Ruby Version Detection

The plugin automatically detects Ruby installation and provides version information:

```powershell
# Check Ruby status
Test-RubyInstalled              # Returns $true if Ruby available
Get-RubyVersion                 # Get detailed version info

# Check gem status
Test-GemInstalled               # Returns $true if gem available
Get-GemVersion                  # Get RubyGems version
```

### Cross-Platform Sudo Support

The `sgem` (Invoke-SudoGem) function handles elevated privileges differently on different platforms:

**Windows**: Checks for administrator privileges and warns if not running as admin
**Unix-like systems**: Uses `sudo` command if available

```powershell
# Install system-wide gem (requires appropriate privileges)
sgem install system_utility_gem

# The function will:
# - On Windows: Check for admin rights
# - On Linux/Mac: Use sudo if available
# - Fall back to regular gem if needed
```

### Ruby Development Server Features

The built-in server uses Ruby's webrick library:

```powershell
# Basic server
rserver                         # Serves current directory on 8080

# Advanced server options
Start-RubyServer -Path ./dist -Port 3000
Start-RubyServer . -Port 8080 -Arguments @('-v', '--bind-address', '0.0.0.0')
```

### File Search Capabilities

The `rfind` function provides powerful Ruby file searching:

```powershell
# Basic pattern search
rfind "pattern"                 # Search all .rb files recursively

# Advanced searching
Find-RubyFiles "pattern" ./specific/path
Find-RubyFiles "class.*Controller" ./app

# The function returns:
# filename:line_number:matching_line
```

## Configuration

### Environment Variables

The plugin respects standard Ruby environment variables:

| Variable       | Description                | Example                           |
| -------------- | -------------------------- | --------------------------------- |
| `RUBY_VERSION` | Ruby version preference    | `3.2.0`                           |
| `GEM_HOME`     | Gem installation directory | `/usr/local/gems`                 |
| `GEM_PATH`     | Gem search path            | `/usr/local/gems:/home/user/gems` |

### Ruby Detection

The plugin automatically detects Ruby installations in the following order:

1. **System PATH**: Uses `ruby` command if available
2. **RubyGems**: Uses `gem` command if available
3. **Version checking**: Validates installations with `--version`

```powershell
# Check current detection
Test-RubyInstalled
Test-GemInstalled
Get-RubyVersion
Get-GemVersion
```

## Troubleshooting

### Ruby Not Detected

**Problem**: Plugin reports Ruby is not installed.

**Solutions**:

```powershell
# Check if Ruby is in PATH
Get-Command ruby -ErrorAction SilentlyContinue

# Check Ruby installation
ruby --version

# Verify gem availability
gem --version

# Test plugin detection
Test-RubyInstalled
Get-RubyVersion
```

### Gem Installation Issues

**Problem**: Gems fail to install or require elevated privileges.

**Solutions**:

```powershell
# Try with elevated privileges
sgem install problematic_gem

# Install without documentation (faster)
gein gem_name --no-document

# Check gem environment
gem environment

# Install to user directory (Unix-like systems)
gem install gem_name --user-install
```

### Server Won't Start

**Problem**: Ruby development server fails to start.

**Solutions**:

```powershell
# Check if webrick is available
rrun "require 'webrick'; puts 'Webrick available'"

# Try different port
rserver -Port 3001

# Check for port conflicts
netstat -an | findstr :8080     # Windows
netstat -an | grep :8080        # Unix-like
```

### File Search Not Working

**Problem**: Ruby file search returns no results.

**Solutions**:

```powershell
# Check current directory has Ruby files
Get-ChildItem -Recurse -Filter "*.rb"

# Use absolute path
Find-RubyFiles "pattern" "C:\full\path\to\project"

# Test with simple pattern
rfind "puts"
rfind "class"
```

### Permission Issues (Windows)

**Problem**: `sgem` commands fail with permission errors.

**Solutions**:

```powershell
# Run PowerShell as Administrator
# Right-click PowerShell → "Run as Administrator"

# Check current privileges
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$isAdmin

# Use regular gem if admin not available
gein gem_name --user-install
```

## Tips and Tricks

### 1. **Quick Ruby Testing**

```powershell
# Test Ruby snippets quickly
rrun "puts 'Hello' * 3"
rrun "[1,2,3].map(&:to_s)"
rrun "File.exist?('README.md')"
```

### 2. **Gem Exploration**

```powershell
# Explore gem source code
geo interesting_gem             # Open in default app
geoe rails                      # Open in editor

# Check gem contents
gem contents gem_name
```

### 3. **Development Workflow**

```powershell
# Quick development setup
function New-RubyProject {
    param($Name)

    mkdir $Name
    cd $Name
    rrun "File.write('Gemfile', 'source \"https://rubygems.org\"\n')"
    rrun "File.write('$Name.rb', 'puts \"Hello from $Name\"')"
    gein bundler
}
```

### 4. **Batch Gem Operations**

```powershell
# Install multiple development gems
$devGems = @('bundler', 'rake', 'minitest', 'rubocop')
$devGems | ForEach-Object { gein $_ --no-document }

# Check multiple gems
$gems = @('rails', 'sinatra', 'hanami')
$gems | ForEach-Object { gei $_ }
```

### 5. **Code Quality Tools**

```powershell
# Search for code quality issues
rfind "TODO"
rfind "FIXME"
rfind "puts.*debug"             # Find debug statements
rfind "binding\.pry"            # Find debugging breakpoints
```

### 6. **Server Management**

```powershell
# Start server in background (Windows)
Start-Job -ScriptBlock { rserver }

# Start server with specific binding
rserver . -Port 8080 --bind-address 0.0.0.0
```

## Integration Examples

### Git Hooks Integration

```powershell
# Pre-commit hook to check Ruby syntax
Get-ChildItem -Recurse -Filter "*.rb" | ForEach-Object {
    rb -c $_.FullName
    if ($LASTEXITCODE -ne 0) { exit 1 }
}
```

### Build Pipeline Integration

```powershell
# CI/CD pipeline Ruby setup
Test-RubyInstalled
Get-RubyVersion
gein bundler --no-document
bundle install
bundle exec rake test
```

### Project Template Creation

```powershell
function New-RubyGemProject {
    param($GemName)

    bundle gem $GemName
    cd $GemName
    gein bundler rake minitest --no-document
    rrun "puts 'Gem $GemName created successfully!'"
}
```

## Contributing

This plugin is part of the MKAbuMattar PowerShell Profile. To contribute:

1. Fork the repository
2. Make your changes
3. Test with different Ruby versions and platforms
4. Submit a pull request

## License

This project is licensed under the MIT License - see the main repository for details.

## Links

-   [GitHub Repository](https://github.com/MKAbuMattar/powershell-profile)
-   [Ruby Documentation](https://ruby-lang.org/en/documentation/)
-   [RubyGems Documentation](https://guides.rubygems.org/)
-   [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
