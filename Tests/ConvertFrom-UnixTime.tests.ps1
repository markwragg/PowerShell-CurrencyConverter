Describe 'ConvertFrom-UnixTime' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Private/ConvertFrom-UnixTime.ps1
    }

    Context 'When given a valid unix time stamps' {

        It 'Returns the current date/time as a date object' {

            $result =  ConvertFrom-UnixTime -UnixTime 1707261531
            $result | Should -BeOfType [datetime]
        }
    }

    Context 'When given a value via the pipeline' {

        It 'Returns the current date/time as a date object' {

            $result = 1707261531 | ConvertFrom-UnixTime
            $result | Should -BeOfType [datetime]
        }
    }
}