# 🦀 Rust Plugin for PowerShell Profile

This PowerShell module provides comprehensive **Cargo** and **Rustup** CLI integration with convenient aliases and functions for Rust development. It automatically detects the availability of Cargo and Rustup tools and loads the appropriate functionality.

## 🚀 Features

-   **Automatic Tool Detection**: Only loads functionality for available tools (Cargo and/or Rustup)
-   **Comprehensive Coverage**: All major Cargo and Rustup commands with intuitive aliases
-   **PowerShell Integration**: Proper parameter handling and help documentation
-   **Error Handling**: Graceful handling when tools are not available
-   **Consistent Naming**: Clear, descriptive function names with short aliases

## 📋 Prerequisites

-   **PowerShell 5.1** or later
-   **Cargo** (Rust build tool) - optional, but recommended
-   **Rustup** (Rust toolchain manager) - optional, but recommended

Install Rust and its tools from: [https://rustup.rs/](https://rustup.rs/)

## 🛠️ Installation

This plugin is part of the PowerShell Profile system. It will be automatically loaded if the plugin is enabled in your profile configuration.

## 📚 Usage

### Cargo Commands

The plugin provides functions and aliases for all major Cargo operations:

#### Basic Commands

```powershell
# Using aliases (short form)
cg --version                    # Cargo shortcut
cgn my-app                      # Create new binary project
cgni my-lib                     # Create new library project
cginit                          # Initialize project in current directory

# Using full function names
Invoke-Cargo --version
New-CargoProject my-app
New-CargoLibrary my-lib
Initialize-CargoProject
```

#### Build and Run

```powershell
cgb                             # Build debug
cgbr                            # Build release
cgr                             # Run debug
cgrr                            # Run release
cgw                             # Watch and rebuild

# Function equivalents
Build-CargoProject
Build-CargoRelease
Start-CargoRun
Start-CargoRunRelease
Watch-CargoProject
```

#### Testing and Benchmarking

```powershell
cgt                             # Run tests
cgtr                            # Run tests in release mode
cgbh                            # Run benchmarks
cgta                            # Test all targets
cgtt                            # Single threaded tests

# Function equivalents
Test-CargoProject
Test-CargoRelease
Test-CargoBench
Test-CargoAll
Test-CargoSingleThread
```

#### Code Quality

```powershell
cgc                             # Check compilation
cgcl                            # Clean build artifacts
cgcy                            # Run clippy lints
cgf                             # Format code
cgfa                            # Format all code
cgfx                            # Auto-fix code issues
cgaud                           # Security vulnerabilities check

# Function equivalents
Test-CargoCheck
Clear-CargoProject
Invoke-CargoClippy
Format-CargoCode
Format-CargoAll
Repair-CargoCode
Test-CargoAudit
```

#### Documentation

```powershell
cgd                             # Build and open documentation
cgdr                            # Build release documentation
cgdo                            # Document private items

# Function equivalents
Show-CargoDoc
Show-CargoDocRelease
Show-CargoDocPrivate
```

#### Dependencies

```powershell
cga serde                       # Add dependency
cgad tokio-test                 # Add dev dependency
cgu                             # Update dependencies
cgo                             # Check outdated dependencies
cgv                             # Vendor dependencies
cgtree                          # Display dependency tree

# Function equivalents
Add-CargoDependency serde
Add-CargoDevDependency tokio-test
Update-CargoDependencies
Show-CargoOutdated
Invoke-CargoVendor
Show-CargoTree
```

#### Cross Compilation

```powershell
cgx                             # Build using Zig
cgxw                            # Cross compilation
cgxt                            # Target specific platform

# Function equivalents
Build-CargoZig
Build-CargoCross
Set-CargoTarget
```

#### Analysis and Profiling

```powershell
cgfl                            # Generate flamegraph
cgbl                            # Binary size analysis
cgl                             # Code coverage
cgm                             # Module structure
cgex                            # Expand macros

# Function equivalents
New-CargoFlamegraph
Show-CargoBloat
Show-CargoLLVMCov
Show-CargoModules
Expand-CargoMacros
```

#### Package Management

```powershell
cgi ripgrep                     # Install binary
cgun ripgrep                    # Uninstall binary
cgp                             # Publish to crates.io
cgs "json parser"               # Search crates.io
cgcp                            # Create release package

# Function equivalents
Install-CargoBinary ripgrep
Uninstall-CargoBinary ripgrep
Publish-CargoPackage
Search-CargoPackages "json parser"
New-CargoPackage
```

#### Advanced Build

```powershell
cgba                            # Build all targets
cgbt                            # Build with all features
cgbp bench                      # Build with specific profile

# Function equivalents
Build-CargoAllTargets
Build-CargoAllFeatures
Build-CargoProfile bench
```

#### Project Templates

```powershell
cgnb                            # New binary from template
cgnl                            # New library from template
cgnt                            # New from custom template

# Function equivalents
New-CargoBinaryTemplate
New-CargoLibraryTemplate
New-CargoTemplate
```

### Rustup Commands

The plugin provides functions and aliases for Rustup toolchain management:

#### Updates and Installation

```powershell
ru                              # Update all toolchains
rus                             # Update stable toolchain
run                             # Update nightly toolchain
rti nightly                     # Install specific toolchain

# Function equivalents
Update-Rustup
Update-RustupStable
Update-RustupNightly
Install-RustupToolchain nightly
```

#### Components Management

```powershell
rca rustfmt                     # Add component
rcl                             # List components
rcr rls                         # Remove component

# Function equivalents
Add-RustupComponent rustfmt
Get-RustupComponents
Remove-RustupComponent rls
```

#### Toolchain Management

```powershell
rtl                             # List installed toolchains
rtu nightly                     # Uninstall toolchain
rde stable                      # Set default toolchain

# Function equivalents
Get-RustupToolchains
Uninstall-RustupToolchain nightly
Set-RustupDefault stable
```

#### Target Management

```powershell
rtaa wasm32-unknown-unknown     # Add compilation target
rtal                            # List available targets
rtar wasm32-unknown-unknown     # Remove compilation target

# Function equivalents
Add-RustupTarget wasm32-unknown-unknown
Get-RustupTargets
Remove-RustupTarget wasm32-unknown-unknown
```

#### Environment Running

```powershell
rns cargo build                 # Run command with stable
rnn cargo build                 # Run command with nightly

# Function equivalents
Invoke-RustupStable cargo build
Invoke-RustupNightly cargo build
```

#### Documentation and Help

```powershell
rdo                             # Open Rust documentation

# Function equivalent
Show-RustupDoc
```

#### Override Management

```powershell
rpr nightly                     # Set directory toolchain
rpl                             # List directory overrides
rpn                             # Remove directory override

# Function equivalents
Set-RustupOverride nightly
Get-RustupOverrides
Remove-RustupOverride
```

#### Toolchain Information

```powershell
rws                             # Show active rustc path
rws cargo                       # Show active cargo path
rsh                             # Show toolchain info

# Function equivalents
Get-RustupWhich                 # Default: rustc
Get-RustupWhich cargo
Show-RustupInfo
```

## 🔧 Advanced Usage

### Using Function Parameters

All functions support additional parameters that are passed through to the underlying tools:

```powershell
# Build with specific features
Build-CargoProject --features="serde,tokio"

# Install from git repository
Install-CargoBinary --git https://github.com/user/repo

# Add dependency with specific version
Add-CargoDependency serde --version="1.0"

# Install toolchain with specific date
Install-RustupToolchain nightly-2023-01-01
```

### Combining Commands

Use PowerShell's pipeline and command chaining:

```powershell
# Clean, build, and test
cgcl; cgb; cgt

# Update toolchains and show info
ru; rsh

# Format code and run clippy
cgfa; cgcy
```

### Working with Multiple Projects

Navigate between projects and use the tools:

```powershell
cd C:\my-rust-projects\project1
cgb                             # Build project1

cd ..\project2
cgr                             # Run project2
```

## ⚠️ Error Handling

The plugin gracefully handles missing tools:

-   If **Cargo** is not found: Cargo-related functions and aliases are not loaded
-   If **Rustup** is not found: Rustup-related functions and aliases are not loaded
-   If **both tools** are missing: The plugin loads but provides no functionality

Status messages are displayed during module loading:

-   ✅ Green: Both tools available and loaded
-   ⚡ Yellow: Only one tool available
-   ❌ Red: No tools available

## 📖 Function Documentation

All functions include comprehensive PowerShell help documentation. Use `Get-Help` to learn more:

```powershell
Get-Help Build-CargoProject -Full
Get-Help Add-RustupComponent -Examples
Get-Help Install-CargoBinary -Parameter Package
```

## 🚨 Common Issues and Solutions

### Tool Not Found

**Problem**: "⚠️ Cargo not found" or "⚠️ Rustup not found" message appears.

**Solution**: Install Rust toolchain from [rustup.rs](https://rustup.rs/) and restart your PowerShell session.

### Commands Not Working

**Problem**: Alias commands like `cgb` are not recognized.

**Solution**: Ensure the plugin is loaded and the respective tool is available. Check with:

```powershell
Get-Command cgb
```

### Path Issues

**Problem**: Commands work in one directory but not another.

**Solution**: Ensure you're in a Rust project directory or specify the correct path parameters.

## 📄 License

This plugin is part of the PowerShell Profile project and is licensed under the same terms.

## 🤝 Contributing

Contributions are welcome! Please ensure any new aliases or functions follow the established naming conventions and include proper documentation.

## 🔗 Related Links

-   [Rust Official Website](https://www.rust-lang.org/)
-   [Cargo Book](https://doc.rust-lang.org/cargo/)
-   [Rustup Book](https://rust-lang.github.io/rustup/)
-   [PowerShell Profile Project](https://github.com/MKAbuMattar/powershell-profile)
