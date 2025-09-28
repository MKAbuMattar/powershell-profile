<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Utility\README.md -->

# Utility Module

## **Table of Contents**

-   [Module Overview](#module-overview)
-   [Available Utilities](#available-utilities)
    -   [System Administration](#system-administration)
    -   [Development Tools](#development-tools)
    -   [Productivity & Convenience](#productivity--convenience)
    -   [Data & File Utilities](#data--file-utilities)
    -   [Web & Network Tools](#web--network-tools)
-   [Quick Start Examples](#quick-start-examples)
-   [Architecture & Design](#architecture--design)
-   [Troubleshooting](#troubleshooting)
-   [Getting Help](#getting-help)
-   [Contributing](#contributing)
-   [License](#license)

## **Module Overview**

The Utility module is a comprehensive collection of general-purpose PowerShell functions designed to enhance your command-line experience and streamline everyday tasks. This module provides essential utilities for system administration, development workflows, productivity enhancement, and data manipulation - all integrated seamlessly into your PowerShell environment.

Each utility is designed with simplicity and efficiency in mind, providing intuitive shortcuts, comprehensive functionality, and consistent behavior across different platforms. The utilities complement your existing PowerShell workflow while adding powerful capabilities for common scenarios.

## **Available Utilities**

### **System Administration**

#### **Administrator Privileges & System Info**

Essential system administration utilities for privilege management and environment validation.

**Key Functions:**

-   `Test-Administrator` (alias: `is-admin`) - Check administrator privileges
-   `Test-CommandExists` (alias: `command-exists`) - Verify command availability
-   `Invoke-ReloadProfile` (alias: `reload-profile`) - Reload PowerShell profile
-   `Get-Uptime` (alias: `uptime`) - System uptime information
-   `Get-CommandDefinition` (alias: `def`) - Command definition lookup

**Key Features:** Privilege validation, environment checking, profile management, system information

**Location:** `Module/Utility/Utility/`

#### **Function Details:**

**`Test-Administrator`** (Alias: `is-admin`):

-   _Description:_ Checks if the current PowerShell session is running with administrator privileges.
-   _Usage:_ `is-admin` (Returns `$true` or `$false`)

**`Test-CommandExists`** (Alias: `command-exists`):

-   _Description:_ Verifies if a specified command (cmdlet, function, alias, or executable) exists in the current session or path.
-   _Usage:_ `command-exists "git"`

**`Invoke-ReloadProfile`** (Alias: `reload-profile`):

-   _Description:_ Reloads the current PowerShell profile, applying any changes made since it was last loaded.
-   _Usage:_ `reload-profile`

**`Get-Uptime`** (Alias: `uptime`):

-   _Description:_ Retrieves and displays the system uptime in a human-readable format (e.g., "3 days, 5 hours, 12 minutes").
-   _Usage:_ `uptime`

**`Get-CommandDefinition`** (Alias: `def`):

-   _Description:_ Retrieves the definition or source code of a given PowerShell command (function, alias, or cmdlet).
-   _Usage:_ `def Get-ChildItem`

#### **Disk Usage Analysis**

Analyze disk usage and storage statistics with flexible unit conversion.

**Key Functions:**

-   `Get-DiskUsage` (alias: `du`) - Disk usage statistics with unit conversion

**Key Features:** Path analysis, multiple units, storage statistics, cross-platform compatibility

**Location:** `Module/Utility/Utility/`

**`Get-DiskUsage`** (Alias: `du`):

-   _Description:_ Retrieves and displays disk usage statistics for the current drive or a specified path.
-   _Usage:_ `du` or `du "C:\Users"`

Complete Base64 encoding and decoding utilities with file and text support.**Location:** `Module/Utility/Utility/` - _Description:_ Verifies if a specified command (cmdlet, function, alias, or executable) exists in the current session or path.

**Key Functions:\*\***Documentation:\*\* [Administrator Utilities README](Utility/README.md)

-   `ConvertTo-Base64` (alias: `e64`) - Encode text to Base64

-   `ConvertFrom-Base64` (alias: `d64`) - Decode Base64 to text ### **System Administration** - _Usage:_ `command-exists "git"`

### **Development Tools**

#### **Base64 Encoding/Decoding**

Complete Base64 encoding and decoding utilities with file and text support.

**Key Functions:**

-   `ConvertTo-Base64` (alias: `e64`) - Encode text to Base64
-   `ConvertFrom-Base64` (alias: `d64`) - Decode Base64 to text
-   `ConvertTo-Base64File` (alias: `ef64`) - Encode files to Base64

**Key Features:** Text encoding/decoding, file encoding, pipeline support, cross-platform compatibility

**Location:** `Module/Utility/Base64/`

**Documentation:** [Base64 Utilities README](Base64/README.md)

#### **GitIgnore Management**

Comprehensive .gitignore file management using the gitignore.io API service.

**Key Functions:**

-   `Get-GitIgnore` (alias: `gitignore`) - Generate .gitignore content
-   `Get-GitIgnoreList` (alias: `gilist`) - List available templates
-   `New-GitIgnoreFile` (alias: `ginew`) - Create .gitignore files
-   `Add-GitIgnoreContent` (alias: `giadd`) - Add to existing .gitignore

-   `Test-GitIgnoreService` (alias: `gitest`) - Test API connectivity- `ConvertTo-Base64` (alias: `e64`) - Encode text to Base64**Key Functions:**

-   `Test-GitIgnoreService` (alias: `gitest`) - Test API connectivity

**Key Features:** Template generation, API integration, file management, technology filtering

**Location:** `Module/Utility/GitIgnore/`

**Documentation:** [GitIgnore Utilities README](GitIgnore/README.md)

#### **QRCode Generation**

Generate QR codes directly from PowerShell using the qrcode.show API service.

**Key Functions:**

-   `New-QRCode` (alias: `qrcode`) - Generate PNG QR codes
-   `New-QRCodeSVG` (alias: `qrsvg`) - Generate SVG QR codes
-   `Save-QRCode` - Save QR codes to files
-   `Test-QRCodeService` - Test API connectivity

**Key Features:** PNG/SVG generation, PowerShell pipeline support, interactive mode, file operations, web API integration

**Location:** `Module/Utility/QRCode/`

**Documentation:** [QRCode Generation README](QRCode/README.md)

### **Productivity & Convenience**

#### **Random Quote Generator**

Fetch inspirational and motivational quotes from online APIs.

**Key Functions:**

-   `Get-RandomQuote` (alias: `quote`) - Fetch random quotes

**Key Features:** Multiple quote sources, inspirational content, API integration

**Location:** `Module/Utility/RandomQuote/`

**Documentation:** [Random Quote README](RandomQuote/README.md)

**Location:** `Module/Utility/GitIgnore/` #### **[Process Management](Process/README.md)**- **`Get-RandomQuote`** (Alias: `quote`):

#### **Weather Forecast**

**Documentation:** [GitIgnore Utilities README](GitIgnore/README.md)

Get weather information and forecasts for any location worldwide.

Comprehensive process management utilities for monitoring and controlling system processes. - _Description:_ Fetches and displays a random quote, typically from an online API.

**Key Functions:**

-   `Get-WeatherForecast` (alias: `weather`) - Weather forecasts with customizable formats#### **[QRCode Generation](QRCode/README.md)**

**Key Features:** Location-based weather, multiple formats, Moon phases, multilingual support, weather glyphs - _Usage:_ `quote`

**Location:** `Module/Utility/WeatherForecast/`

**Documentation:** [Weather Forecast README](WeatherForecast/README.md)Generate QR codes directly from PowerShell using the qrcode.show API service.

#### **Prayer Times\*\***Key Functions:\*\*

Get accurate Islamic prayer times for any city and country.**Key Functions:**

**Key Functions:**- `New-QRCode` (alias: `qrcode`) - Generate PNG QR codes- Process enumeration and filtering- **`Get-WeatherForecast`** (Alias: `weather`):

-   `Get-PrayerTimes` (alias: `prayer`) - Prayer times with multiple calculation methods

-   `New-QRCodeSVG` (alias: `qrsvg`) - Generate SVG QR codes

**Key Features:** Global city coverage, multiple calculation methods, time format options, accurate prayer schedules

**Location:** `Module/Utility/PrayerTimes/` - `Save-QRCode` - Save QR codes to files- Process termination by name or port

**Documentation:** [Prayer Times README](PrayerTimes/README.md)

-   `Test-QRCodeService` - Test API connectivity

#### **Timing Utilities**

-   Process monitoring and statistics - _Description:_ Retrieves and displays the current weather forecast for a specified location using an online weather service.

Essential timing and productivity utilities for time management.

**Key Features:** PNG/SVG generation, PowerShell pipeline support, interactive mode, file operations, web API integration

**Key Functions:**

-   `Start-Countdown` (alias: `countdown`) - Countdown timers with custom titles**Location:** `Module/Utility/QRCode/` - Resource usage analysis - _Usage:_ `weather -Location "London"` or `weather Amman`

-   `Start-Stopwatch` (alias: `stopwatch`) - Stopwatch functionality

-   `Get-WallClock` (alias: `wallclock`) - Large display clock with timezone support**Documentation:** [QRCode Generation README](QRCode/README.md)

**Key Features:** Flexible timing, timezone support, visual displays, productivity tracking **Key Features:** Process discovery, resource monitoring, safe termination, detailed process information - **`Start-Countdown`** (Alias: `countdown`):

**Location:** `Module/Utility/Utility/`

### **Productivity & Convenience**

### **Data & File Utilities**

**Location:** `Module/Utility/Process/`

#### **Matrix Animation**

#### **[Random Quote Generator](RandomQuote/README.md)**

Digital rain matrix animation for console entertainment.

**Documentation:** [Process Management README](Process/README.md) - _Description:_ Starts a countdown timer for a specified duration or until a specific time, displaying the remaining time in the console.

**Key Functions:**

-   `Start-Matrix` (alias: `matrix`) - Matrix rain animation with customizable speedFetch inspirational and motivational quotes from online APIs.

**Key Features:** Console animation, configurable speed, entertainment utility - _Usage Examples:_

**Location:** `Module/Utility/Matrix/`

**Documentation:** [Matrix Animation README](Matrix/README.md)**Key Functions:**

### **Web & Network Tools**- `Get-RandomQuote` (alias: `quote`) - Fetch random quotes### **Development Tools** - `countdown -Duration "30m" -Title "Meeting starts in:"`

#### **Web Search Integration\*\***Key Features:\*\* Multiple quote sources, inspirational content, API integration - `countdown -Until "17:00" -Title "End of Workday"`

Integrated web search functionality with multiple search engines.**Location:** `Module/Utility/RandomQuote/`

**Key Functions:\*\***Documentation:** [Random Quote README](RandomQuote/README.md)#### **[Base64 Encoding/Decoding](Base64/README.md)\*\*

-   `Start-WebSearch` (alias: `web-search`, `ws`) - Interactive web search

-   `Search-Google` (alias: `wsggl`) - Google search#### **[Weather Forecast](WeatherForecast/README.md)**- **`Start-Stopwatch`** (Alias: `stopwatch`):

-   `Search-DuckDuckGo` (alias: `wsddg`) - DuckDuckGo search

-   `Search-GitHub` (alias: `wsgh`) - GitHub repository searchGet weather information and forecasts for any location worldwide.Complete Base64 encoding and decoding utilities with file and text support.

-   `Search-StackOverflow` (alias: `wsso`) - Stack Overflow search

-   `Search-Wikipedia` (alias: `wswiki`) - Wikipedia search**Key Functions:** - _Description:_ Starts a stopwatch timer. Pressing Enter typically stops it and displays the elapsed time.

-   `Search-Reddit` (alias: `wsrdt`) - Reddit search

-   `Get-WeatherForecast` (alias: `weather`) - Weather forecasts with customizable formats

**Key Features:** Multiple search engines, cross-platform browser launching, URL encoding, interactive menu

**Location:** `Module/Utility/WebSearch/` **Key Functions:** - _Usage:_ `stopwatch -Title "Task Timer"`

**Documentation:** [Web Search README](WebSearch/README.md)

**Key Features:** Location-based weather, multiple formats, Moon phases, multilingual support, weather glyphs

## **Quick Start Examples**

**Location:** `Module/Utility/WeatherForecast/` - `ConvertTo-Base64` (alias: `e64`) - Encode text to Base64

### **System Administration:**

**Documentation:** [Weather Forecast README](WeatherForecast/README.md)

````powershell

# Check system status-   `ConvertFrom-Base64` (alias: `d64`) - Decode Base64 to text - **`Get-WallClock`** (Alias: `clock`):

is-admin                                 # Check administrator privileges

uptime                                   # System uptime#### **[Prayer Times](PrayerTimes/README.md)**

command-exists git                       # Verify Git is available

def Get-Process                          # Get command definition-   `ConvertTo-Base64File` (alias: `ef64`) - Encode files to Base64



# Profile managementGet accurate Islamic prayer times for any city and country.

reload-profile                           # Reload PowerShell profile after changes

    -   _Description:_ Displays the current time, optionally for a specified timezone.

# Disk usage

du                                       # Current directory usage**Key Functions:**

du "C:\Users"                           # Specific path usage

```-   `Get-PrayerTimes` (alias: `prayer`) - Prayer times with multiple calculation methods**Key Features:** Text encoding/decoding, file encoding, pipeline support, cross-platform compatibility - _Usage:_ `clock -TimeZone "Pacific Standard Time"` or `wallclock -TimeZone "Europe/Berlin"`



### **Development Workflow:****Key Features:** Global city coverage, multiple calculation methods, time format options, accurate prayer schedules **Location:** `Module/Utility/Base64/`



```powershell**Location:** `Module/Utility/PrayerTimes/`

# Base64 operations

"Hello World" | e64                      # Encode to Base64**Documentation:** [Prayer Times README](PrayerTimes/README.md)**Documentation:** [Base64 Utilities README](Base64/README.md)- **`Get-PrayerTimes`** (Alias: `prayer`):

"SGVsbG8gV29ybGQ=" | d64                 # Decode from Base64

ef64 "document.pdf"                      # Encode file to Base64#### **[Timing Utilities](Utility/README.md)**#### **[GitIgnore Management](GitIgnore/README.md)** - _Description:_ Retrieves and displays Islamic prayer times for a specified city and country, usually by querying an online API.



# GitIgnore managementEssential timing and productivity utilities for time management. - _Usage:_ `prayer -City "Mecca" -Country "Saudi Arabia"`

gitignore node python                    # Generate .gitignore content

gilist -Filter python                    # List Python-related templates**Key Functions:**Comprehensive .gitignore file management using the gitignore.io API service.

ginew visualstudio node                  # Create new .gitignore file

giadd docker kubernetes                  # Add to existing .gitignore-   `Start-Countdown` (alias: `countdown`) - Countdown timers with custom titles



# QRCode generation-   `Start-Stopwatch` (alias: `stopwatch`) - Stopwatch functionality- **`Start-Matrix`** (Alias: `matrix`):

qrcode "Hello World"                     # Generate PNG QR code

qrsvg "https://github.com"              # Generate SVG QR code-   `Get-WallClock` (alias: `wallclock`) - Large display clock with timezone support

Save-QRCode -Text "Contact" -FilePath "contact.png"

```**Key Functions:**



### **Productivity & Information:****Key Features:** Flexible timing, timezone support, visual displays, productivity tracking



```powershell**Location:** `Module/Utility/Utility/` - `Get-GitIgnore` (alias: `gitignore`) - Generate .gitignore content - _Description:_ Displays a "Matrix" digital rain-like animation in the PowerShell console.

# Get information and inspiration

quote                                    # Random inspirational quote**Documentation:** [Timing Utilities README](Utility/README.md)

weather London                           # Weather forecast for London

prayer -City "Mecca" -Country "Saudi Arabia"  # Prayer times-   `Get-GitIgnoreList` (alias: `gilist`) - List available templates - _Usage:_ `matrix`



# Timing utilities### **Data & File Utilities**

countdown -Duration "25m" -Title "Pomodoro"    # 25-minute countdown

stopwatch -Title "Task Timer"                  # Start stopwatch-   `New-GitIgnoreFile` (alias: `ginew`) - Create .gitignore files

wallclock -TimeZone "Pacific Standard Time"   # Display clock

```#### **[Matrix Animation](Matrix/README.md)**



### **Web & Search:**-   `Add-GitIgnoreContent` (alias: `giadd`) - Add to existing .gitignore- **`Get-DiskUsage`** (Alias: `du`):



```powershellDigital rain matrix animation for console entertainment.

# Web searches

ws                                       # Interactive search menu-   `Test-GitIgnoreService` (alias: `gitest`) - Test API connectivity

ws google "PowerShell tutorial"          # Direct Google search

wsgh "awesome-powershell"                # Search GitHub repositories**Key Functions:**

wsso "powershell arrays"                 # Search Stack Overflow

wswiki "PowerShell"                      # Search Wikipedia-   `Start-Matrix` (alias: `matrix`) - Matrix rain animation with customizable speed - _Description:_ Retrieves and displays disk usage statistics for the current drive or a specified path.

````

**Key Features:** Console animation, configurable speed, entertainment utility **Key Features:** Template generation, API integration, file management, technology filtering - _Usage:_ `du` or `du "C:\Users"`

### **Fun & Entertainment:**

**Location:** `Module/Utility/Matrix/`

````powershell

# Entertainment**Documentation:** [Matrix Animation README](Matrix/README.md)**Location:** `Module/Utility/GitIgnore/`

matrix                                   # Matrix digital rain animation

```#### **[Disk Usage Analysis](Utility/README.md)\*\***Documentation:** [GitIgnore Utilities README](GitIgnore/README.md)- **`Get-GitIgnore`\*\* (Alias: `gi`):



## **Architecture & Design**Analyze disk usage and storage statistics.#### **[QRCode Generation](QRCode/README.md)** - _Description:_ Generates .gitignore content for specified technologies using the gitignore.io API.



### **Utility Structure:****Key Functions:** - _Usage:_ `gi node python` or `gi visualstudio -OutputPath .\.gitignore`



Each utility follows a consistent modular structure:-   `Get-DiskUsage` (alias: `du`) - Disk usage statistics with unit conversion



- **`.psd1` Manifest**: Module metadata, exported functions, and dependenciesGenerate QR codes directly from PowerShell using the qrcode.show API service.

- **`.psm1` Module**: PowerShell functions with comprehensive help documentation

- **`README.md`**: Detailed documentation with examples and use cases**Key Features:** Path analysis, multiple units, storage statistics, cross-platform compatibility

- **Consistent Patterns**: Standardized parameter names, error handling, and output formatting

**Location:** `Module/Utility/Utility/` - **`Get-GitIgnoreList`** (Alias: `gilist`):

### **Common Features:**

**Documentation:** [Disk Usage README](Utility/README.md)

- **Intuitive Aliases**: Short, memorable aliases for frequently used functions

- **Pipeline Support**: Full PowerShell pipeline integration where applicable**Key Functions:**

- **Cross-Platform**: Compatible with Windows PowerShell, PowerShell Core, Linux, and macOS

- **Error Handling**: Comprehensive error handling with meaningful messages### **Web & Network Tools**

- **Help Documentation**: Detailed help with examples using PowerShell's help system

- **API Integration**: Reliable integration with external services where needed-   `New-QRCode` (alias: `qrcode`) - Generate PNG QR codes - _Description:_ Lists all available gitignore templates with optional filtering and grid view support.



### **Integration Benefits:**#### **[Web Search Integration](WebSearch/README.md)**



- **Unified Experience**: All utilities work seamlessly within your PowerShell environment-   `New-QRCodeSVG` (alias: `qrsvg`) - Generate SVG QR codes - _Usage:_ `gilist` or `gilist -Filter python`

- **Enhanced Productivity**: Common tasks become simple one-liner commands

- **Consistent Interface**: Similar patterns and behavior across all utilitiesIntegrated web search functionality with multiple search engines.

- **Extended Functionality**: Enhanced capabilities beyond standard PowerShell cmdlets

-   `Save-QRCode` - Save QR codes to files

## **Troubleshooting**

**Key Functions:**

### **Utility Not Loading**

-   `Start-WebSearch` (alias: `web-search`, `ws`) - Interactive web search- `Test-QRCodeService` - Test API connectivity- **`New-GitIgnoreFile`** (Alias: `ginew`):

1. **Check Module Structure**: Verify utility directory exists and contains required files:

   ```powershell-   `Search-Google` (alias: `wsggl`) - Google search

   Get-ChildItem "Module/Utility/UtilityName/" | Select-Object Name

   ```-   `Search-DuckDuckGo` (alias: `wsddg`) - DuckDuckGo search**Key Features:** PNG/SVG generation, PowerShell pipeline support, interactive mode, file operations, web API integration - _Description:_ Creates a new .gitignore file with specified technology templates in the current directory.



2. **Validate Manifest**: Check `.psd1` manifest file syntax:-   `Search-GitHub` (alias: `wsgh`) - GitHub repository search

   ```powershell

   Test-ModuleManifest "Module/Utility/UtilityName/UtilityName.psd1"-   `Search-StackOverflow` (alias: `wsso`) - Stack Overflow search**Location:** `Module/Utility/QRCode/` - _Usage:_ `ginew node python` or `ginew visualstudio -Backup`

````

-   `Search-Wikipedia` (alias: `wswiki`) - Wikipedia search

3. **Test Import**: Verify module can be imported:

    ```powershell-   `Search-Reddit`(alias:`wsrdt`) - Reddit search**Documentation:** [QRCode Generation README](QRCode/README.md)

    Import-Module "Module/Utility/UtilityName/UtilityName.psd1" -Force -Verbose

    ```**Key Features:** Multiple search engines, cross-platform browser launching, URL encoding, interactive menu - **`Add-GitIgnoreContent`** (Alias: `giadd`):

### **API-Dependent Features\*\***Location:\*\* `Module/Utility/WebSearch/`

Some utilities depend on external APIs:**Documentation:** [Web Search README](WebSearch/README.md)### **Productivity & Convenience**

1. **Network Connectivity**: Ensure internet connection for web-based utilities## **Quick Start Examples** - _Description:_ Adds additional technology templates to an existing .gitignore file.

2. **Service Availability**: Test API connectivity:

    ```powershell### **System Administration:**#### **[Random Quote Generator](RandomQuote/README.md)** - _Usage:_ `giadd docker kubernetes`or`giadd macos -Path ./project`

    Test-GitIgnoreService # Test gitignore.io API

    Test-QRCodeService # Test qrcode.show API```powershellFetch inspirational and motivational quotes from online APIs.- **`Test-GitIgnoreService`** (Alias: `gitest`):

    ```

    ```

# Check system status

3. **Rate Limits**: Some APIs have rate limits - space out requests if needed

is-admin # Check administrator privileges**Key Functions:** - _Description:_ Tests connectivity to the gitignore.io API service to ensure it's accessible.

### **Common Solutions**

uptime # System uptime

`````powershell

# Refresh PowerShell profilecommand-exists git # Verify Git is available- `Get-RandomQuote` (alias: `quote`) - Fetch random quotes - _Usage:_ `gitest`

. $PROFILE

def Get-Process # Get command definition

# Force reimport Utility module

Import-Module Utility -Force**Key Features:** Multiple quote sources, inspirational content, API integration - **`New-QRCode`** (Alias: `qrcode`):



# Check loaded utility modules# Profile management

Get-Module | Where-Object { $_.Path -match "Utility" }

reload-profile # Reload PowerShell profile after changes**Location:** `Module/Utility/RandomQuote/`

# Get help for specific utilities

Get-Help Get-RandomQuote -Examples````

Get-Help Start-Countdown -Full

**Documentation:** [Random Quote README](RandomQuote/README.md) - _Description:_ Generates QR codes using the qrcode.show API service. Supports PNG format with various customization options.

# List all utility functions

Get-Command -Module Utility | Sort-Object Name### **Development Workflow:**

`````

    -   _Usage:_ `qrcode "Hello World"` or `New-QRCode -Text "https://example.com" -Size 300`

### **Performance Considerations**

```````powershell

1. **API Response Times**: Web-based utilities depend on external service response times

2. **Network Dependencies**: Internet-based features require active network connection# Base64 operations#### **[Weather Forecast](WeatherForecast/README.md)**

3. **File Operations**: File-based utilities performance depends on disk I/O speed

"Hello World" | e64                      # Encode to Base64

## **Getting Help**

"SGVsbG8gV29ybGQ=" | d64                 # Decode from Base64-   **`New-QRCodeSVG`** (Alias: `qrsvg`):

### **Command-Specific Help:**

ef64 "document.pdf"                      # Encode file to Base64

```powershell

# Get detailed help for any utility functionGet weather information and forecasts for any location worldwide.

Get-Help Test-Administrator -Full

Get-Help Get-WeatherForecast -Examples# GitIgnore management

Get-Help New-QRCode -Detailed

gitignore node python                    # Generate .gitignore content    -   _Description:_ Generates QR codes in SVG format using the qrcode.show API service. Ideal for scalable graphics.

# List all functions in Utility module

Get-Command -Module Utilitygilist -Filter python                    # List Python-related templates



# Get information about the Utility moduleginew visualstudio node                  # Create new .gitignore file**Key Functions:** - _Usage:_ `qrsvg "Hello World"` or `New-QRCodeSVG -Text "Contact Info" -Size 250`

Get-Module Utility | Format-List

```giadd docker kubernetes                  # Add to existing .gitignore



### **Interactive Help System:**-   `Get-WeatherForecast` (alias: `weather`) - Weather forecasts with customizable formats



```powershell# QRCode generation

# Use the profile's integrated help system

Show-ProfileHelp -Section 'Utility'     # Overview of all utilitiesqrcode "Hello World"                     # Generate PNG QR code-   **`Save-QRCode`**:

profile-help -Section 'Base64'          # Specific utility documentation

```qrsvg "https://github.com"              # Generate SVG QR code



### **Examples and Use Cases:**Save-QRCode -Text "Contact" -FilePath "contact.png"**Key Features:** Location-based weather, multiple formats, Moon phases, multilingual support, weather glyphs



Each utility includes comprehensive examples:````



```powershell**Location:** `Module/Utility/WeatherForecast/` - _Description:_ Saves QR code output to a file with proper format detection (PNG/SVG).

# View examples for specific utilities

Get-Help ConvertTo-Base64 -Examples### **Productivity & Information:**

Get-Help Get-GitIgnore -Examples

Get-Help Start-WebSearch -Examples**Documentation:** [Weather Forecast README](WeatherForecast/README.md) - _Usage:_ `Save-QRCode -Text "Hello World" -FilePath "./qrcode.png"`

Get-Help New-QRCode -Examples

``````powershell



## **Contributing**# Get information and inspiration#### **[Prayer Times](PrayerTimes/README.md)**- **`Test-QRCodeService`**:



The Utility module welcomes contributions that enhance the PowerShell experience with general-purpose functionality.quote                                    # Random inspirational quote



### **Ways to Contribute:**weather London                           # Weather forecast for London    -   _Description:_ Tests connectivity to the qrcode.show API service to ensure it's accessible.



- **Add New Utilities**: Create utilities for common tasks not yet coveredprayer -City "Mecca" -Country "Saudi Arabia"  # Prayer times

- **Enhance Existing Utilities**: Add functionality, improve performance, fix bugs

- **Improve Documentation**: Update README files, add examples, improve help textGet accurate Islamic prayer times for any city and country. - _Usage:_ `Test-QRCodeService`

- **Testing & Quality**: Test utilities across different platforms and scenarios

- **API Integrations**: Add integrations with useful web services and APIs# Timing utilities



### **Utility Development Guidelines:**countdown -Duration "25m" -Title "Pomodoro"    # 25-minute countdown**Key Functions:**[Back to Modules](../../README.md#modules)



1. **General Purpose**: Utilities should be broadly applicable, not tool-specificstopwatch -Title "Task Timer"                  # Start stopwatch

2. **Consistent Naming**: Follow PowerShell verb-noun naming conventions

3. **Comprehensive Help**: Include detailed help documentation with exampleswallclock -TimeZone "Pacific Standard Time"   # Display clock-   `Get-PrayerTimes` (alias: `prayer`) - Prayer times with multiple calculation methods

4. **Cross-Platform**: Ensure compatibility across Windows, Linux, and macOS

5. **Error Handling**: Implement robust error handling with clear messages```

6. **Pipeline Support**: Support PowerShell pipeline where logical

## **Contribution:**

### **Future Utility Ideas:**

### **Web & Search:**

Potential utilities that would benefit the community:

**Key Features:** Global city coverage, multiple calculation methods, time format options, accurate prayer schedules

- **Password Generation**: Secure password generation utilities

- **Hash Calculation**: File and string hashing utilities (MD5, SHA256, etc.)````powershell

- **Color Management**: Terminal color and theme utilities

- **System Information**: Extended system information and diagnostics# Web searches**Location:** `Module/Utility/PrayerTimes/` New utility functions that can benefit a wide range of PowerShell users are always welcome. Please ensure they are well-documented and follow the project's contribution guidelines. See the main [Contributing Guidelines](../../README.md#contributing).

- **Clipboard Integration**: Enhanced clipboard management utilities

ws                                       # Interactive search menu

[Back to Modules](../../README.md#modules)

ws google "PowerShell tutorial"          # Direct Google search**Documentation:** [Prayer Times README](PrayerTimes/README.md)

## **License**

wsgh "awesome-powershell"                # Search GitHub repositories

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
wsso "powershell arrays"                 # Search Stack Overflow## **License:**

wswiki "PowerShell"                      # Search Wikipedia

```#### **[Timing Utilities](Utility/README.md)**



### **Fun & Entertainment:**This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.



```powershellEssential timing and productivity utilities for time management.

# Entertainment

matrix                                   # Matrix digital rain animation**Key Functions:**

du                                       # Disk usage analysis

```-   `Start-Countdown` (alias: `countdown`) - Countdown timers with custom titles

-   `Start-Stopwatch` (alias: `stopwatch`) - Stopwatch functionality

## **Architecture & Design**-   `Get-WallClock` (alias: `wallclock`) - Large display clock with timezone support



### **Utility Structure:****Key Features:** Flexible timing, timezone support, visual displays, productivity tracking

**Location:** `Module/Utility/Utility/`

Each utility follows a consistent modular structure:**Documentation:** [Timing Utilities README](Utility/README.md)



-   **`.psd1` Manifest**: Module metadata, exported functions, and dependencies### **Data & File Utilities**

-   **`.psm1` Module**: PowerShell functions with comprehensive help documentation

-   **`README.md`**: Detailed documentation with examples and use cases#### **[Matrix Animation](Matrix/README.md)**

-   **Consistent Patterns**: Standardized parameter names, error handling, and output formatting

Digital rain matrix animation for console entertainment.

### **Common Features:**

**Key Functions:**

-   **Intuitive Aliases**: Short, memorable aliases for frequently used functions

-   **Pipeline Support**: Full PowerShell pipeline integration where applicable-   `Start-Matrix` (alias: `matrix`) - Matrix rain animation with customizable speed

-   **Cross-Platform**: Compatible with Windows PowerShell, PowerShell Core, Linux, and macOS

-   **Error Handling**: Comprehensive error handling with meaningful messages**Key Features:** Console animation, configurable speed, entertainment utility

-   **Help Documentation**: Detailed help with examples using PowerShell's help system**Location:** `Module/Utility/Matrix/`

-   **API Integration**: Reliable integration with external services where needed**Documentation:** [Matrix Animation README](Matrix/README.md)



### **Integration Benefits:**#### **[Disk Usage Analysis](Utility/README.md)**



-   **Unified Experience**: All utilities work seamlessly within your PowerShell environmentAnalyze disk usage and storage statistics.

-   **Enhanced Productivity**: Common tasks become simple one-liner commands

-   **Consistent Interface**: Similar patterns and behavior across all utilities**Key Functions:**

-   **Extended Functionality**: Enhanced capabilities beyond standard PowerShell cmdlets

-   `Get-DiskUsage` (alias: `du`) - Disk usage statistics with unit conversion

## **Troubleshooting**

**Key Features:** Path analysis, multiple units, storage statistics, cross-platform compatibility

### **Utility Not Loading****Location:** `Module/Utility/Utility/`

**Documentation:** [Disk Usage README](Utility/README.md)

1. **Check Module Structure**: Verify utility directory exists and contains required files:

   ```powershell### **Web & Network Tools**

   Get-ChildItem "Module/Utility/UtilityName/" | Select-Object Name

   ```#### **[Web Search Integration](WebSearch/README.md)**



2. **Validate Manifest**: Check `.psd1` manifest file syntax:Integrated web search functionality with multiple search engines.

   ```powershell

   Test-ModuleManifest "Module/Utility/UtilityName/UtilityName.psd1"**Key Functions:**

```````

-   `Start-WebSearch` (alias: `web-search`, `ws`) - Interactive web search

3. **Test Import**: Verify module can be imported:- `Search-Google` (alias: `wsggl`) - Google search

    ```powershell-   `Search-DuckDuckGo`(alias:`wsddg`) - DuckDuckGo search

    Import-Module "Module/Utility/UtilityName/UtilityName.psd1" -Force -Verbose- `Search-GitHub` (alias: `wsgh`) - GitHub repository search

    ```-   `Search-StackOverflow`(alias:`wsso`) - Stack Overflow search

-   `Search-Wikipedia` (alias: `wswiki`) - Wikipedia search

### **API-Dependent Features**- `Search-Reddit` (alias: `wsrdt`) - Reddit search

Some utilities depend on external APIs:**Key Features:** Multiple search engines, cross-platform browser launching, URL encoding, interactive menu

**Location:** `Module/Utility/WebSearch/`

1. **Network Connectivity**: Ensure internet connection for web-based utilities**Documentation:** [Web Search README](WebSearch/README.md)

2. **Service Availability**: Test API connectivity:

    ```powershell## **Quick Start Examples**

    Test-GitIgnoreService                 # Test gitignore.io API

    Test-QRCodeService                   # Test qrcode.show API### **System Administration:**

    ```

````powershell

3. **Rate Limits**: Some APIs have rate limits - space out requests if needed# Check system status

is-admin                                 # Check administrator privileges

### **Common Solutions**uptime                                   # System uptime

command-exists git                       # Verify Git is available

```powershelldef Get-Process                          # Get command definition

# Refresh PowerShell profile

. $PROFILE# Profile management

reload-profile                           # Reload PowerShell profile after changes

# Force reimport Utility module```

Import-Module Utility -Force

### **Development Workflow:**

# Check loaded utility modules

Get-Module | Where-Object { $_.Path -match "Utility" }```powershell

# Base64 operations

# Get help for specific utilities"Hello World" | e64                      # Encode to Base64

Get-Help Get-RandomQuote -Examples"SGVsbG8gV29ybGQ=" | d64                 # Decode from Base64

Get-Help Start-Countdown -Fullef64 "document.pdf"                      # Encode file to Base64



# List all utility functions# GitIgnore management

Get-Command -Module Utility | Sort-Object Namegitignore node python                    # Generate .gitignore content

```gilist -Filter python                    # List Python-related templates

ginew visualstudio node                  # Create new .gitignore file

### **Performance Considerations**giadd docker kubernetes                  # Add to existing .gitignore



1. **API Response Times**: Web-based utilities depend on external service response times# QRCode generation

2. **Network Dependencies**: Internet-based features require active network connectionqrcode "Hello World"                     # Generate PNG QR code

3. **File Operations**: File-based utilities performance depends on disk I/O speedqrsvg "https://github.com"              # Generate SVG QR code

Save-QRCode -Text "Contact" -FilePath "contact.png"

## **Getting Help**```



### **Command-Specific Help:**### **Productivity & Information:**



```powershell```powershell

# Get detailed help for any utility function# Get information and inspiration

Get-Help Test-Administrator -Fullquote                                    # Random inspirational quote

Get-Help Get-WeatherForecast -Examplesweather London                           # Weather forecast for London

Get-Help New-QRCode -Detailedprayer -City "Mecca" -Country "Saudi Arabia"  # Prayer times



# List all functions in Utility module# Timing utilities

Get-Command -Module Utilitycountdown -Duration "25m" -Title "Pomodoro"    # 25-minute countdown

stopwatch -Title "Task Timer"                  # Start stopwatch

# Get information about the Utility modulewallclock -TimeZone "Pacific Standard Time"   # Display clock

Get-Module Utility | Format-List```

````

### **Web & Search:**

### **Interactive Help System:**

````powershell

```powershell# Web searches

# Use the profile's integrated help systemws                                       # Interactive search menu

Show-ProfileHelp -Section 'Utility'     # Overview of all utilitiesws google "PowerShell tutorial"          # Direct Google search

profile-help -Section 'Base64'          # Specific utility documentationwsgh "awesome-powershell"                # Search GitHub repositories

```wsso "powershell arrays"                 # Search Stack Overflow

wswiki "PowerShell"                      # Search Wikipedia

### **Examples and Use Cases:**```



Each utility includes comprehensive examples:### **Fun & Entertainment:**



```powershell```powershell

# View examples for specific utilities# Entertainment

Get-Help ConvertTo-Base64 -Examplesmatrix                                   # Matrix digital rain animation

Get-Help Get-GitIgnore -Examples  du                                       # Disk usage analysis

Get-Help Start-WebSearch -Examples```

Get-Help New-QRCode -Examples

```## **Architecture & Design**



## **Contributing**### **Utility Structure:**



The Utility module welcomes contributions that enhance the PowerShell experience with general-purpose functionality.

### **Ways to Contribute:**

- **Add New Utilities**: Create utilities for common tasks not yet covered
- **Enhance Existing Utilities**: Add functionality, improve performance, fix bugs
- **Improve Documentation**: Update README files, add examples, improve help text
- **Testing & Quality**: Test utilities across different platforms and scenarios
- **API Integrations**: Add integrations with useful web services and APIs

### **Utility Development Guidelines:**

1. **General Purpose**: Utilities should be broadly applicable, not tool-specific
2. **Consistent Naming**: Follow PowerShell verb-noun naming conventions
3. **Comprehensive Help**: Include detailed help documentation with examples
4. **Cross-Platform**: Ensure compatibility across Windows, Linux, and macOS
5. **Error Handling**: Implement robust error handling with clear messages
6. **Pipeline Support**: Support PowerShell pipeline where logical

### **Future Utility Ideas:**

Potential utilities that would benefit the community:

- **Password Generation**: Secure password generation utilities
- **Hash Calculation**: File and string hashing utilities (MD5, SHA256, etc.)
- **Color Management**: Terminal color and theme utilities
- **System Information**: Extended system information and diagnostics
- **Clipboard Integration**: Enhanced clipboard management utilities



[Back to Modules](../../README.md#modules)    ```powershell

    Get-ChildItem "Module/Utility/UtilityName/" | Select-Object Name

## **License**    ```



This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.2. **Validate Manifest**: Check `.psd1` manifest file syntax:

    ```powershell
    Test-ModuleManifest "Module/Utility/UtilityName/UtilityName.psd1"
    ```

3. **Test Import**: Verify module can be imported:
    ```powershell
    Import-Module "Module/Utility/UtilityName/UtilityName.psd1" -Force -Verbose
    ```

### **API-Dependent Features**

Some utilities depend on external APIs:

1. **Network Connectivity**: Ensure internet connection for web-based utilities
2. **Service Availability**: Test API connectivity:

    ```powershell
    Test-GitIgnoreService                 # Test gitignore.io API
    Test-QRCodeService                   # Test qrcode.show API
    ```

3. **Rate Limits**: Some APIs have rate limits - space out requests if needed

### **Common Solutions**

```powershell
# Refresh PowerShell profile
. $PROFILE

# Force reimport Utility module
Import-Module Utility -Force

# Check loaded utility modules
Get-Module | Where-Object { $_.Path -match "Utility" }

# Get help for specific utilities
Get-Help Get-RandomQuote -Examples
Get-Help Start-Countdown -Full

# List all utility functions
Get-Command -Module Utility | Sort-Object Name
````

### **Performance Considerations**

1. **API Response Times**: Web-based utilities depend on external service response times
2. **Network Dependencies**: Internet-based features require active network connection
3. **File Operations**: File-based utilities performance depends on disk I/O speed

## **Getting Help**

### **Command-Specific Help:**

```powershell
# Get detailed help for any utility function
Get-Help Test-Administrator -Full
Get-Help Get-WeatherForecast -Examples
Get-Help New-QRCode -Detailed

# List all functions in Utility module
Get-Command -Module Utility

# Get information about the Utility module
Get-Module Utility | Format-List
```

### **Interactive Help System:**

```powershell
# Use the profile's integrated help system
Show-ProfileHelp -Section 'Utility'     # Overview of all utilities
profile-help -Section 'Base64'          # Specific utility documentation
```

### **Examples and Use Cases:**

Each utility includes comprehensive examples:

```powershell
# View examples for specific utilities
Get-Help ConvertTo-Base64 -Examples
Get-Help Get-GitIgnore -Examples
Get-Help Start-WebSearch -Examples
Get-Help New-QRCode -Examples
```

## **Contributing**

The Utility module welcomes contributions that enhance the PowerShell experience with general-purpose functionality.

### **Ways to Contribute:**

-   **Add New Utilities**: Create utilities for common tasks not yet covered
-   **Enhance Existing Utilities**: Add functionality, improve performance, fix bugs
-   **Improve Documentation**: Update README files, add examples, improve help text
-   **Testing & Quality**: Test utilities across different platforms and scenarios
-   **API Integrations**: Add integrations with useful web services and APIs

### **Utility Development Guidelines:**

1. **General Purpose**: Utilities should be broadly applicable, not tool-specific
2. **Consistent Naming**: Follow PowerShell verb-noun naming conventions
3. **Comprehensive Help**: Include detailed help documentation with examples
4. **Cross-Platform**: Ensure compatibility across Windows, Linux, and macOS
5. **Error Handling**: Implement robust error handling with clear messages
6. **Pipeline Support**: Support PowerShell pipeline where logical

### **Future Utility Ideas:**

Potential utilities that would benefit the community:

-   **Password Generation**: Secure password generation utilities
-   **Hash Calculation**: File and string hashing utilities (MD5, SHA256, etc.)
-   **Color Management**: Terminal color and theme utilities
-   **System Information**: Extended system information and diagnostics
-   **Clipboard Integration**: Enhanced clipboard management utilities

[Back to Modules](../../README.md#modules)

## **License**

This project is licensed under the MIT License. See the [LICENSE](../../LICENSE) file for details.
