#Requires -Version 7.0
<#
.SYNOPSIS
    Checks the brand palette against the identity it comes from.

.DESCRIPTION
    The colours are the ones published at https://mkabumattar.com/identity/. Both setup front ends
    read them from Get-ProfileSetupBrand, so a value drifting here changes the window and the
    console picker together, and a wrong value changes both silently.

    Pinning the hex codes is the point of this file. A test that only checked the shape would pass
    on any six characters.

.LINK
    https://mkabumattar.com/identity/
#>

BeforeAll {
    $script:Root = Split-Path -Parent $PSScriptRoot
    Import-Module -Name (Join-Path $script:Root 'Module/Setup/Setup.psd1') -Force -DisableNameChecking
}

Describe 'Get-ProfileSetupBrand' {

    Context 'the night palette, used by both front ends' {

        BeforeAll {
            $script:Night = Get-ProfileSetupBrand -Mode Night
        }

        It 'defaults to night' {
            (Get-ProfileSetupBrand).Mode | Should -BeExactly 'Night'
        }

        It 'uses <Name> from the identity' -ForEach @(
            @{ Name = 'Ground'; Hex = '#2B2233' }      # Black Iris
            @{ Name = 'Heading'; Hex = '#EAE6DB' }     # Salt White
            @{ Name = 'Body'; Hex = '#D9C9B0' }        # Amman Stone
            @{ Name = 'Accent'; Hex = '#D9A36A' }      # Wadi Rum Sand
            @{ Name = 'Secondary'; Hex = '#B9875E' }   # Desert Camel
            @{ Name = 'Tertiary'; Hex = '#C76B6B' }    # Petra Rose
            @{ Name = 'Positive'; Hex = '#6B7A4F' }    # Olive Green
        ) {
            $script:Night.Hex[$Name] | Should -BeExactly $Hex
        }
    }

    Context 'the day palette, for a light ground' {

        BeforeAll {
            $script:Day = Get-ProfileSetupBrand -Mode Day
        }

        It 'uses <Name> from the identity' -ForEach @(
            @{ Name = 'Ground'; Hex = '#EAE6DB' }      # Salt White
            @{ Name = 'Heading'; Hex = '#2B2233' }     # Black Iris
            @{ Name = 'Body'; Hex = '#3C3C3C' }        # Basalt Black
            @{ Name = 'Accent'; Hex = '#8B1E2D' }      # Keffiyeh Red
            @{ Name = 'Secondary'; Hex = '#2F5D6B' }   # Dead Sea Blue
        ) {
            $script:Day.Hex[$Name] | Should -BeExactly $Hex
        }

        It 'inverts the ground and the heading against night' {
            $night = Get-ProfileSetupBrand -Mode Night
            $script:Day.Hex.Ground | Should -BeExactly $night.Hex.Heading
            $script:Day.Hex.Heading | Should -BeExactly $night.Hex.Ground
        }
    }

    Context 'the ANSI form' {

        It 'writes each colour as a 24-bit foreground sequence' {
            $brand = Get-ProfileSetupBrand -Mode Night

            # Black Iris is 2B 22 33, which is 43 34 51.
            $brand.Ansi.Ground | Should -BeExactly "`e[38;2;43;34;51m"
        }

        It 'carries a reset' {
            (Get-ProfileSetupBrand).Ansi.Reset | Should -BeExactly "`e[0m"
        }

        It 'gives every hex colour an ANSI counterpart' {
            $brand = Get-ProfileSetupBrand

            foreach ($name in $brand.Hex.Keys) {
                $brand.Ansi[$name] | Should -Match '^\e\[38;2;\d+;\d+;\d+m$' -Because "$name has no ANSI form"
            }
        }
    }

    Context 'the typefaces' {

        It 'names <Role> as <Family>' -ForEach @(
            @{ Role = 'Display'; Family = 'Archivo' }
            @{ Role = 'Body'; Family = 'Public Sans' }
            @{ Role = 'Mono'; Family = 'JetBrains Mono' }
        ) {
            (Get-ProfileSetupBrand).Font[$Role] | Should -Match ("^" + [regex]::Escape($Family))
        }

        It 'gives every face a fallback' {
            # None of the three ship with Windows, and WPF drops to a serif when a family is
            # missing, which reads as a rendering bug rather than a font that is not installed.
            foreach ($family in (Get-ProfileSetupBrand).Font.Values) {
                $family | Should -Match ',' -Because "'$family' names no fallback"
            }
        }
    }
}

Describe 'Test-ProfileSetupColor' {

    It 'returns false when output is redirected' {
        # Pester captures output, so this is the redirected case and the escape sequences would be
        # printed as literal text.
        Test-ProfileSetupColor | Should -BeFalse
    }

    It 'returns a boolean' {
        Test-ProfileSetupColor | Should -BeOfType [bool]
    }
}

Describe 'The window and the console agree on the palette' {

    It 'uses the same brand hex codes in the window layout' {
        # Two surfaces, one identity. A colour hard-coded in the XAML that is not in the palette
        # means the window and the picker have started to drift.
        $brand = Get-ProfileSetupBrand -Mode Night
        $xaml = Get-ProfileSetupWindowXaml

        $declared = @(
            [regex]::Matches($xaml, '#FF([0-9A-Fa-f]{6})') |
                ForEach-Object { '#' + $_.Groups[1].Value.ToUpper() } |
                Sort-Object -Unique
        )

        $known = @($brand.Hex.Values | ForEach-Object { $_.ToUpper() })

        # The log pane sits a shade below the ground, which is a tint of Black Iris rather than a
        # separate brand colour.
        $allowed = $known + @('#241D2B')

        foreach ($colour in $declared) {
            $colour | Should -BeIn $allowed -Because "the layout uses $colour, which is not in the palette"
        }
    }

    It 'names the identity typefaces in the window layout' {
        $xaml = Get-ProfileSetupWindowXaml

        $xaml | Should -Match 'Archivo'
        $xaml | Should -Match 'Public Sans'
        $xaml | Should -Match 'JetBrains Mono'
    }
}
