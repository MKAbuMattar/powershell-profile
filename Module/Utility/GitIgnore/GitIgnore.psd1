@{
    RootModule        = 'GitIgnore.psm1'
    ModuleVersion     = '4.2.0'
    GUID              = 'de13ca13-6abe-4ac3-8755-b66cd6852922'
    Author            = 'Mohammad Abu Mattar'
    CompanyName       = 'MKAbuMattar'
    Copyright         = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description       = 'GitIgnore utility module for generating .gitignore files using gitignore.io API. Provides functions for creating, updating, and managing .gitignore files with support for various technologies and platforms.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Get-GitIgnore',
        'Get-GitIgnoreList', 
        'New-GitIgnoreFile',
        'Add-GitIgnoreContent',
        'Test-GitIgnoreService'
    )
    AliasesToExport   = @(
        'gitignore',
        'gilist',
        'ginew', 
        'giadd',
        'gitest'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('gitignore', 'git', 'utility', 'template', 'development', 'powershell')
            LicenseUri = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
}
