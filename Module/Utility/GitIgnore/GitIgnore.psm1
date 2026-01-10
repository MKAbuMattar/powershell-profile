#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - GitIgnore Utility Module
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
#       This module provides a simple wrapper for the igntui CLI tool.
#       igntui is an interactive TUI for generating .gitignore files.
#
# Created: 2025-09-27
# Updated: 2026-01-10
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 5.0.0
#---------------------------------------------------------------------------------------------------

function Start-GitIgnore {
    <#
    .SYNOPSIS
        Launch the interactive igntui Terminal User Interface.
        
    .DESCRIPTION
        This function launches the igntui TUI application, providing an interactive
        interface for browsing and selecting gitignore templates. The TUI offers
        a better user experience with search, multi-select, and preview capabilities.
        
        If igntui is not installed, the function will automatically prompt to install
        it from PyPI using pipx.
        
    .EXAMPLE
        Start-GitIgnore
        Launches the igntui TUI interface.
        
    .EXAMPLE
        gitignore
        Uses the 'gitignore' alias to launch the TUI.

    .NOTES
        Requires igntui to be installed from PyPI.
        Installation command: pipx install igntui
        Will automatically prompt for installation if not found.
    #>
    [CmdletBinding()]
    [Alias('gitignore')]
    param()

    # Check if igntui is installed (get the actual executable, not any alias)
    $igntuiCmd = $null
    try {
        $igntuiCmd = Get-Command igntui -CommandType Application -ErrorAction Stop
    }
    catch {
        Write-Host "❌ igntui is not installed." -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 igntui is an interactive TUI for generating .gitignore files." -ForegroundColor Yellow
        Write-Host "   It can be installed from PyPI using pipx or pip:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "   pipx install igntui" -ForegroundColor Cyan
        Write-Host "   pip install igntui" -ForegroundColor Cyan
        Write-Host ""
        $response = Read-Host "Would you like to install it now using pipx? (Y/n)"
        
        if ($response -match '^(y|yes|)$') {
            Write-Host ""
            Write-Host "📦 Installing igntui from PyPI..." -ForegroundColor Green
            pipx install igntui
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "✅ igntui installed successfully!" -ForegroundColor Green
                Write-Host ""
            }
            else {
                Write-Host ""
                Write-Error "❌ Failed to install igntui. Please install it manually using: pipx install igntui"
                return
            }
        }
        else {
            Write-Host ""
            Write-Host "Installation cancelled. Please install igntui manually when ready." -ForegroundColor Yellow
            return
        }
    }

    try {
        Write-Host "🚀 Launching igntui TUI..." -ForegroundColor Green
        Write-Host ""
        & $igntuiCmd.Source
    }
    catch {
        Write-Error "❌ Failed to launch igntui: $($_.Exception.Message)"
    }
}
