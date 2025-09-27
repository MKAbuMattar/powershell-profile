# Flutter Plugin

Comprehensive Flutter CLI integration with PowerShell functions and convenient aliases for Flutter app development. Provides complete workflow automation with automatic PowerShell completion, device management, build processes, and cross-platform development support for mobile, web, and desktop applications.

## Features

-   **Complete Flutter CLI Integration**: All essential Flutter commands with PowerShell wrappers
-   **Cross-Platform Development**: Support for Android, iOS, web, Windows, macOS, and Linux
-   **Build Management**: APK, iOS, web, and desktop build automation
-   **Device Management**: List and manage connected devices and emulators
-   **Package Management**: Flutter pub commands for dependency management
-   **Multiple Run Modes**: Debug, profile, and release mode execution
-   **SDK Management**: Channel switching and Flutter SDK upgrades
-   **PowerShell Tab Completion**: Enhanced productivity with intelligent completions
-   **Error Handling**: Comprehensive error checking and user feedback

## Installation

The Flutter plugin is automatically loaded as part of the PowerShell profile. Ensure Flutter SDK is installed and accessible via PATH.

### Prerequisites

-   Flutter SDK 3.0.0 or later
-   PowerShell 5.1 or later (PowerShell Core 7+ recommended)
-   Platform-specific development tools (Android Studio, Xcode, etc.)

## Available Commands

### Core Commands

| Command                   | Alias      | Description                   |
| ------------------------- | ---------- | ----------------------------- |
| `Invoke-Flutter`          | `flu`      | Base Flutter command wrapper  |
| `Invoke-FlutterAttach`    | `flattach` | Attach to running application |
| `Invoke-FlutterBuild`     | `flb`      | Build Flutter application     |
| `Invoke-FlutterChannel`   | `flchnl`   | Manage Flutter SDK channels   |
| `Invoke-FlutterClean`     | `flc`      | Clean build files and caches  |
| `Get-FlutterDevices`      | `fldvcs`   | List available devices        |
| `Invoke-FlutterDoctor`    | `fldoc`    | Run Flutter doctor            |
| `Invoke-FlutterPub`       | `flpub`    | Execute Flutter pub commands  |
| `Get-FlutterPubPackages`  | `flget`    | Get package dependencies      |
| `Start-FlutterApp`        | `flr`      | Run Flutter application       |
| `Start-FlutterAppDebug`   | `flrd`     | Run in debug mode             |
| `Start-FlutterAppProfile` | `flrp`     | Run in profile mode           |
| `Start-FlutterAppRelease` | `flrr`     | Run in release mode           |
| `Update-Flutter`          | `flupgrd`  | Upgrade Flutter SDK           |

## Usage Examples

### Project Setup and Management

```powershell
# Check Flutter installation and dependencies
fldoc

# Check available devices
fldvcs

# Create new Flutter project
flu create my_app

# Navigate to project and get dependencies
cd my_app
flget

# Clean build files
flc
```

### Running Applications

```powershell
# Run app in debug mode (default)
flr

# Run app on specific device
flr --device chrome
flr --device android
flr --device ios

# Run in different modes
flrd                    # Debug mode with hot reload
flrp                    # Profile mode for performance testing
flrr                    # Release mode (optimized)

# Run with specific target
flr --target lib/main_dev.dart

# Attach to running application
flattach
```

### Building Applications

```powershell
# Build for different platforms
flb apk                 # Android APK
flb appbundle          # Android App Bundle
flb ios                # iOS application
flb ipa                # iOS App Store package
flb web                # Web application
flb windows            # Windows desktop
flb macos              # macOS desktop
flb linux              # Linux desktop

# Build with specific configurations
flb apk --release
flb ios --debug
flb web --dart-define=ENV=production
```

### Package Management

```powershell
# Get all dependencies
flget

# Add new packages
flpub add http
flpub add provider
flpub add --dev flutter_test

# Remove packages
flpub remove http

# Upgrade packages
flpub upgrade

# Run custom scripts
flpub run build_runner build
flpub run flutter_launcher_icons:main
```

### SDK and Channel Management

```powershell
# Check current channel
flchnl

# Switch to different channels
flchnl stable
flchnl beta
flchnl dev

# Upgrade Flutter SDK
flupgrd

# Upgrade with force (if needed)
flupgrd --force
```

### Development Workflow

```powershell
# Complete development setup
fldoc                          # Verify installation
flu create my_flutter_app      # Create new project
cd my_flutter_app
flget                          # Get dependencies
fldvcs                         # Check available devices
flrd                           # Start development with hot reload

# Build and test workflow
flc                            # Clean previous builds
flb apk --debug                # Build debug APK
flu test                       # Run unit tests
flb apk --release              # Build release APK
```

### Advanced Usage

```powershell
# Performance profiling
flrp --enable-software-rendering
flrp --trace-startup

# Web development
flr --device chrome --web-hostname 0.0.0.0 --web-port 8080
flb web --dart-define=Dart2jsOptimization=O4

# Custom build configurations
flb apk --flavor production --dart-define=ENV=prod
flb ios --release --dart-define=API_URL=https://prod.api.com

# Integration with CI/CD
fl test --coverage
flb apk --release --no-sound-null-safety
```

## PowerShell Tab Completion

The plugin provides intelligent tab completion for:

-   Flutter commands (`fl <TAB>`)
-   Build targets (`flb <TAB>`)
-   SDK channels (`flchnl <TAB>`)
-   Pub commands (`flpub <TAB>`)

## Integration with Development Tools

### Android Development

```powershell
# Check Android setup
fldoc --android-licenses

# List Android devices
fldvcs

# Build for Android
flb apk --split-per-abi
flb appbundle --target-platform android-arm64
```

### iOS Development

```powershell
# Build for iOS
flb ios --release --codesign

# Run on iOS simulator
flr --device ios

# Build for App Store
flb ipa --export-options-plist ios/ExportOptions.plist
```

### Web Development

```powershell
# Run web app
flr --device chrome --web-port 3000

# Build optimized web app
flb web --web-renderer canvaskit --dart-define=FLUTTER_WEB_USE_SKIA=true
```

## Troubleshooting

### Common Issues

1. **Flutter not found**

    ```powershell
    # Check if Flutter is in PATH
    fl --version

    # Add Flutter to PATH if needed
    $env:PATH += ";C:\flutter\bin"
    ```

2. **Device not detected**

    ```powershell
    # Check device connectivity
    fldvcs

    # Run doctor for device issues
    fldoc -v
    ```

3. **Build failures**

    ```powershell
    # Clean and rebuild
    flc
    flget
    flb apk
    ```

4. **Package issues**
    ```powershell
    # Clear pub cache
    flpub cache clean
    flget --offline
    ```

### Performance Optimization

```powershell
# Enable performance flags
flr --enable-software-rendering
flr --skia-deterministic-rendering
flrr --split-debug-info=build/debug-info/
```

### Hot Reload Issues

```powershell
# Restart with hot restart
# Press 'R' in flutter run session, or
fl run --hot
```

## Configuration

### Flutter SDK Channels

-   **Stable**: Production-ready releases
-   **Beta**: Pre-release versions with new features
-   **Dev**: Latest development changes
-   **Master**: Cutting-edge (may be unstable)

### Environment Variables

```powershell
# Set Flutter tool environment
$env:FLUTTER_ROOT = "C:\flutter"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
```

## Best Practices

1. **Always run `fldoc` after Flutter updates**
2. **Use `flc` before important builds**
3. **Test on multiple devices with `fldvcs`**
4. **Keep dependencies updated with `flpub upgrade`**
5. **Use appropriate build modes for different scenarios**
6. **Leverage hot reload in development with `flrd`**

## Links

-   [Flutter Official Documentation](https://docs.flutter.dev/)
-   [Flutter CLI Reference](https://docs.flutter.dev/reference/flutter-cli)
-   [Dart Packages](https://pub.dev/)
-   [Flutter Samples](https://flutter.github.io/samples/)
-   [PowerShell Profile Repository](https://github.com/MKAbuMattar/powershell-profile)

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests to improve the Flutter plugin.

## License

This module is part of the PowerShell Profile project and is licensed under the MIT License.
