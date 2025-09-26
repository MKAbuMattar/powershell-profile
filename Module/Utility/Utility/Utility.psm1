function Read-FigletFont {
  <#
  .SYNOPSIS
    Read the contents of a FIGlet font file.

  .DESCRIPTION
    This function reads the contents of a FIGlet font file and extracts the font data. It returns the font data as a hashtable, which can be used to convert text to ASCII art using the specified font.

  .PARAMETER FontPath
    Specifies the path to the FIGlet font file to read.

  .INPUTS
    FontPath: (Required) The path to the FIGlet font file to read.

  .OUTPUTS
    The font data extracted from the FIGlet font file.

  .NOTES
    This function is useful for reading FIGlet font files to extract font data for ASCII art conversion.

  .EXAMPLE
    Read-FigletFont -FontPath "font.flf"
    Reads the contents of the FIGlet font file "font.flf" and extracts the font data.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
  [CmdletBinding()]
  [OutputType([hashtable])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The path to the FIGlet font file to read."
    )]
    [Alias("f")]
    [string]$FontPath
  )

  if (!(Test-Path $FontPath)) {
    Write-Host ("Error: Font file not found at {0}" -f $FontPath) -ForegroundColor Red
    return $null
  }

  $lines = Get-Content -Path $FontPath -Encoding UTF8
  if ($lines.Count -eq 0) {
    Write-Host "Error: Font file is empty or unreadable." -ForegroundColor Red
    return $null
  }

  $fontData = @{}
  $header = $lines[0] -split " "
  $hardBlank = $header[0][4]
  $charHeight = [int]$header[1]
  $charStartIndex = 1

  for ($i = 32; $i -lt 127; $i++) {
    $charLines = @()
    for ($j = 0; $j -lt $charHeight; $j++) {
      $lineIndex = $charStartIndex + ($i - 32) * $charHeight + $j
      if ($lineIndex -ge $lines.Count) { continue }
      $charLine = $lines[$lineIndex] -replace "[@$hardBlank]", " "
      $charLines += $charLine -replace ".$", ""
    }
    $fontData[[char]$i] = $charLines
  }

  return @{
    "fontData"   = $fontData
    "charHeight" = $charHeight
  }
}

function Convert-TextToAscii {
  <#
  .SYNOPSIS
    Converts text to ASCII art using a specified FIGlet font.

  .DESCRIPTION
    This function converts the specified text to ASCII art using the provided FIGlet font data. It returns the ASCII art representation of the text.

  .PARAMETER Text
    Specifies the text to convert to ASCII art.

  .PARAMETER Font
    Specifies the FIGlet font data extracted from a font file.

  .INPUTS
    Text: (Required) The text to convert to ASCII art.
    Font: (Required) The FIGlet font data extracted from a font file.

  .OUTPUTS
    The ASCII art representation of the text using the specified font.

  .NOTES
    This function is useful for converting text to ASCII art using FIGlet fonts.

  .EXAMPLE
    Convert-TextToAscii -Text "Hello" -Font $fontData
    Converts the text "Hello" to ASCII art using the specified font data.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
  [CmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The text to convert to ASCII art."
    )]
    [Alias("t")]
    [string]$Text,

    [Parameter(
      Mandatory = $true,
      Position = 1,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The FIGlet font data extracted from a font file."
    )]
    [Alias("f")]
    [hashtable]$Font
  )

  if ($null -eq $Font) {
    Write-Host "Error: Font data is empty. Check font file." -ForegroundColor Red
    return
  }

  $output = @()
  for ($i = 0; $i -lt $Font.charHeight; $i++) {
    $line = ""
    foreach ($char in $Text.ToCharArray()) {
      if ($Font.fontData.ContainsKey($char)) {
        $line += $Font.fontData[$char][$i] + "  "
      }
      else {
        $line += " " * 8
      }
    }
    $output += $line
  }

  return $output -join "`n"
}

function Get-ParseTime {
  <#
  .SYNOPSIS
    Parses a time string into a DateTime object.

  .DESCRIPTION
    This function parses a time string into a DateTime object. It supports parsing time strings in the format "HH:mm" or "HH:mmAM/PM".

  .PARAMETER TimeString
    Specifies the time string to parse.

  .INPUTS
    TimeString: (Required) The time string to parse. The time string should be in the format "HH:mm" or "HH:mmAM/PM".

  .OUTPUTS
    The DateTime object representing the parsed time.

  .NOTES
    This function is useful for parsing time strings into DateTime objects.

  .EXAMPLE
    Get-ParseTime -TimeString "12:30PM"
    Parses the time string "12:30PM" into a DateTime object.

  .LINK
    https://github.com/MKAbuMattar/powershell-profile?tab=readme-ov-file#my-powershell-profile
  #>
  [CmdletBinding()]
  [OutputType([datetime])]
  param (
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The time string to parse."
    )]
    [Alias("t")]
    [string]$TimeString
  )

  try {
    $targetTime = [datetime]::ParseExact($TimeString, "h:mmtt", $null)
  }
  catch {
    try {
      $targetTime = [datetime]::ParseExact($TimeString, "HH:mm", $null)
    }
    catch {
      Write-LogMessage -Message "Invalid duration or time format: $TimeString" -Level "ERROR"
      exit 1
    }
  }
  return $targetTime
}

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
