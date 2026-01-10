#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Config Module
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This module provides a profile configuration management system
#       with JSON-based storage, validation, and CRUD operations for
#       PowerShell profile settings.
#
# Created: 2025-10-25
# Updated: 2026-01-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------
@{
    RootModule           = 'Config.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @('Core', 'Desktop')
    GUID                 = 'e8f7c2d1-9a4b-4c3d-8e2f-1a5b6c7d8e9f'
    Author               = 'MKAbuMattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2026 MKAbuMattar. All rights reserved.'
    Description          = 'Profile configuration management system with JSON-based storage, validation, and CRUD operations for PowerShell profile settings.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Get-ProfileConfig',
        'Set-ProfileConfig',
        'Reset-ProfileConfig',
        'Export-ProfileConfig',
        'Import-ProfileConfig',
        'Edit-ProfileConfig',
        'Test-ProfileConfig',
        'Show-ProfileConfigInfo'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'cfg',
        'cfg-set',
        'cfg-reset',
        'cfg-export',
        'cfg-import',
        'cfg-edit',
        'cfg-test',
        'cfg-info'
    )
    
    PrivateData          = @{
        PSData = @{
            Tags         = @('PowerShell', 'Profile', 'Configuration', 'Settings', 'JSON', 'Config')
            ReleaseNotes = @'
## 1.0.0
- Initial release
- JSON-based configuration management
- CRUD operations (Get, Set, Reset, Export, Import)
- Configuration validation
- Schema support
- Merge and override capabilities
- Editor integration
- Default configuration template
'@
        }
    }
}
