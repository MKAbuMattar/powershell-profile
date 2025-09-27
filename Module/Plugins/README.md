<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Plugins\README.md -->

# Plugins Module

## **Table of Contents**

-   [Module Overview](#module-overview)
-   [Available Plugins](#available-plugins)
    -   [Development Tools](#development-tools)
    -   [Package Managers](#package-managers)
    -   [Infrastructure & DevOps](#infrastructure--devops)
    -   [Cloud & Container Platforms](#cloud--container-platforms)
-   [Quick Start Examples](#quick-start-examples)
-   [Architecture & Design](#architecture--design)
-   [Plugin Development Guidelines](#plugin-development-guidelines)
-   [Troubleshooting](#troubleshooting)
-   [Getting Help](#getting-help)

## **Module Overview**

The Plugins module is a comprehensive collection of specialized PowerShell extensions that integrate popular development tools and workflows directly into your PowerShell environment. This module follows a modular architecture where each plugin provides domain-specific functionality while maintaining consistency with the overall PowerShell profile ecosystem.

Each plugin is designed to enhance productivity by providing intuitive shortcuts, aliases, and advanced functionality for commonly used tools. The plugins seamlessly integrate with your existing PowerShell workflow and provide enhanced capabilities beyond what the standard tools offer.

## **Available Plugins**

### **Development Tools**

#### **[Git Plugin](Git/README.md)**

Comprehensive Git integration with 160+ aliases and shortcuts for all Git operations. Includes automatic repository validation, smart branch management, and enhanced workflow commands.

**Key Features:** Git aliases, repository safety, branch management, version compatibility  
**Location:** `Module/Plugins/Git/`  
**Documentation:** [Git Plugin README](Git/README.md)

#### **[Deno Plugin](Deno/README.md)**

Comprehensive Deno CLI integration with 25+ PowerShell functions and convenient aliases for TypeScript/JavaScript runtime operations. Provides complete development workflow automation with bundling, compilation, caching, formatting, linting, running, testing, project management, and modern Deno development capabilities.

**Key Features:** Deno CLI shortcuts, bundle and compile operations, development workflow automation, runtime permissions, project lifecycle management, interactive REPL, documentation generation, JSR publishing  
**Location:** `Module/Plugins/Deno/`  
**Documentation:** [Deno Plugin README](Deno/README.md)

#### **[Flutter Plugin](Flutter/README.md)**

Comprehensive Flutter CLI integration with 14+ PowerShell functions and convenient aliases for cross-platform mobile, web, and desktop app development. Provides complete development workflow automation with device management, build processes, package management, SDK channel switching, and multi-platform support for Android, iOS, web, Windows, macOS, and Linux development.

**Key Features:** Flutter CLI shortcuts, cross-platform development, build automation (APK/iOS/web/desktop), device management, package management with pub commands, SDK channel management, multiple run modes (debug/profile/release), PowerShell tab completion, hot reload support  
**Location:** `Module/Plugins/Flutter/`  
**Documentation:** [Flutter Plugin README](Flutter/README.md)

#### **[VSCode Plugin](VSCode/README.md)**

Comprehensive VS Code CLI integration with 20+ PowerShell functions and convenient aliases for Visual Studio Code, VS Code Insiders, and VSCodium. Provides automatic VS Code flavour detection, file operations, extension management, and comprehensive VS Code workflow automation with automatic PowerShell completion for modern development.

**Key Features:** Automatic VS Code flavour detection, file and folder operations, window management, extension management, profile and user data customization, debug and logging options, tab completion, performance optimization  
**Location:** `Module/Plugins/VSCode/`  
**Documentation:** [VSCode Plugin README](VSCode/README.md)

#### **[Ruby Plugin](Ruby/README.md)**

Comprehensive Ruby CLI integration with 25+ PowerShell functions and convenient aliases for Ruby development and gem management. Provides Ruby execution, gem operations, file searching, development server, and comprehensive Ruby workflow automation with automatic PowerShell completion for modern Ruby development and scripting.

**Key Features:** Ruby command coverage, gem management (install/uninstall/list/info), Ruby file searching with pattern matching, built-in development server, inline Ruby execution, gem certificate management, cleanup and maintenance tools, cross-platform support  
**Location:** `Module/Plugins/Ruby/`  
**Documentation:** [Ruby Plugin README](Ruby/README.md)

#### **[Rust Plugin](Rust/README.md)**

Comprehensive Cargo and Rustup CLI integration with 70+ PowerShell functions and convenient aliases for Rust development, toolchain management, and systems programming. Provides complete development workflow automation including building, testing, dependency management, cross-compilation, and toolchain operations with automatic PowerShell completion for modern Rust development.

**Key Features:** Cargo CLI shortcuts (49+ aliases), Rustup toolchain management (21+ aliases), build automation (debug/release/cross-platform), dependency management, testing and benchmarking, code quality tools (Clippy, formatting), documentation generation, package publishing, target and component management, development workflow automation  
**Location:** `Module/Plugins/Rust/`  
**Documentation:** [Rust Plugin README](Rust/README.md)

#### **[QRCode Plugin](QRCode/README.md)**

Generate QR codes directly from PowerShell using the qrcode.show API service. Provides functions to create QR codes in both PNG and SVG formats with full PowerShell pipeline integration, interactive multi-line input mode, file export capabilities, and cross-platform support for web development and documentation needs.

**Key Features:** QR code generation (PNG/SVG), PowerShell pipeline support, interactive multi-line input, file export, service connectivity testing, bash-compatible aliases (qrcode/qrsvg), web API integration  
**Location:** `Module/Plugins/QRCode/`  
**Documentation:** [QRCode Plugin README](QRCode/README.md)

### **Package Managers**

#### **[NPM Plugin](NPM/README.md)**

Comprehensive npm CLI integration with 35+ PowerShell functions and convenient aliases for Node.js package management. Provides automatic PowerShell completion, package installation, development workflow automation, security auditing, and complete npm registry management.

**Key Features:** npm CLI shortcuts, PowerShell completion, package management, development scripts, security auditing, configuration management  
**Location:** `Module/Plugins/NPM/`  
**Documentation:** [NPM Plugin README](NPM/README.md)

#### **[Conda Plugin](Conda/README.md)**

Comprehensive Conda CLI integration with 40+ PowerShell functions and convenient aliases for data science environment management, package installation, and Python/R development workflow automation. Provides complete environment lifecycle management, package operations, configuration management, and advanced Conda features with automatic PowerShell completion for modern data science and scientific computing.

**Key Features:** Conda CLI shortcuts, environment management (create/activate/deactivate/remove), package operations with dependency resolution, configuration management, data science workflow automation, environment reproducibility, maintenance tools, tab completion  
**Location:** `Module/Plugins/Conda/`  
**Documentation:** [Conda Plugin README](Conda/README.md)

#### **[PNPM Plugin](PNPM/README.md)**

Comprehensive PNPM CLI integration with 68+ PowerShell functions and convenient aliases for fast, disk space efficient package management. Provides complete workspace support, dependency management, development workflow automation, and advanced PNPM features with automatic PowerShell completion for modern JavaScript/Node.js development.

**Key Features:** PNPM CLI shortcuts, package management with dependency types, store management, patching capabilities, workspace operations, development workflow automation, advanced features like dlx and fetch  
**Location:** `Module/Plugins/PNPM/`  
**Documentation:** [PNPM Plugin README](PNPM/README.md)

#### **[Yarn Plugin](Yarn/README.md)**

Comprehensive Yarn CLI integration with 40+ PowerShell functions and convenient aliases for JavaScript/Node.js package management, workspace handling, and development workflows. Supports both Classic (v1.x) and Berry (v2+) Yarn versions with automatic detection, version-specific functionality, global path management, and complete development workflow automation.

**Key Features:** Yarn CLI shortcuts, dual version support (Classic/Berry), package management, workspace operations, development scripts, global path integration, tab completion, monorepo support  
**Location:** `Module/Plugins/Yarn/`  
**Documentation:** [Yarn Plugin README](Yarn/README.md)

#### **[PIP Plugin](PIP/README.md)**

Comprehensive pip CLI integration with 25+ PowerShell functions and convenient aliases for Python package management. Provides automatic PowerShell completion, GitHub integration, requirements management, bulk operations, and advanced pip functionality for complete Python development workflow.

**Key Features:** pip CLI shortcuts, PowerShell completion, GitHub installations, requirements handling, bulk operations, cache management  
**Location:** `Module/Plugins/PIP/`  
**Documentation:** [PIP Plugin README](PIP/README.md)

#### **[Pipenv Plugin](Pipenv/README.md)**

Comprehensive pipenv CLI integration with 15+ PowerShell functions and convenient aliases for Python virtual environment management. Provides automatic shell activation/deactivation, dependency management, security checking, and complete virtual environment workflow automation with cross-platform support.

**Key Features:** pipenv CLI shortcuts, automatic shell management, dependency locking, security vulnerability checking, requirements generation, project directory navigation  
**Location:** `Module/Plugins/Pipenv/`  
**Documentation:** [Pipenv Plugin README](Pipenv/README.md)

#### **[Poetry Plugin](Poetry/README.md)**

Comprehensive Poetry CLI integration with 30+ PowerShell functions and convenient aliases for modern Python dependency management. Provides complete project lifecycle management from initialization to publishing, advanced dependency resolution, virtual environment handling, and cross-platform support for professional Python development workflows.

**Key Features:** Poetry CLI shortcuts, project lifecycle management, dependency resolution, build and publishing, virtual environment control, configuration management, self-updating capabilities  
**Location:** `Module/Plugins/Poetry/`  
**Documentation:** [Poetry Plugin README](Poetry/README.md)

#### **[UV Plugin](UV/README.md)**

Comprehensive UV (Python package manager) CLI integration with 25+ PowerShell functions and convenient aliases for modern Python dependency management. Provides complete project lifecycle management, virtual environment handling, Python version management, tool execution via uvx, and advanced dependency resolution with cross-platform support for professional Python development workflows.

**Key Features:** UV CLI shortcuts, dependency management, virtual environment handling, Python version management, tool execution (uvx), project lifecycle management, lock file operations, requirements export, comprehensive Python project support  
**Location:** `Module/Plugins/UV/`  
**Documentation:** [UV Plugin README](UV/README.md)

### **Infrastructure & DevOps**

#### **[Terraform Plugin](Terraform/README.md)**

Comprehensive Terraform CLI integration with 20+ PowerShell functions and convenient aliases for Infrastructure as Code management. Provides workspace awareness, prompt integration, state management utilities, and complete IaC workflow automation from initialization to deployment and destruction.

**Key Features:** Terraform CLI shortcuts, workspace detection, prompt integration, state management, plan and apply operations, code formatting and validation, cross-platform IaC support  
**Location:** `Module/Plugins/Terraform/`  
**Documentation:** [Terraform Plugin README](Terraform/README.md)

#### **[Terragrunt Plugin](Terragrunt/README.md)**

Comprehensive Terragrunt CLI integration with 25+ PowerShell functions and convenient aliases for improved DRY Infrastructure as Code workflow. Provides complete dependency orchestration, multi-environment management, state operations, and advanced Terragrunt workflow automation from initialization to deployment with full dependency resolution.

**Key Features:** Terragrunt CLI shortcuts, dependency management, multi-environment support, state management, DRY operations, module orchestration, workspace detection, advanced workflow automation  
**Location:** `Module/Plugins/Terragrunt/`  
**Documentation:** [Terragrunt Plugin README](Terragrunt/README.md)

#### **[Helm Plugin](Helm/README.md)**

Complete Helm integration with PowerShell functions and convenient aliases for Kubernetes package management. Provides automatic PowerShell completion, chart management, release lifecycle operations, and comprehensive workflow automation.

**Key Features:** Helm CLI shortcuts, PowerShell completion, chart operations, release management, repository handling  
**Location:** `Module/Plugins/Helm/`  
**Documentation:** [Helm Plugin README](Helm/README.md)

#### **[Kubectl Plugin](Kubectl/README.md)**

Comprehensive kubectl CLI integration with 100+ PowerShell functions and convenient aliases for Kubernetes cluster management. Provides complete workflow automation with automatic PowerShell completion, resource management, namespace handling, and extensive troubleshooting utilities.

**Key Features:** kubectl CLI shortcuts, PowerShell completion, pod/service/deployment management, logging utilities, configuration management  
**Location:** `Module/Plugins/Kubectl/`  
**Documentation:** [Kubectl Plugin README](Kubectl/README.md)

#### **[Rsync Plugin](Rsync/README.md)**

Comprehensive Rsync CLI integration with PowerShell functions and convenient aliases for efficient file synchronization and backup operations. Provides cross-platform file synchronization, remote backup capabilities, progress monitoring, and complete workflow automation with safety confirmations for destructive operations.

**Key Features:** rsync CLI shortcuts, local and remote synchronization, backup automation with timestamps, progress display and verbose output, path validation and safety confirmations, cross-platform support (Windows/Unix)  
**Location:** `Module/Plugins/Rsync/`  
**Documentation:** [Rsync Plugin README](Rsync/README.md)

### **Cloud & Container Platforms**

#### **[AWS Plugin](AWS/README.md)**

Comprehensive AWS CLI integration with advanced profile management, MFA support, and cross-account role assumption. Provides secure credential management, session persistence, and seamless PowerShell integration for AWS workflows.

**Key Features:** Profile & region management, MFA authentication, role assumption, access key rotation, state persistence  
**Location:** `Module/Plugins/AWS/`  
**Documentation:** [AWS Plugin README](AWS/README.md)

#### **[Docker Plugin](Docker/README.md)**

Complete Docker command integration with 37 PowerShell functions and convenient aliases for all Docker operations. Streamlines container management, image handling, network operations, and monitoring workflows.

**Key Features:** Docker CLI shortcuts, container lifecycle management, image operations, network & volume management  
**Location:** `Module/Plugins/Docker/`  
**Documentation:** [Docker Plugin README](Docker/README.md)

#### **[Docker-Compose Plugin](DockerCompose/README.md)**

Comprehensive Docker Compose integration with 20 PowerShell functions and convenient aliases for multi-container application management. Provides intelligent command detection between Docker Compose v1 and v2, service lifecycle management, and complete workflow automation.

**Key Features:** Docker Compose CLI shortcuts, automatic command detection, service management, log monitoring, build automation  
**Location:** `Module/Plugins/DockerCompose/`  
**Documentation:** [Docker-Compose Plugin README](DockerCompose/README.md)

## **Quick Start Examples**

## **Troubleshooting**

### **Plugin Not Loading**

1. **Check Plugin Structure**: Verify plugin directory exists and contains required files:

    ```powershell
    Get-ChildItem "Module/Plugins/PluginName/" | Select-Object Name
    ```

2. **Validate Manifest File**: Check `.psd1` manifest file syntax:

    ```powershell
    Test-ModuleManifest "Module/Plugins/PluginName/PluginName.psd1"
    ```

3. **Check Module Import**: Verify module can be imported:

    ```powershell
    Import-Module "Module/Plugins/PluginName/PluginName.psd1" -Force -Verbose
    ```

4. **Review Dependencies**: Ensure all required external tools are installed and accessible in PATH

### **Commands Not Working**

1. **Verify Context**: Check you're in the appropriate context:

    - Git repository for Git commands
    - Node.js project for NPM/PNPM/Yarn commands
    - Python project for PIP/Poetry/UV commands
    - AWS profile configured for AWS commands

2. **Check External Tools**: Verify required tools are installed:

    ```powershell
    # Check if tools are available
    Get-Command git, docker, aws, terraform, kubectl -ErrorAction SilentlyContinue

    # Check versions
    git --version
    docker --version
    aws --version
    ```

3. **Review Error Messages**: PowerShell provides detailed error information - read the full error message for specific guidance

4. **Reload Modules**: Try reloading the specific plugin module:
    ```powershell
    Remove-Module PluginName -ErrorAction SilentlyContinue
    Import-Module "Module/Plugins/PluginName/PluginName.psd1" -Force
    ```

### **Performance Issues**

1. **Module Loading Time**: Some plugins with many functions may take time to load initially
2. **Tab Completion**: First-time tab completion might be slow as PowerShell builds completion data
3. **External Tool Dependencies**: Commands will only be as fast as the underlying external tools

### **Common Solutions**

```powershell
# Refresh PowerShell profile
. $PROFILE

# Force reimport specific plugin
Import-Module AWS -Force

# Check what modules are loaded
Get-Module | Where-Object { $_.Path -match "Plugins" }

# Get detailed information about plugin functions
Get-Command -Module PNPM | Get-Help -Name { $_.Name } -Examples
```

### **Getting Help:**

```powershell
# View plugin-specific help
Get-Help Your-PluginFunction -Full

# View all functions in a plugin
Get-Command -Module PluginName

# Check plugin module information
Get-Module PluginName | Format-List

# Examples for specific plugins:
Get-Help Set-AWSProfile -Full           # AWS plugin help
Get-Help Invoke-DockerBuild -Full       # Docker plugin help
Get-Help Invoke-PNPMAdd -Full           # PNPM plugin help
Get-Help Invoke-GitCommit -Full         # Git plugin help
Get-Command -Module AWS                  # All AWS functions
Get-Command -Module PNPM                 # All PNPM functions
Get-Command -Module Git                  # All Git functions

# View profile help system
Show-ProfileHelp -Section 'Plugins'     # Overview of all plugins
Show-ProfileHelp -Section 'PNPM'        # Detailed PNPM documentation
Show-ProfileHelp -Section 'Docker'      # Detailed Docker documentation
Show-ProfileHelp -Section 'Flutter'     # Detailed Flutter documentation
Show-ProfileHelp -Section 'Rsync'       # Detailed Rsync documentation
profile-help -Section 'Git'             # Detailed Git documentation
```

## **Quick Start Examples:**

### **Package Management:**

```powershell
# NPM workflow
npmS express cors helmet                 # Install dependencies
npmD jest nodemon typescript             # Install dev dependencies
npmst                                    # Start development

# PNPM workflow (faster, more efficient)
pa express cors helmet                   # Add dependencies
pad jest nodemon typescript              # Add dev dependencies
pd                                       # Start development

# Yarn workflow
ya add express cors helmet               # Add dependencies
ya add -D jest nodemon typescript        # Add dev dependencies
ys                                       # Start development

# Python workflows
pipi requests flask pytest              # Install with pip
poetry add requests flask pytest        # Add with poetry
uv add requests flask pytest            # Add with uv (fastest)

# Flutter development
fl create my_app && cd my_app            # Create Flutter project
flget                                    # Get dependencies
flrd                                     # Start development with hot reload
flb apk --release                        # Build release APK
```

### **Container Management:**

```powershell
# Docker operations
dps                                      # List running containers
dimg                                     # List images
dbuild -t myapp .                        # Build image
drun -p 3000:3000 myapp                  # Run container

# Docker Compose
dcup -d                                  # Start services in background
dclogs -f                                # Follow logs
dcdown                                   # Stop and remove
```

### **Infrastructure & DevOps:**

```powershell
# Terraform workflow
tf init                                  # Initialize
tf plan                                  # Plan changes
tf apply                                 # Apply changes

# Kubernetes management
k get pods                               # List pods
k logs -f pod-name                       # Follow logs
k describe service my-service            # Describe service

# File synchronization with Rsync
rsync-copy "source/" "backup/"           # Copy files locally
rsync-sync "local/dir/" "user@host:/remote/"  # Sync to remote
rsync-backup "project/" "archive/"       # Create backup with timestamp
rsync-move "old/path/" "new/path/"       # Move files (requires confirmation)

# AWS operations
Set-AWSProfile production                # Switch AWS profile
aws-mfa                                  # Refresh MFA session
```

## **Architecture & Design:**

### **Plugin Structure:**

Each plugin follows a consistent structure:

-   **`.psd1` Manifest**: Defines module metadata, exports, and dependencies
-   **`.psm1` Module**: Contains PowerShell functions and aliases
-   **`README.md`**: Comprehensive documentation with examples
-   **Sub-modules** (if applicable): Specialized functionality like Git Core/Utility

### **Common Features:**

-   **Consistent Aliases**: Short, memorable aliases following tool conventions
-   **Parameter Validation**: Input validation and error handling
-   **PowerShell Completion**: Tab completion for commands and options
-   **Cross-Platform Support**: Works on Windows, Linux, and macOS
-   **Help Documentation**: Comprehensive help system with examples

### **Integration Benefits:**

-   **Unified Experience**: All tools work seamlessly within PowerShell
-   **Enhanced Productivity**: Shortcuts reduce typing and improve workflow speed
-   **Consistent Interface**: Similar patterns across all plugins
-   **Extended Functionality**: Additional features beyond standard tool capabilities

## **Plugin Development Guidelines:**

When contributing new plugins or enhancing existing ones:

1. **Follow Naming Conventions**: Use `Invoke-ToolCommand` pattern for functions
2. **Implement Consistent Aliases**: Short, logical aliases (e.g., `g` for git, `d` for docker)
3. **Add Parameter Validation**: Validate inputs and provide clear error messages
4. **Include Help Documentation**: Comprehensive `.SYNOPSIS`, `.DESCRIPTION`, and `.EXAMPLE` blocks
5. **Test Cross-Platform**: Ensure compatibility across Windows, Linux, and macOS
6. **Document Everything**: Update README files with examples and use cases

[Back to Modules](../../README.md#modules)

## **Contributing**

Contributions are highly encouraged! The plugin system is designed to be extensible and welcoming to new contributors.

### **Ways to Contribute:**

-   **Add New Plugins**: Create plugins for popular development tools not yet covered
-   **Enhance Existing Plugins**: Add new functionality, improve performance, or fix bugs
-   **Improve Documentation**: Update README files, add examples, improve help text
-   **Testing & Quality**: Test plugins across different platforms and environments
-   **Feature Requests**: Suggest new plugin ideas or functionality improvements

### **Plugin Development Process:**

1. **Fork the Repository**: Create your own fork to work on
2. **Follow the Guidelines**: Use the [Plugin Development Guidelines](#plugin-development-guidelines)
3. **Create Comprehensive Tests**: Ensure your plugin works across platforms
4. **Document Thoroughly**: Include detailed README with examples
5. **Submit Pull Request**: Follow the main [Contributing Guidelines](../../README.md#contributing)

### **Plugin Request Ideas:**

Future plugins that would benefit the community:

-   **Azure Plugin**: Azure CLI shortcuts and resource management
-   **Google Cloud Plugin**: GCP CLI integration and resource management
-   **Database Plugin**: Database connection and query shortcuts (SQL Server, PostgreSQL, MySQL)
-   **CI/CD Plugin**: GitHub Actions, Azure DevOps, Jenkins integration
-   **Monitoring Plugin**: Prometheus, Grafana, monitoring tools integration

### **Community & Support:**

-   **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/MKAbuMattar/powershell-profile/issues)
-   **Discussions**: Join discussions about plugin development and features
-   **Documentation**: Help improve documentation for better user experience

## **License**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
