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
#       This Module provides documentation for the PowerShell Profile Helper module.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Show-ProfileHelp {
  <#
  .SYNOPSIS
    This module provides documentation for the PowerShell Profile Helper module.

  .DESCRIPTION
    The PowerShell Profile Helper module provides a set of utility functions to help manage the PowerShell profile and perform common tasks in the console. The module includes functions for finding files, creating and updating files, extracting files, compressing files, searching for content in files, replacing content in files, moving up directory levels, updating the module directory, updating the profile, updating PowerShell, checking for command existence, reloading the profile, getting system uptime, getting command definitions, setting environment variables, getting environment variables, getting all processes, finding processes by name, finding processes by port, stopping processes by name, stopping processes by port, getting random quotes, getting weather forecasts, starting countdown timers, starting stopwatches, displaying the wall clock, displaying a matrix rain animation, and more. The `Show-ProfileHelp` function displays detailed help documentation for each section of the module.

  .PARAMETER Section
    Specifies the section of the documentation to display. Valid values are 'All', 'Directory', 'Docs', 'Environment', 'Git', 'Logging', 'Network', 'Plugins', 'Process', 'Starship', 'Update', and 'Utility'. The default value is 'All'.

  .INPUTS
    Section: (Optional) Specifies the section of the documentation to display. Valid values are 'All', 'Directory', 'Docs', 'Environment', 'Git', 'Logging', 'Network', 'Plugins', 'Process', 'Starship', 'Update', and 'Utility'. The default value is 'All'.

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

  .EXAMPLE
    Show-ProfileHelp -Section 'Git'
    Displays the help documentation for the Git plugin with all available Git aliases and commands.

  .EXAMPLE
    Show-ProfileHelp -Section 'Plugins'
    Displays an overview of all available plugins.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
  [CmdletBinding()]
  [Alias("profile-help")]
  [OutputType([void])]
  param (
    [Parameter(
      Mandatory = $false,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Specifies the section of the documentation to display."
    )]
    [ValidateSet(
      'All',
      'Directory',
      'Docs',
      'Environment',
      'Git',
      'Logging',
      'Network',
      'Plugins',
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

    $($PSStyle.Foreground.Green)Get-ShortPath$($PSStyle.Reset) -Path <Path>
    $($PSStyle.Foreground.Magenta)shortpath$($PSStyle.Reset) -Path <Path>
        Retrieves the short path of a file or directory.

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
    $($PSStyle.Foreground.Green)Invoke-ReloadPathEnvironmentVariable$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)reload-env-path$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)reload-path$($PSStyle.Reset)
        Reloads the PATH environment variable.

    $($PSStyle.Foreground.Green)Get-PathEnvironmentVariable$($PSStyle.Reset) [-Scope <Scope>]
    $($PSStyle.Foreground.Magenta)get-env-path$($PSStyle.Reset) [-Scope <Scope>]
    $($PSStyle.Foreground.Magenta)get-path$($PSStyle.Reset) [-Scope <Scope>]
        Retrieves the PATH environment variable.

    $($PSStyle.Foreground.Green)Add-PathEnvironmentVariable$($PSStyle.Reset) -Path <Path> [-Scope <Scope>] [-Append] [-Prepend] [-MakeShort] [-Quiet]
    $($PSStyle.Foreground.Magenta)add-path$($PSStyle.Reset) -Path <Path> [-Scope <Scope>] [-Append] [-Prepend] [-MakeShort] [-Quiet]
    $($PSStyle.Foreground.Magenta)set-path$($PSStyle.Reset) -Path <Path> [-Scope <Scope>] [-Append] [-Prepend] [-MakeShort] [-Quiet]
        Sets the PATH environment variable.

    $($PSStyle.Foreground.Green)Remove-PathEnvironmentVariable$($PSStyle.Reset) -Path <Path> [-Scope <Scope>] [-Force]
    $($PSStyle.Foreground.Magenta)remove-path$($PSStyle.Reset) -Path <Path> [-Scope <Scope>] [-Force]
        Removes a path from the PATH environment variable.

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

  $Plugins = @"
$($PSStyle.Foreground.Yellow)Plugins Module$($PSStyle.Reset)
    This module contains various plugins that extend PowerShell functionality.
    Each plugin provides specialized commands and aliases for specific tools or workflows.

    Available Plugins:
        $($PSStyle.Foreground.Cyan)Git Plugin$($PSStyle.Reset) - Comprehensive Git aliases and shortcuts (160+ commands)

    Use 'Show-ProfileHelp -Section Git' to view specific plugin documentation.
"@

  $PluginsGit = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Git Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive Git aliases and shortcuts$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Basic Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)g$($PSStyle.Reset) <args>           - Direct git command wrapper
        $($PSStyle.Foreground.Magenta)grt$($PSStyle.Reset)                - Navigate to git repository root
        $($PSStyle.Foreground.Magenta)gst$($PSStyle.Reset)                - Git status
        $($PSStyle.Foreground.Magenta)gss$($PSStyle.Reset)                - Git status short
        $($PSStyle.Foreground.Magenta)gsb$($PSStyle.Reset)                - Git status short with branch info

    $($PSStyle.Foreground.Green)Add Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)ga$($PSStyle.Reset) <files>         - Git add files
        $($PSStyle.Foreground.Magenta)gaa$($PSStyle.Reset)                - Git add all
        $($PSStyle.Foreground.Magenta)gapa$($PSStyle.Reset)               - Git add patch (interactive)
        $($PSStyle.Foreground.Magenta)gau$($PSStyle.Reset)                - Git add update (modified files only)
        $($PSStyle.Foreground.Magenta)gav$($PSStyle.Reset)                - Git add verbose

    $($PSStyle.Foreground.Green)Branch Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gb$($PSStyle.Reset)                 - Git branch
        $($PSStyle.Foreground.Magenta)gba$($PSStyle.Reset)                - Git branch all
        $($PSStyle.Foreground.Magenta)gbd$($PSStyle.Reset) <branch>       - Git branch delete
        $($PSStyle.Foreground.Magenta)gbD$($PSStyle.Reset) <branch>       - Git branch force delete
        $($PSStyle.Foreground.Magenta)gbm$($PSStyle.Reset) <name>         - Git branch move/rename

    $($PSStyle.Foreground.Green)Checkout/Switch Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gco$($PSStyle.Reset) <branch>       - Git checkout
        $($PSStyle.Foreground.Magenta)gcb$($PSStyle.Reset) <branch>       - Git checkout new branch
        $($PSStyle.Foreground.Magenta)gcm$($PSStyle.Reset)                - Git checkout main/master
        $($PSStyle.Foreground.Magenta)gcd$($PSStyle.Reset)                - Git checkout develop
        $($PSStyle.Foreground.Magenta)gsw$($PSStyle.Reset) <branch>       - Git switch
        $($PSStyle.Foreground.Magenta)gswc$($PSStyle.Reset) <branch>      - Git switch create

    $($PSStyle.Foreground.Green)Commit Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gcmsg$($PSStyle.Reset) <msg>        - Git commit with message
        $($PSStyle.Foreground.Magenta)gcam$($PSStyle.Reset) <msg>         - Git commit all with message
        $($PSStyle.Foreground.Magenta)gca$($PSStyle.Reset)                - Git commit all verbose
        $($PSStyle.Foreground.Magenta)gcv$($PSStyle.Reset)                - Git commit verbose

    $($PSStyle.Foreground.Green)Diff Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gd$($PSStyle.Reset)                 - Git diff
        $($PSStyle.Foreground.Magenta)gdca$($PSStyle.Reset)               - Git diff cached
        $($PSStyle.Foreground.Magenta)gds$($PSStyle.Reset)                - Git diff staged
        $($PSStyle.Foreground.Magenta)gdw$($PSStyle.Reset)                - Git diff word-diff

    $($PSStyle.Foreground.Green)Log Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)glog$($PSStyle.Reset)               - Git log oneline graph
        $($PSStyle.Foreground.Magenta)gloga$($PSStyle.Reset)              - Git log oneline graph all
        $($PSStyle.Foreground.Magenta)glol$($PSStyle.Reset)               - Git log oneline with dates
        $($PSStyle.Foreground.Magenta)glg$($PSStyle.Reset)                - Git log with stats

    $($PSStyle.Foreground.Green)Pull/Push Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gl$($PSStyle.Reset)                 - Git pull
        $($PSStyle.Foreground.Magenta)gpr$($PSStyle.Reset)                - Git pull rebase
        $($PSStyle.Foreground.Magenta)gp$($PSStyle.Reset)                 - Git push
        $($PSStyle.Foreground.Magenta)gpf$($PSStyle.Reset)                - Git push force-with-lease
        $($PSStyle.Foreground.Magenta)gpsup$($PSStyle.Reset)              - Git push set upstream
        $($PSStyle.Foreground.Magenta)ggpull$($PSStyle.Reset)             - Git pull current branch
        $($PSStyle.Foreground.Magenta)ggpush$($PSStyle.Reset)             - Git push current branch

    $($PSStyle.Foreground.Green)Rebase Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)grb$($PSStyle.Reset) <branch>       - Git rebase
        $($PSStyle.Foreground.Magenta)grbi$($PSStyle.Reset) <commits>     - Git rebase interactive
        $($PSStyle.Foreground.Magenta)grba$($PSStyle.Reset)               - Git rebase abort
        $($PSStyle.Foreground.Magenta)grbc$($PSStyle.Reset)               - Git rebase continue
        $($PSStyle.Foreground.Magenta)grbm$($PSStyle.Reset)               - Git rebase main

    $($PSStyle.Foreground.Green)Stash Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gsta$($PSStyle.Reset) <msg>         - Git stash push
        $($PSStyle.Foreground.Magenta)gstl$($PSStyle.Reset)               - Git stash list
        $($PSStyle.Foreground.Magenta)gstp$($PSStyle.Reset)               - Git stash pop
        $($PSStyle.Foreground.Magenta)gstaa$($PSStyle.Reset)              - Git stash apply
        $($PSStyle.Foreground.Magenta)gstd$($PSStyle.Reset)               - Git stash drop

    $($PSStyle.Foreground.Green)Reset/Restore Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)grh$($PSStyle.Reset) <commit>       - Git reset
        $($PSStyle.Foreground.Magenta)grhh$($PSStyle.Reset) <commit>      - Git reset hard
        $($PSStyle.Foreground.Magenta)grhs$($PSStyle.Reset) <commit>      - Git reset soft
        $($PSStyle.Foreground.Magenta)grs$($PSStyle.Reset) <files>        - Git restore
        $($PSStyle.Foreground.Magenta)grst$($PSStyle.Reset) <files>       - Git restore staged

    $($PSStyle.Foreground.Green)Remote Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gr$($PSStyle.Reset)                 - Git remote
        $($PSStyle.Foreground.Magenta)grv$($PSStyle.Reset)                - Git remote verbose
        $($PSStyle.Foreground.Magenta)gra$($PSStyle.Reset) <name> <url>   - Git remote add
        $($PSStyle.Foreground.Magenta)gf$($PSStyle.Reset)                 - Git fetch
        $($PSStyle.Foreground.Magenta)gfa$($PSStyle.Reset)                - Git fetch all

    $($PSStyle.Foreground.Green)Workflow Helpers:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gwip$($PSStyle.Reset)               - Git work in progress (quick save)
        $($PSStyle.Foreground.Magenta)gunwip$($PSStyle.Reset)             - Git undo work in progress
        $($PSStyle.Foreground.Magenta)gcl$($PSStyle.Reset) <url>          - Git clone with submodules
        $($PSStyle.Foreground.Magenta)gccd$($PSStyle.Reset) <url>         - Git clone and cd into directory

    $($PSStyle.Foreground.Green)Advanced Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)gcp$($PSStyle.Reset) <commit>       - Git cherry-pick
        $($PSStyle.Foreground.Magenta)gm$($PSStyle.Reset) <branch>        - Git merge
        $($PSStyle.Foreground.Magenta)grev$($PSStyle.Reset) <commit>      - Git revert
        $($PSStyle.Foreground.Magenta)gtv$($PSStyle.Reset)                - Git tag list sorted
        $($PSStyle.Foreground.Magenta)gwt$($PSStyle.Reset)                - Git worktree

    Note: All Git functions include automatic repository validation.
    Over 160+ Git aliases available - see full documentation for complete list.
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

    $($PSStyle.Foreground.Green)Update-WindowsTerminalConfig$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)update-terminal-config$($PSStyle.Reset)
        Updates the Windows Terminal configuration file with the latest settings from the GitHub repository.
"@

  $Utility = @"
$($PSStyle.Foreground.Yellow)Utility Module$($PSStyle.Reset)
    $($PSStyle.Foreground.Green)Test-Administrator$($PSStyle.Reset)
    $($PSStyle.Foreground.Magenta)is-admin$($PSStyle.Reset)
        Checks if the current user has administrator privileges.

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

    $($PSStyle.Foreground.Green)Get-PrayerTimes$($PSStyle.Reset) -City <City> -Country <Country> [-Method <Method>] [-Use24HourFormat]
    $($PSStyle.Foreground.Magenta)prayer$($PSStyle.Reset) -City <City> -Country <Country> [-Method <Method>] [-Use24HourFormat]
        Retrieves the prayer times for a specified city and country.

    $($PSStyle.Foreground.Green)Start-Matrix$($PSStyle.Reset) [-SleepTime <SleepTime>]
    $($PSStyle.Foreground.Magenta)matrix$($PSStyle.Reset) [-SleepTime <SleepTime>]
        Displays a matrix rain animation in the console.

    $($PSStyle.Foreground.Green)Get-DiskUsage$($PSStyle.Reset) [-Path <Path>] [-Unit <Unit>]
    $($PSStyle.Foreground.Magenta)du$($PSStyle.Reset) [-Path <Path>] [-Unit <Unit>]
        Retrieves the disk usage for a specified path.

    $($PSStyle.Foreground.Green)Format-ConvertSize$($PSStyle.Reset) -Value <Value> [-Units <Units>] [-Scale <Scale>] [-DecimalPlaces <DecimalPlaces>]
    $($PSStyle.Foreground.Magenta)convert-size$($PSStyle.Reset) -Value <Value> [-Units <Units>] [-Scale <Scale>] [-DecimalPlaces <DecimalPlaces>]
        Converts a size value to a specified unit and formats it.
"@

  switch ($Section) {
    'All' {
      Write-Host $Title
      Write-Host $Directory
      Write-Host $Docs
      Write-Host $Environment
      Write-Host $Logging
      Write-Host $Network
      Write-Host $Plugins
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
    'Git' {
      Write-Host $Title
      Write-Host $PluginsGit
    }
    'Logging' {
      Write-Host $Title
      Write-Host $Logging
    }
    'Network' {
      Write-Host $Title
      Write-Host $Network
    }
    'Plugins' {
      Write-Host $Title
      Write-Host $Plugins
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
