# Performance Module

**Version:** 1.0.0  
**Author:** Mohammad Abu Mattar

## Overview

The Performance module provides comprehensive tools for monitoring, benchmarking, and optimizing your PowerShell profile. It helps you identify performance bottlenecks, track resource usage, and implement caching strategies for expensive operations.

## Features

-   📊 **Profile Startup Measurement** - Track how long your profile takes to load
-   ⏱️ **Module Load Time Tracking** - Identify slow-loading modules
-   🔬 **Performance Benchmarking** - Test and compare module performance
-   💾 **Memory Usage Monitoring** - Track PowerShell memory consumption
-   🗄️ **Performance Caching** - Cache expensive operations for faster execution
-   📈 **Real-time Dashboard** - Live performance monitoring
-   📝 **Comprehensive Reports** - Generate detailed performance analysis

## Installation

The Performance module is included in the PowerShell profile. It's automatically loaded if enabled in your configuration.

To enable/disable:

```powershell
cfg-set "modules.enabled.Performance" $true
```

## Commands

### Startup & Load Time Measurement

#### `Measure-ProfileStartup`

Measures total profile startup time with detailed module load times.

**Aliases:** `measure-startup`

**Examples:**

```powershell
# Basic measurement
Measure-ProfileStartup

# Detailed view with all module times
Measure-ProfileStartup -Detailed

# Capture timing data
$timing = Measure-ProfileStartup
Write-Host "Profile loaded in $($timing.TotalTime)"
```

**Output:**

```
=== Profile Startup Performance ===
Total Time: 2.34s
Modules Loaded: 12
Average Module Load Time: 195ms
Slowest Module: Plugins - 523ms
```

#### `Get-ModuleLoadTime`

Retrieves load times for individual modules.

**Aliases:** `module-time`

**Examples:**

```powershell
# All module times
Get-ModuleLoadTime

# Specific module
Get-ModuleLoadTime -ModuleName "Plugins"

# Top 5 slowest modules
Get-ModuleLoadTime | Sort-Object LoadTimeMs -Descending | Select-Object -First 5
```

### Performance Testing & Benchmarking

#### `Test-ModulePerformance`

Benchmarks module loading with multiple iterations for accuracy.

**Aliases:** `test-perf`

**Examples:**

```powershell
# Test all modules (3 iterations each)
Test-ModulePerformance

# Test with 5 iterations for more accuracy
Test-ModulePerformance -Iterations 5

# Test specific module
Test-ModulePerformance -ModulePath "C:\Path\To\Module.psd1"
```

**Output:**

```
=== Module Performance Test ===
Iterations per module: 3

Testing: Plugins
  Avg: 523ms | Min: 498ms | Max: 557ms
  Memory: 12.5 MB | High load time - Lazy load recommended
```

#### `Get-PerformanceReport`

Generates comprehensive performance analysis with recommendations.

**Aliases:** `perf-report`

**Examples:**

```powershell
# Console report
Get-PerformanceReport

# Include system information
Get-PerformanceReport -IncludeSystemInfo

# Export to file
Get-PerformanceReport -ExportPath "~/perf-report.json"

# Analyze report
$report = Get-PerformanceReport
$report.Recommendations
```

**Sample Report:**

```
=== Performance Report ===
Generated: 2026-01-11 14:32:45

Profile Startup:
  Total Time: 2.34s
  Modules Loaded: 12

Module Load Times:
  Plugins: 523ms
  Docker: 387ms
  Git: 245ms
  Network: 198ms
  Utility: 156ms

Memory Usage:
  Current: 145.2 MB
  Private: 128.7 MB

Recommendations:
  • Slow loading modules detected: Plugins, Docker. Consider lazy loading.
```

### Memory Monitoring

#### `Get-ProfileMemoryUsage`

Retrieves detailed memory usage statistics.

**Aliases:** `mem-usage`

**Examples:**

```powershell
# Current memory stats
Get-ProfileMemoryUsage

# Monitor over time
while ($true) {
    Clear-Host
    Get-ProfileMemoryUsage | Format-Table
    Start-Sleep -Seconds 2
}
```

**Output:**

```
WorkingSet     : 152428544 (145.3 MB)
PrivateMemorySize : 135168000 (128.9 MB)
VirtualMemorySize : 2203484160 (2.1 GB)
GC_Gen0        : 45
GC_Gen1        : 12
GC_Gen2        : 3
TotalMemory    : 87654321 (83.6 MB)
```

### Caching System

#### `Set-PerformanceCache`

Stores values in the performance cache for faster retrieval.

**Aliases:** `set-cache`

**Examples:**

```powershell
# Cache with 1-hour expiration (default)
Set-PerformanceCache -Key "ApiResult" -Value $data

# Cache with no expiration
Set-PerformanceCache -Key "StaticConfig" -Value $config -Expiration 0

# Cache with custom expiration (5 minutes)
Set-PerformanceCache -Key "TempData" -Value $temp -Expiration 300

# Persist to disk
Set-PerformanceCache -Key "UserPrefs" -Value $prefs -Persist
```

#### `Get-PerformanceCache`

Retrieves cached values.

**Aliases:** `get-cache`

**Examples:**

```powershell
# Get cached value
$data = Get-PerformanceCache -Key "ApiResult"

# With default fallback
$config = Get-PerformanceCache -Key "Config" -Default @{}

# Cache-aside pattern
$data = Get-PerformanceCache -Key "ExpensiveData"
if ($null -eq $data) {
    $data = Get-ExpensiveData
    Set-PerformanceCache -Key "ExpensiveData" -Value $data
}
```

#### `Clear-PerformanceCache`

Removes cached entries.

**Aliases:** `clear-cache`

**Examples:**

```powershell
# Clear all cache
Clear-PerformanceCache

# Clear specific entry
Clear-PerformanceCache -Key "ApiResult"

# Clear including disk cache
Clear-PerformanceCache -IncludeDisk
```

### Performance Dashboard

#### `Show-PerformanceDashboard`

Displays real-time performance monitoring dashboard.

**Aliases:** `perf-dash`, `dashboard`

**Examples:**

```powershell
# Start dashboard (2-second refresh)
Show-PerformanceDashboard

# Custom refresh interval (5 seconds)
Show-PerformanceDashboard -RefreshInterval 5
```

**Dashboard View:**

```
╔═══════════════════════════════════════════════════════════════╗
║         PowerShell Performance Dashboard                      ║
║         2026-01-11 14:32:45                                   ║
╚═══════════════════════════════════════════════════════════════╝

┌─ Profile Statistics ────────────────────────────────────────┐
│ Uptime:         15m 32s                                       │
│ Modules Loaded: 12                                            │
└─────────────────────────────────────────────────────────────┘

┌─ Memory Usage ──────────────────────────────────────────────┐
│ Working Set:    145.3 MB                                      │
│ Private Memory: 128.9 MB                                      │
│ GC Collections: Gen0=45 Gen1=12 Gen2=3                        │
└─────────────────────────────────────────────────────────────┘

┌─ Top 5 Slowest Modules ─────────────────────────────────────┐
│ Plugins                                  523ms                │
│ Docker                                   387ms                │
│ Git                                      245ms                │
│ Network                                  198ms                │
│ Utility                                  156ms                │
└─────────────────────────────────────────────────────────────┘

┌─ Cache Statistics ──────────────────────────────────────────┐
│ Cached Entries: 5                                             │
└─────────────────────────────────────────────────────────────┘

Refreshing in 2 seconds... (Ctrl+C to exit)
```

## Configuration

Performance settings can be configured via the configuration file:

```powershell
# Enable/disable Performance module
cfg-set "modules.enabled.Performance" $true

# Configure performance settings
cfg-set "performance.lazyLoading" $true
cfg-set "performance.cacheEnabled" $true
cfg-set "performance.cacheExpiration" 3600
```

### Configuration Schema

```json
{
    "performance": {
        "lazyLoading": true,
        "cacheEnabled": true,
        "cacheExpiration": 3600,
        "monitorMemory": true,
        "trackModuleTimes": true,
        "dashboardRefreshInterval": 2
    }
}
```

## Usage Examples

### Example 1: Profile Optimization Workflow

```powershell
# 1. Measure current performance
Measure-ProfileStartup -Detailed

# 2. Identify slow modules
Get-ModuleLoadTime | Where-Object { $_.LoadTimeMs -gt 300 }

# 3. Test specific module
Test-ModulePerformance -ModulePath "Module/Plugins/Plugins.psd1"

# 4. Generate report
Get-PerformanceReport -ExportPath "~/before-optimization.json"

# 5. Implement lazy loading (see Lazy Loading section)

# 6. Compare results
Measure-ProfileStartup
```

### Example 2: Caching Expensive Operations

```powershell
function Get-RemoteData {
    param([string]$Url)

    # Try cache first
    $cached = Get-PerformanceCache -Key "RemoteData_$Url"
    if ($cached) {
        Write-Host "Cache hit!" -ForegroundColor Green
        return $cached
    }

    # Cache miss - fetch data
    Write-Host "Fetching from remote..." -ForegroundColor Yellow
    $data = Invoke-RestMethod -Uri $Url

    # Cache for 10 minutes
    Set-PerformanceCache -Key "RemoteData_$Url" -Value $data -Expiration 600

    return $data
}

# First call - fetches from remote
$data = Get-RemoteData -Url "https://api.example.com/data"

# Subsequent calls - instant from cache
$data = Get-RemoteData -Url "https://api.example.com/data"
```

### Example 3: Memory Monitoring

```powershell
# Monitor memory during operations
$before = Get-ProfileMemoryUsage

# Perform memory-intensive operations
1..1000 | ForEach-Object { Get-Process | Out-Null }

$after = Get-ProfileMemoryUsage
$increase = $after.WorkingSet - $before.WorkingSet

Write-Host "Memory increased by: $(Format-Bytes $increase)"

# Force garbage collection if needed
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
```

## Lazy Loading Implementation

To implement lazy loading for slow modules:

### Option 1: Manual Lazy Loading

```powershell
# In your profile, instead of immediate import:
# Import-Module Module/Plugins/Plugins.psd1

# Use a proxy function:
function Import-PluginsLazy {
    if (-not (Get-Module -Name 'Module-Plugins')) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Import-Module "$PSScriptRoot/Module/Plugins/Plugins.psd1" -Force
        $sw.Stop()
        Register-ModuleLoadTime -ModuleName 'Module-Plugins' -LoadTimeMs $sw.ElapsedMilliseconds
    }
}

# Load on first use
Import-PluginsLazy
```

### Option 2: Configuration-Based Lazy Loading

```powershell
# Mark modules for lazy loading in config
cfg-set "performance.lazyLoad.Plugins" $true
cfg-set "performance.lazyLoad.Docker" $true

# The profile will automatically delay loading these modules
```

## Performance Best Practices

### 1. Profile Startup Optimization

-   ✅ Keep profile load time under 2 seconds
-   ✅ Lazy load non-critical modules
-   ✅ Use caching for expensive operations
-   ✅ Minimize module dependencies

### 2. Module Load Times

-   **Fast (< 100ms)**: Load immediately
-   **Moderate (100-500ms)**: Consider lazy loading
-   **Slow (> 500ms)**: Definitely lazy load

### 3. Memory Management

-   Monitor memory usage regularly
-   Clear cache periodically: `Clear-PerformanceCache`
-   Use garbage collection for cleanup: `[System.GC]::Collect()`
-   Avoid loading unnecessary modules

### 4. Caching Strategy

-   Cache API responses with appropriate expiration
-   Cache file system queries
-   Cache expensive calculations
-   Don't cache sensitive data
-   Don't cache frequently changing data

### 5. Monitoring

-   Run `Measure-ProfileStartup` after profile changes
-   Generate performance reports before/after optimization
-   Use dashboard for long-running sessions
-   Track memory trends over time

## Troubleshooting

### Slow Profile Startup

```powershell
# Identify culprits
Measure-ProfileStartup -Detailed
Get-ModuleLoadTime | Sort-Object LoadTimeMs -Descending

# Test modules individually
Test-ModulePerformance
```

### High Memory Usage

```powershell
# Check current usage
Get-ProfileMemoryUsage

# Clear cache
Clear-PerformanceCache -IncludeDisk

# Force garbage collection
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
```

### Cache Issues

```powershell
# Verify cache
Get-PerformanceCache -Key "YourKey"

# Clear specific cache
Clear-PerformanceCache -Key "YourKey"

# Clear all cache
Clear-PerformanceCache -IncludeDisk
```

## Cache Storage

-   **Memory Cache**: `$script:PerformanceCache` (session-only)
-   **Disk Cache**: `~/.cache/ps1-profile-perf/` (persistent)

Cache files are stored as JSON with the following structure:

```json
{
    "Value": "your cached data",
    "Timestamp": "2026-01-11T14:32:45",
    "Expiration": 3600
}
```

## Integration

### With Config Module

```powershell
# Performance settings from config
$perfConfig = Get-ProfileConfig -Key "performance"

if ($perfConfig.cacheEnabled) {
    Set-PerformanceCache -Key "MyData" -Value $data
}
```

### With Logging Module

```powershell
# Log performance metrics
$timing = Measure-ProfileStartup
Write-Log -Message "Profile loaded in $($timing.TotalTime)" -Level Info
```

## Advanced Features

### Custom Performance Tracking

```powershell
# Track custom operation
$sw = [System.Diagnostics.Stopwatch]::StartNew()
# ... your expensive operation ...
$sw.Stop()

Write-Host "Operation completed in: $(Format-TimeSpan $sw.Elapsed)"
```

### Performance Hooks

```powershell
# Register custom module load time
Register-ModuleLoadTime -ModuleName "MyModule" -LoadTimeMs 150
```

## API Reference

### Functions

| Function                    | Purpose                     | Alias                    |
| --------------------------- | --------------------------- | ------------------------ |
| `Measure-ProfileStartup`    | Measure total startup time  | `measure-startup`        |
| `Get-ModuleLoadTime`        | Get module load times       | `module-time`            |
| `Test-ModulePerformance`    | Benchmark modules           | `test-perf`              |
| `Get-PerformanceReport`     | Generate performance report | `perf-report`            |
| `Get-ProfileMemoryUsage`    | Get memory statistics       | `mem-usage`              |
| `Set-PerformanceCache`      | Cache a value               | `set-cache`              |
| `Get-PerformanceCache`      | Retrieve cached value       | `get-cache`              |
| `Clear-PerformanceCache`    | Clear cache                 | `clear-cache`            |
| `Show-PerformanceDashboard` | Display live dashboard      | `perf-dash`, `dashboard` |

## Version History

### 1.0.0 (2026-01-11)

-   Initial release
-   Profile startup measurement
-   Module load time tracking
-   Performance benchmarking
-   Memory usage monitoring
-   Caching system
-   Real-time dashboard
-   Comprehensive reporting

## Support

For issues, questions, or contributions:

-   **GitHub**: [MKAbuMattar/powershell-profile](https://github.com/MKAbuMattar/powershell-profile)
-   **Issues**: [Report a bug](https://github.com/MKAbuMattar/powershell-profile/issues)

## License

MIT License - See [LICENSE](../../LICENSE) for details.

---

**Made with ❤️ by Mohammad Abu Mattar**
