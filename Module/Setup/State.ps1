#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup state and receipt
#
# Dot-sourced by Setup.psm1.
#
# Two questions, and they are not the same question:
#
#   Is this on the machine?        Get-ProfileSetupState
#   Did this installer put it there?   the receipt
#
# Uninstall needs the second. Starship being on PATH says nothing about who put it there, and
# removing a tool the user installed years ago for other work is not an uninstall, it is damage.
# So Invoke-ProfileSetup writes down what it actually changed, and Uninstall-ProfileSetup takes
# back only that.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Test-ProfileSetupPresent {
    <#
    .SYNOPSIS
        Reports whether one catalog unit is on this machine.

    .DESCRIPTION
        Switches on the unit's Kind. Nothing here knows about a particular tool, so a new catalog
        row needs no change to this function unless it introduces a new Kind.

    .PARAMETER Unit
        A row from Get-ProfileSetupCatalog.


    .OUTPUTS
        [bool]

    .EXAMPLE
        Test-ProfileSetupPresent -Unit (Get-ProfileSetupCatalog | Where-Object Id -eq 'fzf')

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSCustomObject]$Unit
    )

    process {
        switch ($Unit.Kind) {
            'Package' {
                [bool](Get-Command -Name $Unit.Detect -CommandType Application -ErrorAction SilentlyContinue)
            }
            'Module' {
                [bool](Get-Module -ListAvailable -Name $Unit.Detect -ErrorAction SilentlyContinue)
            }
            'File' {
                Test-Path -LiteralPath $Unit.Detect -PathType Leaf
            }
            'Tree' {
                Test-Path -LiteralPath $Unit.Detect -PathType Container
            }
            'Font' {
                # Asked by installed family name, the same way Install-CascadiaCodeFont in
                # setup.ps1 asks, so the two never disagree about whether a font is present.
                # Looking for a filename under %WINDIR%\Fonts misses a per-user install, which
                # lands in %LOCALAPPDATA%\Microsoft\Windows\Fonts instead.
                try {
                    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
                    $families = [System.Drawing.Text.InstalledFontCollection]::new().Families
                    return ($families.Name -contains $Unit.Detect)
                }
                catch {
                    Write-Warning "Could not read the installed fonts, so '$($Unit.Id)' is reported as absent: $($_.Exception.Message)"
                    return $false
                }
            }
            default {
                throw "Catalog unit '$($Unit.Id)' has an unknown Kind '$($Unit.Kind)'."
            }
        }
    }
}

function Get-ProfileSetupState {
    <#
    .SYNOPSIS
        Reports what is on this machine and who put it there.

    .DESCRIPTION
        Returns one row per catalog unit with three facts a picker needs to render a checkbox
        correctly: whether it is present, whether this installer owns it, and therefore whether
        offering to remove it is safe.

        Owned is the difference between an uninstall and an accident. A unit is owned only when
        the receipt says this installer added it.

    .PARAMETER Category
        Limit to these categories.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .OUTPUTS
        [PSCustomObject[]] The catalog rows with Present, Owned, Removable and InstalledOn added.

    .EXAMPLE
        Get-ProfileSetupState | Format-Table Id, Present, Owned, Removable

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$ReceiptPath
    )

    $paths = Get-ProfileSetupPath -InstallPath $InstallPath
    $receipt = Get-ProfileSetupReceipt -Path $ReceiptPath
    $entries = @{}
    foreach ($entry in $receipt.Entries) { $entries[$entry.Id] = $entry }

    # Passed as a splat rather than as arguments: [ValidateSet] rejects the $null an unbound
    # -Category arrives as, so the parameter has to be absent instead of empty.
    $filter = @{}
    if ($Category) { $filter['Category'] = $Category }
    if ($InstallPath) { $filter['InstallPath'] = $InstallPath }

    foreach ($unit in (Get-ProfileSetupCatalog @filter)) {
        $present = Test-ProfileSetupPresent -Unit $unit
        $entry = $entries[$unit.Id]

        [PSCustomObject]@{
            Id          = $unit.Id
            Name        = $unit.Name
            Category    = $unit.Category
            Description = $unit.Description
            Required    = $unit.Required
            Kind        = $unit.Kind
            Present     = $present
            Owned       = [bool]$entry
            InstalledOn = if ($entry) { $entry.InstalledOn } else { $null }
            Replaced    = if ($entry -and $entry.Backup) { $entry.Backup } else { $null }

            # Offer removal only for something this installer added and the profile can live
            # without. Everything else is either load bearing or someone else's.
            Removable   = ($present -and [bool]$entry -and -not $unit.Required)
        }
    }
}

function Get-ProfileSetupReceipt {
    <#
    .SYNOPSIS
        Reads the record of what this installer put on the machine.

    .DESCRIPTION
        A missing or unreadable receipt is not an error. It means nothing is known to be owned,
        which makes uninstall refuse to remove anything, which is the safe direction to fail in.

    .PARAMETER Path
        Receipt file. Defaults to the one under LOCALAPPDATA.

    .OUTPUTS
        [PSCustomObject] With Version, UpdatedOn and Entries.

    .EXAMPLE
        (Get-ProfileSetupReceipt).Entries | Format-Table Id, InstalledOn

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    $empty = [PSCustomObject]@{ Version = 1; UpdatedOn = $null; Entries = @() }

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $empty }

    try {
        $data = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    }
    catch {
        Write-Warning "The install receipt at $Path could not be read, so nothing is treated as owned: $($_.Exception.Message)"
        return $empty
    }

    [PSCustomObject]@{
        Version   = if ($data.PSObject.Properties.Name -contains 'Version') { $data.Version } else { 1 }
        UpdatedOn = if ($data.PSObject.Properties.Name -contains 'UpdatedOn') { $data.UpdatedOn } else { $null }
        Entries   = @($data.Entries)
    }
}

function Add-ProfileSetupReceiptEntry {
    <#
    .SYNOPSIS
        Records that this installer added one unit.

    .DESCRIPTION
        Called after a unit installs, not before, so a failed install leaves no claim of ownership.
        Re-adding an existing id replaces its entry rather than duplicating it.

    .PARAMETER Id
        Catalog id.

    .PARAMETER Backup
        Path of the file that was displaced, when one was. Uninstall restores it.

    .PARAMETER Manager
        Package manager used, for a Package unit.

    .PARAMETER Path
        Receipt file. Defaults to the one under LOCALAPPDATA.

    .OUTPUTS
        None.

    .EXAMPLE
        Add-ProfileSetupReceiptEntry -Id 'fzf' -Manager Winget

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Id,

        [Parameter()]
        [string]$Backup,

        [Parameter()]
        [string]$Manager,

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    $receipt = Get-ProfileSetupReceipt -Path $Path
    $entries = @($receipt.Entries | Where-Object { $_.Id -ne $Id })

    $entries += [PSCustomObject]@{
        Id          = $Id
        InstalledOn = (Get-Date).ToString('o')
        Backup      = if ($Backup) { $Backup } else { $null }
        Manager     = if ($Manager) { $Manager } else { $null }
    }

    Save-ProfileSetupReceipt -Entry $entries -Path $Path
}

function Remove-ProfileSetupReceiptEntry {
    <#
    .SYNOPSIS
        Drops one unit's ownership record after it has been removed.

    .PARAMETER Id
        Catalog id.

    .PARAMETER Path
        Receipt file. Defaults to the one under LOCALAPPDATA.

    .OUTPUTS
        None.

    .EXAMPLE
        Remove-ProfileSetupReceiptEntry -Id 'fzf'

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Id,

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    $receipt = Get-ProfileSetupReceipt -Path $Path
    Save-ProfileSetupReceipt -Entry @($receipt.Entries | Where-Object { $_.Id -ne $Id }) -Path $Path
}

function Save-ProfileSetupReceipt {
    <#
    .SYNOPSIS
        Writes the receipt.

    .PARAMETER Entry
        The entries to store.

    .PARAMETER Path
        Receipt file.

    .OUTPUTS
        None.

    .EXAMPLE
        Save-ProfileSetupReceipt -Entry @() -Path $receipt
        Empties the receipt.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [AllowEmptyCollection()]
        [PSCustomObject[]]$Entry = @(),

        [Parameter()]
        [string]$Path
    )

    if (-not $Path) { $Path = (Get-ProfileSetupPath).Receipt }

    if (-not $PSCmdlet.ShouldProcess($Path, 'Write the install receipt')) { return }

    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    $document = [PSCustomObject]@{
        Version   = 1
        UpdatedOn = (Get-Date).ToString('o')
        Entries   = @($Entry)
    }

    $document | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $Path -Encoding UTF8
}
