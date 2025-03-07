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
function Invoke-StarshipTransientFunction {
  [CmdletBinding()]
  [Alias("starship-transient")]
  [OutputType([void])]
  param (
    # This function does not accept any parameters
  )
  Begin {}
  Process {
    &starship module character
  }
  End {}
}
