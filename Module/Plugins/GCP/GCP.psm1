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
#       This module provides Google Cloud Platform CLI shortcuts and utility functions
#       for Google Cloud services in PowerShell environments. Supports Compute Engine,
#       App Engine, IAM, Cloud Storage, and more with comprehensive workflow automation
#       in PowerShell environments.
#
# Created: 2025-09-28
# Updated: 2025-09-28
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Core gcloud Functions
#---------------------------------------------------------------------------------------------------
    
function Initialize-GCloudTool {
    <#
    .SYNOPSIS
        A PowerShell function that initializes, authorizes, and configures the gcloud tool.

    .DESCRIPTION
        This function runs 'gcloud init' to set up the Google Cloud SDK. It guides you through
        authentication and initial configuration including setting default project and region.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        The output of the gcloud init command.

    .EXAMPLE
        gcin
        Initializes gcloud using the alias.

        Initialize-GCloudTool
        Initializes gcloud using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Interactive command that requires user input.
    #>
    [CmdletBinding()]
    [Alias("gcin")]
    param()
    
    & gcloud init
}
    
function Get-GCloudInfo {
    <#
    .SYNOPSIS
        A PowerShell function that displays current gcloud tool environment details.

    .DESCRIPTION
        This function runs 'gcloud info' to display comprehensive information about the
        current gcloud installation, configuration, and environment settings.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        Detailed information about the gcloud environment.

    .EXAMPLE
        gcinf
        Displays gcloud info using the alias.

        Get-GCloudInfo
        Displays gcloud info using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides diagnostic information for troubleshooting.
    #>
    [CmdletBinding()]
    [Alias("gcinf")]
    param()
    
    & gcloud info
}
    
function Get-GCloudVersion {
    <#
    .SYNOPSIS
        A PowerShell function that displays version and installed components.

    .DESCRIPTION
        This function runs 'gcloud version' to display the current version of the
        Google Cloud SDK and all installed components.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        Version information for gcloud and its components.

    .EXAMPLE
        gcv
        Displays gcloud version using the alias.

        Get-GCloudVersion
        Displays gcloud version using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Shows versions of all installed gcloud components.
    #>
    [CmdletBinding()]
    [Alias("gcv")]
    param()
    
    & gcloud version
}
    
function Update-GCloudComponents {
    <#
    .SYNOPSIS
        A PowerShell function that updates the Cloud SDK to the latest version.

    .DESCRIPTION
        This function runs 'gcloud components update' to update all installed
        Google Cloud SDK components to their latest versions.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        Update progress and results.

    .EXAMPLE
        gccu
        Updates gcloud components using the alias.

        Update-GCloudComponents
        Updates gcloud components using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - May require administrator privileges depending on installation location.
    #>
    [CmdletBinding()]
    [Alias("gccu")]
    param()
    
    & gcloud components update
}

function Install-GCloudComponent {
    <#
    .SYNOPSIS
        A PowerShell function that installs specific gcloud components.

    .DESCRIPTION
        This function runs 'gcloud components install' to install one or more
        Google Cloud SDK components.

    .PARAMETER Components
        Array of component names to install.

    .INPUTS
        System.String[]. Array of component names.

    .OUTPUTS
        Installation progress and results.

    .EXAMPLE
        gcci kubectl
        Installs kubectl component using the alias.

        Install-GCloudComponent @('kubectl', 'docker-credential-gcloud')
        Installs multiple components using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - May require administrator privileges depending on installation location.
    #>
    [CmdletBinding()]
    [Alias("gcci")]
    param([string[]]$Components)
    
    & gcloud components install @Components
}
    
#---------------------------------------------------------------------------------------------------
# Configuration Management Functions
#---------------------------------------------------------------------------------------------------
    
function Set-GCloudProject {
    <#
    .SYNOPSIS
        A PowerShell function that sets a default Google Cloud project to work on.

    .DESCRIPTION
        This function sets the default project for gcloud operations using
        'gcloud config set project'. All subsequent gcloud commands will use
        this project unless overridden.

    .PARAMETER ProjectId
        The Google Cloud project ID to set as default.

    .INPUTS
        System.String. The project ID.

    .OUTPUTS
        Confirmation of project setting.

    .EXAMPLE
        gccsp my-project-id
        Sets the default project using the alias.

        Set-GCloudProject "production-app-12345"
        Sets the default project using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - The project must exist and you must have access to it.
    #>
    [CmdletBinding()]
    [Alias("gccsp")]
    param([string]$ProjectId)
    
    & gcloud config set project $ProjectId
}
    
function Get-GCloudCurrentProject {
    <#
    .SYNOPSIS
        A PowerShell function that gets the current project ID.

    .DESCRIPTION
        This function retrieves the currently configured default project ID
        from gcloud configuration.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.String. The current project ID.

    .EXAMPLE
        Get-GCloudCurrentProject
        Returns the current project ID.

        $project = Get-GCloudCurrentProject
        Stores the current project ID in a variable.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Returns empty string if no project is configured.
    #>
    [CmdletBinding()]
    param()
    
    & gcloud config get-value project
}

#---------------------------------------------------------------------------------------------------
# Authentication Functions
#---------------------------------------------------------------------------------------------------
    
function Invoke-GCloudAuthLogin {
    <#
    .SYNOPSIS
        A PowerShell function that authorizes Google Cloud access with user credentials.

    .DESCRIPTION
        This function runs 'gcloud auth login' to authenticate with Google Cloud
        using user credentials and set the current account as active.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        Authentication progress and results.

    .EXAMPLE
        gcal
        Authenticates with Google Cloud using the alias.

        Invoke-GCloudAuthLogin
        Authenticates with Google Cloud using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Opens a web browser for OAuth authentication flow.
    #>
    [CmdletBinding()]
    [Alias("gcal")]
    param()
    
    & gcloud auth login
}

#---------------------------------------------------------------------------------------------------
# Compute Engine Functions
#---------------------------------------------------------------------------------------------------
    
function Get-GComputeInstances {
    <#
    .SYNOPSIS
        A PowerShell function that lists all VM instances in a project.

    .DESCRIPTION
        This function runs 'gcloud compute instances list' to display all
        Compute Engine VM instances in the current project.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        List of VM instances with their details.

    .EXAMPLE
        gcpil
        Lists VM instances using the alias.

        Get-GComputeInstances
        Lists VM instances using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Requires a configured project and appropriate permissions.
    #>
    [CmdletBinding()]
    [Alias("gcpil")]
    param()
    
    & gcloud compute instances list
}

function New-GComputeInstance {
    <#
    .SYNOPSIS
        A PowerShell function that creates a new virtual machine instance.

    .DESCRIPTION
        This function creates a new Compute Engine VM instance with specified
        configuration options including machine type and zone.

    .PARAMETER InstanceName
        The name for the new VM instance.

    .PARAMETER MachineType
        The machine type for the VM instance.

    .PARAMETER Zone
        The zone where the instance will be created.

    .PARAMETER AdditionalArgs
        Additional arguments to pass to the gcloud command.

    .INPUTS
        System.String. Instance configuration parameters.

    .OUTPUTS
        VM instance creation progress and results.

    .EXAMPLE
        gccc my-vm --machine-type e2-micro --zone us-central1-a
        Creates a VM instance using the alias.

        New-GComputeInstance -InstanceName "web-server" -MachineType "e2-medium" -Zone "us-west1-b"
        Creates a VM instance using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Requires appropriate permissions to create VM instances.
    #>
    [CmdletBinding()]
    [Alias("gccc")]
    param(
        [Parameter(Mandatory)]
        [string]$InstanceName,
        [string]$MachineType,
        [string]$Zone,
        [string[]]$AdditionalArgs
    )
    $cmdArgs = @('compute', 'instances', 'create', $InstanceName)
    if ($MachineType) { $cmdArgs += "--machine-type=$MachineType" }
    if ($Zone) { $cmdArgs += "--zone=$Zone" }
    if ($AdditionalArgs) { $cmdArgs += $AdditionalArgs }
    
    & gcloud @cmdArgs
}

function Connect-GComputeSSH {
    <#
    .SYNOPSIS
        A PowerShell function that connects to a VM instance using SSH.

    .DESCRIPTION
        This function establishes an SSH connection to a Compute Engine VM instance
        using 'gcloud compute ssh'.

    .PARAMETER InstanceName
        The name of the VM instance to connect to.

    .PARAMETER Zone
        The zone of the VM instance.

    .PARAMETER AdditionalArgs
        Additional arguments to pass to the SSH command.

    .INPUTS
        System.String. SSH connection parameters.

    .OUTPUTS
        SSH session to the VM instance.

    .EXAMPLE
        gcpssh my-vm --zone us-central1-a
        Connects to VM using the alias.

        Connect-GComputeSSH -InstanceName "web-server" -Zone "us-west1-b"
        Connects to VM using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Requires SSH access to be configured on the VM instance.
    #>
    [CmdletBinding()]
    [Alias("gcpssh", "gcco")]
    param(
        [Parameter(Mandatory)]
        [string]$InstanceName,
        [string]$Zone,
        [string[]]$AdditionalArgs
    )
    $cmdArgs = @('compute', 'ssh', $InstanceName)
    if ($Zone) { $cmdArgs += "--zone=$Zone" }
    if ($AdditionalArgs) { $cmdArgs += $AdditionalArgs }
    
    & gcloud @cmdArgs
}

#---------------------------------------------------------------------------------------------------
# Service Shortcuts Functions
#---------------------------------------------------------------------------------------------------
    
function Invoke-GCloudAuth {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud authentication commands.

    .DESCRIPTION
        This function provides access to all 'gcloud auth' commands for managing
        authentication and authorization with Google Cloud services.

    .INPUTS
        Arguments passed to gcloud auth commands.

    .OUTPUTS
        Output from gcloud auth commands.

    .EXAMPLE
        gca list
        Lists authenticated accounts using the alias.

        Invoke-GCloudAuth list
        Lists authenticated accounts using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to login, logout, list, and other auth operations.
    #>
    [CmdletBinding()]
    [Alias("gca")]
    param()
    
    & gcloud auth @args
}

function Invoke-GCloudCompute {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud Compute Engine commands.

    .DESCRIPTION
        This function provides access to all 'gcloud compute' commands for managing
        Compute Engine resources including instances, disks, networks, and more.

    .INPUTS
        Arguments passed to gcloud compute commands.

    .OUTPUTS
        Output from gcloud compute commands.

    .EXAMPLE
        gccm instances list
        Lists compute instances using the alias.

        Invoke-GCloudCompute instances list
        Lists compute instances using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to all Compute Engine management operations.
    #>
    [CmdletBinding()]
    [Alias("gccm")]
    param()
    
    & gcloud compute @args
}

function Invoke-GCloudContainer {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud Container and GKE commands.

    .DESCRIPTION
        This function provides access to all 'gcloud container' commands for managing
        Google Kubernetes Engine clusters and container operations.

    .INPUTS
        Arguments passed to gcloud container commands.

    .OUTPUTS
        Output from gcloud container commands.

    .EXAMPLE
        gccnt clusters list
        Lists GKE clusters using the alias.

        Invoke-GCloudContainer clusters list
        Lists GKE clusters using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to GKE cluster and container management.
    #>
    [CmdletBinding()]
    [Alias("gccnt")]
    param()
    
    & gcloud container @args
}

function Invoke-GCloudApp {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud App Engine commands.

    .DESCRIPTION
        This function provides access to all 'gcloud app' commands for managing
        App Engine applications and services.

    .INPUTS
        Arguments passed to gcloud app commands.

    .OUTPUTS
        Output from gcloud app commands.

    .EXAMPLE
        gca deploy
        Deploys App Engine application using the alias.

        Invoke-GCloudApp deploy
        Deploys App Engine application using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to App Engine deployment and management.
    #>
    [CmdletBinding()]
    [Alias("gcapp")]
    param()
    
    & gcloud app @args
}

function Invoke-GCloudStorage {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud Storage commands.

    .DESCRIPTION
        This function provides access to all 'gcloud storage' commands for managing
        Cloud Storage buckets and objects.

    .INPUTS
        Arguments passed to gcloud storage commands.

    .OUTPUTS
        Output from gcloud storage commands.

    .EXAMPLE
        gcst ls gs://my-bucket
        Lists storage bucket contents using the alias.

        Invoke-GCloudStorage ls gs://my-bucket
        Lists storage bucket contents using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to Cloud Storage operations.
    #>
    [CmdletBinding()]
    [Alias("gcst")]
    param()
    
    & gcloud storage @args
}

function Invoke-GCloudSQL {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud SQL commands.

    .DESCRIPTION
        This function provides access to all 'gcloud sql' commands for managing
        Cloud SQL databases and instances.

    .INPUTS
        Arguments passed to gcloud sql commands.

    .OUTPUTS
        Output from gcloud sql commands.

    .EXAMPLE
        gcsql instances list
        Lists SQL instances using the alias.

        Invoke-GCloudSQL instances list
        Lists SQL instances using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to Cloud SQL management operations.
    #>
    [CmdletBinding()]
    [Alias("gcsql")]
    param()
    
    & gcloud sql @args
}

function Invoke-GCloudFunctions {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud Functions commands.

    .DESCRIPTION
        This function provides access to all 'gcloud functions' commands for managing
        Cloud Functions deployments and operations.

    .INPUTS
        Arguments passed to gcloud functions commands.

    .OUTPUTS
        Output from gcloud functions commands.

    .EXAMPLE
        gcfn deploy my-function
        Deploys a Cloud Function using the alias.

        Invoke-GCloudFunctions deploy my-function
        Deploys a Cloud Function using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to Cloud Functions management.
    #>
    [CmdletBinding()]
    [Alias("gcfn")]
    param()
    
    & gcloud functions @args
}

function Invoke-GCloudRun {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud Run commands.

    .DESCRIPTION
        This function provides access to all 'gcloud run' commands for managing
        Cloud Run services and deployments.

    .INPUTS
        Arguments passed to gcloud run commands.

    .OUTPUTS
        Output from gcloud run commands.

    .EXAMPLE
        gcrun deploy my-service
        Deploys a Cloud Run service using the alias.

        Invoke-GCloudRun deploy my-service
        Deploys a Cloud Run service using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to Cloud Run serverless container management.
    #>
    [CmdletBinding()]
    [Alias("gcrun")]
    param()
    
    & gcloud run @args
}

function Invoke-GCloudIAM {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud IAM commands.

    .DESCRIPTION
        This function provides access to all 'gcloud iam' commands for managing
        Identity and Access Management policies and service accounts.

    .INPUTS
        Arguments passed to gcloud iam commands.

    .OUTPUTS
        Output from gcloud iam commands.

    .EXAMPLE
        gciam service-accounts list
        Lists service accounts using the alias.

        Invoke-GCloudIAM service-accounts list
        Lists service accounts using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to IAM management operations.
    #>
    [CmdletBinding()]
    [Alias("gciam")]
    param()
    
    & gcloud iam @args
}

function Invoke-GCloudKMS {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud KMS commands.

    .DESCRIPTION
        This function provides access to all 'gcloud kms' commands for managing
        Key Management Service keys and cryptographic operations.

    .INPUTS
        Arguments passed to gcloud kms commands.

    .OUTPUTS
        Output from gcloud kms commands.

    .EXAMPLE
        gckms keys list --location global --keyring my-ring
        Lists KMS keys using the alias.

        Invoke-GCloudKMS keys list --location global --keyring my-ring
        Lists KMS keys using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to Key Management Service operations.
    #>
    [CmdletBinding()]
    [Alias("gckms")]
    param()
    
    & gcloud kms @args
}

function Invoke-GCloudPubSub {
    <#
    .SYNOPSIS
        A PowerShell function for Google Cloud Pub/Sub commands.

    .DESCRIPTION
        This function provides access to all 'gcloud pubsub' commands for managing
        Pub/Sub topics, subscriptions, and messaging operations.

    .INPUTS
        Arguments passed to gcloud pubsub commands.

    .OUTPUTS
        Output from gcloud pubsub commands.

    .EXAMPLE
        gcpub topics list
        Lists Pub/Sub topics using the alias.

        Invoke-GCloudPubSub topics list
        Lists Pub/Sub topics using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Provides access to Pub/Sub messaging operations.
    #>
    [CmdletBinding()]
    [Alias("gcpub")]
    param()
    
    & gcloud pubsub @args
}

#---------------------------------------------------------------------------------------------------
# Utility Functions
#---------------------------------------------------------------------------------------------------
    
function Set-GCloudProjectFromDirectory {
    <#
    .SYNOPSIS
        A PowerShell function that sets the default project to match current directory name.

    .DESCRIPTION
        This function attempts to set the default Google Cloud project based on the
        current directory name. It searches for projects matching the directory name
        and sets the first match as the default project.

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        Success or warning message about project setting.

    .EXAMPLE
        gcd
        Sets project from directory name using the alias.

        Set-GCloudProjectFromDirectory
        Sets project from directory name using the full function name.

    .NOTES
        - This function requires gcloud CLI to be installed and in PATH.
        - Searches for projects with names matching the current directory.
        - Shows warning if no matching project is found.
    #>
    [CmdletBinding()]
    [Alias("gcd")]
    param()
    $dirName = Split-Path -Leaf (Get-Location)
    $projects = gcloud projects list --format="value(projectId)" --filter="name:$dirName"
    if ($projects) {
        gcloud config set project $projects[0]
        Write-Host "Set project to: $($projects[0])" -ForegroundColor Green
    }
    else {
        Write-Warning "No project found matching directory name: $dirName"
    }
}
