#Requires -Version 5.1
<#
.SYNOPSIS
    Fails when a function accepts pipeline input but has no process block.

.DESCRIPTION
    A parameter marked ValueFromPipeline or ValueFromPipelineByPropertyName only receives every
    piped item if the function body is a process block. Without one, the body runs once and the
    parameter holds the LAST item, silently discarding the rest:

        'a','b','c' | Write-LogMessage      # logs only "c"

    This check finds that mismatch. The fix is one of two things, depending on intent: give the
    function a process block so it streams, or drop the pipeline binding from parameters that were
    never meant to be piped into. Most of these were copy-paste, not design.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.EXAMPLE
    ./Tools/Test-Pipeline.ps1
    Lists every function with the mismatch and exits non-zero if any exist.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding()]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path
)

# $PSScriptRoot is empty inside a param() default under Windows PowerShell 5.1, so the repository
# root is resolved here instead.
if (-not $Path) { $Path = Split-Path -Parent $PSScriptRoot }

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$offenders = 0

# Extension, not -Include: Windows PowerShell 5.1 ignores -Include alongside -LiteralPath.
foreach ($file in Get-ChildItem -LiteralPath $Path -Recurse -File |
    Where-Object { $_.Extension -in '.ps1', '.psm1' } |
    Where-Object { $_.FullName -notmatch '[\\/](\.git|Tools)[\\/]' }) {

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
    if ($errors) { continue }

    $functions = @($ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] },
            $true))

    foreach ($function in $functions) {
        $paramBlock = $function.Body.ParamBlock
        if (-not $paramBlock) { continue }

        $found = foreach ($parameter in $paramBlock.Parameters) {
            foreach ($attribute in $parameter.Attributes) {
                if ($attribute -isnot [System.Management.Automation.Language.AttributeAst]) { continue }
                if ($attribute.TypeName.Name -ne 'Parameter') { continue }

                foreach ($named in $attribute.NamedArguments) {
                    if ($named.ArgumentName -notin 'ValueFromPipeline', 'ValueFromPipelineByPropertyName') { continue }

                    # `ValueFromPipeline` with no value is implicitly $true.
                    $value = if ($named.ExpressionOmitted) { $true } else { $named.Argument.Extent.Text -match '\$true' }
                    if ($value) { $parameter.Name.VariablePath.UserPath }
                }
            }
        }

        $piped = @($found | Sort-Object -Unique)

        if (-not $piped.Count) { continue }
        if ($function.Body.ProcessBlock) { continue }

        $offenders++
        $relative = $file.FullName.Substring($Path.Length).TrimStart('\', '/')
        Write-Host ("FAIL {0}:{1} {2}" -f $relative, $function.Extent.StartLineNumber, $function.Name) -ForegroundColor Red
        Write-Host ("     pipeline-bound but no process block: {0}" -f (($piped | ForEach-Object { "-$_" }) -join ', '))
    }
}

Write-Host ""
if ($offenders -gt 0) {
    Write-Host ("{0} function(s) accept pipeline input without a process block." -f $offenders)
    exit 1
}

Write-Host "Every pipeline-bound parameter is backed by a process block." -ForegroundColor Green
exit 0
