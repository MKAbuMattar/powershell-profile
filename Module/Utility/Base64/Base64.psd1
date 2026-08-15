@{
    RootModule           = 'Base64.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @('Core')
    GUID                 = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Base64 encoding and decoding utilities for PowerShell'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'ConvertTo-Base64',
        'ConvertTo-Base64File',
        'ConvertFrom-Base64',
        'ConvertFrom-Base64File'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'e64',
        'ef64',
        'd64',
        'df64'
    )
    PrivateData          = @{
        PSData = @{
            Tags       = @('Base64', 'Encoding', 'Utility')
            LicenseUri = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
}
