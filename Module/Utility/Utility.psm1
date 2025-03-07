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
  $exists: True if the command exists, false otherwise.

.NOTES
  This function is useful for verifying the availability of commands in the current environment.

.EXAMPLE
  Test-CommandExists "ls"
  Checks if the "ls" command exists in the current environment.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Test-CommandExists {
  [CmdletBinding()]
  [Alias("command-exists")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("c")]
    [string]$Command
  )

  $exists = $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
  return $exists
}

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
function Invoke-ReloadProfile {
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
function Get-Uptime {
  [CmdletBinding()]
  [Alias("uptime")]
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
      # check date format
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
function Get-CommandDefinition {
  [CmdletBinding()]
  [Alias("def")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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
function Set-EnvVar {
  [CmdletBinding()]
  [Alias("set-env")]
  [Alias("export")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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
function Get-EnvVar {
  [CmdletBinding()]
  [Alias("get-env")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

<#
.SYNOPSIS
  Retrieves a list of all running processes.

.DESCRIPTION
  This function retrieves information about all running processes on the system. It provides details such as the process name, ID, CPU usage, and memory usage.

.PARAMETER Name
  Specifies the name of a specific process to retrieve information for. If not provided, information for all processes is retrieved.

.INPUTS
  Name: (Optional) The name of a specific process to retrieve information for.

.OUTPUTS
  The process information for all running processes.

.NOTES
  This function is useful for retrieving information about running processes on the system.

.EXAMPLE
  Get-AllProcesses
  Retrieves information about all running processes.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-AllProcesses {
  [CmdletBinding()]
  [Alias("pall")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name
  )

  try {
    if ($Name) {
      Get-Process $Name -ErrorAction Stop
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

.PARAMETER Name
  Specifies the name of the process to find.

.INPUTS
  Name: (Required) The name of the process to find.

.OUTPUTS
  The process information if found.

.NOTES
  This function is useful for quickly finding information about a process by its name.

.EXAMPLE
  Get-ProcessByName "process"
  Retrieves information about the process named "process".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-ProcessByName {
  [CmdletBinding()]
  [Alias("pgrep")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name
  )

  try {
    Get-Process $name -ErrorAction Stop
  }
  catch {
    Write-Warning "No process with the name '$Name' found."
  }
}

<#
.SYNOPSIS
  Finds a process by port.

.DESCRIPTION
  This function searches for a process using a specific port. It retrieves information about the process using the specified port, if found.

.PARAMETER Port
  Specifies the port number to search for.

.INPUTS
  Port: (Required) The port number to search for.

.OUTPUTS
  The process information if found.

.NOTES
  This function is useful for quickly finding information about a process using a specific port.

.EXAMPLE
  Get-ProcessByPort 80
  Retrieves information about the process using port 80.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-ProcessByPort {
  [CmdletBinding()]
  [Alias("portgrep")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("p")]
    [int]$Port
  )

  try {
    Get-NetTCPConnection -LocalPort $Port -ErrorAction Stop
  }
  catch {
    Write-Warning "No process using port '$Port' found."
  }
}

<#
.SYNOPSIS
  Terminates a process by name.

.DESCRIPTION
  This function terminates a process by its name. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER Name
  Specifies the name of the process to terminate.

.INPUTS
  Name: (Required) The name of the process to terminate.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for quickly terminating a process by its name.

.EXAMPLE
  Stop-ProcessByName "process"
  Terminates the process named "process".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Stop-ProcessByName {
  [CmdletBinding()]
  [Alias("pkill")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name
  )

  $process = Get-Process $Name -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-LogMessage -Message "No process with the name '$Name' found." -Level "WARNING"
  }
}

<#
.SYNOPSIS
  Terminates a process by port.

.DESCRIPTION
  This function terminates a process using a specific port. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER Port
  Specifies the port number of the process to terminate.

.INPUTS
  Port: (Required) The port number of the process to terminate.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for quickly terminating a process using a specific port.

.EXAMPLE
  Stop-ProcessByPort 80
  Terminates the process using port 80.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Stop-ProcessByPort {
  [CmdletBinding()]
  [Alias("portkill")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("p")]
    [int]$Port
  )

  $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-LogMessage -Message "No process using port '$Port' found." -Level "WARNING"
  }
}

<#
.SYNOPSIS
  Retrieves the system information.

.DESCRIPTION
  This function retrieves information about the system, including the operating system, architecture, and processor details.

.PARAMETER None
  This function does not accept any parameters.

.INPUTS
  This function does not accept any input.

.OUTPUTS
  The system information.

.NOTES
  This function is useful for quickly retrieving information about the system.

.EXAMPLE
  Get-SystemInfo
  Retrieves information about the system.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-SystemInfo {
  [CmdletBinding()]
  [Alias("sysinfo")]
  param (
    # This function does not accept any parameters
  )

  try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $processor = Get-CimInstance -ClassName Win32_Processor
    $architecture = Get-CimInstance -ClassName Win32_ComputerSystem

    [PSCustomObject]@{
      "Operating System" = $os.Caption
      "Version"          = $os.Version
      "Architecture"     = $architecture.SystemType
      "Processor"        = $processor.Name
      "Cores"            = $processor.NumberOfCores
      "Threads"          = $processor.NumberOfLogicalProcessors
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve system information." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Clears windows cache, temp files, and internet explorer cache.

.DESCRIPTION
  This function clears the Windows cache, temporary files, and Internet Explorer cache. It is useful for freeing up disk space and improving system performance.

.PARAMETER Type
  Specifies the type of cache to clear. The available options are "All", "Prefetch", "WindowsTemp", "UserTemp", and "IECache". The default value is "All".

.INPUTS
  Type: (Optional) The type of cache to clear. The default value is "All".

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for clearing various caches on the system to free up disk space and improve performance.

.EXAMPLE
  Clear-Cache
  Clears all caches (Windows Prefetch, Windows Temp, User Temp, and Internet Explorer Cache).

.EXAMPLE
  Clear-Cache -Type "Prefetch"
  Clears the Windows Prefetch cache.

.EXAMPLE
  Clear-Cache -Type "WindowsTemp"
  Clears the Windows Temp cache.

.EXAMPLE
  Clear-Cache -Type "UserTemp"
  Clears the User Temp cache.

.EXAMPLE
  Clear-Cache -Type "IECache"
  Clears the Internet Explorer Cache.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Invoke-ClearCache {
  [CmdletBinding()]
  [Alias("clear-cache")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateSet("All", "Prefetch", "WindowsTemp", "UserTemp", "IECache")]
    [Alias("c")]
    [string]$Type = "All"
  )

  switch ($Type) {
    "All" {
      Write-LogMessage "Clearing Windows Prefetch..."
      Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

      Write-LogMessage "Clearing Windows Temp..."
      Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

      Write-LogMessage "Clearing User Temp..."
      Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

      Write-LogMessage "Clearing Internet Explorer Cache..."
      Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    "Prefetch" {
      Write-LogMessage "Clearing Windows Prefetch..."
      Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue
    }
    "WindowsTemp" {
      Write-LogMessage "Clearing Windows Temp..."
      Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    "UserTemp" {
      Write-LogMessage "Clearing User Temp..."
      Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    "IECache" {
      Write-LogMessage "Clearing Internet Explorer Cache..."
      Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    default {
      Write-LogMessage "Invalid cache type: $Type" -Level "ERROR"
    }
  }
}

<#
.SYNOPSIS
  Retrieves a random quote from an online API.

.DESCRIPTION
  This function retrieves a random quote from an online API. It returns the quote content and author.

.PARAMETER None
  This function does not accept any parameters.

.INPUTS
  This function does not accept any input.

.OUTPUTS
  The random quote content and author.

.NOTES
  This function is useful for displaying random quotes in the PowerShell console.

.EXAMPLE
  Get-RandomQuote
  Retrieves a random quote from the default API URL.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-RandomQuote {
  [CmdletBinding()]
  [Alias("quote")]
  param (
    # This function does not accept any parameters
  )
  $url = "http://api.quotable.io/random"

  try {
    $response = Invoke-RestMethod -Uri $url -Method Get -SkipCertificateCheck

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

<#
.SYNOPSIS
  Gets the weather forecast for a specified location.

.DESCRIPTION
  This function retrieves the weather forecast for a specified location using the wttr.in service. It returns the weather forecast in ASCII art format. The forecast can include weather glyphs, moon phases, and be customized with additional options.

.PARAMETER Location
  Specifies the location to retrieve the weather forecast for. If not provided, the default location is used.

.PARAMETER Glyphs
  Indicates whether to display weather glyphs in the forecast. The default value is $true.

.PARAMETER Moon
  Indicates whether to display moon phases in the forecast. The default value is $false.

.PARAMETER Format
  Specifies a custom format for the weather forecast. The default format is used if not provided.

.PARAMETER Lang
  Specifies the language for the weather forecast. The default language is "en".

.INPUTS
  Location: (Optional) The location to retrieve the weather forecast for. If not provided, the default location is used.
  Glyphs: (Optional) Indicates whether to display weather glyphs in the forecast. The default value is $true.
  Moon: (Optional) Indicates whether to display moon phases in the forecast. The default value is $false.
  Format: (Optional) A custom format for the weather forecast. The default format is used if not provided.
  Lang: (Optional) The language for the weather forecast. The default language is "en".

.OUTPUTS
  The weather forecast in ASCII art format.

.NOTES
  This function is useful for retrieving the weather forecast in ASCII art format for a specified location.

.EXAMPLE
  Get-WeatherForecast -Location "Amman"
  Retrieves the weather forecast for Amman.

.EXAMPLE
  Get-WeatherForecast -Location "New York" -Glyphs $false
  Retrieves the weather forecast for New York without weather glyphs.

.EXAMPLE
  Get-WeatherForecast -Moon
  Retrieves the moon phase forecast.

.EXAMPLE
  Get-WeatherForecast -Location "Paris" -Format "3"
  Retrieves the weather forecast for Paris with a custom format.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-WeatherForecast {
  [CmdletBinding()]
  [Alias("weather")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("l")]
    [string]$Location = $null,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("g")]
    [switch]$Glyphs = $true,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("m")]
    [switch]$Moon = $false,

    [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("f")]
    [string]$Format = $null,

    [Parameter(Mandatory = $false, Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateSet("en", "ar", "de", "es", "fr", "it", "nl", "pl", "pt", "ro", "ru", "tr")]
    [string]$Lang = "en"
  )

  try {
    $url = "https://wttr.in/"

    switch ($true) {
      { $Moon -eq $false && $Location } { $url += $Location }
      { $Moon -eq $true } { $url += "Moon" }
      { $Glyphs -eq $true } { $url += "?d" }
      { $Glyphs -eq $false } { $url += "?T" }
      { $Format } { $url += "&&format=$Format" }
      { $Lang } { $url += "&&lang=$Lang" }
      default { $url += "" }
    }

    $response = Invoke-RestMethod -Uri $url -Method Get -SkipCertificateCheck

    if ($response) {
      Write-Output $response
    }
    else {
      Write-LogMessage -Message "Failed to retrieve the weather forecast." -Level "ERROR"
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve the weather forecast." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Read the contents of a FIGlet font file.

.DESCRIPTION
  This function reads the contents of a FIGlet font file and extracts the font data. It returns the font data as a hashtable, which can be used to convert text to ASCII art using the specified font.

.PARAMETER FontPath
  Specifies the path to the FIGlet font file to read.

.INPUTS
  FontPath: (Required) The path to the FIGlet font file to read.

.OUTPUTS
  The font data extracted from the FIGlet font file.

.NOTES
  This function is useful for reading FIGlet font files to extract font data for ASCII art conversion.

.EXAMPLE
  Read-FigletFont -FontPath "font.flf"
  Reads the contents of the FIGlet font file "font.flf" and extracts the font data.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Read-FigletFont {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("f")]
    [string]$FontPath
  )

  if (!(Test-Path $FontPath)) {
    Write-Host ("Error: Font file not found at {0}" -f $FontPath) -ForegroundColor Red
    return $null
  }

  $lines = Get-Content -Path $FontPath -Encoding UTF8
  if ($lines.Count -eq 0) {
    Write-Host "Error: Font file is empty or unreadable." -ForegroundColor Red
    return $null
  }

  $fontData = @{}
  $header = $lines[0] -split " "
  $hardBlank = $header[0][4]
  $charHeight = [int]$header[1]
  $charStartIndex = 1

  for ($i = 32; $i -lt 127; $i++) {
    $charLines = @()
    for ($j = 0; $j -lt $charHeight; $j++) {
      $lineIndex = $charStartIndex + ($i - 32) * $charHeight + $j
      if ($lineIndex -ge $lines.Count) { continue }
      $charLine = $lines[$lineIndex] -replace "[@$hardBlank]", " "
      $charLines += $charLine -replace ".$", ""
    }
    $fontData[[char]$i] = $charLines
  }

  return @{
    "fontData"   = $fontData
    "charHeight" = $charHeight
  }
}

<#
.SYNOPSIS
  Converts text to ASCII art using a specified FIGlet font.

.DESCRIPTION
  This function converts the specified text to ASCII art using the provided FIGlet font data. It returns the ASCII art representation of the text.

.PARAMETER Text
  Specifies the text to convert to ASCII art.

.PARAMETER Font
  Specifies the FIGlet font data extracted from a font file.

.INPUTS
  Text: (Required) The text to convert to ASCII art.
  Font: (Required) The FIGlet font data extracted from a font file.

.OUTPUTS
  The ASCII art representation of the text using the specified font.

.NOTES
  This function is useful for converting text to ASCII art using FIGlet fonts.

.EXAMPLE
  Convert-TextToAscii -Text "Hello" -Font $fontData
  Converts the text "Hello" to ASCII art using the specified font data.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Convert-TextToAscii {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("t")]
    [string]$Text,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("f")]
    [hashtable]$Font
  )

  if ($null -eq $Font) {
    Write-Host "Error: Font data is empty. Check font file." -ForegroundColor Red
    return
  }

  $output = @()
  for ($i = 0; $i -lt $Font.charHeight; $i++) {
    $line = ""
    foreach ($char in $Text.ToCharArray()) {
      if ($Font.fontData.ContainsKey($char)) {
        $line += $Font.fontData[$char][$i] + "  "
      }
      else {
        $line += " " * 8
      }
    }
    $output += $line
  }

  return $output -join "`n"
}

<#
.SYNOPSIS
  Parses a time string into a DateTime object.

.DESCRIPTION
  This function parses a time string into a DateTime object. It supports parsing time strings in the format "HH:mm" or "HH:mmAM/PM".

.PARAMETER TimeString
  Specifies the time string to parse.

.INPUTS
  TimeString: (Required) The time string to parse. The time string should be in the format "HH:mm" or "HH:mmAM/PM".

.OUTPUTS
  The DateTime object representing the parsed time.

.NOTES
  This function is useful for parsing time strings into DateTime objects.

.EXAMPLE
  Get-ParseTime -TimeString "12:30PM"
  Parses the time string "12:30PM" into a DateTime object.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-ParseTime {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("t")]
    [string]$TimeString
  )
  try {
    $targetTime = [datetime]::ParseExact($TimeString, "h:mmtt", $null)
  }
  catch {
    try {
      $targetTime = [datetime]::ParseExact($TimeString, "HH:mm", $null)
    }
    catch {
      Write-LogMessage -Message "Invalid duration or time format: $TimeString" -Level "ERROR"
      exit 1
    }
  }
  return $targetTime
}

<#
.SYNOPSIS
  Starts a countdown timer.

.DESCRIPTION
  This function starts a countdown timer with the specified duration. It displays the remaining time in a large font using the FIGlet utility. The countdown can be paused and resumed by pressing the "P" key. The countdown can be stopped by pressing the "Q" key.

.PARAMETER Duration
  Specifies the duration of the countdown in seconds or in the format "HH:mm" or "HH:mmAM/PM".

.PARAMETER CountUp
  Indicates whether the countdown should count up instead of down.

.PARAMETER Title
  Specifies the title to display above the countdown timer.

.INPUTS
  Duration: (Required) The duration of the countdown in seconds or in the format "HH:mm" or "HH:mmAM/PM".
  CountUp: (Optional) Indicates whether the countdown should count up instead of down. The default value is $false.
  Title: (Optional) The title to display above the countdown timer. The default value is an empty string.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for starting countdown timers with a visual display.

.EXAMPLE
  Start-Countdown -Duration "25s" -Title "Break Time"
  Starts a 25-second countdown with the title "Break Time".

.EXAMPLE
  Start-Countdown -Duration "5m" -Title "Meeting"
  Starts a 5-minute countdown with the title "Meeting".

.EXAMPLE
  Start-Countdown -Duration "1h" -Title "Workout"
  Starts a 1-hour countdown with the title "Workout".

.EXAMPLE
  Start-Countdown -Duration "02:15PM" -Title "Lunch Time"
  Starts a countdown until 2:15 PM with the title "Lunch Time".

.EXAMPLE
  Start-Countdown -Duration "02:15PM" -Title "Lunch Time" -CountUp
  Starts a count-up timer from 00:00:00 until 2:15 PM with the title "Lunch Time".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Start-Countdown {
  [CmdletBinding()]
  [Alias("countdown")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("d")]
    [string]$Duration,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("u")]
    [switch]$CountUp = $false,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("t")]
    [string]$Title = ""
  )

  $width = $host.UI.RawUI.WindowSize.Width
  $height = $host.UI.RawUI.WindowSize.Height

  $timeLeft = if ($Duration -match "^\d{1,2}:\d{2}(AM|PM)?$") {
    $targetTime = Get-ParseTime -TimeString $Duration
    $now = Get-Date
    if ($targetTime -lt $now) { $targetTime = $targetTime.AddDays(1) }
    ($targetTime - $now).TotalSeconds
  }
  elseif ($Duration -match "^\d+m$") {
    [double]::Parse($Duration.TrimEnd('m')) * 60
  }
  elseif ($Duration -match "^\d+h$") {
    [double]::Parse($Duration.TrimEnd('h')) * 3600
  }
  else {
    [double]::Parse($Duration.TrimEnd('s'))
  }

  Write-Host ("Starting Countdown: {0}" -f $Title) -ForegroundColor Cyan

  $isPaused = $false
  $elapsed = 0
  $paddingTop = [math]::Max(0, ($height - 1) / 2)
  $fontPath = "$env:USERPROFILE\.config\.figlet\ANSI_Shadow.flf"
  $font = Read-FigletFont -FontPath $fontPath

  while ($timeLeft -gt 0) {
    if (-not $isPaused) {
      $displayTime = if ($CountUp) { $elapsed } else { $timeLeft }
      $timeStr = [TimeSpan]::FromSeconds($displayTime).ToString("hh\:mm\:ss")
      $figletTimeStr = Convert-TextToAscii -Text "$timeStr" -Font $font

      $host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(0, 0)

      Clear-Host

      for ($i = 0; $i -lt $paddingTop; $i++) {
        Write-Host ""
      }

      $figletTimeStr.Split("`n") | ForEach-Object {
        $paddingLeft = [math]::Max(0, ($width - $_.Length) / 2)
        Write-Host (" " * $paddingLeft + $_) -ForegroundColor Green
      }

      if ($Title) {
        $paddingLeft = [math]::Max(0, ($width - $Title.Length) / 2)
        Write-Host (" " * $paddingLeft + $Title) -ForegroundColor Yellow
      }

      Start-Sleep -Seconds 1
      $timeLeft--
      if ($CountUp) { $elapsed++ }
    }

    if ([System.Console]::KeyAvailable) {
      $key = [System.Console]::ReadKey($true).Key
      if ($key -eq [System.ConsoleKey]::Q) {
        Clear-Host
        Write-Host "`nCountdown Aborted!" -ForegroundColor Red
        return
      }
    }
  }

  Clear-Host
  Write-Host "`nCountdown Complete!" -ForegroundColor Magenta
}

<#
.SYNOPSIS
  Starts a stopwatch.

.DESCRIPTION
  This function starts a stopwatch that displays the elapsed time in a large font using the FIGlet utility. The stopwatch can be paused and resumed by pressing the "P" key. The stopwatch can be stopped by pressing the "Q" key.

.PARAMETER Title
  Specifies the title to display above the stopwatch.

.INPUTS
  Title: (Optional) The title to display above the stopwatch. The default value is an empty string.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for starting a stopwatch with a visual display.

.EXAMPLE
  Start-Stopwatch
  Starts a stopwatch with no title.

.EXAMPLE
  Start-Stopwatch -Title "Workout"
  Starts a stopwatch with the title "Workout".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Start-Stopwatch {
  [CmdletBinding()]
  [Alias("stopwatch")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("t")]
    [string]$Title = $null
  )

  $width = $host.UI.RawUI.WindowSize.Width
  $height = $host.UI.RawUI.WindowSize.Height
  $paddingTop = [math]::Max(0, ($height - 1) / 2)
  $fontPath = "$env:USERPROFILE\.config\.figlet\ANSI_Shadow.flf"
  $font = Read-FigletFont -FontPath $fontPath

  Write-Host ("Starting Stopwatch: {0}" -f $Title) -ForegroundColor Cyan

  $isPaused = $false
  $elapsed = 0

  while ($true) {
    if (-not $isPaused) {
      $timeStr = [TimeSpan]::FromSeconds($elapsed).ToString("hh\:mm\:ss")
      $figletTimeStr = Convert-TextToAscii -Text "$timeStr" -Font $font

      $host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(0, 0)

      Clear-Host

      for ($i = 0; $i -lt $paddingTop; $i++) {
        Write-Host ""
      }

      $figletTimeStr.Split("`n") | ForEach-Object {
        $paddingLeft = [math]::Max(0, ($width - $_.Length) / 2)
        Write-Host (" " * $paddingLeft + $_) -ForegroundColor Green
      }

      if ($Title) {
        $paddingLeft = [math]::Max(0, ($width - $Title.Length) / 2)
        Write-Host (" " * $paddingLeft + $Title) -ForegroundColor Yellow
      }

      Start-Sleep -Seconds 1
      $elapsed++
    }

    if ([System.Console]::KeyAvailable) {
      $key = [System.Console]::ReadKey($true).Key
      if ($key -eq [System.ConsoleKey]::Q) {
        Clear-Host
        Write-Host "`nStopwatch Aborted!" -ForegroundColor Red
        return
      }
      elseif ($key -eq [System.ConsoleKey]::P) {
        $isPaused = -not $isPaused
      }
    }
  }
}

<#
.SYNOPSIS
  Displays the current time in a large font using the FIGlet utility.

.DESCRIPTION
  This function displays the current time in a large font using the FIGlet utility. The time is updated every second.

.PARAMETER Title
  Specifies the title to display above the clock.

.PARAMETER Use24HourFormat
  Indicates whether to display the time in 24-hour format. If not specified, the time is displayed in 12-hour format.

.PARAMETER TimeZone
  Specifies the time zone to display the time in. If not specified, the local time zone is used.

.INPUTS
  Title: (Optional) The title to display above the clock. The default value is an empty string.
  TimeZone: (Optional) The time zone to display the time in. The default value is "Local".

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for displaying the current time in a visual format.

.EXAMPLE
  Get-WallClock -Title "Current Time"
  Displays the current time with the title "Current Time".

.EXAMPLE
  Get-WallClock -Title "Current Time" -Use24HourFormat
  Displays the current time in 24-hour format with the title "Current Time".

.EXAMPLE
  Get-WallClock -Title "Current Time" -TimeZone "UTC"
  Displays the current time in UTC with the title "Current Time".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-WallClock {
  [CmdletBinding()]
  [Alias("wallclock")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("t")]
    [string]$Title = "",

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("z")]
    [string]$TimeZone = "Local"
  )

  $width = $host.UI.RawUI.WindowSize.Width
  $height = $host.UI.RawUI.WindowSize.Height
  $paddingTop = [math]::Max(0, ($height - 1) / 2)
  $fontPath = "$env:USERPROFILE\.config\.figlet\ANSI_Shadow.flf"
  $font = Read-FigletFont -FontPath $fontPath

  while ($true) {
    $timeFormat = if ($Use24HourFormat) { "HH:mm:ss" } else { "hh:mm:ss tt" }
    $currentTime = if ($TimeZone -eq "Local") {
      Get-Date -Format $timeFormat
    }
    else {
      [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([System.DateTime]::UtcNow, $TimeZone).ToString($timeFormat)
    }
    $figletTimeStr = Convert-TextToAscii -Text "$currentTime" -Font $font

    $host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(0, 0)

    Clear-Host

    for ($i = 0; $i -lt $paddingTop; $i++) {
      Write-Host ""
    }

    $figletTimeStr.Split("`n") | ForEach-Object {
      $paddingLeft = [math]::Max(0, ($width - $_.Length) / 2)
      Write-Host (" " * $paddingLeft + $_) -ForegroundColor Green
    }

    if ($Title) {
      $paddingLeft = [math]::Max(0, ($width - $Title.Length) / 2)
      Write-Host (" " * $paddingLeft + $Title) -ForegroundColor Yellow
    }

    Start-Sleep -Seconds 1

    if ([System.Console]::KeyAvailable) {
      $key = [System.Console]::ReadKey($true).Key
      if ($key -eq [System.ConsoleKey]::Q) {
        Clear-Host
        Write-Host "`nClock Display Aborted!" -ForegroundColor Red
        return
      }
    }
  }
}

<#
.SYNOPSIS
  Displays a matrix rain animation in the console.

.DESCRIPTION
  This function displays a matrix rain animation in the console. It simulates the falling green characters from the movie "The Matrix". The animation can be stopped by pressing the "Q" key.

.PARAMETER SleepTime
  Specifies the time in milliseconds to wait between updating the animation. The default value is 1 millisecond.

.INPUTS
  SleepTime: (Optional) The time in milliseconds to wait between updating the animation. The default value is 1 millisecond.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for displaying a matrix rain animation in the console.

.EXAMPLE
  Start-Matrix
  Displays the matrix rain animation in the console.

.EXAMPLE
  Start-Matrix -SleepTime 10
  Displays the matrix rain animation with a slower update speed.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Start-Matrix {
  [CmdletBinding()]
  [Alias("matrix")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("s")]
    [double]$SleepTime = 0.5
  )

  $host.UI.RawUI.BackgroundColor = "Black"
  $host.UI.RawUI.ForegroundColor = "Green"

  $lines = [console]::WindowHeight
  $cols = [console]::WindowWidth
  $characters = "ァアィイゥウェエォオカガキギクグケゲコゴサコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
  $colsMap = @{}

  Clear-Host

  while ($true) {
    $randomCol = Get-Random -Minimum 0 -Maximum $cols
    $randomChar = $characters[(Get-Random -Minimum 0 -Maximum $characters.Length)]

    if (-not $colsMap.ContainsKey($randomCol)) {
      $colsMap[$randomCol] = 0
    }

    $line = $colsMap[$randomCol]
    $colsMap[$randomCol]++

    Write-Host "`e[$line;${randomCol}H`e[2;32m$randomChar" -NoNewline
    Write-Host "`e[$($colsMap[$randomCol]);${randomCol}H`e[1;37m$randomChar`e[0;0H" -NoNewline

    if ($colsMap[$randomCol] -ge $lines) {
      $colsMap[$randomCol] = 0
    }

    Start-Sleep -Milliseconds $SleepTime

    if ([System.Console]::KeyAvailable) {
      $key = [System.Console]::ReadKey($true).Key
      if ($key -eq [System.ConsoleKey]::Q) {
        Clear-Host
        Write-Host "`nMatrix Animation Stopped!" -ForegroundColor Red
        return
      }
    }
  }
}
