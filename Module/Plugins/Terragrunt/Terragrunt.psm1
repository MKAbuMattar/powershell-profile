#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Terragrunt Plugin
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
#       This module provides Terragrunt CLI shortcuts and utility functions for improved DRY
#       Infrastructure as Code workflow in PowerShell environments. Converts 25+ common
#       terragrunt operations to PowerShell functions with full parameter support, dependency
#       orchestration, and multi-environment management.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function Invoke-Terragrunt {
    <#
    .SYNOPSIS
        Base Terragrunt command wrapper.

    .DESCRIPTION
        Executes Terragrunt commands with all provided arguments. Serves as the base wrapper
        for all Terragrunt operations and ensures Terragrunt is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Terragrunt command.

    .EXAMPLE
        Invoke-Terragrunt --version
        Shows Terragrunt version.

    .EXAMPLE
        Invoke-Terragrunt plan --terragrunt-non-interactive
        Creates a Terragrunt plan non-interactively.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tg")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    & terragrunt @Arguments
}

function Get-TerragruntWorkingDir {
    <#
    .SYNOPSIS
        Gets the Terragrunt working directory.

    .DESCRIPTION
        Returns the current Terragrunt working directory by checking for terragrunt.hcl files
        or using the current directory if terragrunt.hcl is present.

    .OUTPUTS
        System.String
        The path to the Terragrunt working directory, or $null if not in a Terragrunt directory.

    .EXAMPLE
        Get-TerragruntWorkingDir
        Returns the path to the current Terragrunt working directory.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $currentDir = $PWD.Path
        
        $searchDir = $currentDir
        while ($searchDir) {
            $terragruntFile = Join-Path $searchDir "terragrunt.hcl"
            if (Test-Path $terragruntFile -PathType Leaf) {
                return $searchDir
            }
            $parentDir = Split-Path $searchDir -Parent
            if ($parentDir -eq $searchDir) {
                break
            }
            $searchDir = $parentDir
        }
        
        return $null
    }
    catch {
        return $null
    }
}

function Get-TerragruntConfigPath {
    <#
    .SYNOPSIS
        Gets the path to the terragrunt.hcl configuration file.

    .DESCRIPTION
        Returns the full path to the terragrunt.hcl configuration file in the current
        or parent directories.

    .OUTPUTS
        System.String
        The path to terragrunt.hcl file, or $null if not found.

    .EXAMPLE
        Get-TerragruntConfigPath
        Returns the full path to terragrunt.hcl.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $workingDir = Get-TerragruntWorkingDir
    if ($workingDir) {
        return Join-Path $workingDir "terragrunt.hcl"
    }
    return $null
}

function Get-TerragruntCacheDir {
    <#
    .SYNOPSIS
        Gets the Terragrunt cache directory.

    .DESCRIPTION
        Returns the Terragrunt cache directory path, typically .terragrunt-cache
        in the current working directory.

    .OUTPUTS
        System.String
        The path to the Terragrunt cache directory.

    .EXAMPLE
        Get-TerragruntCacheDir
        Returns the cache directory path.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $workingDir = Get-TerragruntWorkingDir
    if ($workingDir) {
        return Join-Path $workingDir ".terragrunt-cache"
    }
    return Join-Path $PWD.Path ".terragrunt-cache"
}

function Invoke-TerragruntInit {
    <#
    .SYNOPSIS
        Initialize Terragrunt working directory.

    .DESCRIPTION
        Initializes a Terragrunt working directory containing terragrunt.hcl configuration.
        Equivalent to 'terragrunt init' or 'tgi' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt init.

    .EXAMPLE
        Invoke-TerragruntInit
        Initializes the current Terragrunt directory.

    .EXAMPLE
        tgi --terragrunt-non-interactive
        Initializes non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntInitFromModule {
    <#
    .SYNOPSIS
        Initialize Terragrunt from a remote module.

    .DESCRIPTION
        Initializes Terragrunt configuration from a remote module source.
        Equivalent to 'terragrunt init-from-module' or 'tgifm' shortcut.

    .PARAMETER ModuleSource
        The source URL or path of the module to initialize from.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt init-from-module.

    .EXAMPLE
        Invoke-TerragruntInitFromModule git@github.com:user/terraform-modules.git//vpc
        Initializes from a Git module source.

    .EXAMPLE
        tgifm ./modules/vpc
        Initializes from local module using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgifm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ModuleSource,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('init-from-module')
    if ($ModuleSource) {
        $allArgs += $ModuleSource
    }
    if ($Arguments) {
        $allArgs += $Arguments
    }

    & terragrunt @allArgs
}

function Invoke-TerragruntPlan {
    <#
    .SYNOPSIS
        Create Terragrunt execution plan.

    .DESCRIPTION
        Creates an execution plan showing what actions Terragrunt will take.
        Equivalent to 'terragrunt plan' or 'tgp' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt plan.

    .EXAMPLE
        Invoke-TerragruntPlan
        Creates an execution plan.

    .EXAMPLE
        tgp --terragrunt-non-interactive
        Creates plan non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('plan') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntPlanAll {
    <#
    .SYNOPSIS
        Create execution plan for all Terragrunt modules.

    .DESCRIPTION
        Creates execution plans for all Terragrunt modules in the dependency tree.
        Equivalent to 'terragrunt plan-all' or 'tgpa' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt plan-all.

    .EXAMPLE
        Invoke-TerragruntPlanAll
        Plans all modules in dependency order.

    .EXAMPLE
        tgpa --terragrunt-parallelism 5
        Plans all modules with custom parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgpa")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('plan-all') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntApply {
    <#
    .SYNOPSIS
        Apply Terragrunt configuration.

    .DESCRIPTION
        Builds or changes infrastructure according to Terragrunt configuration.
        Equivalent to 'terragrunt apply' or 'tga' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt apply.

    .EXAMPLE
        Invoke-TerragruntApply
        Applies the configuration with confirmation.

    .EXAMPLE
        tga --terragrunt-non-interactive
        Applies non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tga")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('apply') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntApplyAll {
    <#
    .SYNOPSIS
        Apply all Terragrunt modules.

    .DESCRIPTION
        Applies all Terragrunt modules in the dependency tree in the correct order.
        Equivalent to 'terragrunt apply-all' or 'tgaa' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt apply-all.

    .EXAMPLE
        Invoke-TerragruntApplyAll
        Applies all modules in dependency order.

    .EXAMPLE
        tgaa --terragrunt-parallelism 3
        Applies all modules with limited parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgaa")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('apply-all') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntRefresh {
    <#
    .SYNOPSIS
        Refresh Terragrunt state.

    .DESCRIPTION
        Updates the Terragrunt state to match the real infrastructure.
        Equivalent to 'terragrunt refresh' or 'tgr' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt refresh.

    .EXAMPLE
        Invoke-TerragruntRefresh
        Refreshes the current module state.

    .EXAMPLE
        tgr --terragrunt-non-interactive
        Refreshes non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('refresh') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntRefreshAll {
    <#
    .SYNOPSIS
        Refresh all Terragrunt module states.

    .DESCRIPTION
        Updates the state for all Terragrunt modules to match real infrastructure.
        Equivalent to 'terragrunt refresh-all' or 'tgra' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt refresh-all.

    .EXAMPLE
        Invoke-TerragruntRefreshAll
        Refreshes state for all modules.

    .EXAMPLE
        tgra --terragrunt-parallelism 5
        Refreshes all modules with custom parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgra")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('refresh-all') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntDestroy {
    <#
    .SYNOPSIS
        Destroy Terragrunt-managed infrastructure.

    .DESCRIPTION
        Destroys the infrastructure managed by Terragrunt.
        Equivalent to 'terragrunt destroy' or 'tgd' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt destroy.

    .EXAMPLE
        Invoke-TerragruntDestroy
        Destroys infrastructure with confirmation.

    .EXAMPLE
        tgd --terragrunt-non-interactive
        Destroys non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('destroy') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntDestroyAll {
    <#
    .SYNOPSIS
        Destroy all Terragrunt-managed infrastructure.

    .DESCRIPTION
        Destroys all infrastructure managed by Terragrunt modules in reverse dependency order.
        Equivalent to 'terragrunt destroy-all' or 'tgda' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt destroy-all.

    .EXAMPLE
        Invoke-TerragruntDestroyAll
        Destroys all modules in reverse dependency order.

    .EXAMPLE
        tgda --terragrunt-parallelism 3
        Destroys all modules with limited parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgda")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('destroy-all') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntFormat {
    <#
    .SYNOPSIS
        Format Terragrunt HCL files.

    .DESCRIPTION
        Formats Terragrunt HCL files to canonical format and style.
        Equivalent to 'terragrunt hclfmt' or 'tgf'/'tgfmt' shortcuts.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt hclfmt.

    .EXAMPLE
        Invoke-TerragruntFormat
        Formats HCL files in current directory.

    .EXAMPLE
        tgf --terragrunt-hclfmt-file terragrunt.hcl
        Formats specific file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgf", "tgfmt")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('hclfmt') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntFormatHCL {
    <#
    .SYNOPSIS
        Format HCL files with Terragrunt.

    .DESCRIPTION
        Alias for Invoke-TerragruntFormat. Formats Terragrunt HCL files.
        Equivalent to 'terragrunt hclfmt'.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt hclfmt.

    .EXAMPLE
        Invoke-TerragruntFormatHCL
        Formats HCL files in current directory.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    Invoke-TerragruntFormat @Arguments
}

function Invoke-TerragruntValidate {
    <#
    .SYNOPSIS
        Validate Terragrunt configuration.

    .DESCRIPTION
        Validates the Terragrunt configuration files in the current directory.
        Equivalent to 'terragrunt validate' or 'tgv' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt validate.

    .EXAMPLE
        Invoke-TerragruntValidate
        Validates current Terragrunt configuration.

    .EXAMPLE
        tgv --terragrunt-non-interactive
        Validates non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('validate') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntValidateAll {
    <#
    .SYNOPSIS
        Validate all Terragrunt configurations.

    .DESCRIPTION
        Validates all Terragrunt configuration files in the dependency tree.
        Equivalent to 'terragrunt validate-all' or 'tgva' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt validate-all.

    .EXAMPLE
        Invoke-TerragruntValidateAll
        Validates all module configurations.

    .EXAMPLE
        tgva --terragrunt-parallelism 5
        Validates all modules with custom parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgva")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('validate-all') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntValidateInputs {
    <#
    .SYNOPSIS
        Validate Terragrunt input variables.

    .DESCRIPTION
        Validates that all required input variables are provided for Terragrunt modules.
        Equivalent to 'terragrunt validate-inputs' or 'tgvi' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt validate-inputs.

    .EXAMPLE
        Invoke-TerragruntValidateInputs
        Validates input variables for current module.

    .EXAMPLE
        tgvi --terragrunt-non-interactive
        Validates inputs non-interactively using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgvi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('validate-inputs') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntRenderJSON {
    <#
    .SYNOPSIS
        Render Terragrunt configuration as JSON.

    .DESCRIPTION
        Renders the final Terragrunt configuration as JSON, useful for debugging.
        Equivalent to 'terragrunt render-json' or 'tgrj' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt render-json.

    .EXAMPLE
        Invoke-TerragruntRenderJSON
        Renders current configuration as JSON.

    .EXAMPLE
        tgrj --terragrunt-json-out config.json
        Renders to specific output file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgrj")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('render-json') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntGraphDependencies {
    <#
    .SYNOPSIS
        Generate dependency graph.

    .DESCRIPTION
        Generates a dependency graph of all Terragrunt modules.
        Equivalent to 'terragrunt graph-dependencies' or 'tggd' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt graph-dependencies.

    .EXAMPLE
        Invoke-TerragruntGraphDependencies
        Generates dependency graph.

    .EXAMPLE
        tggd --terragrunt-graph-root /path/to/root
        Generates graph from specific root using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tggd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('graph-dependencies') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntOutputAll {
    <#
    .SYNOPSIS
        Get outputs from all Terragrunt modules.

    .DESCRIPTION
        Retrieves outputs from all Terragrunt modules in the dependency tree.
        Equivalent to 'terragrunt output-all' or 'tgo' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt output-all.

    .EXAMPLE
        Invoke-TerragruntOutputAll
        Gets outputs from all modules.

    .EXAMPLE
        tgo --terragrunt-parallelism 3
        Gets outputs with limited parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgo")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('output-all') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntOutputModuleGroups {
    <#
    .SYNOPSIS
        Get outputs organized by module groups.

    .DESCRIPTION
        Retrieves outputs from Terragrunt modules organized by their groups.
        Equivalent to 'terragrunt output-module-groups' or 'tgomg' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt output-module-groups.

    .EXAMPLE
        Invoke-TerragruntOutputModuleGroups
        Gets outputs organized by module groups.

    .EXAMPLE
        tgomg --terragrunt-parallelism 5
        Gets grouped outputs with custom parallelism using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgomg")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('output-module-groups') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntStateList {
    <#
    .SYNOPSIS
        List resources in Terragrunt state.

    .DESCRIPTION
        Lists resources in the Terragrunt state file.
        Equivalent to 'terragrunt state list' or 'tgsl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt state list.

    .EXAMPLE
        Invoke-TerragruntStateList
        Lists all resources in state.

    .EXAMPLE
        tgsl
        Lists resources using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgsl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('state', 'list') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntStateShow {
    <#
    .SYNOPSIS
        Show specific resource in Terragrunt state.

    .DESCRIPTION
        Shows detailed information about a specific resource in the Terragrunt state.
        Equivalent to 'terragrunt state show' or 'tgss' shortcut.

    .PARAMETER ResourceAddress
        The address of the resource to show.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt state show.

    .EXAMPLE
        Invoke-TerragruntStateShow aws_instance.example
        Shows detailed information about the specified resource.

    .EXAMPLE
        tgss module.vpc.aws_vpc.main
        Shows module resource using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgss")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$ResourceAddress,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('state', 'show', $ResourceAddress) + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntStateMv {
    <#
    .SYNOPSIS
        Move resource in Terragrunt state.

    .DESCRIPTION
        Moves a resource from one address to another in the Terragrunt state.
        Equivalent to 'terragrunt state mv' or 'tgsm' shortcut.

    .PARAMETER SourceAddress
        The current address of the resource.

    .PARAMETER DestinationAddress
        The new address for the resource.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt state mv.

    .EXAMPLE
        Invoke-TerragruntStateMv aws_instance.old aws_instance.new
        Moves resource from old address to new address.

    .EXAMPLE
        tgsm module.old.aws_instance.web module.new.aws_instance.web
        Moves module resource using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgsm")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$SourceAddress,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]$DestinationAddress,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('state', 'mv', $SourceAddress, $DestinationAddress) + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntStateRm {
    <#
    .SYNOPSIS
        Remove resource from Terragrunt state.

    .DESCRIPTION
        Removes one or more resources from the Terragrunt state.
        Equivalent to 'terragrunt state rm' or 'tgsr' shortcut.

    .PARAMETER ResourceAddress
        The address of the resource to remove.

    .PARAMETER Arguments
        Additional resource addresses and arguments.

    .EXAMPLE
        Invoke-TerragruntStateRm aws_instance.example
        Removes resource from state.

    .EXAMPLE
        tgsr module.vpc.aws_vpc.main
        Removes module resource using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgsr")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$ResourceAddress,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('state', 'rm', $ResourceAddress) + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntShow {
    <#
    .SYNOPSIS
        Show Terragrunt state or plan.

    .DESCRIPTION
        Displays human-readable output from a state or plan file.
        Equivalent to 'terragrunt show' or 'tgsh' shortcut.

    .PARAMETER Arguments
        Path to state/plan file or additional arguments.

    .EXAMPLE
        Invoke-TerragruntShow
        Shows current state.

    .EXAMPLE
        tgsh tfplan
        Shows saved plan file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgsh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('show') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntProviders {
    <#
    .SYNOPSIS
        Show Terragrunt provider information.

    .DESCRIPTION
        Displays information about the providers used in Terragrunt configuration.
        Equivalent to 'terragrunt providers' or 'tgpv' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt providers.

    .EXAMPLE
        Invoke-TerragruntProviders
        Shows provider information.

    .EXAMPLE
        tgpv lock
        Updates provider lock file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgpv")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('providers') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntGet {
    <#
    .SYNOPSIS
        Download and update Terragrunt modules.

    .DESCRIPTION
        Downloads and updates modules referenced in Terragrunt configuration.
        Equivalent to 'terragrunt get' or 'tgget' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt get.

    .EXAMPLE
        Invoke-TerragruntGet
        Downloads and updates modules.

    .EXAMPLE
        tgget -update
        Updates modules using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgget")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('get') + $Arguments
    & terragrunt @allArgs
}

function Invoke-TerragruntVersion {
    <#
    .SYNOPSIS
        Show Terragrunt version.

    .DESCRIPTION
        Displays the version of Terragrunt and Terraform.
        Equivalent to 'terragrunt --version' or 'tgver' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to terragrunt version.

    .EXAMPLE
        Invoke-TerragruntVersion
        Shows Terragrunt and Terraform versions.

    .EXAMPLE
        tgver
        Shows version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md
    #>
    [CmdletBinding()]
    [Alias("tgver")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('--version') + $Arguments
    & terragrunt @allArgs
}
