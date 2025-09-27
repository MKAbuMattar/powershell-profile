# Terraform Plugin

A comprehensive PowerShell module that provides convenient aliases and functions for Infrastructure as Code management using Terraform. This plugin converts all common zsh/bash Terraform shortcuts to PowerShell equivalents with enhanced functionality, workspace awareness, and prompt integration.

## Overview

The Terraform plugin streamlines Infrastructure as Code workflows by providing:

-   **20+ optimized Terraform aliases** for all Terraform operations
-   **Workspace awareness** and prompt integration
-   **Tab completion** for Terraform commands and options
-   **State management utilities** for advanced operations
-   **Cross-platform compatibility** (Windows, Linux, macOS)

## Prerequisites

-   **PowerShell 5.1+** or **PowerShell Core 7.0+**
-   **Terraform** installed and accessible in PATH

### Installing Terraform

```powershell
# Windows (Chocolatey)
choco install terraform

# Windows (Scoop)
scoop install terraform

# macOS (Homebrew)
brew install terraform

# Linux (varies by distribution)
# Download from HashiCorp releases
$version = "1.6.0"
$os = "linux" # or "windows", "darwin"
$arch = "amd64" # or "386", "arm", "arm64"
Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${os}_${arch}.zip" -OutFile "terraform.zip"
Expand-Archive terraform.zip
Move-Item terraform/terraform /usr/local/bin/
```

## Installation

The Terraform plugin is automatically loaded as part of the PowerShell profile system. No additional installation steps required.

## Features

### Core Terraform Aliases

| Alias | Full Command       | Description                    |
| ----- | ------------------ | ------------------------------ |
| `tf`  | `Invoke-Terraform` | Base Terraform command wrapper |

### Initialization Aliases

| Alias   | Full Command                             | Description                    |
| ------- | ---------------------------------------- | ------------------------------ |
| `tfi`   | `Invoke-TerraformInit`                   | Initialize working directory   |
| `tfir`  | `Invoke-TerraformInitReconfigure`        | Init with reconfiguration      |
| `tfiu`  | `Invoke-TerraformInitUpgrade`            | Init with provider upgrade     |
| `tfiur` | `Invoke-TerraformInitUpgradeReconfigure` | Init with upgrade and reconfig |

### Planning and Application Aliases

| Alias  | Full Command                         | Description                |
| ------ | ------------------------------------ | -------------------------- |
| `tfp`  | `Invoke-TerraformPlan`               | Create execution plan      |
| `tfa`  | `Invoke-TerraformApply`              | Apply configuration        |
| `tfaa` | `Invoke-TerraformApplyAutoApprove`   | Apply with auto-approval   |
| `tfd`  | `Invoke-TerraformDestroy`            | Destroy infrastructure     |
| `tfd!` | `Invoke-TerraformDestroyAutoApprove` | Destroy with auto-approval |

### Code Management Aliases

| Alias  | Full Command                      | Description                |
| ------ | --------------------------------- | -------------------------- |
| `tff`  | `Invoke-TerraformFormat`          | Format configuration files |
| `tffr` | `Invoke-TerraformFormatRecursive` | Format files recursively   |
| `tfv`  | `Invoke-TerraformValidate`        | Validate configuration     |
| `tft`  | `Invoke-TerraformTest`            | Execute tests              |

### State and Output Aliases

| Alias  | Full Command             | Description            |
| ------ | ------------------------ | ---------------------- |
| `tfs`  | `Invoke-TerraformState`  | Manage Terraform state |
| `tfo`  | `Invoke-TerraformOutput` | Read output values     |
| `tfsh` | `Invoke-TerraformShow`   | Show state or plan     |

### Interactive Aliases

| Alias | Full Command              | Description                |
| ----- | ------------------------- | -------------------------- |
| `tfc` | `Invoke-TerraformConsole` | Launch interactive console |

## Usage Examples

### Project Initialization and Setup

```powershell
# Initialize new Terraform project
mkdir my-terraform-project
cd my-terraform-project

# Create main.tf file (example)
@"
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-example"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}
"@ | Out-File -FilePath "main.tf" -Encoding utf8

# Initialize Terraform
tfi
terraform init

# Initialize with backend reconfiguration
tfir
terraform init -reconfigure

# Initialize with provider upgrade
tfiu
terraform init -upgrade

# Initialize with upgrade and reconfiguration
tfiur
terraform init -upgrade -reconfigure
```

### Planning and Application

```powershell
# Create execution plan
tfp
terraform plan

# Create plan with output file
tfp -out=tfplan
terraform plan -out=tfplan

# Apply configuration
tfa
terraform apply

# Apply with auto-approval
tfaa
terraform apply -auto-approve

# Apply saved plan
tfa tfplan
terraform apply tfplan

# Apply with variable
tfa -var="instance_type=t3.small"
terraform apply -var="instance_type=t3.small"
```

### Code Management

```powershell
# Format configuration files
tff
terraform fmt

# Format with diff display
tff -diff
terraform fmt -diff

# Format recursively
tffr
terraform fmt -recursive

# Validate configuration
tfv
terraform validate

# Validate with JSON output
tfv -json
terraform validate -json

# Run tests
tft
terraform test

# Run tests with verbose output
tft -verbose
terraform test -verbose
```

### State Management

```powershell
# List resources in state
tfs list
terraform state list

# Show specific resource
tfs show aws_instance.example
terraform state show aws_instance.example

# Move resource in state
tfs mv aws_instance.old aws_instance.new
terraform state mv aws_instance.old aws_instance.new

# Remove resource from state
tfs rm aws_instance.example
terraform state rm aws_instance.example

# Import existing resource
tf import aws_instance.example i-1234567890abcdef0
terraform import aws_instance.example i-1234567890abcdef0

# Pull remote state
tfs pull
terraform state pull

# Push local state
tfs push
terraform state push
```

### Output Management

```powershell
# Show all outputs
tfo
terraform output

# Show specific output
tfo instance_id
terraform output instance_id

# Show output in JSON format
tfo -json
terraform output -json

# Show raw output value
tfo -raw instance_id
terraform output -raw instance_id
```

### Infrastructure Destruction

```powershell
# Destroy infrastructure with confirmation
tfd
terraform destroy

# Destroy with auto-approval (dangerous!)
tfd!
terraform destroy -auto-approve

# Destroy specific resource
tfd -target=aws_instance.example
terraform destroy -target=aws_instance.example

# Destroy with variable
tfd -var="instance_type=t3.small"
terraform destroy -var="instance_type=t3.small"
```

### State and Plan Inspection

```powershell
# Show current state
tfsh
terraform show

# Show saved plan
tfsh tfplan
terraform show tfplan

# Show state in JSON format
tfsh -json
terraform show -json

# Show plan in JSON format
tfsh -json tfplan
terraform show -json tfplan
```

### Interactive Console

```powershell
# Launch interactive console
tfc
terraform console

# Use console with specific state
tfc -state=terraform.tfstate
terraform console -state=terraform.tfstate

# Example console usage:
# > var.instance_type
# > aws_instance.example.id
# > length(var.availability_zones)
```

## Advanced Features

### Workspace Awareness

The plugin includes intelligent workspace detection for prompt integration:

```powershell
# Get current workspace
$workspace = Get-TerraformWorkspace
# Returns: "production", "staging", etc.

# Get workspace info for prompt
$promptInfo = Get-TerraformPromptInfo
# Returns: "[production]" or empty string

# Get version info for prompt
$versionInfo = Get-TerraformVersionPromptInfo
# Returns: "[v1.6.0]" or empty string

# Custom prompt integration
function prompt {
    $location = Get-Location
    $workspace = Get-TerraformPromptInfo
    $version = Get-TerraformVersionPromptInfo

    Write-Host "PS $location" -NoNewline
    if ($workspace) {
        Write-Host " $workspace" -ForegroundColor Yellow -NoNewline
    }
    if ($version) {
        Write-Host " $version" -ForegroundColor Green -NoNewline
    }
    return "> "
}
```

### Tab Completion

The plugin provides intelligent tab completion for:

```powershell
# Terraform commands
terraform <TAB>
# Shows: apply, console, destroy, fmt, init, plan, state, etc.

# State subcommands
terraform state <TAB>
# Shows: list, show, mv, rm, pull, push, etc.

# Common options
terraform plan -<TAB>
# Shows: -out, -var, -var-file, -target, etc.
```

### Error Handling

All functions include comprehensive error handling:

-   **Availability checks**: Verifies Terraform installation before execution
-   **Graceful failures**: Displays helpful error messages
-   **Verbose output**: Optional detailed logging with `-Verbose`

### Cross-Platform Support

The plugin works seamlessly across platforms:

-   **Windows**: PowerShell 5.1+ and PowerShell Core
-   **Linux**: PowerShell Core with proper PATH configuration
-   **macOS**: PowerShell Core with Homebrew or manual installation

## Configuration

### Environment Variables

The plugin respects standard Terraform environment variables:

```powershell
# Set Terraform data directory
$env:TF_DATA_DIR = ".terraform"

# Set log level
$env:TF_LOG = "INFO"  # or "DEBUG", "WARN", "ERROR"

# Set log file path
$env:TF_LOG_PATH = "terraform.log"

# Set variable values
$env:TF_VAR_instance_type = "t3.micro"
$env:TF_VAR_region = "us-west-2"

# Set workspace
$env:TF_WORKSPACE = "production"

# Provider-specific variables
$env:AWS_PROFILE = "default"
$env:AWS_REGION = "us-west-2"
$env:GOOGLE_CREDENTIALS = "path/to/service-account.json"
$env:ARM_SUBSCRIPTION_ID = "your-azure-subscription-id"
```

### Terraform Configuration

Common Terraform configuration patterns:

```hcl
# terraform/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# terraform/variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# terraform/outputs.tf
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}
```

## Troubleshooting

### Common Issues

**Terraform command not found:**

```powershell
# Check if Terraform is installed
Get-Command terraform

# Install Terraform
choco install terraform
# or download from HashiCorp releases

# Add to PATH (Windows)
$env:PATH += ";C:\terraform"
```

**Initialization issues:**

```powershell
# Reconfigure backend
tfir

# Upgrade providers
tfiu

# Both upgrade and reconfigure
tfiur

# Clear .terraform directory
Remove-Item -Recurse -Force .terraform
tfi
```

**State lock issues:**

```powershell
# Force unlock (use carefully)
tf force-unlock LOCK_ID

# Check lock status
tfs list
```

**Provider issues:**

```powershell
# Update provider versions
tfiu

# Clear provider cache
Remove-Item -Recurse -Force .terraform/providers
tfi
```

### Debug Information

Enable verbose output for troubleshooting:

```powershell
# Enable verbose output for all Terraform functions
$VerbosePreference = "Continue"

# Enable Terraform debug logging
$env:TF_LOG = "DEBUG"

# Run commands with verbose output
tfp -Verbose
```

### Performance Tips

1. **Use remote state**: Configure S3, Azure, or Google Cloud backends
2. **Enable parallelism**: Use `-parallelism=10` for faster operations
3. **Use targeted operations**: `-target` specific resources when needed
4. **Plan before apply**: Always run `tfp` before `tfa`

## Integration

### VS Code Integration

The plugin works well with VS Code and Terraform extensions:

```json
// .vscode/settings.json
{
    "terraform.languageServer.enable": true,
    "terraform.validation.enableEnhancedValidation": true,
    "terraform.format.enable": true,
    "terraform.codelens.referenceCount": true,
    "files.associations": {
        "*.tf": "terraform",
        "*.tfvars": "terraform"
    }
}

// .vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "terraform-plan",
            "type": "shell",
            "command": "tfp",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "terraform-apply",
            "type": "shell",
            "command": "tfa",
            "group": "build"
        }
    ]
}
```

### Git Integration

Recommended `.gitignore` entries:

```gitignore
# Terraform files
*.tfstate
*.tfstate.*
*.tfplan
.terraform/
.terraform.lock.hcl

# Crash log files
crash.log

# Exclude all .tfvars files (may contain sensitive data)
*.tfvars
*.tfvars.json

# Override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# CLI configuration files
.terraformrc
terraform.rc
```

### CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Terraform

on:
    push:
        branches: [main]
    pull_request:
        branches: [main]

jobs:
    terraform:
        name: Terraform
        runs-on: ubuntu-latest

        steps:
            - name: Checkout
              uses: actions/checkout@v3

            - name: Setup Terraform
              uses: hashicorp/setup-terraform@v2
              with:
                  terraform_version: 1.6.0

            - name: Terraform Format
              run: terraform fmt -check

            - name: Terraform Init
              run: terraform init

            - name: Terraform Validate
              run: terraform validate

            - name: Terraform Plan
              run: terraform plan -no-color
              continue-on-error: true

            - name: Terraform Apply
              if: github.ref == 'refs/heads/main' && github.event_name == 'push'
              run: terraform apply -auto-approve
```

## Examples and Workflows

### AWS Infrastructure Example

```powershell
# Complete AWS infrastructure workflow
mkdir aws-infrastructure
cd aws-infrastructure

# Create main configuration
@"
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "web-server"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

output "instance_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
"@ | Out-File -FilePath "main.tf" -Encoding utf8

# Initialize and deploy
tfi                    # Initialize Terraform
tff                    # Format code
tfv                    # Validate configuration
tfp                    # Create plan
tfa                    # Apply changes

# Check outputs
tfo                    # Show all outputs
tfo instance_public_ip # Show specific output

# Manage state
tfs list               # List resources
tfs show aws_instance.web  # Show resource details

# Destroy when done
tfp -destroy           # Plan destruction
tfd                    # Destroy infrastructure
```

### Multi-Environment Workflow

```powershell
# Setup for multiple environments
mkdir terraform-multi-env
cd terraform-multi-env

# Create environment-specific tfvars files
@"
aws_region = "us-west-2"
instance_type = "t3.micro"
environment = "development"
"@ | Out-File -FilePath "dev.tfvars" -Encoding utf8

@"
aws_region = "us-east-1"
instance_type = "t3.small"
environment = "production"
"@ | Out-File -FilePath "prod.tfvars" -Encoding utf8

# Initialize once
tfi

# Deploy to different environments
tfp -var-file="dev.tfvars" -out="dev.tfplan"
tfa dev.tfplan

tfp -var-file="prod.tfvars" -out="prod.tfplan"
tfa prod.tfplan

# Use workspaces
tf workspace new development
tf workspace new production

# Switch between workspaces
tf workspace select development
tfa -var-file="dev.tfvars"

tf workspace select production
tfa -var-file="prod.tfvars"
```

## Contributing

Contributions are welcome! Please ensure:

1. **Consistent alias naming**: Follow established Terraform alias patterns
2. **Comprehensive help**: Include detailed `.SYNOPSIS`, `.DESCRIPTION`, and `.EXAMPLE`
3. **Error handling**: Implement proper error checking and user feedback
4. **Cross-platform**: Test on Windows, Linux, and macOS

## Version History

-   **v4.1.0**: Full Terraform plugin with 20+ aliases and workspace awareness
-   **v4.0.0**: Initial Terraform integration and alias conversion

## Related Documentation

-   [Terraform Official Documentation](https://www.terraform.io/docs/)
-   [PowerShell Profile System](https://github.com/MKAbuMattar/powershell-profile)
-   [Infrastructure as Code Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

## License

This module is part of the MKAbuMattar PowerShell Profile project and is licensed under the MIT License.
