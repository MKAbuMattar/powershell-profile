#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Rust Module
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
#       This module provides comprehensive Cargo and Rustup CLI integration with PowerShell aliases
#       and functions for Rust development, including building, testing, dependency management,
#       and toolchain operations.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

# Check if Cargo is available
$script:CargoAvailable = $null -ne (Get-Command 'cargo' -ErrorAction SilentlyContinue)

# Check if Rustup is available
$script:RustupAvailable = $null -ne (Get-Command 'rustup' -ErrorAction SilentlyContinue)

# ================================================================================================
# CARGO FUNCTIONS AND ALIASES
# ================================================================================================

if ($script:CargoAvailable) {
    Write-Host "🦀 Cargo detected - Loading Rust development aliases..." -ForegroundColor Yellow
    
    # ============================================================================================
    # Basic Commands
    # ============================================================================================
    
    function Invoke-Cargo {
        <#
        .SYNOPSIS
        Shortcut for Cargo command.
        
        .DESCRIPTION
        Provides a simple shortcut to the cargo command.
        
        .PARAMETER Arguments
        Arguments to pass to cargo.
        
        .EXAMPLE
        Invoke-Cargo --version
        #>
        [CmdletBinding()]
        [Alias('cg')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo @Arguments
    }
    
    function New-CargoProject {
        <#
        .SYNOPSIS
        Create new binary Rust project.
        
        .DESCRIPTION
        Creates a new Rust binary project using cargo new.
        
        .PARAMETER Name
        Name of the new project.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo new.
        
        .EXAMPLE
        New-CargoProject my-app
        #>
        [CmdletBinding()]
        [Alias('cgn')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Name,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo new $Name @Arguments
    }
    
    function New-CargoLibrary {
        <#
        .SYNOPSIS
        Create new library Rust project.
        
        .DESCRIPTION
        Creates a new Rust library project using cargo new --lib.
        
        .PARAMETER Name
        Name of the new library.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo new.
        
        .EXAMPLE
        New-CargoLibrary my-lib
        #>
        [CmdletBinding()]
        [Alias('cgni')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Name,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo new --lib $Name @Arguments
    }
    
    function Initialize-CargoProject {
        <#
        .SYNOPSIS
        Initialize Cargo project in current directory.
        
        .DESCRIPTION
        Initializes a Rust project in the current directory using cargo init.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo init.
        
        .EXAMPLE
        Initialize-CargoProject
        #>
        [CmdletBinding()]
        [Alias('cginit')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo init @Arguments
    }
    
    # ============================================================================================
    # Build and Run
    # ============================================================================================
    
    function Build-CargoProject {
        <#
        .SYNOPSIS
        Build Rust project in debug mode.
        
        .DESCRIPTION
        Builds the current Rust project in debug mode using cargo build.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo build.
        
        .EXAMPLE
        Build-CargoProject
        #>
        [CmdletBinding()]
        [Alias('cgb')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo build @Arguments
    }
    
    function Build-CargoRelease {
        <#
        .SYNOPSIS
        Build Rust project in release mode.
        
        .DESCRIPTION
        Builds the current Rust project in release mode using cargo build --release.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo build.
        
        .EXAMPLE
        Build-CargoRelease
        #>
        [CmdletBinding()]
        [Alias('cgbr')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo build --release @Arguments
    }
    
    function Start-CargoRun {
        <#
        .SYNOPSIS
        Run Rust project in debug mode.
        
        .DESCRIPTION
        Runs the current Rust project in debug mode using cargo run.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo run.
        
        .EXAMPLE
        Start-CargoRun
        #>
        [CmdletBinding()]
        [Alias('cgr')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo run @Arguments
    }
    
    function Start-CargoRunRelease {
        <#
        .SYNOPSIS
        Run Rust project in release mode.
        
        .DESCRIPTION
        Runs the current Rust project in release mode using cargo run --release.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo run.
        
        .EXAMPLE
        Start-CargoRunRelease
        #>
        [CmdletBinding()]
        [Alias('cgrr')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo run --release @Arguments
    }
    
    function Watch-CargoProject {
        <#
        .SYNOPSIS
        Watch and rebuild Rust project.
        
        .DESCRIPTION
        Watches for file changes and rebuilds the project using cargo watch.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo watch.
        
        .EXAMPLE
        Watch-CargoProject
        #>
        [CmdletBinding()]
        [Alias('cgw')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo watch @Arguments
    }
    
    # ============================================================================================
    # Testing and Benchmarking
    # ============================================================================================
    
    function Test-CargoProject {
        <#
        .SYNOPSIS
        Run Rust project tests.
        
        .DESCRIPTION
        Runs tests for the current Rust project using cargo test.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo test.
        
        .EXAMPLE
        Test-CargoProject
        #>
        [CmdletBinding()]
        [Alias('cgt')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo test @Arguments
    }
    
    function Test-CargoRelease {
        <#
        .SYNOPSIS
        Run tests in release mode.
        
        .DESCRIPTION
        Runs tests in release mode using cargo test --release.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo test.
        
        .EXAMPLE
        Test-CargoRelease
        #>
        [CmdletBinding()]
        [Alias('cgtr')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo test --release @Arguments
    }
    
    function Test-CargoBench {
        <#
        .SYNOPSIS
        Run Rust benchmarks.
        
        .DESCRIPTION
        Runs benchmarks for the current Rust project using cargo bench.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo bench.
        
        .EXAMPLE
        Test-CargoBench
        #>
        [CmdletBinding()]
        [Alias('cgbh')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo bench @Arguments
    }
    
    function Test-CargoAll {
        <#
        .SYNOPSIS
        Test all targets.
        
        .DESCRIPTION
        Runs tests for all targets using cargo test --all.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo test.
        
        .EXAMPLE
        Test-CargoAll
        #>
        [CmdletBinding()]
        [Alias('cgta')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo test --all @Arguments
    }
    
    function Test-CargoSingleThread {
        <#
        .SYNOPSIS
        Run tests in single thread mode.
        
        .DESCRIPTION
        Runs tests using a single thread with cargo test -- --test-threads=1.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo test.
        
        .EXAMPLE
        Test-CargoSingleThread
        #>
        [CmdletBinding()]
        [Alias('cgtt')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo test -- --test-threads=1 @Arguments
    }
    
    # ============================================================================================
    # Code Quality
    # ============================================================================================
    
    function Test-CargoCheck {
        <#
        .SYNOPSIS
        Check Rust code compilation.
        
        .DESCRIPTION
        Checks if the code compiles without producing a binary using cargo check.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo check.
        
        .EXAMPLE
        Test-CargoCheck
        #>
        [CmdletBinding()]
        [Alias('cgc')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo check @Arguments
    }
    
    function Clear-CargoProject {
        <#
        .SYNOPSIS
        Clean build artifacts.
        
        .DESCRIPTION
        Removes build artifacts using cargo clean.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo clean.
        
        .EXAMPLE
        Clear-CargoProject
        #>
        [CmdletBinding()]
        [Alias('cgcl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo clean @Arguments
    }
    
    function Invoke-CargoClippy {
        <#
        .SYNOPSIS
        Run clippy lints.
        
        .DESCRIPTION
        Runs Clippy lints on the project using cargo clippy.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo clippy.
        
        .EXAMPLE
        Invoke-CargoClippy
        #>
        [CmdletBinding()]
        [Alias('cgcy')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo clippy @Arguments
    }
    
    function Format-CargoCode {
        <#
        .SYNOPSIS
        Format Rust code.
        
        .DESCRIPTION
        Formats Rust code using cargo fmt.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo fmt.
        
        .EXAMPLE
        Format-CargoCode
        #>
        [CmdletBinding()]
        [Alias('cgf')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo fmt @Arguments
    }
    
    function Format-CargoAll {
        <#
        .SYNOPSIS
        Format all Rust code.
        
        .DESCRIPTION
        Formats all Rust code in the project using cargo fmt --all.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo fmt.
        
        .EXAMPLE
        Format-CargoAll
        #>
        [CmdletBinding()]
        [Alias('cgfa')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo fmt --all @Arguments
    }
    
    function Repair-CargoCode {
        <#
        .SYNOPSIS
        Auto-fix code issues.
        
        .DESCRIPTION
        Automatically fixes code issues using cargo fix.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo fix.
        
        .EXAMPLE
        Repair-CargoCode
        #>
        [CmdletBinding()]
        [Alias('cgfx')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo fix @Arguments
    }
    
    function Test-CargoAudit {
        <#
        .SYNOPSIS
        Check for security vulnerabilities.
        
        .DESCRIPTION
        Checks for security vulnerabilities in dependencies using cargo audit.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo audit.
        
        .EXAMPLE
        Test-CargoAudit
        #>
        [CmdletBinding()]
        [Alias('cgaud')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo audit @Arguments
    }
    
    # ============================================================================================
    # Documentation
    # ============================================================================================
    
    function Show-CargoDoc {
        <#
        .SYNOPSIS
        Build and open documentation.
        
        .DESCRIPTION
        Builds and opens the documentation using cargo doc --open.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo doc.
        
        .EXAMPLE
        Show-CargoDoc
        #>
        [CmdletBinding()]
        [Alias('cgd')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo doc --open @Arguments
    }
    
    function Show-CargoDocRelease {
        <#
        .SYNOPSIS
        Build release documentation.
        
        .DESCRIPTION
        Builds documentation in release mode using cargo doc --release.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo doc.
        
        .EXAMPLE
        Show-CargoDocRelease
        #>
        [CmdletBinding()]
        [Alias('cgdr')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo doc --release @Arguments
    }
    
    function Show-CargoDocPrivate {
        <#
        .SYNOPSIS
        Document private items.
        
        .DESCRIPTION
        Builds documentation including private items using cargo doc --document-private-items.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo doc.
        
        .EXAMPLE
        Show-CargoDocPrivate
        #>
        [CmdletBinding()]
        [Alias('cgdo')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo doc --document-private-items @Arguments
    }
    
    # ============================================================================================
    # Dependencies
    # ============================================================================================
    
    function Add-CargoDependency {
        <#
        .SYNOPSIS
        Add dependency to project.
        
        .DESCRIPTION
        Adds a dependency to the project using cargo add.
        
        .PARAMETER Package
        Package name to add.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo add.
        
        .EXAMPLE
        Add-CargoDependency serde
        #>
        [CmdletBinding()]
        [Alias('cga')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Package,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo add $Package @Arguments
    }
    
    function Add-CargoDevDependency {
        <#
        .SYNOPSIS
        Add dev dependency to project.
        
        .DESCRIPTION
        Adds a development dependency to the project using cargo add --dev.
        
        .PARAMETER Package
        Package name to add as dev dependency.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo add.
        
        .EXAMPLE
        Add-CargoDevDependency tokio-test
        #>
        [CmdletBinding()]
        [Alias('cgad')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Package,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo add --dev $Package @Arguments
    }
    
    function Update-CargoDependencies {
        <#
        .SYNOPSIS
        Update dependencies.
        
        .DESCRIPTION
        Updates project dependencies using cargo update.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo update.
        
        .EXAMPLE
        Update-CargoDependencies
        #>
        [CmdletBinding()]
        [Alias('cgu')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo update @Arguments
    }
    
    function Show-CargoOutdated {
        <#
        .SYNOPSIS
        Check outdated dependencies.
        
        .DESCRIPTION
        Checks for outdated dependencies using cargo outdated.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo outdated.
        
        .EXAMPLE
        Show-CargoOutdated
        #>
        [CmdletBinding()]
        [Alias('cgo')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo outdated @Arguments
    }
    
    function Invoke-CargoVendor {
        <#
        .SYNOPSIS
        Vendor dependencies.
        
        .DESCRIPTION
        Vendors dependencies locally using cargo vendor.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo vendor.
        
        .EXAMPLE
        Invoke-CargoVendor
        #>
        [CmdletBinding()]
        [Alias('cgv')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo vendor @Arguments
    }
    
    function Show-CargoTree {
        <#
        .SYNOPSIS
        Display dependency tree.
        
        .DESCRIPTION
        Displays the dependency tree using cargo tree.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo tree.
        
        .EXAMPLE
        Show-CargoTree
        #>
        [CmdletBinding()]
        [Alias('cgtree')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo tree @Arguments
    }
    
    # ============================================================================================
    # Cross Compilation
    # ============================================================================================
    
    function Build-CargoZig {
        <#
        .SYNOPSIS
        Build using Zig.
        
        .DESCRIPTION
        Builds the project using Zig with cargo zigbuild.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo zigbuild.
        
        .EXAMPLE
        Build-CargoZig
        #>
        [CmdletBinding()]
        [Alias('cgx')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo zigbuild @Arguments
    }
    
    function Build-CargoCross {
        <#
        .SYNOPSIS
        Cross compilation build.
        
        .DESCRIPTION
        Builds the project for cross compilation using cargo cross.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo cross.
        
        .EXAMPLE
        Build-CargoCross
        #>
        [CmdletBinding()]
        [Alias('cgxw')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo cross @Arguments
    }
    
    function Set-CargoTarget {
        <#
        .SYNOPSIS
        Target specific platform.
        
        .DESCRIPTION
        Sets or manages compilation targets using cargo target.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo target.
        
        .EXAMPLE
        Set-CargoTarget
        #>
        [CmdletBinding()]
        [Alias('cgxt')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo target @Arguments
    }
    
    # ============================================================================================
    # Analysis and Profiling
    # ============================================================================================
    
    function New-CargoFlamegraph {
        <#
        .SYNOPSIS
        Generate flamegraph.
        
        .DESCRIPTION
        Generates a flamegraph for performance analysis using cargo flamegraph.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo flamegraph.
        
        .EXAMPLE
        New-CargoFlamegraph
        #>
        [CmdletBinding()]
        [Alias('cgfl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo flamegraph @Arguments
    }
    
    function Show-CargoBloat {
        <#
        .SYNOPSIS
        Binary size analysis.
        
        .DESCRIPTION
        Analyzes binary size and bloat using cargo bloat.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo bloat.
        
        .EXAMPLE
        Show-CargoBloat
        #>
        [CmdletBinding()]
        [Alias('cgbl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo bloat @Arguments
    }
    
    function Show-CargoLLVMCov {
        <#
        .SYNOPSIS
        Code coverage analysis.
        
        .DESCRIPTION
        Generates code coverage reports using cargo llvm-cov.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo llvm-cov.
        
        .EXAMPLE
        Show-CargoLLVMCov
        #>
        [CmdletBinding()]
        [Alias('cgl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo llvm-cov @Arguments
    }
    
    function Show-CargoModules {
        <#
        .SYNOPSIS
        Module structure analysis.
        
        .DESCRIPTION
        Analyzes module structure using cargo modules.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo modules.
        
        .EXAMPLE
        Show-CargoModules
        #>
        [CmdletBinding()]
        [Alias('cgm')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo modules @Arguments
    }
    
    function Expand-CargoMacros {
        <#
        .SYNOPSIS
        Expand macros.
        
        .DESCRIPTION
        Expands Rust macros using cargo expand.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo expand.
        
        .EXAMPLE
        Expand-CargoMacros
        #>
        [CmdletBinding()]
        [Alias('cgex')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo expand @Arguments
    }
    
    # ============================================================================================
    # Package Management
    # ============================================================================================
    
    function Install-CargoBinary {
        <#
        .SYNOPSIS
        Install binary package.
        
        .DESCRIPTION
        Installs a binary package using cargo install.
        
        .PARAMETER Package
        Package name to install.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo install.
        
        .EXAMPLE
        Install-CargoBinary ripgrep
        #>
        [CmdletBinding()]
        [Alias('cgi')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Package,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo install $Package @Arguments
    }
    
    function Uninstall-CargoBinary {
        <#
        .SYNOPSIS
        Uninstall binary package.
        
        .DESCRIPTION
        Uninstalls a binary package using cargo uninstall.
        
        .PARAMETER Package
        Package name to uninstall.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo uninstall.
        
        .EXAMPLE
        Uninstall-CargoBinary ripgrep
        #>
        [CmdletBinding()]
        [Alias('cgun')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Package,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo uninstall $Package @Arguments
    }
    
    function Publish-CargoPackage {
        <#
        .SYNOPSIS
        Publish to crates.io.
        
        .DESCRIPTION
        Publishes the package to crates.io using cargo publish.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo publish.
        
        .EXAMPLE
        Publish-CargoPackage
        #>
        [CmdletBinding()]
        [Alias('cgp')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo publish @Arguments
    }
    
    function Search-CargoPackages {
        <#
        .SYNOPSIS
        Search crates.io.
        
        .DESCRIPTION
        Searches for packages on crates.io using cargo search.
        
        .PARAMETER Query
        Search query.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo search.
        
        .EXAMPLE
        Search-CargoPackages "json parser"
        #>
        [CmdletBinding()]
        [Alias('cgs')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Query,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo search $Query @Arguments
    }
    
    function New-CargoPackage {
        <#
        .SYNOPSIS
        Create release package.
        
        .DESCRIPTION
        Creates a release package using cargo package.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo package.
        
        .EXAMPLE
        New-CargoPackage
        #>
        [CmdletBinding()]
        [Alias('cgcp')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo package @Arguments
    }
    
    # ============================================================================================
    # Advanced Build
    # ============================================================================================
    
    function Build-CargoAllTargets {
        <#
        .SYNOPSIS
        Build all targets.
        
        .DESCRIPTION
        Builds all targets using cargo build --all-targets.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo build.
        
        .EXAMPLE
        Build-CargoAllTargets
        #>
        [CmdletBinding()]
        [Alias('cgba')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo build --all-targets @Arguments
    }
    
    function Build-CargoAllFeatures {
        <#
        .SYNOPSIS
        Build with all features.
        
        .DESCRIPTION
        Builds with all features using cargo build --all-features.
        
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo build.
        
        .EXAMPLE
        Build-CargoAllFeatures
        #>
        [CmdletBinding()]
        [Alias('cgbt')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo build --all-features @Arguments
    }
    
    function Build-CargoProfile {
        <#
        .SYNOPSIS
        Build with specific profile.
        
        .DESCRIPTION
        Builds with a specific profile using cargo build --release --profile.
        
        .PARAMETER ProfileName
        Profile name to use.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo build.
        
        .EXAMPLE
        Build-CargoProfile bench
        #>
        [CmdletBinding()]
        [Alias('cgbp')]
        param(
            [Parameter(Position = 0)]
            [string]$ProfileName,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        if ($ProfileName) {
            & cargo build --release --profile $ProfileName @Arguments
        }
        else {
            & cargo build --release --profile @Arguments
        }
    }
    
    # ============================================================================================
    # Project Templates
    # ============================================================================================
    
    function New-CargoBinaryTemplate {
        <#
        .SYNOPSIS
        New binary from template.
        
        .DESCRIPTION
        Creates a new binary project from a template using cargo generate --bin.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo generate.
        
        .EXAMPLE
        New-CargoBinaryTemplate
        #>
        [CmdletBinding()]
        [Alias('cgnb')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo generate --bin @Arguments
    }
    
    function New-CargoLibraryTemplate {
        <#
        .SYNOPSIS
        New library from template.
        
        .DESCRIPTION
        Creates a new library project from a template using cargo generate --lib.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo generate.
        
        .EXAMPLE
        New-CargoLibraryTemplate
        #>
        [CmdletBinding()]
        [Alias('cgnl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo generate --lib @Arguments
    }
    
    function New-CargoTemplate {
        <#
        .SYNOPSIS
        New from custom template.
        
        .DESCRIPTION
        Creates a new project from a custom template using cargo generate.
        
        .PARAMETER Arguments
        Additional arguments to pass to cargo generate.
        
        .EXAMPLE
        New-CargoTemplate
        #>
        [CmdletBinding()]
        [Alias('cgnt')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & cargo generate @Arguments
    }
    
}
else {}

# ================================================================================================
# RUSTUP FUNCTIONS AND ALIASES
# ================================================================================================

if ($script:RustupAvailable) {
    Write-Host "🦀 Rustup detected - Loading Rust toolchain management aliases..." -ForegroundColor Yellow
    
    # ============================================================================================
    # Updates and Installation
    # ============================================================================================
    
    function Update-Rustup {
        <#
        .SYNOPSIS
        Update all Rust toolchains.
        
        .DESCRIPTION
        Updates all installed Rust toolchains using rustup update.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup update.
        
        .EXAMPLE
        Update-Rustup
        #>
        [CmdletBinding()]
        [Alias('ru')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup update @Arguments
    }
    
    function Update-RustupStable {
        <#
        .SYNOPSIS
        Update stable toolchain.
        
        .DESCRIPTION
        Updates the stable Rust toolchain using rustup update stable.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup update.
        
        .EXAMPLE
        Update-RustupStable
        #>
        [CmdletBinding()]
        [Alias('rus')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup update stable @Arguments
    }
    
    function Update-RustupNightly {
        <#
        .SYNOPSIS
        Update nightly toolchain.
        
        .DESCRIPTION
        Updates the nightly Rust toolchain using rustup update nightly.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup update.
        
        .EXAMPLE
        Update-RustupNightly
        #>
        [CmdletBinding()]
        [Alias('run')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup update nightly @Arguments
    }
    
    function Install-RustupToolchain {
        <#
        .SYNOPSIS
        Install specific toolchain.
        
        .DESCRIPTION
        Installs a specific Rust toolchain using rustup toolchain install.
        
        .PARAMETER Toolchain
        Toolchain to install (e.g., stable, nightly, 1.70.0).
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup toolchain install.
        
        .EXAMPLE
        Install-RustupToolchain nightly
        #>
        [CmdletBinding()]
        [Alias('rti')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Toolchain,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup toolchain install $Toolchain @Arguments
    }
    
    # ============================================================================================
    # Components Management
    # ============================================================================================
    
    function Add-RustupComponent {
        <#
        .SYNOPSIS
        Add component to toolchain.
        
        .DESCRIPTION
        Adds a component to a Rust toolchain using rustup component add.
        
        .PARAMETER Component
        Component to add (e.g., rustfmt, clippy, rls).
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup component add.
        
        .EXAMPLE
        Add-RustupComponent rustfmt
        #>
        [CmdletBinding()]
        [Alias('rca')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Component,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup component add $Component @Arguments
    }
    
    function Get-RustupComponents {
        <#
        .SYNOPSIS
        List available components.
        
        .DESCRIPTION
        Lists available and installed components using rustup component list.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup component list.
        
        .EXAMPLE
        Get-RustupComponents
        #>
        [CmdletBinding()]
        [Alias('rcl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup component list @Arguments
    }
    
    function Remove-RustupComponent {
        <#
        .SYNOPSIS
        Remove component from toolchain.
        
        .DESCRIPTION
        Removes a component from a Rust toolchain using rustup component remove.
        
        .PARAMETER Component
        Component to remove.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup component remove.
        
        .EXAMPLE
        Remove-RustupComponent rls
        #>
        [CmdletBinding()]
        [Alias('rcr')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Component,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup component remove $Component @Arguments
    }
    
    # ============================================================================================
    # Toolchain Management
    # ============================================================================================
    
    function Get-RustupToolchains {
        <#
        .SYNOPSIS
        List installed toolchains.
        
        .DESCRIPTION
        Lists all installed Rust toolchains using rustup toolchain list.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup toolchain list.
        
        .EXAMPLE
        Get-RustupToolchains
        #>
        [CmdletBinding()]
        [Alias('rtl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup toolchain list @Arguments
    }
    
    function Uninstall-RustupToolchain {
        <#
        .SYNOPSIS
        Uninstall toolchain.
        
        .DESCRIPTION
        Uninstalls a Rust toolchain using rustup toolchain uninstall.
        
        .PARAMETER Toolchain
        Toolchain to uninstall.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup toolchain uninstall.
        
        .EXAMPLE
        Uninstall-RustupToolchain nightly
        #>
        [CmdletBinding()]
        [Alias('rtu')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Toolchain,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup toolchain uninstall $Toolchain @Arguments
    }
    
    function Set-RustupDefault {
        <#
        .SYNOPSIS
        Set default toolchain.
        
        .DESCRIPTION
        Sets the default Rust toolchain using rustup default.
        
        .PARAMETER Toolchain
        Toolchain to set as default.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup default.
        
        .EXAMPLE
        Set-RustupDefault stable
        #>
        [CmdletBinding()]
        [Alias('rde')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Toolchain,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup default $Toolchain @Arguments
    }
    
    # ============================================================================================
    # Target Management
    # ============================================================================================
    
    function Add-RustupTarget {
        <#
        .SYNOPSIS
        Add compilation target.
        
        .DESCRIPTION
        Adds a compilation target using rustup target add.
        
        .PARAMETER Target
        Target to add (e.g., wasm32-unknown-unknown).
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup target add.
        
        .EXAMPLE
        Add-RustupTarget wasm32-unknown-unknown
        #>
        [CmdletBinding()]
        [Alias('rtaa')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Target,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup target add $Target @Arguments
    }
    
    function Get-RustupTargets {
        <#
        .SYNOPSIS
        List available targets.
        
        .DESCRIPTION
        Lists available and installed compilation targets using rustup target list.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup target list.
        
        .EXAMPLE
        Get-RustupTargets
        #>
        [CmdletBinding()]
        [Alias('rtal')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup target list @Arguments
    }
    
    function Remove-RustupTarget {
        <#
        .SYNOPSIS
        Remove compilation target.
        
        .DESCRIPTION
        Removes a compilation target using rustup target remove.
        
        .PARAMETER Target
        Target to remove.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup target remove.
        
        .EXAMPLE
        Remove-RustupTarget wasm32-unknown-unknown
        #>
        [CmdletBinding()]
        [Alias('rtar')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Target,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup target remove $Target @Arguments
    }
    
    # ============================================================================================
    # Environment Running
    # ============================================================================================
    
    function Invoke-RustupStable {
        <#
        .SYNOPSIS
        Run command with stable toolchain.
        
        .DESCRIPTION
        Runs a command using the stable toolchain with rustup run stable.
        
        .PARAMETER Command
        Command to run.
        
        .PARAMETER Arguments
        Additional arguments to pass to the command.
        
        .EXAMPLE
        Invoke-RustupStable cargo build
        #>
        [CmdletBinding()]
        [Alias('rns')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Command,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup run stable $Command @Arguments
    }
    
    function Invoke-RustupNightly {
        <#
        .SYNOPSIS
        Run command with nightly toolchain.
        
        .DESCRIPTION
        Runs a command using the nightly toolchain with rustup run nightly.
        
        .PARAMETER Command
        Command to run.
        
        .PARAMETER Arguments
        Additional arguments to pass to the command.
        
        .EXAMPLE
        Invoke-RustupNightly cargo build
        #>
        [CmdletBinding()]
        [Alias('rnn')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Command,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup run nightly $Command @Arguments
    }
    
    # ============================================================================================
    # Documentation and Help
    # ============================================================================================
    
    function Show-RustupDoc {
        <#
        .SYNOPSIS
        Open Rust documentation.
        
        .DESCRIPTION
        Opens the Rust documentation using rustup doc --open.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup doc.
        
        .EXAMPLE
        Show-RustupDoc
        #>
        [CmdletBinding()]
        [Alias('rdo')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup doc --open @Arguments
    }
    
    # ============================================================================================
    # Override Management
    # ============================================================================================
    
    function Set-RustupOverride {
        <#
        .SYNOPSIS
        Set directory toolchain override.
        
        .DESCRIPTION
        Sets a toolchain override for the current directory using rustup override set.
        
        .PARAMETER Toolchain
        Toolchain to set as override.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup override set.
        
        .EXAMPLE
        Set-RustupOverride nightly
        #>
        [CmdletBinding()]
        [Alias('rpr')]
        param(
            [Parameter(Mandatory, Position = 0)]
            [string]$Toolchain,
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup override set $Toolchain @Arguments
    }
    
    function Get-RustupOverrides {
        <#
        .SYNOPSIS
        List directory overrides.
        
        .DESCRIPTION
        Lists all directory toolchain overrides using rustup override list.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup override list.
        
        .EXAMPLE
        Get-RustupOverrides
        #>
        [CmdletBinding()]
        [Alias('rpl')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup override list @Arguments
    }
    
    function Remove-RustupOverride {
        <#
        .SYNOPSIS
        Remove directory override.
        
        .DESCRIPTION
        Removes the toolchain override for the current directory using rustup override unset.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup override unset.
        
        .EXAMPLE
        Remove-RustupOverride
        #>
        [CmdletBinding()]
        [Alias('rpn')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup override unset @Arguments
    }
    
    # ============================================================================================
    # Toolchain Information
    # ============================================================================================
    
    function Get-RustupWhich {
        <#
        .SYNOPSIS
        Show active rustc path.
        
        .DESCRIPTION
        Shows the path to the active rustc binary using rustup which rustc.
        
        .PARAMETER Tool
        Tool to show path for (default: rustc).
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup which.
        
        .EXAMPLE
        Get-RustupWhich
        Get-RustupWhich cargo
        #>
        [CmdletBinding()]
        [Alias('rws')]
        param(
            [Parameter(Position = 0)]
            [string]$Tool = 'rustc',
            
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup which $Tool @Arguments
    }
    
    function Show-RustupInfo {
        <#
        .SYNOPSIS
        Show toolchain information.
        
        .DESCRIPTION
        Shows information about installed toolchains and active toolchain using rustup show.
        
        .PARAMETER Arguments
        Additional arguments to pass to rustup show.
        
        .EXAMPLE
        Show-RustupInfo
        #>
        [CmdletBinding()]
        [Alias('rsh')]
        param(
            [Parameter(ValueFromRemainingArguments)]
            [string[]]$Arguments
        )
        
        & rustup show @Arguments
    }
    
}
else {}
