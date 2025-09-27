#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Rust Manifest
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
#       This module provides comprehensive Cargo and Rustup CLI integration with PowerShell aliases
#       and functions for Rust development, including building, testing, dependency management,
#       and toolchain operations.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'Rust.psm1'
    ModuleVersion        = '1.0.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = 'f8e9d2b1-4c3a-5b6e-9f1a-2d3e4f5a6b7c'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'Rust Plugin for PowerShell Profile - Provides comprehensive Cargo and Rustup CLI integration with PowerShell aliases and functions for Rust development, including building, testing, dependency management, and toolchain operations.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Invoke-Cargo',
        'New-CargoProject',
        'New-CargoLibrary',
        'Initialize-CargoProject',
        'Build-CargoProject',
        'Build-CargoRelease',
        'Start-CargoRun',
        'Start-CargoRunRelease',
        'Watch-CargoProject',
        'Test-CargoProject',
        'Test-CargoRelease',
        'Test-CargoBench',
        'Test-CargoAll',
        'Test-CargoSingleThread',
        'Test-CargoCheck',
        'Clear-CargoProject',
        'Invoke-CargoClippy',
        'Format-CargoCode',
        'Format-CargoAll',
        'Repair-CargoCode',
        'Test-CargoAudit',
        'Show-CargoDoc',
        'Show-CargoDocRelease',
        'Show-CargoDocPrivate',
        'Add-CargoDependency',
        'Add-CargoDevDependency',
        'Update-CargoDependencies',
        'Show-CargoOutdated',
        'Invoke-CargoVendor',
        'Show-CargoTree',
        'Build-CargoZig',
        'Build-CargoCross',
        'Set-CargoTarget',
        'New-CargoFlamegraph',
        'Show-CargoBloat',
        'Show-CargoLLVMCov',
        'Show-CargoModules',
        'Expand-CargoMacros',
        'Install-CargoBinary',
        'Uninstall-CargoBinary',
        'Publish-CargoPackage',
        'Search-CargoPackages',
        'New-CargoPackage',
        'Build-CargoAllTargets',
        'Build-CargoAllFeatures',
        'Build-CargoProfile',
        'New-CargoBinaryTemplate',
        'New-CargoLibraryTemplate',
        'New-CargoTemplate',
        'Update-Rustup',
        'Update-RustupStable',
        'Update-RustupNightly',
        'Install-RustupToolchain',
        'Add-RustupComponent',
        'Get-RustupComponents',
        'Remove-RustupComponent',
        'Get-RustupToolchains',
        'Uninstall-RustupToolchain',
        'Set-RustupDefault',
        'Add-RustupTarget',
        'Get-RustupTargets',
        'Remove-RustupTarget',
        'Invoke-RustupStable',
        'Invoke-RustupNightly',
        'Show-RustupDoc',
        'Set-RustupOverride',
        'Get-RustupOverrides',
        'Remove-RustupOverride',
        'Get-RustupWhich',
        'Show-RustupInfo'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'cg',
        'cgn',
        'cgni',
        'cginit',
        'cgb',
        'cgbr',
        'cgr',
        'cgrr',
        'cgw',
        'cgt',
        'cgtr',
        'cgbh',
        'cgta',
        'cgtt',
        'cgc',
        'cgcl',
        'cgcy',
        'cgf',
        'cgfa',
        'cgfx',
        'cgaud',
        'cgd',
        'cgdr',
        'cgdo',
        'cga',
        'cgad',
        'cgu',
        'cgo',
        'cgv',
        'cgtree',
        'cgx',
        'cgxw',
        'cgxt',
        'cgfl',
        'cgbl',
        'cgl',
        'cgm',
        'cgex',
        'cgi',
        'cgun',
        'cgp',
        'cgs',
        'cgcp',
        'cgba',
        'cgbt',
        'cgbp',
        'cgnb',
        'cgnl',
        'cgnt',
        'ru',
        'rus',
        'run',
        'rti',
        'rca',
        'rcl',
        'rcr',
        'rtl',
        'rtu',
        'rde',
        'rtaa',
        'rtal',
        'rtar',
        'rns',
        'rnn',
        'rdo',
        'rpr',
        'rpl',
        'rpn',
        'rws',
        'rsh'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'Rust',
                'Cargo',
                'Rustup',
                'Development',
                'Build',
                'Testing',
                'CLI'
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
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rust/README.md'
    DefaultCommandPrefix = ''
}
