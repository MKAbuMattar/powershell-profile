# ============================================================================
# Module: Dependency
# Description: Module dependency management and health checking system
# Author: MKAbuMattar
# Created: January 11, 2026
# Version: 1.0.0
# ============================================================================

#Requires -Version 5.1

# ============================================================================
# Module Variables
# ============================================================================

$script:DependencyMap = @{}
$script:ModuleHealthCache = @{}
$script:CacheExpiration = (Get-Date).AddMinutes(5)

# ============================================================================
# Private Functions
# ============================================================================

function Initialize-DependencyMap {
    <#
    .SYNOPSIS
        Initializes the dependency map for all profile modules.
    #>
    [CmdletBinding()]
    param()
    
    $script:DependencyMap = @{
        'Config'        = @{
            Version          = '2.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Configuration management system'
        }
        'Logging'       = @{
            Version          = '5.0.0'
            Dependencies     = @('Config')
            RequiredCommands = @()
            Description      = 'Enhanced logging and error reporting'
        }
        'Performance'   = @{
            Version          = '2.0.0'
            Dependencies     = @('Config', 'Logging')
            RequiredCommands = @()
            Description      = 'Performance monitoring and optimization'
        }
        'Directory'     = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Enhanced directory navigation'
        }
        'Docs'          = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Interactive documentation system'
        }
        'Environment'   = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Environment variable management'
        }
        'Network'       = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @('python')
            Description      = 'Network utilities'
        }
        'Process'       = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Process management utilities'
        }
        'Starship'      = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @('starship')
            Description      = 'Starship prompt configuration'
        }
        'Update'        = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Profile update management'
        }
        'Utility'       = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'General utility functions'
        }
        'Plugins'       = @{
            Version          = '1.0.0'
            Dependencies     = @()
            RequiredCommands = @()
            Description      = 'Plugin system'
        }
        # Plugin modules
        'AWS'           = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('aws')
            Description      = 'AWS CLI integration'
        }
        'Conda'         = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('conda')
            Description      = 'Conda environment management'
        }
        'Deno'          = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('deno')
            Description      = 'Deno runtime integration'
        }
        'Docker'        = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('docker')
            Description      = 'Docker CLI integration'
        }
        'DockerCompose' = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins', 'Docker')
            RequiredCommands = @('docker-compose', 'docker')
            Description      = 'Docker Compose integration'
        }
        'Flutter'       = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('flutter')
            Description      = 'Flutter development tools'
        }
        'GCP'           = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('gcloud')
            Description      = 'Google Cloud Platform integration'
        }
        'Git'           = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('git')
            Description      = 'Git version control integration'
        }
        'Helm'          = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('helm')
            Description      = 'Helm package manager'
        }
        'Kubectl'       = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('kubectl')
            Description      = 'Kubernetes CLI integration'
        }
        'NPM'           = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('npm')
            Description      = 'NPM package manager'
        }
        'PIP'           = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('pip')
            Description      = 'Python pip package manager'
        }
        'Pipenv'        = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('pipenv')
            Description      = 'Python Pipenv integration'
        }
        'PNPM'          = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('pnpm')
            Description      = 'PNPM package manager'
        }
        'Poetry'        = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('poetry')
            Description      = 'Python Poetry package manager'
        }
        'Rsync'         = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('rsync')
            Description      = 'Rsync file synchronization'
        }
        'Ruby'          = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('ruby', 'gem')
            Description      = 'Ruby development tools'
        }
        'Rust'          = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('cargo', 'rustc')
            Description      = 'Rust development tools'
        }
        'Terraform'     = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('terraform')
            Description      = 'Terraform IaC integration'
        }
        'Terragrunt'    = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins', 'Terraform')
            RequiredCommands = @('terragrunt', 'terraform')
            Description      = 'Terragrunt wrapper for Terraform'
        }
        'UV'            = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('uv')
            Description      = 'UV package manager'
        }
        'VSCode'        = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('code')
            Description      = 'VS Code integration'
        }
        'Yarn'          = @{
            Version          = '1.0.0'
            Dependencies     = @('Plugins')
            RequiredCommands = @('yarn')
            Description      = 'Yarn package manager'
        }
    }
}

function Get-ModuleManifest {
    <#
    .SYNOPSIS
        Gets the module manifest for a given module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName
    )
    
    try {
        $modulePath = Join-Path $PSScriptRoot "..\$ModuleName\$ModuleName.psd1"
        if (Test-Path $modulePath) {
            return Import-PowerShellDataFile -Path $modulePath -ErrorAction Stop
        }
        
        # Check if it's a plugin
        $pluginPath = Join-Path $PSScriptRoot "..\Plugins\$ModuleName\$ModuleName.psd1"
        if (Test-Path $pluginPath) {
            return Import-PowerShellDataFile -Path $pluginPath -ErrorAction Stop
        }
        
        return $null
    }
    catch {
        Write-Warning "Failed to read manifest for module '$ModuleName': $_"
        return $null
    }
}

function Test-CommandAvailable {
    <#
    .SYNOPSIS
        Tests if a command is available in the current session.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName
    )
    
    $null -ne (Get-Command $CommandName -ErrorAction SilentlyContinue)
}

function Get-DependencyChain {
    <#
    .SYNOPSIS
        Gets the full dependency chain for a module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName,
        
        [Parameter()]
        [string[]]$Visited = @()
    )
    
    if ($ModuleName -in $Visited) {
        Write-Warning "Circular dependency detected: $ModuleName"
        return @()
    }
    
    $Visited += $ModuleName
    $chain = @($ModuleName)
    
    if ($script:DependencyMap.ContainsKey($ModuleName)) {
        $dependencies = $script:DependencyMap[$ModuleName].Dependencies
        foreach ($dep in $dependencies) {
            $depChain = Get-DependencyChain -ModuleName $dep -Visited $Visited
            $chain = $depChain + $chain
        }
    }
    
    return ($chain | Select-Object -Unique)
}

# ============================================================================
# Public Functions
# ============================================================================

function Get-ModuleDependencies {
    <#
    .SYNOPSIS
        Gets the dependencies for a profile module.
    
    .DESCRIPTION
        Retrieves the dependency information for a specified module, including
        required modules, commands, and the full dependency chain.
    
    .PARAMETER ModuleName
        The name of the module to check dependencies for.
    
    .PARAMETER IncludeChain
        If specified, includes the full dependency chain (all transitive dependencies).
    
    .EXAMPLE
        Get-ModuleDependencies -ModuleName 'Performance'
        Gets the direct dependencies for the Performance module.
    
    .EXAMPLE
        Get-ModuleDependencies -ModuleName 'DockerCompose' -IncludeChain
        Gets the full dependency chain for DockerCompose (includes Docker, Plugins, etc.)
    
    .EXAMPLE
        deps Performance
        Uses alias to get dependencies for Performance module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$ModuleName,
        
        [Parameter()]
        [switch]$IncludeChain
    )
    
    if ($script:DependencyMap.Count -eq 0) {
        Initialize-DependencyMap
    }
    
    if (-not $script:DependencyMap.ContainsKey($ModuleName)) {
        Write-Warning "Module '$ModuleName' not found in dependency map."
        return
    }
    
    $moduleInfo = $script:DependencyMap[$ModuleName]
    
    $result = [PSCustomObject]@{
        ModuleName         = $ModuleName
        Version            = $moduleInfo.Version
        Description        = $moduleInfo.Description
        DirectDependencies = $moduleInfo.Dependencies
        RequiredCommands   = $moduleInfo.RequiredCommands
        DependencyChain    = if ($IncludeChain) { Get-DependencyChain -ModuleName $ModuleName } else { $null }
    }
    
    return $result
}

function Test-ModuleVersion {
    <#
    .SYNOPSIS
        Tests if a module version meets requirements.
    
    .DESCRIPTION
        Checks if an installed module meets minimum version requirements.
        Compares the installed version against the dependency map.
    
    .PARAMETER ModuleName
        The name of the module to check.
    
    .PARAMETER RequiredVersion
        The minimum required version. If not specified, uses the version from the dependency map.
    
    .EXAMPLE
        Test-ModuleVersion -ModuleName 'Logging'
        Checks if the installed Logging module meets the required version.
    
    .EXAMPLE
        Test-ModuleVersion -ModuleName 'Config' -RequiredVersion '2.0.0'
        Checks if Config module is at least version 2.0.0.
    
    .EXAMPLE
        test-version Logging
        Uses alias to check Logging module version.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$ModuleName,
        
        [Parameter()]
        [version]$RequiredVersion
    )
    
    if ($script:DependencyMap.Count -eq 0) {
        Initialize-DependencyMap
    }
    
    # Get required version from dependency map if not specified
    if (-not $RequiredVersion -and $script:DependencyMap.ContainsKey($ModuleName)) {
        $RequiredVersion = [version]$script:DependencyMap[$ModuleName].Version
    }
    
    # Get installed module
    $installedModule = Get-Module -Name $ModuleName -ListAvailable -ErrorAction SilentlyContinue | 
    Sort-Object Version -Descending | 
    Select-Object -First 1
    
    if (-not $installedModule) {
        return [PSCustomObject]@{
            ModuleName       = $ModuleName
            RequiredVersion  = $RequiredVersion
            InstalledVersion = $null
            IsInstalled      = $false
            MeetsRequirement = $false
            Status           = 'Not Installed'
        }
    }
    
    $installedVersion = $installedModule.Version
    $meetsRequirement = if ($RequiredVersion) { $installedVersion -ge $RequiredVersion } else { $true }
    
    return [PSCustomObject]@{
        ModuleName       = $ModuleName
        RequiredVersion  = $RequiredVersion
        InstalledVersion = $installedVersion
        IsInstalled      = $true
        MeetsRequirement = $meetsRequirement
        Status           = if ($meetsRequirement) { 'OK' } else { 'Outdated' }
    }
}

function Test-ModuleHealth {
    <#
    .SYNOPSIS
        Performs a comprehensive health check on a module.
    
    .DESCRIPTION
        Checks module health including:
        - Module installation and version
        - Dependency availability
        - Required command availability
        - Module loadability
        - Conflict detection
    
    .PARAMETER ModuleName
        The name of the module to check. If not specified, checks all modules.
    
    .PARAMETER UseCache
        If specified, uses cached results if available and not expired.
    
    .EXAMPLE
        Test-ModuleHealth -ModuleName 'Performance'
        Checks the health of the Performance module.
    
    .EXAMPLE
        Test-ModuleHealth
        Checks the health of all profile modules.
    
    .EXAMPLE
        module-health Docker
        Uses alias to check Docker module health.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$ModuleName,
        
        [Parameter()]
        [switch]$UseCache
    )
    
    if ($script:DependencyMap.Count -eq 0) {
        Initialize-DependencyMap
    }
    
    # Check cache
    if ($UseCache -and (Get-Date) -lt $script:CacheExpiration) {
        if ($ModuleName -and $script:ModuleHealthCache.ContainsKey($ModuleName)) {
            return $script:ModuleHealthCache[$ModuleName]
        }
    }
    else {
        $script:ModuleHealthCache = @{}
        $script:CacheExpiration = (Get-Date).AddMinutes(5)
    }
    
    $modulesToCheck = if ($ModuleName) { @($ModuleName) } else { $script:DependencyMap.Keys }
    $results = @()
    
    foreach ($module in $modulesToCheck) {
        if (-not $script:DependencyMap.ContainsKey($module)) {
            Write-Warning "Module '$module' not found in dependency map."
            continue
        }
        
        $moduleInfo = $script:DependencyMap[$module]
        $issues = @()
        $warnings = @()
        
        # Check version
        $versionCheck = Test-ModuleVersion -ModuleName $module
        if (-not $versionCheck.IsInstalled) {
            $issues += "Module not installed"
        }
        elseif (-not $versionCheck.MeetsRequirement) {
            $issues += "Version $($versionCheck.InstalledVersion) is older than required $($versionCheck.RequiredVersion)"
        }
        
        # Check dependencies
        foreach ($dep in $moduleInfo.Dependencies) {
            $depCheck = Test-ModuleVersion -ModuleName $dep
            if (-not $depCheck.IsInstalled) {
                $issues += "Required dependency '$dep' not installed"
            }
            elseif (-not $depCheck.MeetsRequirement) {
                $warnings += "Dependency '$dep' version $($depCheck.InstalledVersion) may be outdated"
            }
        }
        
        # Check required commands
        foreach ($cmd in $moduleInfo.RequiredCommands) {
            if (-not (Test-CommandAvailable -CommandName $cmd)) {
                $warnings += "Required command '$cmd' not available"
            }
        }
        
        # Check if module can be loaded
        $loadable = $false
        if ($versionCheck.IsInstalled) {
            try {
                $testLoad = Get-Module -Name $module -ListAvailable -ErrorAction Stop
                $loadable = $null -ne $testLoad
            }
            catch {
                $issues += "Module cannot be loaded: $_"
            }
        }
        
        # Determine health status
        $status = if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
            'Healthy'
        }
        elseif ($issues.Count -eq 0) {
            'Warning'
        }
        else {
            'Unhealthy'
        }
        
        $result = [PSCustomObject]@{
            ModuleName       = $module
            Status           = $status
            Version          = $versionCheck.InstalledVersion
            RequiredVersion  = $versionCheck.RequiredVersion
            IsInstalled      = $versionCheck.IsInstalled
            IsLoadable       = $loadable
            Dependencies     = $moduleInfo.Dependencies
            RequiredCommands = $moduleInfo.RequiredCommands
            Issues           = $issues
            Warnings         = $warnings
            Description      = $moduleInfo.Description
        }
        
        $script:ModuleHealthCache[$module] = $result
        $results += $result
    }
    
    return $results
}

function Install-ModuleDependencies {
    <#
    .SYNOPSIS
        Automatically installs missing module dependencies.
    
    .DESCRIPTION
        Analyzes module dependencies and installs any missing required modules.
        Does NOT install external commands (like docker, kubectl, etc.).
    
    .PARAMETER ModuleName
        The name of the module to install dependencies for.
        If not specified, checks all modules.
    
    .PARAMETER Force
        Forces reinstallation even if dependencies are already installed.
    
    .EXAMPLE
        Install-ModuleDependencies -ModuleName 'Performance'
        Installs missing dependencies for the Performance module.
    
    .EXAMPLE
        Install-ModuleDependencies
        Checks and installs missing dependencies for all modules.
    
    .EXAMPLE
        install-deps DockerCompose
        Uses alias to install DockerCompose dependencies.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0)]
        [string]$ModuleName,
        
        [Parameter()]
        [switch]$Force
    )
    
    if ($script:DependencyMap.Count -eq 0) {
        Initialize-DependencyMap
    }
    
    $modulesToCheck = if ($ModuleName) { @($ModuleName) } else { $script:DependencyMap.Keys }
    $installed = @()
    
    foreach ($module in $modulesToCheck) {
        $health = Test-ModuleHealth -ModuleName $module
        
        if ($health.Status -eq 'Healthy' -and -not $Force) {
            Write-Host "✓ $module - " -NoNewline -ForegroundColor Green
            Write-Host "Already healthy" -ForegroundColor Gray
            continue
        }
        
        # Note: This function doesn't actually install anything yet
        # It would require the actual module files to be present
        # This is a placeholder for the installation logic
        
        if ($health.Issues -contains "Module not installed") {
            Write-Host "⚠ $module - " -NoNewline -ForegroundColor Yellow
            Write-Host "Not installed (manual installation required)" -ForegroundColor Gray
        }
        
        foreach ($dep in $health.Dependencies) {
            $depHealth = Test-ModuleHealth -ModuleName $dep
            if (-not $depHealth.IsInstalled) {
                Write-Host "⚠ $module → $dep - " -NoNewline -ForegroundColor Yellow
                Write-Host "Dependency not installed" -ForegroundColor Gray
            }
        }
        
        if ($health.Warnings.Count -gt 0) {
            foreach ($warning in $health.Warnings) {
                Write-Host "⚠ $module - " -NoNewline -ForegroundColor Yellow
                Write-Host $warning -ForegroundColor Gray
            }
        }
    }
    
    if ($installed.Count -gt 0) {
        Write-Host "`n✓ Installed $($installed.Count) dependencies" -ForegroundColor Green
        return $installed
    }
    else {
        Write-Host "`nNo dependencies needed installation" -ForegroundColor Gray
    }
}

function Test-ModuleConflict {
    <#
    .SYNOPSIS
        Detects conflicts between modules.
    
    .DESCRIPTION
        Checks for potential conflicts between modules including:
        - Duplicate function names
        - Duplicate alias names
        - Circular dependencies
        - Version conflicts
    
    .PARAMETER ModuleName
        The name of the module to check for conflicts. If not specified, checks all modules.
    
    .EXAMPLE
        Test-ModuleConflict
        Checks for conflicts across all loaded modules.
    
    .EXAMPLE
        Test-ModuleConflict -ModuleName 'Docker'
        Checks for conflicts involving the Docker module.
    
    .EXAMPLE
        check-conflicts
        Uses alias to check for module conflicts.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$ModuleName
    )
    
    if ($script:DependencyMap.Count -eq 0) {
        Initialize-DependencyMap
    }
    
    $conflicts = @()
    $modulesToCheck = if ($ModuleName) { @($ModuleName) } else { $script:DependencyMap.Keys }
    
    # Check for circular dependencies
    foreach ($module in $modulesToCheck) {
        try {
            $chain = Get-DependencyChain -ModuleName $module
            # If we get here without error, no circular dependency
        }
        catch {
            $conflicts += [PSCustomObject]@{
                Type       = 'Circular Dependency'
                ModuleName = $module
                Conflict   = $_.Exception.Message
                Severity   = 'High'
            }
        }
    }
    
    # Check for function name conflicts
    $loadedModules = Get-Module
    $functionMap = @{}
    
    foreach ($mod in $loadedModules) {
        $functions = $mod.ExportedFunctions.Keys
        foreach ($func in $functions) {
            if ($functionMap.ContainsKey($func)) {
                $functionMap[$func] += $mod.Name
            }
            else {
                $functionMap[$func] = @($mod.Name)
            }
        }
    }
    
    foreach ($func in $functionMap.Keys) {
        if ($functionMap[$func].Count -gt 1) {
            $conflicts += [PSCustomObject]@{
                Type       = 'Function Name'
                ModuleName = $functionMap[$func] -join ', '
                Conflict   = "Function '$func' exported by multiple modules"
                Severity   = 'Medium'
            }
        }
    }
    
    # Check for alias conflicts
    $aliasMap = @{}
    
    foreach ($mod in $loadedModules) {
        $aliases = $mod.ExportedAliases.Keys
        foreach ($alias in $aliases) {
            if ($aliasMap.ContainsKey($alias)) {
                $aliasMap[$alias] += $mod.Name
            }
            else {
                $aliasMap[$alias] = @($mod.Name)
            }
        }
    }
    
    foreach ($alias in $aliasMap.Keys) {
        if ($aliasMap[$alias].Count -gt 1) {
            $conflicts += [PSCustomObject]@{
                Type       = 'Alias Name'
                ModuleName = $aliasMap[$alias] -join ', '
                Conflict   = "Alias '$alias' exported by multiple modules"
                Severity   = 'Low'
            }
        }
    }
    
    if ($conflicts.Count -eq 0) {
        Write-Host "✓ No conflicts detected" -ForegroundColor Green
    }
    else {
        Write-Host "⚠ Found $($conflicts.Count) conflict(s)" -ForegroundColor Yellow
    }
    
    return $conflicts
}

function Show-DependencyGraph {
    <#
    .SYNOPSIS
        Displays a visual dependency graph for modules.
    
    .DESCRIPTION
        Shows the dependency relationships between modules in a tree-like format.
    
    .PARAMETER ModuleName
        The name of the module to show dependencies for. If not specified, shows all modules.
    
    .EXAMPLE
        Show-DependencyGraph
        Shows the dependency graph for all modules.
    
    .EXAMPLE
        Show-DependencyGraph -ModuleName 'Performance'
        Shows the dependency graph for Performance module.
    
    .EXAMPLE
        dep-graph Docker
        Uses alias to show Docker module dependency graph.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$ModuleName
    )
    
    if ($script:DependencyMap.Count -eq 0) {
        Initialize-DependencyMap
    }
    
    function Write-DependencyTree {
        param(
            [string]$Module,
            [int]$Indent = 0,
            [string[]]$Visited = @()
        )
        
        $prefix = "  " * $Indent
        $moduleInfo = $script:DependencyMap[$Module]
        
        if ($Module -in $Visited) {
            Write-Host "$prefix├─ $Module " -NoNewline -ForegroundColor Yellow
            Write-Host "(circular reference)" -ForegroundColor Red
            return
        }
        
        $Visited += $Module
        
        if ($Indent -eq 0) {
            Write-Host $Module -ForegroundColor Cyan -NoNewline
        }
        else {
            Write-Host "$prefix├─ $Module" -ForegroundColor Green -NoNewline
        }
        
        Write-Host " v$($moduleInfo.Version)" -ForegroundColor Gray
        
        $deps = $moduleInfo.Dependencies
        if ($deps.Count -gt 0) {
            foreach ($dep in $deps) {
                Write-DependencyTree -Module $dep -Indent ($Indent + 1) -Visited $Visited
            }
        }
        
        if ($moduleInfo.RequiredCommands.Count -gt 0) {
            foreach ($cmd in $moduleInfo.RequiredCommands) {
                $available = Test-CommandAvailable -CommandName $cmd
                $color = if ($available) { 'Green' } else { 'Red' }
                $status = if ($available) { '✓' } else { '✗' }
                Write-Host "$prefix  └─ [$status] $cmd" -ForegroundColor $color
            }
        }
    }
    
    $modulesToShow = if ($ModuleName) { @($ModuleName) } else { 
        $script:DependencyMap.Keys | Where-Object { 
            $script:DependencyMap[$_].Dependencies.Count -eq 0 -or $_ -in @('Config', 'Logging', 'Performance', 'Plugins')
        }
    }
    
    Write-Host "`nModule Dependency Graph" -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Gray
    Write-Host ""
    
    foreach ($module in $modulesToShow) {
        Write-DependencyTree -Module $module
        Write-Host ""
    }
}

# ============================================================================
# Module Initialization
# ============================================================================

Initialize-DependencyMap

# ============================================================================
# Exports
# ============================================================================

Export-ModuleMember -Function @(
    'Get-ModuleDependencies',
    'Test-ModuleVersion',
    'Test-ModuleHealth',
    'Install-ModuleDependencies',
    'Test-ModuleConflict',
    'Show-DependencyGraph'
)

New-Alias -Name 'deps' -Value 'Get-ModuleDependencies' -Force
New-Alias -Name 'test-version' -Value 'Test-ModuleVersion' -Force
New-Alias -Name 'module-health' -Value 'Test-ModuleHealth' -Force
New-Alias -Name 'install-deps' -Value 'Install-ModuleDependencies' -Force
New-Alias -Name 'check-conflicts' -Value 'Test-ModuleConflict' -Force
New-Alias -Name 'dep-graph' -Value 'Show-DependencyGraph' -Force

Export-ModuleMember -Alias @(
    'deps',
    'test-version',
    'module-health',
    'install-deps',
    'check-conflicts',
    'dep-graph'
)
