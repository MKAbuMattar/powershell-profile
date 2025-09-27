# Terragrunt Plugin

A comprehensive PowerShell module that provides Terragrunt CLI shortcuts and utility functions for improved DRY Infrastructure as Code workflow. This plugin converts 25+ common Terragrunt operations to PowerShell functions with full parameter support, dependency orchestration, and multi-environment management.

## Features

- **🚀 Complete Terragrunt CLI Integration**: 25+ functions covering all major Terragrunt operations
- **⚡ Convenient Aliases**: Short aliases for frequent operations (e.g., `tg`, `tgp`, `tga`, `tgd`)
- **📦 Dependency Management**: Functions for dependency graphing, output management, and module orchestration
- **🏗️ Multi-Environment Support**: Workspace detection and environment-specific operations
- **🔍 State Management**: Complete state inspection, modification, and maintenance functions
- **📋 Tab Completion**: Full PowerShell tab completion for Terragrunt commands and options
- **🛡️ Error Handling**: Robust error handling and validation for safe operations
- **📖 Comprehensive Help**: Detailed help documentation for all functions

## Prerequisites

- **Terragrunt**: Must be installed and accessible in your system PATH
- **PowerShell 5.0+**: Required for module functionality
- **Terraform**: Required by Terragrunt (automatically detected)

## Installation

This plugin is part of the MKAbuMattar PowerShell Profile. To install:

```powershell
# Clone the profile repository
git clone https://github.com/MKAbuMattar/powershell-profile.git

# Import the Terragrunt plugin
Import-Module .\powershell-profile\Module\Plugins\Terragrunt\Terragrunt.psm1
```

## Function Reference

### Core Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-Terragrunt` | `tg` | Base Terragrunt command wrapper |
| `Test-TerragruntInstalled` | - | Tests if Terragrunt is available |
| `Initialize-TerragruntCompletion` | - | Sets up tab completion |

### Initialization Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntInit` | `tgi` | Initialize Terragrunt working directory |
| `Invoke-TerragruntInitFromModule` | `tgifm` | Initialize from remote module source |

### Planning Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntPlan` | `tgp` | Create execution plan |
| `Invoke-TerragruntPlanAll` | `tgpa` | Create execution plan for all modules |

### Application Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntApply` | `tga` | Apply configuration changes |
| `Invoke-TerragruntApplyAll` | `tgaa` | Apply all module configurations |
| `Invoke-TerragruntRefresh` | `tgr` | Refresh state to match infrastructure |
| `Invoke-TerragruntRefreshAll` | `tgra` | Refresh all module states |

### Destruction Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntDestroy` | `tgd` | Destroy infrastructure |
| `Invoke-TerragruntDestroyAll` | `tgda` | Destroy all module infrastructure |

### Code Management Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntFormat` | `tgf`, `tgfmt` | Format HCL files |
| `Invoke-TerragruntFormatHCL` | - | Alias for format operation |
| `Invoke-TerragruntValidate` | `tgv` | Validate configuration |
| `Invoke-TerragruntValidateAll` | `tgva` | Validate all configurations |
| `Invoke-TerragruntValidateInputs` | `tgvi` | Validate input variables |

### Dependency Management Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntRenderJSON` | `tgrj` | Render configuration as JSON |
| `Invoke-TerragruntGraphDependencies` | `tggd` | Generate dependency graph |
| `Invoke-TerragruntOutputAll` | `tgo` | Get outputs from all modules |
| `Invoke-TerragruntOutputModuleGroups` | `tgomg` | Get outputs by module groups |

### State Management Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntStateList` | `tgsl` | List resources in state |
| `Invoke-TerragruntStateShow` | `tgss` | Show specific resource details |
| `Invoke-TerragruntStateMv` | `tgsm` | Move resource address |
| `Invoke-TerragruntStateRm` | `tgsr` | Remove resource from state |

### Utility Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Invoke-TerragruntShow` | `tgsh` | Show state or plan |
| `Invoke-TerragruntProviders` | `tgpv` | Show provider information |
| `Invoke-TerragruntGet` | `tgget` | Download and update modules |
| `Invoke-TerragruntVersion` | `tgver` | Show Terragrunt version |

### Environment Functions

| Function | Alias | Description |
|----------|-------|-------------|
| `Get-TerragruntWorkingDir` | - | Get Terragrunt working directory |
| `Get-TerragruntConfigPath` | - | Get path to terragrunt.hcl |
| `Get-TerragruntCacheDir` | - | Get cache directory path |

## Usage Examples

### Basic Operations

```powershell
# Initialize a Terragrunt module
tgi

# Create an execution plan
tgp

# Apply changes with confirmation
tga

# Apply all modules in dependency order
tgaa

# Destroy infrastructure
tgd --terragrunt-non-interactive
```

### Advanced Operations

```powershell
# Validate all modules and their inputs
tgva
tgvi

# Generate dependency graph
tggd --terragrunt-graph-root /path/to/infrastructure

# Format all HCL files
tgf

# Get outputs from all modules
tgo --terragrunt-parallelism 5

# Show detailed configuration as JSON
tgrj | Out-File -Encoding UTF8 config.json
```

### State Management

```powershell
# List all resources in state
tgsl

# Show specific resource details
tgss aws_instance.web_server

# Move a resource to new address
tgsm aws_instance.old aws_instance.new

# Remove resource from state
tgsr aws_instance.deprecated
```

### Multi-Environment Workflow

```powershell
# Work with different environments
Set-Location ./environments/dev
tgp --terragrunt-non-interactive

Set-Location ../staging  
tgp --terragrunt-non-interactive

Set-Location ../prod
tgp --terragrunt-non-interactive
```

### Dependency Management

```powershell
# Apply modules respecting dependencies
tgaa --terragrunt-parallelism 3

# Get outputs organized by module groups
tgomg

# Refresh all module states
tgra --terragrunt-parallelism 5

# Validate dependency chain
tggd
```

## Configuration

The plugin automatically detects:

- **Terragrunt Installation**: Checks for terragrunt command availability
- **Working Directory**: Locates terragrunt.hcl files in current/parent directories
- **Cache Directory**: Identifies .terragrunt-cache location
- **Configuration Files**: Finds and validates terragrunt.hcl files

## Common Workflows

### Initial Setup

```powershell
# Initialize new Terragrunt infrastructure
tgi
tgp
tga
```

### Daily Operations

```powershell
# Plan and apply changes
tgp --terragrunt-non-interactive
tga --terragrunt-non-interactive
```

### Multi-Module Management

```powershell
# Validate and apply all modules
tgva
tgaa --terragrunt-parallelism 4
```

### Troubleshooting

```powershell
# Validate configuration and dependencies
tgv
tggd

# Check state consistency
tgsl
tgr

# Debug configuration rendering
tgrj | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

## Environment Variables

The plugin respects standard Terragrunt environment variables:

- `TERRAGRUNT_TFPATH`: Path to Terraform binary
- `TERRAGRUNT_IAM_ROLE`: AWS IAM role for operations
- `TERRAGRUNT_CONFIG`: Path to terragrunt.hcl file
- `TERRAGRUNT_DOWNLOAD`: Download directory for remote modules
- `TERRAGRUNT_SOURCE`: Source URL for remote state

## Error Handling

All functions include robust error handling:

- **Installation Check**: Validates Terragrunt availability before operations
- **Parameter Validation**: Ensures required parameters are provided
- **Directory Validation**: Confirms Terragrunt working directory exists
- **Command Execution**: Captures and displays Terragrunt command output

## Integration

This plugin integrates with:

- **PowerShell Profile**: Automatic loading and completion setup
- **VS Code**: Enhanced development experience with IntelliSense
- **Git Workflows**: Seamless integration with version control
- **CI/CD Pipelines**: Suitable for automation scripts

## Contributing

This plugin is part of the [MKAbuMattar PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile) project. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

## Author

**Mohammad Abu Mattar**
- GitHub: [@MKAbuMattar](https://github.com/MKAbuMattar)
- Profile: [powershell-profile](https://github.com/MKAbuMattar/powershell-profile)

---

*"The only way to do great work is to love what you do." - Steve Jobs*
