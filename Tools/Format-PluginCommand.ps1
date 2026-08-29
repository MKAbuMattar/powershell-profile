#Requires -Version 5.1
<#
.SYNOPSIS
    Renders a plugin command table as PowerShell source.

.DESCRIPTION
    Dot-source this to get Format-PluginCommandModule, shared by Tools/Update-PluginCommand.ps1
    (which writes the file) and Tools/Test-PluginCommand.ps1 (which verifies it). One
    implementation means generated and checked cannot disagree.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

Set-StrictMode -Version Latest

function Format-PluginCommandModule {
    <#
    .SYNOPSIS
        Returns the full text of a generated wrapper module.

    .PARAMETER Plugin
        Plugin name, used in the header.

    .PARAMETER Tool
        Executable the wrappers invoke.

    .PARAMETER Command
        Rows from commands.psd1.

    .OUTPUTS
        [string] Module source, newline-normalised.

    .EXAMPLE
        Format-PluginCommandModule -Plugin Git -Tool git -Command $rows
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Plugin,
        [Parameter(Mandatory)][string]$Tool,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Command
    )

    function Get-RowField {
        <#
        .SYNOPSIS
            Reads an optional key from a table row.

        .DESCRIPTION
            Rows arrive as hashtables from Import-PowerShellDataFile and most omit the optional
            keys. Set-StrictMode is on, so the key is tested before it is read.
        #>
        param($Row, [string]$Key)

        if ($Row -is [hashtable] -and $Row.ContainsKey($Key)) { return $Row[$Key] }
        return $null
    }

    $lines = [System.Collections.Generic.List[string]]::new()

    $lines.Add('#---------------------------------------------------------------------------------------------------')
    $lines.Add("# MKAbuMattar's PowerShell Profile - $Plugin generated commands")
    $lines.Add('#')
    $lines.Add('# GENERATED FILE. Do not edit.')
    $lines.Add('#')
    $lines.Add("# Source of truth is commands.psd1 beside this file. Add or change a command there and run")
    $lines.Add('# Tools/Update-PluginCommand.ps1. Tools/Test-PluginCommand.ps1 fails CI when the two disagree.')
    $lines.Add('#')
    $lines.Add("# Every function here wraps `$Tool` and passes the remaining arguments through unchanged.")
    $lines.Add('#---------------------------------------------------------------------------------------------------')
    $lines.Add('')

    foreach ($row in $Command) {
        $name = $row.Name
        $arguments = @($row.Args)
        $aliases = @($row.Aliases)

        # An optional leading parameter, so a wrapper can keep a named first argument such as
        # -PackageName instead of collecting everything into -Arguments. Rows without it generate
        # exactly what they did before this key existed.
        $leading = Get-RowField -Row $row -Key 'Param'
        $leadingHelp = Get-RowField -Row $row -Key 'ParamHelp'

        $invocation = if ($arguments.Count) {
            "& $Tool " + ($arguments -join ' ') + ' @Arguments'
        }
        else {
            "& $Tool @Arguments"
        }

        $synopsis = if ($row.Synopsis) { $row.Synopsis } else { "Wraps ``$invocation``." }
        $shown = if ($arguments.Count) { "$Tool " + ($arguments -join ' ') } else { $Tool }

        $lines.Add("function $name {")
        $lines.Add('    <#')
        $lines.Add('    .SYNOPSIS')
        $lines.Add("        $synopsis")
        $lines.Add('')
        $lines.Add('    .DESCRIPTION')
        $lines.Add("        Runs ``$shown`` with any additional arguments appended.")
        $lines.Add('')

        if ($leading) {
            $lines.Add("    .PARAMETER $leading")
            $lines.Add('        ' + $(if ($leadingHelp) { $leadingHelp } else { "First argument to ``$shown``." }))
            $lines.Add('')
        }

        $lines.Add('    .PARAMETER Arguments')
        $lines.Add("        Passed to ``$shown`` unchanged.")
        $lines.Add('')
        $lines.Add('    .INPUTS')
        $lines.Add('        None.')
        $lines.Add('')
        $lines.Add('    .OUTPUTS')
        $lines.Add("        None. Writes whatever $Tool writes.")
        $lines.Add('')
        $lines.Add('    .EXAMPLE')
        $lines.Add("        $name")
        $lines.Add("        Runs ``$shown``.")
        $lines.Add('')
        $lines.Add('    .LINK')
        $lines.Add('        https://github.com/MKAbuMattar/powershell-profile')
        $lines.Add('    #>')
        $lines.Add('    [CmdletBinding()]')

        if ($aliases.Count) {
            $lines.Add('    [Alias(' + (($aliases | ForEach-Object { "'$_'" }) -join ', ') + ')]')
        }

        $lines.Add('    [OutputType([void])]')
        $lines.Add('    param(')

        if ($leading) {
            $lines.Add('        [Parameter(Position = 0)]')
            $lines.Add("        [string]`$$leading,")
            $lines.Add('')
        }

        $lines.Add('        [Parameter(ValueFromRemainingArguments)]')
        $lines.Add('        [string[]]$Arguments')
        $lines.Add('    )')
        $lines.Add('')

        if ($leading) {
            # Built up rather than splatted inline, because an unbound leading parameter must not
            # reach the tool as an empty argument.
            $lines.Add('    $all = @(' + (($arguments | ForEach-Object { "'$_'" }) -join ', ') + ')')
            $lines.Add("    if (`$$leading) { `$all += `$$leading }")
            $lines.Add('    if ($Arguments) { $all += $Arguments }')
            $lines.Add('')
            $lines.Add("    & $Tool @all")
        }
        else {
            $lines.Add("    $invocation")
        }

        $lines.Add('}')
        $lines.Add('')
    }

    return (($lines -join "`n").TrimEnd() + "`n")
}
