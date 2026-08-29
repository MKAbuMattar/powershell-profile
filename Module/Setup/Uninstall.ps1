#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup uninstall
#
# Dot-sourced by Setup.psm1.
#
# Removes only what the receipt says this installer added. Everything else is refused, including
# a tool that is plainly present, because being present is not the same as being ours.
#
# Three refusals are deliberate and none of them are errors:
#
#   not owned    the receipt has no entry, so someone else installed it
#   required     the profile cannot run without it
#   absent       there is nothing left to remove
#
# A file that displaced an existing one is restored from the backup rather than deleted, so
# uninstalling puts the user's own starship.toml back instead of leaving them with nothing.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Remove-ProfileSetupUnit {
    <#
    .SYNOPSIS
        Removes one unit and reports what happened.

    .DESCRIPTION
        Returns a result rather than throwing, so one failure does not abandon the rest of a
        selection. Status is one of removed, restored, skipped or failed.

    .PARAMETER Unit
        A row from Get-ProfileSetupCatalog.

    .PARAMETER Backup
        The displaced original recorded at install time, when there was one.

    .PARAMETER Manager
        The package manager that installed it, from the receipt.

    .OUTPUTS
        [PSCustomObject] Id, Status, Message.

    .EXAMPLE
        Remove-ProfileSetupUnit -Unit $unit -Backup $path -Manager Winget

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Unit,

        [Parameter()]
        [string]$Backup,

        [Parameter()]
        [string]$Manager
    )

    $result = [PSCustomObject]@{ Id = $Unit.Id; Status = 'failed'; Message = '' }

    try {
        switch ($Unit.Kind) {

            { $_ -in 'File', 'Tree' } {
                if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Remove')) {
                    $result.Status = 'skipped'
                    break
                }

                if (Test-Path -LiteralPath $Unit.Detect) {
                    Remove-Item -LiteralPath $Unit.Detect -Recurse -Force
                }

                if ($Backup -and (Test-Path -LiteralPath $Backup)) {
                    Move-Item -LiteralPath $Backup -Destination $Unit.Detect -Force
                    $result.Status = 'restored'
                    $result.Message = "Put back the file that was there before."
                }
                else {
                    $result.Status = 'removed'
                }
            }

            'Module' {
                if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Uninstall Gallery module')) {
                    $result.Status = 'skipped'
                    break
                }

                Uninstall-Module -Name $Unit.Detect -AllVersions -Force -ErrorAction Stop
                $result.Status = 'removed'
            }

            'Package' {
                $package = if ($Manager -eq 'Chocolatey') { $Unit.Chocolatey } else { $Unit.Winget }

                if (-not $package) {
                    $result.Status = 'skipped'
                    $result.Message = "No package id is recorded for $Manager."
                    break
                }

                if (-not $PSCmdlet.ShouldProcess($package, "$Manager uninstall")) {
                    $result.Status = 'skipped'
                    break
                }

                if ($Manager -eq 'Chocolatey') {
                    & choco uninstall $package -y --limit-output
                }
                else {
                    & winget uninstall --exact --id $package --silent
                }

                if ($LASTEXITCODE -ne 0) {
                    $result.Message = "$Manager exited with code $LASTEXITCODE."
                    break
                }

                $result.Status = 'removed'
            }

            'Font' {
                # Left in place on purpose. Windows keeps a font loaded until a restart, other
                # programs may have picked it up, and deleting from the machine font directory
                # needs elevation for a cosmetic gain.
                $result.Status = 'skipped'
                $result.Message = "Fonts are left installed. Remove $($Unit.Detect) from Settings if you want it gone."
            }

            default {
                $result.Message = "Unknown Kind '$($Unit.Kind)'."
            }
        }
    }
    catch {
        $result.Status = 'failed'
        $result.Message = $_.Exception.Message
    }

    return $result
}

function Uninstall-ProfileSetup {
    <#
    .SYNOPSIS
        Removes what this installer put on the machine, and nothing else.

    .DESCRIPTION
        Reads the receipt, not the machine. A unit is removed only when Get-ProfileSetupState
        reports it Removable: present, recorded as installed by this installer, and not Required.

        Everything else is reported with the reason it was left alone. On a machine where the
        profile was cloned rather than installed, that is every unit, and the correct outcome is
        that nothing is touched.

        -Confirm is on by default because this deletes files. Pass -Confirm:$false to run it
        unattended.

    .PARAMETER Id
        Catalog ids to remove. Omit to remove everything this installer owns.

    .PARAMETER Category
        Remove everything owned in these categories.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .OUTPUTS
        [PSCustomObject[]] One result per unit: Id, Status, Message.

    .EXAMPLE
        Uninstall-ProfileSetup -WhatIf
        Reports what it would remove without removing it.

    .EXAMPLE
        Uninstall-ProfileSetup -Id fzf
        Removes fzf, if this installer is the one that added it.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias('profile-uninstall')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]$Id,

        [Parameter()]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$ReceiptPath
    )

    begin {
        $selected = [System.Collections.Generic.List[string]]::new()
    }

    process {
        foreach ($name in @($Id)) { if ($name) { $selected.Add($name) } }
    }

    end {
        # Splatted rather than passed as arguments: [ValidateSet] rejects the $null an unbound
        # -Category arrives as, so the parameter has to be absent instead of empty.
        $filter = @{}
        if ($Category) { $filter['Category'] = $Category }
        if ($InstallPath) { $filter['InstallPath'] = $InstallPath }
        if ($ReceiptPath) { $filter['ReceiptPath'] = $ReceiptPath }

        $catalogFilter = @{}
        if ($InstallPath) { $catalogFilter['InstallPath'] = $InstallPath }

        $state = @(Get-ProfileSetupState @filter)
        $catalog = @{}
        foreach ($unit in (Get-ProfileSetupCatalog @catalogFilter)) { $catalog[$unit.Id] = $unit }

        if ($selected.Count) {
            $unknown = @($selected | Where-Object { -not $catalog.ContainsKey($_) })
            if ($unknown.Count) {
                throw "No such setup unit: $($unknown -join ', '). Run Get-ProfileSetupCatalog to see the ids."
            }
            $state = @($state | Where-Object { $_.Id -in $selected })
        }

        $entries = @{}
        foreach ($entry in (Get-ProfileSetupReceipt -Path $ReceiptPath).Entries) { $entries[$entry.Id] = $entry }

        foreach ($row in $state) {
            if (-not $row.Removable) {
                $reason = if ($row.Required) { 'Required by the profile.' }
                elseif (-not $row.Owned) { 'This installer did not install it, so it is not ours to remove.' }
                else { 'Not on this machine.' }

                [PSCustomObject]@{ Id = $row.Id; Status = 'skipped'; Message = $reason }
                continue
            }

            $entry = $entries[$row.Id]
            $result = Remove-ProfileSetupUnit -Unit $catalog[$row.Id] -Backup $entry.Backup -Manager $entry.Manager

            if ($result.Status -in 'removed', 'restored') {
                Remove-ProfileSetupReceiptEntry -Id $row.Id -Path $ReceiptPath
            }

            $result
        }
    }
}
