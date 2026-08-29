#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Plugin discovery
#
# Dot-sourced by Loader.psm1.
#
# Before this, a plugin could only live at Module/Plugins/<Name>/<Name>.psd1 inside the repository,
# and Update-LocalProfileModuleDirectory moves that whole tree aside and replaces it from the
# archive. A plugin you wrote was therefore deleted by the next update, which made the plugin
# system a closed set rather than an extension point.
#
# Plugins are now discovered from several roots. Only the built-in one is inside the repository, so
# everything you write survives an update.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

$script:PluginCache = $null

function Get-ProfilePluginTool {
    <#
    .SYNOPSIS
        Returns the executable a built-in plugin wraps, or $null.

    .DESCRIPTION
        Built-in plugins predate the plugin.psd1 contract and declare no Tool of their own, so
        their tool comes from the loader's map. A plugin that declares Tool in its contract never
        reaches here.

    .PARAMETER Plugin
        Plugin name.

    .OUTPUTS
        [string] Executable name, or $null when the plugin has no known tool.

    .EXAMPLE
        Get-ProfilePluginTool -Plugin Kubectl
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Plugin
    )

    if ($script:PluginTool.ContainsKey($Plugin)) { return $script:PluginTool[$Plugin] }
    return $null
}

function Get-ProfilePluginRoot {
    <#
    .SYNOPSIS
        Returns the directories plugins are discovered from, in precedence order.

    .DESCRIPTION
        Later roots win, so a plugin you write can replace a built-in of the same name without
        forking the repository. The order is:

            1. Module/Plugins             built-in, replaced wholesale on update
            2. ~/.config/powershell-profile/plugins   yours, never touched by the updater
            3. $env:PROFILE_PLUGIN_PATH   additional roots, separated like PATH

        The user directory is created on demand by New-ProfilePlugin rather than at import, so a
        profile that never uses plugins leaves no directories behind.

    .PARAMETER RepositoryRoot
        Profile root. Defaults to the module's own repository.

    .OUTPUTS
        [PSCustomObject[]] Path and Scope for each existing root.

    .EXAMPLE
        Get-ProfilePluginRoot

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string]$RepositoryRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    )

    $roots = [System.Collections.Generic.List[PSCustomObject]]::new()

    $roots.Add([PSCustomObject]@{
            Path  = Join-Path $RepositoryRoot 'Module/Plugins'
            Scope = 'Builtin'
        })

    $roots.Add([PSCustomObject]@{
            Path  = Join-Path $HOME '.config/powershell-profile/plugins'
            Scope = 'User'
        })

    if ($env:PROFILE_PLUGIN_PATH) {
        foreach ($path in $env:PROFILE_PLUGIN_PATH -split [System.IO.Path]::PathSeparator) {
            if (-not $path.Trim()) { continue }
            $roots.Add([PSCustomObject]@{ Path = $path.Trim(); Scope = 'Environment' })
        }
    }

    return @($roots | Where-Object { Test-Path -LiteralPath $_.Path })
}

function Get-ProfilePlugin {
    <#
    .SYNOPSIS
        Lists every plugin found, where it came from, and whether it is enabled.

    .DESCRIPTION
        A plugin is a directory containing either plugin.psd1 (the contract described below) or,
        for the built-ins, a module manifest named after the directory.

        plugin.psd1 may declare:

            Name           display name; defaults to the directory name
            Module         manifest to import; defaults to <Name>.psd1
            Tool           executable that must exist for the plugin to be worth loading
            Description    one line, shown by Get-ProfilePlugin
            MinimumProfileVersion   refuse to load against an older profile
            LazyCommands   command names that import the module on first use

        When two roots provide the same plugin name, the later root wins and the shadowed one is
        reported, so an override is visible rather than mysterious.

    .PARAMETER Name
        Limit to plugins matching this name. Accepts wildcards.

    .PARAMETER Force
        Re-scan instead of using the cached result.

    .OUTPUTS
        [PSCustomObject[]] Name, Scope, Enabled, Loaded, Tool, ToolPresent, Path, Shadows.

    .EXAMPLE
        Get-ProfilePlugin
        Lists every plugin discovered.

    .EXAMPLE
        Get-ProfilePlugin | Where-Object { $_.Scope -eq 'User' }
        Shows only your own plugins.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-plugins')]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [string]$Name,

        [switch]$Force
    )

    if ($script:PluginCache -and -not $Force) {
        $cached = $script:PluginCache
    }
    else {
        $repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
        $config = Get-ProfileConfig -Path (Join-Path $repositoryRoot 'profile.config.psd1')
        $enabled = @($config.Plugins)

        # Ordered so a later root replaces an earlier one of the same name.
        $found = [ordered]@{}

        foreach ($root in Get-ProfilePluginRoot -RepositoryRoot $repositoryRoot) {
            foreach ($directory in Get-ChildItem -LiteralPath $root.Path -Directory -ErrorAction SilentlyContinue) {

                $contract = Join-Path $directory.FullName 'plugin.psd1'
                $manifest = $null
                $metadata = @{}

                if (Test-Path -LiteralPath $contract) {
                    try {
                        $metadata = Import-PowerShellDataFile -LiteralPath $contract
                    }
                    catch {
                        Write-Warning "Plugin contract at $contract is not valid: $($_.Exception.Message)"
                        continue
                    }

                    $moduleName = if ($metadata.Module) { $metadata.Module } else { "$($directory.Name).psd1" }
                    $manifest = Join-Path $directory.FullName $moduleName
                }
                else {
                    $manifest = Join-Path $directory.FullName "$($directory.Name).psd1"
                }

                if (-not (Test-Path -LiteralPath $manifest)) { continue }

                $pluginName = if ($metadata.Name) { $metadata.Name } else { $directory.Name }
                $tool = if ($metadata.ContainsKey('Tool')) { $metadata.Tool } else { Get-ProfilePluginTool -Plugin $pluginName }

                $shadows = if ($found.Contains($pluginName)) { $found[$pluginName].Scope } else { $null }

                $found[$pluginName] = [PSCustomObject]@{
                    Name         = $pluginName
                    Scope        = $root.Scope
                    Enabled      = $pluginName -in $enabled
                    Loaded       = [bool](Get-Module -Name ([System.IO.Path]::GetFileNameWithoutExtension($manifest)))
                    Tool         = $tool
                    ToolPresent  = if ($tool) { [bool](Get-Command -Name $tool -CommandType Application -ErrorAction SilentlyContinue) } else { $true }
                    Description  = $metadata.Description
                    LazyCommands = @($metadata.LazyCommands)
                    MinimumProfileVersion = $metadata.MinimumProfileVersion
                    Path         = $manifest
                    Shadows      = $shadows
                }
            }
        }

        $cached = @($found.Values)
        $script:PluginCache = $cached
    }

    if ($Name) { return @($cached | Where-Object { $_.Name -like $Name }) }
    return $cached
}

function Enable-ProfilePlugin {
    <#
    .SYNOPSIS
        Adds a plugin to the enabled list in profile.config.psd1.

    .DESCRIPTION
        Editing the configuration by hand is fine; this exists so that enabling something is one
        command rather than finding the right array and matching its indentation.

        The change applies on the next shell. Nothing is imported here, because importing halfway
        through a session gives a different result from a clean start.

    .PARAMETER Name
        Plugin to enable.

    .OUTPUTS
        None.

    .EXAMPLE
        Enable-ProfilePlugin Terraform

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('enable-plugin')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    process {
        foreach ($plugin in $Name) {
            Set-ProfilePluginState -Name $plugin -Enabled $true
        }
    }
}

function Disable-ProfilePlugin {
    <#
    .SYNOPSIS
        Removes a plugin from the enabled list in profile.config.psd1.

    .PARAMETER Name
        Plugin to disable.

    .OUTPUTS
        None.

    .EXAMPLE
        Disable-ProfilePlugin Kubectl

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('disable-plugin')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    process {
        foreach ($plugin in $Name) {
            Set-ProfilePluginState -Name $plugin -Enabled $false
        }
    }
}

function Set-ProfilePluginState {
    <#
    .SYNOPSIS
        Rewrites the Plugins array in profile.config.psd1.

    .DESCRIPTION
        Edits the array in place using the abstract syntax tree, so every comment and every
        commented-out plugin in the file survives. Re-serialising the hashtable would lose all of
        that, and those comments are half the documentation.

    .PARAMETER Name
        Plugin name.

    .PARAMETER Enabled
        Whether it should be listed.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][bool]$Enabled
    )

    $repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $configPath = Join-Path $repositoryRoot 'profile.config.psd1'

    if (-not (Test-Path -LiteralPath $configPath)) {
        Write-Warning "No configuration at $configPath."
        return
    }

    $known = @(Get-ProfilePlugin | ForEach-Object { $_.Name })
    if ($Enabled -and $Name -notin $known) {
        Write-Warning "No plugin named '$Name' was found. Known plugins: $($known -join ', ')"
        return
    }

    $content = (Get-Content -LiteralPath $configPath -Raw) -replace "`r`n", "`n"

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    if ($errors) {
        Write-Warning "Configuration at $configPath does not parse; not touching it."
        return
    }

    $hashtable = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.HashtableAst] }, $false)
    $pair = $hashtable.KeyValuePairs | Where-Object { $_.Item1.Extent.Text.Trim("'", '"') -eq 'Plugins' } | Select-Object -First 1

    if (-not $pair) {
        Write-Warning 'The configuration has no Plugins array.'
        return
    }

    $arrayText = $pair.Item2.Extent.Text
    $listed = $arrayText -match "(?m)^\s*'$([regex]::Escape($Name))'\s*$"

    if ($Enabled -and $listed) {
        Write-Host "$Name is already enabled." -ForegroundColor DarkGray
        return
    }
    if (-not $Enabled -and -not $listed) {
        Write-Host "$Name is already disabled." -ForegroundColor DarkGray
        return
    }

    if (-not $PSCmdlet.ShouldProcess($Name, $(if ($Enabled) { 'Enable plugin' } else { 'Disable plugin' }))) { return }

    if ($Enabled) {
        # Insert before the closing paren, matching the indentation of the entries above it.
        $updated = $arrayText -replace "(\n)(\s*)\)$", "`$1        '$Name'`$1`$2)"
    }
    else {
        # Comment it out rather than deleting it, so re-enabling by hand is obvious.
        $updated = $arrayText -replace "(?m)^(\s*)'$([regex]::Escape($Name))'\s*$", "`$1# '$Name'"
    }

    $start = $pair.Item2.Extent.StartOffset
    $end = $pair.Item2.Extent.EndOffset
    $content = $content.Substring(0, $start) + $updated + $content.Substring($end)

    Set-Content -LiteralPath $configPath -Value $content -NoNewline -Encoding UTF8

    $script:PluginCache = $null
    Write-Host ("{0} {1}. Restart your shell to apply." -f $Name, $(if ($Enabled) { 'enabled' } else { 'disabled' })) -ForegroundColor Green
}

function New-ProfilePlugin {
    <#
    .SYNOPSIS
        Scaffolds a working plugin in your own plugin directory.

    .DESCRIPTION
        Creates a plugin under ~/.config/powershell-profile/plugins, outside the repository, so it
        survives updates. The generated plugin loads as-is and has one working command to edit.

        Give it the name of an existing built-in to override that built-in rather than fork it.

    .PARAMETER Name
        Plugin name. Becomes the directory and module name.

    .PARAMETER Tool
        Executable the plugin wraps. The plugin is skipped when it is absent.

    .PARAMETER Description
        One-line description.

    .PARAMETER Path
        Where to create it. Defaults to the user plugin directory.

    .OUTPUTS
        [string] Path to the created plugin.

    .EXAMPLE
        New-ProfilePlugin -Name Gradle -Tool gradle -Description 'Gradle shortcuts'
        Scaffolds a Gradle plugin and tells you how to enable it.

    .EXAMPLE
        New-ProfilePlugin -Name Git -Tool git
        Creates a user plugin that overrides the built-in Git plugin.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('new-plugin')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('^[A-Za-z][A-Za-z0-9_-]*$')]
        [string]$Name,

        [Parameter(Position = 1)]
        [string]$Tool,

        [string]$Description = "$Name shortcuts",

        [string]$Path = (Join-Path $HOME '.config/powershell-profile/plugins')
    )

    $directory = Join-Path $Path $Name

    if (Test-Path -LiteralPath $directory) {
        Write-Warning "A plugin already exists at $directory."
        return
    }

    if (-not $PSCmdlet.ShouldProcess($directory, 'Create plugin')) { return }

    $null = New-Item -ItemType Directory -Path $directory -Force

    $toolLine = if ($Tool) { "    Tool                  = '$Tool'" } else { '    # Tool                = ' + "'$($Name.ToLower())'" }
    $sample = if ($Tool) { $Tool } else { $Name.ToLower() }

    @"
#---------------------------------------------------------------------------------------------------
# $Name plugin contract
#
# Read by the profile loader. Everything except Name is optional.
#---------------------------------------------------------------------------------------------------

@{
    Name                  = '$Name'
    Description           = '$Description'
$toolLine

    # Module manifest to import. Defaults to <Name>.psd1 beside this file.
    Module                = '$Name.psd1'

    # Refuse to load against an older profile.
    MinimumProfileVersion = '$script:ProfileVersion'

    # Commands that import this plugin on first use instead of at startup. Leave empty to load
    # normally; a plugin that fails should usually fail at startup, not halfway through a command.
    LazyCommands          = @()
}
"@ | Set-Content -LiteralPath (Join-Path $directory 'plugin.psd1') -Encoding UTF8

    @"
#---------------------------------------------------------------------------------------------------
# $Name - $Description
#---------------------------------------------------------------------------------------------------

function Invoke-$Name {
    <#
    .SYNOPSIS
        Wraps the $sample command.

    .DESCRIPTION
        Replace this with something useful. Arguments are passed straight through.

    .PARAMETER Arguments
        Passed to $sample unchanged.

    .EXAMPLE
        Invoke-$Name --version
    #>
    [CmdletBinding()]
    [Alias('$($Name.ToLower())')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]`$Arguments
    )

    & $sample @Arguments
}
"@ | Set-Content -LiteralPath (Join-Path $directory "$Name.psm1") -Encoding UTF8

    @"
@{
    RootModule           = '$Name.psm1'
    ModuleVersion        = '1.0.0'
    CompatiblePSEditions = @('Core')
    GUID                 = '$([guid]::NewGuid())'
    Author               = '$env:USERNAME'
    Description          = '$Description'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @('Invoke-$Name')
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @('$($Name.ToLower())')
}
"@ | Set-Content -LiteralPath (Join-Path $directory "$Name.psd1") -Encoding UTF8

    @"
# $Name

$Description

Created with ``New-ProfilePlugin``. Lives outside the repository, so ``Update-Profile`` will not
remove it.

## Enable

``````powershell
Enable-ProfilePlugin $Name
``````

Then restart your shell.
"@ | Set-Content -LiteralPath (Join-Path $directory 'README.md') -Encoding UTF8

    $script:PluginCache = $null

    Write-Host ''
    Write-Host "Created $Name at $directory" -ForegroundColor Green
    Write-Host "  Enable-ProfilePlugin $Name    then restart your shell"
    Write-Host ''

    return $directory
}
