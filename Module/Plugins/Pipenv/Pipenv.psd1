@{
    RootModule             = 'Pipenv.psm1'
    ModuleVersion          = '4.1.0'
    CompatiblePSEditions   = @(
        'Desktop',
        'Core'
    )
    GUID                   = '9d4e0f5c-1e3f-6a7b-0c9d-3e4f5a6b7c8d'
    Author                 = 'Mohammad Abu Mattar'
    CompanyName            = 'MKAbuMattar'
    Copyright              = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description            = 'A comprehensive PowerShell module that provides pipenv CLI shortcuts and utility functions for Python virtual environment management workflow. Includes automatic shell activation, dependency management, and complete pipenv integration.'
    PowerShellVersion      = '5.0'
    DotNetFrameworkVersion = '4.5'
    CLRVersion             = '4.0'
    FunctionsToExport      = @(
        'Test-PipenvInstalled',
        'Initialize-PipenvCompletion',
        'Enable-PipenvAutoShell',
        'Disable-PipenvAutoShell',
        'Test-PipenvAutoShell',
        'Invoke-PipenvShellToggle',
        'Invoke-Pipenv',
        'Invoke-PipenvCheck',
        'Invoke-PipenvClean',
        'Invoke-PipenvGraph',
        'Invoke-PipenvInstall',
        'Invoke-PipenvInstallDev',
        'Invoke-PipenvLock',
        'Invoke-PipenvOpen',
        'Invoke-PipenvRun',
        'Invoke-PipenvShell',
        'Invoke-PipenvSync',
        'Invoke-PipenvUninstall',
        'Invoke-PipenvUpdate',
        'Invoke-PipenvWhere',
        'Invoke-PipenvVenv',
        'Invoke-PipenvPython',
        'Invoke-PipenvRequirements',
        'Invoke-PipenvScript'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'pipenv',
        'pch',
        'pcl',
        'pgr',
        'pi',
        'pidev',
        'pl',
        'po',
        'prun',
        'psh',
        'psy',
        'pu',
        'pupd',
        'pwh',
        'pvenv',
        'ppy',
        'preq',
        'pscr'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @(
                'pipenv',
                'python',
                'virtualenv',
                'package-manager',
                'powershell',
                'cli',
                'development',
                'workflow',
                'automation',
                'pipfile'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://github.com/MKAbuMattar/powershell-profile/raw/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI            = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Pipenv/README.md'
    DefaultCommandPrefix   = ''
}
