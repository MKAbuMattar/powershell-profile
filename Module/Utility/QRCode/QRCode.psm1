#Requires -Version 7.0

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
#       This module provides functions to generate QR codes using the qrcode.show API.
#       It supports creating QR codes in PNG and SVG formats, with options for interactive
#       input and file saving.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Show-QRCodeInputMessage {
    <#
    .SYNOPSIS
        Display instructions for interactive QR code input.

    .DESCRIPTION
        Provides guidance to the user on how to enter multi-line text input
        for QR code generation in interactive mode.

    .INPUTS
        None. This function does not accept input.

    .OUTPUTS
        None. This function does not produce output.

    .EXAMPLE
        Show-QRCodeInputMessage
        Displays instructions for entering text input.

    .NOTES
        Used internally by New-QRCode and New-QRCodeSVG functions.
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "Type or paste your text, add a new blank line, and press Ctrl+Z (Windows) or Ctrl+D (Unix)" -ForegroundColor Cyan
}

function New-QRCode {
    <#
    .SYNOPSIS
        Generate a QR code image (PNG format).

    .DESCRIPTION
        Creates a QR code from the provided text input using the qrcode.show API.
        Supports both direct text input and pipeline input. If no input is provided,
        enters interactive mode for multi-line text entry.

    .PARAMETER InputText
        The text content to encode in the QR code. Accepts pipeline input.

    .PARAMETER Raw
        Return the raw response without additional formatting.

    .EXAMPLE
        New-QRCode "Hello World"
        Generates a QR code for the text "Hello World".

    .EXAMPLE
        "https://github.com/MKAbuMattar" | New-QRCode
        Generates a QR code for the GitHub URL using pipeline input.

    .EXAMPLE
        New-QRCode
        Enters interactive mode for multi-line text input.

    .OUTPUTS
        String
        The QR code image data in PNG format.

    .NOTES
        Equivalent to qrcode() function in bash.
        Uses qrcode.show API service.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/QRCode/README.md

    .LINK
        https://qrcode.show/
    #>
    [CmdletBinding()]
    [Alias("qrcode")]
    [OutputType([string])]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]]$InputText,

        [Parameter()]
        [switch]$Raw
    )

    begin {
        $allInput = @()
    }

    process {
        if ($InputText) {
            $allInput += $InputText
        }
    }

    end {
        try {
            if ($allInput.Count -eq 0 -or ($allInput.Count -eq 1 -and [string]::IsNullOrWhiteSpace($allInput[0]))) {
                Show-QRCodeInputMessage
                
                $interactiveInput = @()
                do {
                    $line = Read-Host
                    if (-not [string]::IsNullOrEmpty($line)) {
                        $interactiveInput += $line
                    }
                } while (-not [string]::IsNullOrEmpty($line))
                
                if ($interactiveInput.Count -eq 0) {
                    Write-Warning "No input provided. QR code generation cancelled."
                    return
                }
                
                $textToEncode = $interactiveInput -join "`n"
            }
            else {
                $textToEncode = $allInput -join " "
            }

            $response = Invoke-RestMethod -Uri "https://qrcode.show" -Method Post -Body $textToEncode -ContentType "text/plain"
            
            if ($Raw) {
                return $response
            }
            else {
                Write-Output $response
            }
        }
        catch {
            Write-Error "Failed to generate QR code: $($_.Exception.Message)"
        }
    }
}

function New-QRCodeSVG {
    <#
    .SYNOPSIS
        Generate a QR code image in SVG format.

    .DESCRIPTION
        Creates a QR code in SVG format from the provided text input using the qrcode.show API.
        Supports both direct text input and pipeline input. If no input is provided,
        enters interactive mode for multi-line text entry.
        By default, saves SVG files to ~/.QRCode/ directory with timestamp.

    .PARAMETER InputText
        The text content to encode in the QR code. Accepts pipeline input.

    .PARAMETER Raw
        Return the raw SVG response without additional formatting.

    .PARAMETER NoSave
        Do not automatically save to file, just output to console.

    .PARAMETER OutputPath
        Custom path to save the SVG file. If not specified, saves to ~/.QRCode/ directory.

    .EXAMPLE
        New-QRCodeSVG "Hello World"
        Generates an SVG QR code and saves it to ~/.QRCode/Hello_World-20250927_180500.svg

    .EXAMPLE
        "https://github.com/MKAbuMattar" | New-QRCodeSVG -NoSave
        Generates an SVG QR code and outputs to console without saving.

    .EXAMPLE
        New-QRCodeSVG "Test" -OutputPath "C:\temp\myqr.svg"
        Generates an SVG QR code and saves it to the specified path.

    .OUTPUTS
        String
        The QR code image data in SVG format.

    .NOTES
        Equivalent to qrsvg() function in bash.
        Uses qrcode.show API service with SVG Accept header.
        Automatically saves to ~/.QRCode/ directory unless -NoSave is specified.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/QRCode/README.md

    .LINK
        https://qrcode.show/
    #>
    [CmdletBinding()]
    [Alias("qrsvg")]
    [OutputType([string])]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]]$InputText,

        [Parameter()]
        [switch]$Raw,

        [Parameter()]
        [switch]$NoSave,

        [Parameter()]
        [string]$OutputPath
    )

    begin {
        $allInput = @()
    }

    process {
        if ($InputText) {
            $allInput += $InputText
        }
    }

    end {
        try {
            if ($allInput.Count -eq 0 -or ($allInput.Count -eq 1 -and [string]::IsNullOrWhiteSpace($allInput[0]))) {
                Show-QRCodeInputMessage
                
                $interactiveInput = @()
                do {
                    $line = Read-Host
                    if (-not [string]::IsNullOrEmpty($line)) {
                        $interactiveInput += $line
                    }
                } while (-not [string]::IsNullOrEmpty($line))
                
                if ($interactiveInput.Count -eq 0) {
                    Write-Warning "No input provided. QR code generation cancelled."
                    return
                }
                
                $textToEncode = $interactiveInput -join "`n"
            }
            else {
                $textToEncode = $allInput -join " "
            }

            $headers = @{
                "Accept" = "image/svg+xml"
            }
            
            $response = Invoke-WebRequest -Uri "https://qrcode.show" -Method Post -Body $textToEncode -ContentType "text/plain" -Headers $headers
            $svgContent = $response.Content

            if (-not $NoSave) {
                try {
                    $qrCodeDir = Join-Path $env:USERPROFILE ".QRCode"
                    if (-not (Test-Path $qrCodeDir)) {
                        New-Item -ItemType Directory -Path $qrCodeDir -Force | Out-Null
                        Write-Verbose "Created directory: $qrCodeDir"
                    }

                    if (-not $OutputPath) {
                        $sanitizedText = $textToEncode -replace '[^\w\s-]', '' -replace '\s+', '_'
                        if ($sanitizedText.Length -gt 50) {
                            $sanitizedText = $sanitizedText.Substring(0, 50)
                        }
                        
                        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
                        
                        $filename = "$sanitizedText-$timestamp.svg"
                        $OutputPath = Join-Path $qrCodeDir $filename
                    }

                    $svgContent | Out-File -FilePath $OutputPath -Encoding UTF8 -NoNewline
                    Write-Host "QR code saved to: $OutputPath" -ForegroundColor Green
                    
                    return
                }
                catch {
                    Write-Warning "Failed to save QR code file: $($_.Exception.Message)"
                }
            }
            
            if ($Raw) {
                return $svgContent
            }
            else {
                Write-Output $svgContent
            }
        }
        catch {
            Write-Error "Failed to generate SVG QR code: $($_.Exception.Message)"
        }
    }
}

function Test-QRCodeService {
    <#
    .SYNOPSIS
        Test connectivity to the qrcode.show service.

    .DESCRIPTION
        Verifies that the qrcode.show API service is accessible and responding.
        Useful for troubleshooting network connectivity issues.

    .EXAMPLE
        Test-QRCodeService
        Tests if the QR code service is available.

    .OUTPUTS
        Boolean
        Returns $true if service is accessible, $false otherwise.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/QRCode/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $response = Invoke-WebRequest -Uri "https://qrcode.show" -Method Get -TimeoutSec 10
        if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 405) {
            Write-Verbose "QR code service is accessible (HTTP $($response.StatusCode))"
            return $true
        }
        else {
            Write-Warning "QR code service returned unexpected status: HTTP $($response.StatusCode)"
            return $false
        }
    }
    catch {
        Write-Warning "QR code service is not accessible: $($_.Exception.Message)"
        return $false
    }
}

function Save-QRCode {
    <#
    .SYNOPSIS
        Generate and save a QR code to a file.

    .DESCRIPTION
        Creates a QR code and saves it directly to a specified file.
        Supports both PNG and SVG formats based on file extension.

    .PARAMETER InputText
        The text content to encode in the QR code.

    .PARAMETER Path
        The file path where the QR code will be saved.

    .PARAMETER Format
        The output format. Valid values are 'PNG' (default) and 'SVG'.
        If not specified, format is inferred from file extension.

    .EXAMPLE
        Save-QRCode -InputText "Hello World" -Path "qrcode.png"
        Saves a PNG QR code to qrcode.png.

    .EXAMPLE
        Save-QRCode -InputText "https://github.com" -Path "github.svg" -Format SVG
        Saves an SVG QR code to github.svg.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/QRCode/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$InputText,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Path,

        [Parameter()]
        [ValidateSet("PNG", "SVG")]
        [string]$Format
    )

    try {
        if (-not $Format) {
            $extension = [System.IO.Path]::GetExtension($Path).ToLower()
            $Format = switch ($extension) {
                ".svg" { "SVG" }
                default { "PNG" }
            }
        }

        if ($Format -eq "SVG") {
            $qrData = New-QRCodeSVG -InputText $InputText -Raw
        }
        else {
            $qrData = New-QRCode -InputText $InputText -Raw
        }

        $qrData | Out-File -FilePath $Path -Encoding UTF8 -NoNewline
        Write-Host "QR code saved to: $Path" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to save QR code to file: $($_.Exception.Message)"
    }
}
