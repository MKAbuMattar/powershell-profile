# GCP Plugin

Comprehensive Google Cloud Platform CLI integration plugin for PowerShell, providing 70+ commands and aliases for efficient GCP management.

## Features

-   **Complete gcloud CLI integration** with PowerShell functions and aliases
-   **Comprehensive coverage** of all major GCP services
-   **Automatic availability detection** - only loads when gcloud is installed
-   **Cross-platform support** for Windows, macOS, and Linux
-   **PowerShell best practices** with proper parameter handling and error management

## Prerequisites

-   [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured
-   PowerShell 5.1 or later
-   Valid Google Cloud project and authentication

## Installation

The GCP plugin is automatically loaded when the main PowerShell profile is imported, provided that the Google Cloud SDK is installed and available in your system PATH.

To verify gcloud installation:

```powershell
Test-GCloudInstalled
```

## Quick Start

```powershell
# Initialize gcloud (first time setup)
gci                             # gcloud init

# Set default project
gccsp my-project-id            # gcloud config set project

# List configurations
gccl                           # gcloud config list

# Authenticate
gcal                           # gcloud auth login

# Create a VM instance
gccc my-instance --zone us-central1-a --machine-type e2-micro

# List instances
gcpil                          # gcloud compute instances list
```

## Command Categories

### Core Commands

| Alias          | Function                  | Description                        |
| -------------- | ------------------------- | ---------------------------------- |
| `gcloud`, `gc` | `Invoke-GCloud`           | Base gcloud command wrapper        |
| `gci`          | `Initialize-GCloudTool`   | Initialize and configure gcloud    |
| `gcinf`        | `Get-GCloudInfo`          | Display gcloud environment details |
| `gcv`          | `Get-GCloudVersion`       | Show version and components        |
| `gccu`         | `Update-GCloudComponents` | Update Cloud SDK                   |

### Configuration Management

| Alias   | Function                       | Description                    |
| ------- | ------------------------------ | ------------------------------ |
| `gccsp` | `Set-GCloudProject`            | Set default project            |
| `gccca` | `Activate-GCloudConfiguration` | Switch configuration           |
| `gcccc` | `New-GCloudConfiguration`      | Create new configuration       |
| `gcccl` | `Get-GCloudConfigurations`     | List all configurations        |
| `gccgv` | `Get-GCloudConfigValue`        | Get property value             |
| `gccl`  | `Get-GCloudConfigList`         | List current config properties |
| `gccs`  | `Set-GCloudConfig`             | Set configuration property     |
| `gcsa`  | `Set-GCloudAccount`            | Set active account             |

### Authentication

| Alias    | Function                      | Description                      |
| -------- | ----------------------------- | -------------------------------- |
| `gcal`   | `Invoke-GCloudAuthLogin`      | Authenticate with Google account |
| `gcapat` | `Get-GCloudAccessToken`       | Get current access token         |
| `gcar`   | `Revoke-GCloudAuth`           | Revoke credentials               |
| `gcaasa` | `Enable-GCloudServiceAccount` | Activate service account         |
| `gcacd`  | `Enable-GCloudDockerAuth`     | Configure Docker authentication  |

### Identity & Access Management (IAM)

| Alias    | Function                         | Description               |
| -------- | -------------------------------- | ------------------------- |
| `gciamk` | `Get-GCloudServiceAccountKeys`   | List service account keys |
| `gciaml` | `Get-GCloudGrantableRoles`       | List grantable roles      |
| `gciamp` | `Add-GCloudIAMPolicyBinding`     | Add IAM policy binding    |
| `gciamr` | `New-GCloudIAMRole`              | Create custom role        |
| `gciams` | `Set-GCloudServiceAccountPolicy` | Set IAM policy            |
| `gciamv` | `New-GCloudServiceAccount`       | Create service account    |

### Project Management

| Alias  | Function                       | Description                 |
| ------ | ------------------------------ | --------------------------- |
| `gcpa` | `Add-GCloudProjectIAMBinding`  | Add project IAM binding     |
| `gcpd` | `Get-GCloudProjectDescription` | Describe project            |
| `gcp`  | `Invoke-GCloudProjects`        | Project management commands |

### Container & Kubernetes (GKE)

| Alias          | Function                  | Description               |
| -------------- | ------------------------- | ------------------------- |
| `gkec`         | `New-GKECluster`          | Create GKE cluster        |
| `gcccg`        | `Get-GKECredentials`      | Get cluster credentials   |
| `gkecl`, `gcs` | `Get-GKEClusters`         | List GKE clusters         |
| `gccil`        | `Get-GContainerImageTags` | List container image tags |

### Compute Engine

| Alias            | Function                          | Description           |
| ---------------- | --------------------------------- | --------------------- |
| `gccc`           | `New-GComputeInstance`            | Create VM instance    |
| `gcpil`          | `Get-GComputeInstances`           | List VM instances     |
| `gcpid`          | `Get-GComputeInstanceDescription` | Describe VM instance  |
| `gcpup`          | `Start-GComputeInstance`          | Start VM instance     |
| `gcpdown`        | `Stop-GComputeInstance`           | Stop VM instance      |
| `gcprm`          | `Remove-GComputeInstance`         | Delete VM instance    |
| `gcpssh`, `gcco` | `Connect-GComputeSSH`             | SSH to VM instance    |
| `gcpc`           | `Copy-GComputeFiles`              | Copy files to/from VM |
| `gcpds`          | `New-GComputeSnapshot`            | Create disk snapshot  |
| `gcpsk`          | `Remove-GComputeSnapshot`         | Delete snapshot       |
| `gcpzl`          | `Get-GComputeZones`               | List compute zones    |
| `gcca`           | `Get-GComputeAddresses`           | List IP addresses     |
| `gcpha`          | `Get-GComputeAddressDescription`  | Describe IP address   |

### App Engine

| Alias          | Function                 | Description           |
| -------------- | ------------------------ | --------------------- |
| `gcapb`        | `Open-GAppEngine`        | Open app in browser   |
| `gcapc`        | `New-GAppEngine`         | Create App Engine app |
| `gcapd`, `gcu` | `Deploy-GAppEngine`      | Deploy application    |
| `gcapl`        | `Get-GAppEngineLogs`     | View app logs         |
| `gcapv`        | `Get-GAppEngineVersions` | List app versions     |

### Additional Services

| Alias    | Function                    | Description            |
| -------- | --------------------------- | ---------------------- |
| `gckmsd` | `Invoke-GCloudKMSDecrypt`   | Decrypt with Cloud KMS |
| `gclll`  | `Get-GCloudLogs`            | List project logs      |
| `gcsqlb` | `Get-GSQLBackupDescription` | Describe SQL backup    |
| `gcsqle` | `Export-GSQLData`           | Export SQL data        |

### Service Shortcuts

| Alias  | Function                       | Description                 |
| ------ | ------------------------------ | --------------------------- |
| `gca`  | `Invoke-GCloudAuth`            | Auth commands               |
| `gcb`  | `Invoke-GCloudBeta`            | Beta commands               |
| `gcdb` | `Invoke-GCloudDatastore`       | Datastore commands          |
| `gcdp` | `Invoke-GCloudDataproc`        | Dataproc commands           |
| `gce`  | `Invoke-GCloudEndpoints`       | Endpoints commands          |
| `gcem` | `Invoke-GCloudEventarc`        | Eventarc commands           |
| `gcf`  | `Invoke-GCloudFunctions`       | Cloud Functions commands    |
| `gcic` | `Invoke-GCloudIAM`             | IAM commands                |
| `gcir` | `Invoke-GCloudIoT`             | IoT Core commands           |
| `gcki` | `Invoke-GCloudKMS`             | KMS commands                |
| `gcla` | `Invoke-GCloudLogging`         | Logging commands            |
| `gcma` | `Invoke-GCloudMonitoring`      | Monitoring commands         |
| `gcn`  | `Invoke-GCloudNetworks`        | Network commands            |
| `gcps` | `Invoke-GCloudPubSub`          | Pub/Sub commands            |
| `gcr`  | `Remove-GContainerImage`       | Delete container images     |
| `gcrm` | `Invoke-GCloudResourceManager` | Resource Manager commands   |
| `gcro` | `Invoke-GCloudRun`             | Cloud Run commands          |
| `gcsc` | `Invoke-GCloudSource`          | Source Repository commands  |
| `gcso` | `Invoke-GCloudOrganizations`   | Organization commands       |
| `gcsq` | `Invoke-GCloudSQL`             | Cloud SQL commands          |
| `gcss` | `Invoke-GCloudStorage`         | Cloud Storage commands      |
| `gcst` | `Invoke-GCloudServices`        | Service management commands |
| `gct`  | `Invoke-GCloudTasks`           | Cloud Tasks commands        |

### Utility Functions

| Alias | Function                         | Description                     |
| ----- | -------------------------------- | ------------------------------- |
| `gcd` | `Set-GCloudProjectFromDirectory` | Set project from directory name |
| -     | `Get-GCloudCurrentProject`       | Get current project ID          |
| -     | `Test-GCloudInstalled`           | Check if gcloud is installed    |

## Usage Examples

### Initial Setup

```powershell
# Initialize gcloud for first time
gci

# Set up authentication
gcal

# Set default project
gccsp "my-project-id"

# Set default region and zone
gccs compute/region us-central1
gccs compute/zone us-central1-a
```

### Configuration Management

```powershell
# Create development configuration
gcccc dev-config

# Switch to development configuration
gccca dev-config

# Set different project for development
gccsp "my-dev-project"

# List all configurations
gcccl

# View current configuration
gccl
```

### Compute Engine Workflow

```powershell
# Create a new VM instance
gccc my-vm --machine-type e2-medium --image-family ubuntu-2004-lts --image-project ubuntu-os-cloud

# List all instances
gcpil

# Get instance details
gcpid my-vm

# Start/stop instance
gcpup my-vm
gcpdown my-vm

# SSH into instance
gcpssh my-vm

# Copy files to instance
gcpc ./local-file my-vm:~/remote-file

# Create snapshot
gcpds my-vm-disk my-snapshot

# Delete instance
gcprm my-vm
```

### Container/GKE Workflow

```powershell
# Create GKE cluster
gkec my-cluster --num-nodes 3 --zone us-central1-a

# Get cluster credentials for kubectl
gcccg my-cluster --zone us-central1-a

# List clusters
gkecl

# List container images
gccil gcr.io/my-project/my-app
```

### App Engine Workflow

```powershell
# Create App Engine application
gcapc --region us-central

# Deploy application
gcapd

# View application in browser
gcapb

# View logs
gcapl --service default --version 1

# List all versions
gcapv
```

### IAM Management

```powershell
# Create service account
gciamv my-service-account --display-name "My Service Account" --description "Service account for my app"

# Create custom role
gciamr my-custom-role --title "My Custom Role" --description "Custom role for my app" --permissions compute.instances.get,compute.instances.list

# Add IAM policy binding
gcpa my-project --member serviceAccount:my-service-account@my-project.iam.gserviceaccount.com --role roles/viewer
```

### Project Utilities

```powershell
# Set project based on current directory name
gcd

# Get current project
Get-GCloudCurrentProject

# Describe project
gcpd my-project
```

## Advanced Usage

### Service Account Authentication

```powershell
# Download and use service account key
gcaasa path/to/service-account-key.json

# Configure Docker authentication
gcacd
```

### Multi-Configuration Management

```powershell
# Create different configurations for different environments
gcccc production
gccsp "my-prod-project"
gcsa prod-user@company.com

gcccc staging
gccsp "my-staging-project"
gcsa staging-user@company.com

# Switch between configurations
gccca production
gccca staging
```

### Batch Operations

```powershell
# List and operate on multiple instances
$instances = gcpil --format="value(name)" --filter="zone:us-central1-a"
$instances | ForEach-Object { gcpup $_ }
```

## Troubleshooting

### Common Issues

1. **gcloud not found**: Ensure Google Cloud SDK is installed and in PATH
2. **Authentication errors**: Run `gcal` to authenticate
3. **Project not set**: Use `gccsp project-id` to set default project
4. **Permission denied**: Check IAM permissions for your account

### Verification Commands

```powershell
# Test gcloud installation
Test-GCloudInstalled

# Check gcloud info
gcinf

# Verify authentication
gcal --list

# Check current configuration
gccl
```
