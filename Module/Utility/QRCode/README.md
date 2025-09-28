# QRCode Plugin

Generate QR codes directly from PowerShell using the qrcode.show API service.

## 📋 Table of Contents

-   [Overview](#overview)
-   [Installation](#installation)
-   [Functions](#functions)
-   [Quick Reference](#quick-reference)
-   [Usage Examples](#usage-examples)
-   [Advanced Usage](#advanced-usage)
-   [Troubleshooting](#troubleshooting)
-   [Tips](#tips)
-   [Related Links](#related-links)

## 🔍 Overview

The QRCode plugin provides PowerShell functions to generate QR codes in both PNG and SVG formats using the qrcode.show web service. It offers seamless integration with PowerShell pipelines and supports both interactive and programmatic usage.

### ✨ Key Features

-   **Multiple Formats**: Generate QR codes in PNG (default) and SVG formats
-   **Pipeline Support**: Full PowerShell pipeline integration for text input
-   **Interactive Mode**: Multi-line text input when no parameters provided
-   **Cross-Platform**: Works on Windows, Linux, and macOS
-   **File Export**: Save QR codes directly to files
-   **Service Testing**: Verify connectivity to qrcode.show API
-   **Bash Compatibility**: Familiar aliases (`qrcode`, `qrsvg`) for bash users

## 🚀 Installation

This plugin is automatically available when the PowerShell Profile is loaded. No separate installation required.

```powershell
# Verify the plugin is loaded
Get-Module -Name QRCode -ListAvailable
```

## 📚 Functions

| Function             | Alias    | Description                              |
| -------------------- | -------- | ---------------------------------------- |
| `New-QRCode`         | `qrcode` | Generate QR code in PNG format           |
| `New-QRCodeSVG`      | `qrsvg`  | Generate QR code in SVG format           |
| `Test-QRCodeService` | -        | Test connectivity to qrcode.show service |
| `Save-QRCode`        | -        | Generate and save QR code to file        |

## ⚡ Quick Reference

```powershell
# Basic QR code generation
New-QRCode "Hello World"
qrcode "Hello World"                    # Using alias

# SVG format
New-QRCodeSVG "Hello World"
qrsvg "Hello World"                     # Using alias

# Pipeline input
"https://github.com" | New-QRCode
"PowerShell" | New-QRCodeSVG

# Interactive mode (no parameters)
New-QRCode                              # Enter multi-line text
qrcode                                  # Same using alias

# Save to file
Save-QRCode -InputText "Hello" -Path "qr.png"
Save-QRCode -InputText "Hello" -Path "qr.svg" -Format SVG

# Test service
Test-QRCodeService
```

## 📖 Usage Examples

### Basic QR Code Generation

```powershell
# Simple text QR code
New-QRCode "Hello World"

# URL QR code
New-QRCode "https://github.com/MKAbuMattar/powershell-profile"

# Using alias (bash-compatible)
qrcode "PowerShell is awesome!"
```

### SVG Format QR Codes

```powershell
# Generate SVG QR code
New-QRCodeSVG "Hello World"

# Using alias
qrsvg "https://powershell.org"

# Save SVG to file
New-QRCodeSVG "PowerShell" | Out-File -Encoding UTF8 "powershell-qr.svg"
```

### Pipeline Usage

```powershell
# Single input from pipeline
"https://github.com" | New-QRCode

# Multiple inputs (joined with spaces)
"Hello", "World", "from", "PowerShell" | New-QRCode

# From file content
Get-Content "message.txt" | New-QRCode

# Complex pipeline example
Get-Date -Format "yyyy-MM-dd HH:mm:ss" | New-QRCodeSVG
```

### Interactive Multi-line Input

```powershell
# Start interactive mode
New-QRCode
# Type or paste your text
# Add a blank line
# Press Ctrl+Z (Windows) or Ctrl+D (Unix)

# Example interactive session:
PS> qrcode
Type or paste your text, add a new blank line, and press Ctrl+Z (Windows) or Ctrl+D (Unix)
Line 1 of my message
Line 2 of my message
Line 3 of my message

# QR code generated for multi-line text
```

### File Operations

```powershell
# Save PNG QR code
Save-QRCode -InputText "Hello World" -Path "hello.png"

# Save SVG QR code
Save-QRCode -InputText "Hello World" -Path "hello.svg" -Format SVG

# Auto-detect format from extension
Save-QRCode -InputText "GitHub URL" -Path "github.svg"  # Saves as SVG
Save-QRCode -InputText "GitHub URL" -Path "github.png"  # Saves as PNG
```

## 🔧 Advanced Usage

### Service Connectivity Testing

```powershell
# Test if qrcode.show service is accessible
if (Test-QRCodeService) {
    Write-Host "QR Code service is available" -ForegroundColor Green
    New-QRCode "Service is working!"
} else {
    Write-Warning "QR Code service is not accessible"
}
```

### Error Handling

```powershell
# Handle potential network issues
try {
    $qrCode = New-QRCode "Test message" -Raw
    Write-Host "QR code generated successfully"
} catch {
    Write-Error "Failed to generate QR code: $($_.Exception.Message)"
}
```

### Batch QR Code Generation

```powershell
# Generate QR codes for multiple URLs
$urls = @(
    "https://github.com",
    "https://stackoverflow.com",
    "https://docs.microsoft.com"
)

foreach ($url in $urls) {
    $filename = ($url -replace "https://", "" -replace "[^a-zA-Z0-9]", "_") + ".png"
    Save-QRCode -InputText $url -Path $filename
    Write-Host "Generated QR code for $url -> $filename"
}
```

### Integration with Other Commands

```powershell
# Generate QR code from current directory path
Get-Location | New-QRCode

# Generate QR code from system information
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion | ConvertTo-Json | New-QRCodeSVG

# Generate QR code from network adapter info
Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object Name, InterfaceDescription | ConvertTo-Json -Compress | New-QRCode
```

## 🛠 Troubleshooting

### Common Issues

**Issue**: "Failed to generate QR code: The remote server returned an error"

-   **Solution**: Check internet connectivity and try `Test-QRCodeService`
-   **Cause**: Network connectivity issues or qrcode.show service unavailable

**Issue**: QR code appears corrupted or incomplete

-   **Solution**: Ensure input text doesn't contain special characters that might interfere
-   **Cause**: Text encoding issues or very large input

**Issue**: Interactive mode not working as expected

-   **Solution**: Use `Ctrl+Z` on Windows or `Ctrl+D` on Unix systems to end input
-   **Cause**: Incorrect key combination for ending input

### Network Troubleshooting

```powershell
# Test basic connectivity
Test-NetConnection -ComputerName "qrcode.show" -Port 443

# Test QR code service specifically
Test-QRCodeService -Verbose

# Generate QR code with error handling
try {
    $result = New-QRCode "Test" -Raw -ErrorAction Stop
    Write-Host "Service is working correctly"
} catch {
    Write-Warning "Service issue: $($_.Exception.Message)"
}
```

### Verbose Logging

```powershell
# Enable verbose output for troubleshooting
$VerbosePreference = "Continue"
New-QRCode "Debug test"
$VerbosePreference = "SilentlyContinue"
```

## 💡 Tips

### Performance Tips

-   Use `-Raw` parameter when you don't need formatted output
-   Test service connectivity before batch operations
-   Consider caching QR codes for frequently used content

### Best Practices

-   Keep QR code content concise for better readability
-   Use SVG format for scalable graphics
-   Test QR codes with multiple scanners/apps
-   Include error handling in scripts

### Integration Tips

```powershell
# Add to your PowerShell profile for quick access
function qq { param($text) New-QRCode $text }
function qs { param($text) New-QRCodeSVG $text }

# Create a QR code for current Git repository
function Get-GitQR {
    $remote = git remote get-url origin 2>$null
    if ($remote) {
        $remote | New-QRCode
    } else {
        Write-Warning "Not in a Git repository"
    }
}
```

## 🔗 Related Links

-   **Plugin Documentation**: [QRCode Plugin README](https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/QRCode/README.md)
-   **PowerShell Profile**: [Main Repository](https://github.com/MKAbuMattar/powershell-profile)
-   **QR Code Service**: [qrcode.show](https://qrcode.show/)
-   **All Available Plugins**: [Plugins Overview](https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/README.md)
-   **Plugin Documentation System**: [Docs Module](https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Docs/README.md)

---

> **Note**: This plugin requires internet connectivity to access the qrcode.show API service. Generated QR codes are processed by the external service.

_Part of the [PowerShell Profile](https://github.com/MKAbuMattar/powershell-profile) plugin ecosystem._
