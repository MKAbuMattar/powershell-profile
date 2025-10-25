#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - QRCode Plugin
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
#       This module provides functions to generate QR codes using the qrcode.show API.
#       It supports creating QR codes in PNG and SVG formats, with options for interactive
#       input and file saving. Uses only Python standard library (no external packages).
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
QR Code Generator CLI

Generate QR codes using the qrcode.show API.
Supports PNG and SVG formats with interactive input and file saving.

Usage:
    python3 qrcode.py "Hello World" --format png
    python3 qrcode.py "https://github.com" --format svg --save
    python3 qrcode.py --interactive --format svg
"""

import json
import sys
import argparse
import urllib.request
import urllib.error
import urllib.parse
import os
import pathlib
from datetime import datetime


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


def show_qrcode_input_message():
    """Display instructions for interactive QR code input."""
    print(f"{Colors.CYAN}Type or paste your text, add a new blank line, and press Ctrl+Z (Windows) "
          f"or Ctrl+D (Unix){Colors.RESET}")


def get_text_input(input_text=None):
    """
    Get text input either from arguments or interactively.

    Args:
        input_text: Text provided as argument, or None for interactive mode

    Returns:
        str: The text to encode
    """
    if input_text and input_text.strip():
        return input_text.strip()

    # Interactive mode
    show_qrcode_input_message()

    lines = []
    try:
        while True:
            try:
                line = input()
                if not line:
                    break
                lines.append(line)
            except EOFError:
                break
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}QR code generation cancelled.{Colors.RESET}")
        sys.exit(1)

    if not lines:
        print(f"{Colors.YELLOW}No input provided. QR code generation cancelled.{Colors.RESET}")
        sys.exit(1)

    return "\n".join(lines)


def test_qrcode_service():
    """Test connectivity to the qrcode.show service."""
    try:
        with urllib.request.urlopen("https://qrcode.show", timeout=10) as response:
            status_code = response.status
            if status_code in [200, 405]:
                print(f"{Colors.GREEN}[+]{Colors.RESET} QR code service is accessible "
                      f"(HTTP {status_code})")
                return True
            else:
                print(f"{Colors.YELLOW}[!]{Colors.RESET} QR code service returned unexpected status: "
                      f"HTTP {status_code}")
                return False
    except urllib.error.URLError as e:
        print(f"{Colors.RED}[-]{Colors.RESET} QR code service is not accessible: {e}")
        return False
    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error testing service: {e}")
        return False


def generate_qrcode_png(text):
    """
    Generate a QR code in PNG format.

    Args:
        text: The text to encode

    Returns:
        bytes: The PNG image data
    """
    try:
        body = text.encode('utf-8')

        request = urllib.request.Request(
            "https://qrcode.show",
            data=body,
            headers={"Content-Type": "text/plain"},
            method="POST"
        )

        with urllib.request.urlopen(request, timeout=10) as response:
            return response.read()
    except urllib.error.URLError as e:
        print(f"{Colors.RED}Error fetching QR code: {e}{Colors.RESET}")
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}Error generating PNG QR code: {e}{Colors.RESET}")
        sys.exit(1)


def generate_qrcode_svg(text):
    """
    Generate a QR code in SVG format.

    Args:
        text: The text to encode

    Returns:
        str: The SVG image data
    """
    try:
        body = text.encode('utf-8')

        request = urllib.request.Request(
            "https://qrcode.show",
            data=body,
            headers={
                "Content-Type": "text/plain",
                "Accept": "image/svg+xml"
            },
            method="POST"
        )

        with urllib.request.urlopen(request, timeout=10) as response:
            return response.read().decode('utf-8')
    except urllib.error.URLError as e:
        print(f"{Colors.RED}Error fetching QR code: {e}{Colors.RESET}")
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}Error generating SVG QR code: {e}{Colors.RESET}")
        sys.exit(1)


def sanitize_filename(text, max_length=50):
    """
    Sanitize text for use as filename.

    Args:
        text: The text to sanitize
        max_length: Maximum length of filename

    Returns:
        str: Sanitized filename
    """
    import re
    # Remove special characters
    sanitized = re.sub(r'[^\w\s-]', '', text)
    # Replace spaces with underscores
    sanitized = re.sub(r'\s+', '_', sanitized)
    # Truncate if too long
    if len(sanitized) > max_length:
        sanitized = sanitized[:max_length]
    return sanitized


def save_qrcode(qrcode_data, output_path, file_format="PNG"):
    """
    Save QR code data to file.

    Args:
        qrcode_data: The QR code data (bytes for PNG, str for SVG)
        output_path: Path to save the file
        file_format: Format type ("PNG" or "SVG")
    """
    try:
        # Create directory if it doesn't exist
        pathlib.Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        if file_format.upper() == "SVG":
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(qrcode_data)
        else:  # PNG
            with open(output_path, 'wb') as f:
                f.write(qrcode_data)


        print(f"{Colors.GREEN}[+]{Colors.RESET} QR code saved to: {output_path}")
    except IOError as e:
        print(f"{Colors.RED}Error saving QR code to file: {e}{Colors.RESET}")
        sys.exit(1)
    except Exception as e:
        print(f"{Colors.RED}Unexpected error saving file: {e}{Colors.RESET}")
        sys.exit(1)


def main():
    """Main entry point for QR code generator."""
    parser = argparse.ArgumentParser(
        description="Generate QR codes using qrcode.show API",
        prog="qrcode.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s "Hello World" --format png
  %(prog)s "https://github.com/MKAbuMattar" --format svg --save
  %(prog)s --interactive --format svg --output-path ~/QRCodes/my_qr.svg
  %(prog)s --test
        """
    )

    parser.add_argument(
        "text",
        nargs="?",
        help="Text to encode in QR code"
    )

    parser.add_argument(
        "-f", "--format",
        choices=["png", "svg"],
        default="png",
        help="Output format (default: png)"
    )

    parser.add_argument(
        "-s", "--save",
        action="store_true",
        help="Save to file (auto-generates filename for SVG)"
    )

    parser.add_argument(
        "-o", "--output-path",
        help="Custom output file path"
    )

    parser.add_argument(
        "-i", "--interactive",
        action="store_true",
        help="Enter interactive mode for multi-line input"
    )

    parser.add_argument(
        "-t", "--test",
        action="store_true",
        help="Test connectivity to qrcode.show service"
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )

    args = parser.parse_args()

    # Test service mode
    if args.test:
        success = test_qrcode_service()
        sys.exit(0 if success else 1)

    # Get input text
    if args.interactive:
        text_input = get_text_input()
    elif args.text:
        text_input = args.text
    else:
        text_input = get_text_input()

    # Generate QR code
    if args.verbose:
        print(f"{Colors.DIM}Generating {args.format.upper()} QR code...{Colors.RESET}")

    if args.format.lower() == "svg":
        qrcode_data = generate_qrcode_svg(text_input)
    else:
        qrcode_data = generate_qrcode_png(text_input)

    # Handle output
    if args.output_path or args.save:
        if args.output_path:
            output_path = args.output_path
            # Expand ~ to home directory
            output_path = os.path.expanduser(output_path)
        else:
            # Auto-generate filename
            qr_dir = os.path.expanduser("~/.QRCode")
            sanitized_text = sanitize_filename(text_input)
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            extension = "svg" if args.format.lower() == "svg" else "png"
            filename = f"{sanitized_text}-{timestamp}.{extension}"
            output_path = os.path.join(qr_dir, filename)

        save_qrcode(qrcode_data, output_path, args.format)
    else:
        # Output to stdout
        if args.format.lower() == "svg":
            print(qrcode_data)
        else:
            # For binary PNG data, write to stdout in binary mode
            sys.stdout.buffer.write(qrcode_data)
            sys.stdout.buffer.flush()


if __name__ == "__main__":
    main()
