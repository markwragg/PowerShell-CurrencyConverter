Describe 'Format-Currency' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/Format-Currency.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Convert-Currency.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Convert-CryptoCurrency.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/ConvertFrom-UnixTime.ps1
    }

    Context 'When given a valid currency and value' {

        It 'Returns the currency symbol and formatted value' {

            $result = Format-Currency -Currency 'USD' -Value 1234.5678
            $result | Should -Be '$1,234.57'
        }

        It 'Returns the currency symbol and formatted value' {

            $result = Format-Currency -Currency 'USD' -Value 1234
            $result | Should -Be '$1,234.00'
        }

        It 'Returns the currency symbol and formatted value after conversion' {

            $result = Format-Currency -Currency 'USD' -Value 1234 -ConvertTo 'USD'
            $result | Should -Be '$1,234.00'
        }

        It 'Returns the formatted value with the symbol at the end' {

            $result = Format-Currency -Currency 'USD' -Value 1234 -SymbolAtEnd
            $result | Should -Be '1,234.00$'
        }

        It 'Returns the currency symbol and formatted value to the specified number of decimal places' {

            $result = Format-Currency -Currency 'USD' -Value 1234.5678 -Decimals 3
            $result | Should -Be '$1,234.568'
        }
    }

    Context 'When given a value via the pipeline' {

        It 'Returns the currency symbol and formatted value' {

            $result = 1234.5678 | Format-Currency -Currency 'USD'
            $result | Should -Be '$1,234.57'
        }

        It 'Returns the currency symbol and formatted value' {

            $result = 1234 | Format-Currency -Currency 'USD'
            $result | Should -Be '$1,234.00'
        }
    }

    Context 'When given a negative value' {

        It 'Returns the currency symbol and formatted negative value' {

            $result = Format-Currency -Currency 'USD' -Value -1234.5678
            $result | Should -Be '$-1,234.57'
        }
    }

    Context 'When given the output of Convert-Currency via the pipeline' {

        BeforeAll {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    rates                 = @{ EUR = 0.85 }
                    time_next_update_unix = [int]([datetimeoffset](Get-Date).AddDays(1)).ToUnixTimeSeconds()
                }
            }
            Mock Test-Path { $false }
            Mock Out-File
        }

        It 'Infers the Currency parameter from the converted currency' {

            $result = Convert-Currency -Value 100 -From USD -To EUR | Format-Currency
            $result | Should -Be '€85.00'
        }

        It 'Infers the Currency parameter when no conversion is performed' {

            $result = Convert-Currency -Value 100 -From USD -To USD | Format-Currency
            $result | Should -Be '$100.00'
        }
    }

    Context 'When given the output of Convert-CryptoCurrency via the pipeline' {

        BeforeAll {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    data = @{
                        rates = @{ ETH = 21.4961307 }
                    }
                }
            }
            Mock Test-Path { $false }
            Mock Out-File
        }

        It 'Infers the Currency parameter from the converted currency' {

            $result = Convert-CryptoCurrency -Value 1 -From BTC -To ETH | Format-Currency -Decimals 7
            $result | Should -Be 'Ξ21.4961307'
        }
    }
}