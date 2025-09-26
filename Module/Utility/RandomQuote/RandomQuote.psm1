function Get-RandomQuote {
    <#
  .SYNOPSIS
    Retrieves a random quote from an online API.

  .DESCRIPTION
    This function retrieves a random quote from an online API. It returns the quote content and author.

  .PARAMETER None
    This function does not accept any parameters.

  .INPUTS
    This function does not accept any input.

  .OUTPUTS
    The random quote content and author.

  .NOTES
    This function is useful for displaying random quotes in the PowerShell console.

  .EXAMPLE
    Get-RandomQuote
    Retrieves a random quote from the default API URL.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
    [CmdletBinding()]
    [Alias("quote")]
    [OutputType([string])]
    param (
        # This function does not accept any parameters
    )

    $url = "http://api.quotable.io/random"

    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -SkipCertificateCheck

        if ($response) {
            Write-Output "`"$($response.content)`""
            Write-Output " - $($response.author)"
        }
        else {
            Write-LogMessage -Message "Failed to retrieve a random quote." -Level "ERROR"
        }
    }
    catch {
        Write-LogMessage -Message "Failed to retrieve a random quote." -Level "ERROR"
    }
}

