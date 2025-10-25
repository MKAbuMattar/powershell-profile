#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Network Utility
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
#       This module provides network-related utility functions including IP address retrieval
#       and DNS cache flushing.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
Network Utility CLI

Provides network operations including IP address retrieval and DNS cache management.

Usage:
```bash
python network.py [COMMAND] [OPTIONS]
```
"""

import sys
import socket
import argparse
import subprocess
import platform
from urllib import request, error
from typing import Optional


# ANSI Colors
class Colors:
    """ANSI color codes for terminal output"""
    RESET = "\033[0m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    CYAN = "\033[96m"
    MAGENTA = "\033[95m"
    BLUE = "\033[94m"
    WHITE = "\033[97m"
    GRAY = "\033[90m"
    BOLD = "\033[1m"

    # Background colors
    BG_GREEN = "\033[102m"
    BG_YELLOW = "\033[103m"
    BG_CYAN = "\033[106m"
    BG_WHITE = "\033[107m"
    BG_DARK_GRAY = "\033[100m"

    # Foreground for backgrounds
    BLACK = "\033[30m"

    @staticmethod
    def success(text: str) -> str:
        return f"{Colors.GREEN}{text}{Colors.RESET}"

    @staticmethod
    def warning(text: str) -> str:
        return f"{Colors.YELLOW}{text}{Colors.RESET}"

    @staticmethod
    def error(text: str) -> str:
        return f"{Colors.RED}{text}{Colors.RESET}"

    @staticmethod
    def info(text: str) -> str:
        return f"{Colors.CYAN}{text}{Colors.RESET}"

    @staticmethod
    def highlight(text: str) -> str:
        return f"{Colors.MAGENTA}{text}{Colors.RESET}"


def get_local_ip(hostname: Optional[str] = None) -> Optional[str]:
    """
    Get the local IP address

    Args:
        hostname: Optional hostname to resolve (defaults to local hostname)

    Returns:
        Local IP address as string, or None if failed
    """
    try:
        if hostname is None:
            hostname = socket.gethostname()

        # Get all addresses and filter for IPv4
        addresses = socket.getaddrinfo(hostname, None, socket.AF_INET)
        if addresses:
            # Return the first IPv4 address
            return addresses[0][4][0]
        return None
    except Exception as e:
        print(Colors.error(f"[!] Error getting local IP: {e}"), file=sys.stderr)
        return None


def get_public_ipv4() -> Optional[str]:
    """
    Get the public IPv4 address

    Returns:
        Public IPv4 address as string, or None if failed
    """
    services = [
        "http://ipv4.icanhazip.com",
        "http://api.ipify.org",
        "http://ifconfig.me/ip",
        "http://checkip.amazonaws.com"
    ]

    for service in services:
        try:
            with request.urlopen(service, timeout=5) as response:
                ip = response.read().decode('utf-8').strip()
                if ip:
                    return ip
        except Exception:
            continue

    print(Colors.error("[!] Error: Unable to retrieve public IPv4 address"), file=sys.stderr)
    return None


def get_public_ipv6() -> Optional[str]:
    """
    Get the public IPv6 address

    Returns:
        Public IPv6 address as string, or None if failed
    """
    services = [
        "http://ipv6.icanhazip.com",
        "http://api6.ipify.org",
        "http://ifconfig.co"
    ]

    for service in services:
        try:
            with request.urlopen(service, timeout=5) as response:
                ip = response.read().decode('utf-8').strip()
                if ip and ':' in ip:  # IPv6 addresses contain colons
                    return ip
        except Exception:
            continue

    print(Colors.error("[!] Error: Unable to retrieve public IPv6 address"), file=sys.stderr)
    return None


def get_ip_address(local: bool = True, ipv4: bool = False, ipv6: bool = False, hostname: Optional[str] = None):
    """
    Display IP address information in a table format

    Args:
        local: Show local IP address
        ipv4: Show public IPv4 address
        ipv6: Show public IPv6 address
        hostname: Optional hostname for local IP lookup
    """
    # Collect IP information
    ip_data = []

    if local:
        local_ip = get_local_ip(hostname)
        if local_ip:
            ip_data.append(("Local IP", local_ip, Colors.CYAN))
        else:
            ip_data.append(("Local IP", "Unable to retrieve", Colors.RED))

    if ipv4:
        ipv4_addr = get_public_ipv4()
        if ipv4_addr:
            ip_data.append(("Public IPv4", ipv4_addr, Colors.GREEN))
        else:
            ip_data.append(("Public IPv4", "Unable to retrieve", Colors.RED))

    if ipv6:
        ipv6_addr = get_public_ipv6()
        if ipv6_addr:
            ip_data.append(("Public IPv6", ipv6_addr, Colors.GREEN))
        else:
            ip_data.append(("Public IPv6", "Unable to retrieve", Colors.RED))

    if not ip_data:
        print(Colors.warning("[!] No IP address options selected. Use --local, --ipv4, or --ipv6"))
        return 1

    # Display header
    print("\n" + f"{Colors.BOLD}{Colors.CYAN}IP Address Information{Colors.RESET}")
    print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}")

    if hostname:
        print(f"{Colors.BOLD}Hostname:{Colors.RESET} {hostname}")
        print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}")

    # Table header
    print(f"\n{Colors.BOLD}{'Type':<20}{'Address':<40}{Colors.RESET}")
    print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}")

    # Table rows
    for ip_type, ip_address, color in ip_data:
        if "Unable" in ip_address:
            # Error row
            print(f"{Colors.RED}{ip_type:<20}{ip_address:<40}{Colors.RESET}")
        else:
            # Success row with background
            bg_color = Colors.BG_GREEN if "IPv4" in ip_type else Colors.BG_CYAN if "IPv6" in ip_type else Colors.BG_WHITE
            print(f"{bg_color}{Colors.BLACK}{ip_type:<20}{ip_address:<40}{Colors.RESET}")

    print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}\n")

    return 0
def flush_dns():
    """
    Flush the DNS cache

    Returns:
        0 on success, 1 on failure
    """
    system = platform.system()

    try:
        if system == "Windows":
            # Windows: ipconfig /flushdns
            result = subprocess.run(
                ["ipconfig", "/flushdns"],
                capture_output=True,
                text=True,
                check=True
            )
            print(Colors.success("[+] DNS cache flushed successfully (Windows)"))
            return 0

        elif system == "Darwin":  # macOS
            # macOS: dscacheutil -flushcache; killall -HUP mDNSResponder
            subprocess.run(["dscacheutil", "-flushcache"], check=True)
            subprocess.run(["killall", "-HUP", "mDNSResponder"], check=True)
            print(Colors.success("[+] DNS cache flushed successfully (macOS)"))
            return 0

        elif system == "Linux":
            # Linux: Try multiple methods as different distros use different services
            methods = [
                (["systemctl", "restart", "systemd-resolved"], "systemd-resolved"),
                (["systemctl", "restart", "nscd"], "nscd"),
                (["systemctl", "restart", "dnsmasq"], "dnsmasq"),
                (["service", "nscd", "restart"], "nscd service"),
            ]

            for cmd, name in methods:
                try:
                    subprocess.run(cmd, capture_output=True, check=True)
                    print(Colors.success(f"[+] DNS cache flushed successfully using {name} (Linux)"))
                    return 0
                except (subprocess.CalledProcessError, FileNotFoundError):
                    continue

            # If no service worked, try clearing /etc/hosts cache
            print(Colors.warning("[!] No DNS cache service found. DNS may not be cached on this system."))
            print(Colors.info("[*] Note: Some Linux distributions don't cache DNS by default."))
            return 0

        else:
            print(Colors.error(f"[!] Unsupported operating system: {system}"), file=sys.stderr)
            return 1

    except subprocess.CalledProcessError as e:
        print(Colors.error(f"[!] Error flushing DNS cache: {e}"), file=sys.stderr)
        return 1
    except PermissionError:
        print(Colors.error("[!] Error: Insufficient permissions. Try running as administrator/root."), file=sys.stderr)
        return 1
    except Exception as e:
        print(Colors.error(f"[!] Unexpected error: {e}"), file=sys.stderr)
        return 1


def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(
        description="Network utility for IP address retrieval and DNS cache management",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python network.py ip --local --ipv4 --ipv6
  python network.py ip --local
  python network.py ip --ipv4
  python network.py flush-dns

Note: DNS flushing may require administrator/root privileges.
        """,
    )

    subparsers = parser.add_subparsers(dest='command', required=True)

    # IP address command
    ip_parser = subparsers.add_parser('ip', help='Get IP address information')
    ip_parser.add_argument('--local', '-l', action='store_true', help='Show local IP address')
    ip_parser.add_argument('--ipv4', '-4', action='store_true', help='Show public IPv4 address')
    ip_parser.add_argument('--ipv6', '-6', action='store_true', help='Show public IPv6 address')
    ip_parser.add_argument('--hostname', '-n', help='Hostname for local IP lookup')

    # DNS flush command
    subparsers.add_parser('flush-dns', help='Flush DNS cache')

    args = parser.parse_args()

    try:
        if args.command == 'ip':
            # Default to local if no options specified
            if not (args.local or args.ipv4 or args.ipv6):
                args.local = True

            return get_ip_address(
                local=args.local,
                ipv4=args.ipv4,
                ipv6=args.ipv6,
                hostname=args.hostname
            )
        elif args.command == 'flush-dns':
            return flush_dns()
    except KeyboardInterrupt:
        print(Colors.error("\n[!] Aborted by user"))
        return 130
    except Exception as e:
        print(Colors.error(f"[!] Error: {e}"), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
