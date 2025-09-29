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
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Get-GitIgnore {
    <#
    .SYNOPSIS
        Generate .gitignore content for specified technologies using gitignore.io API.
        
    .DESCRIPTION
        This function retrieves .gitignore templates from gitignore.io for specified technologies,
        platforms, or IDEs. It can generate content for multiple technologies at once.
        By default, it creates a .gitignore file in the current directory.
        
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
        The API endpoint is: https://www.toptal.com/developers/gitignore/api/
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
    
    try {
        $TechString = $Technologies -join ','
        
        $ApiUrl = "https://www.toptal.com/developers/gitignore/api/$TechString"
        
        Write-Verbose "Fetching gitignore content from: $ApiUrl"
        
        $Response = Invoke-RestMethod -Uri $ApiUrl -Method Get -ErrorAction Stop
        
        if ($OutputPath) {
            if ($Append) {
                $Response | Add-Content -Path $OutputPath -Encoding UTF8
                Write-Host "✅ GitIgnore content appended to: $OutputPath" -ForegroundColor Green
            }
            else {
                $Response | Set-Content -Path $OutputPath -Encoding UTF8
                Write-Host "✅ GitIgnore content saved to: $OutputPath" -ForegroundColor Green
            }
        }
        else {
            $DefaultPath = ".\.gitignore"
            $Response | Set-Content -Path $DefaultPath -Encoding UTF8
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
        and IDEs that can be used with the Get-GitIgnore function.
        
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
        The list endpoint is: https://www.toptal.com/developers/gitignore/api/list
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
    
    try {
        Write-Verbose "Fetching available gitignore templates..."
        
        $Response = Invoke-RestMethod -Uri "https://www.toptal.com/developers/gitignore/api/list" -Method Get -ErrorAction Stop
        
        $Technologies = $Response -split ',' | Sort-Object
        
        if ($Filter) {
            $Technologies = $Technologies | Where-Object { $_ -like "*$Filter*" }
            Write-Host "📋 Found $($Technologies.Count) templates matching '$Filter':" -ForegroundColor Cyan
        }
        else {
            Write-Host "📋 Available GitIgnore Templates ($($Technologies.Count) total):" -ForegroundColor Cyan
        }
        
        if ($GridView -and $IsWindows) {
            $Technologies | Out-GridView -Title "Available GitIgnore Templates"
        }
        elseif ($GridView) {
            Write-Warning "GridView is only available on Windows. Displaying as list instead."
            $Technologies
        }
        else {
            $Technologies | Format-Wide -Column 4
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
        This function tests whether the gitignore.io API is accessible and responding properly.
        
    .EXAMPLE
        Test-GitIgnoreService
        Tests connectivity to gitignore.io API.
        
    .EXAMPLE
        gitest
        Uses alias to test the service.
    #>
    [CmdletBinding()]
    [Alias('gitest')]
    param()
    
    try {
        Write-Host "🔍 Testing gitignore.io API connectivity..." -ForegroundColor Cyan
        
        $TestUrl = "https://www.toptal.com/developers/gitignore/api/list"
        $Response = Invoke-RestMethod -Uri $TestUrl -Method Get -TimeoutSec 10 -ErrorAction Stop
        
        if ($Response) {
            $TechCount = ($Response -split ',').Count
            Write-Host "✅ gitignore.io API is accessible!" -ForegroundColor Green
            Write-Host "📊 Available templates: $TechCount" -ForegroundColor Green
        }
        else {
            Write-Warning "⚠️  API responded but returned no data."
        }
    }
    catch {
        Write-Error "❌ Failed to connect to gitignore.io API: $($_.Exception.Message)"
        Write-Host "💡 Check your internet connection and try again." -ForegroundColor Yellow
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
