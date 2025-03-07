<#
.SYNOPSIS
  Retrieves the system information.

.DESCRIPTION
  This function retrieves information about the system, including the operating system, architecture, and processor details.

.PARAMETER None
  This function does not accept any parameters.

.INPUTS
  This function does not accept any input.

.OUTPUTS
  The system information.

.NOTES
  This function is useful for quickly retrieving information about the system.

.EXAMPLE
  Get-SystemInfo
  Retrieves information about the system.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-SystemInfo {
  [CmdletBinding()]
  [Alias("sysinfo")]
  [OutputType([PSCustomObject])]
  param (
    # This function does not accept any parameters
  )

  try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $processor = Get-CimInstance -ClassName Win32_Processor
    $architecture = Get-CimInstance -ClassName Win32_ComputerSystem

    [PSCustomObject]@{
      "Operating System" = $os.Caption
      "Version"          = $os.Version
      "Architecture"     = $architecture.SystemType
      "Processor"        = $processor.Name
      "Cores"            = $processor.NumberOfCores
      "Threads"          = $processor.NumberOfLogicalProcessors
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve system information." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Retrieves a list of all running processes.

.DESCRIPTION
  This function retrieves information about all running processes on the system. It provides details such as the process name, ID, CPU usage, and memory usage.

.PARAMETER Name
  Specifies the name of a specific process to retrieve information for. If not provided, information for all processes is retrieved.

.INPUTS
  Name: (Optional) The name of a specific process to retrieve information for.

.OUTPUTS
  The process information for all running processes.

.NOTES
  This function is useful for retrieving information about running processes on the system.

.EXAMPLE
  Get-AllProcesses
  Retrieves information about all running processes.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-AllProcesses {
  [CmdletBinding()]
  [Alias("pall")]
  [OutputType([System.Diagnostics.Process[]])]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name
  )

  try {
    if ($Name) {
      Get-Process $Name -ErrorAction Stop
    }
    else {
      Get-Process
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve process information." -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Finds a process by name.

.DESCRIPTION
  This function searches for a process by its name. It retrieves information about the specified process, if found.

.PARAMETER Name
  Specifies the name of the process to find.

.INPUTS
  Name: (Required) The name of the process to find.

.OUTPUTS
  The process information if found.

.NOTES
  This function is useful for quickly finding information about a process by its name.

.EXAMPLE
  Get-ProcessByName "process"
  Retrieves information about the process named "process".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-ProcessByName {
  [CmdletBinding()]
  [Alias("pgrep")]
  [OutputType([System.Diagnostics.Process[]])]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name
  )

  try {
    Get-Process $name -ErrorAction Stop
  }
  catch {
    Write-Warning "No process with the name '$Name' found."
  }
}

<#
.SYNOPSIS
  Finds a process by port.

.DESCRIPTION
  This function searches for a process using a specific port. It retrieves information about the process using the specified port, if found.

.PARAMETER Port
  Specifies the port number to search for.

.INPUTS
  Port: (Required) The port number to search for.

.OUTPUTS
  The process information if found.

.NOTES
  This function is useful for quickly finding information about a process using a specific port.

.EXAMPLE
  Get-ProcessByPort 80
  Retrieves information about the process using port 80.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Get-ProcessByPort {
  [CmdletBinding()]
  [Alias("portgrep")]
  [OutputType([System.Diagnostics.Process[]])]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("p")]
    [int]$Port
  )

  try {
    Get-NetTCPConnection -LocalPort $Port -ErrorAction Stop
  }
  catch {
    Write-Warning "No process using port '$Port' found."
  }
}

<#
.SYNOPSIS
  Terminates a process by name.

.DESCRIPTION
  This function terminates a process by its name. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER Name
  Specifies the name of the process to terminate.

.INPUTS
  Name: (Required) The name of the process to terminate.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for quickly terminating a process by its name.

.EXAMPLE
  Stop-ProcessByName "process"
  Terminates the process named "process".

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Stop-ProcessByName {
  [CmdletBinding()]
  [Alias("pkill")]
  [OutputType([void])]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("n")]
    [string]$Name
  )

  $process = Get-Process $Name -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-LogMessage -Message "No process with the name '$Name' found." -Level "WARNING"
  }
}

<#
.SYNOPSIS
  Terminates a process by port.

.DESCRIPTION
  This function terminates a process using a specific port. It is useful for stopping processes that may be unresponsive or causing issues.

.PARAMETER Port
  Specifies the port number of the process to terminate.

.INPUTS
  Port: (Required) The port number of the process to terminate.

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for quickly terminating a process using a specific port.

.EXAMPLE
  Stop-ProcessByPort 80
  Terminates the process using port 80.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Stop-ProcessByPort {
  [CmdletBinding()]
  [Alias("portkill")]
  [OutputType([void])]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias("p")]
    [int]$Port
  )

  $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
  if ($process) {
    $process | Stop-Process -Force
  }
  else {
    Write-LogMessage -Message "No process using port '$Port' found." -Level "WARNING"
  }
}

<#
.SYNOPSIS
  Clears windows cache, temp files, and internet explorer cache.

.DESCRIPTION
  This function clears the Windows cache, temporary files, and Internet Explorer cache. It is useful for freeing up disk space and improving system performance.

.PARAMETER Type
  Specifies the type of cache to clear. The available options are "All", "Prefetch", "WindowsTemp", "UserTemp", and "IECache". The default value is "All".

.INPUTS
  Type: (Optional) The type of cache to clear. The default value is "All".

.OUTPUTS
  This function does not return any output.

.NOTES
  This function is useful for clearing various caches on the system to free up disk space and improve performance.

.EXAMPLE
  Clear-Cache
  Clears all caches (Windows Prefetch, Windows Temp, User Temp, and Internet Explorer Cache).

.EXAMPLE
  Clear-Cache -Type "Prefetch"
  Clears the Windows Prefetch cache.

.EXAMPLE
  Clear-Cache -Type "WindowsTemp"
  Clears the Windows Temp cache.

.EXAMPLE
  Clear-Cache -Type "UserTemp"
  Clears the User Temp cache.

.EXAMPLE
  Clear-Cache -Type "IECache"
  Clears the Internet Explorer Cache.

.LINK
  https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
#>
function Invoke-ClearCache {
  [CmdletBinding()]
  [Alias("clear-cache")]
  [OutputType([void])]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateSet("All", "Prefetch", "WindowsTemp", "UserTemp", "IECache")]
    [Alias("c")]
    [string]$Type = "All"
  )

  switch ($Type) {
    "All" {
      Write-LogMessage "Clearing Windows Prefetch..."
      Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

      Write-LogMessage "Clearing Windows Temp..."
      Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

      Write-LogMessage "Clearing User Temp..."
      Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

      Write-LogMessage "Clearing Internet Explorer Cache..."
      Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    "Prefetch" {
      Write-LogMessage "Clearing Windows Prefetch..."
      Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue
    }
    "WindowsTemp" {
      Write-LogMessage "Clearing Windows Temp..."
      Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    "UserTemp" {
      Write-LogMessage "Clearing User Temp..."
      Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    "IECache" {
      Write-LogMessage "Clearing Internet Explorer Cache..."
      Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    default {
      Write-LogMessage "Invalid cache type: $Type" -Level "ERROR"
    }
  }
}
