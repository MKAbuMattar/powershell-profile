#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Flutter Plugin
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
#       This module provides comprehensive Flutter CLI integration with PowerShell functions and
#       convenient aliases for cross-platform mobile, web, and desktop app development. Provides
#       complete development workflow automation with device management, build processes,
#       package management, SDK channel switching, and multi-platform support for Android, iOS,
#       web, Windows, macOS, and Linux development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------
function Invoke-Flutter {
    <#
    .SYNOPSIS
        Executes flutter command with specified arguments.

    .DESCRIPTION
        Direct wrapper for flutter command execution with all arguments passed through.
        Provides a base function for other Flutter operations.

    .PARAMETER Arguments
        Arguments to pass to flutter command.

    .EXAMPLE
        Invoke-Flutter --version
        Shows Flutter version information.

    .EXAMPLE
        Invoke-Flutter help
        Shows Flutter help information.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter @Arguments
}

function Invoke-FlutterAttach {
    <#
    .SYNOPSIS
        Attach to a running application.

    .DESCRIPTION
        Connects to and debugs a running Flutter application.
        This command can be used to attach to a running app instance.

    .PARAMETER Arguments
        Additional arguments for flutter attach command.

    .EXAMPLE
        Invoke-FlutterAttach
        Attaches to a running Flutter application.

    .EXAMPLE
        Invoke-FlutterAttach --target lib/main_dev.dart
        Attaches to a specific target file.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flattach")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter attach @Arguments
}

function Invoke-FlutterBuild {
    <#
    .SYNOPSIS
        Build a Flutter application.

    .DESCRIPTION
        Builds a Flutter application for the specified platform.
        Supports various platforms like APK, iOS, web, etc.

    .PARAMETER Arguments
        Build arguments including platform and options.

    .EXAMPLE
        Invoke-FlutterBuild apk
        Builds an APK for Android.

    .EXAMPLE
        Invoke-FlutterBuild ios --release
        Builds iOS app in release mode.

    .EXAMPLE
        Invoke-FlutterBuild web
        Builds web version of the app.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter build @Arguments
}

function Invoke-FlutterChannel {
    <#
    .SYNOPSIS
        Manage Flutter SDK channels.

    .DESCRIPTION
        Shows or switches Flutter SDK channels (stable, beta, dev, master).
        Use without arguments to see current channel and available channels.

    .PARAMETER Arguments
        Channel name or additional arguments.

    .EXAMPLE
        Invoke-FlutterChannel
        Shows current channel and available channels.

    .EXAMPLE
        Invoke-FlutterChannel stable
        Switches to stable channel.

    .EXAMPLE
        Invoke-FlutterChannel beta
        Switches to beta channel.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flchnl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter channel @Arguments
}

function Invoke-FlutterClean {
    <#
    .SYNOPSIS
        Clean build files and caches.

    .DESCRIPTION
        Deletes build directories and other generated files.
        This is useful when you want a clean slate for rebuilding.

    .PARAMETER Arguments
        Additional arguments for flutter clean command.

    .EXAMPLE
        Invoke-FlutterClean
        Cleans build files in current project.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter clean @Arguments
}

function Get-FlutterDevices {
    <#
    .SYNOPSIS
        List available devices for Flutter development.

    .DESCRIPTION
        Shows all connected devices and available emulators/simulators
        that can be used for Flutter development and testing.

    .PARAMETER Arguments
        Additional arguments for flutter devices command.

    .EXAMPLE
        Get-FlutterDevices
        Lists all available devices.

    .EXAMPLE
        Get-FlutterDevices --machine
        Lists devices in machine-readable format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("fldvcs")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter devices @Arguments
}

function Invoke-FlutterDoctor {
    <#
    .SYNOPSIS
        Check Flutter installation and dependencies.

    .DESCRIPTION
        Runs Flutter doctor to verify the Flutter installation and
        check for any missing dependencies or configuration issues.

    .PARAMETER Arguments
        Additional arguments for flutter doctor command.

    .EXAMPLE
        Invoke-FlutterDoctor
        Runs basic doctor check.

    .EXAMPLE
        Invoke-FlutterDoctor --verbose
        Runs doctor check with verbose output.

    .EXAMPLE
        Invoke-FlutterDoctor --android-licenses
        Accepts Android SDK licenses.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("fldoc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter doctor @Arguments
}

function Invoke-FlutterPub {
    <#
    .SYNOPSIS
        Execute Flutter pub commands.

    .DESCRIPTION
        Manages package dependencies using Flutter's package manager.
        This is equivalent to 'dart pub' but within Flutter context.

    .PARAMETER Arguments
        Pub command and arguments (get, upgrade, add, remove, etc.).

    .EXAMPLE
        Invoke-FlutterPub get
        Gets all package dependencies.

    .EXAMPLE
        Invoke-FlutterPub add http
        Adds http package to dependencies.

    .EXAMPLE
        Invoke-FlutterPub upgrade
        Upgrades all packages to latest versions.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flpub")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter pub @Arguments
}

function Get-FlutterPubPackages {
    <#
    .SYNOPSIS
        Get package dependencies for Flutter project.

    .DESCRIPTION
        Downloads and installs all package dependencies listed in pubspec.yaml.
        This is equivalent to 'flutter pub get'.

    .PARAMETER Arguments
        Additional arguments for flutter pub get command.

    .EXAMPLE
        Get-FlutterPubPackages
        Gets all package dependencies.

    .EXAMPLE
        Get-FlutterPubPackages --offline
        Gets packages using only locally cached versions.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flget")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter pub get @Arguments
}

function Start-FlutterApp {
    <#
    .SYNOPSIS
        Run a Flutter application.

    .DESCRIPTION
        Compiles and runs a Flutter application on connected devices.
        This is the main command for running Flutter apps during development.

    .PARAMETER Arguments
        Run arguments including target, device, and build options.

    .EXAMPLE
        Start-FlutterApp
        Runs the Flutter app on default device.

    .EXAMPLE
        Start-FlutterApp --device chrome
        Runs the app in Chrome browser.

    .EXAMPLE
        Start-FlutterApp --target lib/main_dev.dart
        Runs the app with a specific entry point.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter run @Arguments
}

function Start-FlutterAppDebug {
    <#
    .SYNOPSIS
        Run Flutter application in debug mode.

    .DESCRIPTION
        Runs a Flutter application in debug mode with debugging capabilities enabled.
        This includes hot reload, debugging tools, and assertions.

    .PARAMETER Arguments
        Additional arguments for flutter run command.

    .EXAMPLE
        Start-FlutterAppDebug
        Runs the app in debug mode.

    .EXAMPLE
        Start-FlutterAppDebug --device android
        Runs the app in debug mode on Android device.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flrd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $debugArgs = @('run', '--debug') + $Arguments
    & flutter @debugArgs
}

function Start-FlutterAppProfile {
    <#
    .SYNOPSIS
        Run Flutter application in profile mode.

    .DESCRIPTION
        Runs a Flutter application in profile mode, which is optimized for performance
        profiling while still allowing some debugging capabilities.

    .PARAMETER Arguments
        Additional arguments for flutter run command.

    .EXAMPLE
        Start-FlutterAppProfile
        Runs the app in profile mode.

    .EXAMPLE
        Start-FlutterAppProfile --device ios
        Runs the app in profile mode on iOS device.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flrp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $profileArgs = @('run', '--profile') + $Arguments
    & flutter @profileArgs
}

function Start-FlutterAppRelease {
    <#
    .SYNOPSIS
        Run Flutter application in release mode.

    .DESCRIPTION
        Runs a Flutter application in release mode with full optimizations.
        This mode is used for production builds and performance testing.

    .PARAMETER Arguments
        Additional arguments for flutter run command.

    .EXAMPLE
        Start-FlutterAppRelease
        Runs the app in release mode.

    .EXAMPLE
        Start-FlutterAppRelease --device android
        Runs the app in release mode on Android device.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flrr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $releaseArgs = @('run', '--release') + $Arguments
    & flutter @releaseArgs
}

function Update-Flutter {
    <#
    .SYNOPSIS
        Upgrade Flutter SDK.

    .DESCRIPTION
        Updates Flutter SDK to the latest version available on the current channel.
        This also updates Dart SDK and other Flutter tools.

    .PARAMETER Arguments
        Additional arguments for flutter upgrade command.

    .EXAMPLE
        Update-Flutter
        Upgrades Flutter to latest version.

    .EXAMPLE
        Update-Flutter --force
        Forces upgrade even if there are uncommitted changes.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Flutter/README.md
    #>
    [CmdletBinding()]
    [Alias("flupgrd")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & flutter upgrade @Arguments
}
