#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Terragrunt Manifest
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
#       This module provides Terragrunt CLI shortcuts and utility functions for improved DRY
#       Infrastructure as Code workflow in PowerShell environments. Converts 25+ common
#       terragrunt operations to PowerShell functions with full parameter support, dependency
#       orchestration, and multi-environment management.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Terragrunt.psm1'
    ModuleVersion        = '4.1.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'b5e8f1c3-6d9a-4f2b-9c8e-3f1a5b7d2c4f'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Comprehensive Terragrunt CLI integration for PowerShell with 25+ functions and aliases for DRY Infrastructure as Code management, multi-environment workflows, dependency orchestration, and advanced Terraform operations.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Test-TerragruntInstalled',
        'Initialize-TerragruntCompletion',
        'Invoke-Terragrunt',
        'Get-TerragruntWorkingDir',
        'Get-TerragruntConfigPath',
        'Get-TerragruntCacheDir',
        'Invoke-TerragruntInit',
        'Invoke-TerragruntInitFromModule',
        'Invoke-TerragruntPlan',
        'Invoke-TerragruntPlanAll',
        'Invoke-TerragruntApply',
        'Invoke-TerragruntApplyAll',
        'Invoke-TerragruntRefresh',
        'Invoke-TerragruntRefreshAll',
        'Invoke-TerragruntDestroy',
        'Invoke-TerragruntDestroyAll',
        'Invoke-TerragruntFormat',
        'Invoke-TerragruntFormatHCL',
        'Invoke-TerragruntValidate',
        'Invoke-TerragruntValidateAll',
        'Invoke-TerragruntValidateInputs',
        'Invoke-TerragruntRenderJSON',
        'Invoke-TerragruntGraphDependencies',
        'Invoke-TerragruntOutputAll',
        'Invoke-TerragruntOutputModuleGroups',
        'Invoke-TerragruntStateList',
        'Invoke-TerragruntStateShow',
        'Invoke-TerragruntStateMv',
        'Invoke-TerragruntStateRm',
        'Invoke-TerragruntShow',
        'Invoke-TerragruntProviders',
        'Invoke-TerragruntGet',
        'Invoke-TerragruntVersion'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'tg',          
        'tgi',         
        'tgifm',       
        'tgp',         
        'tgpa',        
        'tga',         
        'tgaa',        
        'tgr',         
        'tgra',        
        'tgd',         
        'tgda',        
        'tgf',         
        'tgfmt',       
        'tgv',         
        'tgva',        
        'tgvi',        
        'tgrj',        
        'tggd',        
        'tgo',         
        'tgomg',       
        'tgsl',         
        'tgss',         
        'tgsm',         
        'tgsr',         
        'tgsh',        
        'tgpv',        
        'tgget',       
        'tgver'        
    )
    DscResourcesToExport = @()
    ModuleList           = @()
    FileList             = @(
        'Terragrunt.psm1',
        'Terragrunt.psd1',
        'README.md'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Terragrunt',
                'Terraform',
                'IaC',
                'Infrastructure',
                'Cloud',
                'DevOps',
                'Automation',
                'DRY',
                'Dependencies',
                'Multi-Environment'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'

            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/assets/icon.png'
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Terragrunt/README.md'
    DefaultCommandPrefix = ''
}
