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
        Specifies the section of the documentation to display. Valid values are 'All', 'AWS', 'Directory', 'Docker', 'DockerCompose', 'Docs', 'Environment', 'Git', 'Helm', 'Kubectl', 'Logging', 'Network', 'NPM', 'PIP', 'Pipenv', 'PNPM', 'Poetry', 'Plugins', 'Process', 'Starship', 'Terraform', 'Terragrunt', 'UV', 'Update', 'Utility', and 'Yarn'. The default value is 'All'.

    .INPUTS
        Section: (Optional) Specifies the section of the documentation to display. Valid values are 'All', 'AWS', 'Directory', 'Docker', 'DockerCompose', 'Docs', 'Environment', 'Git', 'Helm', 'Kubectl', 'Logging', 'Network', 'NPM', 'PIP', 'Pipenv', 'PNPM', 'Poetry', 'Plugins', 'Process', 'Starship', 'Terraform', 'Terragrunt', 'UV', 'Update', 'Utility', and 'Yarn'. The default value is 'All'.

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
        Show-ProfileHelp -Section 'AWS'
        Displays the help documentation for the AWS plugin with all available AWS aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Docker'
        Displays the help documentation for the Docker plugin with all available Docker aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'DockerCompose'
        Displays the help documentation for the DockerCompose plugin with all available Docker Compose aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Git'
        Displays the help documentation for the Git plugin with all available Git aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Helm'
        Displays the help documentation for the Helm plugin with all available Helm aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Kubectl'
        Displays the help documentation for the Kubectl plugin with all available kubectl aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'NPM'
        Displays the help documentation for the NPM plugin with all available npm aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'PIP'
        Displays the help documentation for the PIP plugin with all available pip aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Pipenv'
        Displays the help documentation for the Pipenv plugin with all available pipenv aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Poetry'
        Displays the help documentation for the Poetry plugin with all available poetry aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Terraform'
        Displays the help documentation for the Terraform plugin with all available terraform aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Terragrunt'
        Displays the help documentation for the Terragrunt plugin with all available terragrunt aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'UV'
        Displays the help documentation for the UV plugin with all available UV aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Yarn'
        Displays the help documentation for the Yarn plugin with all available Yarn aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'Deno'
        Displays the help documentation for the Deno plugin with all available Deno aliases and commands.

    .EXAMPLE
        Show-ProfileHelp -Section 'PNPM'
        Displays the help documentation for the PNPM plugin with all available pnpm aliases and commands.

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
            'AWS',
            'Deno',
            'Directory',
            'Docker',
            'DockerCompose',
            'Docs',
            'Environment',
            'Git',
            'Helm',
            'Kubectl',
            'Logging',
            'NPM',
            'Network',
            'PIP',
            'Pipenv',
            'PNPM',
            'Plugins',
            'Poetry',
            'Process',
            'Starship',
            'Terraform',
            'Terragrunt',
            'UV',
            'Update',
            'Utility',
            'Yarn'
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
        $($PSStyle.Foreground.Cyan)AWS Plugin$($PSStyle.Reset) - Comprehensive AWS CLI integration with profile management and MFA support (12 commands)
        $($PSStyle.Foreground.Cyan)Deno Plugin$($PSStyle.Reset) - Comprehensive Deno CLI integration with PowerShell aliases (25+ commands)
        $($PSStyle.Foreground.Cyan)Docker Plugin$($PSStyle.Reset) - Complete Docker CLI integration with PowerShell aliases (37 commands)
        $($PSStyle.Foreground.Cyan)DockerCompose Plugin$($PSStyle.Reset) - Complete Docker Compose CLI integration with PowerShell aliases (20 commands)
        $($PSStyle.Foreground.Cyan)Git Plugin$($PSStyle.Reset) - Comprehensive Git aliases and shortcuts (160+ commands)
        $($PSStyle.Foreground.Cyan)Helm Plugin$($PSStyle.Reset) - Complete Helm CLI integration with PowerShell aliases (20+ commands)
        $($PSStyle.Foreground.Cyan)Kubectl Plugin$($PSStyle.Reset) - Complete kubectl CLI integration with PowerShell aliases (40+ commands)
        $($PSStyle.Foreground.Cyan)NPM Plugin$($PSStyle.Reset) - Complete NPM CLI integration with PowerShell aliases (40+ commands)
        $($PSStyle.Foreground.Cyan)PIP Plugin$($PSStyle.Reset) - Complete PIP CLI integration with PowerShell aliases (20+ commands)
        $($PSStyle.Foreground.Cyan)PNPM Plugin$($PSStyle.Reset) - Comprehensive PNPM CLI integration with PowerShell aliases (68+ commands)
        $($PSStyle.Foreground.Cyan)Pipenv Plugin$($PSStyle.Reset) - Complete Pipenv CLI integration with PowerShell aliases (20+ commands)
        $($PSStyle.Foreground.Cyan)Poetry Plugin$($PSStyle.Reset) - Complete Poetry CLI integration with PowerShell aliases (20+ commands)
        $($PSStyle.Foreground.Cyan)Terraform Plugin$($PSStyle.Reset) - Complete Terraform CLI integration with PowerShell aliases (40+ commands)
        $($PSStyle.Foreground.Cyan)Terragrunt Plugin$($PSStyle.Reset) - Complete Terragrunt CLI integration with PowerShell aliases (20+ commands)
        $($PSStyle.Foreground.Cyan)UV Plugin$($PSStyle.Reset) - Complete UV CLI integration with PowerShell aliases (20+ commands)
        $($PSStyle.Foreground.Cyan)Yarn Plugin$($PSStyle.Reset) - Complete Yarn CLI integration with PowerShell aliases (40+ commands)

    Use $($PSStyle.Foreground.Magenta)Show-ProfileHelp -Section '<PluginName>'$($PSStyle.Reset) to view detailed documentation for each plugin.
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

    $PluginsAWS = @"
$($PSStyle.Foreground.Yellow)Plugins Module - AWS Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive AWS CLI integration with advanced features$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Basic Information:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)agp$($PSStyle.Reset)                 - Show current AWS profile
        $($PSStyle.Foreground.Magenta)agr$($PSStyle.Reset)                 - Show current AWS region
        $($PSStyle.Foreground.Magenta)aws-profiles$($PSStyle.Reset)        - List all configured profiles
        $($PSStyle.Foreground.Magenta)aws-regions$($PSStyle.Reset)         - List all available regions

    $($PSStyle.Foreground.Green)Profile & Region Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)asp$($PSStyle.Reset) <profile>       - Set AWS profile with optional SSO
        $($PSStyle.Foreground.Magenta)asp$($PSStyle.Reset) <profile> login - Set profile and perform SSO login
        $($PSStyle.Foreground.Magenta)asp$($PSStyle.Reset) <profile> logout- Set profile and perform SSO logout
        $($PSStyle.Foreground.Magenta)asr$($PSStyle.Reset) <region>        - Set AWS region with validation
        $($PSStyle.Foreground.Magenta)asp$($PSStyle.Reset)                 - Clear current profile
        $($PSStyle.Foreground.Magenta)asr$($PSStyle.Reset)                 - Clear current region

    $($PSStyle.Foreground.Green)Advanced Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)acp$($PSStyle.Reset) <profile>       - Advanced profile switching with MFA/role assumption
        $($PSStyle.Foreground.Magenta)acp$($PSStyle.Reset) <profile> <mfa> - Switch profile with MFA token
        $($PSStyle.Foreground.Magenta)aws-change-key$($PSStyle.Reset) <prof>- Rotate access keys securely

    $($PSStyle.Foreground.Green)Key Features:$($PSStyle.Reset)
        • Multi-Factor Authentication (MFA) support with configurable session duration
        • Cross-account role assumption with external ID support
        • AWS SSO integration for seamless login/logout operations
        • State persistence across PowerShell sessions (when enabled)
        • Secure access key rotation with guided workflow
        • Profile and region validation against AWS configuration
        • PowerShell prompt integration for AWS context display

    $($PSStyle.Foreground.Green)Configuration Examples:$($PSStyle.Reset)
        # Enable state persistence
        $($PSStyle.Foreground.Cyan)\$env:AWS_PROFILE_STATE_ENABLED = 'true'$($PSStyle.Reset)

        # Configure MFA in AWS profile
        $($PSStyle.Foreground.Cyan)[profile my-profile]
        mfa_serial = arn:aws:iam::123456789012:mfa/username
        duration_seconds = 3600$($PSStyle.Reset)

        # Configure cross-account role
        $($PSStyle.Foreground.Cyan)[profile cross-account]
        role_arn = arn:aws:iam::987654321098:role/CrossAccountRole
        source_profile = my-profile
        external_id = unique-external-id$($PSStyle.Reset)

    Note: Requires AWS CLI installation and proper credential configuration.
    12 AWS functions available for complete credential and profile management.
"@

    $PluginsDocker = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Docker Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Complete Docker CLI integration with PowerShell aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Container Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dcls$($PSStyle.Reset)               - List running containers
        $($PSStyle.Foreground.Magenta)dclsa$($PSStyle.Reset)              - List all containers
        $($PSStyle.Foreground.Magenta)dps$($PSStyle.Reset)                - Show running containers
        $($PSStyle.Foreground.Magenta)dpsa$($PSStyle.Reset)               - Show all containers
        $($PSStyle.Foreground.Magenta)dr$($PSStyle.Reset) <image>         - Run a new container
        $($PSStyle.Foreground.Magenta)drit$($PSStyle.Reset) <image>       - Run interactive container
        $($PSStyle.Foreground.Magenta)dst$($PSStyle.Reset) <container>    - Start a container
        $($PSStyle.Foreground.Magenta)dstp$($PSStyle.Reset) <container>   - Stop a container
        $($PSStyle.Foreground.Magenta)drs$($PSStyle.Reset) <container>    - Restart a container
        $($PSStyle.Foreground.Magenta)drm$($PSStyle.Reset) <container>    - Remove a container
        $($PSStyle.Foreground.Magenta)drm!$($PSStyle.Reset) <container>   - Force remove container
        $($PSStyle.Foreground.Magenta)dsta$($PSStyle.Reset)               - Stop all running containers

    $($PSStyle.Foreground.Green)Image Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dbl$($PSStyle.Reset) <args>         - Build an image
        $($PSStyle.Foreground.Magenta)dib$($PSStyle.Reset) <args>         - Build an image
        $($PSStyle.Foreground.Magenta)dils$($PSStyle.Reset)               - List images
        $($PSStyle.Foreground.Magenta)dirm$($PSStyle.Reset) <image>       - Remove an image
        $($PSStyle.Foreground.Magenta)dit$($PSStyle.Reset) <image> <tag>  - Tag an image
        $($PSStyle.Foreground.Magenta)dipu$($PSStyle.Reset) <image>       - Push an image
        $($PSStyle.Foreground.Magenta)dipru$($PSStyle.Reset)              - Remove unused images
        $($PSStyle.Foreground.Magenta)dpu$($PSStyle.Reset) <image>        - Pull an image

    $($PSStyle.Foreground.Green)Network Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dnc$($PSStyle.Reset) <network>      - Create a network
        $($PSStyle.Foreground.Magenta)dnls$($PSStyle.Reset)               - List networks
        $($PSStyle.Foreground.Magenta)dnrm$($PSStyle.Reset) <network>     - Remove a network
        $($PSStyle.Foreground.Magenta)dncn$($PSStyle.Reset) <net> <cont>  - Connect to network
        $($PSStyle.Foreground.Magenta)dndcn$($PSStyle.Reset) <net> <cont> - Disconnect from network

    $($PSStyle.Foreground.Green)Volume Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dvls$($PSStyle.Reset)               - List volumes
        $($PSStyle.Foreground.Magenta)dvprune$($PSStyle.Reset)            - Remove unused volumes

    $($PSStyle.Foreground.Green)Monitoring & Inspection:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dcin$($PSStyle.Reset) <container>   - Inspect a container
        $($PSStyle.Foreground.Magenta)dii$($PSStyle.Reset) <image>        - Inspect an image
        $($PSStyle.Foreground.Magenta)dni$($PSStyle.Reset) <network>      - Inspect a network
        $($PSStyle.Foreground.Magenta)dvi$($PSStyle.Reset) <volume>       - Inspect a volume
        $($PSStyle.Foreground.Magenta)dlo$($PSStyle.Reset) <container>    - View container logs
        $($PSStyle.Foreground.Magenta)dpo$($PSStyle.Reset) <container>    - Show container ports
        $($PSStyle.Foreground.Magenta)dsts$($PSStyle.Reset)               - Show container stats
        $($PSStyle.Foreground.Magenta)dtop$($PSStyle.Reset) <container>   - Show container processes

    $($PSStyle.Foreground.Green)Execution:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dxc$($PSStyle.Reset) <cont> <cmd>   - Execute command in container
        $($PSStyle.Foreground.Magenta)dxcit$($PSStyle.Reset) <cont> <cmd> - Execute interactive command

    Note: All Docker functions pass arguments directly to Docker CLI.
    37 Docker aliases available for complete container lifecycle management.
"@

    $PluginsDockerCompose = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Docker Compose Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Complete Docker Compose CLI integration with PowerShell aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dco$($PSStyle.Reset) <args>         - Docker Compose base command
        $($PSStyle.Foreground.Magenta)dcb$($PSStyle.Reset) [service]      - Build or rebuild services
        $($PSStyle.Foreground.Magenta)dce$($PSStyle.Reset) <service> <cmd> - Execute commands in containers
        $($PSStyle.Foreground.Magenta)dcps$($PSStyle.Reset)               - List containers
        $($PSStyle.Foreground.Magenta)dcrestart$($PSStyle.Reset) [service] - Restart services
        $($PSStyle.Foreground.Magenta)dcrm$($PSStyle.Reset) [service]     - Remove stopped containers
        $($PSStyle.Foreground.Magenta)dcr$($PSStyle.Reset) <service> <cmd> - Run one-time commands
        $($PSStyle.Foreground.Magenta)dcstop$($PSStyle.Reset) [service]   - Stop services
        $($PSStyle.Foreground.Magenta)dcstart$($PSStyle.Reset) [service]  - Start services
        $($PSStyle.Foreground.Magenta)dck$($PSStyle.Reset) [service]      - Kill running containers

    $($PSStyle.Foreground.Green)Service Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dcup$($PSStyle.Reset) [service]     - Create and start containers
        $($PSStyle.Foreground.Magenta)dcupb$($PSStyle.Reset) [service]    - Create and start with build
        $($PSStyle.Foreground.Magenta)dcupd$($PSStyle.Reset) [service]    - Create and start in detached mode
        $($PSStyle.Foreground.Magenta)dcupdb$($PSStyle.Reset) [service]   - Create and start detached with build
        $($PSStyle.Foreground.Magenta)dcdn$($PSStyle.Reset) [options]     - Stop and remove containers, networks

    $($PSStyle.Foreground.Green)Monitoring & Logs:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dcl$($PSStyle.Reset) [service]      - View container logs
        $($PSStyle.Foreground.Magenta)dclf$($PSStyle.Reset) [service]     - Follow log output
        $($PSStyle.Foreground.Magenta)dclF$($PSStyle.Reset) [service]     - Follow new log entries only

    $($PSStyle.Foreground.Green)Image Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dcpull$($PSStyle.Reset) [service]   - Pull service images

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Start all services in background
        dcupd

        # Build and start web service
        dcupb web

        # Execute bash in web container
        dce web bash

        # Follow logs for all services
        dclf

        # Stop and clean up everything
        dcdn --volumes$($PSStyle.Reset)

    Note: Supports both Docker Compose v1 (docker-compose) and v2 (docker compose).
    20 Docker Compose functions available for complete multi-container management.
"@

    $PluginsHelm = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Helm Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Complete Helm CLI integration with PowerShell aliases for Kubernetes package management$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)h$($PSStyle.Reset) <args>           - Helm base command
        $($PSStyle.Foreground.Magenta)hin$($PSStyle.Reset) <release> <chart> - Install Helm charts
        $($PSStyle.Foreground.Magenta)hun$($PSStyle.Reset) <release>      - Uninstall Helm releases
        $($PSStyle.Foreground.Magenta)hse$($PSStyle.Reset) <query>        - Search for Helm charts
        $($PSStyle.Foreground.Magenta)hup$($PSStyle.Reset) <release> <chart> - Upgrade Helm releases

    $($PSStyle.Foreground.Green)Repository Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Add repositories
        h repo add stable https://charts.helm.sh/stable
        h repo add bitnami https://charts.bitnami.com/bitnami

        # Update repositories
        h repo update

        # List repositories
        h repo list$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Chart Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Search for charts
        hse repo nginx
        hse hub wordpress

        # Install applications
        hin my-nginx stable/nginx
        hin my-app ./my-chart --namespace production

        # Upgrade applications
        hup my-nginx stable/nginx
        hup my-app ./my-chart --install$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Release Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# List releases
        h list
        h list --all-namespaces

        # Get release information
        h get values my-release
        h status my-release

        # Uninstall releases
        hun my-release
        hun my-release --keep-history$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Complete deployment workflow
        h repo add bitnami https://charts.bitnami.com/bitnami
        hse repo wordpress
        hin my-wordpress bitnami/wordpress --namespace production
        h status my-wordpress -n production
        hup my-wordpress bitnami/wordpress -n production$($PSStyle.Reset)

    Note: Includes automatic PowerShell completion for enhanced productivity.
    5 Helm functions available for complete Kubernetes package management.
"@

    $PluginsKubectl = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Kubectl Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive kubectl CLI integration with 100+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)k$($PSStyle.Reset) <args>            - Base kubectl command wrapper
        $($PSStyle.Foreground.Magenta)kca$($PSStyle.Reset) <args>          - Commands against all namespaces
        $($PSStyle.Foreground.Magenta)kaf$($PSStyle.Reset) <file>          - Apply YAML files
        $($PSStyle.Foreground.Magenta)keti$($PSStyle.Reset) <pod>          - Interactive container exec

    $($PSStyle.Foreground.Green)Pod Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# List and manage pods
        kgp                    # Get pods
        kgpa                   # Get all pods in all namespaces
        kgpw                   # Watch pods
        kgpwide                # Get pods with wide output
        kdp my-pod             # Describe pod
        kdelp my-pod           # Delete pod
        keti my-pod            # Interactive exec into pod$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Service & Networking:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Service operations
        kgs                    # Get services
        kgsa                   # Get services in all namespaces
        kds my-service         # Describe service
        kpf svc/my-svc 8080:80 # Port forward to service$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Deployment Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Deployment operations
        kgd                    # Get deployments
        kgda                   # Get deployments in all namespaces
        ksd my-app --replicas=5 # Scale deployment
        krsd my-app            # Rollout status
        kres deployment my-app  # Restart deployment$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Configuration & Context:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Context management
        kcgc                   # List contexts
        kcuc dev-cluster       # Switch context
        kccc                   # Current context
        kcn my-namespace       # Set namespace$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Logging & Monitoring:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# View logs
        kl my-pod              # Get logs
        klf my-pod             # Follow logs
        kl1h my-pod            # Last hour logs
        klf1m my-pod           # Follow logs last minute
        kge                    # Get events
        kgew                   # Watch events$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Resource Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Various resources
        kgcm                   # Get configmaps
        kgsec                  # Get secrets
        kgns                   # Get namespaces
        kga                    # Get all resources
        kgaa                   # Get all in all namespaces$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Complete workflow
        kcgc                               # List contexts
        kcuc production                    # Switch to production
        kgp                               # List pods
        klf my-app-pod                    # Follow logs
        ksd my-app --replicas=3           # Scale application
        kaf deployment.yaml               # Apply configuration$($PSStyle.Reset)

    Note: Includes automatic PowerShell completion and 100+ kubectl commands with aliases.
    Complete kubectl integration for Kubernetes cluster management.
"@

    $PluginsNPM = @"
$($PSStyle.Foreground.Yellow)Plugins Module - NPM Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive npm CLI integration with 35+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)npm$($PSStyle.Reset) <args>          - Base npm command wrapper
        $($PSStyle.Foreground.Magenta)npmg$($PSStyle.Reset) <package>       - Install packages globally
        $($PSStyle.Foreground.Magenta)npmS$($PSStyle.Reset) <package>       - Install and save to dependencies
        $($PSStyle.Foreground.Magenta)npmD$($PSStyle.Reset) <package>       - Install and save to dev-dependencies

    $($PSStyle.Foreground.Green)Package Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Install packages
        npmS express               # Save to dependencies
        npmD jest eslint           # Save to dev-dependencies  
        npmg typescript nodemon    # Install globally
        npmF                       # Force reinstall packages
        
        # Update and maintain
        npmO                       # Check outdated packages
        npmU                       # Update all packages
        npmU express               # Update specific package$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Development Workflow:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Project lifecycle
        npmI                       # Initialize new package
        npmst                      # npm start
        npmt                       # npm test
        npmrd                      # npm run dev
        npmrb                      # npm run build
        npmR lint                  # Run custom scripts$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Information & Discovery:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Package information
        npmV                       # Show npm version
        npmL                       # List installed packages
        npmL0                      # List top-level only
        npmi express               # Get package info
        npmSe react                # Search packages$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Security & Maintenance:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Security and diagnostics
        npma                       # Run security audit
        npmaf                      # Fix vulnerabilities
        npmc clean                 # Clean npm cache
        npmdoc                     # Run npm doctor$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Configuration & Auth:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Registry management
        npmwho                     # Current npm user
        npmlogin                   # Login to registry
        npmlogout                  # Logout from registry
        npmcg registry             # Get config values
        npmcs registry https://... # Set config values$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Complete workflow
        npmI -y                           # Initialize package
        npmS express cors helmet          # Install dependencies
        npmD jest supertest nodemon       # Install dev dependencies
        npmst                            # Start development
        npma && npmaf                    # Security audit and fix
        npmP                             # Publish package$($PSStyle.Reset)

    Note: Includes automatic PowerShell completion and 35+ npm commands with aliases.
    Complete npm integration for Node.js package management.
"@

    $PluginsPIP = @"
$($PSStyle.Foreground.Yellow)Plugins Module - PIP Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive pip CLI integration with 25+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)pip$($PSStyle.Reset) <args>          - Base pip command wrapper
        $($PSStyle.Foreground.Magenta)pipi$($PSStyle.Reset) <package>       - Install Python packages
        $($PSStyle.Foreground.Magenta)pipu$($PSStyle.Reset) <package>       - Upgrade packages to latest
        $($PSStyle.Foreground.Magenta)pipun$($PSStyle.Reset) <package>      - Uninstall Python packages

    $($PSStyle.Foreground.Green)Package Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Install and manage packages
        pipi requests numpy         # Install packages
        pipu package1 package2      # Upgrade packages  
        pipun old-package          # Uninstall packages
        pipiu user-package         # Install for current user
        pipie .                    # Install in editable mode
        
        # Information and discovery
        pipl                       # List installed packages
        piplo                      # List outdated packages
        pips numpy                 # Show package information$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Requirements & Bulk Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Requirements management
        pipreq                     # Create requirements.txt
        pipir                      # Install from requirements.txt
        pipir dev-requirements.txt # Install from custom file
        
        # Bulk operations
        pipupall                   # Upgrade all packages
        pipunall                   # Uninstall all packages (dangerous!)$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)GitHub Integration:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Install from GitHub
        pipig user/repo            # Install from GitHub repo
        pipigb user/repo branch    # Install from specific branch
        pipigp user/repo 123       # Install from pull request$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Advanced Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Advanced pip functionality
        pipck                      # Check dependencies
        pipw package               # Build wheel
        pipd package -d downloads/ # Download without installing
        pipc list                  # Show pip configuration
        pipcc info                 # Cache information$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Complete Python workflow
        python -m venv myproject          # Create virtual environment
        myproject\\Scripts\\Activate.ps1   # Activate environment
        pipi requests flask pytest       # Install packages
        pipreq                           # Create requirements
        pipck                           # Check dependencies
        pipupall                        # Keep packages updated$($PSStyle.Reset)

    Note: Includes automatic PowerShell completion and 25+ pip commands with aliases.
    Complete pip integration for Python package management.
"@

    $PluginsPNPM = @"
$($PSStyle.Foreground.Yellow)Plugins Module - PNPM Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive PNPM CLI integration with 68+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)p$($PSStyle.Reset) <args>             - Base pnpm command wrapper
        $($PSStyle.Foreground.Magenta)pa$($PSStyle.Reset) <package>          - Add packages to dependencies
        $($PSStyle.Foreground.Magenta)pad$($PSStyle.Reset) <package>         - Add packages to dev-dependencies
        $($PSStyle.Foreground.Magenta)pao$($PSStyle.Reset) <package>         - Add packages to optional dependencies
        $($PSStyle.Foreground.Magenta)pap$($PSStyle.Reset) <package>         - Add packages to peer dependencies

    $($PSStyle.Foreground.Green)Package Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Install packages
        pa express cors helmet         # Add to dependencies
        pad jest eslint typescript     # Add to dev-dependencies
        pao fsevents                  # Add to optional dependencies
        pap react vue                 # Add to peer dependencies
        
        # Update and maintain
        pup                           # Update all packages
        pupi                          # Interactive package updates
        prm unused-package            # Remove packages$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Installation & Setup:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Project lifecycle
        pi                            # Install dependencies
        pif                           # Install from frozen lockfile (CI/CD)
        pin                           # Initialize new package.json$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Script Execution:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Run scripts
        pr build                      # Run script from package.json
        ps                            # Run start script
        pd                            # Run dev script
        pb                            # Run build script
        pt                            # Run test script
        ptc                           # Run tests with coverage$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Development Tools:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Code quality
        pln                           # Run lint script
        plnf                          # Run lint with auto-fix
        pf                            # Run format script
        px eslint src/                # Execute from node_modules/.bin
        pdlx create-react-app my-app  # Execute without installing$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Store Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# PNPM store operations
        psts                          # Check store status
        pspr                          # Prune unreferenced packages
        pstp                          # Show store path
        pst status                    # General store management$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Information & Analysis:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Package information
        pls                           # List installed packages
        pout                          # Check outdated packages
        paud                          # Run security audit
        paudf                         # Fix security vulnerabilities
        pw lodash                     # Show why package is installed$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Advanced Features:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# PNPM-specific capabilities
        ppatch lodash@4.17.21         # Create package patch
        ppatchc /tmp/patch-dir        # Commit package patch
        plnk ../local-package         # Link local package
        pfetch                        # Fetch packages to store
        pimp                          # Import from npm lockfile
        pdep dist                     # Deploy for production$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Configuration:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Environment setup
        pcfgl                         # List all configuration
        pcfgs registry https://...     # Set configuration values
        pcfgg store-dir               # Get configuration values
        penv use --global lts         # Manage Node.js versions
        psetup                        # Setup PNPM$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Complete PNPM workflow
        pin                           # Initialize new project
        pa express fastify           # Add production dependencies
        pad jest nodemon typescript   # Add development dependencies
        pi                            # Install all dependencies
        pd                            # Start development server
        paud && paudf                 # Security audit and fix
        psts && pspr                  # Store maintenance$($PSStyle.Reset)

    Note: PNPM provides fast, disk-efficient package management with strict dependency resolution.
    Includes 68+ commands covering all PNPM features with automatic PowerShell completion.
"@

    $PluginsPipenv = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Pipenv Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive pipenv CLI integration with 15+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)pipenv$($PSStyle.Reset) <args>         - Base pipenv command wrapper
        $($PSStyle.Foreground.Magenta)psh$($PSStyle.Reset)                   - Activate pipenv shell
        $($PSStyle.Foreground.Magenta)prun$($PSStyle.Reset) <command>        - Run commands in virtual environment
        $($PSStyle.Foreground.Magenta)pwh$($PSStyle.Reset)                   - Show project directory path
        $($PSStyle.Foreground.Magenta)pvenv$($PSStyle.Reset)                 - Show virtual environment path
        $($PSStyle.Foreground.Magenta)ppy$($PSStyle.Reset)                   - Show Python interpreter path

    $($PSStyle.Foreground.Green)Package Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Install and manage packages
        pi requests flask           # Install packages
        pidev pytest black flake8  # Install development dependencies
        pu old-package              # Uninstall packages
        pupd                        # Update all packages
        pupd requests               # Update specific package$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Dependency Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Lock and sync dependencies
        pl                          # Generate Pipfile.lock
        pl --dev                    # Lock with development dependencies
        psy                         # Install from Pipfile.lock
        psy --dev                   # Sync including dev dependencies
        preq > requirements.txt     # Generate requirements.txt
        preq --dev                  # Generate dev requirements$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Information & Maintenance:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Security and maintenance
        pch                         # Check for vulnerabilities
        pcl                         # Clean unused dependencies
        pgr                         # Show dependency graph
        po requests                 # Open package in editor
        pscr test                   # Run predefined scripts$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Auto-Shell Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Automatic virtual environment activation
        Enable-PipenvAutoShell      # Enable auto-activation
        Disable-PipenvAutoShell     # Disable auto-activation
        Test-PipenvAutoShell        # Check current state
        Invoke-PipenvShellToggle    # Manual toggle$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# New project workflow
        mkdir myproject && cd myproject  # Create and enter directory
        pi --python 3.9                 # Initialize with Python 3.9
        pi requests flask                # Install dependencies  
        pidev pytest black              # Install dev dependencies
        pl                               # Generate lock file
        prun python app.py               # Run application
        
        # Existing project workflow
        cd existing-project              # Auto-activates environment
        psy --dev                        # Install all dependencies
        prun pytest                      # Run tests
        pch                              # Check security
        pcl                              # Clean unused packages$($PSStyle.Reset)

    Note: Includes automatic shell activation/deactivation and 15+ pipenv commands.
    Complete pipenv integration for Python virtual environment management.
"@

    $PluginsPoetry = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Poetry Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive Poetry CLI integration with 30+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)poetry$($PSStyle.Reset) <args>         - Base Poetry command wrapper
        $($PSStyle.Foreground.Magenta)pin$($PSStyle.Reset)                   - Initialize new Poetry project
        $($PSStyle.Foreground.Magenta)pnew$($PSStyle.Reset) <name>           - Create new project with structure
        $($PSStyle.Foreground.Magenta)pch$($PSStyle.Reset)                   - Check project configuration
        $($PSStyle.Foreground.Magenta)pcmd$($PSStyle.Reset)                  - List available packages

    $($PSStyle.Foreground.Green)Dependency Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Add and manage dependencies
        pad requests flask fastapi      # Add production dependencies
        pad pytest black --group dev    # Add development dependencies
        prm old-package                 # Remove dependencies
        pup                            # Update all dependencies
        pup requests                   # Update specific package
        
        # Installation and synchronization
        pinst                          # Install all dependencies
        pinst --no-dev                 # Install without dev dependencies
        psync                          # Sync environment with lock file$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Environment Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Virtual environment operations
        psh                            # Activate Poetry shell
        prun python app.py             # Run commands in environment
        pvinf                          # Show environment information
        ppath                          # Show environment path
        pvu python3.9                  # Use specific Python version
        pvrm python3.9                 # Remove virtual environment$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Build and Publishing:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Project distribution
        pbld                           # Build project packages
        pbld --format wheel            # Build specific format
        ppub                           # Publish to PyPI
        ppub --repository testpypi     # Publish to test PyPI
        ppub --build                   # Build and publish together$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Lock File and Export:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Dependency locking and export
        plck                           # Update lock file
        plck --no-update               # Lock without updating
        pexp                           # Export to requirements.txt
        pexp --dev -o dev-requirements.txt  # Export dev dependencies$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Information and Discovery:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Package information
        pshw                           # Show all installed packages
        pshw requests                  # Show specific package info
        pslt                           # Show latest package versions
        ptree                          # Show dependency tree
        ptree --no-dev                 # Tree without dev dependencies$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Configuration and Self-Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Poetry configuration
        pconf                          # Show all configuration
        pconf virtualenvs.in-project true  # Enable in-project venvs
        pvoff                          # Disable venv creation
        
        # Poetry self-management
        psup                           # Update Poetry itself
        psad poetry-plugin-export      # Add Poetry plugins
        pplug                          # Show installed plugins$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# New project workflow
        pnew myproject                 # Create new project
        cd myproject                   # Enter project directory
        pad fastapi uvicorn           # Add dependencies
        pad pytest black --group dev  # Add dev dependencies
        prun python app.py            # Run application
        
        # Existing project workflow
        cd existing-poetry-project     # Enter project
        pinst                         # Install dependencies
        prun pytest                   # Run tests
        pbld && ppub                  # Build and publish$($PSStyle.Reset)

    Note: Includes comprehensive Poetry CLI integration and 30+ poetry commands.
    Complete Poetry integration for modern Python dependency management.
"@

    $PluginsTerraform = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Terraform Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive Terraform CLI integration with 20+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)tf$($PSStyle.Reset) <args>             - Base Terraform command wrapper
        $($PSStyle.Foreground.Magenta)tfi$($PSStyle.Reset)                   - Initialize working directory
        $($PSStyle.Foreground.Magenta)tfp$($PSStyle.Reset)                   - Create execution plan
        $($PSStyle.Foreground.Magenta)tfa$($PSStyle.Reset)                   - Apply configuration
        $($PSStyle.Foreground.Magenta)tfd$($PSStyle.Reset)                   - Destroy infrastructure

    $($PSStyle.Foreground.Green)Initialization Variants:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Initialize with different options
        tfi                            # Standard initialization
        tfir                           # Init with reconfiguration
        tfiu                           # Init with provider upgrade
        tfiur                          # Init with upgrade and reconfig$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Plan and Apply Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Planning and deployment
        tfp                            # Create execution plan
        tfp -out=tfplan                # Save plan to file
        tfa                            # Apply with confirmation
        tfaa                           # Apply with auto-approval
        tfa tfplan                     # Apply saved plan$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Destruction Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Infrastructure destruction
        tfd                            # Destroy with confirmation
        tfd!                           # Destroy with auto-approval
        tfd -target=resource.name      # Destroy specific resource$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Code Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Code formatting and validation
        tff                            # Format configuration files
        tffr                           # Format recursively
        tfv                            # Validate configuration
        tft                            # Execute tests$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)State Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# State operations
        tfs list                       # List resources in state
        tfs show resource.name         # Show specific resource
        tfs mv old.name new.name       # Move resource in state
        tfs rm resource.name           # Remove from state$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Output and Information:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Information retrieval
        tfo                            # Show all outputs
        tfo output_name                # Show specific output
        tfsh                           # Show current state
        tfsh tfplan                    # Show saved plan$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Interactive Tools:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Interactive exploration
        tfc                            # Launch Terraform console$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Workspace Integration:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Workspace awareness for prompts
        Get-TerraformWorkspace         # Get current workspace
        Get-TerraformPromptInfo        # Get workspace for prompt
        Get-TerraformVersionPromptInfo # Get version for prompt$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Examples:$($PSStyle.Reset)
        $($PSStyle.Foreground.Cyan)# Complete infrastructure workflow
        tfi                            # Initialize Terraform
        tff && tfv                     # Format and validate
        tfp -out=plan.tf               # Create execution plan
        tfa plan.tf                    # Apply the plan
        tfo                            # Check outputs
        
        # State management workflow
        tfs list                       # List all resources
        tfs show aws_instance.web      # Inspect specific resource
        tfsh -json > state.json        # Export state as JSON
        
        # Destruction workflow
        tfp -destroy                   # Plan destruction
        tfd!                           # Destroy with auto-approval$($PSStyle.Reset)

    Note: Includes comprehensive Terraform CLI integration and 20+ terraform commands.
    Complete Terraform integration for Infrastructure as Code management.
"@

    $PluginsTerragrunt = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Terragrunt Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive Terragrunt CLI integration with 25+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)tg$($PSStyle.Reset) <args>             - Base Terragrunt command wrapper
        $($PSStyle.Foreground.Magenta)tgi$($PSStyle.Reset)                   - terragrunt init
        $($PSStyle.Foreground.Magenta)tgp$($PSStyle.Reset)                   - terragrunt plan
        $($PSStyle.Foreground.Magenta)tga$($PSStyle.Reset)                   - terragrunt apply
        $($PSStyle.Foreground.Magenta)tgd$($PSStyle.Reset)                   - terragrunt destroy
        $($PSStyle.Foreground.Magenta)tgr$($PSStyle.Reset)                   - terragrunt refresh
        $($PSStyle.Foreground.Magenta)tgf$($PSStyle.Reset) / $($PSStyle.Foreground.Magenta)tgfmt$($PSStyle.Reset)          - terragrunt hclfmt
        $($PSStyle.Foreground.Magenta)tgv$($PSStyle.Reset)                   - terragrunt validate

    $($PSStyle.Foreground.Green)Multi-Module Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)tgpa$($PSStyle.Reset)                  - terragrunt plan-all
        $($PSStyle.Foreground.Magenta)tgaa$($PSStyle.Reset)                  - terragrunt apply-all
        $($PSStyle.Foreground.Magenta)tgda$($PSStyle.Reset)                  - terragrunt destroy-all
        $($PSStyle.Foreground.Magenta)tgra$($PSStyle.Reset)                  - terragrunt refresh-all
        $($PSStyle.Foreground.Magenta)tgva$($PSStyle.Reset)                  - terragrunt validate-all

    $($PSStyle.Foreground.Green)State Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)tgsl$($PSStyle.Reset)                  - terragrunt state list
        $($PSStyle.Foreground.Magenta)tgss$($PSStyle.Reset) <resource>       - terragrunt state show <resource>
        $($PSStyle.Foreground.Magenta)tgsm$($PSStyle.Reset) <src> <dest>     - terragrunt state mv <src> <dest>
        $($PSStyle.Foreground.Magenta)tgsr$($PSStyle.Reset) <resource>       - terragrunt state rm <resource>
        $($PSStyle.Foreground.Magenta)tgsh$($PSStyle.Reset)                  - terragrunt show

    $($PSStyle.Foreground.Green)Dependency Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)tggo$($PSStyle.Reset)                  - terragrunt output-all
        $($PSStyle.Foreground.Magenta)tgomg$($PSStyle.Reset)                 - terragrunt output-module-groups
        $($PSStyle.Foreground.Magenta)tggd$($PSStyle.Reset)                  - terragrunt graph-dependencies
        $($PSStyle.Foreground.Magenta)tgrj$($PSStyle.Reset)                  - terragrunt render-json

    $($PSStyle.Foreground.Green)Utility Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)tgvi$($PSStyle.Reset)                  - terragrunt validate-inputs
        $($PSStyle.Foreground.Magenta)tgpv$($PSStyle.Reset)                  - terragrunt providers
        $($PSStyle.Foreground.Magenta)tgget$($PSStyle.Reset)                 - terragrunt get
        $($PSStyle.Foreground.Magenta)tgver$($PSStyle.Reset)                 - terragrunt --version
        $($PSStyle.Foreground.Magenta)tgifm$($PSStyle.Reset) <source>        - terragrunt init-from-module <source>

    $($PSStyle.Foreground.Green)Workspace Functions:$($PSStyle.Reset)
        Get-TerragruntWorkingDir       # Get Terragrunt working directory
        Get-TerragruntConfigPath       # Get path to terragrunt.hcl
        Get-TerragruntCacheDir         # Get cache directory path

    $($PSStyle.Foreground.Green)Example Workflows:$($PSStyle.Reset)
        # Initialize and plan single module
        tgi && tgp

        # Apply all modules in dependency order
        tgaa --terragrunt-parallelism 3

        # Format and validate all configurations
        tgf && tgva

        # Generate dependency graph and render JSON
        tggd && tgrj

        # State management operations
        tgsl                           # List all resources
        tgss aws_instance.web          # Show specific resource
        tgsm old_name new_name         # Move resource

    Note: Includes comprehensive Terragrunt CLI integration and 25+ terragrunt commands.
    Complete DRY Infrastructure as Code workflow with dependency management.
"@

    $PluginsUV = @"
$($PSStyle.Foreground.Yellow)Plugins Module - UV Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive UV (Python package manager) CLI integration with 25+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)uv$($PSStyle.Reset) <args>             - Base UV command wrapper
        $($PSStyle.Foreground.Magenta)uva$($PSStyle.Reset) <packages>        - uv add <packages>
        $($PSStyle.Foreground.Magenta)uvrm$($PSStyle.Reset) <packages>       - uv remove <packages>
        $($PSStyle.Foreground.Magenta)uvs$($PSStyle.Reset)                   - uv sync
        $($PSStyle.Foreground.Magenta)uvr$($PSStyle.Reset) <command>         - uv run <command>
        $($PSStyle.Foreground.Magenta)uvi$($PSStyle.Reset) [project]         - uv init [project]

    $($PSStyle.Foreground.Green)Dependency Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)uvl$($PSStyle.Reset)                   - uv lock
        $($PSStyle.Foreground.Magenta)uvlr$($PSStyle.Reset)                  - uv lock --refresh
        $($PSStyle.Foreground.Magenta)uvlu$($PSStyle.Reset)                  - uv lock --upgrade
        $($PSStyle.Foreground.Magenta)uvsr$($PSStyle.Reset)                  - uv sync --refresh
        $($PSStyle.Foreground.Magenta)uvsu$($PSStyle.Reset)                  - uv sync --upgrade
        $($PSStyle.Foreground.Magenta)uvexp$($PSStyle.Reset)                 - uv export (requirements.txt)

    $($PSStyle.Foreground.Green)Python and Environment:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)uvpy$($PSStyle.Reset) <args>           - uv python <args>
        $($PSStyle.Foreground.Magenta)uvp$($PSStyle.Reset) <args>            - uv pip <args>
        $($PSStyle.Foreground.Magenta)uvv$($PSStyle.Reset) [name]            - uv venv [name]

    $($PSStyle.Foreground.Green)Tool Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)uvt$($PSStyle.Reset) <args>            - uv tool <args>
        $($PSStyle.Foreground.Magenta)uvx$($PSStyle.Reset) / $($PSStyle.Foreground.Magenta)uvtr$($PSStyle.Reset) <tool>       - uv tool run <tool> (uvx)
        $($PSStyle.Foreground.Magenta)uvti$($PSStyle.Reset) <tools>          - uv tool install <tools>
        $($PSStyle.Foreground.Magenta)uvtu$($PSStyle.Reset) <tools>          - uv tool uninstall <tools>
        $($PSStyle.Foreground.Magenta)uvtl$($PSStyle.Reset)                  - uv tool list
        $($PSStyle.Foreground.Magenta)uvtup$($PSStyle.Reset) [tools]         - uv tool upgrade [tools]

    $($PSStyle.Foreground.Green)Project Lifecycle:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)uvb$($PSStyle.Reset)                   - uv build
        $($PSStyle.Foreground.Magenta)uvpub$($PSStyle.Reset)                 - uv publish

    $($PSStyle.Foreground.Green)Utility Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)uvup$($PSStyle.Reset)                  - uv self update
        $($PSStyle.Foreground.Magenta)uvver$($PSStyle.Reset)                 - uv --version

    $($PSStyle.Foreground.Green)Project Functions:$($PSStyle.Reset)
        Test-UVProject             # Check if UV project
        Get-UVProjectInfo          # Get project information
        Get-UVVirtualEnvPath       # Get virtual environment path

    $($PSStyle.Foreground.Green)Example Workflows:$($PSStyle.Reset)
        # Initialize and setup new project
        uvi myproject && cd myproject
        uva requests flask pytest --dev

        # Daily development workflow
        uva pandas                 # Add dependency
        uvr pytest               # Run tests
        uvx black .              # Format code

        # Tool management
        uvti black flake8 mypy   # Install tools
        uvx black .              # Run formatter
        uvx flake8 src/          # Run linter

        # Environment management
        uvv                      # Create virtual env
        uvs                      # Sync dependencies
        uvexp                    # Export requirements

    Note: Includes comprehensive UV CLI integration and 25+ UV commands.
    Complete modern Python package management with dependency resolution.
"@

    $PluginsYarn = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Yarn Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive Yarn CLI integration with 40+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)y$($PSStyle.Reset) <args>              - yarn <args> (base wrapper)
        $($PSStyle.Foreground.Magenta)ya$($PSStyle.Reset) <packages>         - yarn add <packages>
        $($PSStyle.Foreground.Magenta)yad$($PSStyle.Reset) <packages>        - yarn add --dev <packages>
        $($PSStyle.Foreground.Magenta)yap$($PSStyle.Reset) <packages>        - yarn add --peer <packages>
        $($PSStyle.Foreground.Magenta)yrm$($PSStyle.Reset) <packages>        - yarn remove <packages>
        $($PSStyle.Foreground.Magenta)yup$($PSStyle.Reset) [packages]        - yarn upgrade [packages]

    $($PSStyle.Foreground.Green)Installation:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yin$($PSStyle.Reset)                   - yarn install
        $($PSStyle.Foreground.Magenta)yii$($PSStyle.Reset)                   - yarn install --immutable (Berry) / --frozen-lockfile (Classic)
        $($PSStyle.Foreground.Magenta)yifl$($PSStyle.Reset)                  - yarn install --frozen-lockfile (alias for yii)

    $($PSStyle.Foreground.Green)Development Scripts:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yi$($PSStyle.Reset) [args]             - yarn init [args]
        $($PSStyle.Foreground.Magenta)yrun$($PSStyle.Reset) <script>         - yarn run <script>
        $($PSStyle.Foreground.Magenta)yst$($PSStyle.Reset) [args]            - yarn start [args]
        $($PSStyle.Foreground.Magenta)yd$($PSStyle.Reset) [args]             - yarn dev [args]
        $($PSStyle.Foreground.Magenta)yb$($PSStyle.Reset) [args]             - yarn build [args]
        $($PSStyle.Foreground.Magenta)ys$($PSStyle.Reset) [args]             - yarn serve [args]
        $($PSStyle.Foreground.Magenta)yt$($PSStyle.Reset) [args]             - yarn test [args]
        $($PSStyle.Foreground.Magenta)ytc$($PSStyle.Reset) [args]            - yarn test --coverage [args]

    $($PSStyle.Foreground.Green)Code Quality:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yln$($PSStyle.Reset) [args]            - yarn lint [args]
        $($PSStyle.Foreground.Magenta)ylnf$($PSStyle.Reset) [args]           - yarn lint --fix [args]
        $($PSStyle.Foreground.Magenta)yf$($PSStyle.Reset) [args]             - yarn format [args]

    $($PSStyle.Foreground.Green)Workspace Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yw$($PSStyle.Reset) <workspace> <cmd>  - yarn workspace <workspace> <cmd>
        $($PSStyle.Foreground.Magenta)yws$($PSStyle.Reset) <args>            - yarn workspaces <args>

    $($PSStyle.Foreground.Green)Information & Utility:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yy$($PSStyle.Reset) <package>          - yarn why <package>
        $($PSStyle.Foreground.Magenta)yv$($PSStyle.Reset) [version]          - yarn version [version]
        $($PSStyle.Foreground.Magenta)yh$($PSStyle.Reset) [command]          - yarn help [command]
        $($PSStyle.Foreground.Magenta)yp$($PSStyle.Reset) [args]             - yarn pack [args]
        $($PSStyle.Foreground.Magenta)ycc$($PSStyle.Reset)                   - yarn cache clean

    $($PSStyle.Foreground.Green)Berry-Specific (Yarn 2+):$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)ydlx$($PSStyle.Reset) <package> [args] - yarn dlx <package> [args]
        $($PSStyle.Foreground.Magenta)yn$($PSStyle.Reset) [args]             - yarn node [args]

    $($PSStyle.Foreground.Green)Classic-Specific (Yarn 1.x):$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yga$($PSStyle.Reset) <packages>        - yarn global add <packages>
        $($PSStyle.Foreground.Magenta)ygls$($PSStyle.Reset) [args]           - yarn global list [args]
        $($PSStyle.Foreground.Magenta)ygrm$($PSStyle.Reset) <packages>       - yarn global remove <packages>
        $($PSStyle.Foreground.Magenta)ygu$($PSStyle.Reset) [packages]        - yarn global upgrade [packages]
        $($PSStyle.Foreground.Magenta)yls$($PSStyle.Reset) [args]            - yarn list [args]
        $($PSStyle.Foreground.Magenta)yout$($PSStyle.Reset) [args]           - yarn outdated [args]
        $($PSStyle.Foreground.Magenta)yuca$($PSStyle.Reset)                  - yarn global upgrade && yarn cache clean

    $($PSStyle.Foreground.Green)Interactive Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)yui$($PSStyle.Reset) [args]            - yarn upgrade-interactive [args]
        $($PSStyle.Foreground.Magenta)yuil$($PSStyle.Reset) [args]           - yarn upgrade-interactive --latest [args] (Classic only)

    $($PSStyle.Foreground.Green)Utility Functions:$($PSStyle.Reset)
        Test-YarnInstalled         # Check if Yarn is available
        Test-YarnBerry             # Check if using Yarn Berry (v2+)
        Get-YarnVersion           # Get installed Yarn version
        Get-YarnGlobalPath        # Get global bin directory path

    $($PSStyle.Foreground.Green)Example Workflows:$($PSStyle.Reset)
        # Initialize and setup new project
        yi -y                    # Initialize with defaults
        ya react typescript      # Add dependencies
        yad jest @types/jest    # Add dev dependencies

        # Daily development workflow
        yin                      # Install dependencies
        yd                       # Start development server
        yt --watch              # Run tests in watch mode
        yb                      # Build for production

        # Workspace operations (monorepo)
        yw frontend build       # Build frontend workspace
        yws foreach run test   # Test all workspaces

        # Maintenance operations
        yui                     # Interactive upgrade
        ycc                     # Clean cache

    Note: Includes comprehensive Yarn CLI integration and 40+ yarn commands.
    Supports both Classic (v1.x) and Berry (v2+) with automatic version detection.
"@

    $PluginsDeno = @"
$($PSStyle.Foreground.Yellow)Plugins Module - Deno Plugin$($PSStyle.Reset)
    $($PSStyle.Foreground.Cyan)Comprehensive Deno CLI integration with 25+ PowerShell functions and aliases$($PSStyle.Reset)

    $($PSStyle.Foreground.Green)Core Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)d$($PSStyle.Reset) <args>              - deno <args> (base wrapper)
        $($PSStyle.Foreground.Magenta)dh$($PSStyle.Reset) [command]          - deno help [command]

    $($PSStyle.Foreground.Green)Bundle and Compile:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)db$($PSStyle.Reset) <source> [output]  - deno bundle <source> [output]
        $($PSStyle.Foreground.Magenta)dc$($PSStyle.Reset) <args>             - deno compile <args>

    $($PSStyle.Foreground.Green)Development Workflow:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dca$($PSStyle.Reset) <files>           - deno cache <files>
        $($PSStyle.Foreground.Magenta)dfmt$($PSStyle.Reset) [paths]          - deno fmt [paths]
        $($PSStyle.Foreground.Magenta)dli$($PSStyle.Reset) [paths]           - deno lint [paths]

    $($PSStyle.Foreground.Green)Run Operations:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)drn$($PSStyle.Reset) <script> [args]   - deno run <script> [args]
        $($PSStyle.Foreground.Magenta)drA$($PSStyle.Reset) <script> [args]   - deno run -A <script> [args] (all permissions)
        $($PSStyle.Foreground.Magenta)drw$($PSStyle.Reset) <script> [args]   - deno run --watch <script> [args]
        $($PSStyle.Foreground.Magenta)dru$($PSStyle.Reset) <script> [args]   - deno run --unstable <script> [args]

    $($PSStyle.Foreground.Green)Test and Quality:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dts$($PSStyle.Reset) [args]            - deno test [args]
        $($PSStyle.Foreground.Magenta)dch$($PSStyle.Reset) <files>           - deno check <files>

    $($PSStyle.Foreground.Green)Utility Commands:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dup$($PSStyle.Reset) [args]            - deno upgrade [args]
        $($PSStyle.Foreground.Magenta)di$($PSStyle.Reset) <args>             - deno install <args>
        $($PSStyle.Foreground.Magenta)dun$($PSStyle.Reset) <name>            - deno uninstall <name>
        $($PSStyle.Foreground.Magenta)dinf$($PSStyle.Reset) [module]         - deno info [module]

    $($PSStyle.Foreground.Green)Interactive and Documentation:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)de$($PSStyle.Reset) <code>             - deno eval <code>
        $($PSStyle.Foreground.Magenta)dr$($PSStyle.Reset) [args]             - deno repl [args]
        $($PSStyle.Foreground.Magenta)ddoc$($PSStyle.Reset) [module]         - deno doc [module]
        $($PSStyle.Foreground.Magenta)dt$($PSStyle.Reset) [args]             - deno types [args]

    $($PSStyle.Foreground.Green)Project Management:$($PSStyle.Reset)
        $($PSStyle.Foreground.Magenta)dinit$($PSStyle.Reset) [project]       - deno init [project]
        $($PSStyle.Foreground.Magenta)dtask$($PSStyle.Reset) <task> [args]   - deno task <task> [args]
        $($PSStyle.Foreground.Magenta)dsv$($PSStyle.Reset) <script> [args]   - deno serve <script> [args]
        $($PSStyle.Foreground.Magenta)dpub$($PSStyle.Reset) [args]           - deno publish [args]

    $($PSStyle.Foreground.Green)Utility Functions:$($PSStyle.Reset)
        Test-DenoInstalled        # Check if Deno is available
        Get-DenoVersion          # Get installed Deno version
        Initialize-DenoCompletion # Setup tab completion

    $($PSStyle.Foreground.Green)Example Workflows:$($PSStyle.Reset)
        # Initialize and develop new project
        dinit my-deno-app        # Initialize project
        dfmt && dli             # Format and lint
        drw main.ts             # Run in watch mode

        # Bundle and compile workflow
        db src/main.ts bundle.js # Bundle for distribution
        dc --output=app main.ts  # Compile to executable

        # Testing and quality workflow
        dts --coverage          # Run tests with coverage
        dch src/*.ts           # Type check files
        dfmt && dli --fix      # Format and fix linting

        # Runtime operations
        drA server.ts          # Run with all permissions
        de 'console.log("Hi")' # Evaluate expression
        dr --unstable          # Interactive REPL

    Note: Includes comprehensive Deno CLI integration and 25+ deno commands.
    Complete TypeScript/JavaScript runtime with modern development tools.
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
        'AWS' {
            Write-Host $Title
            Write-Host $PluginsAWS
        }
        'Deno' {
            Write-Host $Title
            Write-Host $PluginsDeno
        }
        'Directory' {
            Write-Host $Title
            Write-Host $Directory
        }
        'Docker' {
            Write-Host $Title
            Write-Host $PluginsDocker
        }
        'DockerCompose' {
            Write-Host $Title
            Write-Host $PluginsDockerCompose
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
        'Helm' {
            Write-Host $Title
            Write-Host $PluginsHelm
        }
        'Kubectl' {
            Write-Host $Title
            Write-Host $PluginsKubectl
        }
        'Logging' {
            Write-Host $Title
            Write-Host $Logging
        }
        'NPM' {
            Write-Host $Title
            Write-Host $PluginsNPM
        }
        'Network' {
            Write-Host $Title
            Write-Host $Network
        }
        'PIP' {
            Write-Host $Title
            Write-Host $PluginsPIP
        }
        'Pipenv' {
            Write-Host $Title
            Write-Host $PluginsPipenv
        }
        'PNPM' {
            Write-Host $Title
            Write-Host $PluginsPNPM
        }
        'Plugins' {
            Write-Host $Title
            Write-Host $Plugins
        }
        'Poetry' {
            Write-Host $Title
            Write-Host $PluginsPoetry
        }
        'Process' {
            Write-Host $Title
            Write-Host $Process
        }
        'Starship' {
            Write-Host $Title
            Write-Host $Starship
        }
        'Terraform' {
            Write-Host $Title
            Write-Host $PluginsTerraform
        }
        'Terragrunt' {
            Write-Host $Title
            Write-Host $PluginsTerragrunt
        }
        'UV' {
            Write-Host $Title
            Write-Host $PluginsUV
        }
        'Update' {
            Write-Host $Title
            Write-Host $Update
        }
        'Utility' {
            Write-Host $Title
            Write-Host $Utility
        }
        'Yarn' {
            Write-Host $Title
            Write-Host $PluginsYarn
        }
        default {
            Write-Host $Title
            Write-Host $Docs
        }
    }
}

