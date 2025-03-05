<#
.SYNOPSIS
    Moves up one directory level.

.DESCRIPTION
    This function changes the current working directory to the parent directory of the current directory. It is useful for navigating up one level in the directory structure.

.PARAMETER None
    This function does not accept any parameters.

.OUTPUTS None
    This function does not return any output.

.EXAMPLE
    Invoke-UpOneDirectoryLevel
    Moves up one directory level.

.ALIASES
    cd.1 -> Use the alias `cd.1` to quickly move up one directory level.
    .. -> Use the alias `..` to quickly move up one directory level.

.NOTES
    This function is useful for navigating up one level in the directory structure.
#>
function Invoke-UpOneDirectoryLevel {
  [CmdletBinding()]
  [Alias("cd.1")]
  [Alias("..")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path .. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up two directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the current directory. It is useful for navigating up two levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Invoke-UpTwoDirectoryLevels
  Moves up two directory levels.

.ALIASES
  cd.2 -> Use the alias `cd.2` to quickly move up two directory levels.
  ... -> Use the alias `...` to quickly move up two directory levels.

.NOTES
  This function is useful for navigating up two levels in the directory structure.
#>
function Invoke-UpTwoDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.2")]
  [Alias("...")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\.. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up three directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up three levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Invoke-UpThreeDirectoryLevels
  Moves up three directory levels.

.ALIASES
  cd.3 -> Use the alias `cd.3` to quickly move up three directory levels.
  .... -> Use the alias `....` to quickly move up three directory levels.

.NOTES
  This function is useful for navigating up three levels in the directory structure.
#>
function Invoke-UpThreeDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.3")]
  [Alias("....")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\.. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up four directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up four levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Invoke-UpFourDirectoryLevels
  Moves up four directory levels.

.ALIASES
  cd.4 -> Use the alias `cd.4` to quickly move up four directory levels.
  ..... -> Use the alias `.....` to quickly move up four directory levels.

.NOTES
  This function is useful for navigating up four levels in the directory structure.
#>
function Invoke-UpFourDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.4")]
  [Alias(".....")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\.. -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
  Moves up five directory levels.

.DESCRIPTION
  This function changes the current working directory to the parent directory of the parent directory of the parent directory of the parent directory of the parent directory of the current directory. It is useful for navigating up five levels in the directory structure.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS None
  This function does not return any output.

.EXAMPLE
  Invoke-UpFiveDirectoryLevels
  Moves up five directory levels.

.ALIASES
  cd.5 -> Use the alias `cd.5` to quickly move up five directory levels.
  ...... -> Use the alias `......` to quickly move up five directory levels.

.NOTES
  This function is useful for navigating up five levels in the directory structure.
#>
function Invoke-UpFiveDirectoryLevels {
  [CmdletBinding()]
  [Alias("cd.5")]
  [Alias("......")]
  param (
    # This function does not accept any parameters
  )

  Set-Location -Path ..\..\..\..\.. -ErrorAction SilentlyContinue
}
