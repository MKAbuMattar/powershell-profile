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
#       This Module provides a function to transiently load the Starship prompt for PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Invoke-StarshipTransientFunction {
  <#
  .SYNOPSIS
    Invokes the Starship module transiently to load the Starship prompt.

  .DESCRIPTION
    This function transiently invokes the Starship module to load the Starship prompt, which enhances the appearance and functionality of the PowerShell prompt. It ensures that the Starship prompt is loaded dynamically without permanently modifying the PowerShell environment.

  .PARAMETER None
    This function does not accept any parameters.

  .INPUTS
    This function does not accept any input.

  .OUTPUTS
    This function does not return any output.

  .NOTES
    This function is used to load the Starship prompt transiently without permanently modifying the PowerShell environment.

  .EXAMPLE
    Invoke-Starship-TransientFunction
    Invokes the Starship module transiently to load the Starship prompt.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
  [CmdletBinding()]
  [Alias("starship-transient")]
  [OutputType([void])]
  param (
    # This function does not accept any parameters
  )

  &starship module character
}
