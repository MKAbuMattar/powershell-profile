@{
    RootModule        = 'GCP.psm1'
    ModuleVersion     = '5.1.0'
    CompatiblePSEditions = @(
        'Core'
    )
    GUID              = 'f7b8c9d0-e1f2-4a5b-8c6d-9e0f1a2b3c4d'
    Author            = 'MKAbuMattar'
    CompanyName       = 'Personal'
    Copyright         = '(c) 2025 MKAbuMattar. All rights reserved.'
    Description       = 'Google Cloud Platform CLI integration plugin for PowerShell'
    PowerShellVersion = '7.0'
    RequiredModules   = @()
    FunctionsToExport = @(
        'Initialize-GCloudTool',
        'Get-GCloudInfo',
        'Get-GCloudVersion',
        'Update-GCloudComponents',
        'Install-GCloudComponent',
        'Set-GCloudProject',
        'Get-GCloudCurrentProject',
        'Invoke-GCloudAuthLogin',
        'Get-GComputeInstances',
        'New-GComputeInstance',
        'Connect-GComputeSSH',
        'Invoke-GCloudAuth',
        'Invoke-GCloudCompute',
        'Invoke-GCloudContainer',
        'Invoke-GCloudApp',
        'Invoke-GCloudStorage',
        'Invoke-GCloudSQL',
        'Invoke-GCloudFunctions',
        'Invoke-GCloudRun',
        'Invoke-GCloudIAM',
        'Invoke-GCloudKMS',
        'Invoke-GCloudPubSub',
        'Set-GCloudProjectFromDirectory'
    )
    
    AliasesToExport   = @(
        'gcin',
        'gcinf',
        'gcv',
        'gccu',
        'gcci',
        'gccsp',
        'gcal',
        'gcpil',
        'gccc',
        'gcpssh',
        'gcco',
        'gca',
        'gccm',
        'gccnt',
        'gcapp',
        'gcst',
        'gcsql',
        'gcfn',
        'gcrun',
        'gciam',
        'gckms',
        'gcpub',
        'gcd'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('GCP', 
                'GoogleCloud', 
                'CLI', 
                'DevOps', 
                'CloudComputing')
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
}
