#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Terraform Manifest
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
#       This module provides Terraform CLI shortcuts and utility functions for improved Infrastructure
#       as Code workflow in PowerShell environments. Includes functions for initializing, planning,
#       applying, and managing Terraform configurations with convenient aliases and prompt integration.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Terraform.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'a8f7d3c2-5b9e-4f1a-8c6d-2e9b1f4a7c3e'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Comprehensive Terraform CLI integration for PowerShell with 20+ functions and aliases for Infrastructure as Code management, workspace operations, state management, and prompt integration with workspace awareness.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Invoke-Terraform',
        'Get-TerraformWorkspace',
        'Get-TerraformVersion',
        'Get-TerraformPromptInfo',
        'Get-TerraformVersionPromptInfo',
        'Invoke-TerraformInit',
        'Invoke-TerraformInitReconfigure',
        'Invoke-TerraformInitUpgrade',
        'Invoke-TerraformInitUpgradeReconfigure',
        'Invoke-TerraformPlan',
        'Invoke-TerraformApply',
        'Invoke-TerraformApplyAutoApprove',
        'Invoke-TerraformDestroy',
        'Invoke-TerraformDestroyAutoApprove',
        'Invoke-TerraformFormat',
        'Invoke-TerraformFormatRecursive',
        'Invoke-TerraformValidate',
        'Invoke-TerraformTest',
        'Invoke-TerraformState',
        'Invoke-TerraformOutput',
        'Invoke-TerraformShow',
        'Invoke-TerraformConsole'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'tf',          
        'tfi',        
        'tfir',       
        'tfiu',        
        'tfiur',        
        'tfp',        
        'tfa',        
        'tfaa',        
        'tfd',        
        'tfd!',        
        'tff',        
        'tffr',        
        'tfv',        
        'tft',        
        'tfs',        
        'tfo',        
        'tfsh',       
        'tfc'         
    )
    DscResourcesToExport = @()
    ModuleList           = @()
    FileList             = @(
        'Terraform.psm1',
        'Terraform.psd1',
        'README.md'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Terraform',
                'IaC',
                'Infrastructure',
                'Cloud',
                'DevOps',
                'Automation',
                'CLI',
                'PowerShell',
                'Workspace',
                'State'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/assets/icon.png'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terraform/README.md'
    DefaultCommandPrefix = ''
}
