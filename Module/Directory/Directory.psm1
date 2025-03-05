<#
.SYNOPSIS
  Finds files matching a specified name pattern in the current directory and its subdirectories.

.DESCRIPTION
  This function searches for files that match the specified name pattern in the current directory and its subdirectories. It returns the full path of each file found. If no matching files are found, it does not output anything.

.PARAMETER Name
  Specifies the name pattern to search for. You can use wildcard characters such as '*' and '?' to represent multiple characters or single characters in the file name.

.OUTPUTS
  This function does not return any output directly. It writes the full paths of matching files to the pipeline.

.EXAMPLE
  Find-Files "file.txt"
  Searches for files matching the pattern "file.txt" and returns their full paths.
  Find-Files "*.ps1"
  Searches for files with the extension ".ps1" and returns their full paths.

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
  Set-FreshFile "existing_file.txt"
  Updates the timestamp of the existing file named "existing_file.txt" without modifying its content.

.NOTES
  This function can be used as an alias "touch" to quickly create a new file or update the timestamp of an existing file.
#>
function Set-FreshFile {
  [CmdletBinding()]
  [Alias("touch")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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
  Extracts a file to the current directory.

.DESCRIPTION
  This function extracts the specified file to the current directory using the Expand-Archive cmdlet.

.PARAMETER File
  Specifies the file to extract.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Expand-File "file.zip"
  Extracts the file "file.zip" to the current directory.

.NOTES
  This function is useful for quickly extracting files to the current directory.
#>
function Expand-File {
  [CmdletBinding()]
  [Alias("unzip")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

<#
.SYNOPSIS
  Compresses files into a zip archive.

.DESCRIPTION
  This function compresses the specified files into a zip archive using the Compress-Archive cmdlet.

.PARAMETER Files
  Specifies the files to compress into a zip archive.

.PARAMETER Archive
  Specifies the name of the zip archive to create.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Compress-Files -Files "file1.txt", "file2.txt" -Archive "files.zip"
  Compresses "file1.txt" and "file2.txt" into a zip archive named "files.zip".

.NOTES
  This function is useful for quickly compressing files into a zip archive.
#>
function Compress-Files {
  [CmdletBinding()]
  [Alias("zip")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]$Files,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

<#
.SYNOPSIS
  Searches for a string in a file and returns matching lines.

.DESCRIPTION
  This function searches for a specified string or regular expression pattern in a file or files within a directory. It returns the lines that contain the matching string or pattern. It is useful for finding occurrences of specific patterns in text files.

.PARAMETER Pattern
  Specifies the string or regular expression pattern to search for.

.PARAMETER Path
  Specifies the path to the file or directory to search in. If not provided, the function searches in the current directory.

.OUTPUTS
  The lines in the file(s) that match the specified string or regular expression pattern.

.EXAMPLE
  Get-ContentMatching "pattern" "file.txt"
  Searches for occurrences of the pattern "pattern" in the file "file.txt" and returns matching lines.

.NOTES
  This function is useful for quickly searching for a string or regular expression pattern in a file or files within a directory.
#>
function Get-ContentMatching {
  [CmdletBinding()]
  [Alias("grep")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Pattern,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Set-ContentMatching "file.txt" "pattern" "replacement"
  Searches for "pattern" in "file.txt" and replaces it with "replacement".

.NOTES
  This function is useful for quickly performing text replacements in files.
#>
function Set-ContentMatching {
  [CmdletBinding()]
  [Alias("sed")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$File,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Find,

    [Parameter(Mandatory = $true, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

<#
.SYNOPSIS
  Calculates the hash value of a file using the specified algorithm.

.DESCRIPTION
  This function calculates the hash value of a file using the specified algorithm. It supports various hash algorithms such as MD5, SHA1, SHA256, SHA384, SHA512, and more.

.PARAMETER File
  Specifies the path to the file for which the hash value should be calculated.

.PARAMETER Algorithm
  Specifies the hash algorithm to use for calculating the hash value.

.OUTPUTS
  The hash value of the file calculated using the specified algorithm.

.EXAMPLE
  Get-FileHash "file.txt" "SHA256"
  Calculates the SHA256 hash value of the file "file.txt".

.NOTES
  This function is useful for quickly calculating the hash value of a file using different algorithms.
#>
function Get-FileHash {
  [CmdletBinding()]
  [Alias("fh")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Algorithm
  )

  try {
    $hash = Get-FileHash -Path $Path -Algorithm $Algorithm -ErrorAction Stop
    Write-Output $hash.Hash
  }
  catch {
    Write-LogMessage -Message "Failed to calculate hash for path '$Path'." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Determines the encoding of a file.

.DESCRIPTION
  This function determines the encoding of a file by analyzing its byte order mark (BOM) or by examining the file contents. It returns the name of the encoding used in the file.

.PARAMETER Path
  Specifies the path to the file for which the encoding should be determined.

.OUTPUTS
  The name of the encoding used in the file.

.EXAMPLE
  Get-FileEncoding "file.txt"
  Determines the encoding of the file "file.txt" and returns the name of the encoding.

.NOTES
  This function is useful for quickly determining the encoding of a file.
#>
function Get-FileEncoding {
  [CmdletBinding()]
  [Alias("fe")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path
  )

  try {
    $encoding = Get-FileEncoding -Path $Path -ErrorAction Stop
    Write-Output $encoding.EncodingName
  }
  catch {
    Write-LogMessage -Message "Failed to determine encoding for file '$Path'." -Level "ERROR"
  }
}

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

.EXAMPLE
  Get-FileHead "file.txt"
  Reads the first 10 lines of the file "file.txt" and outputs them.
  Get-FileHead "file.txt" 5
  Reads the first 5 lines of the file "file.txt" and outputs them.

.NOTES
  This function is useful for quickly previewing the contents of a file.
#>
function Get-FileHead {
  [CmdletBinding()]
  [Alias("head")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [int]$Lines = 10
  )

  try {
    Get-Content -Path $Path -TotalCount $Lines -ErrorAction Stop
  }
  catch {
    Write-LogMessage -Message "Failed to read the first $Lines lines of file '$Path'." -Level "ERROR"
  }
}

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

.OUTPUTS
  The last few lines of the file.

.EXAMPLE
  Get-FileTail "file.txt"
  Reads the last 10 lines of the file "file.txt" and outputs them.
  Get-FileTail "file.txt" 5
  Reads the last 5 lines of the file "file.txt" and outputs them.
  Get-FileTail "log.txt" -Wait
  Reads the last 10 lines of the file "log.txt" and continues to output new lines as they are added to the file.

.NOTES
  This function is useful for quickly previewing the end of a file or monitoring log files.
#>
function Get-FileTail {
  [CmdletBinding()]
  [Alias("tail")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [int]$Lines = 10,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [switch]$Wait = $false
  )

  try {
    Get-Content -Path $Path -Tail $Lines -Wait:$Wait -ErrorAction Stop
  }
  catch {
    Write-LogMessage -Message "Failed to read the last $Lines lines of file '$Path'." -Level "ERROR"
  }
}

<#
.SYNOPSIS
    Moves up one directory level.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the current directory. It is useful for navigating up one level in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Invoke-UpOneDirectoryLevel
    Moves up one directory level.

.NOTES
    This function is useful for navigating up one level in the directory structure.
#>
function Invoke-UpOneDirectoryLevel {
  [CmdletBinding()]
  [Alias("cd.1")]
  [Alias("..")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path .. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up two directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the current directory. It is useful for navigating up two levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Invoke-UpTwoDirectoryLevels
  Moves up two directory levels.

.NOTES
  This function is useful for navigating up two levels in the directory structure.
#>
function Invoke-UpTwoDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.2")]
  [Alias("...")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\.. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up three directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up three levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Invoke-UpThreeDirectoryLevels
  Moves up three directory levels.

.NOTES
  This function is useful for navigating up three levels in the directory structure.
#>
function Invoke-UpThreeDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.3")]
  [Alias("....")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\.. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up four directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up four levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Invoke-UpFourDirectoryLevels
  Moves up four directory levels.

.NOTES
  This function is useful for navigating up four levels in the directory structure.
#>
function Invoke-UpFourDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.4")]
  [Alias(".....")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\.. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up five directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up five levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Invoke-UpFiveDirectoryLevels
  Moves up five directory levels.

.NOTES
  This function is useful for navigating up five levels in the directory structure.
#>
function Invoke-UpFiveDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.5")]
  [Alias("......")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\..\.. -ErrorAction SilentlyContinue
}
