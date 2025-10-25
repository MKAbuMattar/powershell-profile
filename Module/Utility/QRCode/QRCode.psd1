#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - QRCode Manifest
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
#       This module provides functions to generate QR codes using the qrcode.show API.
#       It supports creating QR codes in PNG and SVG formats, with options for interactive
#       input and file saving.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

@{
    RootModule           = 'QRCode.psm1'
    ModuleVersion        = '4.2.0'
    CompatiblePSEditions = @(
        'Desktop',
        'Core'
    )
    GUID                 = '8f2c3d1e-5a6b-7c8d-9e0f-1a2b3c4d5e6f'
    Author               = 'Mohammad Abu Mattar'
    CompanyName          = 'MKAbuMattar'
    Copyright            = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description          = 'QRCode plugin for PowerShell Profile - Generate QR codes via qrcode.show API. Provides functions to create QR codes in PNG and SVG formats with PowerShell pipeline support.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'New-QRCode',
        'New-QRCodeSVG',
        'Test-QRCodeService',
        'Save-QRCode'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @(
        'qrcode',
        'qrsvg'
    )
    PrivateData          = @{
        PSData = @{
            Tags                       = @(
                'QRCode',
                'QR',
                'Code',
                'Generator',
                'API',
                'Web',
                'Image',
                'SVG',
                'PNG',
                'Utility',
                'Development'
            )
            LicenseUri                 = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri                 = 'https://github.com/MKAbuMattar/powershell-profile'
            IconUri                    = 'https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/assets/icon.png'
            ExternalModuleDependencies = @()
        }
    }
    HelpInfoURI          = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Utility/QRCode/README.md'
}
