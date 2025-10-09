#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Ruby Plugin
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
#       This module provides Ruby CLI shortcuts and utility functions for Ruby development
#       and gem management in PowerShell environments. Supports Ruby execution, gem operations,
#       file searching, development server, and comprehensive Ruby workflow automation for
#       modern Ruby development and scripting.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Get-RubyVersion {
    <#
    .SYNOPSIS
        Gets the installed Ruby version.

    .DESCRIPTION
        Returns the version of Ruby that is currently installed and accessible.

    .OUTPUTS
        System.String
        The Ruby version string, or $null if Ruby is not available.

    .EXAMPLE
        Get-RubyVersion
        Returns the Ruby version (e.g., "ruby 3.2.0").

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $versionOutput = ruby --version 2>$null
        return $versionOutput.Trim()
    }
    catch {
        return $null
    }
}

function Get-GemVersion {
    <#
    .SYNOPSIS
        Gets the installed RubyGems version.

    .DESCRIPTION
        Returns the version of RubyGems that is currently installed and accessible.

    .OUTPUTS
        System.String
        The RubyGems version string, or $null if gem is not available.

    .EXAMPLE
        Get-GemVersion
        Returns the RubyGems version.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $versionOutput = gem --version 2>$null
        return $versionOutput.Trim()
    }
    catch {
        return $null
    }
}

function Invoke-Ruby {
    <#
    .SYNOPSIS
        Base Ruby command wrapper.

    .DESCRIPTION
        Executes Ruby commands with all provided arguments. Serves as the base wrapper
        for all Ruby operations and ensures Ruby is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Ruby command.

    .EXAMPLE
        Invoke-Ruby --version
        Shows Ruby version.

    .EXAMPLE
        Invoke-Ruby script.rb
        Runs Ruby script.

    .EXAMPLE
        rb -e "puts 'Hello World'"
        Runs inline Ruby code using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("rb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    & ruby @Arguments
}

function Invoke-RubyExecute {
    <#
    .SYNOPSIS
        Execute Ruby code inline.

    .DESCRIPTION
        Executes Ruby code directly from the command line using ruby -e.
        Equivalent to 'ruby -e' or 'rrun' shortcut.

    .PARAMETER Code
        Ruby code to execute.

    .PARAMETER Arguments
        Additional arguments to pass to ruby -e.

    .EXAMPLE
        Invoke-RubyExecute "puts 'Hello World'"
        Executes inline Ruby code.

    .EXAMPLE
        rrun "puts RUBY_VERSION"
        Shows Ruby version using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("rrun")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Code,
        
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('-e', $Code) + $Arguments
    & ruby @allArgs
}

function Start-RubyServer {
    <#
    .SYNOPSIS
        Start simple Ruby HTTP server.

    .DESCRIPTION
        Starts a simple HTTP server using Ruby's built-in webrick library.
        Equivalent to 'ruby -run -e httpd . -p 8080' or 'rserver' shortcut.

    .PARAMETER Path
        Path to serve (defaults to current directory).

    .PARAMETER Port
        Port to serve on (defaults to 8080).

    .PARAMETER Arguments
        Additional arguments to pass to the server.

    .EXAMPLE
        Start-RubyServer
        Starts server on current directory, port 8080.

    .EXAMPLE
        Start-RubyServer -Path ./public -Port 3000
        Starts server on ./public directory, port 3000.

    .EXAMPLE
        rserver
        Starts server using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("rserver")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Path = ".",
        
        [Parameter()]
        [int]$Port = 8080,
        
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('-run', '-e', 'httpd', $Path, '-p', $Port.ToString()) + $Arguments
    & ruby @allArgs
}

function Find-RubyFiles {
    <#
    .SYNOPSIS
        Find and search in Ruby files.

    .DESCRIPTION
        Finds Ruby files and searches for patterns within them.
        Equivalent to 'find . -name "*.rb" | xargs grep -n' or 'rfind' shortcut.

    .PARAMETER Pattern
        Pattern to search for in Ruby files.

    .PARAMETER Path
        Path to search in (defaults to current directory).

    .PARAMETER Arguments
        Additional arguments to pass to Select-String.

    .EXAMPLE
        Find-RubyFiles "class"
        Finds all Ruby files containing "class".

    .EXAMPLE
        Find-RubyFiles "def initialize" ./src
        Searches for "def initialize" in ./src directory.

    .EXAMPLE
        rfind "module"
        Finds modules using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("rfind")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Pattern,
        
        [Parameter(Position = 1)]
        [string]$Path = ".",
        
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    try {
        Get-ChildItem -Path $Path -Filter "*.rb" -Recurse | 
        Select-String -Pattern $Pattern @Arguments |
        ForEach-Object { "$($_.Filename):$($_.LineNumber):$($_.Line.Trim())" }
    }
    catch {
        Write-Error "Error searching Ruby files: $($_.Exception.Message)"
    }
}

function Invoke-Gem {
    <#
    .SYNOPSIS
        Base gem command wrapper.

    .DESCRIPTION
        Executes gem commands with all provided arguments. Serves as the base wrapper
        for all gem operations and ensures gem is available before execution.

    .PARAMETER Arguments
        All arguments to pass to gem command.

    .EXAMPLE
        Invoke-Gem --version
        Shows gem version.

    .EXAMPLE
        Invoke-Gem list
        Lists installed gems.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    & gem @Arguments
}

function Invoke-SudoGem {
    <#
    .SYNOPSIS
        Run gem with elevated privileges.

    .DESCRIPTION
        Runs gem commands with sudo (on Unix-like systems) or elevated privileges.
        Equivalent to 'sudo gem' or 'sgem' shortcut. On Windows, attempts to run
        as administrator if possible.

    .PARAMETER Arguments
        All arguments to pass to sudo gem command.

    .EXAMPLE
        Invoke-SudoGem install rails
        Installs rails gem with elevated privileges.

    .EXAMPLE
        sgem uninstall old_gem
        Uninstalls gem with elevated privileges using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("sgem")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if ($env:OS -eq "Windows_NT") {
        try {
            $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
            $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            
            if (-not $isAdmin) {
                Write-Warning "Running gem with elevated privileges requires administrator access. Please run PowerShell as administrator."
                return
            }
        }
        catch {
            Write-Warning "Could not determine administrator status. Attempting to run gem normally."
        }
        
        & gem @Arguments
    }
    else {
        if (Get-Command sudo -ErrorAction SilentlyContinue) {
            $allArgs = @('gem') + $Arguments
            & sudo @allArgs
        }
        else {
            Write-Warning "sudo command not found. Running gem normally."
            & gem @Arguments
        }
    }
}

function Install-Gem {
    <#
    .SYNOPSIS
        Install Ruby gems.

    .DESCRIPTION
        Installs one or more Ruby gems using gem install.
        Equivalent to 'gem install' or 'gein' shortcut.

    .PARAMETER GemNames
        Names of gems to install.

    .PARAMETER Arguments
        Additional arguments to pass to gem install.

    .EXAMPLE
        Install-Gem rails
        Installs rails gem.

    .EXAMPLE
        Install-Gem bundler rake --no-document
        Installs bundler and rake without documentation.

    .EXAMPLE
        gein sinatra
        Installs sinatra gem using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("gein")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('install') + $Arguments
    & gem @allArgs
}

function Uninstall-Gem {
    <#
    .SYNOPSIS
        Uninstall Ruby gems.

    .DESCRIPTION
        Uninstalls one or more Ruby gems using gem uninstall.
        Equivalent to 'gem uninstall' or 'geun' shortcut.

    .PARAMETER Arguments
        Gem names and arguments to pass to gem uninstall.

    .EXAMPLE
        Uninstall-Gem old_gem
        Uninstalls old_gem.

    .EXAMPLE
        geun unused_gem --force
        Uninstalls gem with force flag using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geun")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('uninstall') + $Arguments
    & gem @allArgs
}

function Get-GemList {
    <#
    .SYNOPSIS
        List installed gems.

    .DESCRIPTION
        Lists all installed Ruby gems using gem list.
        Equivalent to 'gem list' or 'geli' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to gem list.

    .EXAMPLE
        Get-GemList
        Lists all installed gems.

    .EXAMPLE
        Get-GemList rails
        Lists gems matching "rails".

    .EXAMPLE
        geli --local
        Lists local gems using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geli")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('list') + $Arguments
    & gem @allArgs
}

function Get-GemInfo {
    <#
    .SYNOPSIS
        Get information about gems.

    .DESCRIPTION
        Shows detailed information about Ruby gems using gem info.
        Equivalent to 'gem info' or 'gei' shortcut.

    .PARAMETER Arguments
        Gem names and arguments to pass to gem info.

    .EXAMPLE
        Get-GemInfo rails
        Shows information about rails gem.

    .EXAMPLE
        gei bundler --remote
        Shows remote info for bundler using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("gei")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('info') + $Arguments
    & gem @allArgs
}

function Get-GemInfoAll {
    <#
    .SYNOPSIS
        Get information about all versions of gems.

    .DESCRIPTION
        Shows detailed information about all versions of Ruby gems using gem info --all.
        Equivalent to 'gem info --all' or 'geiall' shortcut.

    .PARAMETER Arguments
        Gem names and additional arguments to pass to gem info --all.

    .EXAMPLE
        Get-GemInfoAll rails
        Shows information about all versions of rails gem.

    .EXAMPLE
        geiall bundler
        Shows all bundler versions using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geiall")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('info', '--all') + $Arguments
    & gem @allArgs
}

function Add-GemCert {
    <#
    .SYNOPSIS
        Add gem certificate.

    .DESCRIPTION
        Adds a certificate to the gem trust store using gem cert --add.
        Equivalent to 'gem cert --add' or 'geca' shortcut.

    .PARAMETER Arguments
        Certificate files and arguments to pass to gem cert --add.

    .EXAMPLE
        Add-GemCert certificate.pem
        Adds certificate to gem trust store.

    .EXAMPLE
        geca public_key.pem
        Adds public key using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geca")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('cert', '--add') + $Arguments
    & gem @allArgs
}

function Remove-GemCert {
    <#
    .SYNOPSIS
        Remove gem certificate.

    .DESCRIPTION
        Removes a certificate from the gem trust store using gem cert --remove.
        Equivalent to 'gem cert --remove' or 'gecr' shortcut.

    .PARAMETER Arguments
        Certificate names and arguments to pass to gem cert --remove.

    .EXAMPLE
        Remove-GemCert certificate_name
        Removes certificate from gem trust store.

    .EXAMPLE
        gecr old_cert
        Removes certificate using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("gecr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('cert', '--remove') + $Arguments
    & gem @allArgs
}

function Build-GemCert {
    <#
    .SYNOPSIS
        Build gem certificate.

    .DESCRIPTION
        Builds a certificate for gem signing using gem cert --build.
        Equivalent to 'gem cert --build' or 'gecb' shortcut.

    .PARAMETER Arguments
        Arguments to pass to gem cert --build.

    .EXAMPLE
        Build-GemCert email@example.com
        Builds certificate for email address.

    .EXAMPLE
        gecb developer@company.com
        Builds certificate using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("gecb")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('cert', '--build') + $Arguments
    & gem @allArgs
}

function Invoke-GemCleanup {
    <#
    .SYNOPSIS
        Preview gem cleanup operation.

    .DESCRIPTION
        Shows what gem cleanup would remove without actually removing anything using gem cleanup -n.
        Equivalent to 'gem cleanup -n' or 'geclup' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to gem cleanup -n.

    .EXAMPLE
        Invoke-GemCleanup
        Shows what cleanup would remove.

    .EXAMPLE
        geclup
        Shows cleanup preview using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geclup")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('cleanup', '-n') + $Arguments
    & gem @allArgs
}

function Invoke-GemGenerateIndex {
    <#
    .SYNOPSIS
        Generate gem index.

    .DESCRIPTION
        Generates a gem index for a gem repository using gem generate_index.
        Equivalent to 'gem generate_index' or 'gegi' shortcut.

    .PARAMETER Arguments
        Arguments to pass to gem generate_index.

    .EXAMPLE
        Invoke-GemGenerateIndex
        Generates gem index for current directory.

    .EXAMPLE
        gegi --directory ./gems
        Generates index for gems directory using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("gegi")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('generate_index') + $Arguments
    & gem @allArgs
}

function Get-GemHelp {
    <#
    .SYNOPSIS
        Get gem help.

    .DESCRIPTION
        Shows help for gem commands using gem help.
        Equivalent to 'gem help' or 'geh' shortcut.

    .PARAMETER Arguments
        Command names to get help for.

    .EXAMPLE
        Get-GemHelp
        Shows general gem help.

    .EXAMPLE
        Get-GemHelp install
        Shows help for gem install command.

    .EXAMPLE
        geh uninstall
        Shows uninstall help using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geh")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('help') + $Arguments
    & gem @allArgs
}

function Lock-Gem {
    <#
    .SYNOPSIS
        Lock gem dependencies.

    .DESCRIPTION
        Creates a lock file for gem dependencies using gem lock.
        Equivalent to 'gem lock' or 'gel' shortcut.

    .PARAMETER Arguments
        Arguments to pass to gem lock.

    .EXAMPLE
        Lock-Gem
        Creates lock file for current gemset.

    .EXAMPLE
        gel --strict
        Creates strict lock file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("gel")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('lock') + $Arguments
    & gem @allArgs
}

function Open-Gem {
    <#
    .SYNOPSIS
        Open gem in default application.

    .DESCRIPTION
        Opens a gem's source code in the default application using gem open.
        Equivalent to 'gem open' or 'geo' shortcut.

    .PARAMETER Arguments
        Gem names and arguments to pass to gem open.

    .EXAMPLE
        Open-Gem rails
        Opens rails gem source.

    .EXAMPLE
        geo bundler
        Opens bundler gem using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geo")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('open') + $Arguments
    & gem @allArgs
}

function Open-GemEditor {
    <#
    .SYNOPSIS
        Open gem in editor.

    .DESCRIPTION
        Opens a gem's source code in the default editor using gem open -e.
        Equivalent to 'gem open -e' or 'geoe' shortcut.

    .PARAMETER Arguments
        Gem names and arguments to pass to gem open -e.

    .EXAMPLE
        Open-GemEditor rails
        Opens rails gem in editor.

    .EXAMPLE
        geoe bundler
        Opens bundler gem in editor using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Ruby/README.md
    #>
    [CmdletBinding()]
    [Alias("geoe")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('open', '-e') + $Arguments
    & gem @allArgs
}
