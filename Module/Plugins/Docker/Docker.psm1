#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Docker Plugin
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
#       This module provides Docker command aliases and utility functions
#       for improved Docker workflow in PowerShell.
#
# Created: 2025-09-26
# Updated: 2025-09-26
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Docker Build Functions
#---------------------------------------------------------------------------------------------------

function Invoke-DockerBuild {
    <#
    .SYNOPSIS
        Builds a Docker image from a Dockerfile.

    .DESCRIPTION
        This function provides a shorthand for the 'docker build' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker build.

    .EXAMPLE
        Invoke-DockerBuild -t myimage .
        Builds a Docker image with tag 'myimage' from current directory.

    .NOTES
        Alias: dbl
    #>
    [CmdletBinding()]
    [Alias("dbl")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker build @Arguments
}

function Invoke-DockerImageBuild {
    <#
    .SYNOPSIS
        Builds a Docker image.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image build' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker image build.

    .EXAMPLE
        Invoke-DockerImageBuild -t myimage .
        Builds a Docker image with tag 'myimage'.

    .NOTES
        Alias: dib
    #>
    [CmdletBinding()]
    [Alias("dib")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image build @Arguments
}

#---------------------------------------------------------------------------------------------------
# Docker Container Functions
#---------------------------------------------------------------------------------------------------

function Invoke-DockerContainerInspect {
    <#
    .SYNOPSIS
        Displays detailed information on one or more containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container inspect' command.

    .PARAMETER Arguments
        Container names or IDs to inspect.

    .EXAMPLE
        Invoke-DockerContainerInspect mycontainer
        Inspects the container named 'mycontainer'.

    .NOTES
        Alias: dcin
    #>
    [CmdletBinding()]
    [Alias("dcin")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container inspect @Arguments
}

function Invoke-DockerContainerList {
    <#
    .SYNOPSIS
        Lists running containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container ls' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker container ls.

    .EXAMPLE
        Invoke-DockerContainerList
        Lists all running containers.

    .NOTES
        Alias: dcls
    #>
    [CmdletBinding()]
    [Alias("dcls")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container ls @Arguments
}

function Invoke-DockerContainerListAll {
    <#
    .SYNOPSIS
        Lists all containers (running and stopped).

    .DESCRIPTION
        This function provides a shorthand for the 'docker container ls -a' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker container ls -a.

    .EXAMPLE
        Invoke-DockerContainerListAll
        Lists all containers including stopped ones.

    .NOTES
        Alias: dclsa
    #>
    [CmdletBinding()]
    [Alias("dclsa")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container ls -a @Arguments
}

function Invoke-DockerContainerLogs {
    <#
    .SYNOPSIS
        Fetches the logs of a container.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container logs' command.

    .PARAMETER Arguments
        Container name or ID and additional arguments.

    .EXAMPLE
        Invoke-DockerContainerLogs mycontainer
        Shows logs for 'mycontainer'.

    .NOTES
        Alias: dlo
    #>
    [CmdletBinding()]
    [Alias("dlo")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container logs @Arguments
}

function Invoke-DockerContainerPort {
    <#
    .SYNOPSIS
        Lists port mappings for a container.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container port' command.

    .PARAMETER Arguments
        Container name or ID and additional arguments.

    .EXAMPLE
        Invoke-DockerContainerPort mycontainer
        Shows port mappings for 'mycontainer'.

    .NOTES
        Alias: dpo
    #>
    [CmdletBinding()]
    [Alias("dpo")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container port @Arguments
}

function Invoke-DockerPs {
    <#
    .SYNOPSIS
        Lists running containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker ps' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker ps.

    .EXAMPLE
        Invoke-DockerPs
        Lists running containers.

    .NOTES
        Alias: dps
    #>
    [CmdletBinding()]
    [Alias("dps")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker ps @Arguments
}

function Invoke-DockerPsAll {
    <#
    .SYNOPSIS
        Lists all containers (running and stopped).

    .DESCRIPTION
        This function provides a shorthand for the 'docker ps -a' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker ps -a.

    .EXAMPLE
        Invoke-DockerPsAll
        Lists all containers.

    .NOTES
        Alias: dpsa
    #>
    [CmdletBinding()]
    [Alias("dpsa")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker ps -a @Arguments
}

function Invoke-DockerContainerRun {
    <#
    .SYNOPSIS
        Runs a command in a new container.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container run' command.

    .PARAMETER Arguments
        Image name and additional arguments.

    .EXAMPLE
        Invoke-DockerContainerRun ubuntu echo hello
        Runs echo command in ubuntu container.

    .NOTES
        Alias: dr
    #>
    [CmdletBinding()]
    [Alias("dr")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container run @Arguments
}

function Invoke-DockerContainerRunInteractive {
    <#
    .SYNOPSIS
        Runs a command in a new interactive container.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container run -it' command.

    .PARAMETER Arguments
        Image name and additional arguments.

    .EXAMPLE
        Invoke-DockerContainerRunInteractive ubuntu bash
        Runs bash in interactive ubuntu container.

    .NOTES
        Alias: drit
    #>
    [CmdletBinding()]
    [Alias("drit")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container run -it @Arguments
}

function Invoke-DockerContainerRemove {
    <#
    .SYNOPSIS
        Removes one or more containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container rm' command.

    .PARAMETER Arguments
        Container names or IDs to remove.

    .EXAMPLE
        Invoke-DockerContainerRemove mycontainer
        Removes the container named 'mycontainer'.

    .NOTES
        Alias: drm
    #>
    [CmdletBinding()]
    [Alias("drm")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container rm @Arguments
}

function Invoke-DockerContainerRemoveForce {
    <#
    .SYNOPSIS
        Force removes one or more containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container rm -f' command.

    .PARAMETER Arguments
        Container names or IDs to force remove.

    .EXAMPLE
        Invoke-DockerContainerRemoveForce mycontainer
        Force removes the container named 'mycontainer'.

    .NOTES
        Alias: drm!
    #>
    [CmdletBinding()]
    [Alias("drm!")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container rm -f @Arguments
}

function Invoke-DockerContainerStart {
    <#
    .SYNOPSIS
        Starts one or more stopped containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container start' command.

    .PARAMETER Arguments
        Container names or IDs to start.

    .EXAMPLE
        Invoke-DockerContainerStart mycontainer
        Starts the container named 'mycontainer'.

    .NOTES
        Alias: dst
    #>
    [CmdletBinding()]
    [Alias("dst")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container start @Arguments
}

function Invoke-DockerContainerRestart {
    <#
    .SYNOPSIS
        Restarts one or more containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container restart' command.

    .PARAMETER Arguments
        Container names or IDs to restart.

    .EXAMPLE
        Invoke-DockerContainerRestart mycontainer
        Restarts the container named 'mycontainer'.

    .NOTES
        Alias: drs
    #>
    [CmdletBinding()]
    [Alias("drs")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container restart @Arguments
}

function Invoke-DockerStopAll {
    <#
    .SYNOPSIS
        Stops all running containers.

    .DESCRIPTION
        This function stops all currently running containers.

    .EXAMPLE
        Invoke-DockerStopAll
        Stops all running containers.

    .NOTES
        Alias: dsta
  #>
    [CmdletBinding()]
    [Alias("dsta")]
    param()

    docker stop $(docker ps -q)
}

function Invoke-DockerContainerStop {
    <#
    .SYNOPSIS
        Stops one or more running containers.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container stop' command.

    .PARAMETER Arguments
        Container names or IDs to stop.

    .EXAMPLE
        Invoke-DockerContainerStop mycontainer
        Stops the container named 'mycontainer'.

    .NOTES
        Alias: dstp
    #>
    [CmdletBinding()]
    [Alias("dstp")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container stop @Arguments
}

function Invoke-DockerStats {
    <#
    .SYNOPSIS
        Displays a live stream of container resource usage statistics.

    .DESCRIPTION
        This function provides a shorthand for the 'docker stats' command.

    .PARAMETER Arguments
        Container names or IDs and additional arguments.

    .EXAMPLE
        Invoke-DockerStats
        Shows stats for all running containers.

    .NOTES
        Alias: dsts
    #>
    [CmdletBinding()]
    [Alias("dsts")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker stats @Arguments
}

function Invoke-DockerTop {
    <#
    .SYNOPSIS
        Displays the running processes of a container.

    .DESCRIPTION
        This function provides a shorthand for the 'docker top' command.

    .PARAMETER Arguments
        Container name or ID and additional arguments.

    .EXAMPLE
        Invoke-DockerTop mycontainer
        Shows running processes in 'mycontainer'.

    .NOTES
        Alias: dtop
    #>
    [CmdletBinding()]
    [Alias("dtop")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker top @Arguments
}

function Invoke-DockerContainerExec {
    <#
    .SYNOPSIS
        Runs a command in a running container.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container exec' command.

    .PARAMETER Arguments
        Container name or ID and command to execute.

    .EXAMPLE
        Invoke-DockerContainerExec mycontainer ls
        Executes 'ls' command in 'mycontainer'.

    .NOTES
        Alias: dxc
    #>
    [CmdletBinding()]
    [Alias("dxc")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container exec @Arguments
}

function Invoke-DockerContainerExecInteractive {
    <#
    .SYNOPSIS
        Runs a command in a running container interactively.

    .DESCRIPTION
        This function provides a shorthand for the 'docker container exec -it' command.

    .PARAMETER Arguments
        Container name or ID and command to execute.

    .EXAMPLE
        Invoke-DockerContainerExecInteractive mycontainer bash
        Executes 'bash' interactively in 'mycontainer'.

    .NOTES
        Alias: dxcit
    #>
    [CmdletBinding()]
    [Alias("dxcit")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker container exec -it @Arguments
}

#---------------------------------------------------------------------------------------------------
# Docker Image Functions
#---------------------------------------------------------------------------------------------------

function Invoke-DockerImageInspect {
    <#
    .SYNOPSIS
        Displays detailed information on one or more images.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image inspect' command.

    .PARAMETER Arguments
        Image names or IDs to inspect.

    .EXAMPLE
        Invoke-DockerImageInspect myimage
        Inspects the image named 'myimage'.

    .NOTES
        Alias: dii
    #>
    [CmdletBinding()]
    [Alias("dii")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image inspect @Arguments
}

function Invoke-DockerImageList {
    <#
    .SYNOPSIS
        Lists Docker images.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image ls' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker image ls.

    .EXAMPLE
        Invoke-DockerImageList
        Lists all Docker images.

    .NOTES
        Alias: dils
    #>
    [CmdletBinding()]
    [Alias("dils")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image ls @Arguments
}

function Invoke-DockerImagePush {
    <#
    .SYNOPSIS
        Pushes an image to a Docker registry.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image push' command.

    .PARAMETER Arguments
        Image name and additional arguments.

    .EXAMPLE
        Invoke-DockerImagePush myimage
        Pushes 'myimage' to registry.

    .NOTES
        Alias: dipu
    #>
    [CmdletBinding()]
    [Alias("dipu")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image push @Arguments
}

function Invoke-DockerImagePrune {
    <#
    .SYNOPSIS
        Removes all unused images.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image prune -a' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker image prune.

    .EXAMPLE
        Invoke-DockerImagePrune
        Removes all unused images.

    .NOTES
        Alias: dipru
    #>
    [CmdletBinding()]
    [Alias("dipru")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image prune -a @Arguments
}

function Invoke-DockerImageRemove {
    <#
    .SYNOPSIS
        Removes one or more images.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image rm' command.

    .PARAMETER Arguments
        Image names or IDs to remove.

    .EXAMPLE
        Invoke-DockerImageRemove myimage
        Removes the image named 'myimage'.

    .NOTES
        Alias: dirm
    #>
    [CmdletBinding()]
    [Alias("dirm")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image rm @Arguments
}

function Invoke-DockerImageTag {
    <#
    .SYNOPSIS
        Creates a tag for an image.

    .DESCRIPTION
        This function provides a shorthand for the 'docker image tag' command.

    .PARAMETER Arguments
        Source image and target tag.

    .EXAMPLE
        Invoke-DockerImageTag myimage:latest myimage:v1.0
        Tags 'myimage:latest' as 'myimage:v1.0'.

    .NOTES
        Alias: dit
    #>
    [CmdletBinding()]
    [Alias("dit")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker image tag @Arguments
}

function Invoke-DockerPull {
    <#
    .SYNOPSIS
        Pulls an image from a Docker registry.

    .DESCRIPTION
        This function provides a shorthand for the 'docker pull' command.

    .PARAMETER Arguments
        Image name and additional arguments.

    .EXAMPLE
        Invoke-DockerPull ubuntu
        Pulls the ubuntu image.

    .NOTES
        Alias: dpu
    #>
    [CmdletBinding()]
    [Alias("dpu")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker pull @Arguments
}

#---------------------------------------------------------------------------------------------------
# Docker Network Functions
#---------------------------------------------------------------------------------------------------

function Invoke-DockerNetworkCreate {
    <#
    .SYNOPSIS
        Creates a Docker network.

    .DESCRIPTION
        This function provides a shorthand for the 'docker network create' command.

    .PARAMETER Arguments
        Network name and additional arguments.

    .EXAMPLE
        Invoke-DockerNetworkCreate mynetwork
        Creates a network named 'mynetwork'.

    .NOTES
        Alias: dnc
    #>
    [CmdletBinding()]
    [Alias("dnc")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker network create @Arguments
}

function Invoke-DockerNetworkConnect {
    <#
    .SYNOPSIS
        Connects a container to a network.

    .DESCRIPTION
        This function provides a shorthand for the 'docker network connect' command.

    .PARAMETER Arguments
        Network name and container name.

    .EXAMPLE
        Invoke-DockerNetworkConnect mynetwork mycontainer
        Connects 'mycontainer' to 'mynetwork'.

    .NOTES
        Alias: dncn
    #>
    [CmdletBinding()]
    [Alias("dncn")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker network connect @Arguments
}

function Invoke-DockerNetworkDisconnect {
    <#
    .SYNOPSIS
        Disconnects a container from a network.

    .DESCRIPTION
        This function provides a shorthand for the 'docker network disconnect' command.

    .PARAMETER Arguments
        Network name and container name.

    .EXAMPLE
        Invoke-DockerNetworkDisconnect mynetwork mycontainer
        Disconnects 'mycontainer' from 'mynetwork'.

    .NOTES
        Alias: dndcn
    #>
    [CmdletBinding()]
    [Alias("dndcn")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker network disconnect @Arguments
}

function Invoke-DockerNetworkInspect {
    <#
    .SYNOPSIS
        Displays detailed information on one or more networks.

    .DESCRIPTION
        This function provides a shorthand for the 'docker network inspect' command.

    .PARAMETER Arguments
        Network names or IDs to inspect.

    .EXAMPLE
        Invoke-DockerNetworkInspect mynetwork
        Inspects the network named 'mynetwork'.

    .NOTES
        Alias: dni
    #>
    [CmdletBinding()]
    [Alias("dni")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker network inspect @Arguments
}

function Invoke-DockerNetworkList {
    <#
    .SYNOPSIS
        Lists Docker networks.

    .DESCRIPTION
        This function provides a shorthand for the 'docker network ls' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker network ls.

    .EXAMPLE
        Invoke-DockerNetworkList
        Lists all Docker networks.

    .NOTES
        Alias: dnls
    #>
    [CmdletBinding()]
    [Alias("dnls")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker network ls @Arguments
}

function Invoke-DockerNetworkRemove {
    <#
    .SYNOPSIS
        Removes one or more networks.

    .DESCRIPTION
        This function provides a shorthand for the 'docker network rm' command.

    .PARAMETER Arguments
        Network names or IDs to remove.

    .EXAMPLE
        Invoke-DockerNetworkRemove mynetwork
        Removes the network named 'mynetwork'.

    .NOTES
        Alias: dnrm
    #>
    [CmdletBinding()]
    [Alias("dnrm")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker network rm @Arguments
}

#---------------------------------------------------------------------------------------------------
# Docker Volume Functions
#---------------------------------------------------------------------------------------------------

function Invoke-DockerVolumeInspect {
    <#
    .SYNOPSIS
        Displays detailed information on one or more volumes.

    .DESCRIPTION
        This function provides a shorthand for the 'docker volume inspect' command.

    .PARAMETER Arguments
        Volume names to inspect.

    .EXAMPLE
        Invoke-DockerVolumeInspect myvolume
        Inspects the volume named 'myvolume'.

    .NOTES
        Alias: dvi
    #>
    [CmdletBinding()]
    [Alias("dvi")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker volume inspect @Arguments
}

function Invoke-DockerVolumeList {
    <#
    .SYNOPSIS
        Lists Docker volumes.

    .DESCRIPTION
        This function provides a shorthand for the 'docker volume ls' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker volume ls.

    .EXAMPLE
        Invoke-DockerVolumeList
        Lists all Docker volumes.

    .NOTES
        Alias: dvls
    #>
    [CmdletBinding()]
    [Alias("dvls")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker volume ls @Arguments
}

function Invoke-DockerVolumePrune {
    <#
    .SYNOPSIS
        Removes all unused local volumes.

    .DESCRIPTION
        This function provides a shorthand for the 'docker volume prune' command.

    .PARAMETER Arguments
        Additional arguments to pass to docker volume prune.

    .EXAMPLE
        Invoke-DockerVolumePrune
        Removes all unused volumes.

    .NOTES
        Alias: dvprune
    #>
    [CmdletBinding()]
    [Alias("dvprune")]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    docker volume prune @Arguments
}
