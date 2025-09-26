function Get-PrayerTimes {
    <#
  .SYNOPSIS
    Gets the current prayer times for a specified city and country.

  .DESCRIPTION
    This function retrieves the current prayer times for a specified city and country using the AlAdhan API. It displays the prayer times in 12-hour or 24-hour format, along with the current prayer and the time remaining until the next prayer.

  .PARAMETER City
    Specifies the city to get the prayer times for.

  .PARAMETER Country
    Specifies the country to get the prayer times for.

  .PARAMETER Method
    Specifies the calculation method to use for the prayer times. The default value is 1.

  .PARAMETER Use24HourFormat
    Indicates whether to display the prayer times in 24-hour format. The default value is $false.

  .INPUTS
    City: (Required) The city to get the prayer times for.
    Country: (Required) The country to get the prayer times for.
    Method: (Optional) The calculation method to use for the prayer times. The default value is 1.
    Use24HourFormat: (Optional) Indicates whether to display the prayer times in 24-hour format. The default value is $false.

  .OUTPUTS
    This function does not return any output.

  .NOTES
    This function is useful for retrieving and displaying the current prayer times in the PowerShell console.

  .EXAMPLE
    Get-PrayerTimes -City "Amman" -Country "Jordan"
    Retrieves the current prayer times for Amman, Jordan.

  .EXAMPLE
    Get-PrayerTimes -City "New York" -Country "USA" -Method 2 -Use24HourFormat
    Retrieves the current prayer times for New York, USA using calculation method 2 and displays the times in 24-hour format.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
    [CmdletBinding()]
    [Alias("prayer")]
    [OutputType([void])]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The city to get the prayer times for."
        )]
        [Alias("c")]
        [string]$City,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The country to get the prayer times for."
        )]
        [Alias("o")]
        [string]$Country,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The calculation method to use for the prayer times."
        )]
        [Alias("m")]
        [int]$Method = 1,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Indicates whether to display the prayer times in 24-hour format."
        )]
        [Alias("f")]
        [switch]$Use24HourFormat = $false
    )

    $City = ($City.Substring(0, 1).ToUpper() + $City.Substring(1).ToLower())
    $Country = ($Country.Substring(0, 1).ToUpper() + $Country.Substring(1).ToLower())

    $url = "http://api.aladhan.com/v1/timingsByCity?city=$City&country=$Country&method=$Method"
    $response = Invoke-RestMethod -Uri $url -Method Get

    if ($response.code -eq 200) {
        $timings = $response.data.timings
        $date = $response.data.date.readable
        $hijriDate = $response.data.date.hijri.date

        $timeFormat = if ($Use24HourFormat) { "HH:mm" } else { "hh:mm tt" }

        $prayerTimes = @{
            "Fajr"    = [datetime]::ParseExact($timings.Fajr, "HH:mm", $null).ToString($timeFormat)
            "Dhuhr"   = [datetime]::ParseExact($timings.Dhuhr, "HH:mm", $null).ToString($timeFormat)
            "Asr"     = [datetime]::ParseExact($timings.Asr, "HH:mm", $null).ToString($timeFormat)
            "Maghrib" = [datetime]::ParseExact($timings.Maghrib, "HH:mm", $null).ToString($timeFormat)
            "Isha"    = [datetime]::ParseExact($timings.Isha, "HH:mm", $null).ToString($timeFormat)
        }

        $prayerTimes24 = @{}
        foreach ($key in $prayerTimes.Keys) {
            $prayerTimes24[$key] = (Get-Date "01/01/2000 $($prayerTimes[$key])").ToString("HH:mm")
        }

        $currentTime = (Get-Date).ToString("HH:mm")

        $currentPrayer = $null
        $nextPrayer = $null
        $nextPrayerTime = $null
        $sortedPrayers = $prayerTimes24.GetEnumerator() | Sort-Object Value

        foreach ($prayer in $sortedPrayers) {
            if ($currentTime -ge $prayer.Value) {
                $currentPrayer = $prayer.Key
            }
            elseif (-not $nextPrayer) {
                $nextPrayer = $prayer.Key
                $nextPrayerTime = $prayerTimes[$prayer.Key]
            }
        }

        if ($currentPrayer -eq "Isha") {
            $nextPrayer = "Fajr"
            $nextPrayerTime = $prayerTimes["Fajr"]
        }

        $now = Get-Date
        $nextPrayerTimeObj = Get-Date "01/01/2000 $nextPrayerTime"
        if ($nextPrayer -eq "Fajr") {
            $nextPrayerTimeObj = $nextPrayerTimeObj.AddDays(1)
        }
        $countdown = $nextPrayerTimeObj - $now

        if ($countdown.TotalSeconds -lt 0) {
            $countdown = New-TimeSpan -Hours 0 -Minutes 0
        }

        Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
        Write-Host "$City, $Country" -ForegroundColor White
        Write-Host "$currentPrayer" -ForegroundColor Blue
        Write-Host "-----------------------------------------------------"
        Write-Host ("{0,-10} {1,-10} {2,-10} {3,-10} {4,-10}" -f "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha") -ForegroundColor Cyan
        Write-Host ("{0,-10} {1,-10} {2,-10} {3,-10} {4,-10}" -f $prayerTimes["Fajr"], $prayerTimes["Dhuhr"], $prayerTimes["Asr"], $prayerTimes["Maghrib"], $prayerTimes["Isha"]) -ForegroundColor White
        Write-Host "-----------------------------------------------------"
        Write-Host "Current  -> $currentPrayer" -ForegroundColor Yellow
        Write-Host "Next     -> $nextPrayer at $nextPrayerTime" -ForegroundColor Green
        Write-Host "-----------------------------------------------------"
        Write-Host "$date | $hijriDate" -ForegroundColor Magenta
        Write-Host "-----------------------------------------------------"
    }
    else {
        Write-Host "Error fetching prayer times. Please check your city and country name." -ForegroundColor Red
    }
}

