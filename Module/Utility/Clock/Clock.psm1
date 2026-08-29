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
#       common tasks in PowerShell. Now uses Python backend for enhanced performance.
#
# Created: 2021-09-01
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

function Get-ClockPython {
    <#
    .SYNOPSIS
        Resolves the Python interpreter for this module.

    .DESCRIPTION
        Defers to the shared Get-PythonExecutable from the Loader module when the profile is
        loaded, and falls back to a local probe when this module is imported on its own, as the
        CI load test does.

        The shared version is preferred because it verifies the interpreter actually runs, which
        rejects the Microsoft Store stub that Windows installs under the name `python.exe`.

    .OUTPUTS
        [string] Interpreter path or name, or $null when none was found.

    .EXAMPLE
        $python = Get-ClockPython
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (Get-Command -Name Get-PythonExecutable -ErrorAction SilentlyContinue) {
        return Get-PythonExecutable
    }

    foreach ($candidate in 'python3', 'python') {
        if (Get-Command -Name $candidate -CommandType Application -ErrorAction SilentlyContinue) {
            return $candidate
        }
    }

    Write-Error 'Python is not installed or not in PATH. Please install Python 3.6 or later.'
    return $null
}

function Start-Countdown {
    <#
    .SYNOPSIS
        Starts a countdown timer.

    .DESCRIPTION
        This function starts a countdown timer with the specified duration. It displays the remaining time in a large ASCII art font. Press 'Q' or Ctrl+C to stop the countdown.

    .PARAMETER Duration
        Specifies the duration of the countdown. Supports formats: 30s, 5m, 1h, 02:15PM, etc.

    .PARAMETER CountUp
        Indicates whether the countdown should count up instead of down.

    .PARAMETER Title
        Specifies the title to display (will be rendered in ASCII art).

    .INPUTS
        Duration: (Required) The duration of the countdown.
        CountUp: (Optional) Count up instead of down. Default is $false.
        Title: (Optional) Title to display in ASCII art. Default is empty string.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        Uses Python backend with pyfiglet for ASCII art rendering.
        Press 'Q' to quit the countdown.

    .EXAMPLE
        Start-Countdown -Duration "25s" -Title "Break"
        Starts a 25-second countdown with the title "Break".

    .EXAMPLE
        Start-Countdown -Duration "5m" -Title "Meeting"
        Starts a 5-minute countdown with the title "Meeting".

    .EXAMPLE
        Start-Countdown -Duration "02:15PM" -Title "Lunch" -CountUp
        Starts a count-up timer until 2:15 PM with the title "Lunch".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
            HelpMessage = "The duration of the countdown (30s, 5m, 1h, 02:15PM)."
        )]
        [Alias("d")]
        [string]$Duration,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Count up instead of down."
        )]
        [Alias("u")]
        [switch]$CountUp = $false,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Title to display in ASCII art."
        )]
        [Alias("t")]
        [string]$Title = ""
    )

    process {
        $pythonCmd = Get-ClockPython
        if (-not $pythonCmd) {
            return
        }

        $scriptPath = Join-Path $PSScriptRoot "clock.py"
    
        if (-not (Test-Path $scriptPath)) {
            Write-Error "Clock utility Python script not found at: $scriptPath"
            return
        }

        $arguments = @(
            $scriptPath,
            "countdown",
            "--duration", $Duration
        )

        if ($Title) {
            $arguments += "--title"
            $arguments += $Title
        }

        if ($CountUp) {
            $arguments += "--countup"
        }

        try {
            & $pythonCmd $arguments
        }
        catch {
            Write-Error "Failed to run countdown: $_"
        }
    }
}

function Start-StopWatch {
    <#
    .SYNOPSIS
        Starts a stopwatch.

    .DESCRIPTION
        This function starts a stopwatch that displays elapsed time in ASCII art. Press 'P' to pause/resume, 'Q' or Ctrl+C to stop.

    .PARAMETER Title
        Specifies the title to display (will be rendered in ASCII art).

    .INPUTS
        Title: (Optional) Title to display in ASCII art. Default is empty string.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        Uses Python backend with pyfiglet for ASCII art rendering.
        Press 'P' to pause/resume, 'Q' to quit.

    .EXAMPLE
        Start-StopWatch
        Starts a stopwatch with no title.

    .EXAMPLE
        Start-StopWatch -Title "Workout"
        Starts a stopwatch with the title "Workout".

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
            HelpMessage = "Title to display in ASCII art."
        )]
        [Alias("t")]
        [string]$Title = ""
    )

    process {
        $pythonCmd = Get-ClockPython
        if (-not $pythonCmd) {
            return
        }

        $scriptPath = Join-Path $PSScriptRoot "clock.py"
    
        if (-not (Test-Path $scriptPath)) {
            Write-Error "Clock utility Python script not found at: $scriptPath"
            return
        }

        $arguments = @(
            $scriptPath,
            "stopwatch"
        )

        if ($Title) {
            $arguments += "--title"
            $arguments += $Title
        }

        try {
            & $pythonCmd $arguments
        }
        catch {
            Write-Error "Failed to run stopwatch: $_"
        }
    }
}

function Get-WallClock {
    <#
    .SYNOPSIS
        Displays a live wall clock.

    .DESCRIPTION
        This function displays the current time as a live wall clock in ASCII art. Press 'Q' or Ctrl+C to stop.

    .PARAMETER Title
        Specifies the title to display (will be rendered in ASCII art).

    .PARAMETER TimeZone
        Specifies the time zone to display. Default is "Local".

    .PARAMETER Use24Hour
        Switch to use 24-hour format instead of 12-hour format.

    .INPUTS
        Title: (Optional) Title to display in ASCII art. Default is empty string.
        TimeZone: (Optional) Time zone to display. Default is "Local".
        Use24Hour: (Optional) Use 24-hour format. Default is $false.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        Uses Python backend with pyfiglet for ASCII art rendering.
        Press 'Q' to quit.

    .EXAMPLE
        Get-WallClock -Title "Time"
        Displays the current local time with the title "Time".

    .EXAMPLE
        Get-WallClock -Title "UTC" -TimeZone "UTC"
        Displays the current UTC time with the title "UTC".

    .EXAMPLE
        Get-WallClock -Title "Time" -Use24Hour
        Displays the current time in 24-hour format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
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
            HelpMessage = "Title to display in ASCII art."
        )]
        [Alias("t")]
        [string]$Title = "",

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Time zone to display (e.g., UTC, Local)."
        )]
        [Alias("z")]
        [string]$TimeZone = "Local",

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Use 24-hour format."
        )]
        [switch]$Use24Hour = $false
    )

    process {
        $pythonCmd = Get-ClockPython
        if (-not $pythonCmd) {
            return
        }

        $scriptPath = Join-Path $PSScriptRoot "clock.py"
    
        if (-not (Test-Path $scriptPath)) {
            Write-Error "Clock utility Python script not found at: $scriptPath"
            return
        }

        $arguments = @(
            $scriptPath,
            "wallclock",
            "--timezone", $TimeZone
        )

        if ($Title) {
            $arguments += "--title"
            $arguments += $Title
        }

        if ($Use24Hour) {
            $arguments += "--24hour"
        }

        try {
            & $pythonCmd $arguments
        }
        catch {
            Write-Error "Failed to run wall clock: $_"
        }
    }
}
