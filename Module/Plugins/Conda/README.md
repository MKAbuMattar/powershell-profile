# Conda Plugin

Comprehensive Conda CLI integration with PowerShell functions and convenient aliases for data science environment management, package installation, and Python/R development workflow automation. Provides complete environment lifecycle management, package operations, configuration management, and advanced Conda features with automatic PowerShell completion for modern data science and scientific computing.

## Features

-   🐍 **Complete Conda command coverage** with PowerShell functions
-   🔧 **Convenient short aliases** for common operations
-   🏗️ **Environment management** (create, activate, deactivate, remove)
-   📦 **Package operations** (install, remove, update, search) with dependency resolution
-   ⚙️ **Configuration management** for channels, settings, and preferences
-   📊 **Data science workflow** automation and environment reproducibility
-   🔍 **Information commands** for environments, packages, and system details
-   🧹 **Maintenance tools** for cache cleaning and optimization
-   🎯 **Tab completion** for commands, environments, and packages
-   🛡️ **Error handling** with comprehensive validation and informative messages

## Installation

This module is included in MKAbuMattar's PowerShell Profile. It will be automatically loaded when Conda is detected on your system.

## Quick Reference

### Core Commands

| Function              | Alias | Description                      |
| --------------------- | ----- | -------------------------------- |
| `Invoke-Conda`        | `cn`  | Base Conda command wrapper       |
| `Get-CondaVersion`    | -     | Get Conda version                |
| `Get-CondaInfo`       | -     | Get Conda system information     |
| `Get-CondaEnvs`       | -     | Get list of environments         |
| `Get-CurrentCondaEnv` | -     | Get currently active environment |

### Environment Management

| Function                     | Alias  | Description                       |
| ---------------------------- | ------ | --------------------------------- |
| `Invoke-CondaActivate`       | `cna`  | Activate environment              |
| `Invoke-CondaActivateBase`   | `cnab` | Activate base environment         |
| `Invoke-CondaDeactivate`     | `cnde` | Deactivate current environment    |
| `Invoke-CondaCreateName`     | `cncr` | Create environment by name        |
| `Invoke-CondaCreateNameYes`  | `cncn` | Create environment (auto-confirm) |
| `Invoke-CondaCreatePath`     | `cncp` | Create environment at path        |
| `Invoke-CondaCreateFromFile` | `cncf` | Create from environment file      |
| `Invoke-CondaRemoveEnvName`  | `cnrn` | Remove environment by name        |
| `Invoke-CondaRemoveEnvPath`  | `cnrp` | Remove environment by path        |

### Environment Information

| Function                | Alias  | Description                  |
| ----------------------- | ------ | ---------------------------- |
| `Invoke-CondaEnvList`   | `cnel` | List all environments        |
| `Invoke-CondaEnvExport` | `cnee` | Export environment to file   |
| `Invoke-CondaEnvUpdate` | `cneu` | Update environment from file |

### Package Management

| Function                  | Alias  | Description                     |
| ------------------------- | ------ | ------------------------------- |
| `Invoke-CondaInstall`     | `cni`  | Install packages                |
| `Invoke-CondaInstallYes`  | `cniy` | Install packages (auto-confirm) |
| `Invoke-CondaRemove`      | `cnr`  | Remove packages                 |
| `Invoke-CondaRemoveYes`   | `cnry` | Remove packages (auto-confirm)  |
| `Invoke-CondaUpdate`      | `cnu`  | Update specific packages        |
| `Invoke-CondaUpdateAll`   | `cnua` | Update all packages             |
| `Invoke-CondaUpdateConda` | `cnuc` | Update Conda itself             |

### Package Information

| Function                   | Alias   | Description               |
| -------------------------- | ------- | ------------------------- |
| `Invoke-CondaList`         | `cnl`   | List installed packages   |
| `Invoke-CondaListExport`   | `cnle`  | Export package list       |
| `Invoke-CondaListExplicit` | `cnles` | Create explicit spec file |
| `Invoke-CondaSearch`       | `cnsr`  | Search for packages       |

### Configuration Management

| Function                        | Alias     | Description                |
| ------------------------------- | --------- | -------------------------- |
| `Invoke-CondaConfig`            | `cnconf`  | Manage configuration       |
| `Invoke-CondaConfigShowSources` | `cncss`   | Show config sources        |
| `Invoke-CondaConfigGet`         | `cnconfg` | Get configuration value    |
| `Invoke-CondaConfigSet`         | `cnconfs` | Set configuration value    |
| `Invoke-CondaConfigRemove`      | `cnconfr` | Remove configuration value |
| `Invoke-CondaConfigAdd`         | `cnconfa` | Add configuration value    |

### Maintenance & Cleanup

| Function               | Alias   | Description                         |
| ---------------------- | ------- | ----------------------------------- |
| `Invoke-CondaClean`    | `cncl`  | Clean caches and temp files         |
| `Invoke-CondaCleanAll` | `cncla` | Clean everything (thorough cleanup) |

## Usage Examples

### Basic Environment Management

```powershell
# Create and activate data science environment
cncr datascience python=3.9 pandas numpy matplotlib
cna datascience

# Create from environment file
cncf environment.yml

# List all environments
cnel

# Activate base environment
cnab

# Deactivate current environment
cnde
```

### Package Operations

```powershell
# Install data science packages
cni pandas numpy matplotlib seaborn jupyter

# Install with auto-confirmation
cniy scikit-learn tensorflow pytorch

# Search for packages
cnsr "machine learning"
cnsr tensorflow

# Update specific packages
cnu pandas numpy
cnua  # Update all packages

# Remove packages
cnr unused-package
cnry package1 package2  # Auto-confirm removal
```

### Environment Lifecycle

```powershell
# Complete data science environment setup
cncr ml-project python=3.9
cna ml-project
cni pandas numpy scikit-learn jupyter matplotlib seaborn
cnee > ml-environment.yml

# Replicate environment elsewhere
cncf ml-environment.yml
cna ml-project

# Update existing environment
cneu -f updated-environment.yml
```

### Configuration Management

```powershell
# View all configuration
cnconf --show

# Add conda-forge channel
cnconfa channels conda-forge

# Set configuration values
cnconfs channel_priority strict
cnconfs ssl_verify false

# Get specific config
cnconfg channels
cnconfg channel_priority

# Show config sources
cncss
```

### Maintenance & Optimization

```powershell
# Clean package cache
cncl --packages

# Clean index cache
cncl --index-cache

# Thorough cleanup (all caches, temp files)
cncla

# Check system information
Get-CondaInfo
Get-CondaVersion
```

### Advanced Workflows

```powershell
# Research environment with specific versions
cncr research python=3.8 "numpy=1.19" "pandas>=1.2" "matplotlib<3.5"
cna research
cnles > research-specs.txt  # Create exact specification

# Production environment from explicit specs
cncf research-specs.txt --name production
cna production

# Multi-language environment
cncr polyglot python=3.9 r-base r-essentials jupyter
cna polyglot
cni rpy2 jupyter-r  # Bridge Python and R
```

### Data Science Project Setup

```powershell
# Complete ML project environment
cncr mlops python=3.9
cna mlops
cni pandas numpy scikit-learn tensorflow jupyter mlflow dvc
cni -c conda-forge prefect great-expectations
cnee > mlops-environment.yml

# Development tools environment
cncr dev-tools python=3.9
cna dev-tools
cni pytest black flake8 mypy pre-commit sphinx
cni jupyter jupyterlab ipywidgets
```

## Conda Advantages

-   🔬 **Scientific Computing**: Purpose-built for data science and scientific computing
-   📦 **Cross-Language**: Manages Python, R, C++, Fortran, and other language packages
-   🔒 **Dependency Resolution**: Sophisticated solver prevents conflicts
-   🌐 **Multi-Platform**: Consistent environments across Windows, macOS, and Linux
-   ⚡ **Binary Packages**: Pre-compiled packages for faster installation
-   🎯 **Environment Isolation**: Complete isolation including system-level dependencies
-   🔄 **Reproducible**: Exact environment recreation with environment files

## Tips

1. **Use environment files**: `cnee > environment.yml` for reproducible environments
2. **Leverage conda-forge**: Add conda-forge channel for more packages
3. **Regular cleanup**: Use `cncla` to free disk space and optimize performance
4. **Explicit specifications**: Use `cnles` for exact version pinning in production
5. **Channel priority**: Set `strict` channel priority for consistent installs
6. **Environment naming**: Use descriptive names that reflect project purpose

## Common Data Science Workflows

### Machine Learning Environment

```powershell
# Create ML environment with common packages
cncr ml python=3.9 pandas numpy scikit-learn matplotlib seaborn jupyter
cna ml
cni tensorflow keras pytorch torchvision
cnee > ml-environment.yml
```

### Data Analysis Environment

```powershell
# Analytics environment with visualization
cncr analytics python=3.9 pandas numpy matplotlib seaborn plotly
cna analytics
cni jupyter jupyterlab ipywidgets bokeh altair
cni statsmodels scipy
```

### R and Python Integration

```powershell
# Multi-language data science
cncr r-python python=3.9 r-base r-essentials
cna r-python
cni rpy2 jupyter r-irkernel
cni pandas numpy matplotlib ggplot2 dplyr
```

## Requirements

-   Conda or Miniconda installed on your system
-   PowerShell 5.0 or later
-   Conda accessible in PATH

## Troubleshooting

### Installation Issues

1. **Conda not found**: Ensure Conda is installed and added to PATH
2. **Permission errors**: Run PowerShell as administrator if needed
3. **Environment activation**: Use `conda init powershell` to set up shell integration

### Performance Optimization

```powershell
# Get system information
Get-CondaInfo

# Clean up for performance
cncla

# Update Conda itself
cnuc
```

### Environment Problems

```powershell
# List environments to verify
cnel

# Check current environment
Get-CurrentCondaEnv

# Force recreation if corrupted
cnrn problematic-env
cncf environment.yml --name problematic-env
```

## Links

-   [Conda Official Documentation](https://docs.conda.io/)
-   [Conda-Forge Community](https://conda-forge.org/)
-   [Miniconda Installation](https://docs.conda.io/en/latest/miniconda.html)
-   [MKAbuMattar PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile)

### Channel Management

```powershell
# Add channel
Invoke-CondaConfigAdd channels conda-forge
cnconfa channels conda-forge

# Remove channel
Invoke-CondaConfigRemove channels defaults
cnconfr channels defaults

# Set channel priority
Invoke-CondaConfigSet channel_priority strict
cnconfs channel_priority strict
```

### Settings

```powershell
# Get setting value
Invoke-CondaConfigGet auto_activate_base
cnconfg auto_activate_base

# Set setting value
Invoke-CondaConfigSet auto_activate_base false
cnconfs auto_activate_base false
```

## Maintenance

### Cleaning

```powershell
# Clean packages cache
Invoke-CondaClean --packages
cncl --packages

# Clean all caches and unused packages
Invoke-CondaCleanAll
cncla

# Clean specific cache types
cncl --tarballs --index-cache
```

## Common Workflows

### Data Science Environment Setup

```powershell
# Create a data science environment
cncn datascience python=3.9 pandas numpy matplotlib seaborn jupyter scikit-learn

# Activate the environment
cna datascience

# Install additional packages
cniy tensorflow keras plotly

# Export environment for sharing
cnee > datascience.yml
```

### Environment Cloning

```powershell
# Export existing environment
cna myenv
cnee > myenv.yml

# Create new environment from export
cncf myenv.yml

# Or create with different name
cncf myenv.yml -n newenv
```

### Package Management Workflow

```powershell
# Update all packages in environment
cna myenv
cnua

# Clean up afterwards
cncla

# Check what's installed
cnl
```

### Development Environment

```powershell
# Create development environment
cncn devenv python=3.10 pip setuptools wheel

# Activate and install development tools
cna devenv
cniy black flake8 pytest pre-commit

# Export for team use
cnee > devenv.yml
```

## Advanced Usage

### Batch Operations

```powershell
# Multiple environment creation
$envs = @('env1', 'env2', 'env3')
$envs | ForEach-Object { cncn $_ python=3.9 }

# Bulk package installation
$packages = @('numpy', 'pandas', 'matplotlib', 'seaborn')
$packages | ForEach-Object { cniy $_ }
```

### Environment Validation

```powershell
# Check if environment exists
if (Get-CondaEnvs | Where-Object { $_ -eq 'myenv' }) {
    Write-Host "Environment exists"
    cna myenv
} else {
    Write-Host "Creating environment"
    cncr myenv python=3.9
}
```

### Conditional Package Installation

```powershell
# Install package if not already installed
$installed = cnl | Select-String "numpy"
if (-not $installed) {
    cniy numpy
}
```

## Alias Reference

| Alias     | Function                        | Description                             |
| --------- | ------------------------------- | --------------------------------------- |
| `cn`      | `Invoke-Conda`                  | Base Conda command                      |
| `cna`     | `Invoke-CondaActivate`          | Activate environment                    |
| `cnab`    | `Invoke-CondaActivateBase`      | Activate base environment               |
| `cnde`    | `Invoke-CondaDeactivate`        | Deactivate environment                  |
| `cnc`     | `Invoke-CondaCreate`            | Create environment                      |
| `cncr`    | `Invoke-CondaCreateName`        | Create named environment                |
| `cncn`    | `Invoke-CondaCreateNameYes`     | Create named environment (auto-confirm) |
| `cncp`    | `Invoke-CondaCreatePath`        | Create environment at path              |
| `cncf`    | `Invoke-CondaCreateFromFile`    | Create from file                        |
| `cnrn`    | `Invoke-CondaRemoveEnvName`     | Remove environment by name              |
| `cnrp`    | `Invoke-CondaRemoveEnvPath`     | Remove environment by path              |
| `cnel`    | `Invoke-CondaEnvList`           | List environments                       |
| `cnee`    | `Invoke-CondaEnvExport`         | Export environment                      |
| `cneu`    | `Invoke-CondaEnvUpdate`         | Update environment                      |
| `cni`     | `Invoke-CondaInstall`           | Install packages                        |
| `cniy`    | `Invoke-CondaInstallYes`        | Install packages (auto-confirm)         |
| `cnr`     | `Invoke-CondaRemove`            | Remove packages                         |
| `cnry`    | `Invoke-CondaRemoveYes`         | Remove packages (auto-confirm)          |
| `cnu`     | `Invoke-CondaUpdate`            | Update packages                         |
| `cnua`    | `Invoke-CondaUpdateAll`         | Update all packages                     |
| `cnuc`    | `Invoke-CondaUpdateConda`       | Update Conda                            |
| `cnl`     | `Invoke-CondaList`              | List packages                           |
| `cnle`    | `Invoke-CondaListExport`        | Export package list                     |
| `cnles`   | `Invoke-CondaListExplicit`      | Create explicit spec file               |
| `cnsr`    | `Invoke-CondaSearch`            | Search packages                         |
| `cnconf`  | `Invoke-CondaConfig`            | Manage configuration                    |
| `cncss`   | `Invoke-CondaConfigShowSources` | Show config sources                     |
| `cnconfg` | `Invoke-CondaConfigGet`         | Get config value                        |
| `cnconfs` | `Invoke-CondaConfigSet`         | Set config value                        |
| `cnconfr` | `Invoke-CondaConfigRemove`      | Remove config value                     |
| `cnconfa` | `Invoke-CondaConfigAdd`         | Add config value                        |
| `cncl`    | `Invoke-CondaClean`             | Clean caches                            |
| `cncla`   | `Invoke-CondaCleanAll`          | Clean all                               |

## Requirements

-   Conda or Miniconda installed and accessible in PATH
-   PowerShell 5.0 or later

## Troubleshooting

### Common Issues

1. **Conda not found**: Ensure Conda is installed and added to your PATH
2. **Permission errors**: Run PowerShell as administrator if needed
3. **Environment activation**: Use `conda init powershell` to set up shell integration

### Debug Information

```powershell
# Get Conda version
Get-CondaVersion

# Get system information
Get-CondaInfo
```

## Contributing

This plugin is part of the MKAbuMattar PowerShell Profile. To contribute:

1. Fork the repository
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

This project is licensed under the MIT License - see the main repository for details.

## Links

-   [GitHub Repository](https://github.com/MKAbuMattar/powershell-profile)
-   [Conda Documentation](https://docs.conda.io/)
-   [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
