Describe 'Set-CurrencyConverterDefault' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Private/Get-CurrencyConverterDefaultsPath.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Get-CurrencyConverterDefault.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Set-CurrencyConverterDefault.ps1
    }

    BeforeEach {
        $DefaultsPath = Join-Path $TestDrive "$([guid]::NewGuid()).json"
    }

    It 'Saves a single preference' {

        $Result = Set-CurrencyConverterDefault -From USD -DefaultsPath $DefaultsPath
        $Result.From | Should -Be 'USD'

        (Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath).From | Should -Be 'USD'
    }

    It 'Saves multiple preferences at once' {

        Set-CurrencyConverterDefault -From USD -To GBP -APIKey 12345abcdef -DefaultsPath $DefaultsPath

        $Result = Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath
        $Result.From | Should -Be 'USD'
        $Result.To | Should -Be 'GBP'
        $Result.APIKey | Should -Be '12345abcdef'
    }

    It 'Leaves previously saved preferences that are not specified again' {

        Set-CurrencyConverterDefault -From USD -To GBP -DefaultsPath $DefaultsPath
        Set-CurrencyConverterDefault -APIKey 12345abcdef -DefaultsPath $DefaultsPath

        $Result = Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath
        $Result.From | Should -Be 'USD'
        $Result.To | Should -Be 'GBP'
        $Result.APIKey | Should -Be '12345abcdef'
    }

    It 'Overwrites a previously saved preference' {

        Set-CurrencyConverterDefault -From USD -DefaultsPath $DefaultsPath
        Set-CurrencyConverterDefault -From EUR -DefaultsPath $DefaultsPath

        (Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath).From | Should -Be 'EUR'
    }

    It 'Does not create a defaults file when no preference is specified' {

        Set-CurrencyConverterDefault -DefaultsPath $DefaultsPath

        Test-Path $DefaultsPath | Should -BeFalse
    }

    It 'Removes all saved preferences with -Reset' {

        Set-CurrencyConverterDefault -From USD -To GBP -DefaultsPath $DefaultsPath

        $Result = Set-CurrencyConverterDefault -Reset -DefaultsPath $DefaultsPath

        $Result.PSObject.Properties.Name | Should -BeNullOrEmpty
        Test-Path $DefaultsPath | Should -BeFalse
    }

    It 'Does not remove saved preferences with -Reset -WhatIf' {

        Set-CurrencyConverterDefault -From USD -DefaultsPath $DefaultsPath

        Set-CurrencyConverterDefault -Reset -WhatIf -DefaultsPath $DefaultsPath

        Test-Path $DefaultsPath | Should -BeTrue
        (Get-CurrencyConverterDefault -DefaultsPath $DefaultsPath).From | Should -Be 'USD'
    }
}
