#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Base64 Plugin
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
#       This module provides Base64 encoding and decoding utilities.
#       Supports encoding/decoding text and files.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

"""
Base64 Encoding/Decoding CLI

Encode and decode Base64 text and files using standard library only.

Usage:
    python3 base64_util.py --encode "Hello World"
    python3 base64_util.py --decode "SGVsbG8gV29ybGQ="
    python3 base64_util.py --encode-file myfile.txt
    python3 base64_util.py --decode-file encoded.txt
"""

import sys
import argparse
import base64
import os


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
    BLACK = '\033[30m'
    WHITE = '\033[97m'
    GRAY = '\033[90m'
    RESET = '\033[0m'


def encode_text(text, verbose=False):
    """
    Encode text to Base64.

    Args:
        text: Text to encode
        verbose: Enable verbose output

    Returns:
        str: Base64 encoded string
    """
    try:
        if verbose:
            print(f"{Colors.DIM}Encoding text to Base64...{Colors.RESET}")

        # Encode text to bytes, then to Base64
        text_bytes = text.encode('utf-8')
        base64_bytes = base64.b64encode(text_bytes)
        base64_string = base64_bytes.decode('ascii')

        if verbose:
            print(f"{Colors.DIM}  → Encoded successfully{Colors.RESET}")

        return base64_string

    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error encoding text: {e}")
        sys.exit(1)


def decode_text(text, verbose=False):
    """
    Decode Base64 text to plain text.

    Args:
        text: Base64 encoded text
        verbose: Enable verbose output

    Returns:
        str: Decoded plain text
    """
    try:
        if verbose:
            print(f"{Colors.DIM}Decoding Base64 text...{Colors.RESET}")

        # Decode Base64 to bytes, then to text
        text = text.strip()
        base64_bytes = base64.b64decode(text)
        decoded_text = base64_bytes.decode('utf-8')

        if verbose:
            print(f"{Colors.DIM}  → Decoded successfully{Colors.RESET}")

        return decoded_text

    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error decoding Base64: {e}")
        sys.exit(1)


def encode_file(file_path, output_path=None, verbose=False):
    """
    Encode a file to Base64.

    Args:
        file_path: Path to file to encode
        output_path: Optional output file path (default: file_path.txt)
        verbose: Enable verbose output

    Returns:
        str: Path to output file
    """
    try:
        if not os.path.exists(file_path):
            print(f"{Colors.RED}[-]{Colors.RESET} File not found: {file_path}")
            sys.exit(1)

        if verbose:
            print(f"{Colors.DIM}Encoding file to Base64...{Colors.RESET}")
            print(f"{Colors.DIM}  → Input: {file_path}{Colors.RESET}")

        # Read file
        with open(file_path, 'rb') as f:
            file_bytes = f.read()

        # Encode to Base64
        base64_bytes = base64.b64encode(file_bytes)
        base64_string = base64_bytes.decode('ascii')

        # Determine output path
        if not output_path:
            output_path = f"{file_path}.txt"

        # Write output
        with open(output_path, 'w') as f:
            f.write(base64_string)

        if verbose:
            print(f"{Colors.DIM}  → Output: {output_path}{Colors.RESET}")
            print(f"{Colors.DIM}  → Encoded successfully{Colors.RESET}")

        print(f"{Colors.GREEN}[+]{Colors.RESET} File encoded: {output_path}")
        return output_path

    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error encoding file: {e}")
        sys.exit(1)


def decode_file(file_path, output_path=None, verbose=False):
    """
    Decode a Base64 encoded file.

    Args:
        file_path: Path to Base64 encoded file
        output_path: Optional output file path (default: file_path.decoded)
        verbose: Enable verbose output

    Returns:
        str: Path to output file
    """
    try:
        if not os.path.exists(file_path):
            print(f"{Colors.RED}[-]{Colors.RESET} File not found: {file_path}")
            sys.exit(1)

        if verbose:
            print(f"{Colors.DIM}Decoding Base64 file...{Colors.RESET}")
            print(f"{Colors.DIM}  → Input: {file_path}{Colors.RESET}")

        # Read file
        with open(file_path, 'r') as f:
            base64_string = f.read().strip()

        # Decode from Base64
        decoded_bytes = base64.b64decode(base64_string)

        # Determine output path
        if not output_path:
            # Remove .txt or .b64 extension if present
            if file_path.endswith('.txt'):
                output_path = file_path[:-4]
            elif file_path.endswith('.b64'):
                output_path = file_path[:-4]
            else:
                output_path = f"{file_path}.decoded"

        # Write output
        with open(output_path, 'wb') as f:
            f.write(decoded_bytes)

        if verbose:
            print(f"{Colors.DIM}  → Output: {output_path}{Colors.RESET}")
            print(f"{Colors.DIM}  → Decoded successfully{Colors.RESET}")

        print(f"{Colors.GREEN}[+]{Colors.RESET} File decoded: {output_path}")
        return output_path

    except Exception as e:
        print(f"{Colors.RED}[-]{Colors.RESET} Error decoding file: {e}")
        sys.exit(1)


def main():
    """Main entry point for Base64 utility."""
    parser = argparse.ArgumentParser(
        description="Base64 encoding and decoding utility",
        prog="base64_util.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --encode "Hello World"              # Encode text
  %(prog)s --decode "SGVsbG8gV29ybGQ="         # Decode text
  %(prog)s --encode-file document.pdf          # Encode file
  %(prog)s --decode-file encoded.txt           # Decode file
  %(prog)s --encode "Secret" -o encoded.txt    # Encode with output file
  %(prog)s -e "test" --verbose                 # Verbose output
        """
    )

    # Mode selection (mutually exclusive)
    mode_group = parser.add_mutually_exclusive_group(required=True)
    mode_group.add_argument(
        "-e", "--encode",
        help="Encode text to Base64"
    )
    mode_group.add_argument(
        "-d", "--decode",
        help="Decode Base64 text to plain text"
    )
    mode_group.add_argument(
        "--encode-file",
        help="Encode a file to Base64"
    )
    mode_group.add_argument(
        "--decode-file",
        help="Decode a Base64 encoded file"
    )

    # Optional arguments
    parser.add_argument(
        "-o", "--output",
        help="Output file path (for file operations)"
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )

    args = parser.parse_args()

    # Execute appropriate function
    if args.encode:
        result = encode_text(args.encode, args.verbose)
        print(f"{Colors.CYAN}{result}{Colors.RESET}")

    elif args.decode:
        result = decode_text(args.decode, args.verbose)
        print(f"{Colors.CYAN}{result}{Colors.RESET}")

    elif args.encode_file:
        encode_file(args.encode_file, args.output, args.verbose)

    elif args.decode_file:
        decode_file(args.decode_file, args.output, args.verbose)


if __name__ == "__main__":
    main()
