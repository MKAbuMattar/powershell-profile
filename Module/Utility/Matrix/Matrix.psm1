function Start-Matrix {
    <#
    .SYNOPSIS
        Displays a matrix rain animation in the console.

    .DESCRIPTION
        This function displays a matrix rain animation in the console. It simulates the falling
        green characters from the movie "The Matrix". The animation can be stopped by pressing
        Ctrl+C or 'Q' key. Uses Python backend for smooth cross-platform animation.

    .PARAMETER SleepTime
        Specifies the time in seconds to wait between updating the animation.
        Default value is 0.06 seconds. Lower values = faster animation.
        Valid range: 0.01 - 10 seconds.

    .INPUTS
        SleepTime: (Optional) The time in seconds to wait between animation updates.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function requires Python 3.6+ with the matrix.py script available.
        Implemented using a Python backend for smooth cross-platform animation.
        Animation auto-detects terminal size and adapts accordingly.

    .EXAMPLE
        Start-Matrix
        Displays the matrix rain animation with default speed.

    .EXAMPLE
        Start-Matrix -SleepTime 0.1
        Displays the matrix rain animation with slower update speed (0.1 seconds).

    .EXAMPLE
        Start-Matrix 0.04
        Displays the matrix rain animation with faster update speed (0.04 seconds).

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias("matrix")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The time in seconds to wait between updating the animation."
        )]
        [Alias("s")]
        [double]$SleepTime = 30
    )

    $scriptDir = Split-Path -Parent $PSCommandPath
    $pythonScript = Join-Path $scriptDir "matrix.py"

    if (-not (Test-Path $pythonScript)) {
        Write-Error "matrix.py not found at: $pythonScript"
        return
    }

    $pythonCmd = $null
    try {
        $pythonCmd = Get-Command python -ErrorAction Stop
    }
    catch {
        try {
            $pythonCmd = Get-Command python3 -ErrorAction Stop
        }
        catch {
            Write-Error "Python is not installed or not available in PATH"
            return
        }
    }

    $pythonPath = $pythonCmd.Source

    try {
        if ($SleepTime -lt 0.01 -or $SleepTime -gt 50) {
            Write-Error "Sleep time must be between 0.01 and 50 seconds"
            return
        }

        $arguments = @($pythonScript, "--sleep", $SleepTime)
        & $pythonPath $arguments 2>&1
    }
    catch {
        Write-Error "Failed to start matrix animation: $_"
    }
}
