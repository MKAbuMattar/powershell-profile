#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Environment Module
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
#       This Module contains functions to manage environment variables and the PATH variable.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Set environment variables for the PowerShell profile Auto Update.

.DESCRIPTION
    This script sets environment variables to disable the Auto Update feature for the PowerShell profile.

.INPUTS
    None.

.OUTPUTS
    Environment variables for the PowerShell profile Auto Update.

.NOTES
    This script is used to disable/enable the Auto Update feature for the PowerShell profile.

.LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
$global:AutoUpdateProfile = [bool]$false

<#
.SYNOPSIS
    Set environment variables for the PowerShell Auto Update.

.DESCRIPTION
    This script sets environment variables to disable the Auto Update feature for PowerShell.

.OUTPUTS
    Environment variables for the PowerShell Auto Update.

.NOTES
    This script is used to disable/enable the Auto Update feature for PowerShell.
#>
$global:AutoUpdatePowerShell = [bool]$false

<#
.SYNOPSIS
    Set environment variables for Testing GitHub connectivity.

.DESCRIPTION
    This script sets environment variables to test if the machine can connect to GitHub.

INPUTS
    None.

.OUTPUTS
    Environment variables for Testing GitHub connectivity.

.NOTES
    This script is used to test if the machine can connect to GitHub.

.LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
$global:CanConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

function Invoke-ReloadPathEnvironmentVariable {
    <#
    .SYNOPSIS
        Reloads the PATH environment variable.

    .DESCRIPTION
        This function reloads the PATH environment variable by setting it to the current value of the PATH environment variable.

    .INPUTS
        None.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for reloading the PATH environment variable within a PowerShell session.

    .EXAMPLE
        Invoke-ReloadPathEnvironmentVariable
        Reloads the PATH environment variable.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("reload-env-path", "reload-path")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    $env:Path = (Get-PathEnvironmentVariable | Select-Object -ExpandProperty Path) -join ';'
}

function Get-PathEnvironmentVariable {
    <#
    .SYNOPSIS
        Retrieves the PATH environment variable.

    .DESCRIPTION
        This function retrieves the PATH environment variable and returns the value of the PATH environment variable.

    .PARAMETER Scope
        Specifies the scope of the PATH environment variable to retrieve. The default value is "All".

    .INPUTS
        Scope: (Optional) Specifies the scope of the PATH environment variable to retrieve.

    .OUTPUTS
        The value of the PATH environment variable.

    .NOTES
        This function is useful for retrieving the value of the PATH environment variable within a PowerShell session.

    .EXAMPLE
        Get-PathEnvironmentVariable
        Retrieves the value of the PATH environment variable.

    .EXAMPLE
        Get-PathEnvironmentVariable -Scope "User"
        Retrieves the value of the PATH environment variable for the current user.

    .EXAMPLE
        Get-PathEnvironmentVariable -Scope "Machine"
        Retrieves the value of the PATH environment variable for the machine.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("get-env-path", "get-path")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The scope of the PATH environment variable to retrieve."
        )]
        [ValidateSet(
            'User',
            'Machine',
            'All'
        )]
        [Alias('s')]
        [string]
        $Scope = 'All'
    )

    $machine_paths = try {
        [System.Environment]::GetEnvironmentVariable('Path', 'Machine').Split(';') `
        | Select-Object @{name = 'Path'; exp = { $_ } }, @{name = 'Scope'; exp = { 'Machine' } } `
        | Where-Object { $_.Path }
    }
    catch {
        $null
    }

    $user_paths = try {
        [System.Environment]::GetEnvironmentVariable('Path', 'User').Split(';') `
        | Select-Object @{name = 'Path'; exp = { $_ } }, @{name = 'Scope'; exp = { 'User' } } `
        | Where-Object { $_.Path }
    }
    catch {
        $null
    }

    switch ($Scope) {
        'User' {
            return $user_paths
        }
        'Machine' {
            return $machine_paths
        }
        default {
            return $machine_paths + $user_paths
        }
    }
}

function Add-PathEnvironmentVariable {
    <#
    .SYNOPSIS
        Sets the PATH environment variable.

    .DESCRIPTION
        This function sets the PATH environment variable with the specified value.

    .PARAMETER Path
        Specifies the value to set the PATH environment variable to.

    .PARAMETER Scope
        Specifies the scope of the PATH environment variable to set. The default value is "Process".

    .PARAMETER Append
        Appends the specified value to the PATH environment variable.

    .PARAMETER Prepend
        Prepends the specified value to the PATH environment variable.

    .PARAMETER MakeShort
        Converts the specified path to its short form before setting it in the PATH environment variable.

    .PARAMETER Quiet
        Suppresses the output of the function.

    .INPUTS
        Path: (Required) The value to set the PATH environment variable to.
        Scope: (Optional) The scope of the PATH environment variable to set.
        Append: (Optional) Appends the specified value to the PATH environment variable.
        Prepend: (Optional) Prepends the specified value to the PATH environment variable.
        MakeShort: (Optional) Converts the specified path to its short form before setting it in the PATH environment variable.
        Quiet: (Optional) Suppresses the output of the function.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for setting the PATH environment variable within a PowerShell session.

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example"
        Sets the PATH environment variable to "C:\Program Files\Example".

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example" -Scope "User"
        Sets the PATH environment variable for the current user to "C:\Program Files\Example".

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example" -Scope "Machine"
        Sets the PATH environment variable for the machine to "C:\Program Files\Example".

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example" -Append
        Appends "C:\Program Files\Example" to the PATH environment variable.

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example" -Prepend
        Prepends "C:\Program Files\Example" to the PATH environment variable.

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example" -MakeShort
        Converts "C:\Program Files\Example" to its short form before setting it in the PATH environment variable.

    .EXAMPLE
        Set-PathEnvironmentVariable "C:\Program Files\Example" -Quiet
        Sets the PATH environment variable to "C:\Program Files\Example" without displaying any output.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias(
        "add-path",
        "set-path"
    )]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The value to set the PATH environment variable to."
        )]
        [Alias('p')]
        [string[]]$Path,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The scope of the PATH environment variable to set."
        )]
        [ValidateSet(
            'Process',
            'User',
            'Machine'
        )]
        [Alias('s')]
        [string]$Scope = 'Process',

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Appends the specified value to the PATH environment variable."
        )]
        [Alias('a')]
        [switch]$Append = $true,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Prepends the specified value to the PATH environment variable."
        )]
        [Alias('p')]
        [switch]$Prepend,

        [Parameter(
            Mandatory = $false,
            Position = 4,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Converts the specified path to its short form before setting it in the PATH environment variable."
        )]
        [Alias('m')]
        [switch]$MakeShort,

        [Parameter(
            Mandatory = $false,
            Position = 5,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Suppresses the output of the function."
        )]
        [Alias('q')]
        [switch]$Quiet
    )

    $machine_paths = @(Get-PathEnvironmentVariable -Scope Machine | Select-Object -ExpandProperty Path)
    $user_paths = @(Get-PathEnvironmentVariable -Scope User | Select-Object -ExpandProperty Path)

    if ($MakeShort) {
        $Path = $Path | Get-ShortPath
    }

    switch ($Scope) {
        'User' {
            if ($Prepend) {
                $user_paths = $Path + $user_paths
            }
            else {
                $user_paths = $user_paths + $Path
            }
            Set-PathEnvironmentVariable -Path $user_paths -Scope 'User' -ErrorAction Stop
            Reload-PathEnvironmentVariable
        }
        'Machine' {
            if ($Prepend) {
                $machine_paths = $Path + $machine_paths
            }
            else {
                $machine_paths = $machine_paths + $Path
            }
            Set-PathEnvironmentVariable -Path $machine_paths -Scope 'Machine' -ErrorAction Stop
            Reload-PathEnvironmentVariable
        }
        default {
            if ($Prepend) {
                $env:Path = ($Path + $env:Path.Split(';') ) -join ';'
            }
            else {
                $env:Path = ($env:Path.Split(';') + $Path) -join ';'
            }
        }
    }

    if (-not $Quiet) {
        Write-Host "Added the following path(s) to PATH environment variable of scope " -NoNewline
        Write-Host "$Scope`n`t" -NoNewline -ForegroundColor Yellow
        Write-Host $Path -Separator "`n`t" -ForegroundColor Yellow
    }
}

function Remove-PathEnvironmentVariable {
    <#
    .SYNOPSIS
        Removes a path from the PATH environment variable.

    .DESCRIPTION
        This function removes the specified path from the PATH environment variable.

    .PARAMETER Path
        Specifies the path to remove from the PATH environment variable.

    .PARAMETER Scope
        Specifies the scope of the PATH environment variable to remove the path from. The default value is "Process".

    .PARAMETER Force
        Forces the removal of the specified path from the PATH environment variable.

    .INPUTS
        Path: (Required) The path to remove from the PATH environment variable.
        Scope: (Optional) The scope of the PATH environment variable to remove the path from.
        Force: (Optional) Forces the removal of the specified path from the PATH environment variable.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for removing a path from the PATH environment variable within a PowerShell session.

    .EXAMPLE
        Remove-PathEnvironmentVariable "C:\Program Files\Example"
        Removes "C:\Program Files\Example" from the PATH environment variable.

    .EXAMPLE
        Remove-PathEnvironmentVariable "C:\Program Files\Example" -Scope "User"
        Removes "C:\Program Files\Example" from the PATH environment variable for the current user.

    .EXAMPLE
        Remove-PathEnvironmentVariable "C:\Program Files\Example" -Scope "Machine"
        Removes "C:\Program Files\Example" from the PATH environment variable for the machine.

    .EXAMPLE
        Remove-PathEnvironmentVariable "C:\Program Files\Example" -Force
        Forces the removal of "C:\Program Files\Example" from the PATH environment variable.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The path to remove from the PATH environment variable."
        )]
        [string[]]$Path,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The scope of the PATH environment variable to remove the path from."
        )]
        [ValidateSet(
            'Process',
            'User',
            'Machine'
        )]
        [Alias('s')]
        [string]$Scope = 'Process',

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Forces the removal of the specified path from the PATH environment variable."
        )]
        [Alias('f')]
        [switch]$Force
    )

    $old_paths = switch ($Scope) {
        'Process' { $env:Path -split ';' }
        default { Get-PathEnvironmentVariable -Scope $Scope | Select-Object -ExpandProperty Path }
    }
    $requested_paths = @()
    Write-Verbose "Old paths of scope $Scope`:"
    $old_paths | Write-Verbose

    $requested_paths += $Path

    Write-Verbose "Request to remove paths:"
    $requested_paths | Write-Verbose
    $notfound_paths = $requested_paths | Where-Object { $_ -notin $old_paths }
    $toberemoved_paths = $requested_paths | Where-Object { $_ -in $old_paths }

    if ($notfound_paths) {
        Write-Host "Could not find the following path(s) in PATH environment variable of scope " -NoNewline
        Write-Host "$Scope`n`t" -NoNewline -ForegroundColor Yellow
        Write-Host $notfound_paths -ForegroundColor Red -Separator "`n`t"
    }

    if ($toberemoved_paths) {
        $new_paths = $old_paths | Where-Object { $_ -and ($_ -notin $requested_paths) }
        Write-Verbose "Paths to remove:"
        $toberemoved_paths | Write-Verbose
        Write-Verbose "New paths of scope $Scope`:"
        $new_paths | Write-Verbose
        try {
            Set-PathEnvironmentVariable -Path $new_paths -Scope $Scope
        }
        catch {
            return
        }
        Write-Host "Removed the following path(s) from PATH environment variable of scope " -NoNewline
        Write-Host "$Scope`n`t" -NoNewline -ForegroundColor Yellow
        Write-Host $toberemoved_paths -ForegroundColor Yellow -Separator "`n`t"
    }
}

function Set-EnvVar {
    <#
    .SYNOPSIS
        Exports an environment variable.

    .DESCRIPTION
        This function exports an environment variable with the specified name and value. It sets the specified environment variable with the provided value.

    .PARAMETER Name
        Specifies the name of the environment variable.

    .PARAMETER Value
        Specifies the value of the environment variable.

    .INPUTS
        Name: (Required) The name of the environment variable to export.
        Value: (Required) The value of the environment variable to export.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for exporting environment variables within a PowerShell session.

    .EXAMPLE
        Set-EnvVar "name" "value"
        Exports an environment variable named "name" with the value "value".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias(
        "set-env",
        "export"
    )]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name of the environment variable to export."
        )]
        [Alias("n")]
        [string]$Name,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The value of the environment variable to export."
        )]
        [Alias("v")]
        [string]$Value
    )

    try {
        Set-Item -Force -Path "env:$Name" -Value $Value -ErrorAction Stop
    }
    catch {
        Write-LogMessage -Message "Failed to export environment variable '$Name'." -Level "ERROR"
    }
}

function Get-EnvVar {
    <#
    .SYNOPSIS
        Retrieves the value of an environment variable.

    .DESCRIPTION
        This function retrieves the value of the specified environment variable. It returns the value of the environment variable if it exists.

    .PARAMETER Name
        Specifies the name of the environment variable to retrieve the value for.

    .INPUTS
        Name: (Required) The name of the environment variable to retrieve the value for.

    .OUTPUTS
        The value of the specified environment variable.

    .NOTES
        This function is useful for retrieving the value of environment variables within a PowerShell session.

    .EXAMPLE
        Get-EnvVar "name"
        Retrieves the value of the environment variable named "name".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("get-env")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name of the environment variable to retrieve the value for."
        )]
        [Alias("n")]
        [string]$Name
    )

    try {
        $value = Get-Item -Path "env:$Name" -ErrorAction Stop | Select-Object -ExpandProperty Value
        if ($value) {
            Write-Output $value
        }
        else {
            Write-LogMessage -Message "Environment variable '$Name' not found." -Level "WARNING"
        }
    }
    catch {
        Write-LogMessage -Message "An error occurred while retrieving the value of environment variable '$Name'." -Level "ERROR"
    }
}
