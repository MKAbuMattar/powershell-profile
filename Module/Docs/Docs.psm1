<#
.SYNOPSIS
  This module provides documentation for the PowerShell Profile Helper module.

.DESCRIPTION
  The PowerShell Profile Helper module provides a set of utility functions to help manage the PowerShell profile and perform common tasks in the console. The module includes functions for finding files, creating and updating files, extracting files, compressing files, searching for content in files, replacing content in files, moving up directory levels, updating the module directory, updating the profile, updating PowerShell, checking for command existence, reloading the profile, getting system uptime, getting command definitions, setting environment variables, getting environment variables, getting all processes, finding processes by name, finding processes by port, stopping processes by name, stopping processes by port, getting random quotes, getting weather forecasts, starting countdown timers, starting stopwatches, displaying the wall clock, displaying a matrix rain animation, and more. The `Show-ProfileHelp` function displays detailed help documentation for each section of the module.

.PARAMETER Section
  Specifies the section of the documentation to display. Valid values are 'All', 'Directory', 'Docs', 'Environment', 'Logging', 'Network', 'Starship', 'Update', and 'Utility'. The default value is 'All'.

.INPUTS
  Section: (Optional) Specifies the section of the documentation to display. Valid values are 'All', 'Directory', 'Docs', 'Environment', 'Logging', 'Network', 'Starship', 'Update', and 'Utility'. The default value is 'All'.

.OUTPUTS
  This module does not return any output.

.NOTES
  This module is intended to provide documentation for the PowerShell Profile Helper module.

.EXAMPLE
  Show-ProfileHelp
  Displays the help documentation for all sections of the PowerShell Profile Helper module.

.EXAMPLE
  Show-ProfileHelp -Section 'Directory'
  Displays the help documentation for the Directory section of the PowerShell Profile Helper module.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Show-ProfileHelp {
  [CmdletBinding()]
  [Alias("profile-help")]
  [OutputType([void])]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateSet(
      'All',
      'Directory',
      'Docs',
      'Environment',
      'Logging',
      'Network',
      'Process',
      'Starship',
      'Update',
      'Utility'
    )]
    [string]$Section = 'All'
  )

  $Title = @"
$($PSStyle.Foreground.Cyan)PowerShell Profile Helper$($PSStyle.Reset)
"@

  $Directory = @"
$($PSStyle.Foreground.Yellow)Directory Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Find-Files$($PSStyle.Reset) -Name <Name>
    $($PSStyle.Foreground.Magenta)ff$($PSStyle.Reset) -Name <Name>
        Finds files matching a specified name pattern in the current directory and its subdirectories.

    $($PSStyle.Foreground.Green)Set-FreshFile$($PSStyle.Reset) -File <File>
    $($PSStyle.Foreground.Magenta)touch$($PSStyle.Reset) -File <File>
        Creates a new empty file or updates the timestamp of an existing file with the specified name.

    $($PSStyle.Foreground.Green)Expand-File$($PSStyle.Reset) -File <File>
    $($PSStyle.Foreground.Magenta)unzip$($PSStyle.Reset) -File <File>
        Extracts a file to the current directory.

    $($PSStyle.Foreground.Green)Compress-Files$($PSStyle.Reset) -Files <Files> -Archive <Archive>
    $($PSStyle.Foreground.Magenta)zip$($PSStyle.Reset) -Files <Files> -Archive <Archive>
        Compresses files into a zip archive.

    $($PSStyle.Foreground.Green)Get-ContentMatching$($PSStyle.Reset) -Pattern <Pattern> [-Path <Path>]
    $($PSStyle.Foreground.Magenta)grep$($PSStyle.Reset) -Pattern <Pattern> [-Path <Path>]
        Searches for a string in a file and returns matching lines.

    $($PSStyle.Foreground.Green)Set-ContentMatching$($PSStyle.Reset) -File <File> -Find <Find> -Replace <Replace>
    $($PSStyle.Foreground.Magenta)sed$($PSStyle.Reset) -File <File> -Find <Find> -Replace <Replace>
        Searches for a string in a file and replaces it with another string.

    $($PSStyle.Foreground.Magenta)z$($PSStyle.Reset) -Path <Path>
        Windows equivalent of the 'cd' command, z will print the matched directory before navigating to it.

    $($PSStyle.Foreground.Magenta)zi$($PSStyle.Reset) -Path <Path>
        Windows equivalent of the 'cd' command, but with interactive selection (using fzf).

    $($PSStyle.Foreground.Green)Get-FileHead$($PSStyle.Reset) -Path <Path> [-Lines <Lines>]
    $($PSStyle.Foreground.Magenta)head$($PSStyle.Reset) -Path <Path> [-Lines <Lines>]
        Reads the first few lines of a file.

    $($PSStyle.Foreground.Green)Get-FileTail$($PSStyle.Reset) -Path <Path> [-Lines <Lines>] [-Wait]
    $($PSStyle.Foreground.Magenta)tail$($PSStyle.Reset) -Path <Path> [-Lines <Lines>] [-Wait]
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
"@

  $Docs = @"
$($PSStyle.Foreground.Yellow)Docs Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Show-ProfileHelp$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)profile-help$($PSStyle.Reset)
        Displays the help documentation for the PowerShell Profile Helper module.
"@

  $Environment = @"
$($PSStyle.Foreground.Yellow)Environment Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Set-EnvVar$($PSStyle.Reset) -Name <Name> -Value <Value>
    $($PSStyle.Foreground.Magenta)set-env$($PSStyle.Reset) -Name <Name> -Value <Value>
    $($PSStyle.Foreground.Magenta)export$($PSStyle.Reset) -Name <Name> -Value <Value>
        Exports an environment variable with the specified name and value.

    $($PSStyle.Foreground.Green)Get-EnvVar$($PSStyle.Reset) -Name <Name>
    $($PSStyle.Foreground.Magenta)get-env$($PSStyle.Reset) -Name <Name>
        Retrieves the value of the specified environment variable.

    $($PSStyle.Foreground.Green)AutoUpdateProfile$($PSStyle.Reset)
        Global variable to disable/enable the Auto Update feature for the PowerShell profile.

    $($PSStyle.Foreground.Green)AutoUpdatePowerShell$($PSStyle.Reset)
        Global variable to disable/enable the Auto Update feature for PowerShell.

    $($PSStyle.Foreground.Green)CanConnectToGitHub$($PSStyle.Reset)
        Global variable to test if the machine can connect to GitHub.
"@

  $Logging = @"
$($PSStyle.Foreground.Yellow)Logging Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Write-LogMessage$($PSStyle.Reset) -Message <Message> [-Level <Level>]
    $($PSStyle.Foreground.Magenta)log-message$($PSStyle.Reset) -Message <Message> [-Level <Level>]
        Logs a message with a timestamp and log level. The default log level is "INFO".
"@

  $Network = @"
$($PSStyle.Foreground.Yellow)Network Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Get-MyIPAddress$($PSStyle.Reset) [-Local] [-IPv4] [-IPv6] [-ComputerName <ComputerName>]
    $($PSStyle.Foreground.Magenta)my-ip$($PSStyle.Reset) [-Local] [-IPv4] [-IPv6] [-ComputerName <ComputerName>]
        Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.

    $($PSStyle.Foreground.Green)Clear-FlushDNS$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)flush-dns$($PSStyle.Reset)
        Flushes the DNS cache.
"@



  $Process = @"
$($PSStyle.Foreground.Yellow)Process Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Get-SystemInfo$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)sysinfo$($PSStyle.Reset)
        Retrieves the system information.

    $($PSStyle.Foreground.Green)Get-AllProcesses$($PSStyle.Reset) [-Name <Name>]
    $($PSStyle.Foreground.Magenta)pall$($PSStyle.Reset) [-Name <Name>]
        Retrieves a list of all running processes.

    $($PSStyle.Foreground.Green)Get-ProcessByName$($PSStyle.Reset) -Name <Name>
    $($PSStyle.Foreground.Magenta)pgrep$($PSStyle.Reset) -Name <Name>
        Finds a process by name.

    $($PSStyle.Foreground.Green)Get-ProcessByPort$($PSStyle.Reset) -Port <Port>
    $($PSStyle.Foreground.Magenta)portgrep$($PSStyle.Reset) -Port <Port>
        Finds a process by port.

    $($PSStyle.Foreground.Green)Stop-ProcessByName$($PSStyle.Reset) -Name <Name>
    $($PSStyle.Foreground.Magenta)pkill$($PSStyle.Reset) -Name <Name>
        Terminates a process by name.

    $($PSStyle.Foreground.Green)Stop-ProcessByPort$($PSStyle.Reset) -Port <Port>
    $($PSStyle.Foreground.Magenta)portkill$($PSStyle.Reset) -Port <Port>
        Terminates a process by port.

    $($PSStyle.Foreground.Green)Invoke-ClearCache$($PSStyle.Reset) [-Type <Type>]
    $($PSStyle.Foreground.Magenta)clear-cache$($PSStyle.Reset) [-Type <Type>]
        Clears windows cache, temp files, and internet explorer cache.
"@

  $Starship = @"
$($PSStyle.Foreground.Yellow)Starship Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Invoke-StarshipTransientFunction$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)starship-transient$($PSStyle.Reset)
        Invokes the Starship module transiently to load the Starship prompt, enhancing the appearance and functionality of the PowerShell prompt.
"@

  $Update = @"
$($PSStyle.Foreground.Yellow)Update Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Update-LocalProfileModuleDirectory$($PSStyle.Reset) [-LocalPath <LocalPath>]
    $($PSStyle.Foreground.Magenta)update-local-module$($PSStyle.Reset) [-LocalPath <LocalPath>]
        Updates the Modules directory in the local profile with the latest version from the GitHub repository.

    $($PSStyle.Foreground.Green)Update-Profile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-profile$($PSStyle.Reset)
        Checks for updates to the PowerShell profile and updates the local profile if changes are detected.

    $($PSStyle.Foreground.Green)Update-PowerShell$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-ps1$($PSStyle.Reset)
        Checks for updates to PowerShell and upgrades to the latest version if available.
"@

  $Utility = @"
$($PSStyle.Foreground.Yellow)Utility Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Test-CommandExists$($PSStyle.Reset) -Command <Command>
    $($PSStyle.Foreground.Magenta)command-exists$($PSStyle.Reset) -Command <Command>
        Checks if a command exists in the current environment.

    $($PSStyle.Foreground.Green)Invoke-ReloadProfile$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)reload-profile$($PSStyle.Reset)
        Reloads the PowerShell profile to apply changes.

    $($PSStyle.Foreground.Green)Get-Uptime$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)uptime$($PSStyle.Reset)
        Retrieves the system uptime in a human-readable format.

    $($PSStyle.Foreground.Green)Get-CommandDefinition$($PSStyle.Reset) -Name <Name>
    $($PSStyle.Foreground.Magenta)def$($PSStyle.Reset) -Name <Name>
        Gets the definition of a command.

    $($PSStyle.Foreground.Green)Get-RandomQuote$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)quote$($PSStyle.Reset)
        Retrieves a random quote from an online API.

    $($PSStyle.Foreground.Green)Get-WeatherForecast$($PSStyle.Reset) [-Location <Location>] [-Glyphs] [-Moon] [-Format <Format>] [-Lang <Lang>]
    $($PSStyle.Foreground.Magenta)weather$($PSStyle.Reset) [-Location <Location>] [-Glyphs] [-Moon] [-Format <Format>] [-Lang <Lang>]
        Gets the weather forecast for a specified location.

    $($PSStyle.Foreground.Green)Start-Countdown$($PSStyle.Reset) -Duration <Duration> [-CountUp] [-Title <Title>]
    $($PSStyle.Foreground.Magenta)countdown$($PSStyle.Reset) -Duration <Duration> [-CountUp] [-Title <Title>]
        Starts a countdown timer.

    $($PSStyle.Foreground.Green)Start-Stopwatch$($PSStyle.Reset) [-Title <Title>]
    $($PSStyle.Foreground.Magenta)stopwatch$($PSStyle.Reset) [-Title <Title>]
        Starts a stopwatch.

    $($PSStyle.Foreground.Green)Get-WallClock$($PSStyle.Reset) [-Title <Title>] [-TimeZone <TimeZone>]
    $($PSStyle.Foreground.Magenta)wallclock$($PSStyle.Reset) [-Title <Title>] [-TimeZone <TimeZone>]
        Displays the current time in a large font using the FIGlet utility.

    $($PSStyle.Foreground.Green)Start-Matrix$($PSStyle.Reset) [-SleepTime <SleepTime>]
    $($PSStyle.Foreground.Magenta)matrix$($PSStyle.Reset) [-SleepTime <SleepTime>]
        Displays a matrix rain animation in the console.
"@

  switch ($Section) {
    'All' {
      Write-Host $Title
      Write-Host $Directory
      Write-Host $Docs
      Write-Host $Environment
      Write-Host $Logging
      Write-Host $Network
      Write-Host $Process
      Write-Host $Starship
      Write-Host $Update
      Write-Host $Utility
    }
    'Directory' {
      Write-Host $Title
      Write-Host $Directory
    }
    'Docs' {
      Write-Host $Title
      Write-Host $Docs
    }
    'Environment' {
      Write-Host $Title
      Write-Host $Environment
    }
    'Logging' {
      Write-Host $Title
      Write-Host $Logging
    }
    'Network' {
      Write-Host $Title
      Write-Host $Network
    }
    'Process' {
      Write-Host $Title
      Write-Host $Process
    }
    'Starship' {
      Write-Host $Title
      Write-Host $Starship
    }
    'Update' {
      Write-Host $Title
      Write-Host $Update
    }
    'Utility' {
      Write-Host $Title
      Write-Host $Utility
    }
    Default {
      Write-Host $Title
      Write-Host $Docs
    }
  }
}
