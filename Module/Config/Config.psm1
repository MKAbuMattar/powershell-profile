#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Config Module
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
#       This module provides a profile configuration management system
#       with JSON-based storage, validation, and CRUD operations for
#       PowerShell profile settings.
#
# Created: 2025-10-25
# Updated: 2026-01-11
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 1.0.0
#---------------------------------------------------------------------------------------------------

# ==============================================================================
# Module Variables
# ==============================================================================

$script:ConfigDir = Join-Path $env:USERPROFILE ".config"
$script:ConfigFile = Join-Path $script:ConfigDir "ps1-profile-cfg.json"
$script:DefaultConfigFile = Join-Path $PSScriptRoot "config.default.json"

# ==============================================================================
# Private Functions
# ==============================================================================

<#
.SYNOPSIS
    Ensures the configuration directory exists.
#>
function Initialize-ConfigDirectory {
    [CmdletBinding()]
    param()
    
    if (-not (Test-Path -Path $script:ConfigDir)) {
        try {
            New-Item -Path $script:ConfigDir -ItemType Directory -Force | Out-Null
            Write-Verbose "Created configuration directory: $script:ConfigDir"
        }
        catch {
            Write-Error "Failed to create configuration directory: $_"
            throw
        }
    }
}

<#
.SYNOPSIS
    Validates configuration object against schema.
#>
function Test-ConfigurationSchema {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Config
    )
    
    $requiredProperties = @('version', 'profile', 'modules', 'aliases', 'environment')
    $missingProperties = @()
    
    foreach ($prop in $requiredProperties) {
        if (-not ($Config.PSObject.Properties.Name -contains $prop)) {
            $missingProperties += $prop
        }
    }
    
    if ($missingProperties.Count -gt 0) {
        Write-Warning "Configuration is missing required properties: $($missingProperties -join ', ')"
        return $false
    }
    
    return $true
}

<#
.SYNOPSIS
    Merges two configuration objects, with new values overwriting old ones.
#>
function Merge-Configuration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Base,
        
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Override
    )
    
    $result = $Base | ConvertTo-Json -Depth 10 | ConvertFrom-Json
    
    foreach ($property in $Override.PSObject.Properties) {
        if ($result.PSObject.Properties.Name -contains $property.Name) {
            if ($property.Value -is [PSCustomObject]) {
                $result.$($property.Name) = Merge-Configuration -Base $result.$($property.Name) -Override $property.Value
            }
            else {
                $result.$($property.Name) = $property.Value
            }
        }
        else {
            $result | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value -Force
        }
    }
    
    return $result
}

# ==============================================================================
# Public Functions
# ==============================================================================

function Get-ProfileConfig {
    <#
    .SYNOPSIS
        Retrieves the current profile configuration.

    .DESCRIPTION
        This function gets configuration values from the user's config file. If no config file exists,
        returns the default configuration. Can retrieve all settings or a specific setting.

    .PARAMETER Key
        (Optional) Dot-notation path to a specific configuration value (e.g., "profile.theme").

    .PARAMETER Default
        (Optional) Default value to return if the specified key doesn't exist.

    .INPUTS
        Key: (Optional) Dot-notation path to a specific configuration value.
        Default: (Optional) Default value to return if the specified key doesn't exist.

    .OUTPUTS
        PSCustomObject or specific value based on Key parameter.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Get-ProfileConfig
        Retrieves the entire configuration object.

    .EXAMPLE
        Get-ProfileConfig -Key "profile.theme"
        Retrieves the theme setting value.

    .EXAMPLE
        Get-ProfileConfig -Key "modules.lazyLoad" -Default $true
        Retrieves the lazyLoad setting, or $true if it doesn't exist.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cfg")]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [string]$Key,
        
        [Parameter(Position = 1)]
        [object]$Default
    )
    
    try {
        # Load configuration
        if (Test-Path -Path $script:ConfigFile) {
            $config = Get-Content -Path $script:ConfigFile -Raw | ConvertFrom-Json
            Write-Verbose "Loaded configuration from: $script:ConfigFile"
        }
        elseif (Test-Path -Path $script:DefaultConfigFile) {
            $config = Get-Content -Path $script:DefaultConfigFile -Raw | ConvertFrom-Json
            Write-Verbose "Loaded default configuration"
        }
        else {
            Write-Warning "No configuration file found. Creating default configuration."
            Reset-ProfileConfig
            $config = Get-Content -Path $script:ConfigFile -Raw | ConvertFrom-Json
        }
        
        # Return specific key if requested
        if ($Key) {
            $value = $config
            $parts = $Key -split '\.'
            
            foreach ($part in $parts) {
                if ($value.PSObject.Properties.Name -contains $part) {
                    $value = $value.$part
                }
                else {
                    if ($PSBoundParameters.ContainsKey('Default')) {
                        return $Default
                    }
                    Write-Warning "Configuration key '$Key' not found."
                    return $null
                }
            }
            
            return $value
        }
        
        return $config
    }
    catch {
        Write-Error "Failed to retrieve configuration: $_"
        if ($PSBoundParameters.ContainsKey('Default')) {
            return $Default
        }
        throw
    }
}

function Set-ProfileConfig {
    <#
    .SYNOPSIS
        Sets a configuration value.

    .DESCRIPTION
        This function updates a configuration value in the user's config file. Creates the config
        file if it doesn't exist. Supports dot-notation for nested properties.

    .PARAMETER Key
        Dot-notation path to the configuration value (e.g., "profile.theme").

    .PARAMETER Value
        The value to set. Can be any JSON-serializable type.

    .PARAMETER Force
        (Optional) If specified, creates missing parent properties in the path.

    .INPUTS
        Key: Dot-notation path to the configuration value.
        Value: The value to set. Can be any JSON-serializable type.
        Force: (Optional) If specified, creates missing parent properties in the path.

    .OUTPUTS
        None. Displays confirmation message on success.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Set-ProfileConfig -Key "profile.theme" -Value "dark"
        Sets the theme to "dark".

    .EXAMPLE
        Set-ProfileConfig -Key "modules.lazyLoad" -Value $true
        Enables lazy loading for modules.

    .EXAMPLE
        Set-ProfileConfig -Key "custom.newSetting" -Value "value" -Force
        Creates new nested properties if they don't exist.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("cfg-set")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Key,
        
        [Parameter(Mandatory = $true, Position = 1)]
        [object]$Value,
        
        [Parameter()]
        [switch]$Force
    )
    
    try {
        Initialize-ConfigDirectory
        
        # Load current configuration
        $config = Get-ProfileConfig
        
        # Navigate to the target property
        $parts = $Key -split '\.'
        $current = $config
        
        for ($i = 0; $i -lt $parts.Count - 1; $i++) {
            $part = $parts[$i]
            
            if ($current.PSObject.Properties.Name -contains $part) {
                $current = $current.$part
            }
            elseif ($Force) {
                $current | Add-Member -NotePropertyName $part -NotePropertyValue ([PSCustomObject]@{}) -Force
                $current = $current.$part
            }
            else {
                throw "Configuration path '$($parts[0..$i] -join '.')' does not exist. Use -Force to create it."
            }
        }
        
        # Set the final property
        $finalKey = $parts[-1]
        
        if ($PSCmdlet.ShouldProcess("Configuration key '$Key'", "Set to '$Value'")) {
            if ($current.PSObject.Properties.Name -contains $finalKey) {
                $current.$finalKey = $Value
            }
            else {
                $current | Add-Member -NotePropertyName $finalKey -NotePropertyValue $Value -Force
            }
            
            # Save configuration
            $config | ConvertTo-Json -Depth 10 | Set-Content -Path $script:ConfigFile -Encoding UTF8
            Write-Verbose "Configuration saved to: $script:ConfigFile"
            Write-Host "✓ Configuration updated: $Key = $Value" -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to set configuration: $_"
        throw
    }
}

function Reset-ProfileConfig {
    <#
    .SYNOPSIS
        Resets configuration to default values.

    .DESCRIPTION
        This function resets the user configuration file to default values from the template.
        Can reset the entire configuration or specific sections.

    .PARAMETER Section
        (Optional) Specific section to reset (e.g., "profile", "modules").

    .PARAMETER Force
        (Optional) If specified, skips confirmation prompt.

    .INPUTS
        Section: (Optional) Specific section to reset.
        Force: (Optional) If specified, skips confirmation prompt.

    .OUTPUTS
        None. Displays confirmation message on success.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Reset-ProfileConfig
        Resets entire configuration to defaults (with confirmation).

    .EXAMPLE
        Reset-ProfileConfig -Force
        Resets entire configuration without confirmation.

    .EXAMPLE
        Reset-ProfileConfig -Section "modules"
        Resets only the modules section to defaults.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("cfg-reset")]
    param(
        [Parameter()]
        [ValidateSet('profile', 'modules', 'aliases', 'environment', 'performance')]
        [string]$Section,
        
        [Parameter()]
        [switch]$Force
    )
    
    try {
        Initialize-ConfigDirectory
        
        if (-not (Test-Path -Path $script:DefaultConfigFile)) {
            throw "Default configuration file not found: $script:DefaultConfigFile"
        }
        
        $defaultConfig = Get-Content -Path $script:DefaultConfigFile -Raw | ConvertFrom-Json
        
        if ($Section) {
            # Reset specific section
            if ($PSCmdlet.ShouldProcess("Configuration section '$Section'", "Reset to defaults")) {
                $currentConfig = Get-ProfileConfig
                
                if ($defaultConfig.PSObject.Properties.Name -contains $Section) {
                    $currentConfig.$Section = $defaultConfig.$Section
                    $currentConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $script:ConfigFile -Encoding UTF8
                    Write-Host "✓ Configuration section '$Section' reset to defaults" -ForegroundColor Green
                }
                else {
                    Write-Warning "Section '$Section' not found in default configuration"
                }
            }
        }
        else {
            # Reset entire configuration
            if ($Force -or $PSCmdlet.ShouldProcess("Entire configuration", "Reset to defaults")) {
                $defaultConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $script:ConfigFile -Encoding UTF8
                Write-Host "✓ Configuration reset to defaults" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Error "Failed to reset configuration: $_"
        throw
    }
}

function Export-ProfileConfig {
    <#
    .SYNOPSIS
        Exports configuration to a file.

    .DESCRIPTION
        This function exports the current configuration to a JSON file. Useful for backups
        or sharing configuration across machines.

    .PARAMETER Path
        Path where the configuration should be exported.

    .PARAMETER Force
        (Optional) If specified, overwrites existing file without confirmation.

    .INPUTS
        Path: Path where the configuration should be exported.
        Force: (Optional) If specified, overwrites existing file without confirmation.

    .OUTPUTS
        None. Displays confirmation message on success.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Export-ProfileConfig -Path "C:\backup\my-config.json"
        Exports configuration to specified path.

    .EXAMPLE
        Export-ProfileConfig -Path ".\config-backup.json" -Force
        Exports and overwrites existing file.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("cfg-export")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter()]
        [switch]$Force
    )
    
    try {
        $config = Get-ProfileConfig
        
        # Resolve full path
        $fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        
        # Check if file exists
        if ((Test-Path -Path $fullPath) -and -not $Force) {
            throw "File already exists: $fullPath. Use -Force to overwrite."
        }
        
        if ($PSCmdlet.ShouldProcess($fullPath, "Export configuration")) {
            $config | ConvertTo-Json -Depth 10 | Set-Content -Path $fullPath -Encoding UTF8
            Write-Host "✓ Configuration exported to: $fullPath" -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to export configuration: $_"
        throw
    }
}

function Import-ProfileConfig {
    <#
    .SYNOPSIS
        Imports configuration from a file.

    .DESCRIPTION
        This function imports configuration from a JSON file. Can merge with existing configuration
        or replace it entirely.

    .PARAMETER Path
        Path to the configuration file to import.

    .PARAMETER Merge
        (Optional) If specified, merges imported configuration with existing configuration.
        Otherwise, replaces existing configuration entirely.

    .PARAMETER Force
        (Optional) If specified, skips validation and confirmation.

    .INPUTS
        Path: Path to the configuration file to import.
        Merge: (Optional) If specified, merges imported configuration with existing configuration.
        Force: (Optional) If specified, skips validation and confirmation.

    .OUTPUTS
        None. Displays confirmation message on success.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Import-ProfileConfig -Path "C:\backup\my-config.json"
        Imports and replaces current configuration.

    .EXAMPLE
        Import-ProfileConfig -Path ".\config-backup.json" -Merge
        Imports and merges with existing configuration.

    .EXAMPLE
        Import-ProfileConfig -Path ".\config.json" -Force
        Imports without validation or confirmation.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("cfg-import")]

    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path,
        
        [Parameter()]
        [switch]$Merge,
        
        [Parameter()]
        [switch]$Force
    )
    
    try {
        Initialize-ConfigDirectory
        
        # Load configuration to import
        $importedConfig = Get-Content -Path $Path -Raw | ConvertFrom-Json
        
        # Validate schema unless forced
        if (-not $Force) {
            if (-not (Test-ConfigurationSchema -Config $importedConfig)) {
                throw "Imported configuration failed schema validation. Use -Force to import anyway."
            }
        }
        
        if ($Merge) {
            # Merge with existing configuration
            if ($PSCmdlet.ShouldProcess("Configuration", "Merge with imported configuration")) {
                $currentConfig = Get-ProfileConfig
                $mergedConfig = Merge-Configuration -Base $currentConfig -Override $importedConfig
                $mergedConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $script:ConfigFile -Encoding UTF8
                Write-Host "✓ Configuration merged from: $Path" -ForegroundColor Green
            }
        }
        else {
            # Replace entire configuration
            if ($Force -or $PSCmdlet.ShouldProcess("Configuration", "Replace with imported configuration")) {
                $importedConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $script:ConfigFile -Encoding UTF8
                Write-Host "✓ Configuration imported from: $Path" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Error "Failed to import configuration: $_"
        throw
    }
}

function Edit-ProfileConfig {
    <#
    .SYNOPSIS
        Opens the configuration file in the default editor.

    .DESCRIPTION
        This function opens the user configuration file in the default text editor or VS Code.

    .PARAMETER Editor
        (Optional) Specifies which editor to use: Default, VSCode, or Notepad.

    .INPUTS
        Editor: (Optional) Specifies which editor to use.

    .OUTPUTS
        None. Opens the configuration file in the specified editor.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Edit-ProfileConfig
        Opens config in default editor.

    .EXAMPLE
        Edit-ProfileConfig -Editor VSCode
        Opens config in VS Code.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cfg-edit")]
    param(
        [Parameter()]
        [ValidateSet('Default', 'VSCode', 'Notepad')]
        [string]$Editor = 'Default'
    )
    
    try {
        Initialize-ConfigDirectory
        
        if (-not (Test-Path -Path $script:ConfigFile)) {
            Write-Host "Configuration file doesn't exist. Creating from defaults..." -ForegroundColor Yellow
            Reset-ProfileConfig -Force
        }
        
        switch ($Editor) {
            'VSCode' {
                if (Get-Command code -ErrorAction SilentlyContinue) {
                    & code $script:ConfigFile
                }
                else {
                    Write-Warning "VS Code not found in PATH. Opening with default editor."
                    Invoke-Item $script:ConfigFile
                }
            }
            'Notepad' {
                & notepad $script:ConfigFile
            }
            Default {
                Invoke-Item $script:ConfigFile
            }
        }
        
        Write-Host "Opened configuration file: $script:ConfigFile" -ForegroundColor Cyan
    }
    catch {
        Write-Error "Failed to open configuration file: $_"
        throw
    }
}

function Test-ProfileConfig {
    <#
    .SYNOPSIS
        Validates the current configuration file.

    .DESCRIPTION
        This function checks if the configuration file is valid JSON and matches the expected schema.

    .PARAMETER Path
        (Optional) Path to a configuration file to validate. Defaults to user config.

    .INPUTS
        Path: (Optional) Path to a configuration file to validate.

    .OUTPUTS
        Boolean indicating whether configuration is valid.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Test-ProfileConfig
        Validates current user configuration.

    .EXAMPLE
        Test-ProfileConfig -Path ".\my-config.json"
        Validates specified configuration file.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cfg-test")]
    [OutputType([bool])]
    param(
        [Parameter()]
        [string]$Path = $script:ConfigFile
    )
    
    try {
        if (-not (Test-Path -Path $Path)) {
            Write-Warning "Configuration file not found: $Path"
            return $false
        }
        
        # Test JSON validity
        try {
            $config = Get-Content -Path $Path -Raw | ConvertFrom-Json
            Write-Verbose "✓ Configuration is valid JSON"
        }
        catch {
            Write-Error "Configuration contains invalid JSON: $_"
            return $false
        }
        
        # Test schema
        if (-not (Test-ConfigurationSchema -Config $config)) {
            Write-Error "Configuration failed schema validation"
            return $false
        }
        
        Write-Host "✓ Configuration is valid" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Failed to validate configuration: $_"
        return $false
    }
}

function Show-ProfileConfigInfo {
    <#
    .SYNOPSIS
        Shows information about the configuration system.

    .DESCRIPTION
        This function displays configuration file locations, current values, and system information.

    .INPUTS
        None.

    .OUTPUTS
        None. Displays configuration system information.

    .NOTES
        This function is part of the Config module.

    .EXAMPLE
        Show-ProfileConfigInfo
        Displays configuration system information.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("cfg-info")]
    param()
    
    Write-Host "`n=== PowerShell Profile Configuration ===" -ForegroundColor Cyan
    Write-Host "`nConfiguration Locations:" -ForegroundColor Yellow
    Write-Host "  User Config:    " -NoNewline
    if (Test-Path -Path $script:ConfigFile) {
        Write-Host $script:ConfigFile -ForegroundColor Green
    }
    else {
        Write-Host "$script:ConfigFile (not found)" -ForegroundColor Red
    }
    Write-Host "  Default Config: " -NoNewline
    if (Test-Path -Path $script:DefaultConfigFile) {
        Write-Host $script:DefaultConfigFile -ForegroundColor Green
    }
    else {
        Write-Host "$script:DefaultConfigFile (not found)" -ForegroundColor Red
    }
    
    Write-Host "`nCurrent Configuration:" -ForegroundColor Yellow
    try {
        $config = Get-ProfileConfig
        $config | ConvertTo-Json -Depth 3 | Write-Host -ForegroundColor Gray
    }
    catch {
        Write-Host "  Unable to load configuration" -ForegroundColor Red
    }
    
    Write-Host "`nAvailable Commands:" -ForegroundColor Yellow
    Write-Host "  Get-ProfileConfig    - Get configuration values"
    Write-Host "  Set-ProfileConfig    - Set configuration values"
    Write-Host "  Reset-ProfileConfig  - Reset to defaults"
    Write-Host "  Export-ProfileConfig - Export configuration"
    Write-Host "  Import-ProfileConfig - Import configuration"
    Write-Host "  Edit-ProfileConfig   - Edit configuration file"
    Write-Host "  Test-ProfileConfig   - Validate configuration"
    Write-Host ""
}

# ==============================================================================
# Module Exports
# ==============================================================================

Export-ModuleMember -Function @(
    'Get-ProfileConfig',
    'Set-ProfileConfig',
    'Reset-ProfileConfig',
    'Export-ProfileConfig',
    'Import-ProfileConfig',
    'Edit-ProfileConfig',
    'Test-ProfileConfig',
    'Show-ProfileConfigInfo'
)

# ==============================================================================
# Module Aliases
# ==============================================================================

New-Alias -Name 'cfg' -Value 'Get-ProfileConfig' -Force
New-Alias -Name 'cfg-set' -Value 'Set-ProfileConfig' -Force
New-Alias -Name 'cfg-reset' -Value 'Reset-ProfileConfig' -Force
New-Alias -Name 'cfg-export' -Value 'Export-ProfileConfig' -Force
New-Alias -Name 'cfg-import' -Value 'Import-ProfileConfig' -Force
New-Alias -Name 'cfg-edit' -Value 'Edit-ProfileConfig' -Force
New-Alias -Name 'cfg-test' -Value 'Test-ProfileConfig' -Force
New-Alias -Name 'cfg-info' -Value 'Show-ProfileConfigInfo' -Force

Export-ModuleMember -Alias @(
    'cfg',
    'cfg-set',
    'cfg-reset',
    'cfg-export',
    'cfg-import',
    'cfg-edit',
    'cfg-test',
    'cfg-info'
)
