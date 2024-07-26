<#
.SYNOPSIS
    Invokes the Starship module transiently to load the Starship prompt.

.DESCRIPTION
    This function transiently invokes the Starship module to load the Starship prompt, which enhances the appearance and functionality of the PowerShell prompt. It ensures that the Starship prompt is loaded dynamically without permanently modifying the PowerShell environment.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS
    This function does not return any output.

.EXAMPLE
    Invoke-Starship-TransientFunction
    Invokes the Starship module transiently to load the Starship prompt.

.ALIASES
    starship-transient
    Use the alias `starship-transient` to quickly load the Starship prompt transiently.

.NOTES
    This function is used to load the Starship prompt transiently without permanently modifying the PowerShell environment.
#>
function Invoke-StarshipTransientFunction {
    [CmdletBinding()]
    [Alias("starship-transient")]
    param (
        # This function does not accept any parameters
    )

    &starship module character
}
