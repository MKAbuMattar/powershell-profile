function Start-Matrix {
    <#
    .SYNOPSIS
        Displays a matrix rain animation in the console.

    .DESCRIPTION
        This function displays a matrix rain animation in the console. It simulates the falling green characters from the movie "The Matrix". The animation can be stopped by pressing the "Q" key.

    .PARAMETER SleepTime
        Specifies the time in milliseconds to wait between updating the animation. The default value is 1 millisecond.

    .INPUTS
        SleepTime: (Optional) The time in milliseconds to wait between updating the animation. The default value is 1 millisecond.

    .OUTPUTS
        This function does not return any output.

    .NOTES
        This function is useful for displaying a matrix rain animation in the console.

    .EXAMPLE
        Start-Matrix
        Displays the matrix rain animation in the console.

    .EXAMPLE
        Start-Matrix -SleepTime 10
        Displays the matrix rain animation with a slower update speed.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
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
            HelpMessage = "The time in milliseconds to wait between updating the animation."
        )]
        [Alias("s")]
        [double]$SleepTime = 0.6
    )

    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "Green"

    $lines = [console]::WindowHeight
    $cols = [console]::WindowWidth
    $characters = "ァアィイゥウェエォオカガキギクグケゲコゴサコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
    $colsMap = @{}

    Clear-Host

    while ($true) {
        $randomCol = Get-Random -Minimum 0 -Maximum $cols
        $randomChar = $characters[(Get-Random -Minimum 0 -Maximum $characters.Length)]

        if (-not $colsMap.ContainsKey($randomCol)) {
            $colsMap[$randomCol] = 0
        }

        $line = $colsMap[$randomCol]

        if ($line -ge $lines) {
            for ($clearLine = 0; $clearLine -lt $lines; $clearLine++) {
                Write-Host "`e[$clearLine;${randomCol}H " -NoNewline
            }
            $colsMap[$randomCol] = 0
            $line = 0
        }

        $colsMap[$randomCol]++

        Write-Host "`e[$line;${randomCol}H`e[1;32m$randomChar" -NoNewline

        if ($line -gt 0) {
            Write-Host "`e[$($line-1);${randomCol}H`e[0;32m$randomChar" -NoNewline
        }

        if ($line -gt 1) {
            Write-Host "`e[$($line-2);${randomCol}H`e[2;32m$randomChar" -NoNewline
        }

        Write-Host "`e[0;0H" -NoNewline

        Start-Sleep -Milliseconds $SleepTime

        if ([System.Console]::KeyAvailable) {
            $key = [System.Console]::ReadKey($true).Key
            if ($key -eq [System.ConsoleKey]::Q) {
                Clear-Host
                Write-Host "`nMatrix Animation Stopped!" -ForegroundColor Red
                return
            }
        }
    }
}
