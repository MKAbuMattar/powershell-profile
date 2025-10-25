#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PrayerTimes Plugin
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
#       This module provides functions to retrieve and display Islamic prayer times
#       for a specified city and country using the AlAdhan API. It features a clean,
#       left-aligned CLI interface with color-coded output, showing current and
#       next prayers, time until the next prayer, and both Hijri and Gregorian dates.
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
Prayer Times CLI

A clean, left-aligned prayer times viewer using AlAdhan API.
Shows current and next prayers, time until the next one,
and Hijri + Gregorian dates.

Usage:
    python3 prayer_times.py --city <city> --country <country> [--method <method>] [--format 24]
"""

import json
import sys
import argparse
import urllib.request
import urllib.error
from datetime import datetime, timedelta


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


def get_prayer_times(city, country, method=1, use_24_hour_format=False):
    """Fetch and display prayer times from AlAdhan API."""
    city = city.strip().title()
    country = country.strip().title()

    url = f"http://api.aladhan.com/v1/timingsByCity?city={city}&country={country}&method={method}"

    try:
        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read().decode())

        if data.get("code") != 200:
            print("❌ Error fetching prayer times. Please check your city and country name.")
            sys.exit(1)

        timings = data["data"]["timings"]
        date_info = data["data"]["date"]
        readable_date = date_info["readable"]
        hijri_date = date_info["hijri"]
        hijri_full = f"{hijri_date['weekday']['en']} {hijri_date['day']} {hijri_date['month']['en']} {hijri_date['year']}"

        prayer_names = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]

        # Format times
        prayer_times = {}
        for prayer in prayer_names:
            time_str = timings[prayer]
            if use_24_hour_format:
                prayer_times[prayer] = time_str
            else:
                time_obj = datetime.strptime(time_str, "%H:%M")
                prayer_times[prayer] = time_obj.strftime("%I:%M %p").lower()

        now = datetime.now()
        current_time_str = now.strftime("%H:%M")

        # Determine current and next prayers
        sorted_prayers = [(p, timings[p]) for p in prayer_names]
        current_prayer = None
        next_prayer = None

        for p, t in sorted_prayers:
            if current_time_str >= t:
                current_prayer = p
            elif next_prayer is None:
                next_prayer = p

        if current_prayer == "Isha" or next_prayer is None:
            next_prayer = "Fajr"

        # Countdown to next prayer
        next_prayer_time_24 = timings[next_prayer]
        next_dt = datetime.strptime(next_prayer_time_24, "%H:%M").replace(year=now.year, month=now.month, day=now.day)
        if next_dt <= now:
            next_dt += timedelta(days=1)
        countdown = next_dt - now
        countdown_hours = int(countdown.total_seconds() // 3600)
        countdown_minutes = int((countdown.total_seconds() % 3600) // 60)

        # ===== Display =====
        print("\n" + f"{Colors.BOLD}{Colors.CYAN}Prayer Times for {city}, {country}{Colors.RESET}")
        print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}")

        # Show current & next prayer at the top
        current_label = f"{Colors.BOLD}{Colors.WHITE}Current:{Colors.RESET} {current_prayer or 'N/A'}"
        next_label = f"{Colors.BOLD}{Colors.WHITE}Next:{Colors.RESET} {next_prayer}  " \
                     f"{Colors.GREEN}+{countdown_hours:02d}:{countdown_minutes:02d}{Colors.RESET}"
        print(f"{current_label:<30}{next_label}")
        print(f"{Colors.GRAY}{'-' * 60}{Colors.RESET}\n")

        # Table header
        print(f"{Colors.BOLD}{'Prayer':<15}{'Time':<10}{'Status':<10}{Colors.RESET}")
        print(f"{Colors.GRAY}{'-' * 35}{Colors.RESET}")

        # Table rows
        for p in prayer_names:
            time_display = prayer_times[p]
            if p == current_prayer:
                color = Colors.BG_CYAN + Colors.BLACK
                status = "current"
            elif p == next_prayer:
                color = Colors.BG_WHITE + Colors.BLACK
                status = "next"
            else:
                color = Colors.BG_DARK_GRAY + Colors.WHITE
                status = ""
            print(f"{color}{p:<15}{time_display:<10}{status:<10}{Colors.RESET}")

        print(f"\n{Colors.GRAY}{'-' * 60}{Colors.RESET}")
        print(f"{Colors.BOLD}Hijri:{Colors.RESET} {hijri_full}")
        print(f"{Colors.BOLD}Gregorian:{Colors.RESET} {readable_date}")
        print()

    except urllib.error.URLError as e:
        print(f"❌ Error fetching prayer times: {e}")
        sys.exit(1)
    except json.JSONDecodeError:
        print("❌ Error parsing prayer times response.")
        sys.exit(1)
    except KeyError as e:
        print(f"❌ Missing expected data in response: {e}")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Display prayer times for a given city and country.",
        prog="prayer_times.py"
    )
    parser.add_argument("--city", "-c", required=True, help="City name (e.g., Amman)")
    parser.add_argument("--country", "-o", required=True, help="Country name (e.g., Jordan)")
    parser.add_argument("--method", "-m", type=int, default=1, help="Calculation method (default: 1)")
    parser.add_argument("--format", "-f", choices=["12", "24"], default="12", help="Time format: 12 or 24 (default: 12)")
    args = parser.parse_args()

    use_24_hour = args.format == "24"
    get_prayer_times(args.city, args.country, args.method, use_24_hour)


if __name__ == "__main__":
    main()
