#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Base64 Utility Module
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
#       This module provides Base64 encoding and decoding utilities for PowerShell.
#       It includes functions for encoding text and files to Base64 format,
#       and decoding Base64 content back to plain text.
#       Equivalent to bash/zsh encode64, encodefile64, and decode64 functions.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function ConvertTo-Base64 {
    <#
    .SYNOPSIS
        Encodes text or pipeline input to Base64 format.

    .DESCRIPTION
        Converts input text to Base64 encoding. Can accept input from the pipeline 
        or as a parameter. Equivalent to the bash/zsh encode64 function.

    .PARAMETER Text
        The text to encode to Base64. If not provided, reads from pipeline.

    .INPUTS
        String input that should be encoded to Base64.

    .OUTPUTS
        Base64 encoded string.

    .NOTES
        This function provides Base64 encoding functionality similar to the bash/zsh encode64 function.

    .EXAMPLE
        ConvertTo-Base64 "Hello World"
        Encodes "Hello World" to Base64.

    .EXAMPLE
        "Hello World" | ConvertTo-Base64
        Encodes "Hello World" from pipeline to Base64.

    .EXAMPLE
        Get-Content file.txt | ConvertTo-Base64
        Encodes content from file.txt to Base64.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("e64")]
    [OutputType([string])]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]]$Text
    )

    process {
        if ($Text) {
            foreach ($item in $Text) {
                if (![string]::IsNullOrEmpty($item)) {
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes($item)
                    [System.Convert]::ToBase64String($bytes)
                }
            }
        }
        else {
            $input | ForEach-Object {
                if (![string]::IsNullOrEmpty($_)) {
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes($_)
                    [System.Convert]::ToBase64String($bytes)
                }
            }
        }
    }
}

function ConvertTo-Base64File {
    <#
    .SYNOPSIS
        Encodes a file's content to Base64 and saves it to a new file.

    .DESCRIPTION
        Reads a file, encodes its content to Base64, and saves the result to a new file 
        with .txt extension. Equivalent to the bash/zsh encodefile64 function.

    .PARAMETER FilePath
        The path to the file to encode.

    .INPUTS
        String path to the file that should be encoded.

    .OUTPUTS
        Creates a new file with Base64 encoded content.

    .NOTES
        This function provides file Base64 encoding functionality similar to the bash/zsh encodefile64 function.

    .EXAMPLE
        ConvertTo-Base64File "document.pdf"
        Encodes document.pdf to Base64 and saves as document.pdf.txt.

    .EXAMPLE
        ConvertTo-Base64File -FilePath "C:\temp\image.png"
        Encodes the image file and saves the Base64 content to image.png.txt.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("ef64")]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if (Test-Path $_) { $true }
                else { throw "File '$_' does not exist." }
            })]
        [string]$FilePath
    )

    process {
        try {
            $resolvedPath = Resolve-Path $FilePath
            $fileName = $resolvedPath.Path
            $outputFile = "$fileName.txt"

            $bytes = [System.IO.File]::ReadAllBytes($fileName)
            $base64Content = [System.Convert]::ToBase64String($bytes)
            
            [System.IO.File]::WriteAllText($outputFile, $base64Content)
            
            Write-Host "'$fileName' content encoded in base64 and saved as '$outputFile'" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to encode file '$FilePath': $($_.Exception.Message)"
        }
    }
}

function ConvertFrom-Base64 {
    <#
    .SYNOPSIS
        Decodes Base64 encoded text to plain text.

    .DESCRIPTION
        Converts Base64 encoded input back to plain text. Can accept input from the pipeline 
        or as a parameter. Equivalent to the bash/zsh decode64 function.

    .PARAMETER Base64Text
        The Base64 encoded text to decode. If not provided, reads from pipeline.

    .INPUTS
        Base64 encoded string that should be decoded.

    .OUTPUTS
        Decoded plain text string.

    .NOTES
        This function provides Base64 decoding functionality similar to the bash/zsh decode64 function.

    .EXAMPLE
        ConvertFrom-Base64 "SGVsbG8gV29ybGQ="
        Decodes the Base64 string back to "Hello World".

    .EXAMPLE
        "SGVsbG8gV29ybGQ=" | ConvertFrom-Base64
        Decodes the Base64 string from pipeline.

    .EXAMPLE
        Get-Content encoded.txt | ConvertFrom-Base64
        Decodes Base64 content from encoded.txt file.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("d64")]
    [OutputType([string])]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]]$Base64Text
    )

    process {
        if ($Base64Text) {
            foreach ($item in $Base64Text) {
                if (![string]::IsNullOrEmpty($item)) {
                    try {
                        $bytes = [System.Convert]::FromBase64String($item.Trim())
                        [System.Text.Encoding]::UTF8.GetString($bytes)
                    }
                    catch {
                        Write-Error "Invalid Base64 string: $item"
                    }
                }
            }
        }
        else {
            $input | ForEach-Object {
                if (![string]::IsNullOrEmpty($_)) {
                    try {
                        $bytes = [System.Convert]::FromBase64String($_.Trim())
                        [System.Text.Encoding]::UTF8.GetString($bytes)
                    }
                    catch {
                        Write-Error "Invalid Base64 string: $_"
                    }
                }
            }
        }
    }
}
