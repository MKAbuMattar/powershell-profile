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
  $true: If the user has administrator privileges.
  $false: If the user does not have administrator privileges.

.NOTES
  This function is useful for determining if the current user has administrator privileges.

.EXAMPLE
  Test-Administrator
  Checks if the current user has administrator privileges.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Test-Administrator {
  [CmdletBinding()]
  [Alias("is-admin")]
  [OutputType([bool])]
  param (
    # This function does not accept any parameters
  )

  $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

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
  [OutputType([string])]
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
  [OutputType([string])]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The location to retrieve the weather forecast for."
    )]
    [Alias("l")]
    [string]$Location = $null,

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Indicates whether to display weather glyphs in the forecast."
    )]
    [Alias("g")]
    [switch]$Glyphs = $true,

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Indicates whether to display moon phases in the forecast."
    )]
    [Alias("m")]
    [switch]$Moon = $false,

    [Parameter(
      Mandatory = $false,
      Position = 3,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "A custom format for the weather forecast."
    )]
    [Alias("f")]
    [string]$Format = $null,

    [Parameter(
      Mandatory = $false,
      Position = 4,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The language for the weather forecast."
    )]
    [ValidateSet(
      "en",
      "ar",
      "de",
      "es",
      "fr",
      "it",
      "nl",
      "pl",
      "pt",
      "ro",
      "ru",
      "tr"
    )]
    [string]$Lang = "en"
  )

  $url = "https://wttr.in/"

  try {
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
  [OutputType([hashtable])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The path to the FIGlet font file to read."
    )]
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
  [OutputType([string])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The text to convert to ASCII art."
    )]
    [Alias("t")]
    [string]$Text,

    [Parameter(
      Mandatory = $true,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The FIGlet font data extracted from a font file."
    )]
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
  [OutputType([datetime])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The time string to parse."
    )]
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
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The duration of the countdown in seconds or in the format 'HH:mm' or 'HH:mmAM/PM'."
    )]
    [Alias("d")]
    [string]$Duration,

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Indicates whether the countdown should count up instead of down."
    )]
    [Alias("u")]
    [switch]$CountUp = $false,

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The title to display above the countdown timer."
    )]
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
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The title to display above the stopwatch."
    )]
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
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The title to display above the clock."
    )]
    [Alias("t")]
    [string]$Title = "",

    [Parameter(
      Mandatory = $false,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Indicates whether to display the time in 24-hour format."
    )]
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
  Gets the current prayer times for a specified city and country.

.DESCRIPTION
  This function retrieves the current prayer times for a specified city and country using the AlAdhan API. It displays the prayer times in 12-hour or 24-hour format, along with the current prayer and the time remaining until the next prayer.

.PARAMETER City
  Specifies the city to get the prayer times for.

.PARAMETER Country
  Specifies the country to get the prayer times for.

.PARAMETER Method
  Specifies the calculation method to use for the prayer times. The default value is 1.

.PARAMETER Use24HourFormat
  Indicates whether to display the prayer times in 24-hour format. The default value is $false.

.INPUTS
  City: (Required) The city to get the prayer times for.
  Country: (Required) The country to get the prayer times for.
  Method: (Optional) The calculation method to use for the prayer times. The default value is 1.
  Use24HourFormat: (Optional) Indicates whether to display the prayer times in 24-hour format. The default value is $false.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for retrieving and displaying the current prayer times in the PowerShell console.

.EXAMPLE
  Get-PrayerTimes -City "Amman" -Country "Jordan"
  Retrieves the current prayer times for Amman, Jordan.

.EXAMPLE
  Get-PrayerTimes -City "New York" -Country "USA" -Method 2 -Use24HourFormat
  Retrieves the current prayer times for New York, USA using calculation method 2 and displays the times in 24-hour format.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-PrayerTimes {
  [CmdletBinding()]
  [Alias("prayer")]
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The city to get the prayer times for."
    )]
    [Alias("c")]
    [string]$City,

    [Parameter(
      Mandatory = $true,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The country to get the prayer times for."
    )]
    [Alias("o")]
    [string]$Country,

    [Parameter(
      Mandatory = $false,
      Position = 2,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The calculation method to use for the prayer times."
    )]
    [Alias("m")]
    [int]$Method = 1,

    [Parameter(
      Mandatory = $false,
      Position = 3,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Indicates whether to display the prayer times in 24-hour format."
    )]
    [Alias("f")]
    [switch]$Use24HourFormat = $false
  )

  $City = ($City.Substring(0, 1).ToUpper() + $City.Substring(1).ToLower())
  $Country = ($Country.Substring(0, 1).ToUpper() + $Country.Substring(1).ToLower())

  $url = "http://api.aladhan.com/v1/timingsByCity?city=$City&country=$Country&method=$Method"
  $response = Invoke-RestMethod -Uri $url -Method Get

  if ($response.code -eq 200) {
    $timings = $response.data.timings
    $date = $response.data.date.readable
    $hijriDate = $response.data.date.hijri.date

    $timeFormat = if ($Use24HourFormat) { "HH:mm" } else { "hh:mm tt" }

    $prayerTimes = @{
      "Fajr"    = [datetime]::ParseExact($timings.Fajr, "HH:mm", $null).ToString($timeFormat)
      "Dhuhr"   = [datetime]::ParseExact($timings.Dhuhr, "HH:mm", $null).ToString($timeFormat)
      "Asr"     = [datetime]::ParseExact($timings.Asr, "HH:mm", $null).ToString($timeFormat)
      "Maghrib" = [datetime]::ParseExact($timings.Maghrib, "HH:mm", $null).ToString($timeFormat)
      "Isha"    = [datetime]::ParseExact($timings.Isha, "HH:mm", $null).ToString($timeFormat)
    }

    $prayerTimes24 = @{}
    foreach ($key in $prayerTimes.Keys) {
      $prayerTimes24[$key] = (Get-Date "01/01/2000 $($prayerTimes[$key])").ToString("HH:mm")
    }

    $currentTime = (Get-Date).ToString("HH:mm")

    $currentPrayer = $null
    $nextPrayer = $null
    $nextPrayerTime = $null
    $sortedPrayers = $prayerTimes24.GetEnumerator() | Sort-Object Value

    foreach ($prayer in $sortedPrayers) {
      if ($currentTime -ge $prayer.Value) {
        $currentPrayer = $prayer.Key
      }
      elseif (-not $nextPrayer) {
        $nextPrayer = $prayer.Key
        $nextPrayerTime = $prayerTimes[$prayer.Key]
      }
    }

    if ($currentPrayer -eq "Isha") {
      $nextPrayer = "Fajr"
      $nextPrayerTime = $prayerTimes["Fajr"]
    }

    $now = Get-Date
    $nextPrayerTimeObj = Get-Date "01/01/2000 $nextPrayerTime"
    if ($nextPrayer -eq "Fajr") {
      $nextPrayerTimeObj = $nextPrayerTimeObj.AddDays(1)
    }
    $countdown = $nextPrayerTimeObj - $now

    if ($countdown.TotalSeconds -lt 0) {
      $countdown = New-TimeSpan -Hours 0 -Minutes 0
    }

    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
    Write-Host "$City, $Country" -ForegroundColor White
    Write-Host "$currentPrayer" -ForegroundColor Blue
    Write-Host "-----------------------------------------------------"
    Write-Host ("{0,-10} {1,-10} {2,-10} {3,-10} {4,-10}" -f "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha") -ForegroundColor Cyan
    Write-Host ("{0,-10} {1,-10} {2,-10} {3,-10} {4,-10}" -f $prayerTimes["Fajr"], $prayerTimes["Dhuhr"], $prayerTimes["Asr"], $prayerTimes["Maghrib"], $prayerTimes["Isha"]) -ForegroundColor White
    Write-Host "-----------------------------------------------------"
    Write-Host "Current  -> $currentPrayer" -ForegroundColor Yellow
    Write-Host "Next     -> $nextPrayer at $nextPrayerTime" -ForegroundColor Green
    Write-Host "-----------------------------------------------------"
    Write-Host "$date | $hijriDate" -ForegroundColor Magenta
    Write-Host "-----------------------------------------------------"
  }
  else {
    Write-Host "Error fetching prayer times. Please check your city and country name." -ForegroundColor Red
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
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The time in milliseconds to wait between updating the animation."
    )]
    [Alias("s")]
    [double]$SleepTime = 0.6
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

<#
.SYNOPSIS
  Displays disk usage for specified paths.
.DESCRIPTION
  This function calculates and displays the disk usage for one or more paths.
  It can show sizes in human-readable format and control the depth of subdirectories.
.PARAMETER Path
  The path(s) to the directory or file to analyze. Defaults to the current directory.
.PARAMETER Depth
  How many levels of subdirectories to display. Default is 0 (only the top level).
.PARAMETER HumanReadable
  If $true, displays sizes in a human-readable format (KB, MB, GB).
.EXAMPLE
  Get-DiskUsage -Path "C:\Windows" -Depth 1 -HumanReadable
  Displays disk usage for C:\Windows and its immediate subdirectories in human-readable format.
.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-DiskUsage {
  [CmdletBinding()]
  [Alias('du')]
  param (
    [string[]]$Path = (Get-Location),
    [int]$Depth = 0,
    [switch]$HumanReadable
  )
  Write-Output "Disk usage for $($Path -join ', ') (Not Implemented Yet)"
}
