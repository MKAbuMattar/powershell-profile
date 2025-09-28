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
            'wikipedia' { Search-Wikipedia $SearchTerms; return }
            'google' { Search-Google $SearchTerms; return }
            'github' { Search-GitHub $SearchTerms; return }
            'stackoverflow' { Search-StackOverflow $SearchTerms; return }
            'reddit' { Search-Reddit $SearchTerms; return }
            default {
                Write-Host "Unknown search engine: $SearchEngine" -ForegroundColor Red
                Write-Host "Available engines: duckduckgo, wikipedia, google, github, stackoverflow, reddit" -ForegroundColor Yellow
                return
            }
        }
    }
    
    $choices = @(
        'DuckDuckGo', 'Wikipedia', 'Google', 'GitHub', 'StackOverflow',
        'Reddit', 'Quit'
    )
    
    Write-Host "Select a Search Option" -ForegroundColor Magenta
    for ($i = 0; $i -lt $choices.Count; $i++) {
        Write-Host "$($i + 1). $($choices[$i])" -ForegroundColor Cyan
    }
    
    do {
        $selection = Read-Host "Enter your choice (1-$($choices.Count))"
        
        switch ($selection) {
            '1' { Search-DuckDuckGo $SearchTerms; return }
            '2' { Search-Wikipedia $SearchTerms; return }
            '3' { Search-Google $SearchTerms; return }
            '4' { Search-GitHub $SearchTerms; return }
            '5' { Search-StackOverflow $SearchTerms; return }
            '6' { Search-Reddit $SearchTerms; return }
            '7' { Write-Host "Bye! 👋" -ForegroundColor Yellow; return }
            default {
                Write-Host "Invalid option: '$selection'" -ForegroundColor Red
                Write-Host "Enter a number between 1 and $($choices.Count)" -ForegroundColor Yellow
            }
        }
    } while ($selection -ne '11')
}


