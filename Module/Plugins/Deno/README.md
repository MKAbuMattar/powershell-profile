# Deno Plugin for PowerShell

This plugin provides comprehensive Deno CLI shortcuts and utility functions for TypeScript/JavaScript runtime operations in PowerShell environments. It supports bundling, compilation, caching, formatting, linting, running, testing, and upgrade functionality with comprehensive development workflow automation.

## Features

-   **Complete Deno Integration**: Full coverage of Deno CLI commands with PowerShell functions
-   **Intuitive Aliases**: Short, memorable aliases for all common Deno operations
-   **Tab Completion**: PowerShell tab completion for Deno commands and subcommands
-   **Runtime Operations**: Execute, compile, and bundle TypeScript/JavaScript projects
-   **Development Tools**: Built-in formatting, linting, and testing capabilities
-   **Project Management**: Initialize, install, and publish Deno projects
-   **Error Handling**: Robust error checking and user-friendly messages

## Prerequisites

-   PowerShell 5.0 or later
-   Deno installed and accessible in PATH
-   TypeScript/JavaScript projects for testing

## Installation

This plugin is automatically loaded as part of MKAbuMattar's PowerShell Profile. No additional installation required.

## Available Commands

### Core Functions

| Function             | Alias | Description                | Example              |
| -------------------- | ----- | -------------------------- | -------------------- |
| `Invoke-Deno`        | `d`   | Base Deno command wrapper  | `d --version`        |
| `Get-DenoVersion`    | -     | Get installed Deno version | `Get-DenoVersion`    |
| `Test-DenoInstalled` | -     | Check if Deno is available | `Test-DenoInstalled` |

### Bundle and Compile

| Function             | Alias | Description                   | Example                         |
| -------------------- | ----- | ----------------------------- | ------------------------------- |
| `Invoke-DenoBundle`  | `db`  | Bundle project to single file | `db src/main.ts dist/bundle.js` |
| `Invoke-DenoCompile` | `dc`  | Compile to executable         | `dc --output=myapp src/main.ts` |

### Development Workflow

| Function            | Alias  | Description        | Example       |
| ------------------- | ------ | ------------------ | ------------- |
| `Invoke-DenoCache`  | `dca`  | Cache dependencies | `dca deps.ts` |
| `Invoke-DenoFormat` | `dfmt` | Format code        | `dfmt src/`   |
| `Invoke-DenoHelp`   | `dh`   | Show help          | `dh run`      |
| `Invoke-DenoLint`   | `dli`  | Lint code          | `dli src/`    |

### Run Operations

| Function                 | Alias | Description              | Example                     |
| ------------------------ | ----- | ------------------------ | --------------------------- |
| `Invoke-DenoRun`         | `drn` | Run script               | `drn --allow-net server.ts` |
| `Invoke-DenoRunAll`      | `drA` | Run with all permissions | `drA app.ts`                |
| `Invoke-DenoRunWatch`    | `drw` | Run in watch mode        | `drw server.ts`             |
| `Invoke-DenoRunUnstable` | `dru` | Run with unstable APIs   | `dru experimental.ts`       |

### Test and Quality

| Function           | Alias | Description      | Example          |
| ------------------ | ----- | ---------------- | ---------------- |
| `Invoke-DenoTest`  | `dts` | Run tests        | `dts --coverage` |
| `Invoke-DenoCheck` | `dch` | Type-check files | `dch src/*.ts`   |

### Utility Commands

| Function               | Alias  | Description               | Example                                                    |
| ---------------------- | ------ | ------------------------- | ---------------------------------------------------------- |
| `Invoke-DenoUpgrade`   | `dup`  | Upgrade Deno              | `dup --canary`                                             |
| `Invoke-DenoInstall`   | `di`   | Install script as command | `di -A -n serve https://deno.land/std/http/file_server.ts` |
| `Invoke-DenoUninstall` | `dun`  | Uninstall command         | `dun serve`                                                |
| `Invoke-DenoInfo`      | `dinf` | Show module info          | `dinf app.ts`                                              |

### Interactive and Documentation

| Function           | Alias  | Description            | Example                                |
| ------------------ | ------ | ---------------------- | -------------------------------------- |
| `Invoke-DenoEval`  | `de`   | Evaluate code          | `de 'console.log("Hello World")'`      |
| `Invoke-DenoRepl`  | `dr`   | Start REPL             | `dr --unstable`                        |
| `Invoke-DenoDoc`   | `ddoc` | Show documentation     | `ddoc https://deno.land/std/fs/mod.ts` |
| `Invoke-DenoTypes` | `dt`   | Print type definitions | `dt > deno.d.ts`                       |

### Project Management

| Function             | Alias   | Description        | Example                  |
| -------------------- | ------- | ------------------ | ------------------------ |
| `Invoke-DenoInit`    | `dinit` | Initialize project | `dinit my-project`       |
| `Invoke-DenoTask`    | `dtask` | Run project tasks  | `dtask build`            |
| `Invoke-DenoServe`   | `dsv`   | Run HTTP server    | `dsv --port=8080 app.ts` |
| `Invoke-DenoPublish` | `dpub`  | Publish to JSR     | `dpub --dry-run`         |

## Usage Examples

### Basic Development Workflow

```powershell
# Initialize new project
dinit my-deno-app
cd my-deno-app

# Format and lint code
dfmt
dli

# Run in development mode
drw main.ts

# Run with all permissions
drA server.ts
```

### Bundle and Compile

```powershell
# Bundle for distribution
db src/main.ts dist/bundle.js

# Compile to executable
dc --output=myapp --allow-all src/main.ts

# Run compiled executable
./myapp
```

### Testing and Quality Assurance

```powershell
# Run all tests
dts

# Run tests with coverage
dts --coverage

# Type-check without running
dch src/*.ts

# Format and lint everything
dfmt
dli --fix
```

### Dependency Management

```powershell
# Cache all dependencies
dca deps.ts

# Show dependency information
dinf app.ts

# Check for issues
dch main.ts
```

### Interactive Development

```powershell
# Start REPL for experimentation
dr

# Evaluate quick expressions
de 'console.log(Deno.version)'

# Show documentation
ddoc https://deno.land/std/fs/mod.ts
```

### Project Tasks

```powershell
# Run defined tasks
dtask start
dtask build
dtask test

# Serve HTTP applications
dsv --port=3000 server.ts
```

### Installation and Publishing

```powershell
# Install useful tools
di -A -n file_server https://deno.land/std/http/file_server.ts
di -A -n denon https://deno.land/x/denon/denon.ts

# Publish to JSR
dpub --dry-run  # Test first
dpub            # Actual publish
```

### Permissions Management

```powershell
# Specific permissions
drn --allow-net --allow-read server.ts

# All permissions (development)
drA app.ts

# Watch mode with permissions
drw --allow-all server.ts
```

## Configuration

### Tab Completion

Tab completion is automatically initialized when the module loads, providing completion for:

-   Deno subcommands (run, test, fmt, lint, etc.)
-   Common flags and options
-   File extensions and paths

### Permission Shortcuts

The plugin provides several permission shortcuts:

-   `drA` - Run with all permissions (`-A`)
-   `drw` - Run in watch mode (`--watch`)
-   `dru` - Run with unstable APIs (`--unstable`)

### Development Workflow Integration

Common development patterns:

```powershell
# Full development cycle
function Deploy-DenoApp {
    dfmt                    # Format code
    dli                     # Lint code
    dch main.ts            # Type check
    dts                     # Run tests
    db main.ts bundle.js   # Bundle for production
}

# Development server with hot reload
function Start-DevServer {
    drw --allow-all server.ts
}
```

## Integration

This plugin integrates with:

-   **PowerShell Profile**: Automatic loading and initialization
-   **TypeScript Projects**: Full project lifecycle support
-   **Deno Configuration**: Works with deno.json/deno.jsonc
-   **CI/CD Pipelines**: Suitable for automated workflows

## Troubleshooting

### Common Issues

1. **Deno not found**

    ```powershell
    # Verify Deno installation
    Get-Command deno
    deno --version
    ```

2. **Permission errors**

    ```powershell
    # Use appropriate permission flags
    drA app.ts                    # All permissions
    drn --allow-net server.ts     # Specific permissions
    ```

3. **Module resolution issues**
    ```powershell
    # Cache dependencies first
    dca deps.ts
    dinf app.ts  # Check dependency tree
    ```

### Performance Tips

-   Use `dca` to pre-cache dependencies
-   Use `drw` for development with auto-restart
-   Use `db` to create optimized bundles
-   Use `dch` for quick type checking without execution

## Advanced Usage

### Custom Task Integration

```powershell
# Create custom functions combining multiple operations
function Test-DenoProject {
    dfmt              # Format
    dli               # Lint
    dch main.ts      # Type check
    dts --coverage   # Test with coverage
}

function Build-DenoApp {
    param([string]$Output = "app")

    dfmt                           # Format
    dli                            # Lint
    dts                           # Test
    dc --output=$Output main.ts   # Compile
}
```

### Development Environment Setup

```powershell
# Install common development tools
di -A -n velociraptor https://deno.land/x/velociraptor/cli.ts
di -A -n denon https://deno.land/x/denon/denon.ts
di -A -n deno_lint https://deno.land/x/deno_lint/mod.ts

# Set up project structure
dinit my-project
cd my-project
dfmt
dli
```

### Continuous Integration

```powershell
# CI/CD pipeline functions
function Test-CI {
    dca deps.ts       # Cache dependencies
    dfmt --check      # Check formatting
    dli               # Run linter
    dch main.ts      # Type check
    dts               # Run tests
}

function Build-CI {
    param([string]$Version)

    Test-CI                              # Run tests first
    db main.ts "dist/bundle-$Version.js" # Bundle with version
    dc --output="app-$Version" main.ts   # Compile with version
}
```

## Contributing

To contribute to this plugin:

1. Test changes with various Deno projects and versions
2. Update function documentation with examples
3. Add new aliases following naming conventions
4. Update this README with new features

## Support

For issues and questions:

-   Check function help: `Get-Help Invoke-DenoRun -Full`
-   Deno documentation: https://deno.com/manual
-   PowerShell Profile: https://github.com/MKAbuMattar/powershell-profile

---

_This plugin is part of MKAbuMattar's PowerShell Profile - providing a consistent, powerful shell experience for developers._
