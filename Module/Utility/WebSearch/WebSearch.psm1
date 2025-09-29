#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - WebSearch Utility Module
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
#       This module provides web search functionality for various search engines with
#       cross-platform browser launching capabilities.
#
# Created: 2025-09-28
# Updated: 2025-09-28
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function ConvertTo-UrlEncoded {
    <#
    .SYNOPSIS
        URL encodes a string for safe use in URLs.
        
    .DESCRIPTION
        This function URL encodes a string by converting special characters to their
        percent-encoded equivalents, making it safe for use in URLs.
        
    .PARAMETER InputString
        The string to be URL encoded.
        
    .EXAMPLE
        ConvertTo-UrlEncoded "hello world"
        Returns "hello%20world"
        
    .EXAMPLE
        ConvertTo-UrlEncoded "C++ programming"
        Returns "C%2B%2B%20programming"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$InputString
    )
    
    process {
        Add-Type -AssemblyName System.Web
        return [System.Web.HttpUtility]::UrlEncode($InputString)
    }
}

function Start-WebBrowser {
    <#
    .SYNOPSIS
        Launches a URL in the default browser or available browser.
        
    .DESCRIPTION
        This function determines the operating system and launches the provided URL
        using the most appropriate method or browser available.
        
    .PARAMETER Url
        The URL to open in the browser.
        
    .EXAMPLE
        Start-WebBrowser "https://www.google.com"
        Opens Google in the default browser.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )
    
    try {
        if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
            Start-Process $Url
            Write-Host "Launching $Url in default browser..." -ForegroundColor Green
        }
        elseif ($IsMacOS) {
            Start-Process "open" -ArgumentList $Url
            Write-Host "Launching $Url in default browser..." -ForegroundColor Green
        }
        elseif ($IsLinux) {
            $browsers = @('xdg-open', 'lynx', 'browsh', 'links2', 'links')
            $launched = $false
            
            foreach ($browser in $browsers) {
                if (Get-Command $browser -ErrorAction SilentlyContinue) {
                    if ($browser -eq 'xdg-open') {
                        Start-Process $browser -ArgumentList $Url
                        Write-Host "Launching $Url" -ForegroundColor Green
                        Write-Host "Press [Enter] to continue..." -ForegroundColor Gray
                    }
                    else {
                        & $browser $Url
                    }
                    $launched = $true
                    break
                }
            }
            
            if (-not $launched) {
                Write-Host "Unable to launch browser, please open manually:" -ForegroundColor Yellow
                Write-Host "URL: $Url" -ForegroundColor Cyan
            }
        }
        else {
            Start-Process $Url
            Write-Host "Launching $Url..." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Unable to launch browser automatically. Please open manually:" -ForegroundColor Yellow
        Write-Host "URL: $Url" -ForegroundColor Cyan
    }
}

function Invoke-WebSearch {
    <#
    .SYNOPSIS
        Performs a web search using the specified search engine and query.
        
    .DESCRIPTION
        This function constructs a search URL using the provided search engine base URL
        and search terms, then launches it in the browser.
        
    .PARAMETER SearchEngineUrl
        The base URL for the search engine (e.g., 'https://www.google.com/search?q=').
        
    .PARAMETER SearchTerms
        The search terms to encode and append to the URL.
        
    .EXAMPLE
        Invoke-WebSearch 'https://www.google.com/search?q=' 'PowerShell tutorial'
        Searches Google for 'PowerShell tutorial'.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SearchEngineUrl,
        
        [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    if (-not $SearchEngineUrl) {
        Write-Error "No search engine URL provided"
        return
    }
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter Search Term"
    }
    
    $searchQuery = ($SearchTerms -join ' ')
    $encodedQuery = ConvertTo-UrlEncoded $searchQuery
    $webAddress = "$SearchEngineUrl$encodedQuery"
    
    Start-WebBrowser $webAddress
}

function Search-DuckDuckGo {
    <#
    .SYNOPSIS
        Search DuckDuckGo for the specified terms.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-DuckDuckGo "PowerShell tutorial"
    #>
    [CmdletBinding()]
    [Alias('wsddg')]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    Invoke-WebSearch 'https://duckduckgo.com/?q=' $SearchTerms
}

function Search-Wikipedia {
    <#
    .SYNOPSIS
        Search Wikipedia for the specified terms.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-Wikipedia "PowerShell"
    #>
    [CmdletBinding()]
    [Alias('wswiki')]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    Invoke-WebSearch 'https://en.wikipedia.org/w/index.php?search=' $SearchTerms
}

function Search-Google {
    <#
    .SYNOPSIS
        Search Google for the specified terms.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-Google "PowerShell tutorial"
    #>
    [CmdletBinding()]
    [Alias('wsggl')]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    Invoke-WebSearch 'https://www.google.com/search?q=' $SearchTerms
}

function Search-GitHub {
    <#
    .SYNOPSIS
        Search GitHub for the specified terms.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-GitHub "PowerShell modules"
    #>
    [CmdletBinding()]
    [Alias('wsgh')]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    Invoke-WebSearch 'https://github.com/search?q=' $SearchTerms
}

function Search-StackOverflow {
    <#
    .SYNOPSIS
        Search Stack Overflow for the specified terms.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-StackOverflow "PowerShell array"
    #>
    [CmdletBinding()]
    [Alias('wsso')]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    Invoke-WebSearch 'https://stackoverflow.com/search?q=' $SearchTerms
}



function Search-Reddit {
    <#
    .SYNOPSIS
        Search Reddit for the specified terms.
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Search-Reddit "PowerShell tips"
    #>
    [CmdletBinding()]
    [Alias('wsrdt')]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    
    Invoke-WebSearch 'https://www.reddit.com/search/?q=' $SearchTerms
}





function Search-Bing {
    <#
    .SYNOPSIS
        Searches using Bing.
    #>
    [CmdletBinding()]
    [Alias('wsbing')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Bing"
    }
    Invoke-WebSearch 'https://www.bing.com/search?q=' $SearchTerms
}

function Search-Brave {
    <#
    .SYNOPSIS
        Searches using Brave.
    #>
    [CmdletBinding()]
    [Alias('wsbrave', 'wsbrs')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Brave"
    }
    Invoke-WebSearch 'https://search.brave.com/search?q=' $SearchTerms
}

function Search-Yahoo {
    <#
    .SYNOPSIS
        Searches using Yahoo.
    #>
    [CmdletBinding()]
    [Alias('wsyahoo')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Yahoo"
    }
    Invoke-WebSearch 'https://search.yahoo.com/search?p=' $SearchTerms
}

function Search-Startpage {
    <#
    .SYNOPSIS
        Searches using Startpage.
    #>
    [CmdletBinding()]
    [Alias('wssp')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Startpage"
    }
    Invoke-WebSearch 'https://www.startpage.com/do/search?q=' $SearchTerms
}

function Search-Yandex {
    <#
    .SYNOPSIS
        Searches using Yandex.
    #>
    [CmdletBinding()]
    [Alias('wsyandex')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Yandex"
    }
    Invoke-WebSearch 'https://yandex.ru/yandsearch?text=' $SearchTerms
}

function Search-Baidu {
    <#
    .SYNOPSIS
        Searches using Baidu.
    #>
    [CmdletBinding()]
    [Alias('wsbaidu')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Baidu"
    }
    Invoke-WebSearch 'https://www.baidu.com/s?wd=' $SearchTerms
}

function Search-Ecosia {
    <#
    .SYNOPSIS
        Searches using Ecosia.
    #>
    [CmdletBinding()]
    [Alias('wsecosia')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Ecosia"
    }
    Invoke-WebSearch 'https://www.ecosia.org/search?q=' $SearchTerms
}

function Search-Qwant {
    <#
    .SYNOPSIS
        Searches using Qwant.
    #>
    [CmdletBinding()]
    [Alias('wsqwant')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Qwant"
    }
    Invoke-WebSearch 'https://www.qwant.com/?q=' $SearchTerms
}

function Search-Scholar {
    <#
    .SYNOPSIS
        Searches using Google Scholar.
    #>
    [CmdletBinding()]
    [Alias('wsscholar')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Google Scholar"
    }
    Invoke-WebSearch 'https://scholar.google.com/scholar?q=' $SearchTerms
}

function Search-Ask {
    <#
    .SYNOPSIS
        Searches using Ask.com.
    #>
    [CmdletBinding()]
    [Alias('wsask')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Ask.com"
    }
    Invoke-WebSearch 'https://www.ask.com/web?q=' $SearchTerms
}

function Search-YouTube {
    <#
    .SYNOPSIS
        Searches using YouTube.
    #>
    [CmdletBinding()]
    [Alias('wsyt', 'wsyoutube')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for YouTube"
    }
    Invoke-WebSearch 'https://www.youtube.com/results?search_query=' $SearchTerms
}

function Search-DockerHub {
    <#
    .SYNOPSIS
        Searches using Docker Hub.
    #>
    [CmdletBinding()]
    [Alias('wsdocker')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Docker Hub"
    }
    Invoke-WebSearch 'https://hub.docker.com/search?q=' $SearchTerms
}

function Search-NPM {
    <#
    .SYNOPSIS
        Searches using NPM packages.
    #>
    [CmdletBinding()]
    [Alias('wsnpm')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for NPM"
    }
    Invoke-WebSearch 'https://www.npmjs.com/search?q=' $SearchTerms
}

function Search-Packagist {
    <#
    .SYNOPSIS
        Searches using Packagist (PHP packages).
    #>
    [CmdletBinding()]
    [Alias('wspackagist')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Packagist"
    }
    Invoke-WebSearch 'https://packagist.org/?query=' $SearchTerms
}

function Search-GoPackages {
    <#
    .SYNOPSIS
        Searches using Go packages.
    #>
    [CmdletBinding()]
    [Alias('wsgopkg')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Go packages"
    }
    Invoke-WebSearch 'https://pkg.go.dev/search?m=package&q=' $SearchTerms
}

function Search-ChatGPT {
    <#
    .SYNOPSIS
        Opens ChatGPT with search query.
    #>
    [CmdletBinding()]
    [Alias('wschatgpt')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for ChatGPT"
    }
    Invoke-WebSearch 'https://chatgpt.com/?q=' $SearchTerms
}

function Search-Claude {
    <#
    .SYNOPSIS
        Opens Claude AI with search query.
    #>
    [CmdletBinding()]
    [Alias('wschaude')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Claude AI"
    }
    Invoke-WebSearch 'https://claude.ai/new?q=' $SearchTerms
}

function Search-Perplexity {
    <#
    .SYNOPSIS
        Searches using Perplexity AI.
    #>
    [CmdletBinding()]
    [Alias('wsppai', 'wsperplexity')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Perplexity AI"
    }
    Invoke-WebSearch 'https://www.perplexity.ai/search/new?q=' $SearchTerms
}

function Search-RustCrates {
    <#
    .SYNOPSIS
        Searches Rust crates.
    #>
    [CmdletBinding()]
    [Alias('wsrscrate')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Rust crates"
    }
    Invoke-WebSearch 'https://crates.io/search?q=' $SearchTerms
}

function Search-RustDocs {
    <#
    .SYNOPSIS
        Searches Rust documentation.
    #>
    [CmdletBinding()]
    [Alias('wsrsdoc')]
    param([string[]]$SearchTerms)
    
    if (-not $SearchTerms) {
        $SearchTerms = Read-Host "Enter search terms for Rust docs"
    }
    Invoke-WebSearch 'https://docs.rs/releases/search?query=' $SearchTerms
}

function Start-WebSearch {
    <#
    .SYNOPSIS
        Interactive web search with multiple search engine options.
        
    .DESCRIPTION
        This function provides an interactive menu for selecting search engines
        or allows direct invocation with search engine names and terms.
        
    .PARAMETER SearchEngine
        Optional search engine name (duckduckgo, google, github, etc.).
        
    .PARAMETER SearchTerms
        The terms to search for.
        
    .EXAMPLE
        Start-WebSearch
        Shows interactive menu.
        
    .EXAMPLE
        Start-WebSearch google "PowerShell tutorial"
        Directly searches Google.
        
    .EXAMPLE
        Start-WebSearch duckduckgo
        Opens DuckDuckGo search, prompts for terms.
    #>
    [CmdletBinding()]
    [Alias('web-search', 'ws')]
    param(
        [Parameter(Position = 0)]
        [string]$SearchEngine,
        
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$SearchTerms
    )
    

    
    if ($SearchEngine) {
        switch ($SearchEngine.ToLower()) {
            'duckduckgo' { Search-DuckDuckGo $SearchTerms; return }
            'ddg' { Search-DuckDuckGo $SearchTerms; return }
            'wikipedia' { Search-Wikipedia $SearchTerms; return }
            'google' { Search-Google $SearchTerms; return }
            'github' { Search-GitHub $SearchTerms; return }
            'stackoverflow' { Search-StackOverflow $SearchTerms; return }
            'reddit' { Search-Reddit $SearchTerms; return }
            'bing' { Search-Bing $SearchTerms; return }
            'brave' { Search-Brave $SearchTerms; return }
            'yahoo' { Search-Yahoo $SearchTerms; return }
            'startpage' { Search-Startpage $SearchTerms; return }
            'sp' { Search-Startpage $SearchTerms; return }
            'yandex' { Search-Yandex $SearchTerms; return }
            'baidu' { Search-Baidu $SearchTerms; return }
            'ecosia' { Search-Ecosia $SearchTerms; return }
            'qwant' { Search-Qwant $SearchTerms; return }
            'scholar' { Search-Scholar $SearchTerms; return }
            'ask' { Search-Ask $SearchTerms; return }
            'youtube' { Search-YouTube $SearchTerms; return }
            'dockerhub' { Search-DockerHub $SearchTerms; return }
            'npm' { Search-NPM $SearchTerms; return }
            'packagist' { Search-Packagist $SearchTerms; return }
            'gopkg' { Search-GoPackages $SearchTerms; return }
            'chatgpt' { Search-ChatGPT $SearchTerms; return }
            'claude' { Search-Claude $SearchTerms; return }
            'perplexity' { Search-Perplexity $SearchTerms; return }
            'ppai' { Search-Perplexity $SearchTerms; return }
            'rscrate' { Search-RustCrates $SearchTerms; return }
            'rsdoc' { Search-RustDocs $SearchTerms; return }
            default {
                Write-Host "Unknown search engine: $SearchEngine" -ForegroundColor Red
                Write-Host "Available engines: google, bing, brave, yahoo, duckduckgo, startpage, yandex, baidu, ecosia, qwant, github, stackoverflow, scholar, ask, youtube, wikipedia, reddit, dockerhub, npm, packagist, gopkg, chatgpt, claude, perplexity, rscrate, rsdoc" -ForegroundColor Yellow
                return
            }
        }
    }
    
    $choices = @(
        'Google', 'Bing', 'Brave', 'DuckDuckGo', 'Startpage',
        'GitHub', 'StackOverflow', 'Wikipedia', 'Scholar', 'YouTube',
        'Reddit', 'ChatGPT', 'Claude AI', 'Perplexity', 'More Options', 'Quit'
    )
    
    Write-Host "Select a Search Option" -ForegroundColor Magenta
    for ($i = 0; $i -lt $choices.Count; $i++) {
        Write-Host "$($i + 1). $($choices[$i])" -ForegroundColor Cyan
    }
    
    do {
        $selection = Read-Host "Enter your choice (1-$($choices.Count))"
        
        switch ($selection) {
            '1' { Search-Google $SearchTerms; return }
            '2' { Search-Bing $SearchTerms; return }
            '3' { Search-Brave $SearchTerms; return }
            '4' { Search-DuckDuckGo $SearchTerms; return }
            '5' { Search-Startpage $SearchTerms; return }
            '6' { Search-GitHub $SearchTerms; return }
            '7' { Search-StackOverflow $SearchTerms; return }
            '8' { Search-Wikipedia $SearchTerms; return }
            '9' { Search-Scholar $SearchTerms; return }
            '10' { Search-YouTube $SearchTerms; return }
            '11' { Search-Reddit $SearchTerms; return }
            '12' { Search-ChatGPT $SearchTerms; return }
            '13' { Search-Claude $SearchTerms; return }
            '14' { Search-Perplexity $SearchTerms; return }
            '15' { 
                $moreChoices = @(
                    'Yahoo', 'Yandex', 'Baidu', 'Ecosia', 'Qwant', 'Ask.com',
                    'Docker Hub', 'NPM', 'Packagist', 'Go Packages', 'Rust Crates', 'Rust Docs', 'Back'
                )
                
                Write-Host "\nMore Search Options" -ForegroundColor Magenta
                for ($i = 0; $i -lt $moreChoices.Count; $i++) {
                    Write-Host "$($i + 1). $($moreChoices[$i])" -ForegroundColor Cyan
                }
                
                $moreSelection = Read-Host "Enter your choice (1-$($moreChoices.Count))"
                switch ($moreSelection) {
                    '1' { Search-Yahoo $SearchTerms; return }
                    '2' { Search-Yandex $SearchTerms; return }
                    '3' { Search-Baidu $SearchTerms; return }
                    '4' { Search-Ecosia $SearchTerms; return }
                    '5' { Search-Qwant $SearchTerms; return }
                    '6' { Search-Ask $SearchTerms; return }
                    '7' { Search-DockerHub $SearchTerms; return }
                    '8' { Search-NPM $SearchTerms; return }
                    '9' { Search-Packagist $SearchTerms; return }
                    '10' { Search-GoPackages $SearchTerms; return }
                    '11' { Search-RustCrates $SearchTerms; return }
                    '12' { Search-RustDocs $SearchTerms; return }
                    '13' { continue }
                    default {
                        Write-Host "Invalid option: '$moreSelection'" -ForegroundColor Red
                        continue
                    }
                }
            }
            '16' { Write-Host "Bye! 👋" -ForegroundColor Yellow; return }
            default {
                Write-Host "Invalid option: '$selection'" -ForegroundColor Red
                Write-Host "Enter a number between 1 and $($choices.Count)" -ForegroundColor Yellow
            }
        }
    } while ($selection -ne '16')
}


