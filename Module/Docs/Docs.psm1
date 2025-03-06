<#
.SYNOPSIS
    This module provides documentation for the PowerShell Profile Helper module.

.DESCRIPTION
    The PowerShell Profile Helper module provides a set of utility functions to help manage the PowerShell profile and perform common tasks in the console. The module includes functions for finding files, creating and updating files, extracting files, compressing files, searching for content in files, replacing content in files, moving up directory levels, updating the module directory, updating the profile, updating PowerShell, checking for command existence, reloading the profile, getting system uptime, getting command definitions, setting environment variables, getting environment variables, getting all processes, finding processes by name, finding processes by port, stopping processes by name, stopping processes by port, getting random quotes, getting weather forecasts, starting countdown timers, starting stopwatches, displaying the wall clock, displaying a matrix rain animation, and more.

.PARAMETER None
    This module does not accept any parameters.

.OUTPUTS
    This module does not return any output.

.EXAMPLE
    Show-ProfileHelp
    Displays the help documentation for the PowerShell Profile Helper module.

.NOTES
    This module is intended to provide documentation for the PowerShell Profile Helper module.
#>
function Show-ProfileHelp {
  [CmdletBinding()]
  [Alias("profile-help")]
  param (
    # This function does not accept any parameters
  )

  Write-Host @"
$($PSStyle.Foreground.Cyan)PowerShell Profile Helper$($PSStyle.Reset)

$($PSStyle.Foreground.Yellow)Directory Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Find-Files$($PSStyle.Reset) <Name>
    $($PSStyle.Foreground.Magenta)ff$($PSStyle.Reset) <Name>
        Finds files matching a specified name pattern in the current directory and its subdirectories.

    $($PSStyle.Foreground.Green)Set-FreshFile$($PSStyle.Reset) <File>
    $($PSStyle.Foreground.Magenta)touch$($PSStyle.Reset) <File>
        Creates a new empty file or updates the timestamp of an existing file with the specified name.

    $($PSStyle.Foreground.Green)Expand-File$($PSStyle.Reset) <File>
    $($PSStyle.Foreground.Magenta)unzip$($PSStyle.Reset) <File>
        Extracts a file to the current directory.

    $($PSStyle.Foreground.Green)Compress-Files$($PSStyle.Reset) <Files> <Archive>
    $($PSStyle.Foreground.Magenta)zip$($PSStyle.Reset) <Files> <Archive>
        Compresses files into a zip archive.

    $($PSStyle.Foreground.Green)Get-ContentMatching$($PSStyle.Reset) <Pattern> <Path>
    $($PSStyle.Foreground.Magenta)grep$($PSStyle.Reset) <Pattern> <Path>
        Searches for a string in a file and returns matching lines.

    $($PSStyle.Foreground.Green)Set-ContentMatching$($PSStyle.Reset) <File> <Find> <Replace>
    $($PSStyle.Foreground.Magenta)sed$($PSStyle.Reset) <File> <Find> <Replace>
        Searches for a string in a file and replaces it with another string.

    $($PSStyle.Foreground.Magenta)z$($PSStyle.Reset) <Path>
        Windows equivalent of the 'cd' command, z will print the matched directory before navigating to it.

    $($PSStyle.Foreground.Magenta)zi$($PSStyle.Reset) <Path>
        Windows equivalent of the 'cd' command, but with interactive selection (using fzf).

    $($PSStyle.Foreground.Green)Get-FileHead$($PSStyle.Reset) <Path> <Lines>
    $($PSStyle.Foreground.Magenta)head$($PSStyle.Reset) <Path> <Lines>
        Reads the first few lines of a file.

    $($PSStyle.Foreground.Green)Get-FileTail$($PSStyle.Reset) <Path> <Lines>
    $($PSStyle.Foreground.Magenta)tail$($PSStyle.Reset) <Path> <Lines>
        Reads the last few lines of a file.

    $($PSStyle.Foreground.Green)Invoke-UpOneDirectoryLevel$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)cd.1$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)..$($PSStyle.Reset)
        Moves up one directory level.

    $($PSStyle.Foreground.Green)Invoke-UpTwoDirectoryLevels$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)cd.2$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)...$($PSStyle.Reset)
        Moves up two directory levels.

    $($PSStyle.Foreground.Green)Invoke-UpThreeDirectoryLevels$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)cd.3$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)....$($PSStyle.Reset)
        Moves up three directory levels.

    $($PSStyle.Foreground.Green)Invoke-UpFourDirectoryLevels$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)cd.4$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta).....$($PSStyle.Reset)
        Moves up four directory levels.

    $($PSStyle.Foreground.Green)Invoke-UpFiveDirectoryLevels$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)cd.5$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)......$($PSStyle.Reset)
        Moves up five directory levels.

$($PSStyle.Foreground.Yellow)Network Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Get-MyIPAddress$($PSStyle.Reset) <Local> <IPv4> <IPv6> <ComputerName>
    $($PSStyle.Foreground.Magenta)my-ip$($PSStyle.Reset) <Local> <IPv4> <IPv6> <ComputerName>
        Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.

    $($PSStyle.Foreground.Green)Clear-FlushDNS$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)flush-dns$($PSStyle.Reset)
        Flushes the DNS cache.

$($PSStyle.Foreground.Yellow)Update Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Update-LocalProfileModuleDirectory$($PSStyle.Reset) <LocalPath>
    $($PSStyle.Foreground.Magenta)update-local-module$($PSStyle.Reset) <LocalPath>
        Updates the Modules directory in the local profile with the latest version from the GitHub repository.

    $($PSStyle.Foreground.Green)Update-Profile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-profile$($PSStyle.Reset)
        Checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected.

    $($PSStyle.Foreground.Green)Update-PowerShell$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-ps1$($PSStyle.Reset)
        Checks for updates to PowerShell and upgrades to the latest version if available.

$($PSStyle.Foreground.Yellow)Module Utility$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Test-CommandExists$($PSStyle.Reset) <Command>
    $($PSStyle.Foreground.Magenta)command-exists$($PSStyle.Reset) <Command>
        Checks if a command exists in the current environment.

    $($PSStyle.Foreground.Green)Invoke-ReloadProfile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)reload-profile$($PSStyle.Reset)
        Reloads the PowerShell profile to apply changes.

    $($PSStyle.Foreground.Green)Get-Uptime$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)uptime$($PSStyle.Reset)
        Retrieves the system uptime in a human-readable format.

    $($PSStyle.Foreground.Green)Get-CommandDefinition$($PSStyle.Reset) <Name>
    $($PSStyle.Foreground.Magenta)def$($PSStyle.Reset) <Name>
        Gets the definition of a command.

    $($PSStyle.Foreground.Green)Set-EnvVar$($PSStyle.Reset) <Name> <Value>
    $($PSStyle.Foreground.Magenta)export$($PSStyle.Reset)  <Name> <Value>
    $($PSStyle.Foreground.Magenta)set-env$($PSStyle.Reset)  <Name> <Value>
        Exports an environment variable.

    $($PSStyle.Foreground.Green)Get-EnvVar$($PSStyle.Reset) <Name>
    $($PSStyle.Foreground.Magenta)get-env$($PSStyle.Reset) <Name>
        Retrieves the value of an environment variable.

    $($PSStyle.Foreground.Green)Get-AllProcesses$($PSStyle.Reset) <Name>
    $($PSStyle.Foreground.Magenta)pall$($PSStyle.Reset) <Name>
        Retrieves a list of all running processes.

    $($PSStyle.Foreground.Green)Get-ProcessByName$($PSStyle.Reset) <Name>
    $($PSStyle.Foreground.Magenta)pgrep$($PSStyle.Reset) <Name>
        Finds a process by name.

    $($PSStyle.Foreground.Green)Get-ProcessByPort$($PSStyle.Reset) <Port>
    $($PSStyle.Foreground.Magenta)portgrep$($PSStyle.Reset) <Port>
        Finds a process by port.

    $($PSStyle.Foreground.Green)Stop-ProcessByName$($PSStyle.Reset) <Name>
    $($PSStyle.Foreground.Magenta)pkill$($PSStyle.Reset) <Name>
        Terminates a process by name.

    $($PSStyle.Foreground.Green)Stop-ProcessByPort$($PSStyle.Reset) <Port>
    $($PSStyle.Foreground.Magenta)portkill$($PSStyle.Reset) <Port>
        Terminates a process by port.

    $($PSStyle.Foreground.Green)Get-SystemInfo$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)sysinfo$($PSStyle.Reset)
        Retrieves the system information.

    $($PSStyle.Foreground.Green)Clear-Cache$($PSStyle.Reset) <Type>
    $($PSStyle.Foreground.Magenta)clear-cache$($PSStyle.Reset) <Type>
        Clears windows cache, temp files, and internet explorer cache.

    $($PSStyle.Foreground.Green)Clear-Cache$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)quote$($PSStyle.Reset)
        Retrieves a random quote from an online API.

    $($PSStyle.Foreground.Green)Get-WeatherForecast$($PSStyle.Reset) <Location> <Glyphs> <Moon> <Format> <Lang>
    $($PSStyle.Foreground.Magenta)weather$($PSStyle.Reset) <Location> <Glyphs> <Moon> <Format> <Lang>
        Gets the weather forecast for a specified location.

    $($PSStyle.Foreground.Green)Start-Countdown$($PSStyle.Reset) <Duration> <CountUp> <Title>
    $($PSStyle.Foreground.Magenta)countdown$($PSStyle.Reset) <Duration> <CountUp> <Title>
        Starts a countdown timer.

    $($PSStyle.Foreground.Green)Start-Stopwatch$($PSStyle.Reset) <Title>
    $($PSStyle.Foreground.Magenta)stopwatch$($PSStyle.Reset) <Title>
        Starts a stopwatch.

    $($PSStyle.Foreground.Green)Get-WallClock$($PSStyle.Reset) <Title> <TimeZone>
    $($PSStyle.Foreground.Magenta)wallclock$($PSStyle.Reset) <Title> <TimeZone>
        Displays the current time in a large font using the FIGlet utility.

    $($PSStyle.Foreground.Green)Start-Matrix$($PSStyle.Reset) <SleepTime>
    $($PSStyle.Foreground.Magenta)matrix$($PSStyle.Reset) <SleepTime>
        Displays a matrix rain animation in the console.
"@
}
