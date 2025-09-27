# Helm Plugin

A comprehensive PowerShell module that provides Helm CLI shortcuts and utility functions for improved Kubernetes package management workflow in PowerShell environments.

## Overview

This plugin converts common Helm aliases from zsh/bash to PowerShell functions with full parameter support and comprehensive help documentation. It includes automatic PowerShell completion support and seamlessly integrates Helm package management into your PowerShell workflow.

## Features

- **Complete Helm Integration**: All essential Helm commands with short aliases
- **PowerShell Completion**: Automatic tab completion for Helm commands and options
- **Full Parameter Support**: All Helm arguments and options are supported
- **Comprehensive Help**: Detailed help documentation for each function
- **PowerShell Integration**: Native PowerShell function names with familiar aliases

## Installation

This plugin is automatically loaded when the PowerShell profile is imported. No additional installation is required.

## Prerequisites

- **Helm**: Must be installed and accessible via PATH
- **Kubernetes Cluster**: Access to a Kubernetes cluster for deployment operations
- **PowerShell 5.0+**: Required for completion support

## Available Functions and Aliases

### Core Commands

| Alias | Function               | Description               |
| ----- | ---------------------- | ------------------------- |
| `h`   | `Invoke-Helm`          | Base Helm command wrapper |
| `hin` | `Invoke-HelmInstall`   | Install Helm charts       |
| `hun` | `Invoke-HelmUninstall` | Uninstall Helm releases   |
| `hse` | `Invoke-HelmSearch`    | Search for Helm charts    |
| `hup` | `Invoke-HelmUpgrade`   | Upgrade Helm releases     |

## Usage Examples

### Package Management

```powershell
# Search for charts
hse repo nginx
hse hub wordpress
hse repo --versions mysql

# Install applications
hin my-nginx stable/nginx
hin my-app ./my-chart --namespace production
hin wordpress stable/wordpress --set wordpressPassword=secret

# Upgrade applications
hup my-nginx stable/nginx
hup my-app ./my-chart --install
hup wordpress stable/wordpress --set wordpressPassword=newsecret
```

### Repository Management

```powershell
# Add repositories
h repo add stable https://charts.helm.sh/stable
h repo add bitnami https://charts.bitnami.com/bitnami

# Update repositories
h repo update

# List repositories
h repo list
```

### Release Management

```powershell
# List releases
h list
h list --all-namespaces

# Get release information
h get values my-release
h get manifest my-release
h history my-release

# Uninstall releases
hun my-release
hun my-release --keep-history
hun my-release --namespace production
```

### Chart Development

```powershell
# Create new chart
h create my-chart

# Validate chart
h lint ./my-chart

# Package chart
h package ./my-chart

# Test installation
h install my-test ./my-chart --dry-run --debug
```

## Advanced Features

### PowerShell Completion

The plugin automatically initializes Helm completion for PowerShell:

- Tab completion for commands, subcommands, and flags
- Chart name completion for install/upgrade operations
- Release name completion for management operations
- Namespace completion for multi-namespace operations

### Parameter Passing

All functions accept the same parameters as their Helm counterparts:

```powershell
# Multiple values files
hin my-release stable/mysql -f values.yaml -f production-values.yaml

# Set individual values
hin my-release stable/nginx --set service.type=LoadBalancer

# Namespace and timeout
hin my-release stable/app --namespace production --timeout 10m

# Atomic upgrades
hup my-release stable/app --atomic --cleanup-on-fail
```

### Help System Integration

Each function includes comprehensive help documentation:

```powershell
# Get help for any function
Get-Help Invoke-HelmInstall -Full
Get-Help hin -Examples
```

## Common Workflows

### Application Deployment

```powershell
# 1. Add repository
h repo add bitnami https://charts.bitnami.com/bitnami

# 2. Search for chart
hse repo wordpress

# 3. Install application
hin my-wordpress bitnami/wordpress --namespace production --create-namespace

# 4. Check status
h status my-wordpress -n production

# 5. Upgrade when needed
hup my-wordpress bitnami/wordpress -n production
```

### Development Workflow

```powershell
# 1. Create chart
h create my-app

# 2. Develop and test locally
h lint ./my-app
h install test-release ./my-app --dry-run --debug

# 3. Install for testing
hin test-release ./my-app --namespace testing

# 4. Iterate and upgrade
hup test-release ./my-app --namespace testing

# 5. Clean up
hun test-release --namespace testing
```

## Requirements

- **Helm 3.x**: Recommended version for full compatibility
- **Kubernetes Cluster**: With appropriate RBAC permissions
- **PowerShell 5.0+**: For completion and advanced features

## Compatibility

This plugin works with:

- Helm 3.x (recommended)
- Helm 2.x (limited support)
- Windows PowerShell 5.1
- PowerShell Core 6.0+
- All Kubernetes distributions (EKS, GKE, AKS, etc.)

## Troubleshooting

### Common Issues

1. **Helm not found**: Ensure Helm is installed and in PATH
2. **Kubernetes connection**: Check cluster access with `kubectl cluster-info`
3. **RBAC permissions**: Verify sufficient permissions for namespace operations
4. **Repository access**: Check repository URLs and network connectivity

### Getting Help

```powershell
# Check Helm installation
h version

# List available commands
h --help

# Get function help
Get-Help hin -Full

# Debug installations
hin my-release stable/app --dry-run --debug
```

## Security Considerations

- Always validate charts before installation in production
- Use specific chart versions rather than latest
- Review values files for sensitive data
- Implement proper RBAC policies for Helm operations
- Use secure repositories and verify chart signatures

## Contributing

When adding new Helm commands:

1. Follow the naming convention: `Invoke-Helm[Command]`
2. Add appropriate aliases matching the zsh/bash equivalents
3. Include comprehensive help documentation
4. Test with multiple Helm versions
5. Update this README with new functions

## Version History

- **v4.1.0**: Initial PowerShell conversion from zsh/bash aliases
  - All core Helm commands with aliases
  - PowerShell completion support
  - Comprehensive help documentation
  - Full parameter support for all operations
  - Integration with PowerShell profile ecosystem
