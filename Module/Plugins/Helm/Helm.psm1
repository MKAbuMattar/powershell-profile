#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Helm Plugin
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
#       This module provides Helm CLI shortcuts and utility functions for improved
#       Kubernetes package management workflow in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

$script:HelmCompletionInitialized = $false

function Invoke-Helm {
    <#
    .SYNOPSIS
        A PowerShell function that wraps the Helm command.

    .DESCRIPTION
        This function provides a direct wrapper for Helm commands, the package manager for Kubernetes.
        It passes all arguments directly to the Helm CLI and supports all Helm commands and options.
        This is the base function that other Helm functions build upon.

    .PARAMETER Arguments
        All arguments to pass to the Helm command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function executes Helm commands but does not return objects.

    .EXAMPLE
        h version
        Shows the Helm version using the alias.

        Invoke-Helm --help
        Displays Helm help using the full function name.

        h repo list
        Lists all configured Helm repositories.

    .NOTES
        - Requires Helm to be installed and accessible via PATH.
        - All Helm commands and options are supported.
        - This is the base function that other Helm wrapper functions use.
    #>
    [Alias("h")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    if ($Arguments) {
        & helm $Arguments
    }
    else {
        & helm
    }
}

function Invoke-HelmInstall {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `helm install`.

    .DESCRIPTION
        This function installs Helm charts into Kubernetes clusters. It's equivalent to running
        'helm install' with all the provided arguments. This command deploys applications
        using Helm charts and manages the installation lifecycle.

    .PARAMETER Arguments
        All arguments to pass to the Helm install command, including release name and chart.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function installs Helm charts but does not return objects.

    .EXAMPLE
        hin my-release stable/nginx
        Installs nginx chart as 'my-release' using the alias.

        Invoke-HelmInstall my-app ./my-chart
        Installs a local chart using the full function name.

        hin my-release stable/mysql --set mysqlRootPassword=secret
        Installs MySQL chart with custom root password.

    .NOTES
        - Requires Helm to be installed and accessible via PATH.
        - Must have access to a Kubernetes cluster with proper RBAC permissions.
        - Supports all helm install options like --values, --set, --namespace, etc.
        - Creates a new release in the current or specified namespace.
    #>
    [Alias("hin")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & helm install $Arguments
}

function Invoke-HelmUninstall {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `helm uninstall`.

    .DESCRIPTION
        This function uninstalls Helm releases from Kubernetes clusters. It's equivalent to running
        'helm uninstall' with all the provided arguments. This command removes deployed applications
        and cleans up associated Kubernetes resources.

    .PARAMETER Arguments
        All arguments to pass to the Helm uninstall command, including release name.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function uninstalls Helm releases but does not return objects.

    .EXAMPLE
        hun my-release
        Uninstalls the 'my-release' Helm release using the alias.

        Invoke-HelmUninstall my-app --keep-history
        Uninstalls release but keeps history using the full function name.

        hun my-release --namespace production
        Uninstalls release from the production namespace.

    .NOTES
        - Requires Helm to be installed and accessible via PATH.
        - Must have access to a Kubernetes cluster with proper RBAC permissions.
        - By default, removes all associated Kubernetes resources.
        - Use --keep-history to preserve release history for rollback purposes.
    #>
    [Alias("hun")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & helm uninstall $Arguments
}

function Invoke-HelmSearch {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `helm search`.

    .DESCRIPTION
        This function searches for Helm charts in repositories or hubs. It's equivalent to running
        'helm search' with all the provided arguments. This command helps discover available
        charts for deployment and provides information about chart versions and descriptions.

    .PARAMETER Arguments
        All arguments to pass to the Helm search command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function searches for charts but does not return objects.

    .EXAMPLE
        hse repo nginx
        Searches for nginx charts in configured repositories using the alias.

        Invoke-HelmSearch hub wordpress
        Searches for WordPress charts in Helm Hub using the full function name.

        hse repo --versions mysql
        Searches for MySQL charts showing all available versions.

    .NOTES
        - Requires Helm to be installed and accessible via PATH.
        - 'helm search repo' searches in configured repositories.
        - 'helm search hub' searches in the public Helm Hub.
        - Use --versions flag to see all available chart versions.
        - Results show chart name, version, app version, and description.
    #>
    [Alias("hse")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & helm search $Arguments
}

function Invoke-HelmUpgrade {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `helm upgrade`.

    .DESCRIPTION
        This function upgrades existing Helm releases to new versions. It's equivalent to running
        'helm upgrade' with all the provided arguments. This command updates deployed applications
        with new chart versions or configuration changes while maintaining release history.

    .PARAMETER Arguments
        All arguments to pass to the Helm upgrade command, including release name and chart.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function upgrades Helm releases but does not return objects.

    .EXAMPLE
        hup my-release stable/nginx
        Upgrades 'my-release' to the latest nginx chart using the alias.

        Invoke-HelmUpgrade my-app ./my-chart --install
        Upgrades or installs if not exists using the full function name.

        hup my-release stable/mysql --set mysqlRootPassword=newsecret
        Upgrades MySQL release with new root password.

    .NOTES
        - Requires Helm to be installed and accessible via PATH.
        - Must have access to a Kubernetes cluster with proper RBAC permissions.
        - Maintains release history for rollback capabilities.
        - Use --install flag to install if release doesn't exist.
        - Supports all helm upgrade options like --values, --set, --force, etc.
    #>
    [Alias("hup")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & helm upgrade $Arguments
}
