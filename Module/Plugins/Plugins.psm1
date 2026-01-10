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

# Get plugin enable/disable settings from config
$pluginsEnabled = Get-ProfileConfig -Key "modules.pluginsEnabled" -Default @{}

$ModuleList = @(
    @{ Name = 'Plugin-AWS'; Path = 'AWS/AWS.psd1'; ConfigKey = 'AWS' },
    @{ Name = 'Plugin-Conda'; Path = 'Conda/Conda.psd1'; ConfigKey = 'Conda' },
    @{ Name = 'Plugin-Deno'; Path = 'Deno/Deno.psd1'; ConfigKey = 'Deno' },
    @{ Name = 'Plugin-Docker'; Path = 'Docker/Docker.psd1'; ConfigKey = 'Docker' },
    @{ Name = 'Plugin-DockerCompose'; Path = 'DockerCompose/DockerCompose.psd1'; ConfigKey = 'DockerCompose' },
    @{ Name = 'Plugin-Flutter'; Path = 'Flutter/Flutter.psd1'; ConfigKey = 'Flutter' },
    @{ Name = 'Plugin-GCP'; Path = 'GCP/GCP.psd1'; ConfigKey = 'GCP' },
    @{ Name = 'Plugin-Git'; Path = 'Git/Git.psd1'; ConfigKey = 'Git' },
    @{ Name = 'Plugin-Helm'; Path = 'Helm/Helm.psd1'; ConfigKey = 'Helm' },
    @{ Name = 'Plugin-Kubectl'; Path = 'Kubectl/Kubectl.psd1'; ConfigKey = 'Kubectl' },
    @{ Name = 'Plugin-NPM'; Path = 'NPM/NPM.psd1'; ConfigKey = 'NPM' },
    @{ Name = 'Plugin-PIP'; Path = 'PIP/PIP.psd1'; ConfigKey = 'PIP' },
    @{ Name = 'Plugin-Pipenv'; Path = 'Pipenv/Pipenv.psd1'; ConfigKey = 'Pipenv' },
    @{ Name = 'Plugin-PNPM'; Path = 'PNPM/PNPM.psd1'; ConfigKey = 'PNPM' },
    @{ Name = 'Plugin-Poetry'; Path = 'Poetry/Poetry.psd1'; ConfigKey = 'Poetry' },
    @{ Name = 'Plugin-Ruby'; Path = 'Ruby/Ruby.psd1'; ConfigKey = 'Ruby' },
    @{ Name = 'Plugin-Rust'; Path = 'Rust/Rust.psd1'; ConfigKey = 'Rust' },
    @{ Name = 'Plugin-Rsync'; Path = 'Rsync/Rsync.psd1'; ConfigKey = 'Rsync' },
    @{ Name = 'Plugin-Terraform'; Path = 'Terraform/Terraform.psd1'; ConfigKey = 'Terraform' },
    @{ Name = 'Plugin-Terragrunt'; Path = 'Terragrunt/Terragrunt.psd1'; ConfigKey = 'Terragrunt' },
    @{ Name = 'Plugin-UV'; Path = 'UV/UV.psd1'; ConfigKey = 'UV' },
    @{ Name = 'Plugin-VSCode'; Path = 'VSCode/VSCode.psd1'; ConfigKey = 'VSCode' },
    @{ Name = 'Plugin-Yarn'; Path = 'Yarn/Yarn.psd1'; ConfigKey = 'Yarn' }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name
    $ConfigKey = $Module.ConfigKey

    # Check if plugin is enabled in config (default to true if not specified)
    $isEnabled = if ($pluginsEnabled.PSObject.Properties.Name -contains $ConfigKey) {
        $pluginsEnabled.$ConfigKey
    }
    else {
        $true
    }

    if (-not $isEnabled) {
        Write-Verbose "$ModuleName is disabled in configuration. Skipping..."
        continue
    }

    if (Test-Path $ModulePath) {
        Import-Module $ModulePath -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
}
