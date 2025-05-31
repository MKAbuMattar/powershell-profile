<!-- filepath: c:\Users\MKAbuMattar\Work\powershell-profile\Module\Network\README.md -->

# Network Module

## **Module Overview:**

The Network module provides essential functions for network-related tasks directly within PowerShell. It allows users to quickly retrieve local and public IP addresses and manage the system's DNS cache. These utilities are designed for convenience and quick diagnostics of network configurations.

## **Key Features:**

- Retrieval of local machine IP addresses.
- Fetching public IPv4 and IPv6 addresses.
- DNS cache flushing for troubleshooting network resolution issues.

## **Functions:**

- **`Get-MyIPAddress`** (Alias: `my-ip`):

  - _Description:_ Retrieves various IP addresses associated with the machine. It can fetch the local IP address(es), and also query external services to find the public IPv4 and IPv6 addresses.
  - _Parameters:_
    - `-Local`: If specified, returns the local IP address(es) of the machine.
    - `-IPv4`: If specified, returns the public IPv4 address.
    - `-IPv6`: If specified, returns the public IPv6 address.
    - If no parameters are specified, it might return a combination or prompt for selection.
  - _Usage Examples:_
    - `Get-MyIPAddress` (Could default to all or prompt)
    - `my-ip -Local` (Shows only local IP address(es))
    - `Get-MyIPAddress -IPv4 -IPv6` (Shows public IPv4 and IPv6 addresses)
    - `my-ip -Local -IPv4` (Shows local and public IPv4)
  - _Details:_ Uses external services like `ipify.org` or `icanhazip.com` for public IP lookups. Ensure internet connectivity for public IP retrieval.

- **`Clear-FlushDNS`** (Alias: `flush-dns`):
  - _Description:_ Clears and flushes the local DNS resolver cache. This can be useful when troubleshooting DNS resolution problems or after DNS changes have been made that are not yet reflected locally.
  - _Usage:_ `flush-dns`
  - _Details:_ This command typically requires administrator privileges to execute successfully. It is equivalent to `ipconfig /flushdns` on Windows.

[Back to Modules](../../README.md#modules)

**Contribution:**
Contributions such as adding more network diagnostic tools (e.g., ping wrappers, port scanners, traceroute functions) or improving existing functions are welcome. Please adhere to the main [Contributing Guidelines](../../README.md#contributing).
