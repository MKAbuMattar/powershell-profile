function Format-ConvertSize {
    <#
    .SYNOPSIS
        Formats a numeric value into a human-readable string using scaling units.

    .DESCRIPTION
        This function formats a numeric value into a human-readable format, using a customizable set of units and a scale factor. It is useful for formatting values like file sizes, data rates, durations, etc.

    .PARAMETER Value
        The numeric value to format. This parameter is mandatory.

    .PARAMETER Units
        An array of units to use for formatting. Defaults to bytes-based units: Bytes, KB, MB, GB, TB, PB, EB.

    .PARAMETER Scale
        The factor used to scale the value between units. Defaults to 1024.

    .PARAMETER DecimalPlaces
        The number of decimal places to include in the output. Default is 1.

    .INPUTS
        int/long/double.

    .OUTPUTS
        string: Human-readable formatted value with appropriate unit.

    .EXAMPLE
        Format-ConvertSize -Value 1048576
        Returns: "1.0 MB"

    .EXAMPLE
        Format-ConvertSize -Value 1250000 -Scale 1000 -Units @("bps", "Kbps", "Mbps", "Gbps")
        Returns: "1.3 Mbps"

    .EXAMPLE
        Format-ConvertSize -Value -1
        Returns: "N/A"

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            HelpMessage = "The numeric value to format."
        )]
        [Alias("v")]
        [ValidateNotNullOrEmpty()]
        [double]$Value,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            HelpMessage = "An array of units to use for formatting."
        )]
        [Alias("u")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Units = @("Bytes", "KB", "MB", "GB", "TB", "PB", "EB"),

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            HelpMessage = "The factor used to scale the value between units."
        )]
        [Alias("s")]
        [ValidateRange(1, [double]::MaxValue)]
        [double]$Scale = 1024,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            HelpMessage = "The number of decimal places to include in the output."
        )]
        [Alias("d")]
        [ValidateRange(0, 10)]
        [int]$DecimalPlaces = 1
    )

    if ($Value -lt 0) { return "N/A" }
    if ($Value -eq 0) { return "0 $($Units[0])" }

    $tier = 0
    [double]$scaledValue = $Value

    while ($scaledValue -ge $Scale -and $tier -lt ($Units.Length - 1)) {
        $scaledValue /= $Scale
        $tier++
    }

    $currentDecimalPlaces = $DecimalPlaces
    if ($tier -eq 0 -or ($scaledValue - [System.Math]::Truncate($scaledValue)) -eq 0) {
        $currentDecimalPlaces = 0
    }

    $formatted = $scaledValue.ToString("F$currentDecimalPlaces")
    return "$formatted $($Units[$tier])"
}
