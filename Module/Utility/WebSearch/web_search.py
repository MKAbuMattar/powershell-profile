#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - WebSearch Plugin
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
#       This module provides web search functionality for various search engines.
#       Supports URL encoding and multiple search engine options.
#
# Created: 2025-10-25
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

"""
Web Search CLI

Construct and display search URLs for various search engines.

Usage:
    python3 web_search.py --engine google --query "Python tutorial"
    python3 web_search.py -e duckduckgo -q "web development"
    python3 web_search.py --list-engines
    python3 web_search.py --test
"""

import sys
import argparse
import urllib.parse
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
    BLACK = '\033[30m'
    WHITE = '\033[97m'
    GRAY = '\033[90m'
    RESET = '\033[0m'


# ===== Search Engine Definitions =====
SEARCH_ENGINES = {
    # General Search Engines
    "google": {
        "name": "Google",
        "url": "https://www.google.com/search",
        "param": "q"
    },
    "bing": {
        "name": "Bing",
        "url": "https://www.bing.com/search",
        "param": "q"
    },
    "brave": {
        "name": "Brave Search",
        "url": "https://search.brave.com/search",
        "param": "q"
    },
    "duckduckgo": {
        "name": "DuckDuckGo",
        "url": "https://duckduckgo.com/",
        "param": "q"
    },
    "startpage": {
        "name": "Startpage",
        "url": "https://www.startpage.com/do/search",
        "param": "q"
    },
    "yahoo": {
        "name": "Yahoo",
        "url": "https://search.yahoo.com/search",
        "param": "p"
    },
    "yandex": {
        "name": "Yandex",
        "url": "https://yandex.ru/yandsearch",
        "param": "text"
    },
    "baidu": {
        "name": "Baidu",
        "url": "https://www.baidu.com/s",
        "param": "wd"
    },
    "ecosia": {
        "name": "Ecosia",
        "url": "https://www.ecosia.org/search",
        "param": "q"
    },
    "qwant": {
        "name": "Qwant",
        "url": "https://www.qwant.com/",
        "param": "q"
    },
    "ask": {
        "name": "Ask.com",
        "url": "https://www.ask.com/web",
        "param": "q"
    },

    # Development & Technical
    "github": {
        "name": "GitHub",
        "url": "https://github.com/search",
        "param": "q"
    },
    "stackoverflow": {
        "name": "Stack Overflow",
        "url": "https://stackoverflow.com/search",
        "param": "q"
    },
    "scholar": {
        "name": "Google Scholar",
        "url": "https://scholar.google.com/scholar",
        "param": "q"
    },
    "wikipedia": {
        "name": "Wikipedia",
        "url": "https://en.wikipedia.org/w/index.php",
        "param": "search"
    },
    "reddit": {
        "name": "Reddit",
        "url": "https://www.reddit.com/search/",
        "param": "q"
    },
    "youtube": {
        "name": "YouTube",
        "url": "https://www.youtube.com/results",
        "param": "search_query"
    },
    "dockerhub": {
        "name": "Docker Hub",
        "url": "https://hub.docker.com/search",
        "param": "q"
    },
    "npm": {
        "name": "NPM",
        "url": "https://www.npmjs.com/search",
        "param": "q"
    },
    "packagist": {
        "name": "Packagist",
        "url": "https://packagist.org/",
        "param": "query"
    },
    "pypi": {
        "name": "PyPI",
        "url": "https://pypi.org/search/",
        "param": "q"
    },
    "gopkg": {
        "name": "Go Packages",
        "url": "https://pkg.go.dev/search",
        "param": "q",
        "extra_param": ("m", "package")
    },
    "rscrate": {
        "name": "Rust Crates",
        "url": "https://crates.io/search",
        "param": "q"
    },
    "rsdoc": {
        "name": "Rust Docs",
        "url": "https://docs.rs/releases/search",
        "param": "query"
    },

    # AI Assistants
    "chatgpt": {
        "name": "ChatGPT",
        "url": "https://chatgpt.com/",
        "param": "q"
    },
    "claude": {
        "name": "Claude AI",
        "url": "https://claude.ai/new",
        "param": "q"
    },
    "perplexity": {
        "name": "Perplexity AI",
        "url": "https://www.perplexity.ai/search/new",
        "param": "q"
    }
}

# Aliases for search engines
ALIASES = {
    "ddg": "duckduckgo",
    "sp": "startpage",
    "so": "stackoverflow",
    "docker": "dockerhub",
    "gopkg": "gopkg",
    "ppai": "perplexity",
    "rscrate": "rscrate",
    "rsdoc": "rsdoc",
    "yt": "youtube",
    "pip": "pypi"
}



def build_search_url(engine_name, query, verbose=False):
    """
    Build a search URL for the specified engine and query.

    Args:
        engine_name: Search engine key
        query: Search query string
        verbose: Enable verbose output

    Returns:
        str: Constructed search URL
    """
    # Resolve aliases
    engine_name = ALIASES.get(engine_name.lower(), engine_name.lower())

    if engine_name not in SEARCH_ENGINES:
        print(f"{Colors.RED}[-]{Colors.RESET} Unknown search engine: {engine_name}")
        print(f"{Colors.YELLOW}[!]{Colors.RESET} Available engines: {', '.join(sorted(SEARCH_ENGINES.keys()))}")
        return None

    engine = SEARCH_ENGINES[engine_name]

    if verbose:
        print(f"{Colors.DIM}Building search URL...{Colors.RESET}")
        print(f"{Colors.DIM}  → Engine: {engine['name']}{Colors.RESET}")
        print(f"{Colors.DIM}  → Query: {query}{Colors.RESET}")

    # URL encode the query
    encoded_query = urllib.parse.quote(query)

    # Build URL with parameters
    url = engine["url"]

    # Add extra parameter if specified (like for Go packages)
    if "extra_param" in engine:
        param_name, param_value = engine["extra_param"]
        url += f"?{param_name}={param_value}&{engine['param']}={encoded_query}"
    else:
        url += f"?{engine['param']}={encoded_query}"

    if verbose:
        print(f"{Colors.DIM}  → URL: {url}{Colors.RESET}")

    return url


def display_search_url(url, engine_name):
    """
    Display search URL in a formatted way.

    Args:
        url: Search URL to display
        engine_name: Search engine name for context
    """
    engine_name = ALIASES.get(engine_name.lower(), engine_name.lower())
    if engine_name in SEARCH_ENGINES:
        engine_display = SEARCH_ENGINES[engine_name]["name"]
    else:
        engine_display = engine_name

    print(f"{Colors.GREEN}[+]{Colors.RESET} Search URL ({engine_display}):")
    print(f"{Colors.CYAN}{url}{Colors.RESET}")


def test_search_service():
    """Test connectivity to a few major search engines."""
    engines_to_test = ["google", "duckduckgo", "bing"]
    all_accessible = True

    for engine_name in engines_to_test:
        engine = SEARCH_ENGINES[engine_name]
        try:
            request = urllib.request.Request(
                engine["url"],
                headers={'User-Agent': 'PowerShell-Profile/4.2.0'}
            )
            with urllib.request.urlopen(request, timeout=5) as response:
                if response.status == 200:
                    print(f"{Colors.GREEN}[+]{Colors.RESET} {engine['name']} is accessible")
                else:
                    print(f"{Colors.YELLOW}[!]{Colors.RESET} {engine['name']} returned HTTP {response.status}")
                    all_accessible = False
        except urllib.error.URLError as e:
            print(f"{Colors.RED}[-]{Colors.RESET} {engine['name']} is not accessible: {e}")
            all_accessible = False
        except Exception as e:
            print(f"{Colors.RED}[-]{Colors.RESET} Error testing {engine['name']}: {e}")
            all_accessible = False

    return all_accessible


def list_engines():
    """List all available search engines."""
    print(f"{Colors.BOLD}Available Search Engines:{Colors.RESET}\n")

    categories = {
        "General Search": ["google", "bing", "brave", "duckduckgo", "startpage",
                          "yahoo", "yandex", "baidu", "ecosia", "qwant", "ask"],
        "Development & Technical": ["github", "stackoverflow", "scholar", "wikipedia",
                                   "reddit", "youtube", "dockerhub", "npm", "packagist", "pypi",
                                   "gopkg", "rscrate", "rsdoc"],
        "AI Assistants": ["chatgpt", "claude", "perplexity"]
    }

    for category, engines in categories.items():
        print(f"{Colors.BOLD}{category}:{Colors.RESET}")
        for engine_key in engines:
            engine = SEARCH_ENGINES[engine_key]
            print(f"  {Colors.CYAN}{engine_key:15}{Colors.RESET} - {engine['name']}")
        print()

    print(f"{Colors.BOLD}Aliases:{Colors.RESET}")
    for alias, target in sorted(ALIASES.items()):
        target_name = SEARCH_ENGINES[target]["name"]
        print(f"  {Colors.CYAN}{alias:15}{Colors.RESET} → {target_name}")


def main():
    """Main entry point for Web Search."""
    parser = argparse.ArgumentParser(
        description="Construct search URLs for various search engines",
        prog="web_search.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --engine google --query "Python tutorial"
  %(prog)s -e duckduckgo -q "web development"
  %(prog)s --engine stackoverflow --query "PowerShell arrays"
  %(prog)s --list-engines                              # Show all engines
  %(prog)s --test                                      # Test service availability

Aliases: ddg→duckduckgo, sp→startpage, so→stackoverflow, docker→dockerhub,
         yt→youtube, ppai→perplexity, rscrate→rscrate, rsdoc→rsdoc
        """
    )

    parser.add_argument(
        "-e", "--engine",
        default="google",
        help="Search engine to use (default: google)"
    )

    parser.add_argument(
        "-q", "--query",
        help="Search query string"
    )

    parser.add_argument(
        "--list-engines",
        action="store_true",
        help="List all available search engines and exit"
    )

    parser.add_argument(
        "--test",
        action="store_true",
        help="Test connectivity to search engines"
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )

    args = parser.parse_args()

    # List engines mode
    if args.list_engines:
        list_engines()
        sys.exit(0)

    # Test service mode
    if args.test:
        success = test_search_service()
        sys.exit(0 if success else 1)

    # Search mode - query is required
    if not args.query:
        print(f"{Colors.RED}[-]{Colors.RESET} No search query provided")
        print(f"{Colors.YELLOW}[!]{Colors.RESET} Use --query to specify search terms")
        print(f"{Colors.YELLOW}[!]{Colors.RESET} Use --list-engines to see available options")
        sys.exit(1)

    # Build and display search URL
    url = build_search_url(args.engine, args.query, args.verbose)

    if url:
        display_search_url(url, args.engine)
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
