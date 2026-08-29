#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Load configuration
#
# Dot-sourced by Setup.psm1.
#
# Reads and writes the component lists in profile.config.psd1: which plugins, utilities and Gallery
# modules the profile loads at start.
#
# The file disables an entry by commenting it out rather than deleting it, so the list of what is
# available stays visible next to the list of what is on:
#
#     Plugins = @(
#         'Git'
#         # 'AWS'
#     )
#
# That makes this a line edit, not a data rewrite. Reading the file with
# Import-PowerShellDataFile and writing it back would silently delete every commented entry and
# every comment in the file, and profile.config.psd1 is mostly comments explaining what each
# setting costs. So the line holding an entry is found and its comment marker added or removed,
# and nothing else in the file is touched.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileConfigEntry {
    <#
    .SYNOPSIS
        Returns the entries in one list in profile.config.psd1, enabled and disabled.

    .DESCRIPTION
        An entry that is commented out is reported with Enabled false rather than left out, because
        the picker needs to offer it.

    .PARAMETER Path
        The configuration file. Defaults to the one beside the installed Module tree.

    .PARAMETER Key
        Which list: Modules, Plugins, Utilities, ExternalModules or DeferExternalModules.

    .OUTPUTS
        [PSCustomObject[]] Key, Name, Enabled, Line.

    .EXAMPLE
        Get-ProfileConfigEntry -Key Plugins | Where-Object Enabled

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Modules', 'Plugins', 'Utilities', 'ExternalModules', 'DeferExternalModules')]
        [string[]]$Key = @('Modules', 'Plugins', 'Utilities', 'ExternalModules'),

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Config }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }

    $lines = @(Get-Content -LiteralPath $Path)

    foreach ($name in $Key) {
        $start = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^\s*$([regex]::Escape($name))\s*=\s*@\(") { $start = $i; break }
        }
        if ($start -lt 0) { continue }

        for ($i = $start + 1; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]

            # The list ends at its closing parenthesis on a line of its own.
            if ($line -match '^\s*\)\s*$') { break }

            # 'Name' or # 'Name', with anything after it, which is where the cost notes live.
            if ($line -notmatch "^\s*(#\s*)?'([^']+)'") { continue }

            [PSCustomObject]@{
                Key     = $name
                Name    = $Matches[2]
                Enabled = -not $Matches[1]
                Line    = $i
            }
        }
    }
}

function Set-ProfileConfigEntry {
    <#
    .SYNOPSIS
        Turns one entry in profile.config.psd1 on or off.

    .DESCRIPTION
        Adds or removes the comment marker on the line holding the entry. Everything else in the
        file, including the notes explaining what each module costs at startup, is left alone.

        An entry the file does not mention is added to the end of its list, so a plugin that ships
        later can be enabled without editing the file by hand.

    .PARAMETER Key
        Which list the entry belongs to.

    .PARAMETER Name
        The entry.

    .PARAMETER Enabled
        On or off.

    .PARAMETER Path
        The configuration file. Defaults to the one beside the installed Module tree.

    .OUTPUTS
        [bool] Whether the file changed.

    .EXAMPLE
        Set-ProfileConfigEntry -Key Plugins -Name AWS -Enabled $true

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('Modules', 'Plugins', 'Utilities', 'ExternalModules', 'DeferExternalModules')]
        [string]$Key,

        [Parameter(Mandatory, Position = 1)]
        [string]$Name,

        [Parameter(Mandatory, Position = 2)]
        [bool]$Enabled,

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Config }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "There is no configuration file at $Path."
    }

    if (-not $PSCmdlet.ShouldProcess("$Key/$Name", $(if ($Enabled) { 'Enable' } else { 'Disable' }))) {
        return $false
    }

    # Read as raw and split, so the file's own line ending survives the round trip.
    $raw = Get-Content -LiteralPath $Path -Raw
    $newline = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
    $lines = [System.Collections.Generic.List[string]]($raw -split "`r?`n")

    $entry = Get-ProfileConfigEntry -Key $Key -Path $Path | Where-Object { $_.Name -eq $Name } | Select-Object -First 1

    if ($entry) {
        if ($entry.Enabled -eq $Enabled) { return $false }

        $line = $lines[$entry.Line]

        $lines[$entry.Line] = if ($Enabled) {
            # Drop the marker, keep the indentation the rest of the list uses.
            $line -replace "^(\s*)#\s?", '$1'
        }
        else {
            $line -replace "^(\s*)", '$1# '
        }
    }
    else {
        # Not mentioned at all: add it at the end of the list, indented to match.
        $start = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^\s*$([regex]::Escape($Key))\s*=\s*@\(") { $start = $i; break }
        }
        if ($start -lt 0) { throw "profile.config.psd1 has no $Key list to add '$Name' to." }

        $close = -1
        for ($i = $start + 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*\)\s*$') { $close = $i; break }
        }
        if ($close -lt 0) { throw "The $Key list in profile.config.psd1 is not closed." }

        $indent = if ($lines[$close] -match '^(\s*)') { $Matches[1] + '    ' } else { '        ' }
        $text = if ($Enabled) { "$indent'$Name'" } else { "$indent# '$Name'" }

        $lines.Insert($close, $text)
    }

    Set-Content -LiteralPath $Path -Value ($lines -join $newline) -NoNewline -Encoding UTF8
    return $true
}

function Get-ProfileConfigState {
    <#
    .SYNOPSIS
        Returns everything the profile can load, with whether it is turned on.

    .DESCRIPTION
        Joins what is on disk against what profile.config.psd1 lists. A plugin present in the
        Module tree but absent from the file is reported as available and off, so the picker can
        offer something the configuration has never mentioned.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER Path
        The configuration file. Defaults to the one under InstallPath.

    .OUTPUTS
        [PSCustomObject[]] Key, Name, Enabled, Installed, Description.

    .EXAMPLE
        Get-ProfileConfigState | Where-Object Key -eq 'Plugins'

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$Path
    )

    $paths = Get-ProfileSetupPath -InstallPath $InstallPath
    if (-not $Path) { $Path = $paths.Config }

    $configured = @{}
    foreach ($entry in (Get-ProfileConfigEntry -Path $Path)) {
        $configured["$($entry.Key)/$($entry.Name)"] = $entry
    }

    # What the Module tree actually contains, so the list is not limited to what the file mentions.
    $onDisk = [ordered]@{
        Modules   = @()
        Plugins   = @()
        Utilities = @()
    }

    if (Test-Path -LiteralPath $paths.ModuleTree) {
        $onDisk.Plugins = @(Get-ChildItem -LiteralPath (Join-Path $paths.ModuleTree 'Plugins') -Directory -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Name })
        $onDisk.Utilities = @(Get-ChildItem -LiteralPath (Join-Path $paths.ModuleTree 'Utility') -Directory -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Name })
        $onDisk.Modules = @(Get-ChildItem -LiteralPath $paths.ModuleTree -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -notin 'Plugins', 'Utility', 'Loader' } |
                ForEach-Object { $_.Name })
    }

    $seen = @{}

    foreach ($key in $onDisk.Keys) {
        foreach ($name in $onDisk[$key]) {
            $entry = $configured["$key/$name"]
            $seen["$key/$name"] = $true

            [PSCustomObject]@{
                Key         = $key
                Name        = $name
                Enabled     = [bool]($entry -and $entry.Enabled)
                Installed   = $true
                Description = ''
            }
        }
    }

    # Anything the file names that is not on disk: a Gallery module, or a plugin removed since.
    foreach ($entry in $configured.Values) {
        if ($seen["$($entry.Key)/$($entry.Name)"]) { continue }

        [PSCustomObject]@{
            Key         = $entry.Key
            Name        = $entry.Name
            Enabled     = $entry.Enabled
            Installed   = ($entry.Key -eq 'ExternalModules')
            Description = if ($entry.Key -eq 'ExternalModules') { 'From the PowerShell Gallery.' } else { 'Named in the configuration but not in the Module tree.' }
        }
    }
}
