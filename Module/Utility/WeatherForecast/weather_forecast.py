#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - WeatherForecast Plugin
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
#       This module provides functions to retrieve and display weather forecasts
#       from the wttr.in service. Features ASCII art display with customizable options
#       including glyphs, moon phases, and multiple languages.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

"""
Weather Forecast CLI

Retrieve and display weather forecasts from wttr.in service.
Supports multiple locations, languages, and display formats.

Usage:
    python3 weather_forecast.py
    python3 weather_forecast.py "London"
    python3 weather_forecast.py "New York" --no-glyphs
    python3 weather_forecast.py --moon
    python3 weather_forecast.py --test
"""

import sys
import argparse
import urllib.request
import urllib.error
import urllib.parse


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


# Supported languages
SUPPORTED_LANGUAGES = [
    "en", "ar", "de", "es", "fr", "it", "nl",
    "pl", "pt", "ro", "ru", "tr", "uk", "ja",
    "zh", "vi", "th", "fa"
]


def build_weather_url(location=None, glyphs=True, moon=False, format_code=None, lang="en", verbose=False):
    """
    Build wttr.in URL with specified parameters.

    Args:
        location: Location name (e.g., "London", "New York")
        glyphs: Include weather glyphs
        moon: Show moon phases
        format_code: Custom format (0-6)
        lang: Language code
        verbose: Enable verbose output

    Returns:
        str: Constructed URL
    """
    base_url = "https://wttr.in/"

    if verbose:
        print(f"{Colors.DIM}Building URL...{Colors.RESET}")

    # Add location or moon
    if moon:
        url = base_url + "Moon"
        if verbose:
            print(f"{Colors.DIM}  → Moon phases mode{Colors.RESET}")
    elif location:
        # URL encode location
        location = urllib.parse.quote(location)
        url = base_url + location
        if verbose:
            print(f"{Colors.DIM}  → Location: {location}{Colors.RESET}")
    else:
        url = base_url
        if verbose:
            print(f"{Colors.DIM}  → Current location{Colors.RESET}")

    # Build query parameters
    params = []

    # Format/display options
    if moon:
        params.append("")  # Moon doesn't use glyph parameter
    elif not glyphs:
        params.append("T")  # Temperature format (no glyphs)
    else:
        params.append("d")  # Default with glyphs

    # Custom format if specified
    if format_code:
        params.append(f"format={format_code}")

    # Language
    if lang != "en":
        params.append(f"lang={lang}")

    # Combine parameters
    if params:
        params = [p for p in params if p]  # Remove empty strings
        if params:
            url += "?" + "&".join(params)

    if verbose:
        print(f"{Colors.DIM}  → URL: {url}{Colors.RESET}")

    return url


def get_weather(location=None, glyphs=True, moon=False, format_code=None, lang="en", verbose=False):
    """
    Fetch weather forecast from wttr.in.

    Args:
        location: Location name
        glyphs: Include weather glyphs
        moon: Show moon phases
        format_code: Custom format
        lang: Language code
        verbose: Enable verbose output

    Returns:
        str: Weather forecast data
    """
    try:
        url = build_weather_url(location, glyphs, moon, format_code, lang, verbose)

        if verbose:
            print(f"{Colors.DIM}Fetching weather data...{Colors.RESET}")

        # Add user agent
        headers = {
            'User-Agent': 'PowerShell-Profile/4.1.0'
        }

        request = urllib.request.Request(url, headers=headers)

        with urllib.request.urlopen(request, timeout=10) as response:
            data = response.read().decode('utf-8')

        return data

    except urllib.error.URLError as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error fetching weather: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Unexpected error: {e}")
        sys.exit(1)


def test_weather_service():
    """Test connectivity to wttr.in service."""
    try:
        with urllib.request.urlopen("https://wttr.in/", timeout=10) as response:
            if response.status == 200:
                print(f"{Colors.GREEN}[+]{Colors.RESET} wttr.in service is accessible (HTTP 200)")
                return True
            else:
                print(f"{Colors.YELLOW}[!]{Colors.RESET} Service returned status: HTTP {response.status}")
                return False
    except urllib.error.URLError as e:
        print(f"{Colors.RED}[-]{Colors.RESET} wttr.in service is not accessible: {e}")
        return False
    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error testing service: {e}")
        return False


def main():
    """Main entry point for Weather Forecast."""
    parser = argparse.ArgumentParser(
        description="Retrieve and display weather forecasts from wttr.in",
        prog="weather_forecast.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                                    # Current location
  %(prog)s "London"                           # Specific location
  %(prog)s "New York" --no-glyphs             # Without glyphs
  %(prog)s "Paris" --lang fr                  # French language
  %(prog)s "Tokyo" --format 3                 # Custom format
  %(prog)s --moon                             # Moon phases
  %(prog)s --test                             # Test service

Languages: en, ar, de, es, fr, it, nl, pl, pt, ro, ru, tr, uk, ja, zh, vi, th, fa
        """
    )

    parser.add_argument(
        "location",
        nargs="?",
        help="Location for weather forecast (e.g., 'London', 'New York')"
    )

    parser.add_argument(
        "-g", "--glyphs",
        action="store_true",
        default=True,
        help="Display weather glyphs (default: enabled)"
    )

    parser.add_argument(
        "--no-glyphs",
        dest="glyphs",
        action="store_false",
        help="Disable weather glyphs"
    )

    parser.add_argument(
        "-m", "--moon",
        action="store_true",
        help="Show moon phases instead of weather"
    )

    parser.add_argument(
        "-f", "--format",
        type=str,
        help="Custom format code (0-6)"
    )

    parser.add_argument(
        "-l", "--lang",
        choices=SUPPORTED_LANGUAGES,
        default="en",
        help="Language for output (default: en)"
    )

    parser.add_argument(
        "-t", "--test",
        action="store_true",
        help="Test service connectivity"
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )

    args = parser.parse_args()

    # Test service mode
    if args.test:
        success = test_weather_service()
        sys.exit(0 if success else 1)

    # Get weather
    if args.verbose:
        print(f"{Colors.DIM}Retrieving weather forecast...{Colors.RESET}\n")

    weather_data = get_weather(
        location=args.location,
        glyphs=args.glyphs,
        moon=args.moon,
        format_code=args.format,
        lang=args.lang,
        verbose=args.verbose
    )

    # Display weather
    # Handle encoding for Windows CMD (force UTF-8 output)
    try:
        print(weather_data, file=sys.stdout)
    except UnicodeEncodeError:
        # Fallback for Windows: use UTF-8 encoding with error handling
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        print(weather_data)


if __name__ == "__main__":
    main()
