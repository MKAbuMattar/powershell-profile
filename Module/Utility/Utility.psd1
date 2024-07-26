@{
    ModuleVersion     = '0.0.0'
    GUID              = '69fba7f4-822d-4201-bec5-7f7f03edfca3'
    Author            = 'Mohammad Abu Mattar'
    Copyright         = '(c) 2024 Mohammad Abu Mattar'
    Description       = 'Utility module'
    FunctionsToExport = @(
        'Invoke-ProfileReload',
        'Find-Files', 
        'Set-FreshFile',
        'Get-Uptime',
        'Expand-File',
        'Compress-Files'
    )
    CmdletsToExport   = @()
    VariablesToExport = '*'
    AliasesToExport   = @(
        'reload-profile',
        'ff', 
        'touch',
        'uptime',
        'unzip',
        'zip'
    )
}
