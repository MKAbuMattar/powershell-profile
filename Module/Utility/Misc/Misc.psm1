#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Misc Module
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
#       This Module provides a set of miscellaneous utility functions for various 
#       common tasks in PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Helper Functions
#---------------------------------------------------------------------------------------------------

function Get-PythonExecutable {
    <#
    .SYNOPSIS
        Gets the path to the Python executable.

    .DESCRIPTION
        This function attempts to find the Python executable in the system PATH.

    .OUTPUTS
        The path to the Python executable, or $null if not found.
    #>
    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCmd) {
        return $pythonCmd.Source
    }
    return $null
}

#---------------------------------------------------------------------------------------------------
# Import the custom misc modules
#---------------------------------------------------------------------------------------------------

function Test-Administrator {
    <#
    .SYNOPSIS
        Test if the current user has administrator privileges.

    .DESCRIPTION
        This function checks if the current user has administrator privileges using Python backend.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        ${true}: If the user has administrator privileges.
        ${false}: If the user does not have administrator privileges.

    .NOTES
        This function is useful for determining if the current user has administrator privileges.

    .EXAMPLE
        Test-Administrator
        Checks if the current user has administrator privileges.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("is-admin")]
    [OutputType([bool])]
    param (
        # This function does not accept any parameters
    )

    $python = Get-PythonExecutable
    if (-not $python) {
        Write-Error "Python is not installed or not in PATH"
        return $false
    }

    $scriptPath = Join-Path $PSScriptRoot "misc.py"
    $result = & $python $scriptPath is-admin 2>&1
    return $LASTEXITCODE -eq 0
}

function Test-CommandExists {
    <#
    .SYNOPSIS
        Checks if a command exists in the current environment.

    .DESCRIPTION
        This function checks whether a specified command exists using Python backend.

    .PARAMETER Command
        Specifies the command to check for existence.

    .INPUTS
        Command: (Required) The command to check for existence.

    .OUTPUTS
        ${exists}: True if the command exists, false otherwise.

    .NOTES
        This function is useful for verifying the availability of commands in the current environment.

    .EXAMPLE
        Test-CommandExists "ls"
        Checks if the "ls" command exists in the current environment.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("command-exists")]
    [OutputType([bool])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The command to check for existence."
        )]
        [Alias("c")]
        [string]$Command
    )

    $python = Get-PythonExecutable
    if (-not $python) {
        Write-Error "Python is not installed or not in PATH"
        return $false
    }

    $scriptPath = Join-Path $PSScriptRoot "misc.py"
    $result = & $python $scriptPath command-exists $Command 2>&1
    return $LASTEXITCODE -eq 0
}

function Invoke-ReloadProfile {
    <#
    .SYNOPSIS
        Reloads the PowerShell profile to apply changes.

    .DESCRIPTION
        This function reloads the current PowerShell profile to apply any changes made to it. It is useful for immediately applying modifications to the profile without restarting the shell.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for quickly reloading the PowerShell profile to apply changes without restarting the shell.

    .EXAMPLE
        Invoke-ProfileReload
        Reloads the PowerShell profile.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("reload-profile")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    try {
        & $profile
        Write-LogMessage -Message "PowerShell profile reloaded successfully." -Level "INFO"
    }
    catch {
        Write-LogMessage -Message "Failed to reload the PowerShell profile." -Level "ERROR"
    }
}

function Get-Uptime {
    <#
    .SYNOPSIS
        Retrieves the system uptime in a human-readable format.

    .DESCRIPTION
        This function retrieves the system uptime using Python backend for cross-platform support.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        The system uptime in a human-readable format.

    .NOTES
        This function is useful for checking how long the system has been running since the last boot.

    .EXAMPLE
        Get-Uptime
        Retrieves the system uptime.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("uptime")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    $python = Get-PythonExecutable
    if (-not $python) {
        Write-Error "Python is not installed or not in PATH"
        return
    }

    $scriptPath = Join-Path $PSScriptRoot "misc.py"
    & $python $scriptPath uptime
}

function Get-CommandDefinition {
    <#
    .SYNOPSIS
        Gets the definition of a command.

    .DESCRIPTION
        This function retrieves the definition of a specified command. It is useful for understanding the functionality and usage of PowerShell cmdlets and functions.

    .PARAMETER Name
        Specifies the name of the command to retrieve the definition for.

    .INPUTS
        Name: (Required) The name of the command to retrieve the definition for.

    .OUTPUTS
        The definition of the specified command.

    .NOTES
        This function is useful for quickly retrieving the definition of a command.

    .EXAMPLE
        Get-CommandDefinition "ls"
        Retrieves the definition of the "ls" command.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("def")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name of the command to retrieve the definition for."
        )]
        [Alias("n")]
        [string]$Name
    )

    try {
        $definition = Get-Command $Name -ErrorAction Stop | Select-Object -ExpandProperty Definition
        if ($definition) {
            Write-Output $definition
        }
        else {
            Write-LogMessage -Message "Command '$Name' not found." -Level "WARNING"
        }
    }
    catch {
        Write-LogMessage -Message "An error occurred while retrieving the definition of '$Name'." -Level "ERROR"
    }
}

function Get-DiskUsage {
    <#
    .SYNOPSIS
        Gets the disk usage for specified paths.

    .DESCRIPTION
        This function retrieves the disk usage for specified paths using Python backend for better performance.

    .PARAMETER Path
        Specifies the paths to get the disk usage for. If not specified, the current directory is used.

    .PARAMETER HumanReadable
        Indicates whether to display the sizes in a human-readable format (e.g., KB, MB, GB). The default value is $true.

    .PARAMETER Sort
        Indicates whether to sort the results. The default value is $false.

    .PARAMETER SortBy
        Specifies the property to sort by. The default value is "Size". Valid values are "Name" and "Size".

    .INPUTS
        Path: (Optional) The paths to get the disk usage for. If not specified, the current directory is used.
        HumanReadable: (Optional) Indicates whether to display the sizes in a human-readable format. The default value is $true.
        Sort: (Optional) Indicates whether to sort the results. The default value is $false.
        SortBy: (Optional) Specifies the property to sort by. The default value is "Size". Valid values are "Name" and "Size".

    .OUTPUTS
        This function returns a formatted output of the disk usage for the specified paths.

    .NOTES
        This function is useful for checking the disk usage of directories and files in a specified path.

    .EXAMPLE
        Get-DiskUsage
        Gets the disk usage for the current directory and displays the sizes in a human-readable format.

    .EXAMPLE
        Get-DiskUsage -Path "C:\Users\Username\Documents"
        Gets the disk usage for the specified path and displays the sizes in a human-readable format.

    .EXAMPLE
        Get-DiskUsage -Path "C:\Users\Username\Documents" -HumanReadable:$false
        Gets the disk usage for the specified path and displays the sizes in bytes.

    .EXAMPLE
        Get-DiskUsage -Path "C:\Users\Username\Documents" -Sort -SortBy "Name"
        Gets the disk usage for the specified path, sorts the results by name, and displays the sizes in a human-readable format.

    .EXAMPLE
        Get-DiskUsage -Path "C:\Users\Username\Documents" -Sort -SortBy "Size"
        Gets the disk usage for the specified path, sorts the results by size, and displays the sizes in a human-readable format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias('du')]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The paths to get the disk usage for. If not specified, the current directory is used."
        )]
        [Alias('p')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path = (Get-Location).Path,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to display the sizes in a human-readable format (e.g., KB, MB, GB). The default value is true."
        )]
        [Alias('hr')]
        [ValidateNotNullOrEmpty()]
        [switch]$HumanReadable,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to sort the results. The default value is false."
        )]
        [Alias('s')]
        [ValidateNotNullOrEmpty()]
        [switch]$Sort,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Specifies the property to sort by. The default value is 'Size'. Valid values are 'Name' and 'Size'."
        )]
        [Alias('sb')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Name', 'Size')]
        [string]$SortBy = 'Size'
    )

    process {
        $python = Get-PythonExecutable
        if (-not $python) {
            Write-Error "Python is not installed or not in PATH"
            return
        }

        $scriptPath = Join-Path $PSScriptRoot "misc.py"
        
        $args = @('du', '--path')
        $args += $Path
        
        if ($PSBoundParameters.ContainsKey('HumanReadable') -and -not $HumanReadable) {
            $args += '--no-human-readable'
        }
        
        if ($Sort) {
            $args += '--sort'
            $args += '--sort-by'
            $args += $SortBy.ToLower()
        }
        
        & $python $scriptPath @args
    }
}
