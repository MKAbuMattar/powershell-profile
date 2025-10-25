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
@{
    RootModule        = 'WebSearch.psm1'
    ModuleVersion     = '4.2.0'
    GUID              = 'a8e5d9c2-4f7b-4c8e-9a5d-8e7f6c9b4a3e'
    Author            = 'Mohammad Abu Mattar'
    CompanyName       = 'MKAbuMattar'
    Copyright         = '(c) 2025 Mohammad Abu Mattar. All rights reserved.'
    Description       = 'WebSearch utility module for performing web searches across multiple search engines with cross-platform browser launching capabilities.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'ConvertTo-UrlEncoded',
        'Start-WebBrowser',
        'Invoke-WebSearch',
        'Search-DuckDuckGo',
        'Search-Wikipedia',
        'Search-Google',
        'Search-GitHub',
        'Search-StackOverflow',
        'Search-Reddit',
        'Search-Bing',
        'Search-Brave',
        'Search-Yahoo',
        'Search-Startpage',
        'Search-Yandex',
        'Search-Baidu',
        'Search-Ecosia',
        'Search-Qwant',
        'Search-Scholar',
        'Search-Ask',
        'Search-YouTube',
        'Search-DockerHub',
        'Search-NPM',
        'Search-Packagist',
        'Search-GoPackages',
        'Search-ChatGPT',
        'Search-Claude',
        'Search-Perplexity',
        'Search-RustCrates',
        'Search-RustDocs',
        'Search-PyPI',
        'Start-WebSearch'
    )
    AliasesToExport   = @(
        'wsddg',
        'wswiki',
        'wsggl',
        'wsgh',
        'wsso',
        'wsrdt',
        'wsbing',
        'wsbrave',
        'wsbrs',
        'wsyahoo',
        'wssp',
        'wsyandex',
        'wsbaidu',
        'wsecosia',
        'wsqwant',
        'wsscholar',
        'wsask',
        'wsyt',
        'wsyoutube',
        'wsdocker',
        'wsnpm',
        'wspackagist',
        'wsgopkg',
        'wschatgpt',
        'wschaude',
        'wsppai',
        'wsperplexity',
        'wsrscrate',
        'wsrsdoc',
        'wspypi',
        'web-search',
        'ws'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('websearch', 'search', 'browser', 'utility', 'web', 'powershell')
            LicenseUri = 'https://github.com/MKAbuMattar/powershell-profile/blob/main/LICENSE'
            ProjectUri = 'https://github.com/MKAbuMattar/powershell-profile'
        }
    }
}
