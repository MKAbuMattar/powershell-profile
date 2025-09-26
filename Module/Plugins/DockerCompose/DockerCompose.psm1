#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Docker Compose Plugin
#
# Description:
#       This module provides Docker Compose CLI shortcuts and utility functions for improved
#       Docker Compose workflow in PowerShell environments.
#
# Author: Mohammad Abu Mattar
# Created: 2025-09-26
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

# Determine the correct Docker Compose command to use
$script:DockerComposeCommand = $null

function Get-DockerComposeCommand {
    <#
    .SYNOPSIS
        A PowerShell function that determines the correct Docker Compose command to use.

    .DESCRIPTION
        This function checks whether to use 'docker-compose' (standalone) or 'docker compose' (CLI plugin).
        It tests that the docker-compose command is in PATH and resolves to an existing executable file.
        This supports both Compose v1 (standalone) and Compose v2 (CLI plugin).

    .INPUTS
        None. This function does not accept any input.

    .OUTPUTS
        System.String. Returns either 'docker-compose' or 'docker compose' depending on availability.

    .EXAMPLE
        Get-DockerComposeCommand
        Returns the appropriate Docker Compose command for the current system.

    .NOTES
        - Prefers 'docker-compose' (v1 standalone) if available for backward compatibility.
        - Falls back to 'docker compose' (v2 CLI plugin) if standalone version is not found.
        - This function is called internally by all Docker Compose wrapper functions.
    #>
    if ($null -eq $script:DockerComposeCommand) {
        # Test if docker-compose (standalone) is available
        if (Get-Command 'docker-compose' -ErrorAction SilentlyContinue) {
            $script:DockerComposeCommand = 'docker-compose'
        }
        else {
            # Fall back to docker compose (CLI plugin)
            $script:DockerComposeCommand = 'docker compose'
        }
    }
    return $script:DockerComposeCommand
}

# Docker Compose base command
function Invoke-DockerCompose {
    <#
    .SYNOPSIS
        A PowerShell function that wraps the Docker Compose command.

    .DESCRIPTION
        This function provides a direct wrapper for Docker Compose commands, automatically selecting
        between 'docker-compose' (standalone) and 'docker compose' (CLI plugin) based on availability.
        It passes all arguments directly to the Docker Compose command.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function executes Docker Compose commands but does not return objects.

    .EXAMPLE
        dco --version
        Shows the Docker Compose version using the appropriate command.

        Invoke-DockerCompose --help
        Displays Docker Compose help using the full function name.

        dco -f docker-compose.yml -f docker-compose.override.yml config
        Uses multiple compose files to show the configuration.

    .NOTES
        - Automatically detects whether to use docker-compose or docker compose.
        - All Docker Compose arguments and options are supported.
        - This is the base function that other Docker Compose functions build upon.
    #>
    [Alias("dco")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    if ($Arguments) {
        & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] $Arguments
    }
    else {
        & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length]
    }
}

# Docker Compose build
function Invoke-DockerComposeBuild {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose build`.

    .DESCRIPTION
        This function builds or rebuilds Docker Compose services. It's equivalent to running
        'docker-compose build' or 'docker compose build' depending on the available version.
        All arguments are passed directly to the Docker Compose build command.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose build command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function executes Docker Compose build but does not return objects.

    .EXAMPLE
        dcb
        Builds all services defined in docker-compose.yml.

        Invoke-DockerComposeBuild web
        Builds only the 'web' service using the full function name.

        dcb --no-cache
        Builds all services without using cache.

    .NOTES
        - Requires Docker Compose to be installed and accessible via PATH.
        - Must be run in a directory containing a docker-compose.yml file.
        - Supports all docker-compose build options and arguments.
    #>
    [Alias("dcb")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'build' $Arguments
}

# Docker Compose exec
function Invoke-DockerComposeExec {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose exec`.

    .DESCRIPTION
        This function executes commands in running Docker Compose services. It's equivalent to running
        'docker-compose exec' or 'docker compose exec' depending on the available version.
        This is useful for running commands inside already running containers.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose exec command, including service name and command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function executes commands in containers but does not return objects.

    .EXAMPLE
        dce web bash
        Opens a bash shell in the running 'web' service container.

        Invoke-DockerComposeExec db psql -U postgres
        Connects to PostgreSQL in the 'db' service using the full function name.

        dce -it web /bin/sh
        Opens an interactive shell in the 'web' service with TTY allocation.

    .NOTES
        - Requires Docker Compose services to be running.
        - The specified service must be running for exec to work.
        - Supports all docker-compose exec options like -it, -e, --user, etc.
    #>
    [Alias("dce")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'exec' $Arguments
}

# Docker Compose ps
function Invoke-DockerComposePs {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose ps`.

    .DESCRIPTION
        This function lists containers for Docker Compose services. It's equivalent to running
        'docker-compose ps' or 'docker compose ps' depending on the available version.
        Shows the status of all services defined in the compose file.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose ps command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function displays container information but does not return objects.

    .EXAMPLE
        dcps
        Lists all Docker Compose service containers and their status.

        Invoke-DockerComposePs web
        Shows status for only the 'web' service using the full function name.

        dcps -a
        Lists all containers including stopped ones.

    .NOTES
        - Shows containers created by Docker Compose for the current project.
        - Displays container names, status, ports, and other information.
        - Must be run in a directory with a docker-compose.yml file.
    #>
    [Alias("dcps")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'ps' $Arguments
}

# Docker Compose restart
function Invoke-DockerComposeRestart {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose restart`.

    .DESCRIPTION
        This function restarts Docker Compose services. It's equivalent to running
        'docker-compose restart' or 'docker compose restart' depending on the available version.
        Stops and starts the specified services or all services if none specified.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose restart command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function restarts services but does not return objects.

    .EXAMPLE
        dcrestart
        Restarts all Docker Compose services.

        Invoke-DockerComposeRestart web
        Restarts only the 'web' service using the full function name.

        dcrestart web db
        Restarts both 'web' and 'db' services.

    .NOTES
        - Restarts running services by stopping and starting them.
        - Services must be running to be restarted.
        - Preserves container configuration and volumes.
    #>
    [Alias("dcrestart")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'restart' $Arguments
}

# Docker Compose rm
function Invoke-DockerComposeRemove {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose rm`.

    .DESCRIPTION
        This function removes stopped Docker Compose service containers. It's equivalent to running
        'docker-compose rm' or 'docker compose rm' depending on the available version.
        Only removes containers that are currently stopped.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose rm command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function removes containers but does not return objects.

    .EXAMPLE
        dcrm
        Removes all stopped Docker Compose service containers.

        Invoke-DockerComposeRemove web
        Removes only the stopped 'web' service container using the full function name.

        dcrm -f
        Forces removal without confirmation prompt.

    .NOTES
        - Only removes stopped containers, not running ones.
        - Use -f flag to skip confirmation prompt.
        - Does not remove volumes or networks by default.
    #>
    [Alias("dcrm")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'rm' $Arguments
}

# Docker Compose run
function Invoke-DockerComposeRun {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose run`.

    .DESCRIPTION
        This function runs a one-time command against a Docker Compose service. It's equivalent to running
        'docker-compose run' or 'docker compose run' depending on the available version.
        Creates and runs a new container for the specified service.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose run command, including service name and command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function runs commands in new containers but does not return objects.

    .EXAMPLE
        dcr web bash
        Runs a bash shell in a new 'web' service container.

        Invoke-DockerComposeRun --rm web python manage.py migrate
        Runs a Django migration in a new container and removes it afterward.

        dcr -p 8080:8080 web
        Runs the 'web' service with port mapping.

    .NOTES
        - Creates a new container each time it's run.
        - Does not automatically remove containers unless --rm is specified.
        - Use --rm flag to automatically remove containers after execution.
        - Supports all docker-compose run options and flags.
    #>
    [Alias("dcr")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'run' $Arguments
}

# Docker Compose stop
function Invoke-DockerComposeStop {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose stop`.

    .DESCRIPTION
        This function stops running Docker Compose services. It's equivalent to running
        'docker-compose stop' or 'docker compose stop' depending on the available version.
        Gracefully stops containers without removing them.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose stop command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function stops services but does not return objects.

    .EXAMPLE
        dcstop
        Stops all running Docker Compose services.

        Invoke-DockerComposeStop web
        Stops only the 'web' service using the full function name.

        dcstop -t 30 web
        Stops the 'web' service with a 30-second timeout.

    .NOTES
        - Gracefully stops containers by sending SIGTERM followed by SIGKILL after timeout.
        - Does not remove containers, only stops them.
        - Default timeout is 10 seconds, can be customized with -t flag.
    #>
    [Alias("dcstop")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'stop' $Arguments
}

# Docker Compose up
function Invoke-DockerComposeUp {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose up`.

    .DESCRIPTION
        This function creates and starts Docker Compose services. It's equivalent to running
        'docker-compose up' or 'docker compose up' depending on the available version.
        Builds, creates, starts, and attaches to containers for all services.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose up command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function starts services but does not return objects.

    .EXAMPLE
        dcup
        Starts all Docker Compose services in foreground mode.

        Invoke-DockerComposeUp -d
        Starts all services in detached mode using the full function name.

        dcup web db
        Starts only the 'web' and 'db' services.

    .NOTES
        - Creates containers if they don't exist.
        - Starts containers and shows logs in foreground by default.
        - Use -d flag to run in detached mode (background).
        - Builds images if they don't exist (unless --no-build is specified).
    #>
    [Alias("dcup")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'up' $Arguments
}

# Docker Compose up --build
function Invoke-DockerComposeUpBuild {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose up --build`.

    .DESCRIPTION
        This function creates and starts Docker Compose services with forced image building.
        It's equivalent to running 'docker-compose up --build' or 'docker compose up --build'
        depending on the available version. Always rebuilds images before starting services.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose up --build command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function builds and starts services but does not return objects.

    .EXAMPLE
        dcupb
        Rebuilds images and starts all Docker Compose services.

        Invoke-DockerComposeUpBuild -d
        Rebuilds images and starts services in detached mode.

        dcupb web
        Rebuilds and starts only the 'web' service.

    .NOTES
        - Forces rebuilding of images even if they already exist.
        - Useful when you've made changes to Dockerfiles or build context.
        - Combines image building and service startup in one command.
    #>
    [Alias("dcupb")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'up' '--build' $Arguments
}

# Docker Compose up -d
function Invoke-DockerComposeUpDetached {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose up -d`.

    .DESCRIPTION
        This function creates and starts Docker Compose services in detached mode (background).
        It's equivalent to running 'docker-compose up -d' or 'docker compose up -d'
        depending on the available version. Services run in background without showing logs.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose up -d command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function starts services in background but does not return objects.

    .EXAMPLE
        dcupd
        Starts all Docker Compose services in detached mode.

        Invoke-DockerComposeUpDetached web db
        Starts 'web' and 'db' services in background using the full function name.

        dcupd --scale web=3
        Starts services with 3 instances of the 'web' service.

    .NOTES
        - Starts services in background (detached mode).
        - Does not show logs in the terminal after startup.
        - Use 'dcl' or 'dclf' to view logs after starting in detached mode.
        - Returns control to the shell immediately after starting services.
    #>
    [Alias("dcupd")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'up' '-d' $Arguments
}

# Docker Compose up -d --build
function Invoke-DockerComposeUpDetachedBuild {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose up -d --build`.

    .DESCRIPTION
        This function creates and starts Docker Compose services in detached mode with forced building.
        It's equivalent to running 'docker-compose up -d --build' or 'docker compose up -d --build'
        depending on the available version. Rebuilds images and starts services in background.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose up -d --build command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function builds and starts services in background but does not return objects.

    .EXAMPLE
        dcupdb
        Rebuilds images and starts all services in detached mode.

        Invoke-DockerComposeUpDetachedBuild web
        Rebuilds and starts 'web' service in background using the full function name.

        dcupdb --scale web=2
        Rebuilds and starts services with 2 instances of the 'web' service.

    .NOTES
        - Combines image rebuilding with detached startup.
        - Forces rebuilding of images even if they already exist.
        - Starts services in background without showing logs.
        - Most comprehensive startup option for development workflows.
    #>
    [Alias("dcupdb")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'up' '-d' '--build' $Arguments
}

# Docker Compose down
function Invoke-DockerComposeDown {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose down`.

    .DESCRIPTION
        This function stops and removes Docker Compose containers, networks, and optionally volumes.
        It's equivalent to running 'docker-compose down' or 'docker compose down' depending on
        the available version. Provides clean shutdown of the entire Docker Compose stack.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose down command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function stops and removes containers but does not return objects.

    .EXAMPLE
        dcdn
        Stops and removes all Docker Compose containers and networks.

        Invoke-DockerComposeDown --volumes
        Stops containers and removes associated volumes using the full function name.

        dcdn --remove-orphans
        Removes containers for services not defined in current compose file.

    .NOTES
        - Stops and removes containers, networks created by 'up'.
        - Does not remove volumes by default (use --volumes flag).
        - Does not remove images by default (use --rmi flag).
        - More complete cleanup than just 'stop' + 'rm'.
    #>
    [Alias("dcdn")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'down' $Arguments
}

# Docker Compose logs
function Invoke-DockerComposeLogs {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose logs`.

    .DESCRIPTION
        This function displays logs from Docker Compose services. It's equivalent to running
        'docker-compose logs' or 'docker compose logs' depending on the available version.
        Shows logs from all services or specified services.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose logs command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function displays logs but does not return objects.

    .EXAMPLE
        dcl
        Shows logs from all Docker Compose services.

        Invoke-DockerComposeLogs web
        Shows logs from only the 'web' service using the full function name.

        dcl --tail 100 web
        Shows the last 100 log lines from the 'web' service.

    .NOTES
        - Shows historical logs from all or specified services.
        - Use --tail option to limit number of log lines shown.
        - Does not follow logs in real-time (use dclf for following).
        - Useful for checking past service activity and errors.
    #>
    [Alias("dcl")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'logs' $Arguments
}

# Docker Compose logs -f
function Invoke-DockerComposeLogsFollow {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose logs -f`.

    .DESCRIPTION
        This function follows (tails) logs from Docker Compose services in real-time.
        It's equivalent to running 'docker-compose logs -f' or 'docker compose logs -f'
        depending on the available version. Shows continuous log output from services.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose logs -f command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function displays streaming logs but does not return objects.

    .EXAMPLE
        dclf
        Follows logs from all Docker Compose services in real-time.

        Invoke-DockerComposeLogsFollow web
        Follows logs from only the 'web' service using the full function name.

        dclf --tail 50 web db
        Follows logs from 'web' and 'db' services starting with last 50 lines.

    .NOTES
        - Shows real-time log output from running services.
        - Press Ctrl+C to stop following logs.
        - Useful for monitoring service activity during development.
        - Combines historical logs with real-time streaming.
    #>
    [Alias("dclf")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'logs' '-f' $Arguments
}

# Docker Compose logs -f --tail 0
function Invoke-DockerComposeLogsFollowTail {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose logs -f --tail 0`.

    .DESCRIPTION
        This function follows logs from Docker Compose services showing only new log entries.
        It's equivalent to running 'docker-compose logs -f --tail 0' or 'docker compose logs -f --tail 0'
        depending on the available version. Shows only logs generated after the command starts.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose logs -f --tail 0 command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function displays streaming logs but does not return objects.

    .EXAMPLE
        dclF
        Follows only new logs from all Docker Compose services.

        Invoke-DockerComposeLogsFollowTail web
        Follows only new logs from the 'web' service using the full function name.

        dclF web db
        Follows new logs from both 'web' and 'db' services.

    .NOTES
        - Shows only logs generated after the command starts (--tail 0).
        - Does not show historical logs, only new entries.
        - Press Ctrl+C to stop following logs.
        - Useful for monitoring new activity without historical noise.
    #>
    [Alias("dclF")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'logs' '-f' '--tail' '0' $Arguments
}

# Docker Compose pull
function Invoke-DockerComposePull {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose pull`.

    .DESCRIPTION
        This function pulls latest images for Docker Compose services. It's equivalent to running
        'docker-compose pull' or 'docker compose pull' depending on the available version.
        Downloads the latest versions of images defined in the compose file.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose pull command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function pulls images but does not return objects.

    .EXAMPLE
        dcpull
        Pulls latest images for all Docker Compose services.

        Invoke-DockerComposePull web
        Pulls the latest image for only the 'web' service using the full function name.

        dcpull --parallel
        Pulls images in parallel for faster downloads.

    .NOTES
        - Downloads latest versions of images from registries.
        - Only pulls images, does not restart running containers.
        - Use --parallel flag for concurrent downloads.
        - Useful for updating to latest image versions before deployment.
    #>
    [Alias("dcpull")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'pull' $Arguments
}

# Docker Compose start
function Invoke-DockerComposeStart {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose start`.

    .DESCRIPTION
        This function starts existing Docker Compose service containers. It's equivalent to running
        'docker-compose start' or 'docker compose start' depending on the available version.
        Starts containers that were previously created but are currently stopped.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose start command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function starts containers but does not return objects.

    .EXAMPLE
        dcstart
        Starts all stopped Docker Compose service containers.

        Invoke-DockerComposeStart web
        Starts only the 'web' service container using the full function name.

        dcstart web db
        Starts both 'web' and 'db' service containers.

    .NOTES
        - Only starts existing containers, does not create new ones.
        - Containers must have been created previously (e.g., by 'up' or 'create').
        - Different from 'up' which creates containers if they don't exist.
        - Use 'up' for first-time service creation and startup.
    #>
    [Alias("dcstart")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'start' $Arguments
}

# Docker Compose kill
function Invoke-DockerComposeKill {
    <#
    .SYNOPSIS
        A PowerShell function that wraps `docker-compose kill`.

    .DESCRIPTION
        This function forcefully kills running Docker Compose service containers. It's equivalent to running
        'docker-compose kill' or 'docker compose kill' depending on the available version.
        Sends SIGKILL signal to containers for immediate termination.

    .PARAMETER Arguments
        All arguments to pass to the Docker Compose kill command.

    .INPUTS
        System.String[]. Arguments can be provided as parameters.

    .OUTPUTS
        None. This function kills containers but does not return objects.

    .EXAMPLE
        dck
        Kills all running Docker Compose service containers.

        Invoke-DockerComposeKill web
        Kills only the 'web' service container using the full function name.

        dck -s SIGTERM web
        Sends SIGTERM signal to the 'web' service container.

    .NOTES
        - Forcefully terminates containers with SIGKILL by default.
        - More aggressive than 'stop' which sends SIGTERM first.
        - Use when containers are unresponsive to normal stop commands.
        - Can specify different signals with -s flag.
    #>
    [Alias("dck")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $cmd = Get-DockerComposeCommand
    & $cmd.Split(' ')[0] $cmd.Split(' ')[1..$cmd.Split(' ').Length] 'kill' $Arguments
}

#---------------------------------------------------------------------------------------------------
# Export Module Members
#---------------------------------------------------------------------------------------------------

# Export all functions
Export-ModuleMember -Function * -Alias *

