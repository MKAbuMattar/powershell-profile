#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Dependency installation
#
# Dot-sourced by Loader.psm1. Keeping installation out of the import path is the point: the old
# profile called Install-Module during startup, and Directory.psm1 ran `winget install` when
# zoxide was missing. Installing software is now something the user asks for.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

# Command-line tools the profile uses directly, with the winget package that provides each.
$script:NativeDependency = [ordered]@{
    starship = 'Starship.Starship'
    zoxide   = 'ajeetdsouza.zoxide'
    fzf       = 'junegunn.fzf'
    fastfetch = 'Fastfetch-cli.Fastfetch'
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
            Kind      = 'Module'
            Name      = $name
            Installed = [bool](Get-Module -ListAvailable -Name $name)
            Package   = $name
        }
    }

    foreach ($name in $script:NativeDependency.Keys) {
        [PSCustomObject]@{
            Kind      = 'Tool'
            Name      = $name
            Installed = [bool](Get-Command -Name $name -CommandType Application -ErrorAction SilentlyContinue)
            Package   = $script:NativeDependency[$name]
        }
    }

    $python = $null
    foreach ($candidate in 'python3', 'python') {
        $found = Get-Command -Name $candidate -CommandType Application -ErrorAction SilentlyContinue
        if ($found) { $python = $found; break }
    }

    [PSCustomObject]@{
        Kind      = 'Runtime'
        Name      = 'python'
        Installed = [bool]$python
        Package   = 'Python.Python.3.12'
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

    .OUTPUTS
        None.

    .EXAMPLE
        Install-ProfileDependency -WhatIf
        Shows what would be installed without installing it.

    .EXAMPLE
        Install-ProfileDependency
        Installs the missing Gallery modules and command-line tools.

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
        [string]$Scope = 'CurrentUser'
    )

    $missing = @(Get-ProfileDependency -RepositoryRoot $RepositoryRoot | Where-Object { -not $_.Installed })

    if (-not $missing.Count) {
        Write-Host 'Every profile dependency is already installed.' -ForegroundColor Green
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
                if (-not (Get-Command -Name winget -CommandType Application -ErrorAction SilentlyContinue)) {
                    Write-Warning "$($dependency.Name) is missing and winget is not available to install it."
                    continue
                }

                if ($PSCmdlet.ShouldProcess($dependency.Package, 'winget install')) {
                    Write-Host "Installing $($dependency.Name) via winget..."
                    & winget install --exact --id $dependency.Package --accept-source-agreements --accept-package-agreements
                }
            }

            'Runtime' {
                Write-Warning "Python was not found. Eleven utility modules need it. Install it with: winget install --id $($dependency.Package)"
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
