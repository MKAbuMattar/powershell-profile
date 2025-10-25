#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - QRCode Plugin
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
#       This module provides functions to generate QR codes using a Python backend.
#       It supports creating QR codes in PNG and SVG formats with interactive input
#       and file saving using the qrcode.show API.
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function New-QRCode {
    <#
    .SYNOPSIS
        Generate a QR code image (PNG format).

    .DESCRIPTION
        Creates a QR code from the provided text input using the qrcode.show API.
        Supports both direct text input and pipeline input. Saves to a file or outputs data.

    .PARAMETER InputText
        The text content to encode in the QR code. Accepts pipeline input.

    .PARAMETER OutputPath
        Custom path to save the PNG QR code file.

    .INPUTS
        InputText: (Optional) The text to encode in the QR code.
        OutputPath: (Optional) The file path where the QR code will be saved.

    .OUTPUTS
        This function does not return any output. It either displays the QR code or saves it to a file.

    .NOTES
        This function requires Python 3.6+ with the qrcode.py script available.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        New-QRCode "Hello World"
        Generates a PNG QR code for the text "Hello World".

    .EXAMPLE
        "https://github.com/MKAbuMattar" | New-QRCode
        Generates a PNG QR code for the GitHub URL using pipeline input.

    .EXAMPLE
        New-QRCode -InputText "Hello World" -OutputPath "C:\qrcode.png"
        Generates and saves a PNG QR code to the specified path.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("qrcode")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The text to encode in the QR code."
        )]
        [Alias("text")]
        [string]$InputText,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The file path where the QR code will be saved."
        )]
        [Alias("path", "o")]
        [string]$OutputPath
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "qrcode.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: qrcode.py not found at $pythonScript" -ForegroundColor Red
        return
    }

    try {
        $pythonVersion = python --version 2>&1
    }
    catch {
        Write-Host "Error: Python is not installed or not available in PATH." -ForegroundColor Red
        return
    }

    $arguments = @()
    
    if ($InputText) {
        $arguments += @($InputText)
    }

    $arguments += @("--format", "png")

    if ($OutputPath) {
        $arguments += @("--output-path", $OutputPath)
    }

    try {
        & python $pythonScript @arguments
    }
    catch {
        Write-Host "Error executing qrcode.py: $_" -ForegroundColor Red
    }
}

function New-QRCodeSVG {
    <#
    .SYNOPSIS
        Generate a QR code image in SVG format.

    .DESCRIPTION
        Creates a QR code in SVG format from the provided text input using the qrcode.show API.
        Supports both direct text input and pipeline input. By default, saves SVG files to 
        ~/.QRCode/ directory with timestamp. Can also output to console or custom path.

    .PARAMETER InputText
        The text content to encode in the QR code. Accepts pipeline input.

    .PARAMETER NoSave
        Do not automatically save to file, just output to console.

    .PARAMETER OutputPath
        Custom path to save the SVG file. If not specified, saves to ~/.QRCode/ directory.

    .INPUTS
        InputText: (Optional) The text to encode in the QR code.
        NoSave: (Optional) Switch to prevent automatic file saving.
        OutputPath: (Optional) Custom file path for saving the SVG.

    .OUTPUTS
        This function does not return any output. It either displays the SVG data or saves it to a file.

    .NOTES
        This function requires Python 3.6+ with the qrcode.py script available.
        By default, saves to ~/.QRCode/ directory with auto-generated filename.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        New-QRCodeSVG "Hello World"
        Generates an SVG QR code and saves it to ~/.QRCode/Hello_World-timestamp.svg

    .EXAMPLE
        "https://github.com/MKAbuMattar" | New-QRCodeSVG -NoSave
        Generates an SVG QR code and outputs to console without saving.

    .EXAMPLE
        New-QRCodeSVG -InputText "Test" -OutputPath "C:\temp\myqr.svg"
        Generates an SVG QR code and saves it to the specified path.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("qrsvg")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The text to encode in the QR code."
        )]
        [Alias("text")]
        [string]$InputText,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Do not automatically save to file, just output to console."
        )]
        [Alias("ns")]
        [switch]$NoSave,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Custom path to save the SVG file."
        )]
        [Alias("path", "o")]
        [string]$OutputPath
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "qrcode.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: qrcode.py not found at $pythonScript" -ForegroundColor Red
        return
    }

    try {
        $pythonVersion = python --version 2>&1
    }
    catch {
        Write-Host "Error: Python is not installed or not available in PATH." -ForegroundColor Red
        return
    }

    $arguments = @()
    
    if ($InputText) {
        $arguments += @($InputText)
    }

    $arguments += @("--format", "svg")

    if (-not $NoSave) {
        $arguments += @("--save")
    }

    if ($OutputPath) {
        $arguments += @("--output-path", $OutputPath)
    }

    try {
        & python $pythonScript @arguments
    }
    catch {
        Write-Host "Error executing qrcode.py: $_" -ForegroundColor Red
    }
}

function Test-QRCodeService {
    <#
    .SYNOPSIS
        Test connectivity to the qrcode.show service.

    .DESCRIPTION
        Verifies that the qrcode.show API service is accessible and responding.
        Useful for troubleshooting network connectivity issues.

    .OUTPUTS
        Boolean. Returns $true if service is accessible, $false otherwise.

    .NOTES
        This function requires Python 3.6+ with the qrcode.py script available.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        Test-QRCodeService
        Tests if the QR code service is available.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "qrcode.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: qrcode.py not found at $pythonScript" -ForegroundColor Red
        return $false
    }

    try {
        $pythonVersion = python --version 2>&1
    }
    catch {
        Write-Host "Error: Python is not installed or not available in PATH." -ForegroundColor Red
        return $false
    }

    try {
        & python $pythonScript --test 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        Write-Host "Error executing qrcode.py: $_" -ForegroundColor Red
        return $false
    }
}

function Save-QRCode {
    <#
    .SYNOPSIS
        Generate and save a QR code to a file.

    .DESCRIPTION
        Creates a QR code and saves it directly to a specified file.
        Supports both PNG and SVG formats based on file extension or explicit format parameter.

    .PARAMETER InputText
        The text content to encode in the QR code.

    .PARAMETER Path
        The file path where the QR code will be saved.

    .PARAMETER Format
        The output format. Valid values are 'PNG' (default) and 'SVG'.
        If not specified, format is inferred from file extension.

    .INPUTS
        InputText: (Required) The text to encode in the QR code.
        Path: (Required) The file path where the QR code will be saved.
        Format: (Optional) The output format ('PNG' or 'SVG').

    .OUTPUTS
        This function does not return any output. It saves the QR code to the specified file.

    .NOTES
        This function requires Python 3.6+ with the qrcode.py script available.
        Implemented using a Python backend for cross-platform compatibility.

    .EXAMPLE
        Save-QRCode -InputText "Hello World" -Path "qrcode.png"
        Saves a PNG QR code to qrcode.png.

    .EXAMPLE
        Save-QRCode -InputText "https://github.com" -Path "github.svg" -Format SVG
        Saves an SVG QR code to github.svg.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The text to encode in the QR code."
        )]
        [Alias("text")]
        [string]$InputText,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The file path where the QR code will be saved."
        )]
        [Alias("filepath")]
        [string]$Path,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The output format ('PNG' or 'SVG')."
        )]
        [ValidateSet("PNG", "SVG")]
        [string]$Format
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path -Path $scriptDir -ChildPath "qrcode.py"

    if (-not (Test-Path -Path $pythonScript)) {
        Write-Host "Error: qrcode.py not found at $pythonScript" -ForegroundColor Red
        return
    }

    try {
        $pythonVersion = python --version 2>&1
    }
    catch {
        Write-Host "Error: Python is not installed or not available in PATH." -ForegroundColor Red
        return
    }

    # Determine format from extension if not specified
    if (-not $Format) {
        $extension = [System.IO.Path]::GetExtension($Path).ToLower()
        $Format = switch ($extension) {
            ".svg" { "svg" }
            default { "png" }
        }
    }
    else {
        $Format = $Format.ToLower()
    }

    $arguments = @(
        $InputText,
        "--format", $Format,
        "--output-path", $Path
    )

    try {
        & python $pythonScript @arguments
    }
    catch {
        Write-Host "Error executing qrcode.py: $_" -ForegroundColor Red
    }
}
