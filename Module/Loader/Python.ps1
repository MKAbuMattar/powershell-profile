#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Python interpreter resolution
#
# Dot-sourced by Loader.psm1. Eleven utility modules shell out to a bundled Python script, and
# each had grown its own way of finding an interpreter - seven variants in total, one of which
# hardcoded bare `python`. On Windows that name is a Microsoft Store stub that prints an advert
# and exits 9009 when Python is not installed from the Store.
#
# This is the counterpart to DOTFILES_PYTHON in .dotfiles/.plugins/.plugins.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

$script:PythonExecutable = $null

function Get-PythonExecutable {
    <#
    .SYNOPSIS
        Returns the path to a usable Python 3 interpreter, or $null.

    .DESCRIPTION
        Probes versioned interpreter names newest first, then the unversioned ones, and verifies
        each actually runs before accepting it. The Windows Store stub named `python.exe` is
        rejected because it fails the version probe.

        Set $env:PROFILE_PYTHON to pin a specific interpreter and skip discovery entirely.

        The result is cached for the session, so the probe cost is paid once.

    .PARAMETER Force
        Re-probe instead of reusing the cached result.

    .INPUTS
        None.

    .OUTPUTS
        [string] Full path to the interpreter, or $null when none was found.

    .EXAMPLE
        Get-PythonExecutable
        Returns something like C:\Python312\python.exe.

    .EXAMPLE
        $python = Get-PythonExecutable
        if ($python) { & $python script.py }

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('profile-python')]
    [OutputType([string])]
    param(
        [switch]$Force
    )

    if ($script:PythonExecutable -and -not $Force) { return $script:PythonExecutable }

    $candidates = @()
    if ($env:PROFILE_PYTHON) { $candidates += $env:PROFILE_PYTHON }
    $candidates += 'python3.14', 'python3.13', 'python3.12', 'python3.11', 'python3.10', 'python3.9', 'python3', 'python'

    foreach ($candidate in $candidates) {
        $command = Get-Command -Name $candidate -CommandType Application -ErrorAction SilentlyContinue |
            Select-Object -First 1

        if (-not $command) { continue }

        # The Store stub resolves as an Application but fails here, which is exactly what we want.
        $version = & $command.Source '--version' 2>&1
        if ($LASTEXITCODE -ne 0) { continue }
        if ($version -notmatch 'Python 3') { continue }

        $script:PythonExecutable = $command.Source
        return $script:PythonExecutable
    }

    return $null
}

function Invoke-ProfilePython {
    <#
    .SYNOPSIS
        Runs one of the bundled Python scripts, or explains why it cannot.

    .DESCRIPTION
        The single place the utility modules call to reach their Python backend. Replaces the
        per-module blocks that each re-implemented interpreter discovery, script existence
        checking and error reporting.

    .PARAMETER ScriptPath
        Full path to the .py file to run.

    .PARAMETER Arguments
        Arguments passed through to the script.

    .INPUTS
        None.

    .OUTPUTS
        Whatever the script writes to stdout.

    .EXAMPLE
        Invoke-ProfilePython -ScriptPath "$PSScriptRoot/qrcode.py" -Arguments @('--text', 'hello')

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$ScriptPath,

        [Parameter(Position = 1, ValueFromRemainingArguments)]
        [string[]]$Arguments = @()
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        Write-Error "Python script not found at $ScriptPath. The profile install may be incomplete; run Update-Profile."
        return
    }

    $python = Get-PythonExecutable
    if (-not $python) {
        Write-Error 'Python 3 was not found. Install it with Install-ProfileDependency, or set $env:PROFILE_PYTHON to an interpreter.'
        return
    }

    & $python $ScriptPath @Arguments
}
