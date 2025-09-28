#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Plugins Manifest
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
#       This Module provides a set of plugins for various development tools and utilities
#       including AWS CLI, Conda, Deno, Docker, Docker Compose, Flutter, Git, Helm, Kubectl,
#       NPM, PIP, Pipenv, PNPM, Poetry, Ruby, Rust, Rsync, Terraform, Terragrunt,
#       UV, VSCode, and Yarn. Each plugin integrates with PowerShell to provide
#       convenient functions and aliases for enhanced productivity and workflow automation.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Plugins.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '6d4f3c39-8cda-4158-b7df-18a87015311c'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'A collection of utility functions for system and process management.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        '*'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        '*'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Plugins',
                'Utilities',
                'Development',
                'Automation',
                'AWS',
                'Conda',
                'Deno',
                'Docker',
                'DockerCompose',
                'Flutter',
                'Git',
                'Helm',
                'Kubectl',
                'NPM',
                'PIP',
                'Pipenv',
                'PNPM',
                'Poetry',
                'Ruby',
                'Rust',
                'Rsync',
                'Terraform',
                'Terragrunt',
                'UV',
                'VSCode',
                'Yarn'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/README.md'
    DefaultCommandPrefix = ''
}
