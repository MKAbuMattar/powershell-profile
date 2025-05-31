<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Utility\README.md -->

# Utility Module

## **Module Overview:**

The Utility module is a versatile collection of general-purpose functions designed to enhance the PowerShell command-line experience and provide helpful tools for everyday tasks. It ranges from system checks like administrator privileges and command existence to practical tools like timers, weather forecasts, and system information display.

## **Key Features:**

- System status checks (admin rights, command availability, uptime).
- Profile and command introspection.
- Fun and informative additions (random quotes, weather, prayer times, matrix animation).
- Productivity tools (countdown timer, stopwatch, wall clock).
- System resource information (disk usage).

## **Functions:**

- **`Test-Administrator`** (Alias: `is-admin`):

  - _Description:_ Checks if the current PowerShell session is running with administrator privileges.
  - _Usage:_ `is-admin` (Returns `$true` or `$false`)

- **`Test-CommandExists`** (Alias: `command-exists`):

  - _Description:_ Verifies if a specified command (cmdlet, function, alias, or executable) exists in the current session or path.
  - _Usage:_ `command-exists "git"`

- **`Invoke-ReloadProfile`** (Alias: `reload-profile`):

  - _Description:_ Reloads the current PowerShell profile, applying any changes made since it was last loaded.
  - _Usage:_ `reload-profile`

- **`Get-Uptime`** (Alias: `uptime`):

  - _Description:_ Retrieves and displays the system uptime in a human-readable format (e.g., "3 days, 5 hours, 12 minutes").
  - _Usage:_ `uptime`

- **`Get-CommandDefinition`** (Alias: `def`):

  - _Description:_ Retrieves the definition or source code of a given PowerShell command (function, alias, or cmdlet).
  - _Usage:_ `def Get-ChildItem`

- **`Get-RandomQuote`** (Alias: `quote`):

  - _Description:_ Fetches and displays a random quote, typically from an online API.
  - _Usage:_ `quote`

- **`Get-WeatherForecast`** (Alias: `weather`):

  - _Description:_ Retrieves and displays the current weather forecast for a specified location using an online weather service.
  - _Usage:_ `weather -Location "London"` or `weather Amman`

- **`Start-Countdown`** (Alias: `countdown`):

  - _Description:_ Starts a countdown timer for a specified duration or until a specific time, displaying the remaining time in the console.
  - _Usage Examples:_
    - `countdown -Duration "30m" -Title "Meeting starts in:"`
    - `countdown -Until "17:00" -Title "End of Workday"`

- **`Start-Stopwatch`** (Alias: `stopwatch`):

  - _Description:_ Starts a stopwatch timer. Pressing Enter typically stops it and displays the elapsed time.
  - _Usage:_ `stopwatch -Title "Task Timer"`

- **`Get-WallClock`** (Alias: `clock`):

  - _Description:_ Displays the current time, optionally for a specified timezone.
  - _Usage:_ `clock -TimeZone "Pacific Standard Time"` or `wallclock -TimeZone "Europe/Berlin"`

- **`Get-PrayerTimes`** (Alias: `prayer`):

  - _Description:_ Retrieves and displays Islamic prayer times for a specified city and country, usually by querying an online API.
  - _Usage:_ `prayer -City "Mecca" -Country "Saudi Arabia"`

- **`Start-Matrix`** (Alias: `matrix`):

  - _Description:_ Displays a "Matrix" digital rain-like animation in the PowerShell console.
  - _Usage:_ `matrix`

- **`Get-DiskUsage`** (Alias: `du`):
  - _Description:_ Retrieves and displays disk usage statistics for the current drive or a specified path.
  - _Usage:_ `du` or `du "C:\Users"`

[Back to Modules](../../README.md#modules)

**Contribution:**
New utility functions that can benefit a wide range of PowerShell users are always welcome. Please ensure they are well-documented and follow the project's contribution guidelines. See the main [Contributing Guidelines](../../README.md#contributing).
