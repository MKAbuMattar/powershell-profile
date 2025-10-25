#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Misc Module
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
#       This Module provides a set of miscellaneous utility functions for various
#       common tasks in PowerShell.
#
# Created: 2021-09-01
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

import argparse
import datetime
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path
from typing import List, Optional, Tuple


class Colors:
    """ANSI color codes for terminal output"""
    RESET = "\033[0m"
    BLACK = "\033[30m"
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    MAGENTA = "\033[95m"
    CYAN = "\033[96m"
    WHITE = "\033[97m"
    GRAY = "\033[90m"
    DARK_GRAY = "\033[2;37m"
    BOLD = "\033[1m"

    # Background colors
    BG_RED = "\033[41m"
    BG_GREEN = "\033[42m"
    BG_YELLOW = "\033[43m"
    BG_BLUE = "\033[44m"
    BG_CYAN = "\033[46m"
    BG_WHITE = "\033[47m"
    BG_DARK_GRAY = "\033[100m"

    @staticmethod
    def info(text: str) -> str:
        """Return cyan colored info text"""
        return f"{Colors.CYAN}{text}{Colors.RESET}"

    @staticmethod
    def success(text: str) -> str:
        """Return green colored success text"""
        return f"{Colors.GREEN}{text}{Colors.RESET}"

    @staticmethod
    def warning(text: str) -> str:
        """Return yellow colored warning text"""
        return f"{Colors.YELLOW}{text}{Colors.RESET}"

    @staticmethod
    def error(text: str) -> str:
        """Return red colored error text"""
        return f"{Colors.RED}{text}{Colors.RESET}"


def is_admin() -> bool:
    """
    Check if the current user has administrator privileges

    Returns:
        True if user has admin privileges, False otherwise
    """
    try:
        if platform.system() == "Windows":
            import ctypes
            return ctypes.windll.shell32.IsUserAnAdmin() != 0
        else:
            # On Unix-like systems, check if UID is 0 (root)
            return os.geteuid() == 0
    except Exception:
        return False


def command_exists(command: str) -> bool:
    """
    Check if a command exists in the system PATH

    Args:
        command: Command name to check

    Returns:
        True if command exists, False otherwise
    """
    return shutil.which(command) is not None


def get_uptime() -> Tuple[datetime.datetime, datetime.timedelta]:
    """
    Get system boot time and uptime

    Returns:
        Tuple of (boot_time, uptime_delta)
    """
    system = platform.system()

    try:
        if system == "Windows":
            # Use systeminfo command on Windows
            try:
                result = subprocess.run(
                    ["powershell", "-NoProfile", "-Command",
                     "(Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime.ToString('yyyy-MM-dd HH:mm:ss')"],
                    capture_output=True,
                    text=True,
                    timeout=10
                )
                if result.returncode == 0 and result.stdout.strip():
                    boot_str = result.stdout.strip()
                    boot_time = datetime.datetime.strptime(boot_str, "%Y-%m-%d %H:%M:%S")
                else:
                    raise subprocess.SubprocessError("PowerShell command failed")
            except Exception:
                # Fallback to net statistics
                result = subprocess.run(
                    ["net", "statistics", "workstation"],
                    capture_output=True,
                    text=True,
                    timeout=5
                )
                if result.returncode == 0:
                    for line in result.stdout.split('\n'):
                        if 'Statistics since' in line or 'since' in line.lower():
                            boot_str = line.split('since')[-1].strip()
                            # Try multiple date formats
                            for fmt in [
                                '%d/%m/%Y %I:%M:%S %p',
                                '%d/%m/%Y %H:%M:%S',
                                '%m/%d/%Y %I:%M:%S %p',
                                '%m/%d/%Y %H:%M:%S',
                                '%Y-%m-%d %H:%M:%S',
                                '%d.%m.%Y %H:%M:%S'
                            ]:
                                try:
                                    boot_time = datetime.datetime.strptime(boot_str, fmt)
                                    break
                                except ValueError:
                                    continue
                            else:
                                raise ValueError(f"Could not parse date: {boot_str}")
                            break
                    else:
                        raise ValueError("Could not find boot time in net statistics output")
                else:
                    raise subprocess.SubprocessError("net statistics command failed")

        elif system == "Linux":
            # Read from /proc/uptime on Linux
            with open('/proc/uptime', 'r') as f:
                uptime_seconds = float(f.readline().split()[0])
            boot_time = datetime.datetime.now() - datetime.timedelta(seconds=uptime_seconds)

        elif system == "Darwin":  # macOS
            # Use sysctl on macOS
            result = subprocess.run(
                ["sysctl", "-n", "kern.boottime"],
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                # Parse output like: { sec = 1234567890, usec = 0 }
                import re
                match = re.search(r'sec = (\d+)', result.stdout)
                if match:
                    boot_timestamp = int(match.group(1))
                    boot_time = datetime.datetime.fromtimestamp(boot_timestamp)
                else:
                    raise ValueError("Could not parse sysctl output")
            else:
                raise subprocess.SubprocessError("sysctl command failed")
        else:
            raise NotImplementedError(f"Unsupported platform: {system}")

        uptime = datetime.datetime.now() - boot_time
        return boot_time, uptime

    except Exception as e:
        raise RuntimeError(f"Failed to get system uptime: {str(e)}")


def format_size(size_bytes: int, decimal_places: int = 2) -> str:
    """
    Convert bytes to human-readable format

    Args:
        size_bytes: Size in bytes
        decimal_places: Number of decimal places

    Returns:
        Formatted size string (e.g., "1.23 GB")
    """
    if size_bytes == 0:
        return "0 B"

    units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB']
    unit_index = 0
    size = float(size_bytes)

    while size >= 1024 and unit_index < len(units) - 1:
        size /= 1024
        unit_index += 1

    return f"{size:.{decimal_places}f} {units[unit_index]}"


def get_disk_usage(paths: List[str], human_readable: bool = True,
                   sort_results: bool = False, sort_by: str = "size") -> int:
    """
    Display disk usage for specified paths

    Args:
        paths: List of paths to check
        human_readable: Display sizes in human-readable format
        sort_results: Whether to sort results
        sort_by: Sort by "name" or "size"

    Returns:
        Exit code (0 for success, 1 for error)
    """
    for path_str in paths:
        path = Path(path_str)

        # Print separator
        print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

        # Resolve path
        try:
            if not path.exists():
                print(f"{Colors.WHITE}Path: {path_str}{Colors.RESET}")
                print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
                print(f"{Colors.YELLOW}Error: {Colors.RED}Path not found{Colors.RESET}")
                print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
                continue

            resolved_path = path.resolve()
        except PermissionError:
            print(f"{Colors.WHITE}Path: {path_str}{Colors.RESET}")
            print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
            print(f"{Colors.YELLOW}Error: {Colors.RED}Permission denied{Colors.RESET}")
            print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
            continue

        # Check if it's a file
        if resolved_path.is_file():
            try:
                file_size = resolved_path.stat().st_size
                hr_size = format_size(file_size) if human_readable else "N/A"

                print(f"{Colors.WHITE}File: {resolved_path}{Colors.RESET}")
                print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

                # Color code based on size
                if file_size > 1024**3:  # > 1GB
                    size_color = Colors.RED
                elif file_size > 100 * 1024**2:  # > 100MB
                    size_color = Colors.YELLOW
                elif file_size > 10 * 1024**2:  # > 10MB
                    size_color = Colors.GREEN
                else:
                    size_color = Colors.WHITE

                print(f"{Colors.YELLOW}Size: {size_color}{hr_size}{Colors.RESET}")
                print(f"{Colors.YELLOW}Type: {Colors.WHITE}File{Colors.RESET}")

                mod_time = datetime.datetime.fromtimestamp(resolved_path.stat().st_mtime)
                print(f"{Colors.YELLOW}Last Modified: {Colors.WHITE}{mod_time.strftime('%Y-%m-%d %H:%M:%S')}{Colors.RESET}")
                print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

            except PermissionError:
                print(f"{Colors.WHITE}File: {resolved_path}{Colors.RESET}")
                print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
                print(f"{Colors.YELLOW}Error: {Colors.RED}Cannot access file (Permission Denied){Colors.RESET}")
                print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
            continue

        # It's a directory
        if not resolved_path.is_dir():
            continue

        print(f"{Colors.WHITE}Disk usage for: {resolved_path}{Colors.RESET}")
        print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

        # List directory contents
        try:
            items = list(resolved_path.iterdir())
        except PermissionError:
            print(f"{Colors.YELLOW}Error: {Colors.RED}Cannot list contents - Permission Denied{Colors.RESET}")
            print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")
            continue

        items_data = []
        total_size = 0
        folder_count = 0
        file_count = 0

        for item in items:
            item_name = item.name
            is_folder = item.is_dir()
            item_size = -1
            error_msg = ""

            try:
                if is_folder:
                    folder_count += 1
                    # Calculate folder size recursively
                    try:
                        item_size = 0
                        for f in item.rglob('*'):
                            try:
                                if f.is_file():
                                    item_size += f.stat().st_size
                            except (PermissionError, OSError):
                                # Skip files we can't access
                                continue
                        # If we got size 0 but couldn't access the folder, mark as error
                        if item_size == 0:
                            # Try to access at least one file to verify we have permission
                            try:
                                next(item.rglob('*'))
                            except StopIteration:
                                # Empty folder, that's OK
                                pass
                            except (PermissionError, OSError):
                                error_msg = "(Permission Denied)"
                                item_size = -1
                    except (PermissionError, OSError):
                        error_msg = "(Permission Denied)"
                        item_size = -1
                else:
                    file_count += 1
                    item_size = item.stat().st_size

                if item_size >= 0:
                    total_size += item_size

            except PermissionError:
                error_msg = "(Permission Denied)"
                item_size = -1
            except Exception as e:
                error_msg = f"(Error: {str(e).split(chr(10))[0]})"
                item_size = -1

            hr_size = format_size(item_size) if (human_readable and item_size >= 0) else "N/A"

            items_data.append({
                'name': item_name,
                'size': hr_size,
                'raw_size': item_size,
                'is_folder': is_folder,
                'error': error_msg
            })

        # Sort items
        if sort_results:
            if sort_by.lower() == "name":
                items_data.sort(key=lambda x: (not x['is_folder'], x['name'].lower()))
            else:  # sort by size
                items_data.sort(key=lambda x: (not x['is_folder'], -x['raw_size'] if x['raw_size'] >= 0 else 0))

        # Display summary
        total_hr = format_size(total_size) if human_readable else "N/A"
        print(f"{Colors.YELLOW}Total Size: {Colors.WHITE}{total_hr}{Colors.RESET}")
        print(f"{Colors.YELLOW}Items: {Colors.WHITE}{len(items_data)} ({folder_count} directories, {file_count} files){Colors.RESET}")
        print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

        # Table header
        print(f"{Colors.YELLOW}{Colors.BOLD}{'Size':<15} {'Type':<15} {'Name':<50}{Colors.RESET}")
        print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

        # Display items
        for item in items_data:
            item_type = "Directory" if item['is_folder'] else "File"
            item_type_color = Colors.BLUE if item['is_folder'] else Colors.WHITE

            # Color code based on size
            size_color = Colors.WHITE
            if item['raw_size'] != -1:
                if item['raw_size'] > 1024**3:  # > 1GB
                    size_color = Colors.RED
                elif item['raw_size'] > 100 * 1024**2:  # > 100MB
                    size_color = Colors.YELLOW
                elif item['raw_size'] > 10 * 1024**2:  # > 10MB
                    size_color = Colors.GREEN

            print(f"{size_color}{item['size']:<15}{Colors.RESET} "
                  f"{item_type_color}{item_type:<15}{Colors.RESET} "
                  f"{item_type_color}{item['name']:<50}{Colors.RESET}")

            if item['error']:
                print(f"    {Colors.RED}{item['error']}{Colors.RESET}")

        print(f"{Colors.CYAN}{'-' * 60}{Colors.RESET}")

    return 0


def main():
    """Main entry point for the CLI"""
    parser = argparse.ArgumentParser(
        description="Miscellaneous utility functions",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s is-admin
  %(prog)s command-exists python
  %(prog)s uptime
  %(prog)s du
  %(prog)s du --path /home/user --sort --sort-by name
  %(prog)s du --path C:\\Users --no-human-readable
        """
    )

    subparsers = parser.add_subparsers(dest='command', help='Available commands')

    # is-admin subcommand
    admin_parser = subparsers.add_parser('is-admin', help='Check if running as administrator')

    # command-exists subcommand
    cmd_parser = subparsers.add_parser('command-exists', help='Check if a command exists')
    cmd_parser.add_argument('name', help='Command name to check')

    # uptime subcommand
    uptime_parser = subparsers.add_parser('uptime', help='Get system uptime')

    # du (disk usage) subcommand
    du_parser = subparsers.add_parser('du', help='Get disk usage')
    du_parser.add_argument(
        '--path', '-p',
        nargs='+',
        default=['.'],
        help='Paths to check (default: current directory)'
    )
    du_parser.add_argument(
        '--no-human-readable',
        action='store_true',
        help='Display sizes in bytes instead of human-readable format'
    )
    du_parser.add_argument(
        '--sort', '-s',
        action='store_true',
        help='Sort the results'
    )
    du_parser.add_argument(
        '--sort-by', '-sb',
        choices=['name', 'size'],
        default='size',
        help='Sort by name or size (default: size)'
    )

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    try:
        if args.command == 'is-admin':
            if is_admin():
                print(Colors.success("[+] Running with administrator privileges"))
                return 0
            else:
                print(Colors.warning("[!] Not running with administrator privileges"))
                return 1

        elif args.command == 'command-exists':
            if command_exists(args.name):
                print(Colors.success(f"[+] Command '{args.name}' exists"))
                return 0
            else:
                print(Colors.error(f"[!] Command '{args.name}' not found"))
                return 1

        elif args.command == 'uptime':
            boot_time, uptime = get_uptime()

            # Format boot time
            formatted_boot = boot_time.strftime("%A, %B %d, %Y %H:%M:%S")
            print(f"{Colors.DARK_GRAY}System started on: {formatted_boot}{Colors.RESET}")

            # Calculate uptime components
            days = uptime.days
            hours, remainder = divmod(uptime.seconds, 3600)
            minutes, seconds = divmod(remainder, 60)

            print(f"{Colors.BLUE}Uptime: {days} days, {hours} hours, {minutes} minutes, {seconds} seconds{Colors.RESET}")
            return 0

        elif args.command == 'du':
            human_readable = not args.no_human_readable
            return get_disk_usage(args.path, human_readable, args.sort, args.sort_by)

    except Exception as e:
        print(Colors.error(f"[!] Error: {str(e)}"))
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
