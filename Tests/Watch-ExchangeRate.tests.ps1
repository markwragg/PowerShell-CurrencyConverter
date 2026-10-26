Describe 'Watch-ExchangeRate' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/Watch-ExchangeRate.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Get-ExchangeRate.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Get-CryptoExchangeRate.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/ConvertFrom-UnixTime.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/Get-CurrencyDefaultValue.ps1

        # Pretend no defaults are saved, so these tests aren't affected by real preferences saved on the
        # machine running them (Get-CurrencyDefaultValue would otherwise read $HOME/.currencyconverter).
        Mock Get-CurrencyDefaultValue { $Value }

        Mock Start-Sleep
    }

    Context 'Polling until a threshold is crossed' {

        BeforeAll {
            $script:CallCount = 0
            Mock Get-ExchangeRate {
                $script:CallCount++
                @(0.78, 0.79, 0.81)[$script:CallCount - 1]
            }
        }

        It 'Stops polling once the rate is at or above -AboveThreshold, marking that result as Triggered' {

            $Result = Watch-ExchangeRate -From USD -To GBP -AboveThreshold 0.80 -IntervalSeconds 10

            $Result.Count | Should -Be 3
            $Result[0].Triggered | Should -BeFalse
            $Result[1].Triggered | Should -BeFalse
            $Result[2].Triggered | Should -BeTrue
            $Result[2].Rate | Should -Be 0.81

            Should -Invoke Get-ExchangeRate -Exactly 3
            Should -Invoke Start-Sleep -Exactly 2 -ParameterFilter { $Seconds -eq 10 }
        }

        It 'Stops polling once the rate is at or below -BelowThreshold, marking that result as Triggered' {

            $script:CallCount = 0
            Mock Get-ExchangeRate {
                $script:CallCount++
                @(0.81, 0.79, 0.78)[$script:CallCount - 1]
            }

            $Result = Watch-ExchangeRate -From USD -To GBP -BelowThreshold 0.79

            $Result.Count | Should -Be 2
            $Result[1].Triggered | Should -BeTrue
            $Result[1].Rate | Should -Be 0.79
        }
    }

    Context 'Polling without a threshold' {

        BeforeAll {
            Mock Get-ExchangeRate { 0.79 }
        }

        It 'Stops after -MaxIterations polls' {

            $Result = Watch-ExchangeRate -From USD -To GBP -MaxIterations 3

            $Result.Count | Should -Be 3
            $Result | ForEach-Object { $_.Triggered | Should -BeFalse }

            Should -Invoke Get-ExchangeRate -Exactly 3
            Should -Invoke Start-Sleep -Exactly 2
        }

        It 'Uses the saved defaults for -From and -To when not specified' {

            Mock Get-CurrencyDefaultValue {
                switch ($Name) {
                    'From' { 'USD' }
                    'To' { 'GBP' }
                    default { $Value }
                }
            }

            $Result = Watch-ExchangeRate -MaxIterations 1

            $Result.From | Should -Be 'USD'
            $Result.To | Should -Be 'GBP'
        }
    }

    Context 'When a poll fails to return a rate' {

        It 'Keeps polling without emitting a result for that iteration' {

            Mock Get-ExchangeRate { $null }

            $Result = Watch-ExchangeRate -From USD -To GBP -MaxIterations 2

            $Result | Should -BeNullOrEmpty
            Should -Invoke Get-ExchangeRate -Exactly 2
        }
    }

    Context 'Polling a crypto currency' {

        BeforeAll {
            Mock Get-CryptoExchangeRate { 95000 }
            Mock Get-ExchangeRate
        }

        It 'Uses Get-CryptoExchangeRate when -From or -To is a crypto currency' {

            $Result = Watch-ExchangeRate -From BTC -To USD -MaxIterations 1

            $Result.Rate | Should -Be 95000

            Should -Invoke Get-CryptoExchangeRate -Exactly 1
            Should -Not -Invoke Get-ExchangeRate
        }
    }

    Context 'Error handling' {

        It 'Returns an error if no -From/-To is specified and no default is saved' {

            Mock Write-Error
            Mock Get-ExchangeRate

            $Result = Watch-ExchangeRate

            $Result | Should -BeNullOrEmpty
            Should -Invoke Write-Error
            Should -Not -Invoke Get-ExchangeRate
        }
    }
}
