#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Terraform Plugin
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
#       This module provides Terraform CLI shortcuts and utility functions for improved Infrastructure
#       as Code workflow in PowerShell environments. Includes functions for initializing, planning,
#       applying, and managing Terraform configurations with convenient aliases and prompt integration.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Invoke-Terraform {
    <#
    .SYNOPSIS
        Base Terraform command wrapper.

    .DESCRIPTION
        Executes Terraform commands with all provided arguments. Serves as the base wrapper
        for all Terraform operations and ensures Terraform is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Terraform command.

    .EXAMPLE
        Invoke-Terraform version
        Shows Terraform version.

    .EXAMPLE
        Invoke-Terraform plan -out=tfplan
        Creates a Terraform plan file.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    & terraform @Arguments
}

function Get-TerraformWorkspace {
    <#
    .SYNOPSIS
        Gets the current Terraform workspace.

    .DESCRIPTION
        Returns the current Terraform workspace by reading from the .terraform/environment file.
        Returns $null if not in a Terraform directory or if workspace cannot be determined.

    .OUTPUTS
        System.String
        The name of the current workspace, or $null if not available.

    .EXAMPLE
        Get-TerraformWorkspace
        Returns the current workspace name, e.g., "production" or "staging".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $tfDataDir = if ($env:TF_DATA_DIR) { $env:TF_DATA_DIR } else { ".terraform" }
        $environmentFile = Join-Path $tfDataDir "environment"
        
        if ((Test-Path $tfDataDir -PathType Container) -and (Test-Path $environmentFile -PathType Leaf)) {
            $workspace = Get-Content $environmentFile -Raw -ErrorAction SilentlyContinue
            if ($workspace) {
                return $workspace.Trim()
            }
        }
        
        return $null
    }
    catch {
        return $null
    }
}

function Get-TerraformVersion {
    <#
    .SYNOPSIS
        Gets the Terraform version.

    .DESCRIPTION
        Returns the current Terraform version by parsing the output of 'terraform version'.

    .OUTPUTS
        System.String
        The Terraform version string, or $null if not available.

    .EXAMPLE
        Get-TerraformVersion
        Returns version string like "v1.5.7".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $versionOutput = terraform version 2>$null | Select-Object -First 1
        if ($versionOutput -match 'Terraform v(.+)') {
            return "v$($matches[1])"
        }
        return $null
    }
    catch {
        return $null
    }
}

function Get-TerraformPromptInfo {
    <#
    .SYNOPSIS
        Gets Terraform workspace information for prompt display.

    .DESCRIPTION
        Returns formatted workspace information suitable for display in a PowerShell prompt.

    .PARAMETER Prefix
        The prefix to display before the workspace name. Defaults to '['.

    .PARAMETER Suffix
        The suffix to display after the workspace name. Defaults to ']'.

    .OUTPUTS
        System.String
        Formatted workspace string like "[production]" or empty string.

    .EXAMPLE
        Get-TerraformPromptInfo
        Returns "[workspace-name]" or empty string.

    .EXAMPLE
        Get-TerraformPromptInfo -Prefix "tf:" -Suffix ""
        Returns "tf:workspace-name" or empty string.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()]
        [string]$Prefix = '[',

        [Parameter()]
        [string]$Suffix = ']'
    )

    if ($PWD.Path -eq $HOME) {
        return ""
    }

    $workspace = Get-TerraformWorkspace
    if ($workspace) {
        return "${Prefix}${workspace}${Suffix}"
    }

    return ""
}

function Get-TerraformVersionPromptInfo {
    <#
    .SYNOPSIS
        Gets Terraform version information for prompt display.

    .DESCRIPTION
        Returns formatted version information suitable for display in a PowerShell prompt.

    .PARAMETER Prefix
        The prefix to display before the version. Defaults to '['.

    .PARAMETER Suffix
        The suffix to display after the version. Defaults to ']'.

    .OUTPUTS
        System.String
        Formatted version string like "[v1.5.7]" or empty string.

    .EXAMPLE
        Get-TerraformVersionPromptInfo
        Returns "[v1.5.7]" or empty string.

    .EXAMPLE
        Get-TerraformVersionPromptInfo -Prefix "tf-" -Suffix ""
        Returns "tf-v1.5.7" or empty string.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()]
        [string]$Prefix = '[',

        [Parameter()]
        [string]$Suffix = ']'
    )

    $version = Get-TerraformVersion
    if ($version) {
        return "${Prefix}${version}${Suffix}"
    }

    return ""
}

function Invoke-TerraformInit {
    <#
    .SYNOPSIS
        Initialize Terraform working directory.

    .DESCRIPTION
        Initializes a Terraform working directory containing configuration files.
        Equivalent to 'terraform init' or 'tfi' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform init.

    .EXAMPLE
        Invoke-TerraformInit
        Initializes the current directory.

    .EXAMPLE
        tfi -backend=false
        Initializes without configuring backend using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformInitReconfigure {
    <#
    .SYNOPSIS
        Initialize Terraform with reconfiguration.

    .DESCRIPTION
        Initializes Terraform and reconfigures the backend, ignoring any saved configuration.
        Equivalent to 'terraform init -reconfigure' or 'tfir' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform init.

    .EXAMPLE
        Invoke-TerraformInitReconfigure
        Initializes with reconfiguration.

    .EXAMPLE
        tfir
        Reconfigures using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfir")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init', '-reconfigure') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformInitUpgrade {
    <#
    .SYNOPSIS
        Initialize Terraform with provider upgrade.

    .DESCRIPTION
        Initializes Terraform and upgrades providers and modules to latest versions.
        Equivalent to 'terraform init -upgrade' or 'tfiu' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform init.

    .EXAMPLE
        Invoke-TerraformInitUpgrade
        Initializes with provider upgrade.

    .EXAMPLE
        tfiu
        Upgrades providers using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfiu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init', '-upgrade') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformInitUpgradeReconfigure {
    <#
    .SYNOPSIS
        Initialize Terraform with upgrade and reconfiguration.

    .DESCRIPTION
        Initializes Terraform with both provider upgrade and backend reconfiguration.
        Equivalent to 'terraform init -upgrade -reconfigure' or 'tfiur' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform init.

    .EXAMPLE
        Invoke-TerraformInitUpgradeReconfigure
        Initializes with upgrade and reconfiguration.

    .EXAMPLE
        tfiur
        Upgrades and reconfigures using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfiur")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init', '-upgrade', '-reconfigure') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformPlan {
    <#
    .SYNOPSIS
        Create Terraform execution plan.

    .DESCRIPTION
        Creates an execution plan showing what actions Terraform will take.
        Equivalent to 'terraform plan' or 'tfp' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform plan.

    .EXAMPLE
        Invoke-TerraformPlan
        Creates an execution plan.

    .EXAMPLE
        tfp -out=tfplan
        Creates plan and saves to file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('plan') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformApply {
    <#
    .SYNOPSIS
        Apply Terraform configuration.

    .DESCRIPTION
        Builds or changes infrastructure according to Terraform configuration files.
        Equivalent to 'terraform apply' or 'tfa' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform apply.

    .EXAMPLE
        Invoke-TerraformApply
        Applies the configuration with confirmation.

    .EXAMPLE
        tfa tfplan
        Applies a saved plan file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfa")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('apply') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformApplyAutoApprove {
    <#
    .SYNOPSIS
        Apply Terraform configuration with auto-approval.

    .DESCRIPTION
        Builds or changes infrastructure without interactive approval.
        Equivalent to 'terraform apply -auto-approve' or 'tfaa' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform apply.

    .EXAMPLE
        Invoke-TerraformApplyAutoApprove
        Applies configuration without confirmation.

    .EXAMPLE
        tfaa
        Auto-approves apply using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfaa")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('apply', '-auto-approve') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformDestroy {
    <#
    .SYNOPSIS
        Destroy Terraform-managed infrastructure.

    .DESCRIPTION
        Destroys the infrastructure managed by Terraform with confirmation.
        Equivalent to 'terraform destroy' or 'tfd' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform destroy.

    .EXAMPLE
        Invoke-TerraformDestroy
        Destroys infrastructure with confirmation.

    .EXAMPLE
        tfd -target=aws_instance.example
        Destroys specific resource using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('destroy') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformDestroyAutoApprove {
    <#
    .SYNOPSIS
        Destroy Terraform-managed infrastructure with auto-approval.

    .DESCRIPTION
        Destroys the infrastructure managed by Terraform without interactive approval.
        Equivalent to 'terraform destroy -auto-approve' or 'tfd!' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform destroy.

    .EXAMPLE
        Invoke-TerraformDestroyAutoApprove
        Destroys infrastructure without confirmation.

    .EXAMPLE
        tfd!
        Auto-approves destroy using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfd!")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('destroy', '-auto-approve') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformFormat {
    <#
    .SYNOPSIS
        Format Terraform configuration files.

    .DESCRIPTION
        Formats Terraform configuration files to canonical format and style.
        Equivalent to 'terraform fmt' or 'tff' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform fmt.

    .EXAMPLE
        Invoke-TerraformFormat
        Formats files in current directory.

    .EXAMPLE
        tff -diff
        Shows formatting differences using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tff")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('fmt') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformFormatRecursive {
    <#
    .SYNOPSIS
        Format Terraform files recursively.

    .DESCRIPTION
        Formats Terraform configuration files in current directory and subdirectories.
        Equivalent to 'terraform fmt -recursive' or 'tffr' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform fmt.

    .EXAMPLE
        Invoke-TerraformFormatRecursive
        Formats all files recursively.

    .EXAMPLE
        tffr
        Recursively formats using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tffr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('fmt', '-recursive') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformValidate {
    <#
    .SYNOPSIS
        Validate Terraform configuration.

    .DESCRIPTION
        Validates the configuration files in the current directory.
        Equivalent to 'terraform validate' or 'tfv' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform validate.

    .EXAMPLE
        Invoke-TerraformValidate
        Validates configuration files.

    .EXAMPLE
        tfv -json
        Validates and outputs JSON using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('validate') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformTest {
    <#
    .SYNOPSIS
        Execute Terraform test configuration.

    .DESCRIPTION
        Runs tests defined in Terraform test files.
        Equivalent to 'terraform test' or 'tft' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform test.

    .EXAMPLE
        Invoke-TerraformTest
        Runs all tests.

    .EXAMPLE
        tft -verbose
        Runs tests with verbose output using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tft")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('test') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformState {
    <#
    .SYNOPSIS
        Manage Terraform state.

    .DESCRIPTION
        Advanced state management commands for manipulating Terraform state.
        Equivalent to 'terraform state' or 'tfs' shortcut.

    .PARAMETER Arguments
        State subcommands and arguments (list, show, mv, rm, etc.).

    .EXAMPLE
        Invoke-TerraformState list
        Lists resources in state.

    .EXAMPLE
        tfs show aws_instance.example
        Shows specific resource state using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfs")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('state') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformOutput {
    <#
    .SYNOPSIS
        Read Terraform output values.

    .DESCRIPTION
        Reads and displays output values from Terraform configuration.
        Equivalent to 'terraform output' or 'tfo' shortcut.

    .PARAMETER Arguments
        Output name or additional arguments.

    .EXAMPLE
        Invoke-TerraformOutput
        Shows all outputs.

    .EXAMPLE
        tfo instance_ip
        Shows specific output using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfo")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('output') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformShow {
    <#
    .SYNOPSIS
        Show Terraform state or plan.

    .DESCRIPTION
        Displays human-readable output from a state or plan file.
        Equivalent to 'terraform show' or 'tfsh' shortcut.

    .PARAMETER Arguments
        Path to state/plan file or additional arguments.

    .EXAMPLE
        Invoke-TerraformShow
        Shows current state.

    .EXAMPLE
        tfsh tfplan
        Shows saved plan file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfsh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('show') + $Arguments
    & terraform @allArgs
}

function Invoke-TerraformConsole {
    <#
    .SYNOPSIS
        Launch interactive Terraform console.

    .DESCRIPTION
        Launches an interactive console for evaluating Terraform expressions.
        Equivalent to 'terraform console' or 'tfc' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terraform console.

    .EXAMPLE
        Invoke-TerraformConsole
        Launches interactive console.

    .EXAMPLE
        tfc
        Starts console using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md
    #>
    [CmdletBinding()]
    [Alias("tfc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('console') + $Arguments
    & terraform @allArgs
}
