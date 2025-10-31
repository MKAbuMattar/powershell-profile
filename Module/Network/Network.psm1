#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Network Module
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
#       This Module provides network-related functions for PowerShell scripts and modules.
#       Now uses Python backend for enhanced cross-platform compatibility.
#
# Created: 2021-09-01
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

# Helper function to find Python executable
function Get-PythonExecutable {
    $pythonCmd = $null
    
    # Try 'python' first
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $pythonCmd = "python"
    }
    # Fall back to 'python3'
    elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
        $pythonCmd = "python3"
    }
    
    if (-not $pythonCmd) {
        Write-Error "Python is not installed or not in PATH. Please install Python 3.6 or later."
        return $null
    }
    
    return $pythonCmd
}

function Get-MyIPAddress {
    <#
    .SYNOPSIS
        Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.

    .DESCRIPTION
        This function retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses using Python backend.

    .PARAMETER Local
        This switch retrieves the local IP address. Default is $true.

    .PARAMETER IPv4
        This switch retrieves the public IPv4 address. Default is $false.

    .PARAMETER IPv6
        This switch retrieves the public IPv6 address. Default is $false.

    .PARAMETER ComputerName
        The name of the computer to retrieve the IP address from. Default is the local computer name.

    .INPUTS
        Local: (Optional) Switch to retrieve the local IP address.
        IPv4: (Optional) Switch to retrieve the public IPv4 address.
        IPv6: (Optional) Switch to retrieve the public IPv6 address.
        ComputerName: (Optional) The name of the computer to retrieve the IP address from.

    .OUTPUTS
        The IP address of the local machine, and public IPv4 and IPv6 addresses.

    .NOTES
        Uses Python backend for cross-platform compatibility.

    .EXAMPLE
        Get-MyIPAddress -Local -IPv4 -IPv6
        Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.

    .EXAMPLE
        Get-MyIPAddress -Local
        Retrieves the IP address of the local machine.

    .EXAMPLE
        Get-MyIPAddress -IPv4
        Retrieves the public IPv4 address.

    .EXAMPLE
        Get-MyIPAddress -IPv6
        Retrieves the public IPv6 address.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("my-ip")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Switch to retrieve the local IP address."
        )]
        [Alias("l")]
        [switch]$Local = $true,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Switch to retrieve the public IPv4 address."
        )]
        [Alias("4")]
        [switch]$IPv4 = $false,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Switch to retrieve the public IPv6 address."
        )]
        [Alias("6")]
        [switch]$IPv6 = $false,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name of the computer to retrieve the IP address from."
        )]
        [Alias("c")]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    $pythonCmd = Get-PythonExecutable
    if (-not $pythonCmd) {
        return
    }

    $scriptPath = Join-Path $PSScriptRoot "network.py"
    
    if (-not (Test-Path $scriptPath)) {
        Write-Error "Network utility Python script not found at: $scriptPath"
        return
    }

    $arguments = @(
        $scriptPath,
        "ip"
    )

    if ($Local) {
        $arguments += "--local"
        if ($ComputerName -ne $env:COMPUTERNAME) {
            $arguments += "--hostname"
            $arguments += $ComputerName
        }
    }

    if ($IPv4) {
        $arguments += "--ipv4"
    }

    if ($IPv6) {
        $arguments += "--ipv6"
    }

    try {
        & $pythonCmd $arguments
    }
    catch {
        Write-Error "Failed to retrieve IP address: $_"
    }
}

function Clear-FlushDNS {
    <#
    .SYNOPSIS
        Flushes the DNS cache.

    .DESCRIPTION
        This function flushes the DNS cache using Python backend for cross-platform support.
        Supports Windows, macOS, and Linux.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any inputs.

    .OUTPUTS
        Success or error message.

    .NOTES
        Uses Python backend for cross-platform DNS cache flushing.
        May require administrator/root privileges.

    .EXAMPLE
        Clear-FlushDNS
        Flushes the DNS cache.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("flush-dns")]
    [OutputType([string])]
    param (
        # This function does not accept any parameters
    )

    $pythonCmd = Get-PythonExecutable
    if (-not $pythonCmd) {
        return
    }

    $scriptPath = Join-Path $PSScriptRoot "network.py"
    
    if (-not (Test-Path $scriptPath)) {
        Write-Error "Network utility Python script not found at: $scriptPath"
        return
    }

    $arguments = @(
        $scriptPath,
        "flush-dns"
    )

    try {
        & $pythonCmd $arguments
    }
    catch {
        Write-Error "Failed to flush DNS cache: $_"
    }
}

