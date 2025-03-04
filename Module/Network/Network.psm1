<#
.SYNOPSIS
  Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.

.DESCRIPTION
  This function retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.

.PARAMETER Local
  This switch retrieves the local IP address. Default is $true.

.PARAMETER IPv4
  This switch retrieves the public IPv4 address. Default is $true.

.PARAMETER IPv6
  This switch retrieves the public IPv6 address. Default is $false.

.PARAMETER ComputerName
  The name of the computer to retrieve the IP address from. Default is the local computer name.

.OUTPUTS
  The IP address of the local machine, and public IPv4 and IPv6 addresses.

.EXAMPLE
  Get-MyIPAddress -Local -IPv4 -IPv6
  Retrieves the IP address of the local machine, and public IPv4 and IPv6 addresses.
  Get-MyIPAddress -Local
  Retrieves the IP address of the local machine.
  Get-MyIPAddress -IPv4
  Retrieves the public IPv4 address.
  Get-MyIPAddress -IPv6
  Retrieves the public IPv6 address.

.NOTES
  This function is used to retrieve the IP address of the local machine, and public IPv4 and IPv6 addresses.
#>
function Get-MyIPAddress {
  [CmdletBinding()]
  [Alias("my-ip")]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [switch]$Local = $false,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [switch]$IPv4 = $false,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [switch]$IPv6 = $false,

    [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$ComputerName = $env:COMPUTERNAME
  )

  $IPAddress = @()

  try {
    if ($Local) {
      $LocalAddress = [System.Net.Dns]::GetHostAddresses($ComputerName) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString
      Write-Output "Local: $LocalAddress"
    }

    if ($IPv4) {
      $IPv4Address = (Invoke-RestMethod -Uri "http://ipv4.icanhazip.com").Trim()
      Write-Output "IPv4: $IPv4Address"
    }

    if ($IPv6) {
      $IPv6Address = (Invoke-RestMethod -Uri "http://ipv6.icanhazip.com").Trim()
      Write-Output "IPv6: $IPv6Address"
    }
  }
  catch {
    Write-LogMessage -Message "Failed to retrieve IP address: $_" -Level "ERROR"
  }
}

<#
.SYNOPSIS
  Flushes the DNS cache.

.DESCRIPTION
  This function flushes the DNS cache.

.PARAMETER None
  This function does not accept any parameters.

.OUTPUTS
  The DNS cache has been flushed.

.EXAMPLE
  Clear-FlushDNS
  Flushes the DNS cache.

.NOTES
  This function is used to flush the DNS cache.
#>
function Clear-FlushDNS {
  [CmdletBinding()]
  [Alias("flush-dns")]
  param (

  )

  try {
    Clear-DnsClientCache
    Write-LogMessage -Message "DNS cache has been flushed"
  }
  catch {
    Write-LogMessage -Message "Failed to flush DNS: $_" -Level "ERROR"
  }
}
