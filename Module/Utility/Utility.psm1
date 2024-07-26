<#
.SYNOPSIS
    Reloads the PowerShell profile to apply changes.

.DESCRIPTION
    This function reloads the current PowerShell profile to apply any changes made to it. It is useful for immediately applying modifications to the profile without restarting the shell.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Invoke-ProfileReload
    Reloads the PowerShell profile.

.ALIASES
    reload-profile
    Use the alias `reload-profile` to quickly reload the profile.

.NOTES
    This function is useful for quickly reloading the PowerShell profile to apply changes without restarting the shell.
#>
function Invoke-ProfileReload {
    [CmdletBinding()]
    [Alias("reload-profile")]
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

<#
.SYNOPSIS
    Finds files matching a specified name pattern in the current directory and its subdirectories.

.DESCRIPTION
    This function searches for files that match the specified name pattern in the current directory and its subdirectories. It returns the full path of each file found. If no matching files are found, it does not output anything.

.PARAMETER Name
    Specifies the name pattern to search for. You can use wildcard characters such as '*' and '?' to represent multiple characters or single characters in the file name.

.OUTPUTS None
    This function does not return any output directly. It writes the full paths of matching files to the pipeline.

.EXAMPLE
    Find-Files "file.txt"
    Searches for files matching the pattern "file.txt" and returns their full paths.

.EXAMPLE
    Find-Files "*.ps1"
    Searches for files with the extension ".ps1" and returns their full paths.

.ALIASES
    ff
    Use the alias `ff` to quickly find files matching a name pattern.

.NOTES
    This function is useful for quickly finding files that match a specific name pattern in the current directory and its subdirectories.
#>
function Find-Files {
    [CmdletBinding()]
    [Alias("ff")]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name
    )

    Get-ChildItem -Recurse -Filter $Name -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output $_.FullName
    }
}

<#
.SYNOPSIS
    Creates a new empty file or updates the timestamp of an existing file with the specified name.

.DESCRIPTION
    This function serves a dual purpose: it can create a new empty file with the specified name, or if a file with the same name already exists, it updates the timestamp of that file to reflect the current time. This operation is particularly useful in scenarios where you want to ensure a file's existence or update its timestamp without modifying its content. The function utilizes the Out-File cmdlet to achieve this.

.PARAMETER File
    Specifies the name of the file to create or update. If the file already exists, its timestamp will be updated.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Set-FreshFile "file.txt"
    Creates a new empty file named "file.txt" if it doesn't exist. If "file.txt" already exists, its timestamp is updated.

.EXAMPLE
    Set-FreshFile "existing_file.txt"
    Updates the timestamp of the existing file named "existing_file.txt" without modifying its content.

.ALIASES
    touch
    Use the alias `touch` to quickly create a new file or update the timestamp of an existing file.

.NOTES
    This function can be used as an alias "touch" to quickly create a new file or update the timestamp of an existing file.
#>
function Set-FreshFile {
    [CmdletBinding()]
    [Alias("touch")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$File
    )

    if (Test-Path $File) {
        (Get-Item $File).LastWriteTime = Get-Date
    }
    else {
        "" | Out-File $File -Encoding ASCII
    }
}

<#
.SYNOPSIS
    Retrieves the system uptime in a human-readable format.

.DESCRIPTION
    This function retrieves the system uptime in a human-readable format. It provides information about how long the system has been running since the last boot.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    The system uptime in a human-readable format.

.EXAMPLE
    Get-Uptime
    Retrieves the system uptime.

.ALIASES
    uptime
    Use the alias `uptime` to quickly get the system uptime.

.NOTES
    This function is useful for checking how long the system has been running since the last boot.
#>
function Get-Uptime {
    [CmdletBinding()]
    [Alias("uptime")]
    param (
        # This function does not accept any parameters
    )

    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject Win32_OperatingSystem | ForEach-Object {
            $uptime = (Get-Date) - $_.ConvertToDateTime($_.LastBootUpTime)
            [PSCustomObject]@{
                Uptime = $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds -join ':'
            }
        }
    }
    else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

<#
.SYNOPSIS
    Extracts a file to the current directory.

.DESCRIPTION
    This function extracts the specified file to the current directory using the Expand-Archive cmdlet.

.PARAMETER File
    Specifies the file to extract.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Expand-File "file.zip"
    Extracts the file "file.zip" to the current directory.

.ALIASES
    unzip
    Use the alias `unzip` to quickly extract a file.

.NOTES
    This function is useful for quickly extracting files to the current directory.
#>
function Expand-File {
    [CmdletBinding()]
    [Alias("unzip")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$File
    )

    BEGIN {
        Write-LogMessage -Message "Starting file extraction process..." -Level "INFO"
    }

    PROCESS {
        try {
            Write-LogMessage -Message "Extracting file '$File' to '$PWD'..." -Level "INFO"
            $FullFilePath = Get-Item -Path $File -ErrorAction Stop | Select-Object -ExpandProperty FullName
            Expand-Archive -Path $FullFilePath -DestinationPath $PWD -Force -ErrorAction Stop
            Write-LogMessage -Message "File extraction completed successfully." -Level "INFO"
        }
        catch {
            Write-LogMessage -Message "Failed to extract file '$File'." -Level "ERROR"
        }
    }

    END {
        if (-not $Error) {
            Write-LogMessage -Message "File extraction process completed." -Level "INFO"
        }
    }
}

<#
.SYNOPSIS
    Compresses files into a zip archive.

.DESCRIPTION
    This function compresses the specified files into a zip archive using the Compress-Archive cmdlet.

.PARAMETER Files
    Specifies the files to compress into a zip archive.

.PARAMETER Archive
    Specifies the name of the zip archive to create.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Compress-Files -Files "file1.txt", "file2.txt" -Archive "files.zip"
    Compresses "file1.txt" and "file2.txt" into a zip archive named "files.zip".

.ALIASES
    zip
    Use the alias `zip` to quickly compress files into a zip archive.

.NOTES
    This function is useful for quickly compressing files into a zip archive.
#>
function Compress-Files {
    [CmdletBinding()]
    [Alias("zip")]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$Files,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Archive
    )

    BEGIN {
        Write-LogMessage -Message "Starting file compression process..." -Level "INFO"
    }

    PROCESS {
        try {
            Write-LogMessage -Message "Compressing files '$Files' into '$Archive'..." -Level "INFO"
            Compress-Archive -Path $Files -DestinationPath $Archive -Force -ErrorAction Stop
            Write-LogMessage -Message "File compression completed successfully." -Level "INFO"
        }
        catch {
            Write-LogMessage -Message "Failed to compress files '$Files'." -Level "ERROR"
        }
    }

    END {
        if (-not $Error) {
            Write-LogMessage -Message "File compression process completed." -Level "INFO"
        }
    }
}
