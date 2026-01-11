#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile
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
#       This PowerShell profile script is crafted by
#       Mohammad Abu Mattar to enhance the PowerShell
#       experience and productivity.
#
# Created: 2021-09-01
# Updated: 2025-09-24
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Set the console encoding to UTF-8
#---------------------------------------------------------------------------------------------------
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#---------------------------------------------------------------------------------------------------
# Check if Terminal Icons module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if PowerShellGet module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PowerShellGet)) {
    Install-Module -Name PowerShellGet -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if CompletionPredictor module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name CompletionPredictor)) {
    Install-Module -Name CompletionPredictor -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if PSReadLine module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Check if Posh-Git module is installed
#---------------------------------------------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name Posh-Git)) {
    Install-Module -Name Posh-Git -Scope CurrentUser -Force -SkipPublisherCheck
}

#---------------------------------------------------------------------------------------------------
# Load the modules
#---------------------------------------------------------------------------------------------------
Import-Module -Name Terminal-Icons
Import-Module -Name PowerShellGet
Import-Module -Name CompletionPredictor
Import-Module -Name PSReadLine
Import-Module -Name Posh-Git

Set-PSReadLineKeyHandler -Chord '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        # Insert matching quotes, move cursor to be in between the quotes
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

#---------------------------------------------------------------------------------------------------
# Import the custom modules and plugins
#---------------------------------------------------------------------------------------------------
$BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath 'Module'

# Track profile startup time
$script:ProfileStartTime = Get-Date

# Load Config module first (critical dependency)
$ConfigModulePath = Join-Path -Path $BaseModuleDir -ChildPath 'Config/Config.psd1'
if (Test-Path $ConfigModulePath) {
    try {
        Import-Module $ConfigModulePath -Force -ErrorAction Stop
        Write-Verbose "Config module loaded successfully"
    }
    catch {
        Write-Warning "Failed to load Config module: $_"
        Write-Warning "Profile will continue with default settings"
    }
}

# Load Performance module second for tracking
$PerformanceModulePath = Join-Path -Path $BaseModuleDir -ChildPath 'Performance/Performance.psd1'
if (Test-Path $PerformanceModulePath) {
    try {
        Import-Module $PerformanceModulePath -Force -ErrorAction Stop
        Write-Verbose "Performance module loaded successfully"
    }
    catch {
        Write-Warning "Failed to load Performance module: $_"
    }
}

# Get error recovery settings from config
$errorRecoveryEnabled = $true
$continueOnError = $true
if (Get-Command -Name Get-ProfileConfig -ErrorAction SilentlyContinue) {
    $loggingConfig = Get-ProfileConfig -Key 'logging.errorRecovery' -Default @{}
    if ($loggingConfig.PSObject.Properties.Name -contains 'enabled') {
        $errorRecoveryEnabled = $loggingConfig.enabled
    }
    if ($loggingConfig.PSObject.Properties.Name -contains 'continueOnError') {
        $continueOnError = $loggingConfig.continueOnError
    }
}

# Get module enable/disable settings from config
$modulesEnabled = if (Get-Command -Name Get-ProfileConfig -ErrorAction SilentlyContinue) {
    Get-ProfileConfig -Key "modules.enabled" -Default @{}
}
else {
    @{}
}

$lazyLoadModules = if (Get-Command -Name Get-ProfileConfig -ErrorAction SilentlyContinue) {
    Get-ProfileConfig -Key "performance.lazyLoad" -Default @{}
}
else {
    @{}
}

$ModuleList = @(
    @{ Name = 'Module-Directory'; Path = 'Directory/Directory.psd1'; ConfigKey = 'Directory'; LazyLoad = $false },
    @{ Name = 'Module-Docs'; Path = 'Docs/Docs.psd1'; ConfigKey = 'Docs'; LazyLoad = $false },
    @{ Name = 'Module-Environment'; Path = 'Environment/Environment.psd1'; ConfigKey = 'Environment'; LazyLoad = $false },
    @{ Name = 'Module-Logging'; Path = 'Logging/Logging.psd1'; ConfigKey = 'Logging'; LazyLoad = $false },
    @{ Name = 'Module-Network'; Path = 'Network/Network.psd1'; ConfigKey = 'Network'; LazyLoad = $true },
    @{ Name = 'Module-Plugins'; Path = 'Plugins/Plugins.psd1'; ConfigKey = 'Plugins'; LazyLoad = $true },
    @{ Name = 'Module-Process'; Path = 'Process/Process.psd1'; ConfigKey = 'Process'; LazyLoad = $false },
    @{ Name = 'Module-Starship'; Path = 'Starship/Starship.psd1'; ConfigKey = 'Starship'; LazyLoad = $false },
    @{ Name = 'Module-Update'; Path = 'Update/Update.psd1'; ConfigKey = 'Update'; LazyLoad = $true },
    @{ Name = 'Module-Utility'; Path = 'Utility/Utility.psd1'; ConfigKey = 'Utility'; LazyLoad = $true }
)

foreach ($Module in $ModuleList) {
    $ModulePath = Join-Path -Path $BaseModuleDir -ChildPath $Module.Path
    $ModuleName = $Module.Name
    $ConfigKey = $Module.ConfigKey
    $shouldLazyLoad = $Module.LazyLoad

    $isEnabled = if ($modulesEnabled.PSObject.Properties.Name -contains $ConfigKey) {
        $modulesEnabled.$ConfigKey
    }
    else {
        $true
    }

    if (-not $isEnabled) {
        Write-Verbose "$ModuleName is disabled in configuration. Skipping..."
        continue
    }

    if ($lazyLoadModules.PSObject.Properties.Name -contains $ConfigKey) {
        $shouldLazyLoad = $lazyLoadModules.$ConfigKey
    }

    if ($shouldLazyLoad) {
        Write-Verbose "$ModuleName will be lazy-loaded on first use"
        continue
    }

    if (Test-Path $ModulePath) {
        try {
            # Measure module load time
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            Import-Module $ModulePath -Force -ErrorAction Stop
            $sw.Stop()
            
            # Register load time if Performance module is available
            if (Get-Command Register-ModuleLoadTime -ErrorAction SilentlyContinue) {
                Register-ModuleLoadTime -ModuleName $ModuleName -LoadTimeMs $sw.ElapsedMilliseconds
            }
            
            Write-Verbose "$ModuleName loaded successfully in $($sw.ElapsedMilliseconds)ms"
        }
        catch {
            $errorMessage = "Failed to load $ModuleName`: $_"
            Write-Warning $errorMessage
            
            # Log error if logging module is available
            if (Get-Command Write-ErrorReport -ErrorAction SilentlyContinue) {
                Write-ErrorReport -ErrorRecord $_ -Context "Module Loading: $ModuleName" -Severity Medium
            }
            
            # Stop profile loading if continueOnError is false
            if (-not $continueOnError) {
                throw "Critical module loading failure. Profile initialization stopped."
            }
        }
    }
    else {
        Write-Warning "$ModuleName module not found at: $ModulePath"
    }
}

#---------------------------------------------------------------------------------------------------
# Invoke Starship Transient Function
#---------------------------------------------------------------------------------------------------
Invoke-Command -ScriptBlock ${function:Invoke-StarshipTransientFunction} -ErrorAction Stop

#---------------------------------------------------------------------------------------------------
# Load Starship
#---------------------------------------------------------------------------------------------------
Invoke-Expression (&starship init powershell)

#---------------------------------------------------------------------------------------------------
# Set Chocolatey Profile
#---------------------------------------------------------------------------------------------------
$ChocolateyProfile = Join-Path -Path $ENV:CHOCOLATEYINSTALL -ChildPath 'helpers\chocolateyProfile.psm1'

#---------------------------------------------------------------------------------------------------
# Import Chocolatey Profile
#---------------------------------------------------------------------------------------------------
if (Test-Path $ChocolateyProfile) {
    Import-Module $ChocolateyProfile
}

#---------------------------------------------------------------------------------------------------
# Invoke the profile update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true) {
    &${function:Update-LocalProfileModuleDirectory} -ErrorAction SilentlyContinue
}

#---------------------------------------------------------------------------------------------------
# Invoke the profile update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdateProfile -eq $true) {
    &${function:Update-Profile} -ErrorAction SilentlyContinue
}

#---------------------------------------------------------------------------------------------------
# Invoke the PowerShell update function
#---------------------------------------------------------------------------------------------------
if ($global:AutoUpdatePowerShell -eq $true) {
    &${function:Update-PowerShell} -ErrorAction SilentlyContinue
}

#------------------------------------------------------
# Editor Configuration
#------------------------------------------------------
$EDITOR = if (Get-Command nvim -ErrorAction SilentlyContinue) { 'nvim' }
elseif (Get-Command pvim -ErrorAction SilentlyContinue) { 'pvim' }
elseif (Get-Command vim -ErrorAction SilentlyContinue) { 'vim' }
elseif (Get-Command vi -ErrorAction SilentlyContinue) { 'vi' }
elseif (Get-Command code -ErrorAction SilentlyContinue) { 'code' }
elseif (Get-Command notepad++ -ErrorAction SilentlyContinue) { 'notepad++' }
elseif (Get-Command sublime_text -ErrorAction SilentlyContinue) { 'sublime_text' }
else { 'notepad' }

#------------------------------------------------------
# Set the editor alias
#------------------------------------------------------
Set-Alias -Name vim -Value $EDITOR

#------------------------------------------------------
# Run FastFetch
#------------------------------------------------------
# if (Get-Command FastFetch -ErrorAction SilentlyContinue) {
#     Invoke-Expression -Command "Clear-Host"
#     Invoke-Expression -Command "FastFetch"
# }
