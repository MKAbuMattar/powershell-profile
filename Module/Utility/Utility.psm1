<#
.SYNOPSIS
  Checks if a command exists in the current environment.

.DESCRIPTION
  This function checks whether a specified command exists in the current PowerShell environment. It returns a boolean value indicating whether the command is available.

.PARAMETER Command
  Specifies the command to check for existence.

.OUTPUTS
  $exists: True if the command exists, false otherwise.

.EXAMPLE
  Test-CommandExists "ls"
  Checks if the "ls" command exists in the current environment.

.NOTES
  This function is useful for verifying the availability of commands in the current environment.
#>
function Test-CommandExists {
  [CmdletBinding()]
  [Alias("command-exists")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Invoke-ProfileReload
  Reloads the PowerShell profile.

.NOTES
  This function is useful for quickly reloading the PowerShell profile to apply changes without restarting the shell.
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

.OUTPUTS
  The system uptime in a human-readable format.

.EXAMPLE
  Get-Uptime
  Retrieves the system uptime.

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
  Gets the definition of a command.

.DESCRIPTION
  This function retrieves the definition of a specified command. It is useful for understanding the functionality and usage of PowerShell cmdlets and functions.

.PARAMETER Name
  Specifies the name of the command to retrieve the definition for.

.OUTPUTS
  The definition of the specified command.

.EXAMPLE
  Get-CommandDefinition "ls"
  Retrieves the definition of the "ls" command.

.NOTES
  This function is useful for quickly retrieving the definition of a command.
#>
function Get-CommandDefinition {
  [CmdletBinding()]
  [Alias("def")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Set-EnvVar "name" "value"
  Exports an environment variable named "name" with the value "value".

.NOTES
  This function is useful for exporting environment variables within a PowerShell session.
#>
function Set-EnvVar {
  [CmdletBinding()]
  [Alias("set-env")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The value of the specified environment variable.

.EXAMPLE
  Get-EnvVar "name"
  Retrieves the value of the environment variable named "name".

.NOTES
  This function is useful for retrieving the value of environment variables within a PowerShell session.
#>
function Get-EnvVar {
  [CmdletBinding()]
  [Alias("get-env")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The process information for all running processes.

.EXAMPLE
  Get-AllProcesses
  Retrieves information about all running processes.

.NOTES
  This function is useful for retrieving information about running processes on the system.
#>
function Get-AllProcesses {
  [CmdletBinding()]
  [Alias("pall")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The process information if found.

.EXAMPLE
  Get-ProcessByName "process"
  Retrieves information about the process named "process".

.NOTES
  This function is useful for quickly finding information about a process by its name.
#>
function Get-ProcessByName {
  [CmdletBinding()]
  [Alias("pgrep")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The process information if found.

.EXAMPLE
  Get-ProcessByPort 80
  Retrieves information about the process using port 80.

.NOTES
  This function is useful for quickly finding information about a process using a specific port.
#>
function Get-ProcessByPort {
  [CmdletBinding()]
  [Alias("portgrep")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Stop-ProcessByName "process"
  Terminates the process named "process".

.NOTES
  This function is useful for quickly terminating a process by its name.
#>
function Stop-ProcessByName {
  [CmdletBinding()]
  [Alias("pkill")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Stop-ProcessByPort 80
  Terminates the process using port 80.

.NOTES
  This function is useful for quickly terminating a process using a specific port.
#>
function Stop-ProcessByPort {
  [CmdletBinding()]
  [Alias("portkill")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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
  Get-RandomQuote -ApiUrl "http://example.com/api/random"
  Retrieves a random quote from the specified API URL.

.NOTES
  This function is useful for retrieving random quotes from an online API.
#>
function Get-RandomQuote {
  [CmdletBinding()]
  [Alias("quote")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The weather forecast in ASCII art format.

.EXAMPLE
  Get-WeatherForecast -Location "Amman"
  Retrieves the weather forecast for Amman.
  Get-WeatherForecast -Location "New York" -Glyphs $false
  Retrieves the weather forecast for New York without weather glyphs.

.NOTES
  This function is useful for retrieving the weather forecast in ASCII art format for a specified location.
#>
function Get-WeatherForecast {
  [CmdletBinding()]
  [Alias("weather")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Location = $null,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [bool]$Glyphs = $true,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [bool]$Moon = $false,

    [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Format = $null,

    [Parameter(Mandatory = $false, Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The font data extracted from the FIGlet font file.

.EXAMPLE
  Read-FigletFont -FontPath "font.flf"
  Reads the contents of the FIGlet font file "font.flf" and extracts the font data.

.NOTES
  This function is useful for reading FIGlet font files to extract font data for ASCII art conversion.
#>
function Read-FigletFont {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$FontPath
  )

  if (!(Test-Path $FontPath)) {
    Write-Host "Error: Font file not found at $FontPath" -ForegroundColor Red
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

.OUTPUTS
  The ASCII art representation of the text using the specified font.

.EXAMPLE
  Convert-TextToAscii -Text "Hello" -Font $fontData
  Converts the text "Hello" to ASCII art using the specified font data.

.NOTES
  This function is useful for converting text to ASCII art using FIGlet fonts.
#>
function Convert-TextToAscii {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Text,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  The DateTime object representing the parsed time.

.EXAMPLE
  Get-ParseTime -TimeString "12:30PM"
  Parses the time string "12:30PM" into a DateTime object.

.NOTES
  This function is useful for parsing time strings into DateTime objects.
#>
function Get-ParseTime {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Start-Countdown -Duration "25s" -Title "Break Time"
  Starts a 25-second countdown with the title "Break Time".
  Start-Countdown -Duration "5m" -Title "Meeting"
  Starts a 5-minute countdown with the title "Meeting".
  Start-Countdown -Duration "1h" -Title "Workout"
  Starts a 1-hour countdown with the title "Workout".
  Start-Countdown -Duration "02:15PM" -Title "Lunch Time"
  Starts a countdown until 2:15 PM with the title "Lunch Time".
  Start-Countdown -Duration "02:15PM" -Title "Lunch Time" -CountUp
  Starts a count-up timer from 00:00:00 until 2:15 PM with the title "Lunch Time".

.NOTES
  This function is useful for starting countdown timers with a visual display.
#>
function Start-Countdown {
  [CmdletBinding()]
  [Alias("countdown")]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Duration,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [switch]$CountUp = $false,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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

  Write-Host "Starting Countdown: $Title" -ForegroundColor Cyan

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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Start-Stopwatch -Title "Workout Timer"
  Starts a stopwatch with the title "Workout Timer".

.NOTES
  This function is useful for starting a stopwatch with a visual display.
#>
function Start-Stopwatch {
  [CmdletBinding()]
  [Alias("stopwatch")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Title = $null
  )

  $width = $host.UI.RawUI.WindowSize.Width
  $height = $host.UI.RawUI.WindowSize.Height
  $paddingTop = [math]::Max(0, ($height - 1) / 2)
  $fontPath = "$env:USERPROFILE\.config\.figlet\ANSI_Shadow.flf"
  $font = Read-FigletFont -FontPath $fontPath

  Write-Host "Starting Stopwatch: $Title" -ForegroundColor Cyan

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

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Get-WallClock -Title "Current Time"
  Displays the current time with the title "Current Time".
  Get-WallClock -Title "Current Time" -Use24HourFormat
  Displays the current time in 24-hour format with the title "Current Time".
  Get-WallClock -Title "Current Time" -TimeZone "UTC"
  Displays the current time in UTC with the title "Current Time".

.NOTES
  This function is useful for displaying the current time in a visual format.
#>
function Get-WallClock {
  [CmdletBinding()]
  [Alias("wallclock")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Title = "",

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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
  This function displays a matrix rain animation in the console. It simulates the falling green characters from the movie "The Matrix". The animation can be stopped by pressing Ctrl+C.

.PARAMETER SleepTime
  Specifies the time in milliseconds to wait between updating the animation. The default value is 1 millisecond.

.OUTPUTS
  This function does not return any output.

.EXAMPLE
  Start-Matrix
  Displays the matrix rain animation in the console.
  Start-Matrix -SleepTime 10
  Displays the matrix rain animation with a slower update speed.

.NOTES
  This function is useful for displaying a matrix rain animation in the console.
#>
function Start-Matrix {
  [CmdletBinding()]
  [Alias("matrix")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
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
