#Requires -Version 5.1
<#
.SYNOPSIS
    Renders the Setup module and a launcher as one self-contained script.

.DESCRIPTION
    Dot-source this to get Format-InstallerScript, shared by Tools/Build-Installer.ps1 (which
    writes the file) and Tools/Test-Installer.ps1 (which verifies it). One implementation means
    built and checked cannot disagree, the same arrangement Update-Manifest and Test-Manifest use.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

Set-StrictMode -Version Latest

# The order the module dot-sources them in. Brand first because Picker and Window both call it.
$script:InstallerPart = @(
    'Brand.ps1'
    'Catalog.ps1'
    'State.ps1'
    'Config.ps1'
    'Install.ps1'
    'Uninstall.ps1'
    'Picker.ps1'
    'Window.ps1'
)

function Get-InstallerPartName {
    <#
    .SYNOPSIS
        Returns the Setup sources that go into the built script, in order.

    .OUTPUTS
        [string[]] File names, relative to Module/Setup.

    .EXAMPLE
        Get-InstallerPartName

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    return $script:InstallerPart
}

function Format-InstallerScript {
    <#
    .SYNOPSIS
        Returns the full text of the built installer.

    .DESCRIPTION
        Concatenates the Setup sources and appends a launcher that downloads the repository and
        opens the picker.

        The dot-source lines in Setup.psm1 are not carried over: the sources are already inlined,
        and a dot-source of a path that does not exist would throw on the first line.

    .PARAMETER Path
        Repository root.

    .OUTPUTS
        [string] The script, newline-normalised.

    .EXAMPLE
        Format-InstallerScript -Path .

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    $version = (Get-Content -LiteralPath (Join-Path $Path 'VERSION') -Raw).Trim()

    $lines = [System.Collections.Generic.List[string]]::new()

    $lines.Add('#---------------------------------------------------------------------------------------------------')
    $lines.Add("# MKAbuMattar's PowerShell Profile - installer")
    $lines.Add('#')
    $lines.Add('# GENERATED FILE. Do not edit.')
    $lines.Add('#')
    $lines.Add('# Built from Module/Setup by Tools/Build-Installer.ps1. Change a source there and rebuild;')
    $lines.Add('# Tools/Test-Installer.ps1 fails CI when this file and those sources disagree.')
    $lines.Add('#')
    $lines.Add("# Version: $version")
    $lines.Add('#')
    $lines.Add('# Run it with:')
    $lines.Add('#')
    $lines.Add('#   irm https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/build/profileutil.ps1 | iex')
    $lines.Add('#')
    $lines.Add('# https://github.com/MKAbuMattar/powershell-profile')
    $lines.Add('#---------------------------------------------------------------------------------------------------')
    $lines.Add('')

    # param() has to be the first statement, and it does bind when the text is turned into a
    # scriptblock and invoked with arguments, which is how the README documents passing flags.
    $lines.Add('param(')
    $lines.Add('    [Parameter()]')
    $lines.Add('    [switch]$Console,')
    $lines.Add('')
    $lines.Add('    [Parameter()]')
    $lines.Add('    [string]$Branch = ''main''')
    $lines.Add(')')
    $lines.Add('')
    $lines.Add('$ErrorActionPreference = ''Stop''')
    $lines.Add('')

    # #Requires is not enforced when a script arrives through Invoke-Expression, which is the
    # documented way to run this, so the version gate is an ordinary check that actually runs.
    $lines.Add('if ($PSVersionTable.PSVersion.Major -lt 7) {')
    $lines.Add('    Write-Host "This installer needs PowerShell 7 or later. You are on $($PSVersionTable.PSVersion)." -ForegroundColor Red')
    $lines.Add('    Write-Host "Install it with: winget install --id Microsoft.PowerShell"')
    $lines.Add('    return')
    $lines.Add('}')
    $lines.Add('')

    foreach ($part in Get-InstallerPartName) {
        $file = Join-Path $Path "Module/Setup/$part"
        if (-not (Test-Path -LiteralPath $file)) {
            throw "The installer needs Module/Setup/$part and it is not there."
        }

        $lines.Add('#---------------------------------------------------------------------------------------------------')
        $lines.Add("# Module/Setup/$part")
        $lines.Add('#---------------------------------------------------------------------------------------------------')
        $lines.Add('')

        $body = (Get-Content -LiteralPath $file -Raw) -replace "`r`n", "`n"

        # Every part is dot-sourced by Setup.psm1 in the module. Here they are already inlined, so
        # a dot-source line would point at a path that does not exist.
        foreach ($line in ($body -split "`n")) {
            if ($line -match '^\s*\.\s+\(Join-Path \$PSScriptRoot') { continue }
            $lines.Add($line)
        }

        $lines.Add('')
    }

    $lines.Add('#---------------------------------------------------------------------------------------------------')
    $lines.Add('# Launcher')
    $lines.Add('#---------------------------------------------------------------------------------------------------')
    $lines.Add('')
    $lines.Add('function Get-ProfileInstallerRepository {')
    $lines.Add('    <#')
    $lines.Add('    .SYNOPSIS')
    $lines.Add('        Downloads the repository the file and directory units are copied from.')
    $lines.Add('')
    $lines.Add('    .DESCRIPTION')
    $lines.Add('        $PSScriptRoot is empty when a script arrives through Invoke-Expression, so there is no')
    $lines.Add('        checkout beside this file to copy from. The archive is fetched into a temporary')
    $lines.Add('        directory and its path returned.')
    $lines.Add('')
    $lines.Add('    .OUTPUTS')
    $lines.Add('        [string] Path to the extracted repository.')
    $lines.Add('    #>')
    $lines.Add('    [CmdletBinding()]')
    $lines.Add('    [OutputType([string])]')
    $lines.Add('    param(')
    $lines.Add('        [Parameter(Position = 0)]')
    $lines.Add('        [string]$Branch = ''main''')
    $lines.Add('    )')
    $lines.Add('')
    $lines.Add('    $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-installer-" + [guid]::NewGuid().ToString(''N''))')
    $lines.Add('    $archive = "$workspace.tar.gz"')
    $lines.Add('    $null = New-Item -ItemType Directory -Path $workspace -Force')
    $lines.Add('')
    $lines.Add('    Write-Host "Downloading the profile..."')
    $lines.Add('    Invoke-WebRequest -Uri "https://codeload.github.com/MKAbuMattar/powershell-profile/tar.gz/refs/heads/$Branch" -OutFile $archive -UseBasicParsing')
    $lines.Add('')
    $lines.Add('    & tar -xzf $archive -C $workspace')
    $lines.Add('    if ($LASTEXITCODE -ne 0) { throw "tar exited with code $LASTEXITCODE." }')
    $lines.Add('')
    $lines.Add('    Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue')
    $lines.Add('')
    $lines.Add('    $extracted = Get-ChildItem -LiteralPath $workspace -Directory | Select-Object -First 1')
    $lines.Add('    if (-not $extracted) { throw "The archive did not contain the expected directory." }')
    $lines.Add('')
    $lines.Add('    return $extracted.FullName')
    $lines.Add('}')
    $lines.Add('')
    $lines.Add('function Invoke-ProfileInstaller {')
    $lines.Add('    <#')
    $lines.Add('    .SYNOPSIS')
    $lines.Add('        Opens the picker.')
    $lines.Add('')
    $lines.Add('    .DESCRIPTION')
    $lines.Add('        The window when this host can show one, the console list otherwise. -Console forces the')
    $lines.Add('        console list.')
    $lines.Add('')
    $lines.Add('    .PARAMETER Console')
    $lines.Add('        Use the console picker even where a window would work.')
    $lines.Add('')
    $lines.Add('    .PARAMETER Branch')
    $lines.Add('        Repository branch to install from.')
    $lines.Add('')
    $lines.Add('    .OUTPUTS')
    $lines.Add('        None.')
    $lines.Add('    #>')
    $lines.Add('    [CmdletBinding()]')
    $lines.Add('    [OutputType([void])]')
    $lines.Add('    param(')
    $lines.Add('        [Parameter()]')
    $lines.Add('        [switch]$Console,')
    $lines.Add('')
    $lines.Add('        [Parameter()]')
    $lines.Add('        [string]$Branch = ''main''')
    $lines.Add('    )')
    $lines.Add('')
    $lines.Add('    $repository = Get-ProfileInstallerRepository -Branch $Branch')
    $lines.Add('')
    $lines.Add('    if (-not $Console -and (Get-ProfileSetupWindowSupport).Supported) {')
    $lines.Add('        Show-ProfileSetupWindow -Repository $repository')
    $lines.Add('    }')
    $lines.Add('    else {')
    $lines.Add('        Show-ProfileSetup -Repository $repository')
    $lines.Add('    }')
    $lines.Add('}')
    $lines.Add('')
    $lines.Add('Invoke-ProfileInstaller -Console:$Console -Branch $Branch')

    return (($lines -join "`n").TrimEnd() + "`n")
}
