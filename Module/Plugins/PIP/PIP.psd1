@{
    RootModule             = 'PIP.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @(
        'Desktop',
        'Core'
    )
    GUID                   = '8c3f9e4b-0d2e-5f6a-9b8c-2d3e4f5a6b7c'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'A comprehensive PowerShell module that provides pip CLI shortcuts and utility functions for Python package management workflow. Includes automatic completion, package management, requirements handling, GitHub installations, and advanced pip operations.'
    PowerShellVersion      = '5.0'
    DotNetFrameworkVersion = '4.5'
    CLRVersion             = '4.0'
    FunctionsToExport      = @(
        'Test-PipInstalled',
        'Initialize-PipCompletion',
        'Clear-PipCache',
        'Get-PipCacheFile',
        'Update-PipPackageCache',
        'Invoke-Pip',
        'Invoke-PipInstall',
        'Invoke-PipUpgrade',
        'Invoke-PipUninstall',
        'Invoke-PipFreeze',
        'Invoke-PipFreezeGrep',
        'Invoke-PipListOutdated',
        'Invoke-PipRequirements',
        'Invoke-PipInstallRequirements',
        'Invoke-PipUpgradeAll',
        'Invoke-PipUninstallAll',
        'Invoke-PipInstallGitHub',
        'Invoke-PipInstallGitHubBranch',
        'Invoke-PipInstallGitHubPR',
        'Invoke-PipShow',
        'Invoke-PipSearch',
        'Invoke-PipList',
        'Invoke-PipCheck',
        'Invoke-PipWheel',
        'Invoke-PipDownload',
        'Invoke-PipConfig',
        'Invoke-PipDebug',
        'Invoke-PipHash',
        'Invoke-PipHelp',
        'Invoke-PipCache',
        'Invoke-PipInstallUser',
        'Invoke-PipInstallEditable'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'pip',
        'pipi',
        'pipu',
        'pipun',
        'pipgi',
        'piplo',
        'pipreq',
        'pipir',
        'pipupall',
        'pipunall',
        'pipig',
        'pipigb',
        'pipigp',
        'pips',
        'pipsr',
        'pipl',
        'pipck',
        'pipw',
        'pipd',
        'pipc',
        'pipdbg',
        'piph',
        'pipcc',
        'pipiu',
        'pipie'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'pip',
                'python',
                'package-manager',
                'powershell',
                'cli',
                'development',
                'workflow',
                'automation',
                'requirements',
                'virtualenv'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://github.com/MKAbuMattar/powershell-profile/raw/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/PIP/README.md'
    DefaultCommandPrefix   = ''
}
