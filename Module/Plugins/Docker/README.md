# Docker Plugin for PowerShell Profile

This module provides convenient Docker command aliases and utility functions to improve Docker workflow in PowerShell environments.

## Overview

The Docker plugin converts common Docker CLI commands into PowerShell functions with shorter, more intuitive aliases. All functions follow PowerShell naming conventions while maintaining the familiar Docker command structure.

## Features

- **Container Management**: Create, start, stop, and manage Docker containers
- **Image Management**: Build, tag, push, and manage Docker images
- **Network Management**: Create and manage Docker networks
- **Volume Management**: Handle Docker volumes and storage
- **Monitoring**: View container stats, logs, and processes
- **Interactive Sessions**: Execute commands in running containers

## Function Reference

### Container Operations

| Function                               | Alias   | Description               | Docker Equivalent             |
| -------------------------------------- | ------- | ------------------------- | ----------------------------- |
| `Invoke-DockerContainerList`           | `dcls`  | List running containers   | `docker container ls`         |
| `Invoke-DockerContainerListAll`        | `dclsa` | List all containers       | `docker container ls -a`      |
| `Invoke-DockerPs`                      | `dps`   | Show running containers   | `docker ps`                   |
| `Invoke-DockerPsAll`                   | `dpsa`  | Show all containers       | `docker ps -a`                |
| `Invoke-DockerContainerRun`            | `dr`    | Run a new container       | `docker run`                  |
| `Invoke-DockerContainerRunInteractive` | `drit`  | Run interactive container | `docker run -it`              |
| `Invoke-DockerContainerStart`          | `dst`   | Start a container         | `docker start`                |
| `Invoke-DockerContainerStop`           | `dstp`  | Stop a container          | `docker stop`                 |
| `Invoke-DockerContainerRestart`        | `drs`   | Restart a container       | `docker restart`              |
| `Invoke-DockerContainerRemove`         | `drm`   | Remove a container        | `docker rm`                   |
| `Invoke-DockerContainerRemoveForce`    | `drm!`  | Force remove container    | `docker rm -f`                |
| `Invoke-DockerStopAll`                 | `dsta`  | Stop all containers       | `docker stop $(docker ps -q)` |

### Image Operations

| Function                   | Alias   | Description          | Docker Equivalent    |
| -------------------------- | ------- | -------------------- | -------------------- |
| `Invoke-DockerBuild`       | `dbl`   | Build an image       | `docker build`       |
| `Invoke-DockerImageBuild`  | `dib`   | Build an image       | `docker image build` |
| `Invoke-DockerImageList`   | `dils`  | List images          | `docker image ls`    |
| `Invoke-DockerImageRemove` | `dirm`  | Remove an image      | `docker image rm`    |
| `Invoke-DockerImageTag`    | `dit`   | Tag an image         | `docker image tag`   |
| `Invoke-DockerImagePush`   | `dipu`  | Push an image        | `docker image push`  |
| `Invoke-DockerImagePrune`  | `dipru` | Remove unused images | `docker image prune` |
| `Invoke-DockerPull`        | `dpu`   | Pull an image        | `docker pull`        |

### Network Operations

| Function                         | Alias   | Description             | Docker Equivalent           |
| -------------------------------- | ------- | ----------------------- | --------------------------- |
| `Invoke-DockerNetworkCreate`     | `dnc`   | Create a network        | `docker network create`     |
| `Invoke-DockerNetworkList`       | `dnls`  | List networks           | `docker network ls`         |
| `Invoke-DockerNetworkRemove`     | `dnrm`  | Remove a network        | `docker network rm`         |
| `Invoke-DockerNetworkConnect`    | `dncn`  | Connect to network      | `docker network connect`    |
| `Invoke-DockerNetworkDisconnect` | `dndcn` | Disconnect from network | `docker network disconnect` |

### Volume Operations

| Function                   | Alias     | Description           | Docker Equivalent     |
| -------------------------- | --------- | --------------------- | --------------------- |
| `Invoke-DockerVolumeList`  | `dvls`    | List volumes          | `docker volume ls`    |
| `Invoke-DockerVolumePrune` | `dvprune` | Remove unused volumes | `docker volume prune` |

### Monitoring and Inspection

| Function                        | Alias  | Description              | Docker Equivalent          |
| ------------------------------- | ------ | ------------------------ | -------------------------- |
| `Invoke-DockerContainerInspect` | `dcin` | Inspect a container      | `docker container inspect` |
| `Invoke-DockerImageInspect`     | `dii`  | Inspect an image         | `docker image inspect`     |
| `Invoke-DockerNetworkInspect`   | `dni`  | Inspect a network        | `docker network inspect`   |
| `Invoke-DockerVolumeInspect`    | `dvi`  | Inspect a volume         | `docker volume inspect`    |
| `Invoke-DockerContainerLogs`    | `dlo`  | View container logs      | `docker logs`              |
| `Invoke-DockerContainerPort`    | `dpo`  | Show container ports     | `docker port`              |
| `Invoke-DockerStats`            | `dsts` | Show container stats     | `docker stats`             |
| `Invoke-DockerTop`              | `dtop` | Show container processes | `docker top`               |

### Execution

| Function                                | Alias   | Description                 | Docker Equivalent |
| --------------------------------------- | ------- | --------------------------- | ----------------- |
| `Invoke-DockerContainerExec`            | `dxc`   | Execute command             | `docker exec`     |
| `Invoke-DockerContainerExecInteractive` | `dxcit` | Execute interactive command | `docker exec -it` |

## Usage Examples

```powershell
# Build an image
dbl -t myapp:latest .

# Run a container interactively
drit ubuntu:latest

# List all containers
dpsa

# Stop all running containers
dsta

# View container logs
dlo mycontainer

# Execute command in running container
dxcit mycontainer bash

# Remove unused images
dipru

# Create a network
dnc mynetwork

# Inspect a container
dcin mycontainer
```

## Installation

This module is automatically loaded as part of the PowerShell profile. All functions and aliases are available immediately when the profile loads.

## Requirements

- PowerShell 5.0 or later
- Docker installed and accessible via PATH
- Docker daemon running

## Notes

- All functions pass arguments directly to the underlying Docker commands
- Error handling is managed by the Docker CLI
- Functions maintain Docker's original parameter structure and behavior
- Aliases provide quick access to frequently used commands

## Contributing

To add new Docker commands or modify existing ones:

1. Update the function definitions in `Docker.psm1`
2. Add corresponding aliases to the manifest in `Docker.psd1`
3. Update this README with the new function documentation
4. Test the new functions with common Docker workflows

## License

This module is part of the PowerShell Profile project and is licensed under the same terms.
