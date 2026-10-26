Describe 'Add-CurrencyMember' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/Add-CurrencyMember.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Convert-Currency.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Convert-CryptoCurrency.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/ConvertFrom-UnixTime.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/Get-CurrencyDefaultValue.ps1

        # Pretend no defaults are saved, so these tests aren't affected by real preferences saved on the
        # machine running them (Get-CurrencyDefaultValue would otherwise read $HOME/.currencyconverter).
        Mock Get-CurrencyDefaultValue { $Value }
    }

    Context 'Converting a fiat currency property' {

        BeforeAll {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    rates                 = @{ GBP = 0.79 }
                    time_next_update_unix = [int]([datetimeoffset](Get-Date).AddDays(1)).ToUnixTimeSeconds()
                }
            }
            Mock Test-Path { $false }
            Mock Out-File
        }

        It 'Adds a new member named for the property and destination currency by default' {

            $Object = [pscustomobject]@{ Product = 'Widget'; Price = 100 }
            $Result = $Object | Add-CurrencyMember -Property Price -From USD -To GBP -PassThru

            $Result.PriceGBP | Should -Be 79.00
        }

        It 'Adds a new member using the specified -MemberName' {

            $Object = [pscustomobject]@{ Price = 100 }
            $Result = $Object | Add-CurrencyMember -Property Price -MemberName ConvertedPrice -From USD -To GBP -PassThru

            $Result.ConvertedPrice | Should -Be 79.00
        }

        It 'Leaves the original properties on the object untouched' {

            $Object = [pscustomobject]@{ Product = 'Widget'; Price = 100 }
            $Result = $Object | Add-CurrencyMember -Property Price -From USD -To GBP -PassThru

            $Result.Product | Should -Be 'Widget'
            $Result.Price | Should -Be 100
        }

        It 'Processes each object provided via the pipeline' {

            $Objects = @(
                [pscustomobject]@{ Price = 100 }
                [pscustomobject]@{ Price = 200 }
            )

            $Result = $Objects | Add-CurrencyMember -Property Price -From USD -To GBP -PassThru

            $Result[0].PriceGBP | Should -Be 79.00
            $Result[1].PriceGBP | Should -Be 158.00
        }

        It 'Uses the saved defaults for -From and -To when not specified' {

            Mock Get-CurrencyDefaultValue {
                switch ($Name) {
                    'From' { 'USD' }
                    'To' { 'GBP' }
                    default { $Value }
                }
            }

            $Object = [pscustomobject]@{ Price = 100 }
            $Result = $Object | Add-CurrencyMember -Property Price -PassThru

            $Result.PriceGBP | Should -Be 79.00
        }

        It 'Does not return any output by default' {

            $Object = [pscustomobject]@{ Price = 100 }
            $Result = $Object | Add-CurrencyMember -Property Price -From USD -To GBP

            $Result | Should -BeNullOrEmpty
        }

        It 'Still adds the new member to the object when -PassThru is not specified' {

            $Object = [pscustomobject]@{ Price = 100 }
            $Object | Add-CurrencyMember -Property Price -From USD -To GBP

            $Object.PriceGBP | Should -Be 79.00
        }
    }

    Context 'Converting a crypto currency property' {

        BeforeAll {
            Mock Invoke-RestMethod {
                [pscustomobject]@{
                    data = @{
                        rates = @{ GBP = 50000 }
                    }
                }
            }
            Mock Test-Path { $false }
            Mock Out-File
        }

        It 'Uses Convert-CryptoCurrency when -From is a crypto currency' {

            $Object = [pscustomobject]@{ Price = 1 }
            $Result = $Object | Add-CurrencyMember -Property Price -From BTC -To GBP -PassThru

            $Result.PriceGBP | Should -Be 50000
        }
    }

    Context 'Error handling' {

        It 'Returns an error if the specified property does not exist on the object' {

            Mock Write-Error

            $Object = [pscustomobject]@{ Price = 100 }
            $Object | Add-CurrencyMember -Property DoesNotExist -From USD -To GBP

            Should -Invoke Write-Error
        }

        It 'Returns an error if no -From/-To is specified and no default is saved' {

            Mock Write-Error

            $Object = [pscustomobject]@{ Price = 100 }
            $Object | Add-CurrencyMember -Property Price

            Should -Invoke Write-Error
        }
    }

    Context 'Historical rates (-Date)' {

        It 'Returns an error if -Date is specified without -APIKey' {

            Mock Write-Error
            Mock Invoke-RestMethod

            $Object = [pscustomobject]@{ Price = 100 }
            $Object | Add-CurrencyMember -Property Price -From USD -To GBP -Date '2024-01-15'

            Should -Not -Invoke Invoke-RestMethod
            Should -Invoke Write-Error
        }

        It 'Returns an error if -Date is specified with a crypto currency' {

            Mock Write-Error
            Mock Invoke-RestMethod

            $Object = [pscustomobject]@{ Price = 1 }
            $Object | Add-CurrencyMember -Property Price -From BTC -To GBP -Date '2024-01-15' -ApiKey 12345abcdef

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
                    conversion_rates = @{ GBP = 0.79 }
                }
            }
            Mock Test-Path { $false }
            Mock Out-File

            $Object = [pscustomobject]@{ Price = 100 }
            $Result = $Object | Add-CurrencyMember -Property Price -From USD -To GBP -Date '2024-01-15' -ApiKey 12345abcdef -PassThru

            $Result.PriceGBP | Should -Be 79.00

            Should -Invoke Invoke-RestMethod -ParameterFilter { $Uri -like '*history/USD/2024/1/15*' }
            Should -Invoke Out-File
        }
    }
}
