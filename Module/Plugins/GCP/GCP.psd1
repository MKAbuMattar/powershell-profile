@{
    RootModule        = 'GCP.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'f7b8c9d0-e1f2-4a5b-8c6d-9e0f1a2b3c4d'
    Author            = 'MKAbuMattar'
    CompanyName       = 'Personal'
    Copyright         = '(c) 2025 MKAbuMattar. All rights reserved.'
    Description       = 'Google Cloud Platform CLI integration plugin for PowerShell'
    
    PowerShellVersion = '5.1'
    
    RequiredModules   = @()
    
    FunctionsToExport = @(
        # Core gcloud commands
        'Invoke-GCloud',
        'Initialize-GCloudTool',
        'Get-GCloudInfo',
        'Get-GCloudVersion',
        'Update-GCloudComponents',
        
        # Component management
        'Install-GCloudComponent',
        
        # Configuration management
        'Set-GCloudProject',
        'Activate-GCloudConfiguration',
        'New-GCloudConfiguration',
        'Get-GCloudConfigurations',
        'Get-GCloudConfigValue',
        'Get-GCloudConfigList',
        'Set-GCloudConfig',
        'Set-GCloudAccount',
        
        # Authentication
        'Invoke-GCloudAuthLogin',
        'Get-GCloudAuthList',
        'Get-GCloudAccessToken',
        'Revoke-GCloudAuth',
        'Enable-GCloudServiceAccount',
        'Enable-GCloudDockerAuth',
        
        # IAM
        'Get-GCloudServiceAccountKeys',
        'Get-GCloudGrantableRoles',
        'Add-GCloudIAMPolicyBinding',
        'New-GCloudIAMRole',
        'Set-GCloudServiceAccountPolicy',
        'New-GCloudServiceAccount',
        
        # Projects
        'Add-GCloudProjectIAMBinding',
        'Get-GCloudProjectDescription',
        
        # Container/GKE
        'New-GKECluster',
        'Get-GKECredentials',
        'Get-GKEClusters',
        'Get-GContainerImageTags',
        
        # Compute Engine
        'Copy-GComputeFiles',
        'Stop-GComputeInstance',
        'New-GComputeSnapshot',
        'Get-GComputeInstanceDescription',
        'Get-GComputeInstances',
        'Remove-GComputeInstance',
        'Remove-GComputeSnapshot',
        'Connect-GComputeSSH',
        'Start-GComputeInstance',
        'Get-GComputeZones',
        'New-GComputeInstance',
        'Get-GComputeAddresses',
        'Get-GComputeAddressDescription',
        
        # App Engine
        'Open-GAppEngine',
        'New-GAppEngine',
        'Deploy-GAppEngine',
        'Get-GAppEngineLogs',
        'Get-GAppEngineVersions',
        
        # Additional services
        'Invoke-GCloudKMSDecrypt',
        'Get-GCloudLogs',
        'Get-GSQLBackupDescription',
        'Export-GSQLData',
        
        # Service shortcuts
        'Invoke-GCloudAuth',
        'Invoke-GCloudBeta',
        'Invoke-GCloudBuilds',
        'Invoke-GCloudDatastore',
        'Invoke-GCloudDataproc',
        'Invoke-GCloudEndpoints',
        'Invoke-GCloudEventarc',
        'Invoke-GCloudFunctions',
        'Invoke-GCloudIAM',
        'Invoke-GCloudIoT',
        'Invoke-GCloudKMS',
        'Invoke-GCloudLogging',
        'Invoke-GCloudMonitoring',
        'Invoke-GCloudNetworks',
        'Invoke-GCloudProjects',
        'Invoke-GCloudPubSub',
        'Remove-GContainerImage',
        'Invoke-GCloudResourceManager',
        'Invoke-GCloudRun',
        'Invoke-GCloudSource',
        'Invoke-GCloudOrganizations',
        'Invoke-GCloudSQL',
        'Invoke-GCloudStorage',
        'Invoke-GCloudServices',
        'Invoke-GCloudTasks',
        
        # Utility functions
        'Test-GCloudInstalled',
        'Get-GCloudCurrentProject',
        'Set-GCloudProjectFromDirectory'
    )
    
    AliasesToExport   = @(
        # Core commands
        'gcloud', 'gc',
        'gci', 'gcinf', 'gcv', 'gccu',
        
        # Components
        'gcci',
        
        # Configuration
        'gccsp', 'gccca', 'gcccc', 'gcccl', 'gccgv', 'gccl', 'gccs', 'gcsa', 'gck',
        
        # Authentication
        'gcal', 'gcapat', 'gcar', 'gcaasa', 'gcacd',
        
        # IAM
        'gciamk', 'gciaml', 'gciamp', 'gciamr', 'gciams', 'gciamv',
        
        # Projects
        'gcpa', 'gcpd', 'gcp', 'gcpd',
        
        # Container/GKE
        'gcccc', 'gcccg', 'gcccl', 'gccil', 'gcs',
        
        # Compute Engine
        'gcpc', 'gcpdown', 'gcpds', 'gcpid', 'gcpil', 'gcprm', 'gcpsk', 'gcpssh', 'gcpup', 'gcpzl',
        'gccc', 'gcca', 'gcpha', 'gcco',
        
        # App Engine
        'gcapb', 'gcapc', 'gcapd', 'gcapl', 'gcapv', 'gcu',
        
        # Additional services
        'gckmsd', 'gclll', 'gcsqlb', 'gcsqle',
        
        # Service shortcuts
        'gca', 'gcb', 'gcdb', 'gcdp', 'gce', 'gcem', 'gcf', 'gci', 'gcic', 'gcir', 'gcki', 'gcla',
        'gcma', 'gcn', 'gcps', 'gcr', 'gcrm', 'gcro', 'gcsc', 'gcso', 'gcsq', 'gcss', 'gcst', 'gct',
        
        # Utilities
        'gcd'
    )
    
    CmdletsToExport   = @()
    VariablesToExport = @()
    
    PrivateData       = @{
        PSData = @{
            Tags       = @('GCP', 'GoogleCloud', 'CLI', 'DevOps', 'CloudComputing')
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
}
