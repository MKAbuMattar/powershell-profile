#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Plugins Module
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
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Import the custom plugins modules
#---------------------------------------------------------------------------------------------------
$BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath '/'

$ModuleList = @(
    @{ Name = 'Plugin-AWS'; Path = 'AWS/AWS.psd1' },
    @{ Name = 'Plugin-Conda'; Path = 'Conda/Conda.psd1' },
    @{ Name = 'Plugin-Deno'; Path = 'Deno/Deno.psd1' },
    @{ Name = 'Plugin-Docker'; Path = 'Docker/Docker.psd1' },
    @{ Name = 'Plugin-DockerCompose'; Path = 'DockerCompose/DockerCompose.psd1' },
    @{ Name = 'Plugin-Flutter'; Path = 'Flutter/Flutter.psd1' },
    @{ Name = 'Plugin-GCP'; Path = 'GCP/GCP.psd1' },
    @{ Name = 'Plugin-Git'; Path = 'Git/Git.psd1' },
    @{ Name = 'Plugin-Helm'; Path = 'Helm/Helm.psd1' },
    @{ Name = 'Plugin-Kubectl'; Path = 'Kubectl/Kubectl.psd1' },
    @{ Name = 'Plugin-NPM'; Path = 'NPM/NPM.psd1' },
    @{ Name = 'Plugin-PIP'; Path = 'PIP/PIP.psd1' },
    @{ Name = 'Plugin-Pipenv'; Path = 'Pipenv/Pipenv.psd1' },
    @{ Name = 'Plugin-PNPM'; Path = 'PNPM/PNPM.psd1' },
    @{ Name = 'Plugin-Poetry'; Path = 'Poetry/Poetry.psd1' },
    @{ Name = 'Plugin-Ruby'; Path = 'Ruby/Ruby.psd1' },
    @{ Name = 'Plugin-Rust'; Path = 'Rust/Rust.psd1' },
    @{ Name = 'Plugin-Rsync'; Path = 'Rsync/Rsync.psd1' },
    @{ Name = 'Plugin-Terraform'; Path = 'Terraform/Terraform.psd1' },
    @{ Name = 'Plugin-Terragrunt'; Path = 'Terragrunt/Terragrunt.psd1' },
    @{ Name = 'Plugin-UV'; Path = 'UV/UV.psd1' },
    @{ Name = 'Plugin-VSCode'; Path = 'VSCode/VSCode.psd1' },
    @{ Name = 'Plugin-Yarn'; Path = 'Yarn/Yarn.psd1' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name

    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
}
