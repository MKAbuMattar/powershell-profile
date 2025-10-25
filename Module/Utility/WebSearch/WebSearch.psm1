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
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Start-WebBrowser {
    <#
    .SYNOPSIS
        Launches a URL in the default browser or available browser.
        
    .DESCRIPTION
        This function determines the operating system and launches the provided URL
        using the most appropriate method or browser available. Supports Windows,
        macOS, and Linux with automatic browser detection.
        
    .PARAMETER Url
        The URL to open in the browser.
        
    .EXAMPLE
        Start-WebBrowser "https://www.google.com"
        Opens Google in the default browser.
        
    .EXAMPLE
        Start-WebBrowser "https://github.com"
        Opens GitHub in the default browser.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )
    
    try {
        Write-Host "Opening: $Url" -ForegroundColor Green
        
        if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
            Start-Process $Url
        }
        elseif ($IsMacOS) {
            Start-Process "open" -ArgumentList $Url
        }
        elseif ($IsLinux) {
            $browsers = @('xdg-open', 'firefox', 'chromium', 'google-chrome', 'lynx', 'links')
            $launched = $false
            
            foreach ($browser in $browsers) {
                if (Get-Command $browser -ErrorAction SilentlyContinue) {
                    if ($browser -eq 'xdg-open') {
                        Start-Process $browser -ArgumentList $Url
                    }
                    else {
                        & $browser $Url &
                    }
                    $launched = $true
                    break
                }
            }
            
            if (-not $launched) {
                Write-Host "Unable to launch browser. Please open manually:" -ForegroundColor Yellow
                Write-Host "$Url" -ForegroundColor Cyan
            }
        }
        else {
            Start-Process $Url
        }
    }
    catch {
        Write-Host "Unable to launch browser. Please open manually:" -ForegroundColor Yellow
        Write-Host "$Url" -ForegroundColor Cyan
    }
}

function Invoke-SearchEngine {
    <#
    .SYNOPSIS
        Internal function to perform a web search using Python backend.
        
    .DESCRIPTION
        This function uses the web_search.py Python backend to construct
        a search URL and then opens it in the browser. Handles all URL encoding
        and engine-specific parameter construction.
        
    .PARAMETER Engine
        The search engine to use (e.g., 'google', 'duckduckgo', 'github', 'pypi').
        
    .PARAMETER Query
        The search query string. If not provided, prompts interactively.
        
    .EXAMPLE
        Invoke-SearchEngine -Engine "google" -Query "PowerShell tutorial"
        Searches Google for PowerShell tutorial.
        
    .EXAMPLE
        Invoke-SearchEngine -Engine "github" -Query "powershell modules"
        Searches GitHub for PowerShell modules.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Engine,
        
        [Parameter(Mandatory = $false)]
        [string]$Query
    )
    
    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "web_search.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "web_search.py not found at: $pythonScript"
            return
        }

        $pythonCmd = $null
        
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                Write-Error "Please install Python 3.6 or later from https://www.python.org"
                return
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            if (-not $Query) {
                $Query = Read-Host "Enter search query"
            }

            $arguments = @($pythonScript, "--engine", $Engine, "--query", $Query)
            $output = & $pythonPath $arguments 2>&1
            $url = $null

            foreach ($line in $output) {
                if ($line -match "(https?://[^\s]+)") {
                    $url = $matches[1].Trim()
                    break
                }
            }

            if ($url) {
                Start-WebBrowser $url
            }
            else {
                Write-Error "Failed to generate search URL"
                Write-Host "Python output:" -ForegroundColor Yellow
                $output | ForEach-Object { Write-Host "  $_" }
            }
        }
        catch {
            Write-Error "Failed to perform web search: $_"
        }
    }
}

#---------------------------------------------------------------------------------------------------
# Search Engine Functions
#---------------------------------------------------------------------------------------------------

function Search-Google {
    <#
    .SYNOPSIS
        Searches Google for the specified terms.
        
    .DESCRIPTION
        Constructs a Google search URL with the provided search terms and opens
        it in the default browser.
        
    .PARAMETER SearchTerms
        The terms to search for. Multiple terms can be provided.
        
    .EXAMPLE
        Search-Google "PowerShell tutorial"
        Searches Google for PowerShell tutorial.
        
    .EXAMPLE
        Search-Google "cloud computing" "AWS"
        Searches Google for cloud computing AWS.
        
    .EXAMPLE
        google "web development"
        Using the alias to search Google.
    #>
    [CmdletBinding()]
    [Alias('wsggl', 'google')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "google" -Query ($SearchTerms -join ' ')
}

function Search-DuckDuckGo {
    <#
    .SYNOPSIS
        Searches DuckDuckGo for the specified terms.
        
    .DESCRIPTION
        Constructs a DuckDuckGo search URL with the provided search terms and opens
        it in the default browser. DuckDuckGo provides privacy-focused search.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-DuckDuckGo "PowerShell scripting"
        Searches DuckDuckGo for PowerShell scripting.
        
    .EXAMPLE
        ddg "privacy search"
        Using the alias to search DuckDuckGo.
    #>
    [CmdletBinding()]
    [Alias('wsddg', 'ddg')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "duckduckgo" -Query ($SearchTerms -join ' ')
}

function Search-Bing {
    [CmdletBinding()]
    [Alias('wsbing', 'bing')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "bing" -Query ($SearchTerms -join ' ')
}

function Search-Brave {
    <#
    .SYNOPSIS
        Searches Brave Search for the specified terms.

    .DESCRIPTION
        Constructs a Brave Search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Brave "decentralized web"
        Searches Brave Search for decentralized web.

    .EXAMPLE
        brave "blockchain technology"
        Using the alias to search Brave Search.
    #>
    [CmdletBinding()]
    [Alias('wsbrave', 'wsbrs', 'brave')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "brave" -Query ($SearchTerms -join ' ')
}

function Search-Yahoo {
    <#
    .SYNOPSIS
        Searches Yahoo for the specified terms.

    .DESCRIPTION
        Constructs a Yahoo search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Yahoo "latest news"
        Searches Yahoo for the latest news.

    .EXAMPLE
        yahoo "sports updates"
        Using the alias to search Yahoo.
    #>
    [CmdletBinding()]
    [Alias('wsyahoo', 'yahoo')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "yahoo" -Query ($SearchTerms -join ' ')
}

function Search-Startpage {
    <#
    .SYNOPSIS
        Searches Startpage for the specified terms.

    .DESCRIPTION
        Constructs a Startpage search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Startpage "private browsing"
        Searches Startpage for private browsing.

    .EXAMPLE
        startpage "anonymous search"
        Using the alias to search Startpage.
    #>
    [CmdletBinding()]
    [Alias('wssp', 'startpage')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "startpage" -Query ($SearchTerms -join ' ')
}

function Search-Yandex {
    <#
    .SYNOPSIS
        Searches Yandex for the specified terms.
    
    .DESCRIPTION
        Constructs a Yandex search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Yandex "technology news"
        Searches Yandex for technology news.

    .EXAMPLE
        yandex "latest gadgets"
        Using the alias to search Yandex.
    #>
    [CmdletBinding()]
    [Alias('wsyandex', 'yandex')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "yandex" -Query ($SearchTerms -join ' ')
}

function Search-Baidu {
    <#
    .SYNOPSIS
        Searches Baidu for the specified terms.

    .DESCRIPTION
        Constructs a Baidu search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Baidu "最新科技"
        Searches Baidu for the latest technology.

    .EXAMPLE
        baidu "人工智能"
        Using the alias to search Baidu.
    #>
    [CmdletBinding()]
    [Alias('wsbaidu', 'baidu')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "baidu" -Query ($SearchTerms -join ' ')
}

function Search-Ecosia {
    <#
    .SYNOPSIS
        Searches Ecosia for the specified terms.

    .DESCRIPTION
        Constructs an Ecosia search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Ecosia "plant trees"
        Searches Ecosia for planting trees.

    .EXAMPLE
        ecosia "environmental conservation"
        Using the alias to search Ecosia.
    #>
    [CmdletBinding()]
    [Alias('wsecosia', 'ecosia')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "ecosia" -Query ($SearchTerms -join ' ')
}

function Search-Qwant {
    <#
    .SYNOPSIS
        Searches Qwant for the specified terms.

    .DESCRIPTION
        Constructs a Qwant search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Qwant "privacy focused search"
        Searches Qwant for privacy focused search.

    .EXAMPLE
        qwant "data protection"
        Using the alias to search Qwant.
    #>
    [CmdletBinding()]
    [Alias('wsqwant', 'qwant')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "qwant" -Query ($SearchTerms -join ' ')
}

function Search-Ask {
    <#
    .SYNOPSIS
        Searches Ask.com for the specified terms.
    
    .DESCRIPTION
        Constructs an Ask.com search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Ask "general knowledge"
        Searches Ask.com for general knowledge.

    .EXAMPLE
        ask "trivia questions"
        Using the alias to search Ask.com.
    #>
    [CmdletBinding()]
    [Alias('wsask', 'ask')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "ask" -Query ($SearchTerms -join ' ')
}

#---------------------------------------------------------------------------------------------------
# Development & Technical
#---------------------------------------------------------------------------------------------------

function Search-GitHub {
    <#
    .SYNOPSIS
        Searches GitHub for the specified terms.
        
    .DESCRIPTION
        Constructs a GitHub search URL with the provided search terms and opens
        it in the default browser. Useful for finding repositories, code, and issues.
        
    .PARAMETER SearchTerms
        The terms to search for (e.g., repository names, topics, code snippets).
        
    .EXAMPLE
        Search-GitHub "powershell modules"
        Searches GitHub for PowerShell modules.
        
    .EXAMPLE
        github "aws sdk"
        Using the alias to search GitHub for AWS SDK repositories.
    #>
    [CmdletBinding()]
    [Alias('wsgh')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "github" -Query ($SearchTerms -join ' ')
}

function Search-StackOverflow {
    <#
    .SYNOPSIS
        Searches Stack Overflow for the specified terms.
        
    .DESCRIPTION
        Constructs a Stack Overflow search URL with the provided search terms and opens
        it in the default browser. Great for finding solutions to programming problems.
        
    .PARAMETER SearchTerms
        The terms to search for (e.g., programming questions, error messages, topics).
        
    .EXAMPLE
        Search-StackOverflow "PowerShell array manipulation"
        Searches Stack Overflow for array manipulation in PowerShell.
        
    .EXAMPLE
        stackoverflow "null reference exception"
        Using the alias to search for null reference exceptions.
    #>
    [CmdletBinding()]
    [Alias('wsso', 'stackoverflow')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "stackoverflow" -Query ($SearchTerms -join ' ')
}

function Search-Wikipedia {
    <#
    .SYNOPSIS
        Searches Wikipedia for the specified terms.

    .DESCRIPTION
        Constructs a Wikipedia search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Wikipedia "PowerShell scripting"
        Searches Wikipedia for PowerShell scripting.

    .EXAMPLE
        wikipedia "artificial intelligence"
        Using the alias to search Wikipedia.
    #>
    [CmdletBinding()]
    [Alias('wswiki', 'wikipedia')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "wikipedia" -Query ($SearchTerms -join ' ')
}

function Search-Scholar {
    <#
    .SYNOPSIS
        Searches Google Scholar for the specified terms.
    
    .DESCRIPTION
        Constructs a Google Scholar search URL with the provided search terms and opens
        it in the default browser. Useful for finding academic papers and articles.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Scholar "machine learning algorithms"
        Searches Google Scholar for machine learning algorithms.

    .EXAMPLE
        scholar "data science"
        Using the alias to search Google Scholar.
    #>\
    [CmdletBinding()]
    [Alias('wsscholar', 'scholar')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "scholar" -Query ($SearchTerms -join ' ')
}

function Search-Reddit {
    <#
    .SYNOPSIS
        Searches Reddit for the specified terms.

    .DESCRIPTION
        Constructs a Reddit search URL with the provided search terms and opens
        it in the default browser.

    .PARAMETER SearchTerms
        The terms to search for.

    .EXAMPLE
        Search-Reddit "PowerShell tips"
        Searches Reddit for PowerShell tips.

    .EXAMPLE
        reddit "programming help"
        Using the alias to search Reddit.
    #>
    [CmdletBinding()]
    [Alias('wsrdt', 'reddit')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "reddit" -Query ($SearchTerms -join ' ')
}

function Search-YouTube {
    <#
    .SYNOPSIS
        Searches YouTube for the specified terms.
        
    .DESCRIPTION
        Constructs a YouTube search URL with the provided search terms and opens
        it in the default browser. Find videos, tutorials, and content.
        
    .PARAMETER SearchTerms
        The terms to search for (video titles, topics, keywords).
        
    .EXAMPLE
        Search-YouTube "PowerShell tutorial"
        Searches YouTube for PowerShell tutorials.
        
    .EXAMPLE
        youtube "python beginners"
        Using the alias to search for Python beginner videos.
    #>
    [CmdletBinding()]
    [Alias('wsyt', 'wsyoutube', 'youtube')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "youtube" -Query ($SearchTerms -join ' ')
}

function Search-DockerHub {
    [CmdletBinding()]
    [Alias('wsdocker', 'docker', 'dockerhub')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "dockerhub" -Query ($SearchTerms -join ' ')
}

function Search-NPM {
    <#
    .SYNOPSIS
        Searches NPM (Node Package Manager) for the specified terms.
        
    .DESCRIPTION
        Constructs an NPM search URL with the provided search terms and opens
        it in the default browser. Search for Node.js packages and modules.
        
    .PARAMETER SearchTerms
        The terms to search for (package names, keywords, or topics).
        
    .EXAMPLE
        Search-NPM "express"
        Searches NPM for the Express.js package.
        
    .EXAMPLE
        npm "rest api"
        Using the alias to search for REST API packages.
    #>
    [CmdletBinding()]
    [Alias('wsnpm')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "npm" -Query ($SearchTerms -join ' ')
}

function Search-Packagist {
    <#
    .SYNOPSIS
        Searches Packagist for the specified terms.

    .DESCRIPTION
        Constructs a Packagist search URL with the provided search terms and opens
        it in the default browser. Search for PHP packages and libraries.

    .PARAMETER SearchTerms
        The terms to search for (package names, keywords, or topics).

    .EXAMPLE
        Search-Packagist "laravel"
        Searches Packagist for the Laravel package.

    .EXAMPLE
        packagist "authentication"
        Using the alias to search for authentication packages.
    #>
    [CmdletBinding()]
    [Alias('wspackagist')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "packagist" -Query ($SearchTerms -join ' ')
}

function Search-GoPackages {
    <#
    .SYNOPSIS
        Searches Go Packages for the specified terms.

    .DESCRIPTION
        Constructs a Go Packages search URL with the provided search terms and opens
        it in the default browser. Search for Go libraries and modules.

    .PARAMETER SearchTerms
        The terms to search for (package names, keywords, or topics).

    .EXAMPLE
        Search-GoPackages "gin"
        Searches Go Packages for the Gin web framework.

    .EXAMPLE
        gopkg "http server"
        Using the alias to search for HTTP server packages.
    #>
    [CmdletBinding()]
    [Alias('wsgopkg', 'gopkg')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "gopkg" -Query ($SearchTerms -join ' ')
}

function Search-RustCrates {
    <#
    .SYNOPSIS
        Searches Rust Crates for the specified terms.

    .DESCRIPTION
        Constructs a Rust Crates search URL with the provided search terms and opens
        it in the default browser. Search for Rust libraries and packages.

    .PARAMETER SearchTerms
        The terms to search for (package names, keywords, or topics).

    .EXAMPLE
        Search-RustCrates "serde"
        Searches Rust Crates for the Serde library.

    .EXAMPLE
        rscrate "json parsing"
        Using the alias to search for JSON parsing crates.
    #>
    [CmdletBinding()]
    [Alias('wsrscrate', 'rscrate')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "rscrate" -Query ($SearchTerms -join ' ')
}

function Search-RustDocs {
    <#
    .SYNOPSIS
        Searches Rust Docs for the specified terms.

    .DESCRIPTION
        Constructs a Rust Docs search URL with the provided search terms and opens
        it in the default browser. Search for Rust documentation and references.

    .PARAMETER SearchTerms
        The terms to search for (documentation topics, functions, or keywords).

    .EXAMPLE
        Search-RustDocs "Vec"
        Searches Rust Docs for the Vec documentation.

    .EXAMPLE
        rsdoc "error handling"
        Using the alias to search for error handling documentation.
    #>
    [CmdletBinding()]
    [Alias('wsrsdoc', 'rsdoc')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "rsdoc" -Query ($SearchTerms -join ' ')
}

function Search-PyPI {
    <#
    .SYNOPSIS
        Searches PyPI (Python Package Index) for the specified terms.
        
    .DESCRIPTION
        Constructs a PyPI search URL with the provided search terms and opens
        it in the default browser. Search for Python packages and libraries.
        
    .PARAMETER SearchTerms
        The terms to search for (package names, keywords, or topics).
        
    .EXAMPLE
        Search-PyPI "requests"
        Searches PyPI for the Requests library.
        
    .EXAMPLE
        pypi "machine learning"
        Using the alias to search for machine learning packages.
    #>
    [CmdletBinding()]
    [Alias('wspypi', 'pypi')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "pypi" -Query ($SearchTerms -join ' ')
}

#---------------------------------------------------------------------------------------------------
# AI Assistants
#---------------------------------------------------------------------------------------------------

function Search-ChatGPT {
    <#
    .SYNOPSIS
        Opens ChatGPT with search query context.
        
    .DESCRIPTION
        Constructs a ChatGPT URL with the provided query and opens
        it in the default browser. Great for AI-powered assistance and conversations.
        
    .PARAMETER SearchTerms
        The terms or question to provide to ChatGPT.
        
    .EXAMPLE
        Search-ChatGPT "how to write PowerShell functions"
        Opens ChatGPT with a question about PowerShell.
        
    .EXAMPLE
        chatgpt "explain REST APIs"
        Using the alias to ask ChatGPT about REST APIs.
    #>
    [CmdletBinding()]
    [Alias('wschatgpt', 'chatgpt')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "chatgpt" -Query ($SearchTerms -join ' ')
}

function Search-Claude {
    <#
    .SYNOPSIS
        Opens Claude AI with search query context.

    .DESCRIPTION
        Constructs a Claude AI URL with the provided query and opens
        it in the default browser. Useful for AI-driven conversations and assistance.

    .PARAMETER SearchTerms
        The terms or question to provide to Claude.

    .EXAMPLE
        Search-Claude "What is the capital of France?"
        Opens Claude AI with a question about the capital of France.

    .EXAMPLE
        claude "Explain quantum computing"
        Using the alias to ask Claude about quantum computing.
    #>
    [CmdletBinding()]
    [Alias('wschaude', 'claude')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "claude" -Query ($SearchTerms -join ' ')
}

function Search-Perplexity {
    <#
    .SYNOPSIS
        Opens Perplexity AI with search query context.

    .DESCRIPTION
        Constructs a Perplexity AI URL with the provided query and opens
        it in the default browser. Useful for AI-driven information retrieval.

    .PARAMETER SearchTerms
        The terms or question to provide to Perplexity.

    .EXAMPLE
        Search-Perplexity "Explain machine learning"
        Opens Perplexity AI with a question about machine learning.

    .EXAMPLE
        perplexity "What is the meaning of life?"
        Using the alias to ask Perplexity about the meaning of life.
    #>
    [CmdletBinding()]
    [Alias('wsppai', 'wsperplexity', 'perplexity')]
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$SearchTerms)
    Invoke-SearchEngine -Engine "perplexity" -Query ($SearchTerms -join ' ')
}

#---------------------------------------------------------------------------------------------------
# Testing & Utilities
#---------------------------------------------------------------------------------------------------

function Test-SearchService {
    <#
    .SYNOPSIS
        Test connectivity to web search services.

    .DESCRIPTION
        This function tests the connectivity to various web search services
        by invoking the Python backend with a test flag. It returns $true if
        all services are reachable, otherwise $false.

    .EXAMPLE
        Test-SearchService
        Tests connectivity to web search services.

    .OUTPUTS
        Boolean. Returns $true if all services are reachable, $false otherwise.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "web_search.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "web_search.py not found at: $pythonScript"
            return $false
        }

        $pythonCmd = $null
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                return $false
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            & $pythonPath $pythonScript --test 2>&1
            if ($LASTEXITCODE -eq 0) {
                return $true
            }
            else {
                return $false
            }
        }
        catch {
            Write-Error "Error testing search services: $_"
            return $false
        }
    }
}

function Get-SearchEngines {
    <#
    .SYNOPSIS
        Lists all available search engines.

    .DESCRIPTION
        This function retrieves and displays a list of all supported search engines
        from the Python backend.

    .EXAMPLE
        Get-SearchEngines
        Lists all available search engines.
    #>
    [CmdletBinding()]
    param()

    begin {
        $scriptDir = Split-Path -Parent $PSCommandPath
        $pythonScript = Join-Path $scriptDir "web_search.py"

        if (-not (Test-Path $pythonScript)) {
            Write-Error "web_search.py not found at: $pythonScript"
            return
        }

        $pythonCmd = $null
        try {
            $pythonCmd = Get-Command python -ErrorAction Stop
        }
        catch {
            try {
                $pythonCmd = Get-Command python3 -ErrorAction Stop
            }
            catch {
                Write-Error "Python is not installed or not available in PATH"
                return
            }
        }

        $pythonPath = $pythonCmd.Source
    }

    process {
        try {
            & $pythonPath $pythonScript --list-engines
        }
        catch {
            Write-Error "Error retrieving search engines: $_"
        }
    }
}

#---------------------------------------------------------------------------------------------------
# Main Search Function
#---------------------------------------------------------------------------------------------------

function Start-WebSearch {
    <#
    .SYNOPSIS
        Performs a web search with optional engine selection.
        
    .DESCRIPTION
        This function provides an easy way to search using various search engines.
        If an engine is specified, it performs a direct search. Otherwise, it prompts
        for engine and search terms.
        
    .PARAMETER Engine
        Optional search engine name (google, duckduckgo, github, etc.).
        
    .PARAMETER Query
        The search query string.
        
    .EXAMPLE
        Start-WebSearch
        Prompts for search engine and query.
        
    .EXAMPLE
        Start-WebSearch -Engine google -Query "PowerShell tutorial"
        Directly searches Google.
        
    .EXAMPLE
        Start-WebSearch -Engine github -Query "powershell modules"
        Searches GitHub for PowerShell modules.
    #>
    [CmdletBinding()]
    [Alias('web-search', 'ws')]
    param(
        [Parameter(Position = 0)]
        [string]$Engine,
        
        [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
        [string[]]$Query
    )

    if ($Engine) {
        $queryString = ($Query -join ' ')
        if (-not $queryString) {
            Write-Host "Enter search query: " -NoNewline -ForegroundColor Cyan
            $queryString = Read-Host
        }
        Invoke-SearchEngine -Engine $Engine -Query $queryString
    }
    else {
        Write-Host ""
        Write-Host "Select a Search Engine:" -ForegroundColor Magenta
        Write-Host ""
        
        $engines = @(
            @{ name = "Google"; key = "google" },
            @{ name = "DuckDuckGo"; key = "duckduckgo" },
            @{ name = "Bing"; key = "bing" },
            @{ name = "Brave"; key = "brave" },
            @{ name = "GitHub"; key = "github" },
            @{ name = "Stack Overflow"; key = "stackoverflow" },
            @{ name = "Wikipedia"; key = "wikipedia" },
            @{ name = "YouTube"; key = "youtube" },
            @{ name = "Reddit"; key = "reddit" },
            @{ name = "ChatGPT"; key = "chatgpt" },
            @{ name = "Claude"; key = "claude" },
            @{ name = "Perplexity"; key = "perplexity" },
            @{ name = "List All Engines"; key = "list" },
            @{ name = "Quit"; key = "quit" }
        )
        
        for ($i = 0; $i -lt $engines.Count; $i++) {
            Write-Host "$($i + 1). $($engines[$i].name)" -ForegroundColor Cyan
        }
        
        Write-Host ""
        $selection = Read-Host "Enter your choice (1-$($engines.Count))"
        
        if ($selection -eq $engines.Count) {
            return
        }
        
        $selectedIndex = [int]$selection - 1
        
        if ($selectedIndex -lt 0 -or $selectedIndex -ge $engines.Count) {
            Write-Host "Invalid selection" -ForegroundColor Red
            return
        }
        
        $selectedEngine = $engines[$selectedIndex].key
        
        if ($selectedEngine -eq "list") {
            Get-SearchEngines
            return
        }
        
        if ($selectedEngine -eq "quit") {
            Write-Host "Goodbye! 👋" -ForegroundColor Yellow
            return
        }
        
        Invoke-SearchEngine -Engine $selectedEngine
    }
}
