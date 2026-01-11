@{
    # Module metadata
    RootModule           = 'Performance.psm1'
    ModuleVersion        = '1.0.0'
    GUID                 = '9a3c4e5f-6d7e-8f9a-0b1c-2d3e4f5a6b7c'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2026 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Performance monitoring, benchmarking, and optimization tools for PowerShell profile'

    # Minimum PowerShell version
    PowerShellVersion    = '5.1'

    # Compatible editions
    CompatiblePSEditions = @('Desktop', 'Core')

    # Functions to export
    FunctionsToExport    = @(
        'Measure-ProfileStartup',
        'Get-ModuleLoadTime',
        'Test-ModulePerformance',
        'Get-PerformanceReport',
        'Get-ProfileMemoryUsage',
        'Set-PerformanceCache',
        'Get-PerformanceCache',
        'Clear-PerformanceCache',
        'Show-PerformanceDashboard',
        'Register-ModuleLoadTime'
    )

    # Cmdlets to export
    CmdletsToExport      = @()

    # Variables to export
    VariablesToExport    = @()

    # Aliases to export
    AliasesToExport      = @(
        'measure-startup',
        'module-time',
        'test-perf',
        'perf-report',
        'mem-usage',
        'set-cache',
        'get-cache',
        'clear-cache',
        'perf-dash',
        'dashboard'
    )

    # Private data
    PrivateData          = @{
        PSData = @{
            Tags       = @(
                'Performance',
                'Monitoring',
                'Benchmarking',
                'Optimization',
                'Cache',
                'Memory',
                'Startup'
            )
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
            LicenseUri = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
        }
    }
}
