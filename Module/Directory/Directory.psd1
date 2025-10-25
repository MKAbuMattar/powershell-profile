#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Directory Manifest
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
#       This Module contains various directory and file management
#       functions to enhance productivity in PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Directory.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '23724530-b558-4a50-bc83-98525b46d859'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'A PowerShell utility module for file and directory management, including file search, creation, compression, extraction, and content manipulation.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Find-Files',
        'Set-FreshFile',
        'Expand-File',
        'Compress-Files',
        'Get-ContentMatching',
        'Set-ContentMatching',
        'Get-FileHead',
        'Get-FileTail',
        'Get-ShortPath',
        'Invoke-UpOneDirectoryLevel',
        'Invoke-UpTwoDirectoryLevels',
        'Invoke-UpThreeDirectoryLevels',
        'Invoke-UpFourDirectoryLevels',
        'Invoke-UpFiveDirectoryLevels'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'ff',
        'touch',
        'unzip',
        'zip',
        'grep',
        'sed',
        'z',
        'zi',
        'head',
        'tail',
        'shortpath',
        'cd.1',
        '..',
        'cd.2',
        '...',
        'cd.3',
        '....',
        'cd.4',
        '.....',
        'cd.5',
        '......'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Files Management',
                'Directory Navigation',
                'Compression',
                'Extraction',
                'Content Manipulation'
            )
            LicenseUri                 = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            ReleaseNotes               = ''
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Directory/README.md'
    DefaultCommandPrefix = ''
}
