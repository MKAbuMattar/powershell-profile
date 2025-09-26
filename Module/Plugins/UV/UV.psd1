@{
    RootModule             = 'UV.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @(
        'Desktop', 
        'Core'
    )
    GUID                   = 'a8f7b2c3-4d5e-6f7a-8b9c-0d1e2f3a4b5c'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'Comprehensive UV (Python package manager) CLI integration with PowerShell functions and convenient aliases for modern Python dependency management, virtual environment handling, and project workflows.'
    PowerShellVersion      = '5.0'
    PowerShellHostName     = ''
    PowerShellHostVersion  = ''
    DotNetFrameworkVersion = ''
    CLRVersion             = ''
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @(
        'Test-UVInstalled',
        'Initialize-UVCompletion',
        'Invoke-UV',
        'Invoke-UVAdd',
        'Invoke-UVExport',
        'Invoke-UVLock',
        'Invoke-UVLockRefresh',
        'Invoke-UVLockUpgrade',
        'Invoke-UVPip',
        'Invoke-UVPython',
        'Invoke-UVRun',
        'Invoke-UVRemove',
        'Invoke-UVSync',
        'Invoke-UVSyncRefresh',
        'Invoke-UVSyncUpgrade',
        'Invoke-UVSelfUpdate',
        'Invoke-UVVenv',
        'Invoke-UVVersion',
        'Invoke-UVInit',
        'Invoke-UVBuild',
        'Invoke-UVPublish',
        'Invoke-UVTool',
        'Invoke-UVToolRun',
        'Invoke-UVToolInstall',
        'Invoke-UVToolUninstall',
        'Invoke-UVToolList',
        'Invoke-UVToolUpgrade',
        'Get-UVProjectInfo',
        'Get-UVVirtualEnvPath',
        'Test-UVProject'
    )
    CmdletsToExport        = @()
    VariablesToExport      = ''
    AliasesToExport        = @(
        'uv',
        'uva',
        'uvexp',
        'uvl',
        'uvlr',
        'uvlu',
        'uvp',
        'uvpy',
        'uvr',
        'uvrm',
        'uvs',
        'uvsr',
        'uvsu',
        'uvup',
        'uvv',
        'uvver',
        'uvi',
        'uvb',
        'uvpub',
        'uvt',
        'uvtr',
        'uvti',
        'uvtu',
        'uvtl',
        'uvtup',
        'uvx'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @(
        'UV.psm1',
        'UV.psd1',
        'README.md'
    )
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'UV',
                'Python',
                'PackageManager',
                'VirtualEnvironment', 
                'Dependencies',
                'PyPI',
                'Poetry',
                'CLI',
                'Development',
                'Tools'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://github.com/MKAbuMattar/powershell-profile/raw/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/UV/README.md'
    DefaultCommandPrefix   = ''
}
