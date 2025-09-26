<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Plugins\README.md -->

# Plugins Module

## **Module Overview:**

The Plugins module is a comprehensive collection of specialized PowerShell extensions that integrate popular development tools and workflows directly into your PowerShell environment. This module follows a modular architecture where each plugin provides domain-specific functionality while maintaining consistency with the overall PowerShell profile ecosystem.

Each plugin is designed to enhance productivity by providing intuitive shortcuts, aliases, and advanced functionality for commonly used tools. The plugins seamlessly integrate with your existing PowerShell workflow and provide enhanced capabilities beyond what the standard tools offer.

## **Available Plugins:**

### **[AWS Plugin](AWS/README.md)**

Comprehensive AWS CLI integration with advanced profile management, MFA support, and cross-account role assumption. Provides secure credential management, session persistence, and seamless PowerShell integration for AWS workflows.

**Key Features:** Profile & region management, MFA authentication, role assumption, access key rotation, state persistence  
**Location:** `Module/Plugins/AWS/`  
**Documentation:** [AWS Plugin README](AWS/README.md)

### **[Deno Plugin](Deno/README.md)**

Comprehensive Deno CLI integration with 25+ PowerShell functions and convenient aliases for TypeScript/JavaScript runtime operations. Provides complete development workflow automation with bundling, compilation, caching, formatting, linting, running, testing, project management, and modern Deno development capabilities.

**Key Features:** Deno CLI shortcuts, bundle and compile operations, development workflow automation, runtime permissions, project lifecycle management, interactive REPL, documentation generation, JSR publishing  
**Location:** `Module/Plugins/Deno/`  
**Documentation:** [Deno Plugin README](Deno/README.md)

### **[Docker Plugin](Docker/README.md)**

Complete Docker command integration with 37 PowerShell functions and convenient aliases for all Docker operations. Streamlines container management, image handling, network operations, and monitoring workflows.

**Key Features:** Docker CLI shortcuts, container lifecycle management, image operations, network & volume management  
**Location:** `Module/Plugins/Docker/`  
**Documentation:** [Docker Plugin README](Docker/README.md)

### **[Docker-Compose Plugin](DockerCompose/README.md)**

Comprehensive Docker Compose integration with 20 PowerShell functions and convenient aliases for multi-container application management. Provides intelligent command detection between Docker Compose v1 and v2, service lifecycle management, and complete workflow automation.

**Key Features:** Docker Compose CLI shortcuts, automatic command detection, service management, log monitoring, build automation  
**Location:** `Module/Plugins/DockerCompose/`  
**Documentation:** [Docker-Compose Plugin README](DockerCompose/README.md)

### **[Git Plugin](Git/README.md)**

Comprehensive Git integration with 160+ aliases and shortcuts for all Git operations. Includes automatic repository validation, smart branch management, and enhanced workflow commands.

**Key Features:** Git aliases, repository safety, branch management, version compatibility  
**Location:** `Module/Plugins/Git/`  
**Documentation:** [Git Plugin README](Git/README.md)

### **[Helm Plugin](Helm/README.md)**

Complete Helm integration with PowerShell functions and convenient aliases for Kubernetes package management. Provides automatic PowerShell completion, chart management, release lifecycle operations, and comprehensive workflow automation.

**Key Features:** Helm CLI shortcuts, PowerShell completion, chart operations, release management, repository handling  
**Location:** `Module/Plugins/Helm/`  
**Documentation:** [Helm Plugin README](Helm/README.md)

### **[Kubectl Plugin](Kubectl/README.md)**

Comprehensive kubectl CLI integration with 100+ PowerShell functions and convenient aliases for Kubernetes cluster management. Provides complete workflow automation with automatic PowerShell completion, resource management, namespace handling, and extensive troubleshooting utilities.

**Key Features:** kubectl CLI shortcuts, PowerShell completion, pod/service/deployment management, logging utilities, configuration management  
**Location:** `Module/Plugins/Kubectl/`  
**Documentation:** [Kubectl Plugin README](Kubectl/README.md)

### **[NPM Plugin](NPM/README.md)**

Comprehensive npm CLI integration with 35+ PowerShell functions and convenient aliases for Node.js package management. Provides automatic PowerShell completion, package installation, development workflow automation, security auditing, and complete npm registry management.

**Key Features:** npm CLI shortcuts, PowerShell completion, package management, development scripts, security auditing, configuration management  
**Location:** `Module/Plugins/NPM/`  
**Documentation:** [NPM Plugin README](NPM/README.md)

### **[PIP Plugin](PIP/README.md)**

Comprehensive pip CLI integration with 25+ PowerShell functions and convenient aliases for Python package management. Provides automatic PowerShell completion, GitHub integration, requirements management, bulk operations, and advanced pip functionality for complete Python development workflow.

**Key Features:** pip CLI shortcuts, PowerShell completion, GitHub installations, requirements handling, bulk operations, cache management  
**Location:** `Module/Plugins/PIP/`  
**Documentation:** [PIP Plugin README](PIP/README.md)

### **[Pipenv Plugin](Pipenv/README.md)**

Comprehensive pipenv CLI integration with 15+ PowerShell functions and convenient aliases for Python virtual environment management. Provides automatic shell activation/deactivation, dependency management, security checking, and complete virtual environment workflow automation with cross-platform support.

**Key Features:** pipenv CLI shortcuts, automatic shell management, dependency locking, security vulnerability checking, requirements generation, project directory navigation  
**Location:** `Module/Plugins/Pipenv/`  
**Documentation:** [Pipenv Plugin README](Pipenv/README.md)

### **[Poetry Plugin](Poetry/README.md)**

Comprehensive Poetry CLI integration with 30+ PowerShell functions and convenient aliases for modern Python dependency management. Provides complete project lifecycle management from initialization to publishing, advanced dependency resolution, virtual environment handling, and cross-platform support for professional Python development workflows.

**Key Features:** Poetry CLI shortcuts, project lifecycle management, dependency resolution, build and publishing, virtual environment control, configuration management, self-updating capabilities  
**Location:** `Module/Plugins/Poetry/`  
**Documentation:** [Poetry Plugin README](Poetry/README.md)

### **[Terraform Plugin](Terraform/README.md)**

Comprehensive Terraform CLI integration with 20+ PowerShell functions and convenient aliases for Infrastructure as Code management. Provides workspace awareness, prompt integration, state management utilities, and complete IaC workflow automation from initialization to deployment and destruction.

**Key Features:** Terraform CLI shortcuts, workspace detection, prompt integration, state management, plan and apply operations, code formatting and validation, cross-platform IaC support  
**Location:** `Module/Plugins/Terraform/`  
**Documentation:** [Terraform Plugin README](Terraform/README.md)

### **[Terragrunt Plugin](Terragrunt/README.md)**

Comprehensive Terragrunt CLI integration with 25+ PowerShell functions and convenient aliases for improved DRY Infrastructure as Code workflow. Provides complete dependency orchestration, multi-environment management, state operations, and advanced Terragrunt workflow automation from initialization to deployment with full dependency resolution.

**Key Features:** Terragrunt CLI shortcuts, dependency management, multi-environment support, state management, DRY operations, module orchestration, workspace detection, advanced workflow automation  
**Location:** `Module/Plugins/Terragrunt/`  
**Documentation:** [Terragrunt Plugin README](Terragrunt/README.md)

### **[UV Plugin](UV/README.md)**

Comprehensive UV (Python package manager) CLI integration with 25+ PowerShell functions and convenient aliases for modern Python dependency management. Provides complete project lifecycle management, virtual environment handling, Python version management, tool execution via uvx, and advanced dependency resolution with cross-platform support for professional Python development workflows.

**Key Features:** UV CLI shortcuts, dependency management, virtual environment handling, Python version management, tool execution (uvx), project lifecycle management, lock file operations, requirements export, comprehensive Python project support  
**Location:** `Module/Plugins/UV/`  
**Documentation:** [UV Plugin README](UV/README.md)

### **[Yarn Plugin](Yarn/README.md)**

Comprehensive Yarn CLI integration with 40+ PowerShell functions and convenient aliases for JavaScript/Node.js package management, workspace handling, and development workflows. Supports both Classic (v1.x) and Berry (v2+) Yarn versions with automatic detection, version-specific functionality, global path management, and complete development workflow automation.

**Key Features:** Yarn CLI shortcuts, dual version support (Classic/Berry), package management, workspace operations, development scripts, global path integration, tab completion, monorepo support  
**Location:** `Module/Plugins/Yarn/`  
**Documentation:** [Yarn Plugin README](Yarn/README.md)

## **Troubleshooting:**

### **Plugin Not Loading:**

1. Check if plugin directory exists and contains required files
2. Verify `.psd1` manifest file is properly formatted
3. Check for syntax errors in `.psm1` module file
4. Ensure all dependencies are available

### **Commands Not Working:**

1. Verify you're in the appropriate context (e.g., Git repository for Git commands, AWS profile configured for AWS commands)
2. Check if required external tools are installed and in PATH (Git, Docker, AWS CLI)
3. Review error messages for specific guidance
4. Try reloading the plugin module

### **Getting Help:**

```powershell
# View plugin-specific help
Get-Help Your-PluginFunction -Full

# View all functions in a plugin
Get-Command -Module PluginName

# Check plugin module information
Get-Module PluginName | Format-List

# Examples for specific plugins:
Get-Help Set-AWSProfile -Full      # AWS plugin help
Get-Help Invoke-DockerBuild -Full  # Docker plugin help
Get-Command -Module AWS             # All AWS functions
```

## **Future Plugin Ideas:**

The plugin system is designed to be extensible. Future plugins could include:

-   **Kubernetes Plugin**: Kubernetes cluster management commands
-   **Azure Plugin**: Azure CLI shortcuts and resource management
-   **NPM Plugin**: Node.js and NPM workflow enhancements
-   **Python Plugin**: Python development and virtual environment management
-   **Database Plugin**: Database connection and query shortcuts
-   **CI/CD Plugin**: Continuous integration and deployment helpers

[Back to Modules](../../README.md#modules)

**Contribution:**
Contributions are highly encouraged! Whether you want to:

-   Add new plugins for popular development tools
-   Enhance existing plugins with new functionality
-   Improve documentation and examples
-   Fix bugs or optimize performance
-   Suggest new plugin ideas

Please follow the plugin development guidelines and adhere to the main [Contributing Guidelines](../../README.md#contributing).

## **License:**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
