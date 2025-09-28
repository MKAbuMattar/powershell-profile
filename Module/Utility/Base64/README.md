# Base64 Utility Module

Base64 encoding and decoding utilities for PowerShell, providing functions to encode text and files to Base64 format and decode Base64 strings back to plain text.

## Features

-   **Text Encoding**: Encode text strings to Base64 format
-   **File Encoding**: Encode entire files to Base64 and save to `.txt` files
-   **Text Decoding**: Decode Base64 strings back to plain text
-   **Pipeline Support**: All functions support pipeline input
-   **Error Handling**: Comprehensive error handling for invalid input

## Available Functions

### Core Functions

| Function               | Alias  | Description                                    |
| ---------------------- | ------ | ---------------------------------------------- |
| `ConvertTo-Base64`     | `e64`  | Encode text or pipeline input to Base64        |
| `ConvertTo-Base64File` | `ef64` | Encode file content to Base64 and save as .txt |
| `ConvertFrom-Base64`   | `d64`  | Decode Base64 text to plain text               |

## Usage Examples

### Basic Text Encoding

```powershell
# Encode a simple string
ConvertTo-Base64 "Hello World"
# or using alias
e64 "Hello World"
# Output: SGVsbG8gV29ybGQ=
```

### Pipeline Operations

```powershell
# Encode from pipeline
"Hello World" | ConvertTo-Base64
"Hello World" | e64

# Encode multiple lines
Get-Content message.txt | ConvertTo-Base64

# Chain encoding and decoding
"Test Message" | e64 | d64
```

### File Operations

```powershell
# Encode a file to Base64
ConvertTo-Base64File "document.pdf"
ef64 "image.png"

# This creates document.pdf.txt or image.png.txt with Base64 content
```

### Decoding Operations

```powershell
# Decode Base64 string
ConvertFrom-Base64 "SGVsbG8gV29ybGQ="
d64 "SGVsbG8gV29ybGQ="
# Output: Hello World

# Decode from file
Get-Content encoded.txt | ConvertFrom-Base64
Get-Content encoded.txt | d64
```

### Advanced Usage

```powershell
# Encode multiple strings
@("Hello", "World", "Test") | ConvertTo-Base64

# Encode file content and decode it back
Get-Content data.txt | e64 | d64

# Process Base64 encoded log files
Get-Content logs.b64 | d64 | Select-String "ERROR"
```

## Error Handling

The module includes comprehensive error handling:

-   **File Not Found**: Validates file existence before encoding
-   **Invalid Base64**: Catches and reports invalid Base64 strings during decoding
-   **Access Denied**: Handles file permission issues gracefully

## Compatibility

-   **PowerShell 5.1+**: Full compatibility with Windows PowerShell
-   **PowerShell Core 7+**: Cross-platform support
-   **Pipeline Support**: All functions support PowerShell pipeline operations
-   **UTF-8 Encoding**: Consistent UTF-8 text encoding

## Implementation Notes

-   Uses .NET `System.Convert.ToBase64String()` and `System.Convert.FromBase64String()` for reliable encoding/decoding
-   Supports both parameter input and pipeline input for maximum flexibility
-   File operations use binary mode to handle any file type correctly
-   Output files are saved with `.txt` extension for easy identification

## Related Commands

This module provides PowerShell equivalents to common Unix/Linux Base64 utilities:

-   `encode64` → `ConvertTo-Base64` / `e64`
-   `encodefile64` → `ConvertTo-Base64File` / `ef64`
-   `decode64` → `ConvertFrom-Base64` / `d64`
