#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - RandomQuote Plugin
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
#       This module provides functions to retrieve and display random quotes
#       from the Quotable API. Features color-coded output and multiple display formats.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

"""
Random Quote CLI

Retrieve and display random quotes from the Quotable API.
Supports multiple display formats and filtering options.

Usage:
    python3 random_quote.py
    python3 random_quote.py --format json
    python3 random_quote.py --test
"""

import json
import sys
import argparse
import urllib.request
import urllib.error


# ===== ANSI Color Codes =====
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    DIM = '\033[2m'
    BG_BLUE = '\033[44m'
    BG_CYAN = '\033[46m'
    BG_GREEN = '\033[42m'
    BG_YELLOW = '\033[43m'
    BG_WHITE = '\033[47m'
    BG_DARK_GRAY = '\033[100m'
    BLACK = '\033[30m'
    WHITE = '\033[97m'
    GRAY = '\033[90m'
    RESET = '\033[0m'


def get_random_quote(verbose=False):
    """
    Fetch a random quote from the Quotable API.

    Args:
        verbose: Enable verbose output

    Returns:
        dict: Quote data containing 'content' and 'author' keys
    """
    url = "http://api.quotable.io/random"

    try:
        if verbose:
            print(f"{Colors.DIM}Fetching random quote from {url}...{Colors.RESET}")

        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read().decode())

        if not data or 'content' not in data:
            print(f"{Colors.RED}[-]{Colors.RESET} Error: Invalid response from API")
            sys.exit(1)

        return data

    except urllib.error.URLError as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error fetching quote: {e}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"{Colors.RED}[-]{Colors.RESET} Error parsing quote response")
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Unexpected error: {e}")
        sys.exit(1)


def display_quote_default(quote_data):
    """Display quote in default format with colors."""
    content = quote_data.get('content', '')
    author = quote_data.get('author', 'Unknown').replace(', author.bio', '')
    tags = quote_data.get('tags', [])

    print(f"\n{Colors.CYAN}{Colors.BOLD}Random Quote{Colors.RESET}")
    print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}")
    print(f"{Colors.WHITE}{content}{Colors.RESET}")
    print()
    print(f"{Colors.GREEN}[+]{Colors.RESET} {Colors.BOLD}{author}{Colors.RESET}")

    if tags:
        tags_str = ", ".join(tags[:3])  # Show first 3 tags
        print(f"{Colors.GRAY}Tags: {tags_str}{Colors.RESET}")

    print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}\n")


def display_quote_simple(quote_data):
    """Display quote in simple format."""
    content = quote_data.get('content', '')
    author = quote_data.get('author', 'Unknown').replace(', author.bio', '')

    print(f'"{content}"')
    print(f" - {author}")


def display_quote_json(quote_data):
    """Display quote in JSON format."""
    print(json.dumps(quote_data, indent=2))


def test_api_service():
    """Test connectivity to the Quotable API."""
    try:
        with urllib.request.urlopen("http://api.quotable.io/random", timeout=10) as response:
            if response.status == 200:
                print(f"{Colors.GREEN}[+]{Colors.RESET} Quotable API is accessible (HTTP 200)")
                return True
            else:
                print(f"{Colors.YELLOW}[!]{Colors.RESET} API returned unexpected status: HTTP {response.status}")
                return False
    except urllib.error.URLError as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Quotable API is not accessible: {e}")
        return False
    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error testing API: {e}")
        return False


def main():
    """Main entry point for Random Quote generator."""
    parser = argparse.ArgumentParser(
        description="Retrieve and display random quotes from Quotable API",
        prog="random_quote.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s
  %(prog)s --format simple
  %(prog)s --format json
  %(prog)s --test
        """
    )

    parser.add_argument(
        "-f", "--format",
        choices=["default", "simple", "json"],
        default="default",
        help="Display format (default: default)"
    )

    parser.add_argument(
        "-t", "--test",
        action="store_true",
        help="Test connectivity to Quotable API"
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )

    args = parser.parse_args()

    # Test service mode
    if args.test:
        success = test_api_service()
        sys.exit(0 if success else 1)

    # Fetch and display quote
    if args.verbose:
        print(f"{Colors.DIM}Retrieving random quote...{Colors.RESET}")

    quote_data = get_random_quote(verbose=args.verbose)

    # Display based on format
    if args.format == "simple":
        display_quote_simple(quote_data)
    elif args.format == "json":
        display_quote_json(quote_data)
    else:  # default
        display_quote_default(quote_data)


if __name__ == "__main__":
    main()
