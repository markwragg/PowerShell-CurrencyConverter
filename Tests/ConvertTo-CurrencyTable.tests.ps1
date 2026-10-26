Describe 'ConvertTo-CurrencyTable' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/ConvertTo-CurrencyTable.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Convert-Currency.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/ConvertFrom-UnixTime.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/Get-CurrencyDefaultValue.ps1

        # Pretend no defaults are saved, so these tests aren't affected by real preferences saved on the
        # machine running them (Get-CurrencyDefaultValue would otherwise read $HOME/.currencyconverter).
        Mock Get-CurrencyDefaultValue { $Value }

        Mock Test-Path { $false }
        Mock Out-File
    }

    Context 'Converting to multiple currencies' {

        BeforeAll {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    rates                 = @{ GBP = 0.79; EUR = 0.93; JPY = 157.0 }
                    time_next_update_unix = [int]([datetimeoffset](Get-Date).AddDays(1)).ToUnixTimeSeconds()
                }
            }
        }

        It 'Returns a single object with a property for the source currency and each destination currency' {

            $Result = 100 | ConvertTo-CurrencyTable -From USD -To GBP, EUR, JPY

            $Result.USD | Should -Be 100
            $Result.GBP | Should -Be 79.00
            $Result.EUR | Should -Be 93.00
            $Result.JPY | Should -Be 15700.00
        }

        It 'Returns one object per value provided via the pipeline' {

            $Result = 100, 200 | ConvertTo-CurrencyTable -From USD -To GBP, EUR

            $Result.Count | Should -Be 2
            $Result[0].GBP | Should -Be 79.00
            $Result[1].GBP | Should -Be 158.00
        }

        It 'Uses the saved default for -From when not specified' {

            Mock Get-CurrencyDefaultValue {
                switch ($Name) {
                    'From' { 'USD' }
                    default { $Value }
                }
            }

            $Result = 100 | ConvertTo-CurrencyTable -To GBP, EUR

            $Result.USD | Should -Be 100
            $Result.GBP | Should -Be 79.00
        }
    }

    Context 'When a destination currency cannot be converted' {

        BeforeAll {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    rates                 = @{ GBP = 0.79; EUR = 0.93 }
                    time_next_update_unix = [int]([datetimeoffset](Get-Date).AddDays(1)).ToUnixTimeSeconds()
                }
            }
            Mock Write-Error
        }

        It 'Omits the property for that currency but still returns the others' {

            $Result = 100 | ConvertTo-CurrencyTable -From USD -To GBP, EUR, JPY

            $Result.GBP | Should -Be 79.00
            $Result.EUR | Should -Be 93.00
            $Result.PSObject.Properties['JPY'] | Should -BeNullOrEmpty

            Should -Invoke Write-Error
        }
    }

    Context 'Error handling' {

        It 'Returns an error if no -From is specified and no default is saved' {

            Mock Write-Error

            $Result = 100 | ConvertTo-CurrencyTable -To GBP

            $Result | Should -BeNullOrEmpty
            Should -Invoke Write-Error
        }
    }

    Context 'Historical rates (-Date)' {

        It 'Returns an error if -Date is specified without -APIKey' {

            Mock Write-Error
            Mock Invoke-RestMethod

            $Result = 100 | ConvertTo-CurrencyTable -From USD -To GBP, EUR -Date '2024-01-15'

            $Result | Should -BeNullOrEmpty
            Should -Not -Invoke Invoke-RestMethod
            Should -Invoke Write-Error
        }

        It 'Retrieves historical rates from the v6 history API when -Date and -APIKey are specified' {

            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    result           = 'success'
                    year             = 2024
                    month            = 1
                    day              = 15
                    base_code        = 'USD'
                    conversion_rates = @{ USD = 1; GBP = 0.79; EUR = 0.93 }
                }
            }

            $Result = 100 | ConvertTo-CurrencyTable -From USD -To GBP, EUR -Date '2024-01-15' -ApiKey 12345abcdef

            $Result.GBP | Should -Be 79.00
            $Result.EUR | Should -Be 93.00

            Should -Invoke Invoke-RestMethod -ParameterFilter { $Uri -like '*history/USD/2024/1/15*' }
            Should -Invoke Out-File
        }
    }
}
