#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Clock Manifest
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
#       This Module provides a set of clock-related utility functions for various
#       common tasks in PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function Read-FigletFont {
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

function Convert-TextToAscii {
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

function Get-ParseTime {
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
