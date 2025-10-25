#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - GitIgnore Utility Module
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
#       This module provides utilities for generating .gitignore files using the gitignore.io API.
#       It includes functions for generating gitignore content for various technologies and platforms,
#       as well as listing available templates and providing tab completion support.
#       Uses Python backend for API interactions.
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------
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
