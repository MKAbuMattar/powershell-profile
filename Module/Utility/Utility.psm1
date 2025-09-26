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
#       This Module provides general utility functions for PowerShell scripts and modules.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Import the custom Git modules
#---------------------------------------------------------------------------------------------------
$MatrixModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Matrix/Matrix.psd1'
if (Test-Path $MatrixModulePath) {
  Import-Module $MatrixModulePath -Force -Global
}
else {
  Write-Warning "Matrix module not found at: $MatrixModulePath"
}

$PrayerTimesModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'PrayerTimes/PrayerTimes.psd1'
if (Test-Path $PrayerTimesModulePath) {
  Import-Module $PrayerTimesModulePath -Force -Global
}
else {
  Write-Warning "PrayerTimes module not found at: $PrayerTimesModulePath"
}

$RandomQuoteModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'RandomQuote/RandomQuote.psd1'
if (Test-Path $RandomQuoteModulePath) {
  Import-Module $RandomQuoteModulePath -Force -Global
}
else {
  Write-Warning "RandomQuote module not found at: $RandomQuoteModulePath"
}

$UtilityModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Utility/Utility.psd1'
if (Test-Path $UtilityModulePath) {
  Import-Module $UtilityModulePath -Force -Global
}
else {
  Write-Warning "Utility module not found at: $UtilityModulePath"
}

$WeatherForecastModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'WeatherForecast/WeatherForecast.psd1'
if (Test-Path $WeatherForecastModulePath) {
  Import-Module $WeatherForecastModulePath -Force -Global
}
else {
  Write-Warning "WeatherForecast module not found at: $WeatherForecastModulePath"
}

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

function Start-Countdown {
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

function Start-StopWatch {
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

function Get-WallClock {
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
      Mandatory = $true,
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
