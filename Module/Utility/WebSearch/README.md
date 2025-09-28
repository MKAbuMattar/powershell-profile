# WebSearch Module

The WebSearch module provides comprehensive web search functionality for PowerShell, allowing you to search across 30+ search engines directly from the command line with cross-platform browser launching capabilities.

## Features

-   **30+ Search Engines** - Support for Google, Bing, Brave, DuckDuckGo, GitHub, AI tools, package repositories, and more
-   **Cross-platform browser launching** - Works on Windows, macOS, and Linux
-   **Interactive menu** - Choose search engines through organized categories
-   **Direct command support** - Search directly without menus using engine names or aliases
-   **URL encoding** - Proper handling of special characters in search terms
-   **Extensive aliases** - Multiple shortcuts for quick searches
-   **AI Integration** - Search ChatGPT, Claude AI, and Perplexity directly
-   **Developer Tools** - Search NPM, Docker Hub, GitHub, package repositories

## Available Search Engines

### **General Search Engines**

| Function            | Aliases            | Description                     |
| ------------------- | ------------------ | ------------------------------- |
| `Search-Google`     | `wsggl`            | Google search                   |
| `Search-Bing`       | `wsbing`           | Microsoft Bing search           |
| `Search-Brave`      | `wsbrave`, `wsbrs` | Privacy-focused Brave search    |
| `Search-DuckDuckGo` | `wsddg`            | Privacy-focused search          |
| `Search-Yahoo`      | `wsyahoo`          | Yahoo search                    |
| `Search-Startpage`  | `wssp`             | Privacy search (Google results) |
| `Search-Yandex`     | `wsyandex`         | Russian search engine           |
| `Search-Baidu`      | `wsbaidu`          | Chinese search engine           |
| `Search-Ecosia`     | `wsecosia`         | Environmental search engine     |
| `Search-Qwant`      | `wsqwant`          | European privacy search         |
| `Search-Ask`        | `wsask`            | Ask.com search                  |

### **Academic & Professional**

| Function           | Aliases             | Description                    |
| ------------------ | ------------------- | ------------------------------ |
| `Search-Scholar`   | `wsscholar`         | Google Scholar academic papers |
| `Search-Wikipedia` | `wswiki`            | Wikipedia encyclopedia         |
| `Search-YouTube`   | `wsyt`, `wsyoutube` | YouTube video search           |

### **Development & Packages**

| Function               | Aliases       | Description               |
| ---------------------- | ------------- | ------------------------- |
| `Search-GitHub`        | `wsgh`        | GitHub repository search  |
| `Search-StackOverflow` | `wsso`        | Stack Overflow Q&A        |
| `Search-DockerHub`     | `wsdocker`    | Docker container images   |
| `Search-NPM`           | `wsnpm`       | Node.js package search    |
| `Search-Packagist`     | `wspackagist` | PHP package search        |
| `Search-GoPackages`    | `wsgopkg`     | Go module search          |
| `Search-RustCrates`    | `wsrscrate`   | Rust package search       |
| `Search-RustDocs`      | `wsrsdoc`     | Rust documentation search |

### **AI & Chat Platforms**

| Function            | Aliases                  | Description          |
| ------------------- | ------------------------ | -------------------- |
| `Search-ChatGPT`    | `wschatgpt`              | OpenAI ChatGPT       |
| `Search-Claude`     | `wschaude`               | Anthropic Claude AI  |
| `Search-Perplexity` | `wsppai`, `wsperplexity` | Perplexity AI search |

### **Social & Community**

| Function        | Aliases | Description        |
| --------------- | ------- | ------------------ |
| `Search-Reddit` | `wsrdt` | Reddit discussions |

## Usage

### Interactive Menu

The interactive menu provides organized access to all search engines:

```powershell
Start-WebSearch
# or
ws
```

**Main Menu Options:**

1. Google
2. Bing
3. Brave
4. DuckDuckGo
5. Startpage
6. GitHub
7. StackOverflow
8. Wikipedia
9. Scholar
10. YouTube
11. Reddit
12. ChatGPT
13. Claude AI
14. Perplexity
15. More Options (submenu with additional engines)
16. Quit

### Direct Search

Search directly using engine names:

```powershell
# Popular search engines
ws google "PowerShell tutorial"
ws github "awesome-powershell"
ws stackoverflow "PowerShell arrays"
ws youtube "PowerShell scripting"

# Privacy-focused searches
ws duckduckgo "secure coding practices"
ws brave "privacy tools"
ws startpage "anonymous browsing"

# Developer searches
ws dockerhub "nginx"
ws npm "express.js"
ws packagist "symfony"
ws gopkg "gin framework"
ws rscrate "serde"

# AI assistance
ws chatgpt "explain async programming"
ws claude "code review best practices"
ws perplexity "latest web technologies"

# Academic research
ws scholar "machine learning algorithms"
ws wikipedia "computer science"
```

### Using Aliases Directly

```powershell
# Quick searches with aliases
wsggl "PowerShell best practices"           # Google
wsgh "microsoft/powershell"                # GitHub
wsyt "PowerShell tutorials"                # YouTube
wschatgpt "debug this code"                # ChatGPT
wsdocker "official images"                 # Docker Hub
wsnpm "react hooks"                        # NPM packages
wsrscrate "tokio"                          # Rust crates
```

### Individual Functions

```powershell
# Using full function names with parameters
Search-Google "PowerShell scripting"
Search-GitHub "dotnet core"
Search-YouTube "PowerShell automation"
Search-ChatGPT "code optimization"
Search-DockerHub "alpine linux"
Search-NPM "lodash utility"

# Multiple search terms
Search-DuckDuckGo "PowerShell" "tutorial" "beginner"
Search-Scholar "artificial intelligence" "machine learning"
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

# Quick searches
ws google "PowerShell best practices"
ws github "awesome-lists"
ws stackoverflow "PowerShell error handling"
ws youtube "PowerShell for beginners"
```

### Developer Workflows

```powershell
# Find packages and libraries
ws npm "react components"               # Node.js packages
ws packagist "laravel packages"         # PHP packages
ws gopkg "web frameworks"              # Go packages
ws rscrate "async runtime"             # Rust crates
ws dockerhub "official postgres"       # Container images

# Research and documentation
ws github "kubernetes examples"
ws scholar "distributed systems"
ws rsdoc "tokio"                       # Rust documentation
```

### AI-Assisted Development

```powershell
# Get help from AI tools
ws chatgpt "explain async/await in detail"
ws claude "review this code for security issues"
ws perplexity "latest JavaScript frameworks 2025"
```

### Privacy-Focused Searches

```powershell
# Use privacy-focused search engines
ws duckduckgo "secure coding practices"
ws brave "privacy tools comparison"
ws startpage "anonymous web browsing"
ws qwant "GDPR compliance guide"
```

### International and Specialized Searches

```powershell
# Different regions and languages
ws yandex "российское программирование"  # Russian
ws baidu "中国编程教程"                    # Chinese
ws ecosia "sustainable technology"       # Environmental focus

# Academic and educational
ws scholar "computer science papers"
ws wikipedia "algorithm complexity"
ws ask "how does DNS work"
```

### Advanced Usage

```powershell
# Search with special characters (automatically URL encoded)
ws google "C# vs PowerShell performance"
ws stackoverflow "PowerShell [array] manipulation"
ws github "repo:microsoft/powershell issues"

# Chain searches for research
ws scholar "machine learning"; ws youtube "ML tutorials"
ws github "react projects"; ws npm "react libraries"
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
