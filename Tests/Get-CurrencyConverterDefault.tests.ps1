Describe 'Get-CurrencyConverterDefault' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Private/Get-CurrencyConverterDefaultsPath.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Get-CurrencyConverterDefault.ps1

        $DefaultsPath = Join-Path $TestDrive 'CurrencyConverter.defaults.json'
    }

    Context 'No defaults saved' {

        It 'Returns an empty object' {

            $Result = Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath
            $Result.PSObject.Properties.Name | Should -BeNullOrEmpty
        }
    }

    Context 'Defaults saved' {

        BeforeAll {
            '{"From":"USD","To":"GBP","APIKey":"12345abcdef"}' | Out-File $DefaultsPath -Force
        }

        It 'Returns the saved From' {

            (Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath).From | Should -Be 'USD'
        }

        It 'Returns the saved To' {

            (Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath).To | Should -Be 'GBP'
        }

        It 'Returns the saved APIKey' {

            (Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath).APIKey | Should -Be '12345abcdef'
        }
    }
}
