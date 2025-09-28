# AWS Plugin for PowerShell Profile

This module provides comprehensive AWS CLI shortcuts and utility functions with advanced features like profile management, MFA support, and role assumption for improved AWS workflow in PowerShell environments.

## Overview

The AWS plugin provides PowerShell functions for managing AWS profiles, regions, and credentials with support for advanced features like Multi-Factor Authentication (MFA), cross-account role assumption, and session management. All functions follow PowerShell naming conventions while maintaining compatibility with AWS CLI workflows.

## Features

- **Profile Management**: Switch between AWS profiles with validation and SSO support
- **Region Management**: Set and validate AWS regions across all available regions
- **MFA Support**: Handle Multi-Factor Authentication tokens and session duration
- **Role Assumption**: Cross-account role assumption with external ID support
- **State Management**: Persist AWS configuration across PowerShell sessions
- **Access Key Rotation**: Secure access key rotation with guided workflow
- **Prompt Integration**: Display AWS context in PowerShell prompts

## Function Reference

### Basic AWS Information

| Function                | Alias          | Description                  | Equivalent                    |
| ----------------------- | -------------- | ---------------------------- | ----------------------------- |
| `Get-AWSCurrentProfile` | `agp`          | Show current AWS profile     | `echo $AWS_PROFILE`           |
| `Get-AWSCurrentRegion`  | `agr`          | Show current AWS region      | `echo $AWS_REGION`            |
| `Get-AWSProfiles`       | `aws-profiles` | List all configured profiles | `aws configure list-profiles` |
| `Get-AWSRegions`        | `aws-regions`  | List all available regions   | `aws ec2 describe-regions`    |

### Profile and Region Management

| Function            | Alias | Description                         | AWS CLI Equivalent           |
| ------------------- | ----- | ----------------------------------- | ---------------------------- |
| `Set-AWSProfile`    | `asp` | Set AWS profile with optional SSO   | `export AWS_PROFILE=profile` |
| `Set-AWSRegion`     | `asr` | Set AWS region with validation      | `export AWS_REGION=region`   |
| `Switch-AWSProfile` | `acp` | Advanced profile switching with MFA | `aws sts get-session-token`  |

### Advanced Operations

| Function              | Alias            | Description                     | AWS CLI Equivalent          |
| --------------------- | ---------------- | ------------------------------- | --------------------------- |
| `Update-AWSAccessKey` | `aws-change-key` | Rotate access keys securely     | `aws iam create-access-key` |
| `Get-AWSPromptInfo`   | -                | Get AWS info for prompt display | Custom prompt integration   |

### State Management (Internal)

| Function              | Description                           |
| --------------------- | ------------------------------------- |
| `Update-AWSState`     | Save current AWS config to state file |
| `Clear-AWSState`      | Clear AWS state file                  |
| `Initialize-AWSState` | Load AWS config from state file       |

## Usage Examples

### Basic Profile and Region Management

```powershell
# Show current AWS configuration
agp                           # Show current profile
agr                           # Show current region

# List available profiles and regions
aws-profiles                  # List all configured profiles
aws-regions                   # List all available AWS regions

# Switch profiles and regions
asp my-profile                # Set profile to 'my-profile'
asr us-west-2                 # Set region to 'us-west-2'

# Clear configuration
asp                           # Clear current profile
asr                           # Clear current region
```

### SSO Operations

```powershell
# Profile switching with SSO
asp my-profile login          # Set profile and perform SSO login
asp my-profile logout         # Set profile and perform SSO logout
asp my-profile login my-sso-session  # Login with specific SSO session

# Clear profile (also logs out)
asp                           # Clear profile and SSO session
```

### Advanced Profile Switching with MFA

```powershell
# Switch to profile requiring MFA
acp production-profile        # Will prompt for MFA token if required

# Switch with pre-provided MFA token
acp production-profile 123456 # Use MFA token 123456

# Cross-account role assumption
acp cross-account-role        # Assume role in different account
```

### Access Key Rotation

```powershell
# Rotate access keys for a profile
aws-change-key my-profile     # Create new keys and guide through rotation

# The function will:
# 1. Create new access key pair
# 2. Guide you through AWS CLI configuration
# 3. Optionally disable old access key
# 4. Provide commands to delete old key
```

### State Management

```powershell
# Enable persistent state across sessions
$env:AWS_PROFILE_STATE_ENABLED = 'true'
$env:AWS_STATE_FILE = 'C:\temp\my-aws-state'  # Optional custom location

# AWS configuration will now persist across PowerShell sessions
asp my-profile                # This will be remembered next session
asr us-east-1                # This will be remembered next session
```

### Prompt Integration

```powershell
# Get AWS info for custom prompts
Get-AWSPromptInfo             # Returns: "<aws:my-profile> <region:us-east-1>"

# Example custom prompt function
function prompt {
    $awsInfo = Get-AWSPromptInfo
    $location = Get-Location
    if ($awsInfo) {
        "PS $location $awsInfo> "
    } else {
        "PS $location> "
    }
}
```

## Advanced Configuration

### MFA Configuration

Configure MFA in your AWS profile:

```ini
[profile my-profile]
region = us-east-1
mfa_serial = arn:aws:iam::123456789012:mfa/username
duration_seconds = 3600
```

### Cross-Account Role Configuration

Configure cross-account roles:

```ini
[profile cross-account]
role_arn = arn:aws:iam::987654321098:role/CrossAccountRole
source_profile = my-profile
mfa_serial = arn:aws:iam::123456789012:mfa/username
external_id = unique-external-id
role_session_name = PowerShellSession
```

## Installation

This module is automatically loaded as part of the PowerShell profile. All functions and aliases are available immediately when the profile loads.

## Requirements

- PowerShell 5.0 or later
- AWS CLI installed and accessible via PATH
- AWS credentials configured (~/.aws/credentials and ~/.aws/config)
- For MFA: MFA device configured in AWS IAM
- For SSO: AWS SSO configured with appropriate permissions

## Environment Variables

| Variable                    | Description                | Default                          |
| --------------------------- | -------------------------- | -------------------------------- |
| `AWS_PROFILE_STATE_ENABLED` | Enable state persistence   | `false`                          |
| `AWS_STATE_FILE`            | Custom state file location | `$env:TEMP\.aws_current_profile` |
| `AWS_CONFIG_FILE`           | Custom AWS config file     | `$env:HOME\.aws\config`          |

## Error Handling

The module provides comprehensive error handling:

- **Profile validation**: Checks if profiles exist before switching
- **Region validation**: Validates regions against AWS region list
- **MFA timeout**: Handles MFA token timeouts gracefully
- **Network errors**: Manages AWS CLI network connectivity issues
- **Permission errors**: Clear messages for insufficient IAM permissions

## Security Notes

- **MFA tokens**: Never logged or stored, prompted securely
- **Session tokens**: Temporary credentials with configurable expiration
- **Access key rotation**: Guided process to minimize security exposure
- **State files**: Contain only profile/region names, no credentials

## Contributing

To add new AWS functionality or modify existing features:

1. Update function definitions in `AWS.psm1`
2. Add corresponding aliases to the manifest in `AWS.psd1`
3. Update this README with new function documentation
4. Add comprehensive help documentation following PowerShell standards
5. Test with various AWS configurations (MFA, SSO, cross-account roles)

## Troubleshooting

### Common Issues

**Profile not found**: Ensure profile exists in `~/.aws/config`

```powershell
aws-profiles  # List available profiles
```

**Region validation fails**: Ensure AWS CLI can access AWS services

```powershell
aws-regions   # Test region listing
```

**MFA failures**: Check MFA device time synchronization and token validity

**SSO issues**: Ensure SSO session is properly configured

```powershell
aws sso login --sso-session your-session
```

### Debug Mode

Enable verbose AWS CLI output:

```powershell
$env:AWS_CLI_FILE_ENCODING = 'UTF-8'
```

## License

This module is part of the PowerShell Profile project and is licensed under the same terms.
