#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile
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
#       This Module contains various directory and file management
#       functions to enhance productivity in PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Find-Files {
    <#
    .SYNOPSIS
        Finds files matching a specified name pattern in the current directory and its subdirectories.

    .DESCRIPTION
        This function searches for files that match the specified name pattern in the current directory and its subdirectories. It returns the full path of each file found. If no matching files are found, it does not output anything.

    .PARAMETER Name
        Specifies the name pattern to search for. You can use wildcard characters such as '*' and '?' to represent multiple characters or single characters in the file name.

    .OUTPUTS
        This function does not return any output directly. It writes the full paths of matching files to the pipeline.

    .INPUTS
        Name: (Required) The name pattern to search for.

    .NOTES
        This function is useful for quickly finding files that match a specific name pattern in the current directory and its subdirectories.

    .EXAMPLE
        Find-Files "file.txt"
        Searches for files matching the pattern "file.txt" and returns their full paths.

    .EXAMPLE
        Find-Files "*.ps1"
        Searches for files with the extension ".ps1" and returns their full paths.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("ff")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name pattern to search for."
        )]
        [Alias("n")]
        [string]$Name
    )

    Get-ChildItem -Recurse -Filter $Name -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output $_.FullName
    }
}

Remove-Alias touch -ErrorAction SilentlyContinue
function Set-FreshFile {
    <#
    .SYNOPSIS
        Creates a new empty file or updates the timestamp of an existing file with the specified name.

    .DESCRIPTION
        This function serves a dual purpose: it can create a new empty file with the specified name, or if a file with the same name already exists, it updates the timestamp of that file to reflect the current time. This operation is particularly useful in scenarios where you want to ensure a file's existence or update its timestamp without modifying its content. The function utilizes the Out-File cmdlet to achieve this.

    .PARAMETER File
        Specifies the name of the file to create or update. If the file already exists, its timestamp will be updated.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function can be used as an alias "touch" to quickly create a new file or update the timestamp of an existing file.

    .EXAMPLE
        Set-FreshFile "file.txt"
        Creates a new empty file named "file.txt" if it doesn't exist. If "file.txt" already exists, its timestamp is updated.

    .EXAMPLE
        Set-FreshFile "existing_file.txt"
        Updates the timestamp of the existing file named "existing_file.txt" without modifying its content.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("touch")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name of the file to create or update."
        )]
        [Alias("f")]
        [string]$File
    )

    if (Test-Path $File) {
        (Get-Item $File).LastWriteTime = Get-Date
    }
    else {
        "" | Out-File $File -Encoding ASCII
    }
}

function Expand-File {
    <#
    .SYNOPSIS
        Extracts a file to the current directory.

    .DESCRIPTION
        This function extracts the specified file to the current directory using the Expand-Archive cmdlet.

    .PARAMETER File
        Specifies the file to extract.

    .INPUTS
        File: (Required) The file to extract.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for quickly extracting files to the current directory.

    .EXAMPLE
        Expand-File "file.zip"
        Extracts the file "file.zip" to the current directory.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("unzip")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The file to extract."
        )]
        [string]$File
    )

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

function Compress-Files {
    <#
    .SYNOPSIS
        Compresses files into a zip archive.

    .DESCRIPTION
        This function compresses the specified files into a zip archive using the Compress-Archive cmdlet.

    .PARAMETER Files
        Specifies the files to compress into a zip archive.

    .PARAMETER Archive
        Specifies the name of the zip archive to create.

    .INPUTS
        Files: (Required) The files to compress into the zip archive.
        Archive: (Required) The name of the zip archive to create.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for quickly compressing files into a zip archive.

    .EXAMPLE
        Compress-Files -Files "file1.txt", "file2.txt" -Archive "files.zip"
        Compresses "file1.txt" and "file2.txt" into a zip archive named "files.zip".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("zip")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The files to compress into the zip archive."
        )]
        [Alias("f")]
        [string[]]$Files,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The name of the zip archive to create."
        )]
        [Alias("a")]
        [string]$Archive
    )

    try {
        Write-LogMessage -Message "Compressing files '$Files' into '$Archive'..." -Level "INFO"
        Compress-Archive -Path $Files -DestinationPath $Archive -Force -ErrorAction Stop
        Write-LogMessage -Message "File compression completed successfully." -Level "INFO"
    }
    catch {
        Write-LogMessage -Message "Failed to compress files '$Files'." -Level "ERROR"
    }
}

function Get-ContentMatching {
    <#
    .SYNOPSIS
        Searches for a string in a file and returns matching lines.

    .DESCRIPTION
        This function searches for a specified string or regular expression pattern in a file or files within a directory. It returns the lines that contain the matching string or pattern. It is useful for finding occurrences of specific patterns in text files.

    .PARAMETER Pattern
        Specifies the string or regular expression pattern to search for.

    .PARAMETER Path
        Specifies the path to the file or directory to search in. If not provided, the function searches in the current directory.

    .INPUTS
        Pattern: (Required) The string or regular expression pattern to search for.
        Path: (Optional) The path to the file or directory to search in.

    .OUTPUTS
        The lines in the file(s) that match the specified string or regular expression pattern.

    .NOTES
        This function is useful for quickly searching for a string or regular expression pattern in a file or files within a directory.

    .EXAMPLE
        Get-ContentMatching "pattern" "file.txt"
        Searches for occurrences of the pattern "pattern" in the file "file.txt" and returns matching lines.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("grep")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The string or regular expression pattern to search for."
        )]
        [Alias("p")]
        [string]$Pattern,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The path to the file or directory to search in."
        )]
        [Alias("f")]
        [string]$Path = $PWD
    )

    try {
        if (-not (Test-Path $Path)) {
            Write-LogMessage -Message "The specified path '$Path' does not exist." -Level "ERROR"
            return
        }

        if (Test-Path $Path -PathType Leaf) {
            Get-Content -Path $Path | Select-String -Pattern $Pattern
        }
        elseif (Test-Path $Path -PathType Container) {
            Get-ChildItem -Path $Path -Recurse -File | ForEach-Object {
                Get-Content -Path $_.FullName | Select-String -Pattern $Pattern
            }
        }
        else {
            Write-LogMessage -Message "The specified path '$Path' is neither a file nor a directory." -Level "WARNING"
        }
    }
    catch {
        Write-LogMessage -Message "Failed to access path '$Path'." -Level "ERROR"
        return
    }
}

function Set-ContentMatching {
    <#
    .SYNOPSIS
        Searches for a string in a file and replaces it with another string.

    .DESCRIPTION
        This function searches for a specified string in a file and replaces it with another string. It is useful for performing text replacements in files.

    .PARAMETER File
        Specifies the file to search and perform replacements in.

    .PARAMETER Find
        Specifies the string to search for.

    .PARAMETER Replace
        Specifies the string to replace the found string with.

    .INPUTS
        File: (Required) The file to search and perform replacements in.
        Find: (Required) The string to search for.
        Replace: (Required) The string to replace the found string with.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for quickly performing text replacements in files.

    .EXAMPLE
        Set-ContentMatching "file.txt" "pattern" "replacement"
        Searches for "pattern" in "file.txt" and replaces it with "replacement".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("sed")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The file to search and perform replacements in."
        )]
        [Alias("f")]
        [string]$File,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The string to search for."
        )]
        [Alias("s")]
        [string]$Find,

        [Parameter(
            Mandatory = $true,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The string to replace the found string with."
        )]
        [Alias("r")]
        [string]$Replace
    )

    try {
        $content = Get-Content $File -ErrorAction Stop
        $content -replace $Find, $Replace | Set-Content $File -ErrorAction Stop
    }
    catch {
        Write-LogMessage -Message "An error occurred while performing text replacement." -Level "ERROR"
    }
}

<#
.SYNOPSIS
    Initializes and configures the zoxide tool for PowerShell.

.DESCRIPTION
    This function checks if the zoxide tool is installed and initializes it for use in PowerShell. If the tool is not installed, it attempts to install it using the winget package manager.

.NOTES
    This function is useful for setting up the zoxide tool for directory navigation in PowerShell.
#>
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
}
else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install -e --id ajeetdsouza.zoxide
        Write-Host "zoxide installed successfully. Initializing..."
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    }
    catch {
        Write-Error "Failed to install zoxide. Error: $_"
    }
}

Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force

function Get-FileHead {
    <#
    .SYNOPSIS
        Reads the first few lines of a file.

    .DESCRIPTION
        This function reads the first few lines of a file and outputs them to the pipeline. It is useful for quickly previewing the contents of a file.

    .PARAMETER Path
        Specifies the path to the file to read.

    .PARAMETER Lines
        Specifies the number of lines to read from the beginning of the file. The default value is 10.

    .OUTPUTS
        The first few lines of the file.

    .NOTES
        This function is useful for quickly previewing the contents of a file.

    .EXAMPLE
        Get-FileHead "file.txt"
        Reads the first 10 lines of the file "file.txt" and outputs them.

    .EXAMPLE
        Get-FileHead "file.txt" 5
        Reads the first 5 lines of the file "file.txt" and outputs them.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("head")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The path to the file to read."
        )]
        [Alias("f")]
        [string]$Path,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The number of lines to read from the beginning of the file."
        )]
        [Alias("n")]
        [int]$Lines = 10
    )

    try {
        Get-Content -Path $Path -TotalCount $Lines -ErrorAction Stop
    }
    catch {
        Write-LogMessage -Message "Failed to read the first $Lines lines of file '$Path'." -Level "ERROR"
    }
}

function Get-FileTail {
    <#
    .SYNOPSIS
        Reads the last few lines of a file.

    .DESCRIPTION
        This function reads the last few lines of a file and outputs them to the pipeline. It is useful for quickly previewing the end of a file or monitoring log files.

    .PARAMETER Path
        Specifies the path to the file to read.

    .PARAMETER Lines
        Specifies the number of lines to read from the end of the file. The default value is 10.

    .PARAMETER Wait
        Indicates whether the function should wait for new lines to be added to the file. If specified, the function will continue to output new lines as they are added to the file.

    .INPUTS
        Path: (Required) The path to the file to read.
        Lines: (Optional) The number of lines to read from the end of the file. The default value is 10.
        Wait: (Optional) Indicates whether to wait for new lines to be added to the file. The default value is $false.s

    .OUTPUTS
        The last few lines of the file.

    .NOTES
        This function is useful for quickly previewing the end of a file or monitoring log files.

    .EXAMPLE
        Get-FileTail "file.txt"
        Reads the last 10 lines of the file "file.txt" and outputs them.

    .EXAMPLE
        Get-FileTail "file.txt" 5
        Reads the last 5 lines of the file "file.txt" and outputs them.

    .EXAMPLE
        Get-FileTail "log.txt" -Wait
        Reads the last 10 lines of the file "log.txt" and continues to output new lines as they are added to the file.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("tail")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The path to the file to read."
        )]
        [Alias("f")]
        [string]$Path,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The number of lines to read from the end of the file."
        )]
        [Alias("n")]
        [int]$Lines = 10,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to wait for new lines to be added to the file."
        )]
        [Alias("w")]
        [switch]$Wait = $false
    )

    try {
        Get-Content -Path $Path -Tail $Lines -Wait:$Wait -ErrorAction Stop
    }
    catch {
        Write-LogMessage -Message "Failed to read the last $Lines lines of file '$Path'." -Level "ERROR"
    }
}

function Get-ShortPath {
    <#
    .SYNOPSIS
        Gets the short path of a file or directory.

    .DESCRIPTION
        This function retrieves the short path of a file or directory. The short path is the 8.3 format path that conforms to the MS-DOS naming convention. It is useful for working with legacy applications that require short paths.

    .PARAMETER Path
        Specifies the path of the file or directory to retrieve the short path for. If not provided, the function uses the current location.

    .INPUTS
        Path: (Optional) The path of the file or directory to retrieve the short path for.

    .OUTPUTS
        The short path of the file or directory.

    .NOTES
        This function is useful for retrieving the short path of a file or directory.

    .EXAMPLE
        Get-ShortPath "C:\Program Files\Example"
        Retrieves the short path of the directory "C:\Program Files\Example".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("shortpath")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The path of the file or directory to retrieve the short path for."
        )]
        [string]$Path = (Get-Location)
    )

    Write-Verbose "Make short path from: $Path"
    if ($Path -and (Test-Path $Path)) {
        $fso = New-Object -ComObject Scripting.FileSystemObject
        $short = if ((Get-Item $Path).PSIsContainer) {
            $fso.GetFolder($Path).ShortPath
        }
        else {
            $fso.GetFile($Path).ShortPath
        }
        Write-Output $short
    }
    else {
        Write-Verbose "Ignoring $Path"
        Write-Output $null
    }
}

function Invoke-UpOneDirectoryLevel {
    <#
    .SYNOPSIS
        Moves up one directory level.

    .DESCRIPTION
        This function changes the current working directory to the parent directory of the current directory. It is useful for navigating up one level in the directory structure.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for navigating up one level in the directory structure.

    .EXAMPLE
        Invoke-UpOneDirectoryLevel
        Moves up one directory level.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cd.1", "..")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    Set-Location -Path .. -ErrorAction SilentlyContinue
}

function Invoke-UpTwoDirectoryLevels {
    <#
    .SYNOPSIS
        Moves up two directory levels.

    .DESCRIPTION
        This function changes the current working directory to the parent directory of the parent directory of the current directory. It is useful for navigating up two levels in the directory structure.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for navigating up two levels in the directory structure.

    .EXAMPLE
        Invoke-UpTwoDirectoryLevels
        Moves up two directory levels.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cd.2", "...")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    Set-Location -Path ..\.. -ErrorAction SilentlyContinue
}

function Invoke-UpThreeDirectoryLevels {
    <#
    .SYNOPSIS
        Moves up three directory levels.

    .DESCRIPTION
        This function changes the current working directory to the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up three levels in the directory structure.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for navigating up three levels in the directory structure.

    .EXAMPLE
        Invoke-UpThreeDirectoryLevels
        Moves up three directory levels.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cd.3", "....")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    Set-Location -Path ..\..\.. -ErrorAction SilentlyContinue
}

function Invoke-UpFourDirectoryLevels {
    <#
    .SYNOPSIS
        Moves up four directory levels.

    .DESCRIPTION
        This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up four levels in the directory structure.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for navigating up four levels in the directory structure.

    .EXAMPLE
        Invoke-UpFourDirectoryLevels
        Moves up four directory levels.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cd.4", ".....")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    Set-Location -Path ..\..\..\.. -ErrorAction SilentlyContinue
}

function Invoke-UpFiveDirectoryLevels {
    <#
    .SYNOPSIS
        Moves up five directory levels.

    .DESCRIPTION
        This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up five levels in the directory structure.

    .PARAMETER None
        This function does not accept any parameters.

    .INPUTS
        This function does not accept any input.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for navigating up five levels in the directory structure.

    .EXAMPLE
        Invoke-UpFiveDirectoryLevels
        Moves up five directory levels.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cd.5", "......")]
    [OutputType([void])]
    param (
        # This function does not accept any parameters
    )

    Set-Location -Path ..\..\..\..\.. -ErrorAction SilentlyContinue
}
