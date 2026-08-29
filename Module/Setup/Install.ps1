#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup install
#
# Dot-sourced by Setup.psm1.
#
# Installs the units a caller selected and writes down what it did. The receipt entry is written
# after the unit installs, never before, so a failed install leaves no claim of ownership behind
# for Uninstall-ProfileSetup to act on.
#
# Every function here switches on Kind and nothing else. Adding a tool means adding a catalog row.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Resolve-ProfileSetupManager {
    <#
    .SYNOPSIS
        Picks the package manager to install with.

    .DESCRIPTION
        winget first: it installs the profile's tools without an elevated session, and Chocolatey
        does not.

    .PARAMETER Preference
        Auto, Winget, Chocolatey or None.

    .OUTPUTS
        [string] Winget, Chocolatey or None.

    .EXAMPLE
        Resolve-ProfileSetupManager -Preference Auto

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('Auto', 'Winget', 'Chocolatey', 'None')]
        [string]$Preference = 'Auto'
    )

    if ($Preference -ne 'Auto') { return $Preference }

    if (Get-Command -Name winget -CommandType Application -ErrorAction SilentlyContinue) { return 'Winget' }
    if (Get-Command -Name choco -CommandType Application -ErrorAction SilentlyContinue) { return 'Chocolatey' }

    return 'None'
}

function Copy-ProfileSetupItem {
    <#
    .SYNOPSIS
        Copies a file or directory into place, keeping a copy of whatever it displaced.

    .DESCRIPTION
        Returns the backup path when something was displaced, so the caller can record it and
        Uninstall-ProfileSetup can put the original back rather than deleting a file the user had
        before this ever ran.

    .PARAMETER Source
        What to copy.

    .PARAMETER Destination
        Where it goes.

    .OUTPUTS
        [string] The backup path, or an empty string when nothing was displaced.

    .EXAMPLE
        Copy-ProfileSetupItem -Source $repo/profile.config.psd1 -Destination $target

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Source,

        [Parameter(Mandatory, Position = 1)]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Nothing to copy: $Source does not exist."
    }

    if (-not $PSCmdlet.ShouldProcess($Destination, 'Install')) { return '' }

    $parent = Split-Path -Parent $Destination
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    $backup = ''
    if (Test-Path -LiteralPath $Destination) {
        $backup = "$Destination.profile-backup"
        if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }
        Move-Item -LiteralPath $Destination -Destination $backup -Force
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force

    return $backup
}

function Install-ProfileSetupUnit {
    <#
    .SYNOPSIS
        Installs one catalog unit and reports what happened.

    .DESCRIPTION
        Returns a result rather than throwing, because one failing unit must not abandon the rest
        of a selection. Status is one of installed, present, skipped or failed.

    .PARAMETER Unit
        A row from Get-ProfileSetupCatalog.

    .PARAMETER Repository
        Root of a checkout or extracted archive, for File and Tree units.

    .PARAMETER Manager
        Winget, Chocolatey or None.

    .OUTPUTS
        [PSCustomObject] Id, Status, Backup, Message.

    .EXAMPLE
        Install-ProfileSetupUnit -Unit $unit -Repository $repo -Manager Winget

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Unit,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$Manager = 'None'
    )

    $result = [PSCustomObject]@{ Id = $Unit.Id; Status = 'failed'; Backup = ''; Message = '' }

    try {
        switch ($Unit.Kind) {

            { $_ -in 'File', 'Tree' } {
                if (-not $Repository) {
                    $result.Status = 'skipped'
                    $result.Message = 'No repository was supplied to copy from.'
                    break
                }

                $source = Join-Path $Repository $Unit.Source
                $result.Backup = Copy-ProfileSetupItem -Source $source -Destination $Unit.Detect
                $result.Status = 'installed'
                $result.Message = "-> $($Unit.Detect)"
            }

            'Module' {
                if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Install Gallery module')) {
                    $result.Status = 'skipped'
                    break
                }

                Install-Module -Name $Unit.Detect -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck -ErrorAction Stop
                $result.Status = 'installed'
            }

            'Package' {
                $package = if ($Manager -eq 'Winget') { $Unit.Winget } elseif ($Manager -eq 'Chocolatey') { $Unit.Chocolatey } else { $null }

                if (-not $package) {
                    $result.Status = 'skipped'
                    $result.Message = "No $Manager package is defined for this tool."
                    break
                }

                if (-not $PSCmdlet.ShouldProcess($package, "$Manager install")) {
                    $result.Status = 'skipped'
                    break
                }

                if ($Manager -eq 'Winget') {
                    & winget install --exact --id $package --accept-source-agreements --accept-package-agreements --silent
                }
                else {
                    & choco install $package -y --limit-output
                }

                if ($LASTEXITCODE -ne 0) {
                    $result.Message = "$Manager exited with code $LASTEXITCODE."
                    break
                }

                $result.Status = 'installed'
            }

            'Font' {
                $result = Install-ProfileSetupFont -Unit $Unit
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

function Install-ProfileSetupFont {
    <#
    .SYNOPSIS
        Installs the Nerd Font the prompt draws with.

    .DESCRIPTION
        Fonts go into the machine font directory through the shell namespace, which registers them.
        That needs an elevated session, so an unelevated caller gets a skip with a reason rather
        than a failure it cannot act on.

    .PARAMETER Unit
        The Font catalog row.

    .OUTPUTS
        [PSCustomObject] Id, Status, Backup, Message.

    .EXAMPLE
        Install-ProfileSetupFont -Unit $unit

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Unit
    )

    $result = [PSCustomObject]@{ Id = $Unit.Id; Status = 'failed'; Backup = ''; Message = '' }

    $identity = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $result.Status = 'skipped'
        $result.Message = 'Installing a font needs an elevated session.'
        return $result
    }

    if (-not $PSCmdlet.ShouldProcess($Unit.Detect, 'Install font')) {
        $result.Status = 'skipped'
        return $result
    }

    $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-font-" + [guid]::NewGuid().ToString('N'))
    $archive = "$workspace.zip"

    try {
        $null = New-Item -ItemType Directory -Path $workspace -Force

        Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip' -OutFile $archive -UseBasicParsing
        Expand-Archive -Path $archive -DestinationPath $workspace -Force

        $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
        $installed = 0

        foreach ($file in Get-ChildItem -LiteralPath $workspace -Recurse -Filter '*.ttf') {
            if (Test-Path -LiteralPath (Join-Path $env:WINDIR "Fonts\$($file.Name)")) { continue }
            $fonts.CopyHere($file.FullName, 0x10)
            $installed++
        }

        $result.Status = 'installed'
        $result.Message = "$installed font file(s)"
    }
    catch {
        $result.Message = $_.Exception.Message
    }
    finally {
        Remove-Item -LiteralPath $workspace -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue
    }

    return $result
}

function Invoke-ProfileSetup {
    <#
    .SYNOPSIS
        Installs the selected units and records what it installed.

    .DESCRIPTION
        A unit already on the machine is reported as present and left alone unless -Force is given,
        so re-running is cheap and does not reinstall what is already there.

        The receipt entry is written only after a unit installs. A failure leaves no ownership
        claim, so a later uninstall cannot try to remove something this never put there.

    .PARAMETER Id
        Catalog ids to install. Omit to install everything not yet present.

    .PARAMETER Category
        Install everything in these categories.

    .PARAMETER Repository
        Root of a checkout or extracted archive, needed for File and Tree units.

    .PARAMETER InstallPath
        Where the Module tree goes. Defaults to the directory holding $PROFILE.

    .PARAMETER PackageManager
        Auto, Winget, Chocolatey or None.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .PARAMETER Force
        Install a unit even when it is already present.

    .OUTPUTS
        [PSCustomObject[]] One result per unit: Id, Status, Backup, Message.

    .EXAMPLE
        Invoke-ProfileSetup -Id fzf, zoxide
        Installs those two tools.

    .EXAMPLE
        Invoke-ProfileSetup -Category Tool -WhatIf
        Reports which tools it would install.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('profile-install')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]$Id,

        [Parameter()]
        [ValidateSet('Core', 'Config', 'Tool', 'Font', 'Module', 'System')]
        [string[]]$Category,

        [Parameter()]
        [string]$Repository,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [ValidateSet('Auto', 'Winget', 'Chocolatey', 'None')]
        [string]$PackageManager = 'Auto',

        [Parameter()]
        [string]$ReceiptPath,

        [Parameter()]
        [switch]$Force
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

        $manager = Resolve-ProfileSetupManager -Preference $PackageManager

        foreach ($row in $state) {
            if ($row.Present -and -not $Force) {
                [PSCustomObject]@{ Id = $row.Id; Status = 'present'; Backup = ''; Message = 'Already installed.' }
                continue
            }

            $result = Install-ProfileSetupUnit -Unit $catalog[$row.Id] -Repository $Repository -Manager $manager

            if ($result.Status -eq 'installed') {
                Add-ProfileSetupReceiptEntry -Id $row.Id -Backup $result.Backup -Manager $manager -Path $ReceiptPath
            }

            $result
        }
    }
}

function Update-ProfileSetup {
    <#
    .SYNOPSIS
        Refreshes what is already installed, and adds nothing.

    .DESCRIPTION
        Install and update are different jobs and the difference matters.

        Invoke-ProfileSetup adds what a person picked. Running it again to pick up a new version
        would either report everything as already present and do nothing, or with -Force reinstall
        the lot, including the units the person deliberately left out.

        This refreshes the units that are already there, and only those: the Module tree, the
        maintenance scripts, the profile, and any configuration file this installer owns. Nothing
        absent is added, so a machine that never wanted FastFetch does not acquire it on an update.

        profile.config.psd1 is never overwritten. It holds the choices about what loads at every
        shell start, which are the user's, not the repository's. -IncludeConfig overrides that and
        says so in the result.

    .PARAMETER Repository
        A checkout or extracted archive to refresh from.

    .PARAMETER InstallPath
        Where the Module tree lives.

    .PARAMETER ReceiptPath
        Override the receipt location. For tests.

    .PARAMETER IncludeConfig
        Replace profile.config.psd1 as well. The current one is backed up first.

    .OUTPUTS
        [PSCustomObject[]] One result per unit: Id, Status, Backup, Message.

    .EXAMPLE
        Update-ProfileSetup -Repository $checkout
        Refreshes the installed pieces from that checkout.

    .EXAMPLE
        Update-ProfileSetup -Repository $checkout -WhatIf
        Reports what it would refresh.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('profile-update')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Repository,

        [Parameter()]
        [string]$InstallPath,

        [Parameter()]
        [string]$ReceiptPath,

        [Parameter()]
        [switch]$IncludeConfig
    )

    $filter = @{}
    if ($InstallPath) { $filter['InstallPath'] = $InstallPath }
    if ($ReceiptPath) { $filter['ReceiptPath'] = $ReceiptPath }

    $catalog = @{}
    $catalogFilter = @{}
    if ($InstallPath) { $catalogFilter['InstallPath'] = $InstallPath }
    foreach ($unit in (Get-ProfileSetupCatalog @catalogFilter)) { $catalog[$unit.Id] = $unit }

    foreach ($row in (Get-ProfileSetupState @filter)) {

        # Only what is copied from the repository can be refreshed from it. A package or a Gallery
        # module is updated by winget or Install-Module, not by this.
        if ($catalog[$row.Id].Kind -notin 'File', 'Tree') { continue }

        # Owned, not merely present. Several units point at absolute user paths rather than at
        # anything under InstallPath: $PROFILE, ~/.config/starship.toml, the Windows Terminal
        # settings. Refreshing on Present alone reaches straight past a scratch install path and
        # overwrites the real ones, which is what it did before this check existed.
        if (-not $row.Owned) {
            [PSCustomObject]@{
                Id = $row.Id; Status = 'skipped'; Backup = ''
                Message = 'This installer did not install it, so it is not ours to refresh.'
            }
            continue
        }

        if (-not $row.Present) {
            [PSCustomObject]@{ Id = $row.Id; Status = 'skipped'; Backup = ''; Message = 'Not installed, so there is nothing to refresh.' }
            continue
        }

        if ($row.Id -eq 'config' -and -not $IncludeConfig) {
            [PSCustomObject]@{
                Id = 'config'; Status = 'skipped'; Backup = ''
                Message = 'Your choices about what loads are kept. Pass -IncludeConfig to replace them.'
            }
            continue
        }

        $result = Install-ProfileSetupUnit -Unit $catalog[$row.Id] -Repository $Repository

        if ($result.Status -eq 'installed') {
            $result.Status = 'refreshed'
            Add-ProfileSetupReceiptEntry -Id $row.Id -Backup $result.Backup -Path $ReceiptPath
        }

        $result
    }
}
