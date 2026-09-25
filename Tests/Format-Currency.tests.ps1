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
}