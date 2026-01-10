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
#       This module provides a simple wrapper for the igntui CLI tool.
#       igntui is an interactive TUI for generating .gitignore files.
#       Automatically installs igntui from PyPI if not found.
#
# Created: 2025-09-27
# Updated: 2026-01-10
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.0.0
#---------------------------------------------------------------------------------------------------
@{
    RootModule        = 'GitIgnore.psm1'
    ModuleVersion     = '5.0.0'
    GUID              = 'de13ca13-6abe-4ac3-8755-b66cd6852922'
    Author            = 'Mohammad Abu Mattar'
    CompanyName       = 'MKAbuMattar'
    Copyright         = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description       = 'Simple wrapper for igntui - an interactive TUI for generating .gitignore files. Automatically installs from PyPI using pipx if not found.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Start-GitIgnore'
    )
    AliasesToExport   = @(
        'gitignore',
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
