#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - GitIgnore Plugin
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
#       This module provides GitIgnore template retrieval and management utilities.
#       Supports generating gitignore content for various technologies using the gitignore.io API.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

"""
GitIgnore Template Generator CLI

Retrieve and generate .gitignore templates for various technologies using the gitignore.io API.
Supports listing available templates, generating content, and managing gitignore files.

Usage:
```bash
python gitignore_util.py --get TECHNOLOGY [TECHNOLOGY ...]
python gitignore_util.py --list [--filter PATTERN]
python gitignore_util.py --test
```
"""

import sys
import urllib.request
import urllib.error
import argparse
import json
from typing import List, Dict, Optional, Tuple

# ANSI Colors
class Colors:
    """ANSI color codes for terminal output"""
    RESET = "\033[0m"
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    BOLD = "\033[1m"

    @staticmethod
    def success(text: str) -> str:
        """Format success message"""
        return f"{Colors.GREEN}[+]{Colors.RESET} {text}"

    @staticmethod
    def error(text: str) -> str:
        """Format error message"""
        return f"{Colors.RED}[!]{Colors.RESET} {text}"

    @staticmethod
    def info(text: str) -> str:
        """Format info message"""
        return f"{Colors.CYAN}[*]{Colors.RESET} {text}"


class GitIgnoreAPI:
    """Client for gitignore.io API"""

    BASE_URL = "https://www.toptal.com/developers/gitignore/api"
    TIMEOUT = 10

    @staticmethod
    def fetch_url(url: str) -> str:
        """
        Fetch content from URL

        Args:
            url: URL to fetch

        Returns:
            Response content as string

        Raises:
            urllib.error.URLError: If network request fails
        """
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=GitIgnoreAPI.TIMEOUT) as response:
                return response.read().decode("utf-8")
        except urllib.error.URLError as e:
            raise RuntimeError(f"Failed to fetch {url}: {e}")

    @staticmethod
    def get_templates(technologies: List[str]) -> str:
        """
        Get gitignore content for specified technologies

        Args:
            technologies: List of technology names

        Returns:
            GitIgnore content as string
        """
        if not technologies:
            raise ValueError("At least one technology must be specified")

        tech_string = ",".join(technologies).lower()
        url = f"{GitIgnoreAPI.BASE_URL}/{tech_string}"

        print(f"Fetching gitignore templates for: {', '.join(technologies)}")
        return GitIgnoreAPI.fetch_url(url)

    @staticmethod
    def list_templates() -> List[str]:
        """
        Get list of available templates

        Returns:
            List of available technology names
        """
        url = f"{GitIgnoreAPI.BASE_URL}/list"

        print(Colors.info("Fetching available templates..."))
        response = GitIgnoreAPI.fetch_url(url)
        technologies = sorted(response.strip().split(","))
        return technologies

    @staticmethod
    def test_connectivity() -> bool:
        """
        Test API connectivity

        Returns:
            True if API is accessible, False otherwise
        """
        try:
            print(Colors.info("Testing gitignore.io API connectivity..."))
            response = GitIgnoreAPI.fetch_url(f"{GitIgnoreAPI.BASE_URL}/list")
            if response:
                tech_count = len(response.split(","))
                print(Colors.success(f"gitignore.io API is accessible!"))
                print(Colors.info(f"Available templates: {tech_count}"))
                return True
        except Exception as e:
            print(Colors.error(f"Failed to connect to gitignore.io API: {e}"))
            return False

        return False


def get_gitignore(technologies: List[str], verbose: bool = False) -> None:
    """
    Fetch and display gitignore content

    Args:
        technologies: List of technology names
        verbose: Enable verbose output
    """
    try:
        content = GitIgnoreAPI.get_templates(technologies)
        print(content)
        if verbose:
            print(Colors.info(f"Successfully retrieved gitignore for: {', '.join(technologies)}"), file=sys.stderr)
    except Exception as e:
        print(Colors.error(f"Failed to fetch gitignore: {e}"), file=sys.stderr)
        sys.exit(1)


def list_templates(filter_text: Optional[str] = None, verbose: bool = False) -> None:
    """
    List available gitignore templates

    Args:
        filter_text: Optional filter string
        verbose: Enable verbose output
    """
    try:
        templates = GitIgnoreAPI.list_templates()

        if filter_text:
            templates = [t for t in templates if filter_text.lower() in t.lower()]
            print(Colors.info(f"Found {len(templates)} templates matching '{filter_text}':\n"))
        else:
            print(Colors.info(f"Available GitIgnore Templates ({len(templates)} total):\n"))

        # Display in columns (4 columns)
        column_width = 20
        for i, tech in enumerate(templates):
            print(f"{tech:<{column_width}}", end="")
            if (i + 1) % 4 == 0:
                print()

        if len(templates) % 4 != 0:
            print()

        print()
        print(Colors.info("Usage: gitignore <technology1> <technology2> ..."))
        print(Colors.info("Example: gitignore node python visualstudio"))

    except Exception as e:
        print(Colors.error(f"Failed to fetch templates: {e}"), file=sys.stderr)
        sys.exit(1)


def test_service(verbose: bool = False) -> None:
    """
    Test gitignore.io service connectivity

    Args:
        verbose: Enable verbose output
    """
    success = GitIgnoreAPI.test_connectivity()
    sys.exit(0 if success else 1)


def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(
        description="Generate .gitignore templates from gitignore.io API",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python gitignore_util.py --get node python
  python gitignore_util.py --list
  python gitignore_util.py --list --filter python
  python gitignore_util.py --test
        """,
    )

    # Create mutually exclusive group for modes
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument(
        "--get",
        nargs="+",
        metavar="TECHNOLOGY",
        help="Get gitignore templates for specified technologies",
    )
    modes.add_argument(
        "--list",
        action="store_true",
        help="List all available gitignore templates",
    )
    modes.add_argument(
        "--test",
        action="store_true",
        help="Test API connectivity",
    )

    parser.add_argument(
        "--filter",
        metavar="PATTERN",
        help="Filter templates by pattern (used with --list)",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output",
    )

    args = parser.parse_args()

    try:
        if args.get:
            get_gitignore(args.get, args.verbose)
        elif args.list:
            list_templates(args.filter, args.verbose)
        elif args.test:
            test_service(args.verbose)
    except KeyboardInterrupt:
        print(Colors.error("Operation cancelled by user"), file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        print(Colors.error(f"Unexpected error: {e}"), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
