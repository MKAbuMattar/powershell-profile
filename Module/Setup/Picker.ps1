#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup picker
#
# Dot-sourced by Setup.psm1.
#
# A checkbox list in the console. It reads Get-ProfileSetupState and calls Invoke-ProfileSetup or
# Uninstall-ProfileSetup, so it holds no knowledge of what a unit is or how one installs.
#
# The console rather than a window, for the first front end: it works over SSH, inside Windows
# Terminal, in an editor's integrated shell, and a Pester run can drive it by handing it a
# selection instead of keystrokes. Format-ProfileSetupMenu and Resolve-ProfileSetupSelection are
# separate from Show-ProfileSetup for exactly that reason, and are the parts under test.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileSetupMenuOrder {
    <#
    .SYNOPSIS
        Returns the rows in the order the menu shows them.

    .DESCRIPTION
        The menu numbers rows by position, and Resolve-ProfileSetupSelection turns a number back
        into a row by index. Both have to see the same order or number 1 selects something other
        than the first line on screen, which installs the wrong thing silently.

        One function orders them so the two cannot disagree. Categories run in the order a person
        installs in: the profile itself, then the tools it drives, then what is optional.

    .PARAMETER State
        Rows from Get-ProfileSetupState.

    .OUTPUTS
        [PSCustomObject[]] The same rows, in display order.

    .EXAMPLE
        Get-ProfileSetupMenuOrder -State (Get-ProfileSetupState)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$State
    )

    $order = @{ Core = 0; Tool = 1; Module = 2; Config = 3; Font = 4; System = 5 }

    @($State | Sort-Object -Stable -Property @{ Expression = { $order[$_.Category] } })
}

function Format-ProfileSetupMenu {
    <#
    .SYNOPSIS
        Renders the state rows as a numbered menu.

    .DESCRIPTION
        Returns lines of text rather than writing them, so a test can read what the user would see.

        Numbers follow the order of the rows it is given. Pass the output of Get-ProfileSetupMenuOrder
        and pass those same rows to Resolve-ProfileSetupSelection, or the numbers on screen will
        not match the rows a number resolves to.

        The marker in each row says what the unit is, in one glyph:

          [x]  installed by this installer, so it can be removed again
          [=]  present, but installed by someone else. Left alone.
          [ ]  not on this machine
          [!]  recorded as installed but no longer here

    .PARAMETER State
        Rows from Get-ProfileSetupState.

    .OUTPUTS
        [string[]] The menu, one line per element.

    .EXAMPLE
        Format-ProfileSetupMenu -State (Get-ProfileSetupState)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$State
    )

    $lines = [System.Collections.Generic.List[string]]::new()
    $index = 0
    $category = ''

    foreach ($row in $State) {
        $index++

        if ($row.Category -ne $category) {
            $category = $row.Category
            $lines.Add('')
            $lines.Add($category.ToUpper())
        }

        $marker = if ($row.Owned -and $row.Present) { '[x]' }
        elseif ($row.Owned) { '[!]' }
        elseif ($row.Present) { '[=]' }
        else { '[ ]' }

        $note = if ($row.Required) { 'required' }
        elseif ($row.Owned -and $row.Present) { 'installed by setup' }
        elseif ($row.Owned) { 'recorded, but missing' }
        elseif ($row.Present) { 'already on this machine' }
        else { '' }

        $lines.Add(('{0,3}. {1} {2,-28} {3}' -f $index, $marker, $row.Name, $note).TrimEnd())
        $lines.Add(('      {0}' -f $row.Description))
    }

    return @($lines)
}

function Resolve-ProfileSetupSelection {
    <#
    .SYNOPSIS
        Turns what a person typed into catalog ids.

    .DESCRIPTION
        Accepts numbers as shown in the menu, ids, category names, and the words all and none,
        separated by spaces or commas. A range is written 3-7.

        An entry that matches nothing is returned in Unknown rather than thrown, so the caller can
        say which word was not understood and ask again instead of ending the session.

    .PARAMETER Input
        What the person typed.

    .PARAMETER State
        The rows the menu was built from, in menu order.

    .OUTPUTS
        [PSCustomObject] Id, the resolved ids, and Unknown, the entries that matched nothing.

    .EXAMPLE
        Resolve-ProfileSetupSelection -InputText '1 3-5 tool' -State $state

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$InputText,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$State
    )

    $ordered = @($State)
    $ids = [System.Collections.Generic.List[string]]::new()
    $unknown = [System.Collections.Generic.List[string]]::new()

    if ([string]::IsNullOrWhiteSpace($InputText)) {
        return [PSCustomObject]@{ Id = @(); Unknown = @() }
    }

    foreach ($token in ($InputText -split '[\s,]+' | Where-Object { $_ })) {

        if ($token -eq 'none') { return [PSCustomObject]@{ Id = @(); Unknown = @() } }

        if ($token -eq 'all') {
            foreach ($row in $ordered) { $ids.Add($row.Id) }
            continue
        }

        if ($token -match '^(\d+)-(\d+)$') {
            $from = [int]$Matches[1]
            $to = [int]$Matches[2]
            if ($from -gt $to) { $from, $to = $to, $from }

            $any = $false
            for ($n = $from; $n -le $to; $n++) {
                if ($n -ge 1 -and $n -le $ordered.Count) {
                    $ids.Add($ordered[$n - 1].Id)
                    $any = $true
                }
            }
            if (-not $any) { $unknown.Add($token) }
            continue
        }

        if ($token -match '^\d+$') {
            $n = [int]$token
            if ($n -ge 1 -and $n -le $ordered.Count) { $ids.Add($ordered[$n - 1].Id) }
            else { $unknown.Add($token) }
            continue
        }

        $byId = @($ordered | Where-Object { $_.Id -eq $token })
        if ($byId.Count) {
            foreach ($row in $byId) { $ids.Add($row.Id) }
            continue
        }

        $byCategory = @($ordered | Where-Object { $_.Category -eq $token })
        if ($byCategory.Count) {
            foreach ($row in $byCategory) { $ids.Add($row.Id) }
            continue
        }

        $unknown.Add($token)
    }

    [PSCustomObject]@{
        Id      = @($ids | Select-Object -Unique)
        Unknown = @($unknown | Select-Object -Unique)
    }
}

function Show-ProfileSetup {
    <#
    .SYNOPSIS
        Lists what the profile can install, asks what you want, and does it.

    .DESCRIPTION
        Prints the catalog with its current state, reads a selection, and hands it to
        Invoke-ProfileSetup or Uninstall-ProfileSetup.

        Type numbers, ids, a category name, a range such as 3-7, all, or none. Prefix with
        "remove" to take units away instead of adding them. Enter on its own ends the session.

        Nothing is installed until the selection is confirmed, and the confirmation names every
        unit, so a mistyped range is visible before it runs.

    .PARAMETER Repository
        Root of a checkout or extracted archive, needed for the file and directory units. Defaults
        to the repository this module was loaded from.

    .PARAMETER InstallPath
        Where the Module tree goes. Defaults to the directory holding $PROFILE.

    .PARAMETER PackageManager
        Auto, Winget, Chocolatey or None.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .OUTPUTS
        None. Writes to the host.

    .EXAMPLE
        Show-ProfileSetup
        Opens the picker.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-setup')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Repository,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [ValidateSet('Auto', 'Winget', 'Chocolatey', 'None')]
        [string]$PackageManager = 'Auto',

        [Parameter()]
        [string]$ReceiptPath
    )

    # Module/Setup sits two directories below the repository root.
    if (-not $Repository) { $Repository = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }

    $common = @{}
    if ($InstallPath) { $common['InstallPath'] = $InstallPath }
    if ($ReceiptPath) { $common['ReceiptPath'] = $ReceiptPath }

    while ($true) {
        # Ordered once, then used for both the menu and the selection, so a number on screen and
        # the row it resolves to cannot drift apart.
        $state = Get-ProfileSetupMenuOrder -State (Get-ProfileSetupState @common)

        Write-Host ''
        Write-Host 'MKAbuMattar PowerShell profile setup'
        Write-Host ('Installing into {0}' -f (Get-ProfileSetupPath -InstallPath $InstallPath).InstallPath)

        foreach ($line in (Format-ProfileSetupMenu -State $state)) { Write-Host $line }

        Write-Host ''
        Write-Host '  [x] installed by setup   [=] already yours   [ ] not installed   [!] missing'
        Write-Host '  numbers, ids, a category, a range like 3-7, all, or none'
        Write-Host '  prefix with "remove" to take something off. Enter on its own to finish.'
        Write-Host ''

        $answer = Read-Host 'Select'
        if ([string]::IsNullOrWhiteSpace($answer)) { return }

        $removing = $answer -match '^\s*remove\b'
        if ($removing) { $answer = $answer -replace '^\s*remove\b', '' }

        $selection = Resolve-ProfileSetupSelection -InputText $answer -State $state

        if ($selection.Unknown.Count) {
            Write-Host ("Not understood: {0}" -f ($selection.Unknown -join ', ')) -ForegroundColor Yellow
        }

        if (-not $selection.Id.Count) { continue }

        $verb = if ($removing) { 'Remove' } else { 'Install' }
        $names = @($state | Where-Object { $_.Id -in $selection.Id } | ForEach-Object { $_.Name })

        Write-Host ''
        Write-Host ("{0}:" -f $verb)
        foreach ($name in $names) { Write-Host ("  {0}" -f $name) }
        Write-Host ''

        if ((Read-Host "$verb these? [y/N]") -notmatch '^y') { continue }

        $results = if ($removing) {
            Uninstall-ProfileSetup -Id $selection.Id @common -Confirm:$false
        }
        else {
            Invoke-ProfileSetup -Id $selection.Id -Repository $Repository -PackageManager $PackageManager @common -Confirm:$false
        }

        Write-Host ''
        foreach ($result in $results) {
            $colour = switch ($result.Status) {
                'installed' { 'Green' }
                'restored' { 'Green' }
                'removed' { 'Green' }
                'present' { 'DarkGray' }
                'skipped' { 'Yellow' }
                default { 'Red' }
            }
            Write-Host ("  {0,-22} {1,-10} {2}" -f $result.Id, $result.Status, $result.Message) -ForegroundColor $colour
        }
    }
}
