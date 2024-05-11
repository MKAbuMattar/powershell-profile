#######################################################
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
#  MKAbuMattar's PowerShell Profile
#######################################################

#------------------------------------------------------
# MKAbuMattar's PowerShell Profile
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This PowerShell profile script is crafted by
#       Mohammad Abu Mattar to tailor and optimize the
#       PowerShell environment according to specific
#       preferences and requirements. It includes various
#       settings, module imports, utility functions, and
#       shortcuts to enhance productivity and streamline
#       workflow.
#
# Created: 2021-09-01
# Updated: 2024-05-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 2.0.1
#------------------------------------------------------

#######################################################
# Environment Variables
#######################################################

<#
.SYNOPSIS
    Set environment variables for the PowerShell profile Auto Update.

.DESCRIPTION
    This environment variable determines whether the PowerShell profile should automatically check for updates. If set to true, it enables the profile update function, which checks for updates to the PowerShell profile from a specified GitHub repository and updates the local profile if changes are detected. Default value is false.

.EXAMPLE
    AutoUpdateProfile = false
    Disables the automatic update of the PowerShell profile.
#>
$env:AutoUpdateProfile = [bool]$false

<#
.SYNOPSIS
    Set environment variables for the PowerShell Auto Update.

.DESCRIPTION
    This environment variable determines whether the PowerShell should automatically check for updates. If set to true, it enables the PowerShell update function, which checks for updates to the PowerShell from a specified GitHub repository and updates the local PowerShell if changes are detected. Default value is false.

.EXAMPLE
    AutoUpdatePowerShell = false
    Disables the automatic update of the PowerShell.
#>
$env:AutoUpdatePowerShell = [bool]$false