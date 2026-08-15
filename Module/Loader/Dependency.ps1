#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Dependency installation
#
# Dot-sourced by Loader.psm1. Keeping installation out of the import path is the point: the old
# profile called Install-Module during startup, and Directory.psm1 ran `winget install` when
# zoxide was missing. Installing software is now something the user asks for.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

# Command-line tools the profile itself uses, with the package id each manager knows them by.
#
# Plugin tools are deliberately absent. kubectl, terraform, docker and the rest are gated on
# already being installed, so a plugin costs nothing on a machine without its tool, and installing
# Kubernetes tooling because someone wanted a nicer prompt would be presumptuous.
$script:NativeDependency = [ordered]@{
    starship  = @{
        Winget = 'Starship.Starship'; Chocolatey = 'starship'
        Required = $true;  Purpose = 'the prompt itself'
    }
    zoxide    = @{
        Winget = 'ajeetdsouza.zoxide'; Chocolatey = 'zoxide'
        Required = $true;  Purpose = 'cd, and the z / zi jump commands'
    }
    git       = @{
        Winget = 'Git.Git'; Chocolatey = 'git'
        Required = $true;  Purpose = 'the Git plugin, and update checks'
    }
    fzf       = @{
        Winget = 'junegunn.fzf'; Chocolatey = 'fzf'
        Required = $false; Purpose = "zoxide's interactive zi picker"
    }
    fastfetch = @{
        Winget = 'Fastfetch-cli.Fastfetch'; Chocolatey = 'fastfetch'
        Required = $false; Purpose = 'the optional startup banner'
    }
}

function Resolve-ProfilePackageManager {
    <#
    .SYNOPSIS
        Decides which package manager to install with, asking when it is reasonable to ask.

    .DESCRIPTION
        Honours an explicit preference. Otherwise: returns None when neither winget nor Chocolatey
        is present, the only one available when just one is, and asks when both are and the
        session can be prompted. A session that cannot be prompted gets winget, because it ships
        with Windows and needs no elevation for these packages.

    .PARAMETER Preference
        Ask, Winget, Chocolatey or None.

    .OUTPUTS
        [string] Winget, Chocolatey or None.

    .EXAMPLE
        Resolve-ProfilePackageManager -Preference Ask

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [ValidateSet('Ask', 'Winget', 'Chocolatey', 'None')]
        [string]$Preference = 'Ask'
    )

    if ($Preference -ne 'Ask') { return $Preference }

    $hasWinget = [bool](Get-Command winget -CommandType Application -ErrorAction SilentlyContinue)
    $hasChoco = [bool](Get-Command choco -CommandType Application -ErrorAction SilentlyContinue)

    if (-not $hasWinget -and -not $hasChoco) {
        Write-Warning 'Neither winget nor Chocolatey is available. Install "App Installer" from the Microsoft Store to get winget.'
        return 'None'
    }

    if ($hasWinget -and -not $hasChoco) { return 'Winget' }
    if ($hasChoco -and -not $hasWinget) { return 'Chocolatey' }

    if ([System.Console]::IsInputRedirected -or -not $Host.UI.RawUI) { return 'Winget' }

    $choices = @(
        [System.Management.Automation.Host.ChoiceDescription]::new('&Winget', 'Ships with Windows. No elevation needed.')
        [System.Management.Automation.Host.ChoiceDescription]::new('&Chocolatey', 'Needs an elevated shell.')
        [System.Management.Automation.Host.ChoiceDescription]::new('&Skip', 'Do not install command-line tools.')
    )

    switch ($Host.UI.PromptForChoice('Package manager', 'Install the command-line tools with which package manager?', $choices, 0)) {
        0 { return 'Winget' }
        1 { return 'Chocolatey' }
        default { return 'None' }
    }
}

function Get-ProfileDependency {
    <#
    .SYNOPSIS
        Lists what the profile wants installed and whether it is present.

    .DESCRIPTION
        Covers both halves of the dependency set: the PowerShell Gallery modules named in
        ExternalModules, and the command-line tools the profile shells out to. Reports the
        Python interpreter too, because eleven utility modules depend on one.

    .PARAMETER RepositoryRoot
        Directory containing profile.config.psd1. Defaults to the profile root.

    .OUTPUTS
        [PSCustomObject[]] One row per dependency with Kind, Name, Installed and Package.

    .EXAMPLE
        Get-ProfileDependency
        Lists every dependency and its status.

    .EXAMPLE
        Get-ProfileDependency | Where-Object { -not $_.Installed }
        Shows only what is missing.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-deps')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [string]$RepositoryRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    )

    $config = Get-ProfileConfig -Path (Join-Path $RepositoryRoot 'profile.config.psd1')

    foreach ($name in $config.ExternalModules) {
        [PSCustomObject]@{
            Kind       = 'Module'
            Name       = $name
            Installed  = [bool](Get-Module -ListAvailable -Name $name)
            Required   = $true
            Package    = $name
            Chocolatey = $null
            Purpose    = 'imported by the profile at startup'
        }
    }

    foreach ($name in $script:NativeDependency.Keys) {
        $entry = $script:NativeDependency[$name]

        [PSCustomObject]@{
            Kind       = 'Tool'
            Name       = $name
            Installed  = [bool](Get-Command -Name $name -CommandType Application -ErrorAction SilentlyContinue)
            Required   = $entry.Required
            Package    = $entry.Winget
            Chocolatey = $entry.Chocolatey
            Purpose    = $entry.Purpose
        }
    }

    [PSCustomObject]@{
        Kind       = 'Runtime'
        Name       = 'python'
        Installed  = [bool](Get-PythonExecutable)
        Required   = $true
        Package    = 'Python.Python.3.13'
        Chocolatey = 'python'
        Purpose    = 'the bundled utility scripts (QR codes, clock, weather, search)'
    }

    # tar extracts the update archive. It ships with Windows 10 1803 and later, so it is reported
    # rather than installed: if it is genuinely missing, no package manager is the right fix.
    [PSCustomObject]@{
        Kind       = 'System'
        Name       = 'tar'
        Installed  = [bool](Get-Command -Name tar -CommandType Application -ErrorAction SilentlyContinue)
        Required   = $true
        Package    = $null
        Chocolatey = $null
        Purpose    = 'extracting the update archive (ships with Windows)'
    }

    $requirements = Join-Path $RepositoryRoot 'Module/requirements.txt'
    if (Test-Path -LiteralPath $requirements) {
        foreach ($line in Get-Content -LiteralPath $requirements) {
            $trimmed = $line.Trim()
            if (-not $trimmed -or $trimmed.StartsWith('#')) { continue }

            $package = ($trimmed -split '[<>=!~]')[0].Trim()
            $installed = $false

            $python = Get-PythonExecutable
            if ($python) {
                & $python -c "import $package" 2>&1 | Out-Null
                $installed = ($LASTEXITCODE -eq 0)
            }

            [PSCustomObject]@{
                Kind       = 'Python'
                Name       = $package
                Installed  = $installed
                Required   = $false
                Package    = $trimmed
                Chocolatey = $null
                Purpose    = 'ASCII rendering for the clock utility'
            }
        }
    }
}

function Install-ProfileDependency {
    <#
    .SYNOPSIS
        Installs whatever the profile needs and does not have.

    .DESCRIPTION
        Installs missing Gallery modules with Install-Module, and missing command-line tools with
        winget. Nothing is installed without being named first: run with -WhatIf, or call
        Get-ProfileDependency, to see the list before committing to it.

        The Python packages the utility modules need are listed in Module/requirements.txt and
        are installed separately with -IncludePython.

    .PARAMETER RepositoryRoot
        Directory containing profile.config.psd1. Defaults to the profile root.

    .PARAMETER IncludePython
        Also pip install the packages in Module/requirements.txt.

    .PARAMETER Scope
        Install scope for Gallery modules. Defaults to CurrentUser.

    .PARAMETER PackageManager
        Which package manager installs the command-line tools: Winget, Chocolatey, or None to
        skip them. Defaults to Ask, which prompts when both are available and the session is
        interactive, and otherwise picks whichever is installed, preferring winget.

    .OUTPUTS
        None.

    .EXAMPLE
        Install-ProfileDependency -WhatIf
        Shows what would be installed without installing it.

    .EXAMPLE
        Install-ProfileDependency
        Installs the missing Gallery modules and command-line tools, asking which package
        manager to use if both winget and Chocolatey are present.

    .EXAMPLE
        Install-ProfileDependency -PackageManager Chocolatey
        Uses Chocolatey without prompting.

    .EXAMPLE
        Install-ProfileDependency -IncludePython
        Also installs the Python packages the utility modules need.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('install-profile-deps')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$RepositoryRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),

        [switch]$IncludePython,

        [ValidateSet('CurrentUser', 'AllUsers')]
        [string]$Scope = 'CurrentUser',

        [ValidateSet('Ask', 'Winget', 'Chocolatey', 'None')]
        [string]$PackageManager = 'Ask'
    )

    $missing = @(Get-ProfileDependency -RepositoryRoot $RepositoryRoot | Where-Object { -not $_.Installed })

    if (-not $missing.Count) {
        Write-Host 'Every profile dependency is already installed.' -ForegroundColor Green
        return
    }

    # Only decide on a package manager if there is actually a tool to install, so the prompt does
    # not appear when the only thing missing is a Gallery module.
    $manager = if (@($missing | Where-Object { $_.Kind -eq 'Tool' }).Count) {
        Resolve-ProfilePackageManager -Preference $PackageManager
    }
    else {
        'None'
    }

    if ($manager -eq 'Chocolatey') {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        if (-not ([Security.Principal.WindowsPrincipal]$identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Warning 'Chocolatey needs an elevated session. Re-run elevated, or pass -PackageManager Winget.'
            $manager = 'None'
        }
    }

    foreach ($dependency in $missing) {
        switch ($dependency.Kind) {
            'Module' {
                if ($PSCmdlet.ShouldProcess($dependency.Name, 'Install-Module')) {
                    Write-Host "Installing module $($dependency.Name)..."
                    Install-Module -Name $dependency.Name -Scope $Scope -Force -SkipPublisherCheck
                }
            }

            'Tool' {
                if ($manager -eq 'None') {
                    Write-Warning "$($dependency.Name) is missing and no package manager is available to install it."
                    continue
                }

                $package = if ($manager -eq 'Winget') { $dependency.Package } else { $dependency.Chocolatey }

                if (-not $PSCmdlet.ShouldProcess($package, "$manager install")) { continue }

                Write-Host "Installing $($dependency.Name) via $manager..."

                if ($manager -eq 'Winget') {
                    & winget install --exact --id $package --accept-source-agreements --accept-package-agreements --silent
                }
                else {
                    & choco install $package -y --limit-output
                }
            }

            'Runtime' {
                if ($manager -eq 'None') {
                    Write-Warning "Python was not found; the bundled utility scripts need it. Install it with: winget install --id $($dependency.Package)"
                    continue
                }

                $package = if ($manager -eq 'Winget') { $dependency.Package } else { $dependency.Chocolatey }
                if (-not $PSCmdlet.ShouldProcess($package, "$manager install")) { continue }

                Write-Host "Installing Python via $manager..."
                if ($manager -eq 'Winget') {
                    & winget install --exact --id $package --accept-source-agreements --accept-package-agreements --silent
                }
                else {
                    & choco install $package -y --limit-output
                }
            }

            'System' {
                Write-Warning "$($dependency.Name) is missing. It normally ships with Windows; no package manager can supply it."
            }

            'Python' {
                # Handled by -IncludePython so a pip install is never a surprise.
                Write-Host "Python package '$($dependency.Name)' is missing. Run: Install-ProfileDependency -IncludePython" -ForegroundColor DarkGray
            }
        }
    }

    if (-not $IncludePython) { return }

    $requirements = Join-Path $RepositoryRoot 'Module/requirements.txt'
    if (-not (Test-Path -LiteralPath $requirements)) {
        Write-Warning "No requirements file at $requirements."
        return
    }

    $python = Get-PythonExecutable
    if (-not $python) {
        Write-Warning 'Python was not found, so the Python packages were skipped.'
        return
    }

    if ($PSCmdlet.ShouldProcess($requirements, 'pip install -r')) {
        & $python -m pip install --user -r $requirements
    }
}
