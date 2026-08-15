#Requires -Version 5.1
<#
.SYNOPSIS
    Wraps the body of pipeline-bound functions in a process block.

.DESCRIPTION
    Fixes what Tools/Test-Pipeline.ps1 reports: a function whose parameters are marked
    ValueFromPipeline but whose body is not a process block receives only the last piped item.

    Every statement after the param block is moved into `process { }` and re-indented. Functions
    that already have a begin, process or end block are left alone, as are functions that
    reference $input, because both mean the author thought about pipeline behaviour already.

    Run Tools/Test-Pipeline.ps1 afterwards to confirm, and Tools/Test-Load.ps1 to confirm every
    module still imports.

.PARAMETER Path
    Repository root to scan. Defaults to the parent of the directory holding this script.

.PARAMETER WhatIf
    Report what would change without writing.

.EXAMPLE
    ./Tools/Add-ProcessBlock.ps1 -WhatIf
    Lists the functions that would be rewritten.

.EXAMPLE
    ./Tools/Add-ProcessBlock.ps1
    Rewrites them.

.LINK
    https://github.com/MKAbuMattar/powershell-profile
#>
[CmdletBinding(SupportsShouldProcess)]
[OutputType([int])]
param(
    [Parameter(Position = 0)]
    [string]$Path = (Split-Path -Parent $PSScriptRoot)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-PipelineParameterName {
    <#
    .SYNOPSIS
        Returns the names of parameters bound to the pipeline.
    #>
    param([System.Management.Automation.Language.ParamBlockAst]$ParamBlock)

    $found = foreach ($parameter in $ParamBlock.Parameters) {
        foreach ($attribute in $parameter.Attributes) {
            if ($attribute -isnot [System.Management.Automation.Language.AttributeAst]) { continue }
            if ($attribute.TypeName.Name -ne 'Parameter') { continue }

            foreach ($named in $attribute.NamedArguments) {
                if ($named.ArgumentName -notin 'ValueFromPipeline', 'ValueFromPipelineByPropertyName') { continue }

                $value = if ($named.ExpressionOmitted) { $true } else { $named.Argument.Extent.Text -match '\$true' }
                if ($value) { $parameter.Name.VariablePath.UserPath }
            }
        }
    }

    return @($found | Sort-Object -Unique)
}

$changedFiles = 0
$changedFunctions = 0

foreach ($file in Get-ChildItem -LiteralPath $Path -Recurse -File -Include '*.ps1', '*.psm1' |
    Where-Object { $_.FullName -notmatch '[\\/](\.git|Tools)[\\/]' }) {

    $content = Get-Content -LiteralPath $file.FullName -Raw

    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$errors)
    if ($errors) { continue }

    $targets = foreach ($function in $ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)) {

        $body = $function.Body
        if (-not $body.ParamBlock) { continue }
        if ($body.ProcessBlock -or $body.BeginBlock) { continue }
        if (-not $body.EndBlock) { continue }
        if (-not $body.EndBlock.Unnamed) { continue }
        if ($function.Extent.Text -match '\$input\b') { continue }

        $pipedNames = @(Get-PipelineParameterName -ParamBlock $body.ParamBlock)
        if ($pipedNames.Count -eq 0) { continue }

        $statements = @($body.EndBlock.Statements)
        if ($statements.Count -eq 0) { continue }

        $function
    }

    $targets = @($targets)
    if (-not $targets.Count) { continue }

    # Rewrite from the bottom up so earlier offsets stay valid.
    foreach ($function in ($targets | Sort-Object { $_.Extent.StartOffset } -Descending)) {
        $statements = @($function.Body.EndBlock.Statements)

        $start = $statements[0].Extent.StartOffset
        $end = $statements[-1].Extent.EndOffset

        # Walk back to the start of the first statement's line so its own indentation is captured.
        $lineStart = $start
        while ($lineStart -gt 0 -and $content[$lineStart - 1] -ne "`n") { $lineStart-- }

        $indent = $content.Substring($lineStart, $start - $lineStart)
        if ($indent -match '\S') { $indent = '    ' }

        $bodyText = $content.Substring($start, $end - $start)

        $reindented = ($bodyText -split "`r?`n" | ForEach-Object {
                if ($_.Trim()) { '    ' + $_ } else { $_ }
            }) -join [Environment]::NewLine

        $replacement = "process {" + [Environment]::NewLine +
        $indent + '    ' + $reindented.TrimStart() + [Environment]::NewLine +
        $indent + "}"

        $content = $content.Substring(0, $start) + $replacement + $content.Substring($end)
        $changedFunctions++

        Write-Host ("  {0}:{1} {2}" -f $file.FullName.Substring($Path.Length).TrimStart('\', '/'), $function.Extent.StartLineNumber, $function.Name)
    }

    # Never write a file this script just broke.
    $verifyErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$tokens, [ref]$verifyErrors)
    if ($verifyErrors) {
        Write-Host ("  SKIPPED {0}: rewrite did not parse, file left unchanged" -f $file.Name) -ForegroundColor Red
        continue
    }

    if ($PSCmdlet.ShouldProcess($file.Name, 'Add process blocks')) {
        Set-Content -LiteralPath $file.FullName -Value $content -NoNewline -Encoding UTF8
    }

    $changedFiles++
}

Write-Host ""
Write-Host ("{0} function(s) across {1} file(s)." -f $changedFunctions, $changedFiles)
exit 0
