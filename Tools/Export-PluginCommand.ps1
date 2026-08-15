#Requires -Version 5.1
<#
.SYNOPSIS
    Extracts pure tool-wrapper functions from a plugin into a commands.psd1 table.

.DESCRIPTION
    A "pure wrapper" is a function whose entire body is one statement invoking an external tool
    and splatting @Arguments:

        & git add --all @Arguments

    200 of the 828 plugin functions are exactly this, wrapped in about 21 lines of comment-based
    help each. Git alone has 132. That volume is why gcb and gcB sat 40 lines apart for months
    without anyone noticing they were the same name.

    This reads them out into a table. Tools/Update-PluginCommand.ps1 turns the table back into
    generated source, and Tools/Test-PluginCommand.ps1 fails CI when the two disagree.

    Generation is static, not at import time. Generating 132 functions with Invoke-Expression was
    measured at 971 ms, against 48 ms to import the whole hand-written 5,854-line module -- so
    doing it at runtime would have made startup twenty times worse. The table is the source of
    truth; the generated .psm1 is committed.

    Functions that do anything else are left alone, and reported as skipped.

.PARAMETER ModulePath
    The .psm1 to read.

.PARAMETER OutputPath
    Where to write commands.psd1. Defaults to beside the module.

.EXAMPLE
    ./Tools/Export-PluginCommand.ps1 -ModulePath ./Module/Plugins/Git/Git.psm1
    Writes Module/Plugins/Git/commands.psd1.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
[OutputType([int])]
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$ModulePath,

    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $OutputPath) {
    $OutputPath = Join-Path (Split-Path -Parent $ModulePath) 'commands.psd1'
}

$tokens = $null
$errors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile($ModulePath, [ref]$tokens, [ref]$errors)
if ($errors) { throw "$ModulePath does not parse." }

$wrappers = [System.Collections.Generic.List[hashtable]]::new()
$skipped = 0
$tool = $null

foreach ($function in $ast.FindAll(
        { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] },
        $true)) {

    $body = $function.Body
    $statements = @(@($body.EndBlock.Statements) + @(if ($body.ProcessBlock) { $body.ProcessBlock.Statements }) |
            Where-Object { $_ })

    if ($statements.Count -ne 1) { $skipped++; continue }

    $text = $statements[0].Extent.Text.Trim()

    # & <tool> <literal args...> @Arguments   and nothing else.
    if ($text -notmatch '^&\s+(?<tool>[\w][\w.-]*)(?<args>(?:\s+[^\s@]+)*)\s+@Arguments$') {
        $skipped++
        continue
    }

    $thisTool = $Matches['tool']
    $arguments = @($Matches['args'].Trim() -split '\s+' | Where-Object { $_ })

    if (-not $tool) { $tool = $thisTool }
    if ($thisTool -ne $tool) { $skipped++; continue }

    $help = $function.GetHelpContent()
    $synopsis = if ($help -and $help.Synopsis) { ($help.Synopsis -replace '\s+', ' ').Trim() } else { '' }

    $aliases = @()
    if ($body.ParamBlock) {
        foreach ($attribute in $body.ParamBlock.Attributes) {
            if ($attribute.TypeName.Name -ne 'Alias') { continue }
            foreach ($argument in $attribute.PositionalArguments) {
                if ($argument.Value) { $aliases += $argument.Value }
            }
        }
    }

    $wrappers.Add(@{
            Name     = $function.Name
            Args     = $arguments
            Aliases  = $aliases
            Synopsis = $synopsis
        })
}

Write-Host ("{0}: {1} pure wrapper(s) for '{2}', {3} function(s) left alone." -f `
    (Split-Path -Leaf $ModulePath), $wrappers.Count, $tool, $skipped)

if (-not $wrappers.Count) { exit 0 }

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('#---------------------------------------------------------------------------------------------------')
$lines.Add("# $((Split-Path -Leaf (Split-Path -Parent $ModulePath))) - generated command table")
$lines.Add('#')
$lines.Add('# One row per pure wrapper: a function whose whole body invokes the tool and passes the')
$lines.Add('# remaining arguments through. This file is the source of truth; the functions themselves are')
$lines.Add('# generated into *.Generated.psm1 by Tools/Update-PluginCommand.ps1.')
$lines.Add('#')
$lines.Add('# Adding a command means adding a row here and re-running the generator.')
$lines.Add('#---------------------------------------------------------------------------------------------------')
$lines.Add('')
$lines.Add('@{')
$lines.Add("    Tool     = '$tool'")
$lines.Add('    Commands = @(')

foreach ($wrapper in $wrappers) {
    $argText = if ($wrapper.Args.Count) {
        '@(' + (($wrapper.Args | ForEach-Object { "'$_'" }) -join ', ') + ')'
    }
    else {
        '@()'
    }

    $aliasText = if ($wrapper.Aliases.Count) {
        '@(' + (($wrapper.Aliases | ForEach-Object { "'$_'" }) -join ', ') + ')'
    }
    else {
        '@()'
    }

    $synopsis = $wrapper.Synopsis -replace "'", "''"

    $lines.Add(("        @{{ Name = '{0}'; Args = {1}; Aliases = {2}; Synopsis = '{3}' }}" -f `
                $wrapper.Name, $argText, $aliasText, $synopsis))
}

$lines.Add('    )')
$lines.Add('}')

if ($PSCmdlet.ShouldProcess($OutputPath, 'Write command table')) {
    Set-Content -LiteralPath $OutputPath -Value ($lines -join [Environment]::NewLine) -Encoding UTF8
    Write-Host "  wrote $OutputPath"
}

exit 0
