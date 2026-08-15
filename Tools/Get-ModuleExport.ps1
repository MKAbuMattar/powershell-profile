#Requires -Version 5.1
<#
.SYNOPSIS
    Derives the correct export lists for a module from its source.

.DESCRIPTION
    Dot-source this to get Get-ModuleExport, the single implementation shared by
    Update-Manifest.ps1 (which writes the lists) and Test-Manifest.ps1 (which verifies them).
    Keeping one implementation is what makes "generated" and "checked" mean the same thing.

    Function names and function-level [Alias()] values are read from the abstract syntax tree,
    so a parameter-level [Alias()] is never mistaken for a function-level one.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>

Set-StrictMode -Version Latest

function Get-ModuleExport {
    <#
    .SYNOPSIS
        Returns the functions and aliases a module should export.

    .PARAMETER ModulePath
        Path to the .psm1 to inspect.

    .PARAMETER Policy
        The hashtable loaded from Tools/ExportPolicy.psd1.

    .OUTPUTS
        A PSCustomObject with Functions, Aliases, Skipped and ParseErrors properties.

    .EXAMPLE
        Get-ModuleExport -ModulePath ./Module/Network/Network.psm1 -Policy $policy
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$ModulePath,

        [Parameter(Mandatory, Position = 1)]
        [hashtable]$Policy
    )

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($ModulePath, [ref]$tokens, [ref]$errors)

    if ($errors) {
        return [PSCustomObject]@{
            Functions   = @()
            Aliases     = @()
            Skipped     = @()
            ParseErrors = @($errors)
        }
    }

    $definitions = @($ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] },
            $true))

    # A module may split itself across dot-sourced .ps1 files, as Loader.psm1 does. Those
    # functions are part of the module's surface and belong in its export lists, so follow
    # each dot-source one level and collect what it defines.
    $moduleDirectory = Split-Path -Parent $ModulePath

    $dotSourced = @($ast.FindAll(
            { param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and
                $node.InvocationOperator -eq [System.Management.Automation.Language.TokenKind]::Dot },
            $true))

    foreach ($command in $dotSourced) {
        $literal = $command.FindAll(
            { param($node)
                $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
                $node.Value -like '*.ps1' },
            $true) | Select-Object -First 1

        if (-not $literal) { continue }

        $included = Join-Path $moduleDirectory $literal.Value
        if (-not (Test-Path -LiteralPath $included)) { continue }

        $includedTokens = $null
        $includedErrors = $null
        $includedAst = [System.Management.Automation.Language.Parser]::ParseFile($included, [ref]$includedTokens, [ref]$includedErrors)
        if ($includedErrors) { continue }

        $definitions += @($includedAst.FindAll(
                { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] },
                $true))
    }

    $functions = [System.Collections.Generic.List[string]]::new()
    $aliases = [System.Collections.Generic.List[string]]::new()
    $skipped = [System.Collections.Generic.List[string]]::new()

    foreach ($definition in $definitions) {
        if ($definition.Name -in $Policy.PrivateFunctions) { continue }

        $functions.Add($definition.Name)

        $paramBlock = $definition.Body.ParamBlock
        if (-not $paramBlock) { continue }

        foreach ($attribute in $paramBlock.Attributes) {
            if ($attribute.TypeName.Name -ne 'Alias') { continue }

            foreach ($argument in $attribute.PositionalArguments) {
                $name = $argument.Value
                if (-not $name) { continue }

                if ($name -in $Policy.ReservedAliases) {
                    $skipped.Add($name)
                    continue
                }

                # An alias whose name matches its own function, ignoring case, shadows that
                # function and resolves to itself, so the command becomes uncallable. This is
                # what happened to Update-Profile / update-profile.
                if ($name -eq $definition.Name) {
                    $skipped.Add($name)
                    continue
                }

                $aliases.Add($name)
            }
        }
    }

    return [PSCustomObject]@{
        Functions   = @($functions)
        Aliases     = @($aliases)
        Skipped     = @($skipped | Sort-Object -Unique)
        ParseErrors = @()
    }
}
