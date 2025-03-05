function Show-ProfileHelp {
  [CmdletBinding()]
  [Alias("profile-help")]
  param ()

  Write-Host @"
$($PSStyle.Foreground.Cyan)PowerShell Profile Helper$($PSStyle.Reset)

$($PSStyle.Foreground.Yellow)Module Directory$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Find-Files$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)ff$($PSStyle.Reset)
        Finds files matching a specified name pattern in the current directory and its subdirectories.

    $($PSStyle.Foreground.Green)Set-FreshFile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)touch$($PSStyle.Reset)
        Creates a new empty file or updates the timestamp of an existing file with the specified name.

    $($PSStyle.Foreground.Green)Expand-File$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)unzip$($PSStyle.Reset)
        Extracts a file to the current directory.

    $($PSStyle.Foreground.Green)Compress-Files$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)zip$($PSStyle.Reset)
        Compresses files into a zip archive.

    $($PSStyle.Foreground.Green)Get-ContentMatching$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)grep$($PSStyle.Reset)
        Searches for a string in a file and returns matching lines.

    $($PSStyle.Foreground.Green)Set-ContentMatching$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)sed$($PSStyle.Reset)
        Searches for a string in a file and replaces it with another string.

    $($PSStyle.Foreground.Green)Get-CommandDefinition$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)def$($PSStyle.Reset)
        Gets the definition of a command.

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

$($PSStyle.Foreground.Yellow)Module Update$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Update-LocalProfileModuleDirectory$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-local-module$($PSStyle.Reset)
        Updates the Modules directory in the local profile with the latest version from the GitHub repository.

    $($PSStyle.Foreground.Green)Update-Profile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-profile$($PSStyle.Reset)
        Checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected.

    $($PSStyle.Foreground.Green)Update-PowerShell$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-ps1$($PSStyle.Reset)
        Checks for updates to PowerShell and upgrades to the latest version if available.

$($PSStyle.Foreground.Yellow)Module Utility$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Test-CommandExists$($PSStyle.Reset) <command>
    $($PSStyle.Foreground.Magenta)command-exists$($PSStyle.Reset) <command>
        Checks if a command exists in the current environment.

    $($PSStyle.Foreground.Green)Invoke-ReloadProfile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)reload-profile$($PSStyle.Reset)
        Reloads the PowerShell profile to apply changes.

    $($PSStyle.Foreground.Green)Get-Uptime$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)uptime$($PSStyle.Reset)
        Retrieves the system uptime in a human-readable format.

    $($PSStyle.Foreground.Green)Set-EnvVar$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)set-env$($PSStyle.Reset)
        Exports an environment variable.

    $($PSStyle.Foreground.Green)Get-EnvVar$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)get-env$($PSStyle.Reset)
        Retrieves the value of an environment variable.

    $($PSStyle.Foreground.Green)Get-AllProcesses$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)pall$($PSStyle.Reset)
        Retrieves a list of all running processes.

    $($PSStyle.Foreground.Green)Get-ProcessByName$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)pgrep$($PSStyle.Reset)
        Finds a process by name.

    $($PSStyle.Foreground.Green)Get-ProcessByPort$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)portgrep$($PSStyle.Reset)
        Finds a process by port.

    $($PSStyle.Foreground.Green)Stop-ProcessByName$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)pkill$($PSStyle.Reset)
        Terminates a process by name.

    $($PSStyle.Foreground.Green)Stop-ProcessByPort$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)portkill$($PSStyle.Reset)
        Terminates a process by port.

    $($PSStyle.Foreground.Green)Get-RandomQuote$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)quote$($PSStyle.Reset)
        Retrieves a random quote from an online API.

    $($PSStyle.Foreground.Green)Get-WeatherForecast$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)weather$($PSStyle.Reset)
        Gets the weather forecast for a specified location.

    $($PSStyle.Foreground.Green)Start-Countdown$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)countdown$($PSStyle.Reset)
        Starts a countdown timer.

    $($PSStyle.Foreground.Green)Start-Stopwatch$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)stopwatch$($PSStyle.Reset)
        Starts a stopwatch.

    $($PSStyle.Foreground.Green)Get-WallClock$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)wallclock$($PSStyle.Reset)
        Displays the current time in a large font using the FIGlet utility.

    $($PSStyle.Foreground.Green)Start-Matrix$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)matrix$($PSStyle.Reset)
        Displays a matrix rain animation in the console.
"@
}
