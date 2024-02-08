Describe 'Convert-Currency' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/Get-Currency.ps1
    }

    Context 'Currency provided' {

        $SupportedCodes = @('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')

        It 'Should return the specified currency' -TestCases $SupportedCodes {
            $Code = $_
            $Result = Get-Currency -Currency $Code
            $Result.Code | Should -Be $Code
        }

        It 'Should return the specified currency' -TestCases $SupportedCodes {
            $Code = $_
            $Result = Get-Currency -Code $Code
            $Result.Code | Should -Be $Code
        }
    }

    Context 'Name provided' {

        It 'Should return the specified currency' {
            $Result = Get-Currency -Name 'Pound Sterling'
            $Result.Code | Should -Be 'GBP'
        }

        It 'Should return the specified currencies' {
            $Result = Get-Currency -Name 'Pound'
            $Result.Count | Should -Be 12
        }
    }

    Context 'Country provided' {

        It 'Should return the specified currency' {
            $Result = Get-Currency -Country 'United Kingdom'
            $Result.Code | Should -Be 'GBP'
        }

        It 'Should return the specified currencies' {
            $Result = Get-Currency -Country 'United'
            $Result.Count | Should -Be 3
        }
    }

    Context 'No input' {

        It 'Should return currencies' {
            $Result = Get-Currency
            $Result.Count | Should -Be 161
        }
    }

    Context 'false input' {

        It 'Should return nothing' {
            $Result = Get-Currency -Code XXX
            $Result | Should -BeNullOrEmpty
        }

        It 'Should return nothing' {
            $Result = Get-Currency -Name XXX
            $Result | Should -BeNullOrEmpty
        }

        It 'Should return nothing' {
            $Result = Get-Currency -Country XXX
            $Result | Should -BeNullOrEmpty
        }
    }
}