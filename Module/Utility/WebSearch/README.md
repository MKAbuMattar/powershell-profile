# WebSearch Module

The WebSearch module provides comprehensive web search functionality for PowerShell, allowing you to search across multiple search engines directly from the command line.

## Features

-   **Cross-platform browser launching** - Works on Windows, macOS, and Linux
-   **Multiple search engines** - Support for Google, DuckDuckGo, GitHub, Stack Overflow, and more
-   **Interactive menu** - Choose search engines through a user-friendly menu
-   **Direct command support** - Search directly without menus
-   **URL encoding** - Proper handling of special characters in search terms
-   **Bash-style aliases** - Familiar shortcuts for quick searches

## Available Search Engines

| Function               | Alias    | Description                |
| ---------------------- | -------- | -------------------------- |
| `Search-DuckDuckGo`    | `wsddg`  | Search DuckDuckGo          |
| `Search-Wikipedia`     | `wswiki` | Search Wikipedia           |
| `Search-Google`        | `wsggl`  | Search Google              |
| `Search-GitHub`        | `wsgh`   | Search GitHub repositories |
| `Search-StackOverflow` | `wsso`   | Search Stack Overflow      |
| `Search-Reddit`        | `wsrdt`  | Search Reddit              |

## Usage

### Interactive Menu

```powershell
Start-WebSearch
# or
ws
```

### Direct Search

```powershell
# Search Google directly
ws google "PowerShell tutorial"

# Search GitHub for repositories
ws github "awesome-powershell"

# Search Stack Overflow
ws stackoverflow "PowerShell array manipulation"
```

### Individual Functions

```powershell
# Using full function names
Search-Google "PowerShell scripting"
Search-GitHub "dotnet core"

# Using aliases
wsddg "privacy focused search"
wswiki "PowerShell"
wsgh "microsoft/powershell"
```

### URL Encoding Utility

```powershell
ConvertTo-UrlEncoded "hello world & special chars!"
# Returns: hello%20world%20%26%20special%20chars%21
```

### Browser Launching Utility

```powershell
Start-WebBrowser "https://www.example.com"
```

## Examples

### Basic Searches

```powershell
# Interactive menu
Start-WebSearch

# Quick Google search
ws google "PowerShell best practices"

# Search for PowerShell modules on GitHub
wsgh "PowerShell modules"

# Look up documentation on Stack Overflow
wsso "PowerShell error handling"
```

### Advanced Usage

```powershell
# Search multiple terms
Search-DuckDuckGo "PowerShell" "tutorial" "beginner"

# Search with special characters
ws google "C# vs PowerShell performance"

# Search Reddit discussions
Search-Reddit "PowerShell tips and tricks"
```

## Cross-Platform Support

The module automatically detects your operating system and uses the appropriate method to launch browsers:

-   **Windows**: Uses `Start-Process` to open the default browser
-   **macOS**: Uses the `open` command
-   **Linux**: Tries multiple options in order:
    -   `xdg-open` (GUI browsers)
    -   `lynx` (terminal browser)
    -   `browsh` (modern terminal browser)
    -   `links2` (graphical mode)
    -   `links` (text mode)

## Help

Get help information:

```powershell
Start-WebSearch help
# or
ws --help
# or
Show-WebSearchHelp
```

## Notes

-   Requires internet connectivity for searches
-   URL encoding handles special characters automatically
-   On Linux, ensure you have a browser installed (GUI or terminal-based)
-   Some search engines may have rate limiting or access restrictions

## Integration

This module integrates seamlessly with the PowerShell Profile utility system and provides bash-compatible aliases for users familiar with the original zsh/bash web-search functionality.
