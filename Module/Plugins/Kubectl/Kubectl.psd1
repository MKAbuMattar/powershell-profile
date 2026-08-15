#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Kubectl Manifest
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
#       This module provides kubectl CLI shortcuts and utility functions for improved
#       Kubernetes cluster management workflow in PowerShell environments.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{  
    RootModule           = 'Kubectl.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'b1c2d3e4-f5a6-7890-1234-567890abcdef'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Kubectl plugin for MKAbuMattar PowerShell Profile - provides kubectl CLI shortcuts and utility functions for Kubernetes cluster management workflows.'
    PowerShellVersion    = '5.0'
    FunctionsToExport    = @(
        'Invoke-Kubectl',
        'Invoke-KubectlAllNamespaces',
        'Invoke-KubectlApplyFile',
        'Invoke-KubectlExecInteractive',
        'Invoke-KubectlConfigUseContext',
        'Invoke-KubectlConfigSetContext',
        'Invoke-KubectlConfigDeleteContext',
        'Invoke-KubectlConfigCurrentContext',
        'Invoke-KubectlConfigGetContexts',
        'Invoke-KubectlDelete',
        'Invoke-KubectlDeleteFile',
        'Invoke-KubectlGetEvents',
        'Invoke-KubectlGetEventsWatch',
        'Invoke-KubectlGetPods',
        'Invoke-KubectlGetPodsLabels',
        'Invoke-KubectlGetPodsNamespace',
        'Invoke-KubectlGetPodsShowLabels',
        'Invoke-KubectlGetPodsAllNamespaces',
        'Invoke-KubectlGetPodsWatch',
        'Invoke-KubectlGetPodsWide',
        'Invoke-KubectlEditPods',
        'Invoke-KubectlDescribePods',
        'Invoke-KubectlDeletePods',
        'Invoke-KubectlGetPodsAll'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'k',
        'kca',
        'kaf',
        'keti',
        'kcuc',
        'kcsc',
        'kcdc',
        'kccc',
        'kcgc',
        'kdel',
        'kdelf',
        'kge',
        'kgew',
        'kgp',
        'kgpl',
        'kgpn',
        'kgpsl',
        'kgpa',
        'kgpw',
        'kgpwide',
        'kep',
        'kdp',
        'kdelp',
        'kgpall'
    )
    DscResourcesToExport = @()
    ModuleList           = @()
    FileList             = @(
        'Kubectl.psm1',
        'Kubectl.psd1',
        'README.md'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Kubectl',
                'Kubernetes',
                'K8s',
                'DevOps',
                'CLI',
                'PowerShell',
                'Profile',
                'Aliases',
                'Container',
                'Orchestration'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = ''
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Kubectl/README.md'
    DefaultCommandPrefix = ''
}
