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
#       This module provides utilities for generating .gitignore files using the gitignore.io API.
#       It includes functions for generating gitignore content for various technologies and platforms,
#       as well as listing available templates and providing tab completion support.
#       Uses Python backend for API interactions.
#
# Created: 2025-09-27
# Updated: 2025-10-25
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.2.0
#---------------------------------------------------------------------------------------------------

function Get-GitIgnore {
    <#
    .SYNOPSIS
        Generate .gitignore content for specified technologies using gitignore.io API.
        
    .DESCRIPTION
        This function retrieves .gitignore templates from gitignore.io for specified technologies,
        platforms, or IDEs using the Python backend. It can generate content for multiple technologies
        at once. By default, it creates a .gitignore file in the current directory.
        
    .PARAMETER Technologies
        Array of technology names to generate gitignore content for.
        Examples: 'node', 'python', 'visualstudio', 'macos', 'windows'
        
    .PARAMETER OutputPath
        Optional path to save the gitignore content to a file.
        If not specified, content is saved to .gitignore in the current directory.
        
    .PARAMETER Append
        If specified and OutputPath is provided, content will be appended to the file
        instead of overwriting it.
        
    .EXAMPLE
        Get-GitIgnore node python
        Generates gitignore content for Node.js and Python, saves to .gitignore file.
        
    .EXAMPLE
        gitignore visualstudio windows
        Uses the 'gitignore' alias to generate gitignore content for Visual Studio and Windows,
        automatically creates .gitignore file in current directory.
        
    .EXAMPLE
        Get-GitIgnore macos python django -OutputPath custom.gitignore
        Generates gitignore content and saves to a custom file path.
        
    .NOTES
        This function requires internet connectivity to access the gitignore.io API.
        Uses Python backend for reliable cross-platform API interactions.
    #>
    [CmdletBinding()]
    [Alias('gitignore')]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromRemainingArguments = $true,
            HelpMessage = "Specify one or more technology names (e.g., 'node', 'python', 'visualstudio')"
        )]
        [string[]]$Technologies,
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Path to save the gitignore content to a file"
        )]
        [string]$OutputPath,
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Append to file instead of overwriting"
        )]
        [switch]$Append
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path $scriptDir "gitignore_util.py"

    if (-not (Test-Path $pythonScript)) {
        Write-Error "gitignore_util.py not found at: $pythonScript"
        return
    }

    # Try 'python' first, then 'python3'
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

    try {
        $arguments = @($pythonScript, "--get") + $Technologies
        $gitignoreContent = & $pythonPath $arguments 2>&1 | Where-Object { $_ -notmatch '^\[' }
        
        if ($OutputPath) {
            if ($Append) {
                Add-Content -Path $OutputPath -Value $gitignoreContent -Encoding UTF8
                Write-Host "✅ GitIgnore content appended to: $OutputPath" -ForegroundColor Green
            }
            else {
                Set-Content -Path $OutputPath -Value $gitignoreContent -Encoding UTF8
                Write-Host "✅ GitIgnore content saved to: $OutputPath" -ForegroundColor Green
            }
        }
        else {
            $DefaultPath = ".\.gitignore"
            Set-Content -Path $DefaultPath -Value $gitignoreContent -Encoding UTF8
            Write-Host "✅ GitIgnore content saved to: $DefaultPath" -ForegroundColor Green
            Write-Host "📝 Technologies: $($Technologies -join ', ')" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Error "❌ Failed to fetch gitignore content: $($_.Exception.Message)"
        Write-Host "💡 Make sure you have internet connectivity and the technology names are valid." -ForegroundColor Yellow
        Write-Host "💡 Use 'Get-GitIgnoreList' to see available technologies." -ForegroundColor Yellow
    }
}

function Get-GitIgnoreList {
    <#
    .SYNOPSIS
        Get a list of all available gitignore templates from gitignore.io.
        
    .DESCRIPTION
        This function retrieves the complete list of available technologies, platforms,
        and IDEs that can be used with the Get-GitIgnore function using the Python backend.
        
    .PARAMETER Filter
        Optional filter to search for specific technologies.
        Uses case-insensitive matching.
        
    .PARAMETER GridView
        If specified, displays the list in an interactive grid view (Windows only).
        
    .EXAMPLE
        Get-GitIgnoreList
        Lists all available gitignore templates.
        
    .EXAMPLE
        Get-GitIgnoreList -Filter python
        Lists all templates containing 'python' in the name.
        
    .EXAMPLE
        gilist -Filter node
        Uses the 'gilist' alias to find Node.js related templates.
        
    .EXAMPLE
        Get-GitIgnoreList -GridView
        Shows templates in an interactive grid view for selection.
        
    .NOTES
        This function requires internet connectivity to access the gitignore.io API.
        Uses Python backend for reliable cross-platform API interactions.
    #>
    [CmdletBinding()]
    [Alias('gilist')]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            HelpMessage = "Filter the list by technology name"
        )]
        [string]$Filter,
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Display in grid view (Windows only)"
        )]
        [switch]$GridView
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path $scriptDir "gitignore_util.py"

    if (-not (Test-Path $pythonScript)) {
        Write-Error "gitignore_util.py not found at: $pythonScript"
        return
    }

    # Try 'python' first, then 'python3'
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

    try {
        $arguments = @($pythonScript, "--list")
        
        if ($Filter) {
            $arguments += @("--filter", $Filter)
        }
        
        $output = & $pythonPath $arguments 2>&1
        
        # Extract the list of technologies (skip info messages)
        $technologies = $output | Where-Object { $_ -notmatch '^\[' -and $_ -notmatch '^Usage' -and $_ -notmatch '^Example' -and $_ -ne '' } | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        
        # Display formatted output
        if ($technologies) {
            if ($GridView -and $IsWindows) {
                $technologies | Out-GridView -Title "Available GitIgnore Templates"
            }
            elseif ($GridView) {
                Write-Warning "GridView is only available on Windows. Displaying as list instead."
                $technologies | Format-Wide -Column 4
            }
            else {
                $technologies | Format-Wide -Column 4
            }
        }
        
        Write-Host ""
        Write-Host "💡 Usage: Get-GitIgnore <technology1> <technology2> ..." -ForegroundColor Yellow
        Write-Host "💡 Example: gitignore node python visualstudio" -ForegroundColor Yellow
    }
    catch {
        Write-Error "❌ Failed to fetch gitignore template list: $($_.Exception.Message)"
        Write-Host "💡 Make sure you have internet connectivity." -ForegroundColor Yellow
    }
}

function New-GitIgnoreFile {
    <#
    .SYNOPSIS
        Create a new .gitignore file with specified technologies in the current directory.
        
    .DESCRIPTION
        This function creates a new .gitignore file in the current directory (or specified path)
        with content for the specified technologies. If a .gitignore file already exists,
        it can optionally be backed up or appended to.
        
    .PARAMETER Technologies
        Array of technology names to include in the gitignore file.
        
    .PARAMETER Path
        Directory path where the .gitignore file should be created.
        Defaults to current directory.
        
    .PARAMETER Backup
        If specified, creates a backup of existing .gitignore file before overwriting.
        
    .PARAMETER Force
        If specified, overwrites existing .gitignore without prompting.
        
    .EXAMPLE
        New-GitIgnoreFile node python
        Creates .gitignore file with Node.js and Python templates.
        
    .EXAMPLE
        New-GitIgnoreFile visualstudio,windows -Backup
        Creates .gitignore file and backs up any existing one.
        
    .EXAMPLE
        ginew python django -Force
        Uses alias to forcefully create .gitignore for Python and Django.
    #>
    [CmdletBinding()]
    [Alias('ginew')]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromRemainingArguments = $true,
            HelpMessage = "Specify one or more technology names"
        )]
        [string[]]$Technologies,
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Directory path for the .gitignore file"
        )]
        [string]$Path = ".",
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Backup existing .gitignore file"
        )]
        [switch]$Backup,
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Force overwrite without prompting"
        )]
        [switch]$Force
    )
    
    $GitIgnorePath = Join-Path -Path $Path -ChildPath ".gitignore"
    
    if (Test-Path $GitIgnorePath -and -not $Force) {
        if ($Backup) {
            $BackupPath = "$GitIgnorePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item -Path $GitIgnorePath -Destination $BackupPath
            Write-Host "📦 Existing .gitignore backed up to: $BackupPath" -ForegroundColor Yellow
        }
        else {
            $Response = Read-Host "⚠️  .gitignore already exists. Overwrite? (y/N)"
            if ($Response -notmatch '^y|yes$') {
                Write-Host "❌ Operation cancelled." -ForegroundColor Red
                return
            }
        }
    }
    
    try {
        Get-GitIgnore @Technologies -OutputPath $GitIgnorePath
        Write-Host "🎉 Successfully created .gitignore file with templates for: $($Technologies -join ', ')" -ForegroundColor Green
    }
    catch {
        Write-Error "❌ Failed to create .gitignore file: $($_.Exception.Message)"
    }
}

function Add-GitIgnoreContent {
    <#
    .SYNOPSIS
        Add additional technologies to an existing .gitignore file.
        
    .DESCRIPTION
        This function appends gitignore content for additional technologies to an existing
        .gitignore file. If no .gitignore file exists, it creates a new one.
        
    .PARAMETER Technologies
        Array of technology names to add to the gitignore file.
        
    .PARAMETER Path
        Directory path containing the .gitignore file.
        Defaults to current directory.
        
    .EXAMPLE
        Add-GitIgnoreContent macos linux
        Adds macOS and Linux templates to existing .gitignore.
        
    .EXAMPLE
        giadd docker kubernetes
        Uses alias to add Docker and Kubernetes templates.
    #>
    [CmdletBinding()]
    [Alias('giadd')]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromRemainingArguments = $true,
            HelpMessage = "Specify one or more technology names to add"
        )]
        [string[]]$Technologies,
        
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Directory path containing the .gitignore file"
        )]
        [string]$Path = "."
    )
    
    $GitIgnorePath = Join-Path -Path $Path -ChildPath ".gitignore"
    
    try {
        if (Test-Path $GitIgnorePath) {
            "" | Add-Content -Path $GitIgnorePath
            "# Added $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $($Technologies -join ', ')" | Add-Content -Path $GitIgnorePath
            
            Get-GitIgnore @Technologies -OutputPath $GitIgnorePath -Append
            Write-Host "✅ Successfully added templates for: $($Technologies -join ', ')" -ForegroundColor Green
        }
        else {
            Write-Host "📝 No existing .gitignore found. Creating new file..." -ForegroundColor Yellow
            New-GitIgnoreFile @Technologies -Path $Path
        }
    }
    catch {
        Write-Error "❌ Failed to add content to .gitignore: $($_.Exception.Message)"
    }
}

function Test-GitIgnoreService {
    <#
    .SYNOPSIS
        Test connectivity to the gitignore.io API service.
        
    .DESCRIPTION
        This function tests whether the gitignore.io API is accessible and responding properly
        using the Python backend.
        
    .EXAMPLE
        Test-GitIgnoreService
        Tests connectivity to gitignore.io API.
        
    .EXAMPLE
        gitest
        Uses alias to test the service.

    .NOTES
        Uses Python backend for reliable cross-platform API connectivity testing.
    #>
    [CmdletBinding()]
    [Alias('gitest')]
    param()

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path $scriptDir "gitignore_util.py"

    if (-not (Test-Path $pythonScript)) {
        Write-Error "gitignore_util.py not found at: $pythonScript"
        return
    }

    # Try 'python' first, then 'python3'
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

    try {
        $arguments = @($pythonScript, "--test")
        & $pythonPath $arguments 2>&1
    }
    catch {
        Write-Error "❌ Failed to test gitignore.io service: $($_.Exception.Message)"
    }
}

function Get-GitIgnoreTypes {
    <#
    .SYNOPSIS
        Get a list of all available gitignore types/templates with pagination.
        
    .DESCRIPTION
        This function retrieves and displays all available gitignore types from gitignore.io
        with interactive pagination. Shows 15 items per page with navigation controls.
        Returns a complete list of all technologies, platforms, and IDEs that can be used 
        with Get-GitIgnore function.
        
    .PARAMETER Filter
        Optional filter to search for specific types by name.
        Uses case-insensitive partial matching.
        
    .EXAMPLE
        Get-GitIgnoreTypes
        Displays all available gitignore types with pagination (15 per page).
        
    .EXAMPLE
        Get-GitIgnoreTypes -Filter python
        Shows gitignore types containing 'python' with pagination.
        
    .EXAMPLE
        gitypes
        Uses the 'gitypes' alias to list all types with pagination.

    .NOTES
        Uses Python backend to fetch the complete list from gitignore.io API.
        Interactive pagination allows you to browse through 450+ available technology types.
    #>
    [CmdletBinding()]
    [Alias('gitypes')]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            HelpMessage = "Filter results by type name"
        )]
        [string]$Filter
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path $scriptDir "gitignore_util.py"

    if (-not (Test-Path $pythonScript)) {
        Write-Error "gitignore_util.py not found at: $pythonScript"
        return
    }

    # Try 'python' first, then 'python3'
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

    try {
        $arguments = @($pythonScript, "--list")
        
        if ($Filter) {
            $arguments += @("--filter", $Filter)
        }
        
        # Run the command and capture output
        $rawOutput = & $pythonPath $arguments 2>&1
        
        # Parse the output to extract technology names
        $types = @()
        foreach ($line in $rawOutput) {
            # Skip info messages and utility text
            if ($line -notmatch '^\[' -and $line -notmatch '^Usage' -and $line -notmatch '^Example' -and $line -notmatch '^💡' -and $line.Trim() -ne '') {
                # Split by whitespace and add each item
                $items = $line.Trim() -split '\s+' | Where-Object { $_ -and $_ -notmatch '^-' }
                $types += $items
            }
        }
        
        # Remove duplicates and sort
        $types = $types | Select-Object -Unique | Sort-Object
        
        if ($types.Count -eq 0) {
            Write-Warning "No gitignore types found matching '$Filter'"
            return
        }
        
        # Pagination setup
        $itemsPerPage = 15
        $totalPages = [Math]::Ceiling($types.Count / $itemsPerPage)
        $currentPage = 0
        
        # Display paginated results
        $displayMore = $true
        while ($displayMore) {
            Clear-Host
            
            $pageStart = $currentPage * $itemsPerPage
            $pageEnd = [Math]::Min($pageStart + $itemsPerPage - 1, $types.Count - 1)
            $pageItems = $types[$pageStart..$pageEnd]
            
            # Display header
            Write-Host ""
            Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
            if ($Filter) {
                Write-Host "📋 GitIgnore Types matching '$Filter'" -ForegroundColor Cyan
            }
            else {
                Write-Host "📋 All Available GitIgnore Types" -ForegroundColor Cyan
            }
            Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
            Write-Host ""
            
            # Display current page items in 3 columns
            $column1 = @()
            $column2 = @()
            $column3 = @()
            
            for ($i = 0; $i -lt $pageItems.Count; $i++) {
                if ($i % 3 -eq 0) { $column1 += $pageItems[$i] }
                elseif ($i % 3 -eq 1) { $column2 += $pageItems[$i] }
                else { $column3 += $pageItems[$i] }
            }
            
            for ($i = 0; $i -lt [Math]::Max([Math]::Max($column1.Count, $column2.Count), $column3.Count); $i++) {
                $col1Text = if ($i -lt $column1.Count) { $column1[$i].PadRight(20) } else { " " * 20 }
                $col2Text = if ($i -lt $column2.Count) { $column2[$i].PadRight(20) } else { " " * 20 }
                $col3Text = if ($i -lt $column3.Count) { $column3[$i] } else { "" }
                
                Write-Host "$col1Text  $col2Text  $col3Text"
            }
            
            Write-Host ""
            Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host "Page $($currentPage + 1) of $totalPages | Total: $($types.Count) types" -ForegroundColor Green
            Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host ""
            
            # Display navigation options
            Write-Host "Navigation:" -ForegroundColor Yellow
            if ($currentPage -gt 0) {
                Write-Host "  [P] Previous page"
            }
            if ($currentPage -lt $totalPages - 1) {
                Write-Host "  [N] Next page"
            }
            Write-Host "  [L] List all on this page"
            Write-Host "  [E] Exit"
            Write-Host ""
            
            # Get user input
            $choice = Read-Host "Choose an option (P/N/L/E)"
            
            switch ($choice.ToUpper()) {
                'N' {
                    if ($currentPage -lt $totalPages - 1) {
                        $currentPage++
                    }
                    else {
                        Write-Host "Already on last page!" -ForegroundColor Yellow
                        Start-Sleep -Seconds 1
                    }
                }
                'P' {
                    if ($currentPage -gt 0) {
                        $currentPage--
                    }
                    else {
                        Write-Host "Already on first page!" -ForegroundColor Yellow
                        Start-Sleep -Seconds 1
                    }
                }
                'L' {
                    Clear-Host
                    Write-Host ""
                    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
                    Write-Host "📋 All Available GitIgnore Types ($($types.Count) total)" -ForegroundColor Cyan
                    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
                    Write-Host ""
                    
                    # Display all types in formatted columns
                    $types | Format-Wide -Column 5
                    
                    Write-Host ""
                    Write-Host "💡 Usage: Get-GitIgnore <type1> <type2> ..." -ForegroundColor Yellow
                    Write-Host "💡 Example: gitignore node python visualstudio" -ForegroundColor Yellow
                    Write-Host ""
                    Read-Host "Press Enter to return to pagination"
                }
                'E' {
                    Write-Host "Goodbye!" -ForegroundColor Green
                    $displayMore = $false
                }
                default {
                    Write-Host "Invalid option. Please choose P, N, L, or E." -ForegroundColor Red
                    Start-Sleep -Seconds 1
                }
            }
        }
    }
    catch {
        Write-Error "❌ Failed to retrieve gitignore types: $($_.Exception.Message)"
        Write-Host "💡 Make sure you have internet connectivity." -ForegroundColor Yellow
    }
}

Register-ArgumentCompleter -CommandName Get-GitIgnore, New-GitIgnoreFile, Add-GitIgnoreContent -ParameterName Technologies -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $BoundParameters)
    
    if (-not $script:GitIgnoreTechnologies -or (Get-Date) -gt $script:GitIgnoreCacheExpiry) {
        try {
            $Response = Invoke-RestMethod -Uri "https://www.toptal.com/developers/gitignore/api/list" -Method Get -TimeoutSec 5 -ErrorAction Stop
            $script:GitIgnoreTechnologies = $Response -split ','
            $script:GitIgnoreCacheExpiry = (Get-Date).AddMinutes(30) # Cache for 30 minutes
        }
        catch {
            $script:GitIgnoreTechnologies = @(
                'node', 'python', 'java', 'csharp', 'visualstudio', 'vscode', 'intellij',
                'windows', 'macos', 'linux', 'android', 'ios', 'react', 'angular',
                'vue', 'django', 'flask', 'spring', 'maven', 'gradle', 'docker'
            )
        }
    }
    
    $script:GitIgnoreTechnologies | Where-Object { $_ -like "$WordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
