<#
.SYNOPSIS
    Checks if a command exists in the current environment.

.DESCRIPTION
    This function checks whether a specified command exists in the current PowerShell environment. It returns a boolean value indicating whether the command is available.

.PARAMETER command
    Specifies the command to check for existence.

.OUTPUTS
    $exists: True if the command exists, false otherwise.

.EXAMPLE
    Test-CommandExists "ls"
    Checks if the "ls" command exists in the current environment.
#>
function Test-CommandExists {
  [CmdletBinding()]
  [Alias("command-exists")]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$command
  )

  $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
  return $exists
}

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

.ALIASES
    grep -> Use the alias `grep` to quickly search for a string in a file.

.NOTES
    This function is useful for quickly searching for a string or regular expression pattern in a file or files within a directory.
#>
function Get-ContentMatching {
  [CmdletBinding()]
  [Alias("grep")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [string]$Pattern,

    [Parameter(Position = 1)]
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

.PARAMETER file
    Specifies the file to search and perform replacements in.

.PARAMETER find
    Specifies the string to search for.

.PARAMETER replace
    Specifies the string to replace the found string with.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Set-ContentMatching "file.txt" "pattern" "replacement"
    Searches for "pattern" in "file.txt" and replaces it with "replacement".

.ALIASES
    sed -> Use the alias `sed` to quickly perform text replacements.

.NOTES
    This function is useful for quickly performing text replacements in files.
#>
function Set-ContentMatching {
  [CmdletBinding()]
  [Alias("sed")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$file,

    [Parameter(Mandatory = $true)]
    [string]$find,

    [Parameter(Mandatory = $true)]
    [string]$replace
  )

  try {
    $content = Get-Content $file -ErrorAction Stop
    $content -replace $find, $replace | Set-Content $file -ErrorAction Stop
  }
  catch {
    Write-LogMessage -Message "An error occurred while performing text replacement." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Gets the definition of a command.

.DESCRIPTION
  This function retrieves the definition of a specified command. It is useful for understanding the functionality and usage of PowerShell cmdlets and functions.

.PARAMETER name
  Specifies the name of the command to retrieve the definition for.

.OUTPUTS
  The definition of the specified command.

.EXAMPLE
  Get-CommandDefinition "ls"
  Retrieves the definition of the "ls" command.

.ALIASES
  def -> Use the alias `def` to quickly get the definition of a command.

.NOTES
  This function is useful for quickly retrieving the definition of a command.
#>
function Get-CommandDefinition {
  [CmdletBinding()]
  [Alias("def")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$name
  )

  try {
    $definition = Get-Command $name -ErrorAction Stop | Select-Object -ExpandProperty Definition
    if ($definition) {
      Write-Output $definition
    }
    else {
      Write-LogMessage -Message "Command '$name' not found." -Level "WARNING"
    }
  }
  catch {
    Write-LogMessage -Message "An error occurred while retrieving the definition of '$name'." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Exports an environment variable.

.DESCRIPTION
  This function exports an environment variable with the specified name and value. It sets the specified environment variable with the provided value.

.PARAMETER name
  Specifies the name of the environment variable.

.PARAMETER value
  Specifies the value of the environment variable.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Set-EnvVar "name" "value"
  Exports an environment variable named "name" with the value "value".

.ALIASES
  set-env -> Use the alias `set-env` to quickly export an environment variable.

.NOTES
  This function is useful for exporting environment variables within a PowerShell session.
#>
function Set-EnvVar {
  [CmdletBinding()]
  [Alias("set-env")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$name,

    [Parameter(Mandatory = $true)]
    [string]$value
  )

  try {
    Set-Item -Force -Path "env:$name" -Value $value -ErrorAction Stop
  }
  catch {
    Write-LogMessage -Message "Failed to export environment variable '$name'." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Retrieves the value of an environment variable.

.DESCRIPTION
  This function retrieves the value of the specified environment variable. It returns the value of the environment variable if it exists.

.PARAMETER name
  Specifies the name of the environment variable to retrieve the value for.

.OUTPUTS
  The value of the specified environment variable.

.EXAMPLE
  Get-EnvVar "name"
  Retrieves the value of the environment variable named "name".

.ALIASES
  get-env -> Use the alias `get-env` to quickly get the value of an environment variable.

.NOTES
  This function is useful for retrieving the value of environment variables within a PowerShell session.
#>
function Get-EnvVar {
  [CmdletBinding()]
  [Alias("get-env")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$name
  )

  try {
    $value = Get-Item -Path "env:$name" -ErrorAction Stop | Select-Object -ExpandProperty Value
    if ($value) {
      Write-Output $value
    }
    else {
      Write-LogMessage -Message "Environment variable '$name' not found." -Level "WARNING"
    }
  }
  catch {
    Write-LogMessage -Message "An error occurred while retrieving the value of environment variable '$name'." -Level "ERROR"
  }
}

<#
.SYNOPSIS
    Retrieves a list of all running processes.

.DESCRIPTION
    This function retrieves information about all running processes on the system. It provides details such as the process name, ID, CPU usage, and memory usage.

.PARAMETER Name
    Specifies the name of a specific process to retrieve information for. If not provided, information for all processes is retrieved.

.OUTPUTS
    The process information for all running processes.

.EXAMPLE
    Get-AllProcesses
    Retrieves information about all running processes.

.ALIASES
    pall -> Use the alias `pall` to quickly get information about all running processes.

.NOTES
    This function is useful for retrieving information about running processes on the system.
#>
function Get-AllProcesses {
  [CmdletBinding()]
  [Alias("pall")]
  param (
    [Parameter(Mandatory = $false)]
    [string]$name
  )

  try {
    if ($name) {
      Get-Process $name -ErrorAction Stop
    }
    else {
      Get-Process
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve process information." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Finds a process by name.

.DESCRIPTION
  This function searches for a process by its name. It retrieves information about the specified process, if found.

.PARAMETER name
  Specifies the name of the process to find.

.OUTPUTS
  The process information if found.

.EXAMPLE
  Get-ProcessByName "process"
  Retrieves information about the process named "process".

.ALIASES
  pgrep -> Use the alias `pgrep` to quickly find a process by name.

.NOTES
  This function is useful for quickly finding information about a process by its name.
#>
function Get-ProcessByName {
  [CmdletBinding()]
  [Alias("pgrep")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$name
  )

  try {
    Get-Process $name -ErrorAction Stop
  }
  catch {
    Write-Warning "No process with the name '$name' found."
  }
}

<#
.SYNOPSIS
  Finds a process by port.

.DESCRIPTION
  This function searches for a process using a specific port. It retrieves information about the process using the specified port, if found.

.PARAMETER port
  Specifies the port number to search for.

.OUTPUTS
  The process information if found.

.EXAMPLE
  Get-ProcessByPort 80
  Retrieves information about the process using port 80.

.ALIASES
  portgrep -> Use the alias `portgrep` to quickly find a process by port.

.NOTES
  This function is useful for quickly finding information about a process using a specific port.
#>
function Get-ProcessByPort {
  [CmdletBinding()]
  [Alias("portgrep")]
  param (
    [Parameter(Mandatory = $true)]
    [int]$port
  )

  try {
    Get-NetTCPConnection -LocalPort $port -ErrorAction Stop
  }
  catch {
    Write-Warning "No process using port '$port' found."
  }
}

<#
.SYNOPSIS
  Terminates a process by name.

.DESCRIPTION
  This function terminates a process by its name. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER name
  Specifies the name of the process to terminate.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Stop-ProcessByName "process"
  Terminates the process named "process".

.ALIASES
  pkill -> Use the alias `pkill` to quickly stop a process by name.

.NOTES
  This function is useful for quickly terminating a process by its name.
#>
function Stop-ProcessByName {
  [CmdletBinding()]
  [Alias("pkill")]
  param (
    [Parameter(Mandatory = $true)]
    [string]$name
  )

  $process = Get-Process $name -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-LogMessage -Message "No process with the name '$name' found." -Level "WARNING"
  }
}

<#
.SYNOPSIS
  Terminates a process by port.

.DESCRIPTION
  This function terminates a process using a specific port. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER port
  Specifies the port number of the process to terminate.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Stop-ProcessByPort 80
  Terminates the process using port 80.

.ALIASES
  portkill -> Use the alias `portkill` to quickly stop a process by port.

.NOTES
  This function is useful for quickly terminating a process using a specific port.
#>
function Stop-ProcessByPort {
  [CmdletBinding()]
  [Alias("portkill")]
  param (
    [Parameter(Mandatory = $true)]
    [int]$port
  )

  $process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-LogMessage -Message "No process using port '$port' found." -Level "WARNING"
  }
}

<#
.SYNOPSIS
    Retrieves a random quote from an online API.

.DESCRIPTION
    This function retrieves a random quote from the specified API URL. It returns the quote content and author. If the API request fails, it logs an error message.

.PARAMETER ApiUrl
    Specifies the URL of the API to retrieve the random quote from. The default value is "http://api.quotable.io/random".

.OUTPUTS
    The random quote content and author.

.EXAMPLE
    Get-RandomQuote
    Retrieves a random quote from the default API URL.

.EXAMPLE
    Get-RandomQuote -ApiUrl "http://example.com/api/random"
    Retrieves a random quote from the specified API URL.

.ALIASES
    quote
    Use the alias `quote` to quickly retrieve a random quote.

.NOTES
    This function is useful for retrieving random quotes from an online API.
#>
function Get-RandomQuote {
  [CmdletBinding()]
  [Alias("quote")]
  param (
    [Parameter(Position = 0)]
    [string]$ApiUrl = "http://api.quotable.io/random"
  )

  try {
    $response = Invoke-RestMethod -Uri $ApiUrl -Method Get -SkipCertificateCheck
    if ($response) {
      Write-Output "`"$($response.content)`""
      Write-Output " - $($response.author)"
    }
    else {
      Write-LogMessage -Message "Failed to retrieve a random quote." -Level "ERROR"
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve a random quote." -Level "ERROR"
  }
}
