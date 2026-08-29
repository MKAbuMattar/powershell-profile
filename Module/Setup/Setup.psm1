#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup Module
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
#       Describes what the profile installs, reports what is already on the machine, and records
#       what this installer put there so it can take the same things back off.
#
#       setup.ps1 installs; nothing removed. Removing by guesswork deletes a starship.toml the
#       user wrote and uninstalls an fzf they had before they found this repository. The receipt
#       is what separates those two cases, so it is written by the installer and read by every
#       front end.
#
#       This module is deliberately free of a user interface. The console picker and the window
#       both bind to Get-ProfileSetupState and call Invoke-ProfileSetup, which keeps the part
#       that can be tested apart from the part that cannot.
#
# Created: 2026-08-29
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.1.0
#---------------------------------------------------------------------------------------------------

. (Join-Path $PSScriptRoot 'Brand.ps1')
. (Join-Path $PSScriptRoot 'Catalog.ps1')
. (Join-Path $PSScriptRoot 'State.ps1')
. (Join-Path $PSScriptRoot 'Config.ps1')
. (Join-Path $PSScriptRoot 'Install.ps1')
. (Join-Path $PSScriptRoot 'Uninstall.ps1')
. (Join-Path $PSScriptRoot 'Picker.ps1')
. (Join-Path $PSScriptRoot 'Window.ps1')
