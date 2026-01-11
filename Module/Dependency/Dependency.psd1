@{
    # Module Information
    RootModule        = 'Dependency.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a3c8f7e2-9d4b-4a1e-8c5f-6b7a8d9e0f12'
    Author            = 'MKAbuMattar'
    CompanyName       = 'Personal'
    Copyright         = '(c) 2026 MKAbuMattar. All rights reserved.'
    Description       = 'Module dependency management and health checking system for PowerShell profile'
    
    # Requirements
    PowerShellVersion = '5.1'
    
    # Functions to export
    FunctionsToExport = @(
        'Get-ModuleDependencies',
        'Test-ModuleVersion',
        'Test-ModuleHealth',
        'Install-ModuleDependencies',
        'Test-ModuleConflict',
        'Show-DependencyGraph'
    )
    
    # Aliases to export
    AliasesToExport   = @(
        'deps',
        'test-version',
        'module-health',
        'install-deps',
        'check-conflicts',
        'dep-graph'
    )
    
    # Private data
    PrivateData       = @{
        PSData = @{
            Tags         = @('Dependency', 'Module', 'Health', 'Management', 'Profile')
            ProjectUri   = 'https://github.com/MKAbuMattar/powershell-profile'
            ReleaseNotes = @'
Version 1.0.0 (January 11, 2026)
- Initial release
- Dependency mapping for all profile modules
- Module version checking
- Module health diagnostics
- Automatic dependency installation
- Conflict detection (functions, aliases, circular dependencies)
- Visual dependency graph
'@
        }
    }
}
