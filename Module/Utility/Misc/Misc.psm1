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
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Import the custom misc modules
#---------------------------------------------------------------------------------------------------

function Test-Administrator {
    <#
    .SYNOPSIS
        Test if the current user has administrator privileges.

    .DESCRIPTION
        This function checks if the current user has administrator privileges. It returns a boolean value indicating whether the user is an administrator.

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

    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Test-CommandExists {
    <#
    .SYNOPSIS
        Checks if a command exists in the current environment.

    .DESCRIPTION
        This function checks whether a specified command exists in the current PowerShell environment. It returns a boolean value indicating whether the command is available.

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

    $exists = $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
    return $exists
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
        This function retrieves the system uptime in a human-readable format. It provides information about how long the system has been running since the last boot.

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

    try {
        if ($PSVersionTable.PSVersion.Major -eq 5) {
            $lastBoot = (Get-WmiObject win32_operatingsystem).LastBootUpTime
            $bootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($lastBoot)
        }
        else {
            $lastBootStr = net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
            if ($lastBootStr -match '^\d{2}/\d{2}/\d{4}') {
                $dateFormat = 'dd/MM/yyyy'
            }
            elseif ($lastBootStr -match '^\d{2}-\d{2}-\d{4}') {
                $dateFormat = 'dd-MM-yyyy'
            }
            elseif ($lastBootStr -match '^\d{4}/\d{2}/\d{2}') {
                $dateFormat = 'yyyy/MM/dd'
            }
            elseif ($lastBootStr -match '^\d{4}-\d{2}-\d{2}') {
                $dateFormat = 'yyyy-MM-dd'
            }
            elseif ($lastBootStr -match '^\d{2}\.\d{2}\.\d{4}') {
                $dateFormat = 'dd.MM.yyyy'
            }

            if ($lastBootStr -match '\bAM\b' -or $lastBootStr -match '\bPM\b') {
                $timeFormat = 'h:mm:ss tt'
            }
            else {
                $timeFormat = 'HH:mm:ss'
            }

            $bootTime = [System.DateTime]::ParseExact($lastBootStr, "$dateFormat $timeFormat", [System.Globalization.CultureInfo]::InvariantCulture)
        }


        $formattedBootTime = $bootTime.ToString("dddd, MMMM dd, yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture) + " [$lastBootStr]"
        Write-Host ("System started on: {0}" -f $formattedBootTime) -ForegroundColor DarkGray

        $uptime = (Get-Date) - $bootTime

        $days = $uptime.Days
        $hours = $uptime.Hours
        $minutes = $uptime.Minutes
        $seconds = $uptime.Seconds

        Write-Host ("Uptime: {0} days, {1} hours, {2} minutes, {3} seconds" -f $days, $hours, $minutes, $seconds) -ForegroundColor Blue
    }
    catch {
        Write-Error "An error occurred while retrieving system uptime."
    }
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
        This function retrieves the disk usage for specified paths, displaying the size of each item in a human-readable format. It can also sort the results by name or size.

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
        if ($PSBoundParameters.ContainsKey('HumanReadable') -eq $false) {
            $HumanReadable = $true
        }

        foreach ($p in $Path) {
            $resolvedPath = Resolve-Path -Path $p -ErrorAction SilentlyContinue
            if (-not $resolvedPath) {
                Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                Write-Host "Path: $p" -ForegroundColor White
                Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                Write-Host "Error: " -NoNewline -ForegroundColor Yellow
                Write-Host "Path not found" -ForegroundColor Red
                Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                continue
            }

            if (-not (Test-Path -Path $resolvedPath -PathType Container)) {
                $fileItem = Get-Item -Path $resolvedPath -Force -ErrorAction SilentlyContinue
                if ($fileItem) {
                    $fileSize = $fileItem.Length
                    $hrSizeStr = if ($HumanReadable) {
                        Format-ConvertSize -Value $fileSize -DecimalPlaces 2
                    }
                    else {
                        "N/A"
                    }

                    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                    Write-Host "File: $($fileItem.FullName)" -ForegroundColor White
                    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan

                    Write-Host "Size: " -NoNewline -ForegroundColor Yellow

                    $sizeColor = "White"
                    if ($fileSize -gt 1GB) {
                        $sizeColor = "Red"
                    }
                    elseif ($fileSize -gt 100MB) {
                        $sizeColor = "Yellow"
                    }
                    elseif ($fileSize -gt 10MB) {
                        $sizeColor = "Green"
                    }

                    Write-Host "$hrSizeStr" -ForegroundColor $sizeColor
                    Write-Host "Type: " -NoNewline -ForegroundColor Yellow
                    Write-Host "File" -ForegroundColor White
                    Write-Host "Last Modified: " -NoNewline -ForegroundColor Yellow
                    Write-Host "$($fileItem.LastWriteTime)" -ForegroundColor White
                    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                }
                else {
                    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                    Write-Host "File: $resolvedPath" -ForegroundColor White
                    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                    Write-Host "Error: " -NoNewline -ForegroundColor Yellow
                    Write-Host "Cannot access file (Permission Denied)" -ForegroundColor Red
                    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                }
                continue
            }

            Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
            Write-Host "Disk usage for: $resolvedPath" -ForegroundColor White
            Write-Host "-----------------------------------------------------" -ForegroundColor Cyan

            $childItems = $null
            $accessError = $null
            try {
                $childItems = Get-ChildItem -Path $resolvedPath -Depth 0 -Force -ErrorAction Stop
            }
            catch [System.UnauthorizedAccessException] {
                $accessError = $_.Exception
            }
            catch {
                $errorMsg = $_.Exception.Message
                Write-Host "Error: " -NoNewline -ForegroundColor Yellow
                Write-Host "Error listing contents of $resolvedPath`: $errorMsg" -ForegroundColor Red
                Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                continue
            }

            if ($accessError) {
                Write-Host "Error: " -NoNewline -ForegroundColor Yellow
                Write-Host "Cannot list contents - Permission Denied" -ForegroundColor Red
                Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                continue
            }
            if ($null -eq $childItems -and $Error.Count -gt 0 -and $Error[0].Exception -is [System.UnauthorizedAccessException]) {
                Write-Host "Error: " -NoNewline -ForegroundColor Yellow
                Write-Host "Cannot list contents - Permission Denied" -ForegroundColor Red
                Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
                $Error.Clear()
                continue
            }
            $Error.Clear()

            $itemsData = @()
            $totalSize = 0
            $folderCount = 0
            $fileCount = 0

            foreach ($item in $childItems) {
                $itemPath = $item.FullName
                $itemName = $item.Name
                [long]$itemSize = -1
                $errorMessage = ""
                $isFolder = $item.PSIsContainer

                try {
                    if ($isFolder) {
                        $folderCount++
                        $subItems = Get-ChildItem -Path $itemPath -Recurse -Force -ErrorAction SilentlyContinue
                        if ($null -eq $subItems -and $Error.Count -gt 0 -and $Error[0].Exception -is [System.UnauthorizedAccessException] -and $Error[0].TargetObject -eq $itemPath) {
                            throw $Error[0].Exception
                        }
                        $Error.Clear()

                        $itemSize = ($subItems | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                        if ($null -eq $itemSize) { $itemSize = 0 }
                    }
                    else {
                        $fileCount++
                        $itemSize = $item.Length
                    }

                    if ($itemSize -ge 0) {
                        $totalSize += $itemSize
                    }
                }
                catch [System.UnauthorizedAccessException] {
                    $errorMessage = "(Permission Denied)"
                    $itemSize = -1
                }
                catch {
                    $errorMessage = "(Error: $($_.Exception.Message.Split([Environment]::NewLine)[0]))"
                    $itemSize = -1
                }
                finally {
                    $Error.Clear()
                }

                $hrSizeStr = if ($HumanReadable -and $itemSize -ge 0) {
                    Format-ConvertSize -Value $itemSize -DecimalPlaces 2
                }
                else {
                    "N/A"
                }

                $itemsData += [PSCustomObject]@{
                    Name         = $itemName
                    Size         = $hrSizeStr
                    RawSize      = $itemSize
                    IsFolder     = $isFolder
                    ErrorMessage = $errorMessage
                }
            }

            $totalHumanSize = if ($HumanReadable) {
                Format-ConvertSize -Value $totalSize -DecimalPlaces 2
            }
            else {
                "N/A"
            }

            $sortedItems = if ($Sort) {
                if ($SortBy -eq 'Size') {
                    $itemsData | Sort-Object -Property @{Expression = "IsFolder"; Descending = $true }, @{Expression = { $_.RawSize }; Descending = $true }
                }
                else {
                    $itemsData | Sort-Object -Property @{Expression = "IsFolder"; Descending = $true }, @{Expression = "Name"; Descending = $false }
                }
            }
            else {
                $itemsData
            }

            Write-Host "Total Size: " -NoNewline -ForegroundColor Yellow
            Write-Host "$totalHumanSize" -ForegroundColor White
            Write-Host "Items: " -NoNewline -ForegroundColor Yellow
            Write-Host "$($sortedItems.Count) ($folderCount directories, $fileCount files)" -ForegroundColor White
            Write-Host "-----------------------------------------------------" -ForegroundColor Cyan

            Write-Host ("{0,-15} {1,-15} {2,-50}" -f "Size", "Type", "Name") -ForegroundColor Yellow
            Write-Host "-----------------------------------------------------" -ForegroundColor Cyan

            foreach ($item in $sortedItems) {
                $itemTypeColor = if ($item.IsFolder) { "Blue" } else { "White" }
                $itemType = if ($item.IsFolder) { "Directory" } else { "File" }

                $sizeColor = "White"
                if ($item.RawSize -ne -1) {
                    $sizeValue = $item.RawSize
                    if ($sizeValue -gt 1GB) {
                        $sizeColor = "Red"
                    }
                    elseif ($sizeValue -gt 100MB) {
                        $sizeColor = "Yellow"
                    }
                    elseif ($sizeValue -gt 10MB) {
                        $sizeColor = "Green"
                    }
                }

                Write-Host ("{0,-15} " -f $item.Size) -NoNewline -ForegroundColor $sizeColor
                Write-Host ("{0,-15} " -f $itemType) -NoNewline -ForegroundColor $itemTypeColor
                Write-Host ("{0,-50}" -f $item.Name) -ForegroundColor $itemTypeColor

                if ($item.ErrorMessage) {
                    Write-Host "    $($item.ErrorMessage)" -ForegroundColor Red
                }
            }
            Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
        }
    }
}
