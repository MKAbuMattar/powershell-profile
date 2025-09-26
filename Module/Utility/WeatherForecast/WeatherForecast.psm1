function Get-WeatherForecast {
    <#
    .SYNOPSIS
        Gets the weather forecast for a specified location.

    .DESCRIPTION
        This function retrieves the weather forecast for a specified location using the wttr.in service. It returns the weather forecast in ASCII art format. The forecast can include weather glyphs, moon phases, and be customized with additional options.

    .PARAMETER Location
        Specifies the location to retrieve the weather forecast for. If not provided, the default location is used.

    .PARAMETER Glyphs
        Indicates whether to display weather glyphs in the forecast. The default value is $true.

    .PARAMETER Moon
        Indicates whether to display moon phases in the forecast. The default value is $false.

    .PARAMETER Format
        Specifies a custom format for the weather forecast. The default format is used if not provided.

    .PARAMETER Lang
        Specifies the language for the weather forecast. The default language is "en".

    .INPUTS
        Location: (Optional) The location to retrieve the weather forecast for. If not provided, the default location is used.
        Glyphs: (Optional) Indicates whether to display weather glyphs in the forecast. The default value is $true.
        Moon: (Optional) Indicates whether to display moon phases in the forecast. The default value is $false.
        Format: (Optional) A custom format for the weather forecast. The default format is used if not provided.
        Lang: (Optional) The language for the weather forecast. The default language is "en".

    .OUTPUTS
        The weather forecast in ASCII art format.

    .NOTES
        This function is useful for retrieving the weather forecast in ASCII art format for a specified location.

    .EXAMPLE
        Get-WeatherForecast -Location "Amman"
        Retrieves the weather forecast for Amman.

    .EXAMPLE
        Get-WeatherForecast -Location "New York" -Glyphs $false
        Retrieves the weather forecast for New York without weather glyphs.

    .EXAMPLE
        Get-WeatherForecast -Moon
        Retrieves the moon phase forecast.

    .EXAMPLE
        Get-WeatherForecast -Location "Paris" -Format "3"
        Retrieves the weather forecast for Paris with a custom format.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
    #>
    [CmdletBinding()]
    [Alias("weather")]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The location to retrieve the weather forecast for."
        )]
        [Alias("l")]
        [string]$Location = $null,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to display weather glyphs in the forecast."
        )]
        [Alias("g")]
        [switch]$Glyphs = $true,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to display moon phases in the forecast."
        )]
        [Alias("m")]
        [switch]$Moon = $false,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "A custom format for the weather forecast."
        )]
        [Alias("f")]
        [string]$Format = $null,

        [Parameter(
            Mandatory = $false,
            Position = 4,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The language for the weather forecast."
        )]
        [ValidateSet(
            "en",
            "ar",
            "de",
            "es",
            "fr",
            "it",
            "nl",
            "pl",
            "pt",
            "ro",
            "ru",
            "tr"
        )]
        [string]$Lang = "en"
    )

    $url = "https://wttr.in/"

    try {
        switch ($true) {
            { $Moon -eq $false && $Location } { $url += $Location }
            { $Moon -eq $true } { $url += "Moon" }
            { $Glyphs -eq $true } { $url += "?d" }
            { $Glyphs -eq $false } { $url += "?T" }
            { $Format } { $url += "&&format=$Format" }
            { $Lang } { $url += "&&lang=$Lang" }
            default { $url += "" }
        }

        $response = Invoke-RestMethod -Uri $url -Method Get -SkipCertificateCheck

        if ($response) {
            Write-Output $response
        }
        else {
            Write-LogMessage -Message "Failed to retrieve the weather forecast." -Level "ERROR"
        }
    }
    catch {
        Write-LogMessage -Message "Failed to retrieve the weather forecast." -Level "ERROR"
    }
}
