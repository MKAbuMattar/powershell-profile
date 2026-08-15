#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Runtime help
#
# Dot-sourced by Loader.psm1. Replaces Module/Docs/Docs.psm1, which was 151 KB of hardcoded help
# text restating the per-module READMEs, which in turn restated the comment-based help on each
# function. Three copies of the same information drift, and they did: the Kubectl section
# documented 45 aliases that no longer existed.
#
# This version reads the loaded modules, so it can only ever show commands that actually exist.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

function Get-ProfileModuleName {
    <#
    .SYNOPSIS
        Returns the names of the profile modules currently loaded.

    .DESCRIPTION
        Identifies profile modules by their path rather than by a hardcoded list, so a module
        added to profile.config.psd1 shows up here with no further change.

    .OUTPUTS
        [string[]] Module names, sorted.

    .EXAMPLE
        Get-ProfileModuleName

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

    return @(Get-Module |
            Where-Object { $_.Path -and $_.Path.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) } |
            ForEach-Object { $_.Name } |
            Sort-Object -Unique)
}

function Show-ProfileHelp {
    <#
    .SYNOPSIS
        Lists the commands the profile has actually loaded.

    .DESCRIPTION
        Shows each loaded profile module with its exported commands and their aliases, taking the
        one-line summary from each function's own comment-based help.

        Because the listing is built from the live session, a command that failed to load cannot
        appear here, and a command that exists cannot be missing.

    .PARAMETER Section
        Limit the output to one module. Tab-completes from the modules currently loaded.

    .PARAMETER Detailed
        Include the synopsis for every command. Without it, only names and aliases are listed.

    .INPUTS
        [string] A module name.

    .OUTPUTS
        None. Writes to the host.

    .EXAMPLE
        Show-ProfileHelp
        Lists every loaded module and the commands it provides.

    .EXAMPLE
        Show-ProfileHelp -Section Git
        Lists just the Git plugin's commands.

    .EXAMPLE
        Show-ProfileHelp -Section WebSearch -Detailed
        Lists the WebSearch commands with a one-line description of each.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-help')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete)
                Get-ProfileModuleName | Where-Object { $_ -like "$wordToComplete*" }
            })]
        [string]$Section,

        [switch]$Detailed
    )

    process {
        $names = Get-ProfileModuleName

        if ($Section) {
            $names = @($names | Where-Object { $_ -eq $Section })

            if (-not $names.Count) {
                Write-Warning "No loaded profile module named '$Section'. Loaded: $((Get-ProfileModuleName) -join ', ')"
                return
            }
        }

        foreach ($name in $names) {
            $module = Get-Module -Name $name
            $functions = @($module.ExportedFunctions.Values | Sort-Object Name)

            if (-not $functions.Count) { continue }

            Write-Host ""
            Write-Host $name -ForegroundColor Cyan
            Write-Host ('-' * $name.Length) -ForegroundColor DarkGray

            foreach ($function in $functions) {
                $aliases = @($module.ExportedAliases.Values |
                        Where-Object { $_.Definition -eq $function.Name } |
                        ForEach-Object { $_.Name })

                $label = $function.Name
                if ($aliases.Count) { $label += '  (' + ($aliases -join ', ') + ')' }

                if (-not $Detailed) {
                    Write-Host "  $label"
                    continue
                }

                $synopsis = (Get-Help -Name $function.Name -ErrorAction SilentlyContinue).Synopsis
                if ($synopsis) { $synopsis = $synopsis.Trim() }

                Write-Host ("  {0}" -f $label)
                if ($synopsis -and $synopsis -ne $function.Name) {
                    Write-Host ("      {0}" -f $synopsis) -ForegroundColor DarkGray
                }
            }
        }

        Write-Host ""
        Write-Host "Run 'Get-Help <command> -Full' for detail, or Measure-ProfileLoad to see what loaded." -ForegroundColor DarkGray
        Write-Host ""
    }
}
