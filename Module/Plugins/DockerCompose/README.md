# Docker Compose Plugin

A comprehensive PowerShell module that provides Docker Compose CLI shortcuts and utility functions for improved Docker Compose workflow in PowerShell environments.

## Features

-   **Automatic Command Detection**: Intelligently selects between `docker-compose` and `docker compose`
-   **Complete Alias Coverage**: All essential Docker Compose commands with short aliases
-   **Full Parameter Support**: All Docker Compose arguments and options are supported
-   **Comprehensive Help**: Detailed help documentation for each function
-   **PowerShell Integration**: Native PowerShell function names with familiar aliases

## Installation

This plugin is automatically loaded when the PowerShell profile is imported. No additional installation is required.

## Available Functions and Aliases

### Core Commands

| Alias       | Function                      | Description                            |
| ----------- | ----------------------------- | -------------------------------------- |
| `dco`       | `Invoke-DockerCompose`        | Base Docker Compose command wrapper    |
| `dcb`       | `Invoke-DockerComposeBuild`   | Build or rebuild services              |
| `dce`       | `Invoke-DockerComposeExec`    | Execute commands in running containers |
| `dcps`      | `Invoke-DockerComposePs`      | List containers                        |
| `dcrestart` | `Invoke-DockerComposeRestart` | Restart services                       |
| `dcrm`      | `Invoke-DockerComposeRemove`  | Remove stopped containers              |
| `dcr`       | `Invoke-DockerComposeRun`     | Run one-time commands                  |
| `dcstop`    | `Invoke-DockerComposeStop`    | Stop services                          |
| `dcstart`   | `Invoke-DockerComposeStart`   | Start services                         |
| `dck`       | `Invoke-DockerComposeKill`    | Kill running containers                |

### Service Management

| Alias    | Function                              | Description                                     |
| -------- | ------------------------------------- | ----------------------------------------------- |
| `dcup`   | `Invoke-DockerComposeUp`              | Create and start containers                     |
| `dcupb`  | `Invoke-DockerComposeUpBuild`         | Create and start containers with build          |
| `dcupd`  | `Invoke-DockerComposeUpDetached`      | Create and start containers in detached mode    |
| `dcupdb` | `Invoke-DockerComposeUpDetachedBuild` | Create and start containers detached with build |
| `dcdn`   | `Invoke-DockerComposeDown`            | Stop and remove containers, networks            |

### Monitoring and Logs

| Alias  | Function                             | Description                          |
| ------ | ------------------------------------ | ------------------------------------ |
| `dcl`  | `Invoke-DockerComposeLogs`           | View output from containers          |
| `dclf` | `Invoke-DockerComposeLogsFollow`     | Follow log output                    |
| `dclF` | `Invoke-DockerComposeLogsFollowTail` | Follow log output (new entries only) |

### Image Management

| Alias    | Function                   | Description         |
| -------- | -------------------------- | ------------------- |
| `dcpull` | `Invoke-DockerComposePull` | Pull service images |

## Usage Examples

### Basic Service Management

```powershell
# Start all services
dcup

# Start services in detached mode
dcupd

# Start services with fresh build
dcupb

# Stop and remove everything
dcdn
```

### Development Workflow

```powershell
# Build and start services in background
dcupdb

# View logs
dcl

# Follow logs in real-time
dclf

# Execute commands in running containers
dce web bash
dce db psql -U postgres
```

### Service Monitoring

```powershell
# List running containers
dcps

# View service logs
dcl web
dcl --tail 100 web

# Follow new log entries only
dclF
```

### Container Management

```powershell
# Run one-time commands
dcr web python manage.py migrate
dcr --rm web npm test

# Restart specific services
dcrestart web db

# Remove stopped containers
dcrm
```

## Advanced Features

### Command Detection

The plugin automatically detects the available Docker Compose command:

-   Prefers `docker-compose` (v1) for backward compatibility
-   Falls back to `docker compose` (v2) if v1 is not available
-   Caches the detection result for better performance

### Parameter Passing

All functions accept the same parameters as their Docker Compose counterparts:

```powershell
# Multiple compose files
dco -f docker-compose.yml -f docker-compose.override.yml config

# Environment variables
dcr -e DEBUG=true web python manage.py shell

# Port mapping
dcr -p 8080:8080 web

# Volume mounting
dcr -v /host/path:/container/path web bash
```

### Help System Integration

Each function includes comprehensive help documentation:

```powershell
# Get help for any function
Get-Help Invoke-DockerComposeUp -Full
Get-Help dcup -Examples
```

## Requirements

-   PowerShell 5.0 or later
-   Docker Compose (either v1 standalone or v2 CLI plugin)
-   Docker Engine

## Compatibility

This plugin works with:

-   Docker Compose v1 (`docker-compose`)
-   Docker Compose v2 (`docker compose`)
-   Windows PowerShell 5.1
-   PowerShell Core 6.0+
-   All Docker Compose commands and options

## Troubleshooting

### Common Issues

1. **Command not found**: Ensure Docker Compose is installed and in PATH
2. **Permission denied**: Check Docker daemon permissions
3. **File not found**: Ensure you're in a directory with `docker-compose.yml`

### Getting Help

```powershell
# Check Docker Compose installation
dco --version

# List available commands
dco --help

# Get function help
Get-Help dcup -Full
```

## Commands

<!-- BEGIN GENERATED COMMANDS -->

<!-- Generated by Tools/Update-Readme.ps1 from the comment-based help in DockerCompose.psm1. -->
<!-- Edit the help in the source, then re-run the tool. Changes here are overwritten. -->

| Command | Alias | Description |
| --- | --- | --- |
| `Invoke-DockerCompose` | `dco` | A PowerShell function that wraps the Docker Compose command. |
| `Invoke-DockerComposeBuild` | `dcb` | A PowerShell function that wraps `docker-compose build`. |
| `Invoke-DockerComposeDown` | `dcdn` | A PowerShell function that wraps `docker-compose down`. |
| `Invoke-DockerComposeExec` | `dce` | A PowerShell function that wraps `docker-compose exec`. |
| `Invoke-DockerComposeKill` | `dck` | A PowerShell function that wraps `docker-compose kill`. |
| `Invoke-DockerComposeLogs` | `dcl` | A PowerShell function that wraps `docker-compose logs`. |
| `Invoke-DockerComposeLogsFollow` | `dclf` | A PowerShell function that wraps `docker-compose logs -f`. |
| `Invoke-DockerComposeLogsFollowTail` | `dclft` | A PowerShell function that wraps `docker-compose logs -f --tail 0`. |
| `Invoke-DockerComposePs` | `dcps` | A PowerShell function that wraps `docker-compose ps`. |
| `Invoke-DockerComposePull` | `dcpull` | A PowerShell function that wraps `docker-compose pull`. |
| `Invoke-DockerComposeRemove` | `dcrm` | A PowerShell function that wraps `docker-compose rm`. |
| `Invoke-DockerComposeRestart` | `dcrestart` | A PowerShell function that wraps `docker-compose restart`. |
| `Invoke-DockerComposeRun` | `dcr` | A PowerShell function that wraps `docker-compose run`. |
| `Invoke-DockerComposeStart` | `dcstart` | A PowerShell function that wraps `docker-compose start`. |
| `Invoke-DockerComposeStop` | `dcstop` | A PowerShell function that wraps `docker-compose stop`. |
| `Invoke-DockerComposeUp` | `dcup` | A PowerShell function that wraps `docker-compose up`. |
| `Invoke-DockerComposeUpBuild` | `dcupb` | A PowerShell function that wraps `docker-compose up --build`. |
| `Invoke-DockerComposeUpDetached` | `dcupd` | A PowerShell function that wraps `docker-compose up -d`. |
| `Invoke-DockerComposeUpDetachedBuild` | `dcupdb` | A PowerShell function that wraps `docker-compose up -d --build`. |

19 command(s).

<!-- END GENERATED COMMANDS -->
