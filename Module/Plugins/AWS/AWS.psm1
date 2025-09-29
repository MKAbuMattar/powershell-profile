#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This module provides AWS CLI shortcuts and utility functions for improved AWS workflow
#       in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Get-AWSCurrentProfile {
    <#
    .SYNOPSIS
        A PowerShell function that displays the currently active AWS profile.

    .DESCRIPTION
        This function retrieves and displays the currently active AWS profile from the AWS_PROFILE environment variable.
        It provides a quick way to check which AWS profile is currently being used for AWS CLI operations.
        This is equivalent to checking the value of the $env:AWS_PROFILE variable.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.String. Returns the current AWS profile name as a string, or null if no profile is set.

    .EXAMPLE
        agp
        Returns the name of the currently active AWS profile.

        Get-AWSCurrentProfile
        Returns the name of the currently active AWS profile using the full function name.

        $currentProfile = agp
        Stores the current AWS profile name in a variable for later use.

    .NOTES
        - This function reads from the AWS_PROFILE environment variable.
        - Returns null or empty string if no AWS profile is currently set.
        - This is a shortcut for accessing $env:AWS_PROFILE directly.
    #>
    [CmdletBinding()]
    [Alias("agp")]
    param()
    return $env:AWS_PROFILE
}

function Get-AWSCurrentRegion {
    <#
    .SYNOPSIS
        A PowerShell function that displays the currently active AWS region.

    .DESCRIPTION
        This function retrieves and displays the currently active AWS region from the AWS_REGION environment variable.
        It provides a quick way to check which AWS region is currently being used for AWS CLI operations.
        This is equivalent to checking the value of the $env:AWS_REGION variable.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.String. Returns the current AWS region name as a string, or null if no region is set.

    .EXAMPLE
        agr
        Returns the name of the currently active AWS region.

        Get-AWSCurrentRegion
        Returns the name of the currently active AWS region using the full function name.

        $currentRegion = agr
        Stores the current AWS region name in a variable for later use.

    .NOTES
        - This function reads from the AWS_REGION environment variable.
        - Returns null or empty string if no AWS region is currently set.
        - This is a shortcut for accessing $env:AWS_REGION directly.
    #>
    [CmdletBinding()]
    [Alias("agr")]
    param()
    return $env:AWS_REGION
}

function Update-AWSState {
    <#
    .SYNOPSIS
        A PowerShell function that updates the AWS state file with current profile and region information.

    .DESCRIPTION
        This function saves the current AWS profile and region to a state file if AWS profile state tracking is enabled.
        The state file allows the AWS configuration to persist across PowerShell sessions when AWS_PROFILE_STATE_ENABLED is set to 'true'.
        The function writes the current AWS_PROFILE and AWS_REGION values to the specified state file location.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        None. This function writes to a file but does not return objects.

    .EXAMPLE
        Update-AWSState
        Updates the AWS state file with the current profile and region if state tracking is enabled.

        $env:AWS_PROFILE_STATE_ENABLED = 'true'
        Update-AWSState
        Enables state tracking and updates the state file with current AWS configuration.

    .NOTES
        - Requires AWS_PROFILE_STATE_ENABLED environment variable to be set to 'true'.
        - Uses AWS_STATE_FILE environment variable for custom state file location, defaults to $env:TEMP\.aws_current_profile.
        - Creates or overwrites the state file with current AWS_PROFILE and AWS_REGION values.
        - Will display an error if the state directory does not exist.
    #>
    if ($env:AWS_PROFILE_STATE_ENABLED -eq 'true') {
        $stateFile = if ($env:AWS_STATE_FILE) { $env:AWS_STATE_FILE } else { "$env:TEMP\.aws_current_profile" }
        $stateDir = Split-Path -Path $stateFile -Parent

        if (-not (Test-Path -Path $stateDir)) {
            Write-Error "State directory does not exist: $stateDir"
            return
        }

        "$env:AWS_PROFILE $env:AWS_REGION" | Out-File -FilePath $stateFile -Encoding UTF8
    }
}

function Clear-AWSState {
    <#
    .SYNOPSIS
        A PowerShell function that clears the AWS state file.

    .DESCRIPTION
        This function empties the AWS state file if AWS profile state tracking is enabled.
        It removes any saved AWS profile and region information from the state file, effectively
        clearing the persistent AWS configuration. The state file will be emptied but not deleted.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        None. This function writes to a file but does not return objects.

    .EXAMPLE
        Clear-AWSState
        Clears the AWS state file if state tracking is enabled.

        $env:AWS_PROFILE_STATE_ENABLED = 'true'
        Clear-AWSState
        Enables state tracking and clears any existing state information.

    .NOTES
        - Requires AWS_PROFILE_STATE_ENABLED environment variable to be set to 'true'.
        - Uses AWS_STATE_FILE environment variable for custom state file location, defaults to $env:TEMP\.aws_current_profile.
        - Empties the state file content but does not delete the file itself.
        - Will display an error if the state directory does not exist.
    #>
    [CmdletBinding()]
    param()

    if ($env:AWS_PROFILE_STATE_ENABLED -eq 'true') {
        $stateFile = if ($env:AWS_STATE_FILE) { $env:AWS_STATE_FILE } else { "$env:TEMP\.aws_current_profile" }
        $stateDir = Split-Path -Path $stateFile -Parent

        if (-not (Test-Path -Path $stateDir)) {
            Write-Error "State directory does not exist: $stateDir"
            return
        }

        '' | Out-File -FilePath $stateFile -Encoding UTF8
    }
}

function Set-AWSProfile {
    <#
    .SYNOPSIS
        A PowerShell function that sets the AWS profile for the current session with optional SSO operations.

    .DESCRIPTION
        This function changes the AWS profile for the current PowerShell session and optionally performs SSO login/logout operations.
        It validates that the specified profile exists in the AWS configuration before setting it. If no profile is specified,
        it clears all AWS profile-related environment variables. The function also supports AWS SSO login and logout operations.

    .PARAMETER Profile
        The AWS profile name to switch to. If empty or not provided, clears all AWS profile variables.
        The profile must exist in the AWS configuration file.

    .PARAMETER Action
        Optional action to perform after setting the profile. Valid values are 'login', 'logout', or empty string.
        'login' performs AWS SSO login, 'logout' performs AWS SSO logout.

    .PARAMETER SSOSession
        Optional SSO session name for login operations. Only used when Action is 'login'.

    .INPUTS
        System.String. The profile name, action, and SSO session can be provided as parameters.

    .OUTPUTS
        None. This function writes status messages to the console but does not return objects.

    .EXAMPLE
        asp my-profile
        Sets the AWS profile to 'my-profile' for the current session.

        Set-AWSProfile -Profile my-profile
        Sets the AWS profile to 'my-profile' using the full function name.

        asp my-profile login
        Sets the AWS profile to 'my-profile' and performs AWS SSO login.

        asp my-profile login my-sso-session
        Sets the AWS profile to 'my-profile' and performs AWS SSO login with a specific SSO session.

        asp
        Clears all AWS profile variables from the current session.

    .NOTES
        - Requires AWS CLI to be installed and available in the system's PATH.
        - The specified profile must exist in the AWS configuration file (~/.aws/config).
        - Sets AWS_DEFAULT_PROFILE, AWS_PROFILE, and AWS_EB_PROFILE environment variables.
        - Updates the AWS state file if state tracking is enabled.
        - Supports AWS SSO login and logout operations.
    #>
    [CmdletBinding()]
    [Alias("asp")]
    param(
        [Parameter(Position = 0)]
        [string]$Profile,

        [Parameter(Position = 1)]
        [ValidateSet('login', 'logout', '')]
        [string]$Action = '',

        [Parameter(Position = 2)]
        [string]$SSOSession = ''
    )

    if ([string]::IsNullOrEmpty($Profile)) {
        Remove-Item -Path Env:AWS_DEFAULT_PROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_PROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_EB_PROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_PROFILE_REGION -ErrorAction SilentlyContinue
        Clear-AWSState
        Write-Host "AWS profile cleared." -ForegroundColor Green
        return
    }

    $availableProfiles = Get-AWSProfiles
    if ($Profile -notin $availableProfiles) {
        $configFile = if ($env:AWS_CONFIG_FILE) { $env:AWS_CONFIG_FILE } else { "$env:HOME\.aws\config" }
        Write-Error "Profile '$Profile' not found in '$configFile'"
        Write-Host "Available profiles: $($availableProfiles -join ', ')" -ForegroundColor Yellow
        return
    }

    $env:AWS_DEFAULT_PROFILE = $Profile
    $env:AWS_PROFILE = $Profile
    $env:AWS_EB_PROFILE = $Profile

    try {
        $env:AWS_PROFILE_REGION = aws configure get region --profile $Profile 2>$null
    }
    catch {}

    Update-AWSState

    if ($Action -eq 'login') {
        if (-not [string]::IsNullOrEmpty($SSOSession)) {
            aws sso login --sso-session $SSOSession
        }
        else {
            aws sso login
        }
    }
    elseif ($Action -eq 'logout') {
        aws sso logout
    }

    Write-Host "AWS profile set to: $Profile" -ForegroundColor Green
}

function Set-AWSRegion {
    <#
    .SYNOPSIS
        A PowerShell function that sets the AWS region for the current session.

    .DESCRIPTION
        This function changes the AWS region for the current PowerShell session with validation against available AWS regions.
        It validates that the specified region exists and is available before setting it. If no region is specified,
        it clears all AWS region-related environment variables. The function updates both AWS_REGION and AWS_DEFAULT_REGION.

    .PARAMETER Region
        The AWS region to switch to. If empty or not provided, clears all AWS region variables.
        The region must be a valid AWS region (e.g., us-east-1, eu-west-1, ap-southeast-2).

    .INPUTS
        System.String. The region name can be provided as a parameter.

    .OUTPUTS
        None. This function writes status messages to the console but does not return objects.

    .EXAMPLE
        asr us-east-1
        Sets the AWS region to 'us-east-1' for the current session.

        Set-AWSRegion -Region eu-west-1
        Sets the AWS region to 'eu-west-1' using the full function name.

        asr ap-southeast-2
        Sets the AWS region to 'ap-southeast-2' for the current session.

        asr
        Clears all AWS region variables from the current session.

    .NOTES
        - Requires AWS CLI to be installed and available in the system's PATH.
        - Validates the region against the list of available AWS regions.
        - Sets AWS_REGION and AWS_DEFAULT_REGION environment variables.
        - Updates the AWS state file if state tracking is enabled.
        - An AWS profile must be set to retrieve the list of available regions.
    #>
    [Alias("asr")]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Region
    )

    if ([string]::IsNullOrEmpty($Region)) {
        Remove-Item -Path Env:AWS_DEFAULT_REGION -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_REGION -ErrorAction SilentlyContinue
        Update-AWSState
        Write-Host "AWS region cleared." -ForegroundColor Green
        return
    }

    $availableRegions = Get-AWSRegions
    if ($Region -notin $availableRegions) {
        Write-Error "Invalid region: $Region"
        Write-Host "Available regions:" -ForegroundColor Yellow
        Get-AWSRegions | Format-Wide -Column 3
        return
    }

    $env:AWS_REGION = $Region
    $env:AWS_DEFAULT_REGION = $Region
    Update-AWSState
    Write-Host "AWS region set to: $Region" -ForegroundColor Green
}

function Switch-AWSProfile {
    <#
    .SYNOPSIS
        A PowerShell function that switches AWS profiles with advanced support for MFA and role assumption.

    .DESCRIPTION
        This function performs advanced AWS profile switching that handles MFA (Multi-Factor Authentication) tokens,
        role assumption, and session token management. It can assume roles across AWS accounts, handle MFA requirements,
        and manage temporary credentials. This is more advanced than Set-AWSProfile as it handles credential generation
        and temporary session management.

    .PARAMETER Profile
        The AWS profile name to switch to. This parameter is mandatory and the profile must exist in AWS configuration.

    .PARAMETER MFAToken
        Optional MFA token code. If the profile requires MFA and no token is provided, the function will prompt for one.

    .INPUTS
        System.String. The profile name and MFA token can be provided as parameters.

    .OUTPUTS
        None. This function writes status messages to the console but does not return objects.

    .EXAMPLE
        acp production-profile
        Switches to 'production-profile' with automatic MFA prompting if required.

        Switch-AWSProfile -Profile production-profile -MFAToken 123456
        Switches to 'production-profile' using the provided MFA token.

        acp cross-account-role
        Switches to a profile configured for cross-account role assumption.

    .NOTES
        - Requires AWS CLI to be installed and available in the system's PATH.
        - Supports MFA token authentication with configurable session duration.
        - Handles cross-account role assumption with external ID support.
        - Manages temporary AWS credentials (AccessKeyId, SecretAccessKey, SessionToken).
        - The profile must be configured with appropriate role_arn, mfa_serial, or other advanced settings.
        - Session duration can be configured per profile (900-43200 seconds, default 3600).
    #>
    [Alias("acp")]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$Profile,

        [Parameter(Position = 1)]
        [string]$MFAToken = ''
    )

    if ([string]::IsNullOrEmpty($Profile)) {
        Remove-Item -Path Env:AWS_DEFAULT_PROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_PROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_EB_PROFILE -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_ACCESS_KEY_ID -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_SECRET_ACCESS_KEY -ErrorAction SilentlyContinue
        Remove-Item -Path Env:AWS_SESSION_TOKEN -ErrorAction SilentlyContinue
        Write-Host "AWS profile cleared." -ForegroundColor Green
        return
    }

    $availableProfiles = Get-AWSProfiles
    if ($Profile -notin $availableProfiles) {
        $configFile = if ($env:AWS_CONFIG_FILE) { $env:AWS_CONFIG_FILE } else { "$env:HOME\.aws\config" }
        Write-Error "Profile '$Profile' not found in '$configFile'"
        Write-Host "Available profiles: $($availableProfiles -join ', ')" -ForegroundColor Yellow
        return
    }

    try {
        $awsAccessKeyId = aws configure get aws_access_key_id --profile $Profile 2>$null
        $awsSecretAccessKey = aws configure get aws_secret_access_key --profile $Profile 2>$null
        $awsSessionToken = aws configure get aws_session_token --profile $Profile 2>$null
    }
    catch {
        Write-Warning "Could not retrieve AWS credentials for profile $Profile"
    }

    try {
        $mfaSerial = aws configure get mfa_serial --profile $Profile 2>$null
        $sessDuration = aws configure get duration_seconds --profile $Profile 2>$null
    }
    catch {}

    $mfaOptions = @()
    if (-not [string]::IsNullOrEmpty($mfaSerial)) {
        if ([string]::IsNullOrEmpty($MFAToken)) {
            $MFAToken = Read-Host "Please enter your MFA token for $mfaSerial"
        }
        if ([string]::IsNullOrEmpty($sessDuration)) {
            $sessDuration = Read-Host "Please enter the session duration in seconds (900-43200; default: 3600)"
            if ([string]::IsNullOrEmpty($sessDuration)) { $sessDuration = '3600' }
        }
        $mfaOptions = @('--serial-number', $mfaSerial, '--token-code', $MFAToken, '--duration-seconds', $sessDuration)
    }

    try {
        $roleArn = aws configure get role_arn --profile $Profile 2>$null
        $sessName = aws configure get role_session_name --profile $Profile 2>$null
    }
    catch {}

    $awsCommand = @()
    if (-not [string]::IsNullOrEmpty($roleArn)) {
        $awsCommand = @('aws', 'sts', 'assume-role', '--role-arn', $roleArn) + $mfaOptions

        try {
            $externalId = aws configure get external_id --profile $Profile 2>$null
            if (-not [string]::IsNullOrEmpty($externalId)) {
                $awsCommand += @('--external-id', $externalId)
            }
        }
        catch {}

        try {
            $sourceProfile = aws configure get source_profile --profile $Profile 2>$null
            if ([string]::IsNullOrEmpty($sessName)) {
                $sessName = if ([string]::IsNullOrEmpty($sourceProfile)) { 'profile' } else { $sourceProfile }
            }
            $profileOption = if ([string]::IsNullOrEmpty($sourceProfile)) { 'profile' } else { $sourceProfile }
            $awsCommand += @("--profile=$profileOption", '--role-session-name', $sessName)
        }
        catch { }

        Write-Host "Assuming role $roleArn using profile $($sourceProfile ?? 'profile')" -ForegroundColor Yellow
    }
    else {
        $awsCommand = @('aws', 'sts', 'get-session-token', "--profile=$Profile") + $mfaOptions
        Write-Host "Obtaining session token for profile $Profile" -ForegroundColor Yellow
    }

    $awsCommand += @('--query', '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]', '--output', 'text')

    try {
        $result = & $awsCommand[0] $awsCommand[1..($awsCommand.Length - 1)] 2>$null
        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrEmpty($result)) {
            $credentials = $result -split "`t"
            if ($credentials.Length -ge 3) {
                $awsAccessKeyId = $credentials[0]
                $awsSecretAccessKey = $credentials[1]
                $awsSessionToken = $credentials[2]
            }
        }
    }
    catch {
        Write-Warning "AWS command failed: $_"
    }

    if (-not [string]::IsNullOrEmpty($awsAccessKeyId) -and -not [string]::IsNullOrEmpty($awsSecretAccessKey)) {
        $env:AWS_DEFAULT_PROFILE = $Profile
        $env:AWS_PROFILE = $Profile
        $env:AWS_EB_PROFILE = $Profile
        $env:AWS_ACCESS_KEY_ID = $awsAccessKeyId
        $env:AWS_SECRET_ACCESS_KEY = $awsSecretAccessKey

        if (-not [string]::IsNullOrEmpty($awsSessionToken)) {
            $env:AWS_SESSION_TOKEN = $awsSessionToken
        }
        else {
            Remove-Item -Path Env:AWS_SESSION_TOKEN -ErrorAction SilentlyContinue
        }

        Write-Host "Switched to AWS Profile: $Profile" -ForegroundColor Green
    }
    else {
        Write-Error "Failed to obtain AWS credentials"
    }
}

function Update-AWSAccessKey {
    <#
    .SYNOPSIS
        A PowerShell function that creates a new AWS access key pair and manages the transition from old keys.

    .DESCRIPTION
        This function generates new AWS access keys for the specified profile and helps manage the transition
        from old keys to new ones. It creates a new access key pair, guides through the configuration process,
        and optionally disables the previous access key for security. This is useful for regular key rotation
        or when access keys may have been compromised.

    .PARAMETER Profile
        The AWS profile to update access keys for. This parameter is mandatory and the profile must exist
        in AWS configuration.

    .INPUTS
        System.String. The profile name can be provided as a parameter.

    .OUTPUTS
        None. This function writes status messages to the console but does not return objects.

    .EXAMPLE
        aws-change-key my-profile
        Creates new access keys for 'my-profile' and guides through the key rotation process.

        Update-AWSAccessKey -Profile production-profile
        Creates new access keys for 'production-profile' using the full function name.

    .NOTES
        - Requires AWS CLI to be installed and available in the system's PATH.
        - Requires appropriate IAM permissions to create and manage access keys.
        - The function will prompt for confirmation before disabling old access keys.
        - Automatically switches to the specified profile before creating new keys.
        - Provides guidance for manually deleting old access keys after rotation.
        - May fail if the user has reached the maximum number of access keys (2 per user).
    #>
    [Alias("aws-change-key")]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$Profile
    )

    try {
        $originalAccessKey = aws configure get aws_access_key_id --profile $Profile 2>$null
    }
    catch {
        Write-Error "Could not retrieve current access key for profile $Profile"
        return
    }

    Set-AWSProfile -Profile $Profile
    if ($LASTEXITCODE -ne 0) {
        return
    }

    Write-Host "Generating a new access key pair for you now." -ForegroundColor Yellow

    try {
        $result = aws --no-cli-pager iam create-access-key 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Insert the newly generated credentials when asked." -ForegroundColor Green
            aws --no-cli-pager configure --profile $Profile
        }
        else {
            Write-Host "Current access keys:" -ForegroundColor Yellow
            aws --no-cli-pager iam list-access-keys
            Write-Host "Profile `"$Profile`" is currently using the $originalAccessKey key." -ForegroundColor Yellow
            Write-Host "You can delete an old access key by running: aws --profile $Profile iam delete-access-key --access-key-id AccessKeyId" -ForegroundColor Cyan
            return
        }
    }
    catch {
        Write-Error "Failed to create new access key: $_"
        return
    }

    $disable = Read-Host "Would you like to disable your previous access key ($originalAccessKey) now? (y/N)"
    if ($disable -match '^[Yy]') {
        Write-Host "Disabling access key $originalAccessKey..." -ForegroundColor Yellow -NoNewline
        try {
            aws --no-cli-pager iam update-access-key --access-key-id $originalAccessKey --status Inactive 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "done." -ForegroundColor Green
            }
            else {
                Write-Host "failed." -ForegroundColor Red
                Write-Host "Failed to disable $originalAccessKey key." -ForegroundColor Red
            }
        }
        catch {
            Write-Host "failed." -ForegroundColor Red
            Write-Error "Failed to disable access key: $_"
        }
    }

    Write-Host "You can now safely delete the old access key by running: aws --profile $Profile iam delete-access-key --access-key-id $originalAccessKey" -ForegroundColor Cyan
    Write-Host "Your current keys are:" -ForegroundColor Yellow
    aws --no-cli-pager iam list-access-keys
}

function Get-AWSRegions {
    <#
    .SYNOPSIS
        A PowerShell function that lists all available AWS regions.

    .DESCRIPTION
        This function retrieves a complete list of all available AWS regions using the AWS CLI.
        It queries the AWS EC2 service to get the current list of active regions and returns them
        in sorted order. The function requires an active AWS profile to be set and uses a fallback
        region for the initial query.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.Array. Returns an array of AWS region names as strings, sorted alphabetically.

    .EXAMPLE
        aws-regions
        Returns a list of all available AWS regions.

        Get-AWSRegions
        Returns a list of all available AWS regions using the full function name.

        $regions = aws-regions
        Stores all available AWS regions in a variable for later use.

        aws-regions | Where-Object { $_ -like 'us-*' }
        Returns only AWS regions in the United States.

    .NOTES
        - Requires AWS CLI to be installed and available in the system's PATH.
        - An AWS profile must be set to retrieve the list of regions.
        - Uses a fallback region (us-west-1) for the initial query if no region is set.
        - Returns an empty array if no AWS profile is configured or if the query fails.
        - The region list is sorted alphabetically for consistent output.
    #>
    [Alias("aws-regions")]
    param()
    $region = $env:AWS_DEFAULT_REGION
    if ([string]::IsNullOrEmpty($region)) {
        $region = $env:AWS_REGION
    }
    if ([string]::IsNullOrEmpty($region)) {
        $region = 'us-west-1'
    }

    if (-not [string]::IsNullOrEmpty($env:AWS_DEFAULT_PROFILE) -or -not [string]::IsNullOrEmpty($env:AWS_PROFILE)) {
        try {
            $result = aws ec2 describe-regions --region $region --query 'Regions[].RegionName' --output text 2>$null
            if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrEmpty($result)) {
                return ($result -split "`t" | Sort-Object)
            }
        }
        catch {
            Write-Warning "Could not retrieve AWS regions: $_"
        }
    }
    else {
        Write-Error "You must specify an AWS profile."
    }
    return @()
}

function Get-AWSProfiles {
    <#
    .SYNOPSIS
        A PowerShell function that lists all available AWS profiles.

    .DESCRIPTION
        This function retrieves a complete list of all configured AWS profiles from the AWS CLI configuration.
        It first attempts to use the AWS CLI's built-in profile listing command, and falls back to parsing
        the AWS configuration file directly if the CLI method fails. The profiles are returned in sorted order.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.Array. Returns an array of AWS profile names as strings, sorted alphabetically.

    .EXAMPLE
        aws-profiles
        Returns a list of all configured AWS profiles.

        Get-AWSProfiles
        Returns a list of all configured AWS profiles using the full function name.

        $profiles = aws-profiles
        Stores all available AWS profiles in a variable for later use.

        aws-profiles | Where-Object { $_ -like '*prod*' }
        Returns only AWS profiles containing 'prod' in their name.

    .NOTES
        - Requires AWS CLI to be installed and available in the system's PATH.
        - Reads from the AWS configuration file (~/.aws/config) as a fallback.
        - Supports both 'profile' and default profile configurations.
        - Returns an empty array if no profiles are configured or if configuration files are not accessible.
        - The profile list is sorted alphabetically for consistent output.
    #>
    [Alias("aws-profiles")]
    param()
    try {
        $result = aws --no-cli-pager configure list-profiles 2>$null
        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrEmpty($result)) {
            return ($result -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object)
        }
    }
    catch { }

    $configFile = if ($env:AWS_CONFIG_FILE) { $env:AWS_CONFIG_FILE } else { "$env:HOME\.aws\config" }
    if (Test-Path -Path $configFile) {
        try {
            $profiles = @()
            $content = Get-Content -Path $configFile -ErrorAction Stop
            foreach ($line in $content) {
                if ($line -match '^\[(?:profile\s+)?([^\]]+)\]$') {
                    $profiles += $matches[1]
                }
            }
            return ($profiles | Sort-Object)
        }
        catch {
            Write-Warning "Could not parse AWS config file: $_"
        }
    }
    return @()
}

function Get-AWSPromptInfo {
    <#
    .SYNOPSIS
        A PowerShell function that gets AWS information for prompt display.

    .DESCRIPTION
        This function returns formatted AWS profile and region information that can be used in PowerShell prompts.
        It combines the current AWS profile and region into a formatted string suitable for display in command prompts
        or status bars. The function checks multiple environment variables to find the most current AWS configuration.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.String. Returns a formatted string containing AWS profile and region information, or empty string if none are set.

    .EXAMPLE
        Get-AWSPromptInfo
        Returns formatted AWS information like "<aws:my-profile> <region:us-east-1>".

        $promptInfo = Get-AWSPromptInfo
        Stores the AWS prompt information in a variable for use in custom prompts.

        function prompt { "PS $((Get-Location).Path) $(Get-AWSPromptInfo)> " }
        Uses AWS prompt info in a custom PowerShell prompt function.

    .NOTES
        - Returns an empty string if no AWS profile or region is set.
        - Checks AWS_REGION, AWS_DEFAULT_REGION, and AWS_PROFILE_REGION environment variables.
        - Formats output as "<aws:profile-name> <region:region-name>" when both are available.
        - Can be used in PowerShell prompt functions or status display scripts.
    #>
    $awsInfo = @()
    $region = $env:AWS_REGION
    if ([string]::IsNullOrEmpty($region)) {
        $region = $env:AWS_DEFAULT_REGION
        if ([string]::IsNullOrEmpty($region)) {
            $region = $env:AWS_PROFILE_REGION
        }
    }

    if (-not [string]::IsNullOrEmpty($env:AWS_PROFILE)) {
        $awsInfo += "<aws:$($env:AWS_PROFILE)>"
    }

    if (-not [string]::IsNullOrEmpty($region)) {
        $awsInfo += "<region:$region>"
    }

    return ($awsInfo -join ' ')
}

function Initialize-AWSState {
    <#
    .SYNOPSIS
        A PowerShell function that initializes AWS state from a state file if enabled.

    .DESCRIPTION
        This function loads AWS profile and region configuration from a state file if AWS profile state tracking is enabled.
        It restores the AWS environment variables from the previous session, allowing AWS configuration to persist across
        PowerShell sessions. The function is automatically called when the AWS module is imported.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        None. This function sets environment variables but does not return objects.

    .EXAMPLE
        Initialize-AWSState
        Loads AWS configuration from the state file if state tracking is enabled.

        $env:AWS_PROFILE_STATE_ENABLED = 'true'
        Initialize-AWSState
        Enables state tracking and loads any existing state information.

    .NOTES
        - Requires AWS_PROFILE_STATE_ENABLED environment variable to be set to 'true'.
        - Uses AWS_STATE_FILE environment variable for custom state file location, defaults to $env:TEMP\.aws_current_profile.
        - Automatically called when the AWS module is imported.
        - Sets AWS_DEFAULT_PROFILE, AWS_PROFILE, AWS_EB_PROFILE, AWS_REGION, and AWS_DEFAULT_REGION.
        - If region is not in state file, attempts to retrieve it from AWS configuration.
        - Fails silently if state file doesn't exist or cannot be read.
    #>
    if ($env:AWS_PROFILE_STATE_ENABLED -eq 'true') {
        $stateFile = if ($env:AWS_STATE_FILE) { $env:AWS_STATE_FILE } else { "$env:TEMP\.aws_current_profile" }

        if (Test-Path -Path $stateFile) {
            try {
                $content = Get-Content -Path $stateFile -Raw -ErrorAction Stop
                if (-not [string]::IsNullOrWhiteSpace($content)) {
                    $awsState = $content.Trim() -split '\s+'

                    if ($awsState.Length -gt 0 -and -not [string]::IsNullOrEmpty($awsState[0])) {
                        $env:AWS_DEFAULT_PROFILE = $awsState[0]
                        $env:AWS_PROFILE = $awsState[0]
                        $env:AWS_EB_PROFILE = $awsState[0]
                    }

                    if ($awsState.Length -gt 1 -and -not [string]::IsNullOrEmpty($awsState[1])) {
                        $env:AWS_REGION = $awsState[1]
                        $env:AWS_DEFAULT_REGION = $awsState[1]
                    }
                    elseif (-not [string]::IsNullOrEmpty($env:AWS_PROFILE)) {
                        try {
                            $env:AWS_REGION = aws configure get region --profile $env:AWS_PROFILE 2>$null
                            $env:AWS_DEFAULT_REGION = $env:AWS_REGION
                        }
                        catch { }
                    }
                }
            }
            catch {
                Write-Warning "Could not load AWS state file: $_"
            }
        }
    }
}

#---------------------------------------------------------------------------------------------------
# Invoke initialization on module import
#---------------------------------------------------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Initialize-AWSState} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Export Module Members
#---------------------------------------------------------------------------------------------------

# Export all functions
Export-ModuleMember -Function * -Alias *
