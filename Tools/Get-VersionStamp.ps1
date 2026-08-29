#Requires -Version 5.1
<#
.SYNOPSIS
    Derives what every version-carrying file in the repository should say.

.DESCRIPTION
    The repository ships one profile made of 45 modules that are released together, so they all
    carry one version. The VERSION file at the repository root holds it, and every other
    occurrence is stamped from there.

    Before this existed there were four live numbers at once: 4.2.0 in 41 manifests, 5.0.0 in the
    profile header and Loader.psd1, and 5.1.0 in Loader.psm1 and Coreutils.psd1. The
    MinimumProfileVersion gate in the loader compared plugin metadata against the 5.1.0 constant,
    which was correct only because someone remembered to edit that one line.

    Tools/Update-Version.ps1 writes what this returns, Tools/Test-Version.ps1 fails when a
    committed file disagrees with it. Both call this, so the writer and the checker cannot drift.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.OUTPUTS
    [PSCustomObject] One per file needing a change, with Relative, Full, Current and Updated.

.EXAMPLE
    . ./Tools/Get-VersionStamp.ps1
    Get-VersionStamp -Path .

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

function Get-ProfileVersionFile {
    <#
    .SYNOPSIS
        Reads the VERSION file and returns its contents as a [version].

    .PARAMETER Path
        Repository root holding the VERSION file.

    .OUTPUTS
        [version] The declared profile version.
    #>
    [CmdletBinding()]
    [OutputType([version])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    $file = Join-Path $Path 'VERSION'
    if (-not (Test-Path -LiteralPath $file)) {
        throw "VERSION not found at $file. It is the source of truth for every module version."
    }

    $text = (Get-Content -LiteralPath $file -Raw).Trim()
    if ($text -notmatch '^\d+\.\d+\.\d+$') {
        throw "VERSION holds '$text'. It must be a three-part version such as 5.1.0."
    }

    [version]$text
}

function Get-VersionStamp {
    <#
    .SYNOPSIS
        Returns every file whose version text differs from the VERSION file.

    .DESCRIPTION
        Three things carry the version and are rewritten here:

          # Version: X.Y.Z     the header comment in every module file and in the profile
          ModuleVersion = 'X'  the manifest key in every .psd1 that declares one
          $script:ProfileVersion = 'X'   the constant the MinimumProfileVersion gate compares against

        Tools/ is excluded: those scripts declare #Requires, not a version, and are not shipped
        as modules.

    .PARAMETER Path
        Repository root to scan.

    .OUTPUTS
        [PSCustomObject] Relative, Full, Current, Updated. Empty when nothing has drifted.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    $version = Get-ProfileVersionFile -Path $Path
    $text = $version.ToString()

    $files = Get-ChildItem -LiteralPath $Path -Recurse -File -Include '*.ps1', '*.psm1', '*.psd1' |
        Where-Object { $_.FullName -notmatch '[\\/](\.git|Tools|Tests)[\\/]' }

    foreach ($file in $files) {
        $original = Get-Content -LiteralPath $file.FullName -Raw
        if ($null -eq $original) { continue }

        $updated = $original

        # Header comment, as written by every module file and by the profile itself.
        $updated = [regex]::Replace($updated, '(?m)^(#\s*Version:\s*)\d+\.\d+\.\d+\s*$', "`${1}$text")

        # Manifest key, in .psd1 only. Module/Loader/Plugin.ps1 carries a ModuleVersion inside the
        # here-string it scaffolds a new plugin from, and a user's plugin starts at its own 1.0.0
        # rather than at the profile version.
        if ($file.Extension -eq '.psd1') {
            $updated = [regex]::Replace($updated, "(?m)^(\s*ModuleVersion\s*=\s*)'[^']*'", "`${1}'$text'")
        }

        # The constant the loader compares MinimumProfileVersion against.
        $updated = [regex]::Replace($updated, "(?m)^(\s*\`$script:ProfileVersion\s*=\s*)'[^']*'", "`${1}'$text'")

        if ($updated -eq $original) { continue }

        [PSCustomObject]@{
            Relative = $file.FullName.Substring($Path.Length).TrimStart('\', '/')
            Full     = $file.FullName
            Current  = $original
            Updated  = $updated
        }
    }
}
