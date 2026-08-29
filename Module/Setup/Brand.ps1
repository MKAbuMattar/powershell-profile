#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Brand palette
#
# Dot-sourced by Setup.psm1.
#
# The identity at https://mkabumattar.com/identity/, in one place, so the console picker and the
# window cannot drift into two different looks.
#
# The identity defines a day palette and a night palette. Both front ends here sit on a dark
# ground, so they use the night set: Black Iris underneath, Salt White for headings, Amman Stone
# for body copy, Wadi Rum Sand as the accent. The day values are carried too, for anything drawn
# on a light ground later.
#
# Typefaces are named with a fallback after them. Archivo, Public Sans and JetBrains Mono are not
# on a machine by default, and WPF silently falls back to a serif when a family is missing, which
# looks like a bug rather than a missing font.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileSetupBrand {
    <#
    .SYNOPSIS
        Returns the brand colours and typefaces.

    .DESCRIPTION
        Colours come back as hex for WPF and as 24-bit ANSI sequences for the console, so a caller
        picks the form its surface needs rather than converting one into the other.

    .PARAMETER Mode
        Night for a dark ground, Day for a light one. Night is the default: both setup front ends
        draw on a dark ground.

    .OUTPUTS
        [PSCustomObject] Hex, Ansi and Font.

    .EXAMPLE
        (Get-ProfileSetupBrand).Hex.Accent
        Returns the accent colour for the night palette.

    .EXAMPLE
        "$((Get-ProfileSetupBrand).Ansi.Accent)Selected$((Get-ProfileSetupBrand).Ansi.Reset)"
        Writes accented text to a console that understands virtual terminal sequences.

    .LINK
        https://mkabumattar.com/identity/
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Night', 'Day')]
        [string]$Mode = 'Night'
    )

    $hex = if ($Mode -eq 'Night') {
        [ordered]@{
            Ground    = '#2B2233'   # Black Iris
            Surface   = '#352B3E'   # Black Iris, lifted, for a panel on the ground
            Line      = '#4A3F53'   # Black Iris, lifted further, for a keyline
            Heading   = '#EAE6DB'   # Salt White
            Body      = '#D9C9B0'   # Amman Stone
            Accent    = '#D9A36A'   # Wadi Rum Sand
            Secondary = '#B9875E'   # Desert Camel
            Tertiary  = '#C76B6B'   # Petra Rose
            Positive  = '#6B7A4F'   # Olive Green
        }
    }
    else {
        [ordered]@{
            Ground    = '#EAE6DB'   # Salt White
            Surface   = '#F2EFE7'   # Salt White, lifted
            Line      = '#2B2233'   # Black Iris
            Heading   = '#2B2233'   # Black Iris
            Body      = '#3C3C3C'   # Basalt Black
            Accent    = '#8B1E2D'   # Keffiyeh Red
            Secondary = '#2F5D6B'   # Dead Sea Blue
            Tertiary  = '#C76B6B'   # Petra Rose
            Positive  = '#6B7A4F'   # Olive Green
        }
    }

    $ansi = [ordered]@{ Reset = "`e[0m" }
    foreach ($name in $hex.Keys) {
        $value = $hex[$name].TrimStart('#')
        $r = [Convert]::ToInt32($value.Substring(0, 2), 16)
        $g = [Convert]::ToInt32($value.Substring(2, 2), 16)
        $b = [Convert]::ToInt32($value.Substring(4, 2), 16)
        $ansi[$name] = "`e[38;2;$r;$g;${b}m"
    }

    [PSCustomObject]@{
        Mode = $Mode
        Hex  = $hex
        Ansi = $ansi
        Font = [ordered]@{
            # Weight ranges are the identity's: Archivo 500-900, Public Sans 300-700,
            # JetBrains Mono 400-700.
            Display = 'Archivo, Segoe UI'
            Body    = 'Public Sans, Segoe UI'
            Mono    = 'JetBrains Mono, Cascadia Mono, Consolas'
        }
    }
}

function Test-ProfileSetupColor {
    <#
    .SYNOPSIS
        Reports whether this host can draw 24-bit colour.

    .DESCRIPTION
        A redirected or piped host prints the escape sequences as literal text, which is worse
        than plain output, so the picker asks before it colours anything.

    .OUTPUTS
        [bool]

    .EXAMPLE
        if (Test-ProfileSetupColor) { Write-Host "$accent text$reset" }

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if ([System.Console]::IsOutputRedirected) { return $false }
    if ($env:NO_COLOR) { return $false }
    if ($env:TERM -eq 'dumb') { return $false }

    return $true
}
