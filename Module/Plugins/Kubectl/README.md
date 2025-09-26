# Kubectl Plugin

A comprehensive PowerShell module that provides kubectl CLI shortcuts and utility functions for improved Kubernetes cluster management workflow in PowerShell environments.

## Overview

This plugin converts 100+ common kubectl aliases from zsh/bash to PowerShell functions with full parameter support and comprehensive help documentation. It includes automatic PowerShell completion support and seamlessly integrates Kubernetes cluster management into your PowerShell workflow.

## Features

-   **Complete kubectl Integration**: All essential kubectl commands with short aliases
-   **PowerShell Completion**: Automatic tab completion for kubectl commands and options
-   **Full Parameter Support**: All kubectl arguments and options are supported
-   **Comprehensive Help**: Detailed help documentation for each function
-   **PowerShell Integration**: Native PowerShell function names with familiar aliases
-   **100+ Aliases**: Complete coverage of kubectl operations

## Installation

This plugin is automatically loaded when the PowerShell profile is imported. No additional installation is required.

## Prerequisites

-   **kubectl**: Must be installed and accessible via PATH
-   **Kubernetes Cluster**: Access to a Kubernetes cluster for management operations
-   **PowerShell 5.0+**: Required for completion support

## Available Functions and Aliases

### Core Commands

| Alias  | Function                        | Description                             |
| ------ | ------------------------------- | --------------------------------------- |
| `k`    | `Invoke-Kubectl`                | Base kubectl command wrapper            |
| `kca`  | `Invoke-KubectlAllNamespaces`   | Execute commands against all namespaces |
| `kaf`  | `Invoke-KubectlApplyFile`       | Apply YAML files                        |
| `keti` | `Invoke-KubectlExecInteractive` | Interactive container exec              |

### Configuration Management

| Alias  | Function                             | Description          |
| ------ | ------------------------------------ | -------------------- |
| `kcuc` | `Invoke-KubectlConfigUseContext`     | Use/switch context   |
| `kcsc` | `Invoke-KubectlConfigSetContext`     | Set context          |
| `kcdc` | `Invoke-KubectlConfigDeleteContext`  | Delete context       |
| `kccc` | `Invoke-KubectlConfigCurrentContext` | Show current context |
| `kcgc` | `Invoke-KubectlConfigGetContexts`    | List all contexts    |

### Pod Management

| Alias     | Function                             | Description                    |
| --------- | ------------------------------------ | ------------------------------ |
| `kgp`     | `Invoke-KubectlGetPods`              | List pods                      |
| `kgpl`    | `Invoke-KubectlGetPodsLabels`        | List pods by labels            |
| `kgpn`    | `Invoke-KubectlGetPodsNamespace`     | List pods in namespace         |
| `kgpsl`   | `Invoke-KubectlGetPodsShowLabels`    | List pods with labels shown    |
| `kgpa`    | `Invoke-KubectlGetPodsAllNamespaces` | List pods in all namespaces    |
| `kgpw`    | `Invoke-KubectlGetPodsWatch`         | Watch pods                     |
| `kgpwide` | `Invoke-KubectlGetPodsWide`          | List pods with wide output     |
| `kep`     | `Invoke-KubectlEditPods`             | Edit pods                      |
| `kdp`     | `Invoke-KubectlDescribePods`         | Describe pods                  |
| `kdelp`   | `Invoke-KubectlDeletePods`           | Delete pods                    |
| `kgpall`  | `Invoke-KubectlGetPodsAll`           | List all pods with wide output |

### Service Management

| Alias     | Function                                 | Description                     |
| --------- | ---------------------------------------- | ------------------------------- |
| `kgs`     | `Invoke-KubectlGetServices`              | List services                   |
| `kgsa`    | `Invoke-KubectlGetServicesAllNamespaces` | List services in all namespaces |
| `kgsw`    | `Invoke-KubectlGetServicesWatch`         | Watch services                  |
| `kgswide` | `Invoke-KubectlGetServicesWide`          | List services with wide output  |
| `kes`     | `Invoke-KubectlEditService`              | Edit service                    |
| `kds`     | `Invoke-KubectlDescribeService`          | Describe service                |
| `kdels`   | `Invoke-KubectlDeleteService`            | Delete service                  |

### Deployment Management

| Alias     | Function                                    | Description                        |
| --------- | ------------------------------------------- | ---------------------------------- |
| `kgd`     | `Invoke-KubectlGetDeployments`              | List deployments                   |
| `kgda`    | `Invoke-KubectlGetDeploymentsAllNamespaces` | List deployments in all namespaces |
| `kgdw`    | `Invoke-KubectlGetDeploymentsWatch`         | Watch deployments                  |
| `kgdwide` | `Invoke-KubectlGetDeploymentsWide`          | List deployments with wide output  |
| `ked`     | `Invoke-KubectlEditDeployment`              | Edit deployment                    |
| `kdd`     | `Invoke-KubectlDescribeDeployment`          | Describe deployment                |
| `kdeld`   | `Invoke-KubectlDeleteDeployment`            | Delete deployment                  |
| `ksd`     | `Invoke-KubectlScaleDeployment`             | Scale deployment                   |
| `krsd`    | `Invoke-KubectlRolloutStatusDeployment`     | Rollout status                     |
| `kres`    | `Invoke-KubectlRestartResource`             | Restart resource                   |

### Namespace Management

| Alias    | Function                           | Description           |
| -------- | ---------------------------------- | --------------------- |
| `kgns`   | `Invoke-KubectlGetNamespaces`      | List namespaces       |
| `kens`   | `Invoke-KubectlEditNamespace`      | Edit namespace        |
| `kdns`   | `Invoke-KubectlDescribeNamespace`  | Describe namespace    |
| `kdelns` | `Invoke-KubectlDeleteNamespace`    | Delete namespace      |
| `kcn`    | `Invoke-KubectlConfigSetNamespace` | Set current namespace |

### ConfigMap Management

| Alias    | Function                                   | Description                       |
| -------- | ------------------------------------------ | --------------------------------- |
| `kgcm`   | `Invoke-KubectlGetConfigMaps`              | List configmaps                   |
| `kgcma`  | `Invoke-KubectlGetConfigMapsAllNamespaces` | List configmaps in all namespaces |
| `kecm`   | `Invoke-KubectlEditConfigMap`              | Edit configmap                    |
| `kdcm`   | `Invoke-KubectlDescribeConfigMap`          | Describe configmap                |
| `kdelcm` | `Invoke-KubectlDeleteConfigMap`            | Delete configmap                  |

### Secret Management

| Alias     | Function                                | Description                    |
| --------- | --------------------------------------- | ------------------------------ |
| `kgsec`   | `Invoke-KubectlGetSecrets`              | List secrets                   |
| `kgseca`  | `Invoke-KubectlGetSecretsAllNamespaces` | List secrets in all namespaces |
| `kdsec`   | `Invoke-KubectlDescribeSecret`          | Describe secret                |
| `kdelsec` | `Invoke-KubectlDeleteSecret`            | Delete secret                  |

### Logging and Monitoring

| Alias   | Function                          | Description                  |
| ------- | --------------------------------- | ---------------------------- |
| `kl`    | `Invoke-KubectlLogs`              | View logs                    |
| `kl1h`  | `Invoke-KubectlLogs1Hour`         | View logs from last hour     |
| `kl1m`  | `Invoke-KubectlLogs1Minute`       | View logs from last minute   |
| `kl1s`  | `Invoke-KubectlLogs1Second`       | View logs from last second   |
| `klf`   | `Invoke-KubectlLogsFollow`        | Follow logs                  |
| `klf1h` | `Invoke-KubectlLogsFollow1Hour`   | Follow logs from last hour   |
| `klf1m` | `Invoke-KubectlLogsFollow1Minute` | Follow logs from last minute |
| `klf1s` | `Invoke-KubectlLogsFollow1Second` | Follow logs from last second |

### Utility Commands

| Alias   | Function                            | Description                         |
| ------- | ----------------------------------- | ----------------------------------- |
| `kdel`  | `Invoke-KubectlDelete`              | Delete resources                    |
| `kdelf` | `Invoke-KubectlDeleteFile`          | Delete resources from file          |
| `kge`   | `Invoke-KubectlGetEvents`           | Get events                          |
| `kgew`  | `Invoke-KubectlGetEventsWatch`      | Watch events                        |
| `kpf`   | `Invoke-KubectlPortForward`         | Port forward                        |
| `kcp`   | `Invoke-KubectlCopy`                | Copy files                          |
| `kga`   | `Invoke-KubectlGetAll`              | Get all resources                   |
| `kgaa`  | `Invoke-KubectlGetAllAllNamespaces` | Get all resources in all namespaces |

### Output Formatting

| Alias | Function                   | Description            |
| ----- | -------------------------- | ---------------------- |
| `kj`  | `Invoke-KubectlOutputJson` | Output as JSON with jq |
| `ky`  | `Invoke-KubectlOutputYaml` | Output as YAML         |

## Usage Examples

### Basic Operations

```powershell
# Get cluster info
k cluster-info

# List all resources
kga

# Get all pods
kgp

# Get pods in all namespaces
kgpa

# Watch pods
kgpw
```

### Context Management

```powershell
# List contexts
kcgc

# Switch context
kcuc production

# Get current context
kccc

# Set namespace for current context
kcn kube-system
```

### Pod Operations

```powershell
# Get pods with labels
kgpl app=nginx

# Get detailed pod info
kdp my-pod

# Execute command in pod
keti my-pod -- /bin/bash

# View pod logs
kl my-pod

# Follow pod logs
klf my-pod
```

### Application Deployment

```powershell
# Apply manifests
kaf deployment.yaml

# Get deployments
kgd

# Scale deployment
ksd my-deployment --replicas=5

# Check rollout status
krsd my-deployment

# Restart deployment
kres deployment my-deployment
```

### Service and Networking

```powershell
# List services
kgs

# Port forward to service
kpf svc/my-service 8080:80

# Get ingress
kgi

# Describe service
kds my-service
```

### Configuration Management

```powershell
# List configmaps
kgcm

# Edit configmap
kecm my-config

# List secrets
kgsec

# Describe secret
kdsec my-secret
```

### Troubleshooting

```powershell
# Get events
kge

# Watch events
kgew

# Get logs from last hour
kl1h my-pod

# Follow logs with timestamp filter
klf1m my-pod

# Get detailed resource information
kdp my-pod
kds my-service
kdd my-deployment
```

## Advanced Features

### PowerShell Completion

The plugin automatically initializes kubectl completion for PowerShell:

-   Tab completion for commands, subcommands, and flags
-   Resource name completion for management operations
-   Namespace completion for multi-namespace operations
-   Context completion for configuration commands

### Parameter Passing

All functions accept the same parameters as their kubectl counterparts:

```powershell
# Multiple namespaces
k get pods -n namespace1,namespace2

# Output formats
k get pods -o yaml
k get pods -o json

# Label selectors
kgpl app=nginx,version=latest

# Field selectors
k get pods --field-selector status.phase=Running
```

### Help System Integration

Each function includes comprehensive help documentation:

```powershell
# Get help for any function
Get-Help Invoke-KubectlGetPods -Full
Get-Help kgp -Examples
```

## Common Workflows

### Application Management

```powershell
# Deploy application
kaf app-deployment.yaml
kaf app-service.yaml

# Check status
kgd
krsd my-app

# View logs
klf my-app-pod

# Scale if needed
ksd my-app --replicas=3
```

### Troubleshooting Workflow

```powershell
# Check cluster status
k get nodes
kga

# Look for issues
kge
kdp failing-pod

# Check logs
kl failing-pod
kl1h failing-pod

# Get detailed information
kdp failing-pod
kds related-service
```

### Multi-Environment Management

```powershell
# List available contexts
kcgc

# Switch to development
kcuc dev-cluster
kcn dev-namespace

# Deploy to dev
kaf dev-config.yaml

# Switch to production
kcuc prod-cluster
kcn prod-namespace

# Check production status
kgp
kgs
```

## Requirements

-   **kubectl**: Latest version recommended for full compatibility
-   **Kubernetes Cluster**: With appropriate RBAC permissions
-   **PowerShell 5.0+**: For completion and advanced features

## Compatibility

This plugin works with:

-   kubectl 1.20+ (recommended)
-   All Kubernetes distributions (EKS, GKE, AKS, etc.)
-   Windows PowerShell 5.1
-   PowerShell Core 6.0+
-   Local clusters (minikube, kind, etc.)

## Troubleshooting

### Common Issues

1. **kubectl not found**: Ensure kubectl is installed and in PATH
2. **Cluster connection**: Check cluster access with `k cluster-info`
3. **RBAC permissions**: Verify sufficient permissions for namespace operations
4. **Context issues**: Check current context with `kccc`

### Getting Help

```powershell
# Check kubectl installation
k version

# List available commands
k --help

# Get function help
Get-Help kgp -Full

# Debug cluster connectivity
k cluster-info
k get nodes
```

## Security Considerations

-   Always verify your current context before running commands
-   Use specific namespaces rather than --all-namespaces in production
-   Be cautious with delete operations
-   Implement proper RBAC policies for kubectl access
-   Use read-only contexts for monitoring operations

## Contributing

When adding new kubectl commands:

1. Follow the naming convention: `Invoke-Kubectl[Command]`
2. Add appropriate aliases matching the zsh/bash equivalents
3. Include comprehensive help documentation
4. Test with multiple kubectl versions
5. Update this README with new functions

## Version History

-   **v4.1.0**: Initial PowerShell conversion from zsh/bash aliases
    -   100+ kubectl commands with aliases
    -   PowerShell completion support
    -   Comprehensive help documentation
    -   Full parameter support for all operations
    -   Integration with PowerShell profile ecosystem
