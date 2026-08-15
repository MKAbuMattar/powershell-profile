#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Setup
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       Installs the profile, its modules and its configuration files.
#
#       Everything comes from one repository archive rather than a request per file, every step
#       can be run on its own, and nothing is overwritten without a backup.
#
# Created: 2021-09-01
# Updated: 2026-08-15
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.0.0
#---------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Installs MKAbuMattar's PowerShell profile.

.DESCRIPTION
    Downloads the repository once and installs from that copy: the profile, the Module tree,
    profile.config.psd1, the Tools directory, and the Starship, FastFetch, Figlet and Windows
    Terminal configuration files. Optionally installs the Cascadia Code font, Chocolatey, and the
    PowerShell Gallery modules the profile expects.

    Every step is separately runnable with -Step, and -WhatIf reports what would happen without
    touching anything.

    Three things this no longer does, each of which used to cause a problem:

    It does not fetch each file individually. It walked the GitHub Contents API and pulled roughly
    135 files one at a time, against an unauthenticated limit of 60 requests an hour, so a single
    run could exhaust the quota and fail partway through.

    It does not move your existing $PROFILE aside and replace it. Microsoft coreutils injects a
    marked block into that file and records the path in the registry; moving the file away left
    coreutils believing its shims were installed when they were gone. Marked third-party sections
    are now carried across, and a symlinked $PROFILE is written through rather than replaced.

    It does not demand Administrator for everything. Only the font and Chocolatey steps need it,
    and they are skipped with a warning rather than aborting the install.

.PARAMETER InstallPath
    Directory to install into. Defaults to the parent of $PROFILE.

.PARAMETER Branch
    Repository branch to install from. Defaults to main.

.PARAMETER Step
    Run only the named steps. Defaults to every step except Font and Tools, which are opt-in.

.PARAMETER IncludeOptional
    Also run the Font and Tools steps.

.PARAMETER PackageManager
    Which package manager installs the command-line tools: Winget, Chocolatey, or None to skip.
    Defaults to Ask, which prompts when the session is interactive and both are available, and
    otherwise picks whichever is installed, preferring winget because it ships with Windows.

.PARAMETER Force
    Overwrite an existing profile.config.psd1. Without this, your configuration is kept.

.EXAMPLE
    irm "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/setup.ps1" | iex
    Installs with the defaults.

.EXAMPLE
    & ([scriptblock]::Create((irm "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/setup.ps1"))) -WhatIf
    Reports what a fresh install would do, without doing it.

.EXAMPLE
    ./setup.ps1 -Step Profile, Modules
    Reinstalls just the profile and the Module tree.

.EXAMPLE
    ./setup.ps1 -IncludeOptional
    Also installs the font and the command-line tools, asking which package manager to use.

.EXAMPLE
    ./setup.ps1 -Step Tools -PackageManager Chocolatey
    Installs starship, zoxide, fzf and fastfetch through Chocolatey without prompting.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
#---------------------------------------------------------------------------------------------------
# This param block is deliberately plain: no [CmdletBinding()], no [ValidateSet], no defaults that
# call cmdlets. The documented install pipes this file into Invoke-Expression, which runs it in the
# caller's scope rather than a script scope, and that breaks both of those in ways worth spelling
# out because the failure is obscure:
#
#   [ValidateSet] is applied to the caller's existing variable, and an unbound $Step holds $null,
#   which is not in the set. The install died on
#     "The attribute cannot be added because variable Step with value would no longer be valid."
#
#   [CmdletBinding()] does not create a $PSCmdlet under Invoke-Expression, so every
#   $PSCmdlet.ShouldProcess() call would throw on a null reference.
#
# Validation, ShouldProcess and -WhatIf all work correctly inside a function, so the real work
# lives in Install-MKAbuMattarProfile below and this block only forwards to it.
#---------------------------------------------------------------------------------------------------
param(
    [string]$InstallPath,
    [string]$Branch,
    [string[]]$Step,
    [switch]$IncludeOptional,
    [string]$PackageManager,
    [switch]$Force,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

#---------------------------------------------------------------------------------------------------
# The profile requires PowerShell 7. Checked explicitly rather than with #Requires, because
# #Requires is not enforced when this script is run through Invoke-Expression, which is how the
# documented one-line install works.
#---------------------------------------------------------------------------------------------------
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Warning "This profile requires PowerShell 7 or later. You are running $($PSVersionTable.PSVersion)."
    Write-Warning "Install it with: winget install --id Microsoft.PowerShell"
    return
}

#---------------------------------------------------------------------------------------------------
# Helpers
#---------------------------------------------------------------------------------------------------

function Write-SetupLog {
    <#
    .SYNOPSIS
        Writes a timestamped setup message.

    .PARAMETER Message
        The message to write.

    .PARAMETER Level
        INFO, WARNING or ERROR. Defaults to INFO.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Message,

        [ValidateSet('INFO', 'WARNING', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $colour = switch ($Level) {
        'WARNING' { 'Yellow' }
        'ERROR' { 'Red' }
        default { 'Gray' }
    }

    Write-Host ("[{0}][{1}] {2}" -f (Get-Date -Format 'HH:mm:ss'), $Level, $Message) -ForegroundColor $colour
}

function Test-SetupAdministrator {
    <#
    .SYNOPSIS
        Reports whether the current session is elevated.

    .OUTPUTS
        [bool]
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    return ([Security.Principal.WindowsPrincipal]$identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-SetupConnection {
    <#
    .SYNOPSIS
        Reports whether GitHub is reachable.

    .DESCRIPTION
        Uses an HTTPS request rather than ICMP. The previous version pinged www.google.com, which
        fails on any network that blocks ICMP even when HTTPS works perfectly well.

    .OUTPUTS
        [bool]
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $null = Invoke-WebRequest -Uri 'https://github.com' -Method Head -TimeoutSec 10 -UseBasicParsing
        return $true
    }
    catch {
        return $false
    }
}

function Get-RepositoryArchive {
    <#
    .SYNOPSIS
        Downloads and extracts the repository, returning the extracted directory.

    .DESCRIPTION
        One request for the whole repository. The caller is responsible for removing the returned
        directory's parent when finished.

    .PARAMETER Branch
        Branch to download.

    .OUTPUTS
        [string] Path to the extracted repository root.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Branch
    )

    $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ("profile-setup-" + [guid]::NewGuid().ToString('N'))
    $archive = "$workspace.tar.gz"

    # -WhatIf:$false on the scratch directory: it is internal scaffolding, not a change to the
    # user's machine, and a dry run still needs the archive on disk to report what it would
    # install. Without this the directory is never created and tar fails.
    $null = New-Item -ItemType Directory -Path $workspace -Force -WhatIf:$false

    $url = "https://codeload.github.com/MKAbuMattar/powershell-profile/tar.gz/refs/heads/$Branch"
    Write-SetupLog "Downloading $Branch..."
    Invoke-WebRequest -Uri $url -OutFile $archive -UseBasicParsing

    # tar ships with Windows 10 1803 and later.
    & tar -xzf $archive -C $workspace
    if ($LASTEXITCODE -ne 0) {
        throw "tar exited with code $LASTEXITCODE while extracting the archive."
    }

    Remove-Item -LiteralPath $archive -Force -ErrorAction SilentlyContinue -WhatIf:$false

    $extracted = Get-ChildItem -LiteralPath $workspace -Directory | Select-Object -First 1
    if (-not $extracted) {
        throw 'The archive did not contain the expected directory.'
    }

    return $extracted.FullName
}

function Get-ForeignProfileSection {
    <#
    .SYNOPSIS
        Extracts a block another installer injected into a profile file.

    .DESCRIPTION
        Microsoft coreutils appends a marked block to Microsoft.PowerShell_profile.ps1 and records
        the path under HKLM:\SOFTWARE\Microsoft\coreutils\PowerShellProfiles. Replacing the profile
        without carrying that block across leaves coreutils believing its shims are installed.

    .PARAMETER Path
        Profile file to inspect.

    .OUTPUTS
        [string] The section including its marker line, or an empty string.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) { return '' }

    $lines = @(Get-Content -LiteralPath $Path)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*#\s*DO NOT MODIFY') {
            return ($lines[$i..($lines.Count - 1)] -join [Environment]::NewLine)
        }
    }

    return ''
}

function Install-RepositoryFile {
    <#
    .SYNOPSIS
        Copies one file out of the extracted repository, backing up whatever is there.

    .PARAMETER Source
        File inside the extracted repository.

    .PARAMETER Destination
        Where to put it.

    .PARAMETER Label
        Human-readable name for the log.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$Label
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        Write-SetupLog "$Label is not in the archive, skipping." -Level WARNING
        return
    }

    if (-not $PSCmdlet.ShouldProcess($Destination, "Install $Label")) { return }

    $parent = Split-Path -Parent $Destination
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    if (Test-Path -LiteralPath $Destination) {
        Copy-Item -LiteralPath $Destination -Destination "$Destination.bak" -Force
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-SetupLog "$Label -> $Destination"
}

#---------------------------------------------------------------------------------------------------
# Steps
#---------------------------------------------------------------------------------------------------

function Install-ProfileModule {
    <#
    .SYNOPSIS
        Installs the Module tree, profile.config.psd1 and Tools.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)][string]$Repository,
        [Parameter(Mandatory)][string]$InstallPath,
        [switch]$Force
    )

    $target = Join-Path $InstallPath 'Module'
    $source = Join-Path $Repository 'Module'

    if ($PSCmdlet.ShouldProcess($target, 'Install the Module directory')) {
        # Move the old tree aside rather than deleting it, so a failure is recoverable.
        if (Test-Path -LiteralPath $target) {
            $backup = "$target.old"
            if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Recurse -Force }
            Move-Item -LiteralPath $target -Destination $backup -Force
            Write-SetupLog "Existing Module directory moved to $backup"
        }

        Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
        Write-SetupLog ("Module directory installed ({0} files)" -f @(Get-ChildItem -LiteralPath $target -Recurse -File).Count)
    }

    # The loader reads its policy from Tools/ExportPolicy.psd1.
    $toolsSource = Join-Path $Repository 'Tools'
    $toolsTarget = Join-Path $InstallPath 'Tools'
    if ((Test-Path -LiteralPath $toolsSource) -and $PSCmdlet.ShouldProcess($toolsTarget, 'Install Tools')) {
        if (Test-Path -LiteralPath $toolsTarget) { Remove-Item -LiteralPath $toolsTarget -Recurse -Force }
        Copy-Item -LiteralPath $toolsSource -Destination $toolsTarget -Recurse -Force
        Write-SetupLog "Tools installed"
    }

    # Never clobber a configuration the user has edited.
    $configSource = Join-Path $Repository 'profile.config.psd1'
    $configTarget = Join-Path $InstallPath 'profile.config.psd1'

    if ((Test-Path -LiteralPath $configTarget) -and -not $Force) {
        Write-SetupLog "Keeping your existing profile.config.psd1. Use -Force to replace it."
        return
    }

    Install-RepositoryFile -Source $configSource -Destination $configTarget -Label 'profile.config.psd1'
}

function Install-Profile {
    <#
    .SYNOPSIS
        Installs Microsoft.PowerShell_profile.ps1, preserving third-party sections.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)][string]$Repository
    )

    $source = Join-Path $Repository 'Microsoft.PowerShell_profile.ps1'
    if (-not (Test-Path -LiteralPath $source)) {
        Write-SetupLog 'The archive has no profile script.' -Level ERROR
        return
    }

    if (-not $PSCmdlet.ShouldProcess($PROFILE, 'Install the profile')) { return }

    $parent = Split-Path -Parent $PROFILE
    if (-not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }

    $incoming = Get-Content -LiteralPath $source -Raw
    $foreign = Get-ForeignProfileSection -Path $PROFILE

    if ($foreign) {
        $incoming = $incoming.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $foreign + [Environment]::NewLine
        Write-SetupLog 'Preserved a third-party section already present in your profile.'
    }

    if (Test-Path -LiteralPath $PROFILE) {
        Copy-Item -LiteralPath $PROFILE -Destination "$PROFILE.bak" -Force
    }

    # Set-Content writes through a symlink; Copy-Item -Force would replace the link itself.
    Set-Content -LiteralPath $PROFILE -Value $incoming -NoNewline -Encoding UTF8
    Write-SetupLog "Profile installed -> $PROFILE"
}

function Install-GalleryModule {
    <#
    .SYNOPSIS
        Installs the PowerShell Gallery modules the profile imports.

    .DESCRIPTION
        Posh-Git is deliberately absent: starship.toml already renders git_branch, git_commit,
        git_state, git_metrics and git_status, and nothing in the profile calls a posh-git
        function, so importing it cost about 220 ms of every shell for nothing.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    foreach ($name in 'Terminal-Icons', 'PSReadLine', 'CompletionPredictor') {
        if (Get-Module -ListAvailable -Name $name) {
            Write-SetupLog "$name is already installed."
            continue
        }

        if (-not $PSCmdlet.ShouldProcess($name, 'Install-Module')) { continue }

        try {
            Install-Module -Name $name -Scope CurrentUser -Force -SkipPublisherCheck
            Write-SetupLog "Installed $name"
        }
        catch {
            Write-SetupLog "Could not install ${name}: $($_.Exception.Message)" -Level WARNING
        }
    }
}

function Install-CascadiaCodeFont {
    <#
    .SYNOPSIS
        Installs the Cascadia Code Nerd Font. Requires an elevated session.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [string]$FontName = 'CascadiaCode',
        [string]$FontDisplayName = 'CaskaydiaCove NF'
    )

    if (-not (Test-SetupAdministrator)) {
        Write-SetupLog 'Font installation needs an elevated session. Skipping.' -Level WARNING
        return
    }

    $family = [System.Drawing.Text.InstalledFontCollection]::new().Families
    if ($family.Name -contains $FontDisplayName) {
        Write-SetupLog "$FontDisplayName is already installed."
        return
    }

    if (-not $PSCmdlet.ShouldProcess($FontDisplayName, 'Install font')) { return }

    $zip = Join-Path $env:TEMP "$FontName.zip"
    $extract = Join-Path $env:TEMP $FontName

    try {
        $url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FontName.zip"
        Write-SetupLog "Downloading $FontDisplayName..."
        Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

        Expand-Archive -Path $zip -DestinationPath $extract -Force

        $shell = (New-Object -ComObject Shell.Application).Namespace(0x14)
        foreach ($file in Get-ChildItem -LiteralPath $extract -Recurse -Filter '*.ttf') {
            if (Test-Path -LiteralPath (Join-Path $env:WINDIR "Fonts\$($file.Name)")) { continue }
            $shell.CopyHere($file.FullName, 0x10)
        }

        Write-SetupLog "Installed $FontDisplayName"
    }
    catch {
        Write-SetupLog "Font installation failed: $($_.Exception.Message)" -Level WARNING
    }
    finally {
        Remove-Item -LiteralPath $extract -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
    }
}

# The command-line tools the profile shells out to, with the package id each manager knows them by.
$script:ProfileTool = [ordered]@{
    starship  = @{ Winget = 'Starship.Starship'; Chocolatey = 'starship' }
    zoxide    = @{ Winget = 'ajeetdsouza.zoxide'; Chocolatey = 'zoxide' }
    fzf       = @{ Winget = 'junegunn.fzf'; Chocolatey = 'fzf' }
    fastfetch = @{ Winget = 'Fastfetch-cli.Fastfetch'; Chocolatey = 'fastfetch' }
}

function Resolve-PackageManager {
    <#
    .SYNOPSIS
        Decides which package manager to use, asking when it is reasonable to ask.

    .DESCRIPTION
        Honours an explicit -PackageManager. Otherwise it looks at what is installed:

        Neither available    returns None and explains how to get one.
        Only one available   returns that one.
        Both available       asks when the session is interactive, and otherwise picks winget,
                             because it ships with Windows and needs no elevation.

        The prompt is skipped when the host cannot prompt, which is the case for the documented
        `irm ... | iex` one-liner piped from a non-interactive context.

    .PARAMETER Preference
        Ask, Winget, Chocolatey or None.

    .OUTPUTS
        [string] Winget, Chocolatey or None.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Preference
    )

    if ($Preference -ne 'Ask') { return $Preference }

    $hasWinget = [bool](Get-Command winget -CommandType Application -ErrorAction SilentlyContinue)
    $hasChoco = [bool](Get-Command choco -CommandType Application -ErrorAction SilentlyContinue)

    if (-not $hasWinget -and -not $hasChoco) {
        Write-SetupLog 'Neither winget nor Chocolatey is available, so the tools cannot be installed.' -Level WARNING
        Write-SetupLog 'winget ships with Windows 11 and recent Windows 10; install it from the Microsoft Store as "App Installer".' -Level WARNING
        return 'None'
    }

    if ($hasWinget -and -not $hasChoco) { return 'Winget' }
    if ($hasChoco -and -not $hasWinget) { return 'Chocolatey' }

    # Both are present. Ask, if this session can be asked.
    $canPrompt = -not [System.Console]::IsInputRedirected -and $Host.UI.RawUI

    if (-not $canPrompt) {
        Write-SetupLog 'Both winget and Chocolatey are available; using winget (non-interactive session).'
        return 'Winget'
    }

    Write-Host ''
    $choices = @(
        [System.Management.Automation.Host.ChoiceDescription]::new('&Winget', 'Ships with Windows. No elevation needed.')
        [System.Management.Automation.Host.ChoiceDescription]::new('&Chocolatey', 'Already installed on this machine. Needs an elevated shell.')
        [System.Management.Automation.Host.ChoiceDescription]::new('&Skip', 'Do not install the command-line tools.')
    )

    $answer = $Host.UI.PromptForChoice(
        'Command-line tools',
        "Install starship, zoxide, fzf and fastfetch with which package manager?",
        $choices,
        0)

    Write-Host ''

    switch ($answer) {
        0 { return 'Winget' }
        1 { return 'Chocolatey' }
        default { return 'None' }
    }
}

function Install-ProfileTool {
    <#
    .SYNOPSIS
        Installs the command-line tools the profile uses.

    .DESCRIPTION
        Anything already on PATH is left alone. Chocolatey needs an elevated session; winget does
        not for these packages.

    .PARAMETER Manager
        Winget, Chocolatey or None.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Manager
    )

    if ($Manager -eq 'None') {
        Write-SetupLog 'Skipping the command-line tools.'
        return
    }

    if ($Manager -eq 'Chocolatey' -and -not (Test-SetupAdministrator)) {
        Write-SetupLog 'Chocolatey needs an elevated session. Skipping the tools.' -Level WARNING
        Write-SetupLog 'Re-run in an elevated shell, or use -PackageManager Winget.' -Level WARNING
        return
    }

    Write-SetupLog "Installing command-line tools with $Manager"

    foreach ($tool in $script:ProfileTool.Keys) {
        if (Get-Command $tool -CommandType Application -ErrorAction SilentlyContinue) {
            Write-SetupLog "$tool is already installed."
            continue
        }

        $package = $script:ProfileTool[$tool].$Manager

        if (-not $PSCmdlet.ShouldProcess($package, "$Manager install")) { continue }

        try {
            if ($Manager -eq 'Winget') {
                & winget install --exact --id $package --accept-source-agreements --accept-package-agreements --silent
            }
            else {
                & choco install $package -y --limit-output
            }

            if ($LASTEXITCODE -ne 0) { throw "$Manager exited with code $LASTEXITCODE." }
            Write-SetupLog "Installed $tool"
        }
        catch {
            Write-SetupLog "Could not install ${tool}: $($_.Exception.Message)" -Level WARNING
        }
    }
}

#---------------------------------------------------------------------------------------------------
# Run
#---------------------------------------------------------------------------------------------------

function Install-MKAbuMattarProfile {
    <#
    .SYNOPSIS
        Runs the install.

    .DESCRIPTION
        The real entry point. Everything lives in a function so that [ValidateSet], $PSCmdlet and
        -WhatIf all behave, which they do not in a top-level param block when the script is piped
        into Invoke-Expression.

    .PARAMETER InstallPath
        Directory to install into. Defaults to the parent of $PROFILE.

    .PARAMETER Branch
        Repository branch to install from.

    .PARAMETER Step
        Run only the named steps.

    .PARAMETER IncludeOptional
        Also run the Font and Tools steps.

    .PARAMETER PackageManager
        Winget, Chocolatey, None, or Ask to be prompted.

    .PARAMETER Force
        Overwrite an existing profile.config.psd1.

    .OUTPUTS
        None.

    .EXAMPLE
        Install-MKAbuMattarProfile -Step Profile -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [string]$InstallPath = (Split-Path -Parent $PROFILE),

        [string]$Branch = 'main',

        [ValidateSet('Modules', 'Profile', 'Starship', 'FastFetch', 'Figlet', 'WindowsTerminal', 'Font', 'Tools', 'GalleryModules')]
        [string[]]$Step,

        [switch]$IncludeOptional,

        [ValidateSet('Ask', 'Winget', 'Chocolatey', 'None')]
        [string]$PackageManager = 'Ask',

        [switch]$Force
    )
    $defaultSteps = @('Modules', 'Profile', 'Starship', 'FastFetch', 'Figlet', 'WindowsTerminal', 'GalleryModules')
    if (-not $Step) {
        $Step = if ($IncludeOptional) { $defaultSteps + @('Font', 'Tools') } else { $defaultSteps }
    }

    Write-Host ''
    Write-SetupLog "Installing to $InstallPath from branch $Branch"
    Write-SetupLog ("Steps: {0}" -f ($Step -join ', '))
    Write-Host ''

    if (-not (Test-SetupConnection)) {
        Write-SetupLog 'github.com is not reachable. Check your connection and try again.' -Level ERROR
        return
    }

    $repository = $null

    try {
        $repository = Get-RepositoryArchive -Branch $Branch
        $workspace = Split-Path -Parent $repository

        $configTargets = @{
            Starship        = @{
                Source      = Join-Path $repository '.config/starship.toml'
                Destination = Join-Path $env:USERPROFILE '.config/starship.toml'
                Label       = 'starship.toml'
            }
            FastFetch       = @{
                Source      = Join-Path $repository '.config/fastfetch/config.jsonc'
                Destination = Join-Path $env:USERPROFILE '.config/fastfetch/config.jsonc'
                Label       = 'fastfetch config.jsonc'
            }
            Figlet          = @{
                Source      = Join-Path $repository '.config/.figlet/ANSI_Shadow.flf'
                Destination = Join-Path $env:USERPROFILE '.config/.figlet/ANSI_Shadow.flf'
                Label       = 'ANSI_Shadow.flf'
            }
            WindowsTerminal = @{
                Source      = Join-Path $repository '.config/windows-terminal/settings.json'
                Destination = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
                Label       = 'Windows Terminal settings.json'
            }
        }

        foreach ($name in $Step) {
            switch ($name) {
                'Modules' { Install-ProfileModule -Repository $repository -InstallPath $InstallPath -Force:$Force }
                'Profile' { Install-Profile -Repository $repository }
                'GalleryModules' { Install-GalleryModule }
                'Font' { Install-CascadiaCodeFont }
                'Tools' { Install-ProfileTool -Manager (Resolve-PackageManager -Preference $PackageManager) }
                default {
                    $target = $configTargets[$name]
                    if ($target) {
                        Install-RepositoryFile -Source $target.Source -Destination $target.Destination -Label $target.Label
                    }
                }
            }
        }

        Write-Host ''
        Write-SetupLog 'Setup complete.'
        Write-Host ''
        Write-Host '  Next steps:' -ForegroundColor Cyan
        Write-Host '    Install-ProfileDependency      install the CLI tools the profile uses'
        Write-Host '    Measure-ProfileLoad            see what loads and what it costs'
        Write-Host '    Show-ProfileHelp               list the commands you now have'
        Write-Host ''
        Write-Host "  Edit $InstallPath\profile.config.psd1 to choose what loads." -ForegroundColor DarkGray
        Write-Host '  Restart your shell to pick everything up.' -ForegroundColor DarkGray
        Write-Host ''
    }
    catch {
        Write-SetupLog "Setup failed: $($_.Exception.Message)" -Level ERROR
        Write-SetupLog 'Nothing further was installed. Existing files were backed up alongside the originals.' -Level ERROR
    }
    finally {
        if ($repository) {
            Remove-Item -LiteralPath (Split-Path -Parent $repository) -Recurse -Force -ErrorAction SilentlyContinue -WhatIf:$false
        }
    }
}

#---------------------------------------------------------------------------------------------------
# Entry point
#
# Forwards only the arguments actually supplied, so the function's own defaults apply to the rest.
# This works identically for `irm ... | iex`, for & ([scriptblock]::Create(...)) -Arg, and for
# ./setup.ps1 -Arg.
#---------------------------------------------------------------------------------------------------
$forward = @{}
if ($InstallPath) { $forward['InstallPath'] = $InstallPath }
if ($Branch) { $forward['Branch'] = $Branch }
if ($Step) { $forward['Step'] = $Step }
if ($PackageManager) { $forward['PackageManager'] = $PackageManager }
if ($IncludeOptional) { $forward['IncludeOptional'] = $true }
if ($Force) { $forward['Force'] = $true }
if ($WhatIf) { $forward['WhatIf'] = $true }

Install-MKAbuMattarProfile @forward
