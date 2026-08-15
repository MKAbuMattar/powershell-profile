#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Lazy loading
#
# Dot-sourced by Loader.psm1.
#
# A lazily loaded module is not imported at startup. Instead each of its commands is replaced by a
# stub that, on first call, imports the real module, removes every stub, and re-invokes the command
# for real. The user sees the command work; they just do not pay for it in every shell that never
# calls it.
#
# This is opt-in per plugin, and deliberately so. A module that fails to import fails at the moment
# you first use it rather than at startup, which is a worse place to discover a problem. It is the
# right trade for Terminal-Icons, which costs 252 ms to colour output you may never look at, and
# the wrong trade for something you would rather know about immediately.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

$script:LazyRegistration = @{}

function Register-ProfileLazyCommand {
    <#
    .SYNOPSIS
        Registers stubs that import a plugin on first use.

    .PARAMETER Plugin
        A plugin object from Get-ProfilePlugin, with LazyCommands populated.

    .OUTPUTS
        None.

    .EXAMPLE
        Register-ProfileLazyCommand -Plugin (Get-ProfilePlugin Terraform)

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Plugin
    )

    foreach ($command in $Plugin.LazyCommands) {
        if (-not $command) { continue }

        $script:LazyRegistration[$command] = $Plugin

        # The stub closes over nothing: it looks itself up in the registration table by name, so
        # the table stays the single source of truth and the stub text is identical for every
        # command.
        $stub = @"
function global:$command {
    [CmdletBinding()]
    param([Parameter(ValueFromRemainingArguments)]`$Arguments)
    Resolve-ProfileLazyCommand -Name '$command' -Arguments `$Arguments
}
"@
        Invoke-Expression $stub
    }
}

function Resolve-ProfileLazyCommand {
    <#
    .SYNOPSIS
        Imports the plugin behind a stub, removes the stubs, and re-runs the real command.

    .DESCRIPTION
        Every stub for the same plugin is removed before importing, otherwise the import would be
        unable to define the real functions over the top of them and the second call would recurse.

    .PARAMETER Name
        The command that was invoked.

    .PARAMETER Arguments
        Arguments to pass on.

    .OUTPUTS
        Whatever the real command returns.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [object[]]$Arguments = @()
    )

    $plugin = $script:LazyRegistration[$Name]

    if (-not $plugin) {
        throw "No lazy registration for '$Name'."
    }

    # Remove every stub belonging to this plugin before importing, so the module's own definitions
    # win and a second call cannot land back here.
    foreach ($command in $plugin.LazyCommands) {
        if (Test-Path -LiteralPath "Function:\global:$command") {
            Remove-Item -LiteralPath "Function:\global:$command" -Force -ErrorAction SilentlyContinue
        }
        $script:LazyRegistration.Remove($command)
    }

    Write-Verbose "Lazily importing $($plugin.Name) because '$Name' was called."

    try {
        Import-Module -Name $plugin.Path -Global -Force -DisableNameChecking -ErrorAction Stop
    }
    catch {
        throw "Lazy import of plugin '$($plugin.Name)' failed: $($_.Exception.Message)"
    }

    $real = Get-Command -Name $Name -ErrorAction SilentlyContinue
    if (-not $real) {
        throw "Plugin '$($plugin.Name)' imported but does not define '$Name'. Check its LazyCommands list."
    }

    & $real @Arguments
}

$script:DeferredModule = [System.Collections.Generic.List[string]]::new()

function Register-ProfileDeferredModule {
    <#
    .SYNOPSIS
        Defers a Gallery module until just after the first prompt is drawn.

    .DESCRIPTION
        Terminal-Icons is the case that motivated this: 252 ms of every shell, roughly half of all
        module loading, spent so Get-ChildItem can show file-type icons.

        The obvious approach — stub the commands and import on first use — was tried and rejected.
        Terminal-Icons attaches to Get-ChildItem, and a global function shadowing a core cmdlet
        that everything including module auto-loading and tab completion depends on caused the
        shell to hang during startup. Shadowing Get-ChildItem is not a safe thing to do.

        This defers to the first prompt instead. Interactive shells pay the same total cost but
        reach a usable prompt sooner, and non-interactive shells -- `pwsh -c`, scripts, CI, every
        editor integration that runs one command -- never draw a prompt and so never pay it at all.

        Deferral is skipped when the host has no prompt to hook.

    .PARAMETER Name
        Gallery module names to defer.

    .OUTPUTS
        None.

    .EXAMPLE
        Register-ProfileDeferredModule -Name Terminal-Icons

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Name
    )

    foreach ($module in $Name) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Write-Verbose "Gallery module '$module' is not installed; nothing to defer."
            continue
        }
        if (-not $script:DeferredModule.Contains($module)) { $script:DeferredModule.Add($module) }
    }

    if (-not $script:DeferredModule.Count) { return }

    Enable-ProfileDeferredImport
}

function Enable-ProfileDeferredImport {
    <#
    .SYNOPSIS
        Wraps the prompt so deferred modules import once, after the first prompt.

    .DESCRIPTION
        Replaces `prompt` with a one-shot wrapper that restores the original before doing anything
        else, so the deferral cannot repeat or recurse even if an import throws.

    .OUTPUTS
        None.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not (Test-Path -LiteralPath 'Function:\global:prompt')) { return }
    if (Get-Variable -Name 'ProfileDeferredHooked' -Scope Script -ErrorAction SilentlyContinue) { return }

    $script:ProfileDeferredHooked = $true
    $script:OriginalPrompt = (Get-Item -LiteralPath 'Function:\global:prompt').ScriptBlock

    $loader = $ExecutionContext.SessionState.Module

    Set-Item -LiteralPath 'Function:\global:prompt' -Value {
        & $loader { Invoke-ProfileDeferredImport }
        & $loader { $script:OriginalPrompt }
    }.GetNewClosure()
}

function Invoke-ProfileDeferredImport {
    <#
    .SYNOPSIS
        Imports the deferred modules and restores the original prompt.

    .DESCRIPTION
        Restores first, so a failing import cannot leave the shell without a prompt or repeat the
        attempt on every keystroke.

    .OUTPUTS
        None.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    if (-not $script:DeferredModule.Count) { return }

    $modules = @($script:DeferredModule)
    $script:DeferredModule.Clear()

    if ($script:OriginalPrompt) {
        Set-Item -LiteralPath 'Function:\global:prompt' -Value $script:OriginalPrompt
    }

    foreach ($module in $modules) {
        try {
            Import-Module -Name $module -Global -ErrorAction Stop
            Write-Verbose "Deferred import of $module completed."
        }
        catch {
            Write-Warning "Deferred import of '$module' failed: $($_.Exception.Message)"
        }
    }
}
