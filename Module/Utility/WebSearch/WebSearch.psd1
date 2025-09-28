@{
    RootModule        = 'WebSearch.psm1'
    ModuleVersion     = '4.1.0'
    GUID              = 'a8e5d9c2-4f7b-4c8e-9a5d-8e7f6c9b4a3e'
    Author            = 'Mohammad Abu Mattar'
    CompanyName       = 'MKAbuMattar'
    Copyright         = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description       = 'WebSearch utility module for performing web searches across multiple search engines with cross-platform browser launching capabilities.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'ConvertTo-UrlEncoded',
        'Start-WebBrowser',
        'Invoke-WebSearch',
        'Search-DuckDuckGo',
        'Search-Wikipedia',
        'Search-Google',
        'Search-GitHub',
        'Search-StackOverflow',
        'Search-Reddit',
        'Start-WebSearch'
    )
    AliasesToExport   = @(
        'wsddg',
        'wswiki',
        'wsggl',
        'wsgh',
        'wsso',
        'wsrdt',
        'web-search',
        'ws'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('websearch', 'search', 'browser', 'utility', 'web', 'powershell')
            LicenseUri = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
}
