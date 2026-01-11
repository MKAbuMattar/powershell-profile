#---------------------------------------------------------------------------------------------------
# Performance Module
# Version: 1.0.0
# Author: Mohammad Abu Mattar
# Description: Provides performance monitoring, benchmarking, and optimization tools
#---------------------------------------------------------------------------------------------------

#region Private Variables

# Global variable to store profile startup time
$script:ProfileStartTime = Get-Date
$script:ModuleLoadTimes = @{}
$script:PerformanceCache = @{}

#endregion

#region Private Functions

<#
.SYNOPSIS
    Initializes the cache directory for performance data.
.DESCRIPTION
    Creates the cache directory at ~/.cache/ps1-profile-perf if it doesn't exist.
.EXAMPLE
    Initialize-CacheDirectory
#>
function Initialize-CacheDirectory {
    [CmdletBinding()]
    param()

    $cacheDir = Join-Path $HOME '.cache'
    $perfCacheDir = Join-Path $cacheDir 'ps1-profile-perf'

    if (-not (Test-Path $perfCacheDir)) {
        New-Item -Path $perfCacheDir -ItemType Directory -Force | Out-Null
    }

    return $perfCacheDir
}

<#
.SYNOPSIS
    Formats a timespan into a human-readable string.
.DESCRIPTION
    Converts a TimeSpan object into a human-readable format (e.g., "1.23s", "456ms").
.PARAMETER TimeSpan
    The TimeSpan object to format.
.EXAMPLE
    Format-TimeSpan -TimeSpan $elapsed
#>
function Format-TimeSpan {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [TimeSpan]$TimeSpan
    )

    if ($TimeSpan.TotalSeconds -ge 1) {
        return "{0:N2}s" -f $TimeSpan.TotalSeconds
    }
    else {
        return "{0:N0}ms" -f $TimeSpan.TotalMilliseconds
    }
}

<#
.SYNOPSIS
    Formats bytes into a human-readable size.
.DESCRIPTION
    Converts bytes into appropriate units (B, KB, MB, GB).
.PARAMETER Bytes
    The number of bytes to format.
.EXAMPLE
    Format-Bytes -Bytes 1024000
#>
function Format-Bytes {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [long]$Bytes
    )

    $sizes = 'B', 'KB', 'MB', 'GB', 'TB'
    $index = 0
    $value = [double]$Bytes

    while ($value -ge 1024 -and $index -lt ($sizes.Count - 1)) {
        $value = $value / 1024
        $index++
    }

    return "{0:N2} {1}" -f $value, $sizes[$index]
}

#endregion

#region Public Functions

<#
.SYNOPSIS
    Measures the total profile startup time.
.DESCRIPTION
    The Measure-ProfileStartup function calculates and displays the time taken
    for the PowerShell profile to load. It provides detailed timing information
    including module load times.

    This function helps identify performance bottlenecks in your profile startup.
.PARAMETER Detailed
    (Optional) When specified, displays detailed timing information for each module.
.INPUTS
    None. You cannot pipe objects to this function.
.OUTPUTS
    PSCustomObject
        Returns an object containing:
        - TotalTime: Total profile load time
        - ModuleCount: Number of modules loaded
        - AverageModuleTime: Average time per module
        - SlowestModule: The slowest loading module
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    This function relies on timing data collected during profile initialization.
    Results are most accurate when called shortly after profile loads.
.EXAMPLE
    Measure-ProfileStartup

    Description
    -----------
    Displays basic profile startup timing information.
.EXAMPLE
    Measure-ProfileStartup -Detailed

    Description
    -----------
    Displays detailed timing information including per-module load times.
.EXAMPLE
    $timing = Measure-ProfileStartup
    Write-Host "Profile loaded in $($timing.TotalTime)"

    Description
    -----------
    Captures timing data into a variable for programmatic use.
.LINK
    Get-ModuleLoadTime
.LINK
    Test-ModulePerformance
#>
function Measure-ProfileStartup {
    [CmdletBinding()]
    [Alias('measure-startup')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        [switch]$Detailed
    )

    $endTime = Get-Date
    $elapsed = $endTime - $script:ProfileStartTime
    $totalTimeStr = Format-TimeSpan $elapsed

    Write-Host "`n=== Profile Startup Performance ===" -ForegroundColor Cyan
    Write-Host "Total Time: $totalTimeStr" -ForegroundColor Green

    if ($script:ModuleLoadTimes.Count -gt 0) {
        $avgTime = ($script:ModuleLoadTimes.Values | Measure-Object -Average).Average
        $slowest = $script:ModuleLoadTimes.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1
        $avgTimeStr = Format-TimeSpan ([TimeSpan]::FromMilliseconds($avgTime))
        $slowestTimeStr = Format-TimeSpan ([TimeSpan]::FromMilliseconds($slowest.Value))

        Write-Host "Modules Loaded: $($script:ModuleLoadTimes.Count)" -ForegroundColor Yellow
        Write-Host "Average Module Load Time: $avgTimeStr" -ForegroundColor Yellow
        Write-Host "Slowest Module: $($slowest.Name) - $slowestTimeStr" -ForegroundColor Red

        if ($Detailed) {
            Write-Host "`nDetailed Module Load Times:" -ForegroundColor Cyan
            $script:ModuleLoadTimes.GetEnumerator() | 
            Sort-Object Value -Descending |
            ForEach-Object {
                $timeStr = Format-TimeSpan ([TimeSpan]::FromMilliseconds($_.Value))
                Write-Host "  $($_.Name): $timeStr" -ForegroundColor Gray
            }
        }
    }

    Write-Host ""

    return [PSCustomObject]@{
        TotalTime         = $elapsed
        ModuleCount       = $script:ModuleLoadTimes.Count
        AverageModuleTime = if ($script:ModuleLoadTimes.Count -gt 0) { [TimeSpan]::FromMilliseconds($avgTime) } else { [TimeSpan]::Zero }
        SlowestModule     = if ($slowest) { $slowest.Name } else { $null }
        SlowestModuleTime = if ($slowest) { [TimeSpan]::FromMilliseconds($slowest.Value) } else { [TimeSpan]::Zero }
    }
}

<#
.SYNOPSIS
    Gets the load time for individual modules.
.DESCRIPTION
    The Get-ModuleLoadTime function retrieves timing information for modules
    that were loaded during profile initialization. It can show times for
    specific modules or all loaded modules.

    Use this function to identify which modules are taking the longest to load
    and may benefit from lazy loading or optimization.
.PARAMETER ModuleName
    (Optional) The name of a specific module to query. If not specified,
    returns timing for all modules.
.INPUTS
    System.String
        You can pipe module names to this function.
.OUTPUTS
    PSCustomObject
        Returns objects containing:
        - ModuleName: Name of the module
        - LoadTime: Time taken to load the module
        - LoadTimeMs: Load time in milliseconds
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    Module load times are captured during profile initialization. This function
    only reports on modules that have timing data available.
.EXAMPLE
    Get-ModuleLoadTime

    Description
    -----------
    Lists load times for all modules.
.EXAMPLE
    Get-ModuleLoadTime -ModuleName "Plugins"

    Description
    -----------
    Shows the load time for the Plugins module specifically.
.EXAMPLE
    Get-ModuleLoadTime | Sort-Object LoadTimeMs -Descending | Select-Object -First 5

    Description
    -----------
    Shows the 5 slowest loading modules.
.LINK
    Measure-ProfileStartup
.LINK
    Test-ModulePerformance
#>
function Get-ModuleLoadTime {
    [CmdletBinding()]
    [Alias('module-time')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$ModuleName
    )

    process {
        if ($ModuleName) {
            if ($script:ModuleLoadTimes.ContainsKey($ModuleName)) {
                $timeMs = $script:ModuleLoadTimes[$ModuleName]
                return [PSCustomObject]@{
                    ModuleName = $ModuleName
                    LoadTime   = Format-TimeSpan ([TimeSpan]::FromMilliseconds($timeMs))
                    LoadTimeMs = $timeMs
                }
            }
            else {
                Write-Warning "No timing data found for module: $ModuleName"
            }
        }
        else {
            $script:ModuleLoadTimes.GetEnumerator() | 
            Sort-Object Value -Descending |
            ForEach-Object {
                [PSCustomObject]@{
                    ModuleName = $_.Name
                    LoadTime   = Format-TimeSpan ([TimeSpan]::FromMilliseconds($_.Value))
                    LoadTimeMs = $_.Value
                }
            }
        }
    }
}

<#
.SYNOPSIS
    Tests and benchmarks module loading performance.
.DESCRIPTION
    The Test-ModulePerformance function provides detailed performance analysis
    for PowerShell modules. It can test specific modules or all available modules,
    measuring load times, memory usage, and providing recommendations for optimization.

    This is useful for identifying performance bottlenecks and deciding which
    modules should be lazy-loaded or optimized.
.PARAMETER ModulePath
    (Optional) The path to a specific module to test. If not specified, tests
    all modules in the profile.
.PARAMETER Iterations
    (Optional) Number of times to load/unload the module for accurate timing.
    Default is 3 iterations. More iterations provide more accurate results but
    take longer.
.INPUTS
    System.String
        You can pipe module paths to this function.
.OUTPUTS
    PSCustomObject
        Returns objects containing:
        - ModuleName: Name of the tested module
        - AverageLoadTime: Average time to load across iterations
        - MinLoadTime: Fastest load time
        - MaxLoadTime: Slowest load time
        - MemoryImpact: Memory used by the module
        - Recommendation: Optimization suggestion
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    This function temporarily loads and unloads modules for testing, which may
    affect your current session. Results are based on multiple iterations for
    statistical accuracy.

    Recommendations:
    - <100ms: Fast loading, keep as-is
    - 100-500ms: Consider lazy loading
    - >500ms: Strong candidate for lazy loading or optimization
.EXAMPLE
    Test-ModulePerformance

    Description
    -----------
    Tests performance of all profile modules.
.EXAMPLE
    Test-ModulePerformance -ModulePath "C:\Path\To\Module.psd1"

    Description
    -----------
    Tests a specific module's performance.
.EXAMPLE
    Test-ModulePerformance -Iterations 5

    Description
    -----------
    Tests all modules with 5 iterations for more accurate results.
.LINK
    Get-ModuleLoadTime
.LINK
    Get-PerformanceReport
#>
function Test-ModulePerformance {
    [CmdletBinding()]
    [Alias('test-perf')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$ModulePath,

        [Parameter()]
        [ValidateRange(1, 10)]
        [int]$Iterations = 3
    )

    begin {
        Write-Host "`n=== Module Performance Test ===" -ForegroundColor Cyan
        Write-Host "Iterations per module: $Iterations`n" -ForegroundColor Yellow
    }

    process {
        $modulesToTest = @()

        if ($ModulePath) {
            $modulesToTest += $ModulePath
        }
        else {
            # Test all profile modules
            $BaseModuleDir = Join-Path -Path $PSScriptRoot -ChildPath '..'
            Get-ChildItem -Path $BaseModuleDir -Filter "*.psd1" -Recurse | 
            ForEach-Object { $modulesToTest += $_.FullName }
        }

        foreach ($module in $modulesToTest) {
            if (-not (Test-Path $module)) {
                Write-Warning "Module not found: $module"
                continue
            }

            $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($module)
            Write-Host "Testing: $moduleName" -ForegroundColor Cyan

            $times = @()
            
            # Force garbage collection for more accurate memory measurement
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
            Start-Sleep -Milliseconds 100
            $memBefore = (Get-Process -Id $PID).WorkingSet64

            for ($i = 0; $i -lt $Iterations; $i++) {
                $sw = [System.Diagnostics.Stopwatch]::StartNew()
                Import-Module $module -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                $sw.Stop()
                $times += $sw.ElapsedMilliseconds

                # Unload for next iteration
                Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
            }

            # Load one final time for memory measurement
            Import-Module $module -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            $memAfter = (Get-Process -Id $PID).WorkingSet64
            # Use absolute value to avoid negative memory (due to GC)
            $memImpact = [Math]::Abs($memAfter - $memBefore)

            $avgTime = ($times | Measure-Object -Average).Average
            $minTime = ($times | Measure-Object -Minimum).Minimum
            $maxTime = ($times | Measure-Object -Maximum).Maximum

            # Determine recommendation
            $recommendation = if ($avgTime -lt 100) {
                "Fast - Keep as-is"
            }
            elseif ($avgTime -lt 500) {
                "Consider lazy loading"
            }
            else {
                "High load time - Lazy load recommended"
            }

            # Inline formatting to avoid scope issues during module testing
            $avgTimeSpan = [TimeSpan]::FromMilliseconds($avgTime)
            $avgTimeStr = if ($avgTimeSpan.TotalSeconds -ge 1) { "{0:N2}s" -f $avgTimeSpan.TotalSeconds } else { "{0:N0}ms" -f $avgTimeSpan.TotalMilliseconds }
            
            $minTimeSpan = [TimeSpan]::FromMilliseconds($minTime)
            $minTimeStr = if ($minTimeSpan.TotalSeconds -ge 1) { "{0:N2}s" -f $minTimeSpan.TotalSeconds } else { "{0:N0}ms" -f $minTimeSpan.TotalMilliseconds }
            
            $maxTimeSpan = [TimeSpan]::FromMilliseconds($maxTime)
            $maxTimeStr = if ($maxTimeSpan.TotalSeconds -ge 1) { "{0:N2}s" -f $maxTimeSpan.TotalSeconds } else { "{0:N0}ms" -f $maxTimeSpan.TotalMilliseconds }
            
            # Format bytes inline
            $sizes = 'B', 'KB', 'MB', 'GB', 'TB'
            $index = 0
            $value = [double]$memImpact
            while ($value -ge 1024 -and $index -lt ($sizes.Count - 1)) {
                $value = $value / 1024
                $index++
            }
            $memImpactStr = "{0:N2} {1}" -f $value, $sizes[$index]

            $result = [PSCustomObject]@{
                ModuleName      = $moduleName
                AverageLoadTime = $avgTimeStr
                MinLoadTime     = $minTimeStr
                MaxLoadTime     = $maxTimeStr
                MemoryImpact    = $memImpactStr
                Recommendation  = $recommendation
            }

            Write-Host "  Avg: $avgTimeStr | Min: $minTimeStr | Max: $maxTimeStr" -ForegroundColor Gray
            Write-Host "  Memory: $memImpactStr | $recommendation`n" -ForegroundColor Gray

            $result
        }
    }
}

<#
.SYNOPSIS
    Generates a comprehensive performance report.
.DESCRIPTION
    The Get-PerformanceReport function creates a detailed performance analysis
    of your PowerShell profile, including startup times, module load times,
    memory usage, and recommendations for optimization.

    The report can be displayed in the console or exported to a file for
    later analysis or sharing.
.PARAMETER ExportPath
    (Optional) Path to export the report as JSON. If not specified, displays
    the report in the console only.
.PARAMETER IncludeSystemInfo
    (Optional) When specified, includes detailed system information in the report
    such as PowerShell version, OS version, and hardware details.
.INPUTS
    None. You cannot pipe objects to this function.
.OUTPUTS
    PSCustomObject
        Returns a comprehensive performance report object containing:
        - ProfileStartupTime: Total profile load time
        - ModuleTiming: Detailed module load times
        - MemoryUsage: Current memory usage statistics
        - SystemInfo: System information (if requested)
        - Recommendations: Optimization suggestions
        - Timestamp: When the report was generated
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    This function provides a comprehensive view of profile performance and is
    useful for both troubleshooting and optimization efforts.

    The report can be compared over time to track performance improvements
    or regressions.
.EXAMPLE
    Get-PerformanceReport

    Description
    -----------
    Displays a performance report in the console.
.EXAMPLE
    Get-PerformanceReport -IncludeSystemInfo

    Description
    -----------
    Generates a detailed report including system information.
.EXAMPLE
    Get-PerformanceReport -ExportPath "~/perf-report.json"

    Description
    -----------
    Exports the performance report to a JSON file.
.EXAMPLE
    $report = Get-PerformanceReport
    $report.ModuleTiming | Sort-Object LoadTimeMs -Descending | Select-Object -First 5

    Description
    -----------
    Gets the 5 slowest loading modules from the report.
.LINK
    Measure-ProfileStartup
.LINK
    Get-ProfileMemoryUsage
#>
function Get-PerformanceReport {
    [CmdletBinding()]
    [Alias('perf-report')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        [string]$ExportPath,

        [Parameter()]
        [switch]$IncludeSystemInfo
    )

    $endTime = Get-Date
    $totalTime = $endTime - $script:ProfileStartTime
    $totalTimeStr = Format-TimeSpan $totalTime
    $dateStr = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

    Write-Host "`n=== Performance Report ===" -ForegroundColor Cyan
    Write-Host "Generated: $dateStr`n" -ForegroundColor Gray

    # Profile timing
    Write-Host "Profile Startup:" -ForegroundColor Yellow
    Write-Host "  Total Time: $totalTimeStr" -ForegroundColor Green
    Write-Host "  Modules Loaded: $($script:ModuleLoadTimes.Count)" -ForegroundColor Green

    # Module timing
    if ($script:ModuleLoadTimes.Count -gt 0) {
        Write-Host "`nModule Load Times:" -ForegroundColor Yellow
        $sortedModules = $script:ModuleLoadTimes.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
        foreach ($mod in $sortedModules) {
            $timeStr = Format-TimeSpan ([TimeSpan]::FromMilliseconds($mod.Value))
            Write-Host "  $($mod.Name): $timeStr" -ForegroundColor Gray
        }
    }

    # Memory usage
    $memInfo = Get-ProfileMemoryUsage
    $workingSetStr = Format-Bytes $memInfo.WorkingSet
    $privateMemStr = Format-Bytes $memInfo.PrivateMemorySize
    Write-Host "`nMemory Usage:" -ForegroundColor Yellow
    Write-Host "  Current: $workingSetStr" -ForegroundColor Green
    Write-Host "  Private: $privateMemStr" -ForegroundColor Green

    # System info
    $systemInfo = $null
    if ($IncludeSystemInfo) {
        $systemInfo = @{
            PSVersion = $PSVersionTable.PSVersion.ToString()
            OS        = [System.Environment]::OSVersion.ToString()
            Platform  = $PSVersionTable.Platform
            Edition   = $PSVersionTable.PSEdition
        }

        Write-Host "`nSystem Information:" -ForegroundColor Yellow
        Write-Host "  PowerShell: $($systemInfo.PSVersion)" -ForegroundColor Green
        Write-Host "  Edition: $($systemInfo.Edition)" -ForegroundColor Green
        Write-Host "  Platform: $($systemInfo.Platform)" -ForegroundColor Green
    }

    # Recommendations
    Write-Host "`nRecommendations:" -ForegroundColor Yellow
    $recommendations = @()

    if ($totalTime.TotalSeconds -gt 3) {
        $rec = "Profile loads slowly (>3s). Consider implementing lazy loading for non-critical modules."
        Write-Host "  • $rec" -ForegroundColor Red
        $recommendations += $rec
    }

    $slowModules = $script:ModuleLoadTimes.GetEnumerator() | Where-Object { $_.Value -gt 500 }
    if ($slowModules) {
        $rec = "Slow loading modules detected: $($slowModules.Name -join ', '). Consider lazy loading."
        Write-Host "  • $rec" -ForegroundColor Red
        $recommendations += $rec
    }

    if ($memInfo.WorkingSet -gt 200MB) {
        $rec = "High memory usage detected (>200MB). Review loaded modules and consider cleanup."
        Write-Host "  • $rec" -ForegroundColor Yellow
        $recommendations += $rec
    }

    if ($recommendations.Count -eq 0) {
        Write-Host "  ✓ Performance looks good!" -ForegroundColor Green
    }

    Write-Host ""

    $report = [PSCustomObject]@{
        Timestamp          = $endTime
        ProfileStartupTime = $totalTime.TotalMilliseconds
        ModuleCount        = $script:ModuleLoadTimes.Count
        ModuleTiming       = $script:ModuleLoadTimes
        MemoryUsage        = $memInfo
        SystemInfo         = $systemInfo
        Recommendations    = $recommendations
    }

    if ($ExportPath) {
        $report | ConvertTo-Json -Depth 5 | Set-Content -Path $ExportPath
        Write-Host "Report exported to: $ExportPath" -ForegroundColor Green
    }

    return $report
}

<#
.SYNOPSIS
    Gets current memory usage of the PowerShell process.
.DESCRIPTION
    The Get-ProfileMemoryUsage function retrieves detailed memory usage statistics
    for the current PowerShell process. This includes working set, private memory,
    virtual memory, and garbage collection information.

    Use this function to monitor memory consumption and identify potential
    memory leaks or excessive memory usage.
.INPUTS
    None. You cannot pipe objects to this function.
.OUTPUTS
    PSCustomObject
        Returns an object containing:
        - WorkingSet: Physical memory in use
        - PrivateMemorySize: Private bytes allocated
        - VirtualMemorySize: Virtual memory allocated
        - GC_Gen0: Gen0 garbage collections
        - GC_Gen1: Gen1 garbage collections
        - GC_Gen2: Gen2 garbage collections
        - TotalMemory: Total managed memory
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    Memory usage can vary significantly based on:
    - Number of loaded modules
    - Command history
    - Variables in scope
    - Background jobs

    Typical PowerShell memory usage:
    - Light usage: 50-100MB
    - Moderate usage: 100-200MB
    - Heavy usage: 200MB+
.EXAMPLE
    Get-ProfileMemoryUsage

    Description
    -----------
    Displays current memory usage statistics.
.EXAMPLE
    $mem = Get-ProfileMemoryUsage
    Write-Host "Using $(Format-Bytes $mem.WorkingSet) of RAM"

    Description
    -----------
    Gets memory usage and formats it for display.
.EXAMPLE
    Get-ProfileMemoryUsage | Format-Table

    Description
    -----------
    Displays memory statistics in a table format.
.LINK
    Get-PerformanceReport
.LINK
    Show-PerformanceDashboard
#>
function Get-ProfileMemoryUsage {
    [CmdletBinding()]
    [Alias('mem-usage')]
    [OutputType([PSCustomObject])]
    param()

    $process = Get-Process -Id $PID

    return [PSCustomObject]@{
        WorkingSet        = $process.WorkingSet64
        PrivateMemorySize = $process.PrivateMemorySize64
        VirtualMemorySize = $process.VirtualMemorySize64
        GC_Gen0           = [System.GC]::CollectionCount(0)
        GC_Gen1           = [System.GC]::CollectionCount(1)
        GC_Gen2           = [System.GC]::CollectionCount(2)
        TotalMemory       = [System.GC]::GetTotalMemory($false)
    }
}

<#
.SYNOPSIS
    Adds a value to the performance cache.
.DESCRIPTION
    The Set-PerformanceCache function stores a key-value pair in the performance
    cache. This cache can be used to store results of expensive operations to
    improve performance on subsequent calls.

    The cache persists for the duration of the PowerShell session and can be
    optionally saved to disk for persistence across sessions.
.PARAMETER Key
    The unique identifier for the cached value.
.PARAMETER Value
    The value to cache. Can be any object type.
.PARAMETER Expiration
    (Optional) Time in seconds after which the cache entry expires. Default is
    3600 seconds (1 hour). Set to 0 for no expiration.
.PARAMETER Persist
    (Optional) When specified, saves the cache entry to disk for persistence
    across PowerShell sessions.
.INPUTS
    None. You cannot pipe objects to this function directly.
.OUTPUTS
    None. This function does not generate output.
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    The cache is stored in memory by default. Persistent cache entries are
    stored in ~/.cache/ps1-profile-perf/

    Use caching for:
    - Network API responses
    - File system queries
    - Complex calculations
    - Expensive object constructions

    Avoid caching:
    - Rapidly changing data
    - Large objects (>1MB)
    - Sensitive information
.EXAMPLE
    Set-PerformanceCache -Key "ApiResult" -Value $data

    Description
    -----------
    Caches an API result with default 1-hour expiration.
.EXAMPLE
    Set-PerformanceCache -Key "StaticData" -Value $config -Expiration 0

    Description
    -----------
    Caches configuration data with no expiration.
.EXAMPLE
    Set-PerformanceCache -Key "UserData" -Value $userData -Persist

    Description
    -----------
    Caches user data and persists it to disk.
.LINK
    Get-PerformanceCache
.LINK
    Clear-PerformanceCache
#>
function Set-PerformanceCache {
    [CmdletBinding()]
    [Alias('set-cache')]
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [object]$Value,

        [Parameter()]
        [int]$Expiration = 3600,

        [Parameter()]
        [switch]$Persist
    )

    $cacheEntry = @{
        Value      = $Value
        Timestamp  = Get-Date
        Expiration = $Expiration
    }

    $script:PerformanceCache[$Key] = $cacheEntry

    if ($Persist) {
        $cacheDir = Initialize-CacheDirectory
        $cachePath = Join-Path $cacheDir "$Key.json"
        $cacheEntry | ConvertTo-Json -Depth 5 | Set-Content -Path $cachePath
    }

    Write-Verbose "Cached: $Key (Expires in $Expiration seconds)"
}

<#
.SYNOPSIS
    Retrieves a value from the performance cache.
.DESCRIPTION
    The Get-PerformanceCache function retrieves a previously cached value by its key.
    If the cache entry has expired or doesn't exist, returns $null or a specified
    default value.

    This function is used in conjunction with Set-PerformanceCache to implement
    caching for expensive operations.
.PARAMETER Key
    The unique identifier of the cached value to retrieve.
.PARAMETER Default
    (Optional) The value to return if the cache entry doesn't exist or has expired.
.INPUTS
    System.String
        You can pipe cache keys to this function.
.OUTPUTS
    System.Object
        Returns the cached value, the default value, or $null if not found.
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    This function automatically handles cache expiration. Expired entries are
    treated as non-existent and will trigger a cache miss.

    For persistent cache entries, the function attempts to load from disk if
    not found in memory.
.EXAMPLE
    $data = Get-PerformanceCache -Key "ApiResult"

    Description
    -----------
    Retrieves a cached API result, returns $null if not found.
.EXAMPLE
    $config = Get-PerformanceCache -Key "Config" -Default @{}

    Description
    -----------
    Retrieves cached configuration, returns empty hashtable if not found.
.EXAMPLE
    if ($null -eq (Get-PerformanceCache -Key "Data")) {
        $data = Get-ExpensiveData
        Set-PerformanceCache -Key "Data" -Value $data
    }

    Description
    -----------
    Implements cache-aside pattern for expensive operations.
.LINK
    Set-PerformanceCache
.LINK
    Clear-PerformanceCache
#>
function Get-PerformanceCache {
    [CmdletBinding()]
    [Alias('get-cache')]
    [OutputType([object])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Key,

        [Parameter()]
        [object]$Default = $null
    )

    process {
        # Check memory cache first
        if ($script:PerformanceCache.ContainsKey($Key)) {
            $entry = $script:PerformanceCache[$Key]
            $age = (Get-Date) - $entry.Timestamp

            # Check if expired
            if ($entry.Expiration -eq 0 -or $age.TotalSeconds -lt $entry.Expiration) {
                Write-Verbose "Cache hit: $Key"
                return $entry.Value
            }
            else {
                # Expired, remove from cache
                $script:PerformanceCache.Remove($Key)
                Write-Verbose "Cache expired: $Key"
            }
        }

        # Try to load from disk
        $cacheDir = Initialize-CacheDirectory
        $cachePath = Join-Path $cacheDir "$Key.json"

        if (Test-Path $cachePath) {
            try {
                $entry = Get-Content -Path $cachePath -Raw | ConvertFrom-Json
                $timestamp = [datetime]$entry.Timestamp
                $age = (Get-Date) - $timestamp

                if ($entry.Expiration -eq 0 -or $age.TotalSeconds -lt $entry.Expiration) {
                    # Load into memory cache
                    $script:PerformanceCache[$Key] = @{
                        Value      = $entry.Value
                        Timestamp  = $timestamp
                        Expiration = $entry.Expiration
                    }
                    Write-Verbose "Cache loaded from disk: $Key"
                    return $entry.Value
                }
                else {
                    # Expired disk cache
                    Remove-Item -Path $cachePath -Force
                    Write-Verbose "Disk cache expired: $Key"
                }
            }
            catch {
                Write-Verbose "Failed to load disk cache: $Key - $_"
            }
        }

        Write-Verbose "Cache miss: $Key"
        return $Default
    }
}

<#
.SYNOPSIS
    Clears cached performance data.
.DESCRIPTION
    The Clear-PerformanceCache function removes cached entries from memory and
    optionally from disk. You can clear specific cache entries by key, or clear
    all cached data.

    Use this function to free memory or force fresh data retrieval for cached
    operations.
.PARAMETER Key
    (Optional) The specific cache entry to clear. If not specified, clears all
    cache entries.
.PARAMETER IncludeDisk
    (Optional) When specified, also removes persistent cache files from disk.
.INPUTS
    System.String
        You can pipe cache keys to this function.
.OUTPUTS
    None. This function does not generate output.
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    Clearing the cache will cause subsequent operations to recalculate or
    re-fetch data, which may temporarily impact performance.

    Use cases for clearing cache:
    - Freeing memory
    - Forcing data refresh
    - Troubleshooting stale data
    - Session cleanup
.EXAMPLE
    Clear-PerformanceCache

    Description
    -----------
    Clears all cached entries from memory.
.EXAMPLE
    Clear-PerformanceCache -Key "ApiResult"

    Description
    -----------
    Clears a specific cache entry.
.EXAMPLE
    Clear-PerformanceCache -IncludeDisk

    Description
    -----------
    Clears all cache entries from both memory and disk.
.EXAMPLE
    Get-PerformanceCache -Key "*" | Clear-PerformanceCache

    Description
    -----------
    Clears cache entries matching a pattern.
.LINK
    Get-PerformanceCache
.LINK
    Set-PerformanceCache
#>
function Clear-PerformanceCache {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [Alias('clear-cache')]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$Key,

        [Parameter()]
        [switch]$IncludeDisk
    )

    process {
        if ($Key) {
            if ($PSCmdlet.ShouldProcess("Cache entry '$Key'", "Clear")) {
                if ($script:PerformanceCache.ContainsKey($Key)) {
                    $script:PerformanceCache.Remove($Key)
                    Write-Verbose "Cleared cache: $Key"
                }

                if ($IncludeDisk) {
                    $cacheDir = Initialize-CacheDirectory
                    $cachePath = Join-Path $cacheDir "$Key.json"
                    if (Test-Path $cachePath) {
                        Remove-Item -Path $cachePath -Force
                        Write-Verbose "Cleared disk cache: $Key"
                    }
                }
            }
        }
        else {
            if ($PSCmdlet.ShouldProcess("All cache entries", "Clear")) {
                $script:PerformanceCache.Clear()
                Write-Host "Cleared all cache entries" -ForegroundColor Green

                if ($IncludeDisk) {
                    $cacheDir = Initialize-CacheDirectory
                    if (Test-Path $cacheDir) {
                        Get-ChildItem -Path $cacheDir -Filter "*.json" | Remove-Item -Force
                        Write-Host "Cleared disk cache" -ForegroundColor Green
                    }
                }
            }
        }
    }
}

<#
.SYNOPSIS
    Displays a real-time performance dashboard.
.DESCRIPTION
    The Show-PerformanceDashboard function creates an interactive, real-time
    dashboard displaying key performance metrics for your PowerShell session.
    The dashboard updates continuously and shows:
    
    - Profile startup time
    - Module load times
    - Current memory usage
    - CPU usage
    - Top loaded modules
    - Cache statistics

    Press Ctrl+C to exit the dashboard.
.PARAMETER RefreshInterval
    (Optional) Time in seconds between dashboard updates. Default is 2 seconds.
    Minimum is 1 second.
.INPUTS
    None. You cannot pipe objects to this function.
.OUTPUTS
    None. This function displays output directly to the console.
.NOTES
    Module: Performance
    Version: 1.0.0
    Author: Mohammad Abu Mattar
    
    The dashboard provides a high-level overview of PowerShell performance and
    resource usage. It's particularly useful for:
    - Monitoring long-running sessions
    - Identifying performance trends
    - Troubleshooting performance issues
    - Demonstrating profile optimizations

    The dashboard will continue running until interrupted with Ctrl+C.
.EXAMPLE
    Show-PerformanceDashboard

    Description
    -----------
    Displays the performance dashboard with default 2-second refresh.
.EXAMPLE
    Show-PerformanceDashboard -RefreshInterval 5

    Description
    -----------
    Displays the dashboard with 5-second refresh interval.
.LINK
    Get-PerformanceReport
.LINK
    Measure-ProfileStartup
#>
function Show-PerformanceDashboard {
    [CmdletBinding()]
    [Alias('perf-dash', 'dashboard')]
    param(
        [Parameter()]
        [ValidateRange(1, 60)]
        [int]$RefreshInterval = 2
    )

    Write-Host "`nStarting Performance Dashboard..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to exit`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 1

    try {
        while ($true) {
            Clear-Host

            # Header
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║         PowerShell Performance Dashboard                      ║" -ForegroundColor Cyan
            Write-Host "║         $timestamp                                    ║" -ForegroundColor Cyan
            Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host ""

            # Profile Stats
            $elapsed = (Get-Date) - $script:ProfileStartTime
            $elapsedStr = Format-TimeSpan $elapsed
            Write-Host "┌─ Profile Statistics ────────────────────────────────────────┐" -ForegroundColor Yellow
            Write-Host "│ Uptime:         $elapsedStr" -ForegroundColor White -NoNewline
            Write-Host " " * (55 - $elapsedStr.Length) -NoNewline
            Write-Host "│" -ForegroundColor Yellow
            Write-Host "│ Modules Loaded: $($script:ModuleLoadTimes.Count)" -ForegroundColor White -NoNewline
            Write-Host " " * (50 - $script:ModuleLoadTimes.Count.ToString().Length) -NoNewline
            Write-Host "│" -ForegroundColor Yellow
            Write-Host "└─────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
            Write-Host ""

            # Memory Stats
            $mem = Get-ProfileMemoryUsage
            $workingSetStr = Format-Bytes $mem.WorkingSet
            $privateMemStr = Format-Bytes $mem.PrivateMemorySize
            Write-Host "┌─ Memory Usage ──────────────────────────────────────────────┐" -ForegroundColor Yellow
            Write-Host "│ Working Set:    $workingSetStr" -ForegroundColor White -NoNewline
            Write-Host " " * (48 - $workingSetStr.Length) -NoNewline
            Write-Host "│" -ForegroundColor Yellow
            Write-Host "│ Private Memory: $privateMemStr" -ForegroundColor White -NoNewline
            Write-Host " " * (48 - $privateMemStr.Length) -NoNewline
            Write-Host "│" -ForegroundColor Yellow
            Write-Host "│ GC Collections: Gen0=$($mem.GC_Gen0) Gen1=$($mem.GC_Gen1) Gen2=$($mem.GC_Gen2)" -ForegroundColor White -NoNewline
            $gcStr = "Gen0=$($mem.GC_Gen0) Gen1=$($mem.GC_Gen1) Gen2=$($mem.GC_Gen2)"
            Write-Host " " * (40 - $gcStr.Length) -NoNewline
            Write-Host "│" -ForegroundColor Yellow
            Write-Host "└─────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
            Write-Host ""

            # Top Modules
            Write-Host "┌─ Top 5 Slowest Modules ─────────────────────────────────────┐" -ForegroundColor Yellow
            $topModules = $script:ModuleLoadTimes.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
            foreach ($mod in $topModules) {
                $timeStr = Format-TimeSpan ([TimeSpan]::FromMilliseconds($mod.Value))
                $nameStr = $mod.Name.PadRight(40)
                Write-Host "│ $nameStr $timeStr" -ForegroundColor White -NoNewline
                Write-Host " " * (20 - $timeStr.Length) -NoNewline
                Write-Host "│" -ForegroundColor Yellow
            }
            if ($topModules.Count -eq 0) {
                Write-Host "│ No module data available" -ForegroundColor Gray -NoNewline
                Write-Host " " * 40 -NoNewline
                Write-Host "│" -ForegroundColor Yellow
            }
            Write-Host "└─────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
            Write-Host ""

            # Cache Stats
            $cacheCount = $script:PerformanceCache.Count
            Write-Host "┌─ Cache Statistics ──────────────────────────────────────────┐" -ForegroundColor Yellow
            Write-Host "│ Cached Entries: $cacheCount" -ForegroundColor White -NoNewline
            Write-Host " " * (52 - $cacheCount.ToString().Length) -NoNewline
            Write-Host "│" -ForegroundColor Yellow
            Write-Host "└─────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
            Write-Host ""

            Write-Host "Refreshing in $RefreshInterval seconds... (Ctrl+C to exit)" -ForegroundColor Gray
            Start-Sleep -Seconds $RefreshInterval
        }
    }
    catch {
        Write-Host "`nDashboard stopped." -ForegroundColor Yellow
    }
}

<#
.SYNOPSIS
    Records module load time for performance tracking.
.DESCRIPTION
    Internal function used by the profile to record module load times.
    This data is used by performance monitoring functions.
.PARAMETER ModuleName
    The name of the module being tracked.
.PARAMETER LoadTimeMs
    The load time in milliseconds.
.NOTES
    This is an internal function used during profile initialization.
#>
function Register-ModuleLoadTime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName,

        [Parameter(Mandatory)]
        [double]$LoadTimeMs
    )

    $script:ModuleLoadTimes[$ModuleName] = $LoadTimeMs
}

#endregion

#region Exports

Export-ModuleMember -Function @(
    'Measure-ProfileStartup',
    'Get-ModuleLoadTime',
    'Test-ModulePerformance',
    'Get-PerformanceReport',
    'Get-ProfileMemoryUsage',
    'Set-PerformanceCache',
    'Get-PerformanceCache',
    'Clear-PerformanceCache',
    'Show-PerformanceDashboard',
    'Register-ModuleLoadTime'
) -Alias @(
    'measure-startup',
    'module-time',
    'test-perf',
    'perf-report',
    'mem-usage',
    'set-cache',
    'get-cache',
    'clear-cache',
    'perf-dash',
    'dashboard'
)

#endregion
