# Dependency Module

Module dependency management and health checking system for PowerShell profile.

## Features

-   **Dependency Mapping**: Tracks all module dependencies and relationships
-   **Version Checking**: Validates module versions against requirements
-   **Health Diagnostics**: Comprehensive module health checks
-   **Automatic Installation**: Install missing dependencies automatically
-   **Conflict Detection**: Detects function/alias conflicts and circular dependencies
-   **Visual Graphs**: Display dependency relationships in tree format

## Functions

### Get-ModuleDependencies (alias: `deps`)

Gets the dependencies for a profile module.

```powershell
# Get direct dependencies
Get-ModuleDependencies -ModuleName 'Performance'
deps Performance

# Get full dependency chain
Get-ModuleDependencies -ModuleName 'DockerCompose' -IncludeChain
deps DockerCompose -IncludeChain
```

### Test-ModuleVersion (alias: `test-version`)

Tests if a module version meets requirements.

```powershell
# Check against dependency map version
Test-ModuleVersion -ModuleName 'Logging'
test-version Logging

# Check against specific version
Test-ModuleVersion -ModuleName 'Config' -RequiredVersion '2.0.0'
```

### Test-ModuleHealth (alias: `module-health`)

Performs a comprehensive health check on modules.

```powershell
# Check specific module
Test-ModuleHealth -ModuleName 'Performance'
module-health Performance

# Check all modules
Test-ModuleHealth

# Use cached results
Test-ModuleHealth -UseCache
```

**Health Check Includes:**

-   Module installation status
-   Version requirements
-   Dependency availability
-   Required command availability (docker, kubectl, etc.)
-   Module loadability
-   Issues and warnings

### Install-ModuleDependencies (alias: `install-deps`)

Automatically installs missing module dependencies.

```powershell
# Install dependencies for specific module
Install-ModuleDependencies -ModuleName 'Performance'
install-deps Performance

# Check and install for all modules
Install-ModuleDependencies

# Force reinstall
Install-ModuleDependencies -Force
```

**Note**: This only handles PowerShell module dependencies. External commands (docker, kubectl, etc.) must be installed manually.

### Test-ModuleConflict (alias: `check-conflicts`)

Detects conflicts between modules.

```powershell
# Check all modules
Test-ModuleConflict
check-conflicts

# Check specific module
Test-ModuleConflict -ModuleName 'Docker'
```

**Detects:**

-   Duplicate function names
-   Duplicate alias names
-   Circular dependencies
-   Version conflicts

### Show-DependencyGraph (alias: `dep-graph`)

Displays a visual dependency graph for modules.

```powershell
# Show all module dependencies
Show-DependencyGraph
dep-graph

# Show specific module
Show-DependencyGraph -ModuleName 'Performance'
dep-graph Docker
```

## Dependency Map

The module maintains a comprehensive dependency map including:

```powershell
@{
    ModuleName = @{
        Version = '1.0.0'
        Dependencies = @('Module1', 'Module2')
        RequiredCommands = @('command1', 'command2')
        Description = 'Module description'
    }
}
```

### Core Modules

-   **Config**: Configuration management (no dependencies)
-   **Logging**: Enhanced logging (depends on Config)
-   **Performance**: Performance monitoring (depends on Config, Logging)
-   **Plugins**: Plugin system (no dependencies)

### Plugin Modules

All plugin modules depend on the Plugins module and may require external commands:

-   **Docker**: Docker CLI integration (requires `docker`)
-   **DockerCompose**: Docker Compose (requires `docker-compose`, depends on Docker)
-   **Git**: Git integration (requires `git`)
-   **Kubectl**: Kubernetes CLI (requires `kubectl`)
-   **AWS**: AWS CLI (requires `aws`)
-   **And many more...**

## Health Status Levels

-   **Healthy**: All checks passed, no issues or warnings
-   **Warning**: Module works but has warnings (outdated dependencies, missing optional commands)
-   **Unhealthy**: Module has issues (not installed, missing required dependencies)

## Examples

### Check System Health

```powershell
# Quick health check
module-health | Where-Object Status -ne 'Healthy'

# Detailed report
module-health | Format-Table ModuleName, Status, Version, @{L='Issues';E={$_.Issues -join '; '}}
```

### View Dependencies

```powershell
# See what Performance needs
deps Performance

# See full chain for DockerCompose
deps DockerCompose -IncludeChain
```

### Troubleshoot Module Issues

```powershell
# Check specific module health
$health = module-health Docker

# View issues
$health.Issues

# View warnings
$health.Warnings

# Check if commands are available
$health.RequiredCommands | ForEach-Object {
    Write-Host "$_ : $(Get-Command $_ -ErrorAction SilentlyContinue ? 'Available' : 'Missing')"
}
```

### Detect Conflicts

```powershell
# Check for any conflicts
$conflicts = check-conflicts

# View by severity
$conflicts | Group-Object Severity | Format-Table Count, Name
```

### Visualize Dependencies

```powershell
# See the whole graph
dep-graph

# Focus on specific module
dep-graph Performance
```

## Best Practices

1. **Run Health Checks Regularly**: Use `module-health` to catch issues early
2. **Check Before Updates**: Run `test-version` before updating modules
3. **Resolve Conflicts**: Use `check-conflicts` when adding new modules
4. **View Dependencies**: Use `dep-graph` to understand module relationships
5. **Use Caching**: Enable `-UseCache` for faster repeated health checks

## Configuration

The Dependency module uses the dependency map defined internally. No external configuration is required.

## Location

-   **Module**: `Module/Dependency/Dependency.psm1`
-   **Manifest**: `Module/Dependency/Dependency.psd1`
-   **Documentation**: This file

## Version History

### Version 1.0.0 (January 11, 2026)

-   Initial release
-   Dependency mapping for all profile modules
-   Module version checking
-   Module health diagnostics
-   Automatic dependency installation support
-   Conflict detection (functions, aliases, circular dependencies)
-   Visual dependency graph display
