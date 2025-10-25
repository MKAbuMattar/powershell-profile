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
#       Uses Python backend for encoding/decoding operations.
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function ConvertTo-Base64 {
    <#
    .SYNOPSIS
        Encodes text to Base64 format.

    .DESCRIPTION
        Converts input text to Base64 encoding using the Python backend.
        Can accept input from the pipeline or as a parameter.

    .PARAMETER Text
        The text to encode to Base64. If not provided, reads from pipeline.

    .INPUTS
        String input that should be encoded to Base64.

    .OUTPUTS
        Base64 encoded string.

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
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("e64")]
    [OutputType([string])]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]]$Text
    )

    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "base64_util.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "base64_util.py not found at: $pythonScript"
            return
        }

        $pythonCmd = $null
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                return
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        if ($Text) {
            foreach ($item in $Text) {
                if (-not [string]::IsNullOrEmpty($item)) {
                    try {
                        $arguments = @($pythonScript, "--encode", $item)
                        & $pythonPath $arguments 2>&1
                    }
                    catch {
                        Write-Error "Failed to encode text: $_"
                    }
                }
            }
        }
        else {
            $input | ForEach-Object {
                if (-not [string]::IsNullOrEmpty($_)) {
                    try {
                        $arguments = @($pythonScript, "--encode", $_)
                        & $pythonPath $arguments 2>&1
                    }
                    catch {
                        Write-Error "Failed to encode text: $_"
                    }
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
        Reads a file, encodes its content to Base64, and saves the result to a new file.
        Uses the Python backend for encoding.

    .PARAMETER FilePath
        The path to the file to encode.

    .PARAMETER OutputPath
        Optional path for the output file. If not specified, adds .txt extension.

    .INPUTS
        String path to the file that should be encoded.

    .OUTPUTS
        Creates a new file with Base64 encoded content.

    .EXAMPLE
        ConvertTo-Base64File "document.pdf"
        Encodes document.pdf to Base64 and saves as document.pdf.txt.

    .EXAMPLE
        ConvertTo-Base64File -FilePath "C:\temp\image.png" -OutputPath "C:\temp\image.b64"
        Encodes the image file and saves the Base64 content to image.b64.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "base64_util.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "base64_util.py not found at: $pythonScript"
            return
        }

        $pythonCmd = $null
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                return
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            $resolvedPath = Resolve-Path $FilePath
            
            if ($OutputPath) {
                $arguments = @($pythonScript, "--encode-file", $resolvedPath.Path, "-o", $OutputPath)
            }
            else {
                $arguments = @($pythonScript, "--encode-file", $resolvedPath.Path)
            }
            
            & $pythonPath $arguments 2>&1
        }
        catch {
            Write-Error "Failed to encode file '$FilePath': $_"
        }
    }
}

function ConvertFrom-Base64 {
    <#
    .SYNOPSIS
        Decodes Base64 encoded text to plain text.

    .DESCRIPTION
        Converts Base64 encoded input back to plain text. Can accept input from the pipeline
        or as a parameter. Uses the Python backend for decoding.

    .PARAMETER Base64Text
        The Base64 encoded text to decode. If not provided, reads from pipeline.

    .INPUTS
        Base64 encoded string that should be decoded.

    .OUTPUTS
        Decoded plain text string.

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
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("d64")]
    [OutputType([string])]
    param(
        [Parameter(ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string[]]$Base64Text
    )

    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "base64_util.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "base64_util.py not found at: $pythonScript"
            return
        }

        # Try 'python' first, then 'python3'
        $pythonCmd = $null
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                return
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        if ($Base64Text) {
            foreach ($item in $Base64Text) {
                if (-not [string]::IsNullOrEmpty($item)) {
                    try {
                        $arguments = @($pythonScript, "--decode", $item)
                        & $pythonPath $arguments 2>&1
                    }
                    catch {
                        Write-Error "Failed to decode Base64: $_"
                    }
                }
            }
        }
        else {
            $input | ForEach-Object {
                if (-not [string]::IsNullOrEmpty($_)) {
                    try {
                        $arguments = @($pythonScript, "--decode", $_)
                        & $pythonPath $arguments 2>&1
                    }
                    catch {
                        Write-Error "Failed to decode Base64: $_"
                    }
                }
            }
        }
    }
}

function ConvertFrom-Base64File {
    <#
    .SYNOPSIS
        Decodes a Base64 encoded file back to its original format.

    .DESCRIPTION
        Reads a Base64 encoded file, decodes it, and saves the result to a new file.
        Uses the Python backend for decoding.

    .PARAMETER FilePath
        The path to the Base64 encoded file.

    .PARAMETER OutputPath
        Optional path for the output file. If not specified, removes .txt or .b64 extension.

    .INPUTS
        String path to the Base64 encoded file.

    .OUTPUTS
        Creates a new file with decoded content.

    .EXAMPLE
        ConvertFrom-Base64File "document.pdf.txt"
        Decodes document.pdf.txt and saves as document.pdf.

    .EXAMPLE
        ConvertFrom-Base64File -FilePath "encoded.txt" -OutputPath "decoded.bin"
        Decodes encoded.txt and saves the binary content to decoded.bin.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("df64")]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if (Test-Path $_) { $true }
                else { throw "File '$_' does not exist." }
            })]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "base64_util.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "base64_util.py not found at: $pythonScript"
            return
        }

        # Try 'python' first, then 'python3'
        $pythonCmd = $null
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                return
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            $resolvedPath = Resolve-Path $FilePath
            
            if ($OutputPath) {
                $arguments = @($pythonScript, "--decode-file", $resolvedPath.Path, "-o", $OutputPath)
            }
            else {
                $arguments = @($pythonScript, "--decode-file", $resolvedPath.Path)
            }
            
            & $pythonPath $arguments 2>&1
        }
        catch {
            Write-Error "Failed to decode file '$FilePath': $_"
        }
    }
}

