Describe 'Set-CurrencyDefault' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Private/Get-CurrencyDefaultsPath.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Get-CurrencyDefault.ps1
        . $PSScriptRoot/../CurrencyConverter/Public/Set-CurrencyDefault.ps1
    }

    BeforeEach {
        $DefaultsPath = Join-Path $TestDrive "$([guid]::NewGuid()).json"
    }

    It 'Saves a single preference' {

        $Result = Set-CurrencyDefault -From USD -DefaultsPath $DefaultsPath
        $Result.From | Should -Be 'USD'

        (Get-CurrencyDefault -DefaultsPath $DefaultsPath).From | Should -Be 'USD'
    }

    It 'Saves multiple preferences at once' {

        Set-CurrencyDefault -From USD -To GBP -APIKey 12345abcdef -DefaultsPath $DefaultsPath

        $Result = Get-CurrencyDefault -DefaultsPath $DefaultsPath
        $Result.From | Should -Be 'USD'
        $Result.To | Should -Be 'GBP'
        $Result.APIKey | Should -Be '12345abcdef'
    }

    It 'Leaves previously saved preferences that are not specified again' {

        Set-CurrencyDefault -From USD -To GBP -DefaultsPath $DefaultsPath
        Set-CurrencyDefault -APIKey 12345abcdef -DefaultsPath $DefaultsPath

        $Result = Get-CurrencyDefault -DefaultsPath $DefaultsPath
        $Result.From | Should -Be 'USD'
        $Result.To | Should -Be 'GBP'
        $Result.APIKey | Should -Be '12345abcdef'
    }

    It 'Overwrites a previously saved preference' {

        Set-CurrencyDefault -From USD -DefaultsPath $DefaultsPath
        Set-CurrencyDefault -From EUR -DefaultsPath $DefaultsPath

        (Get-CurrencyDefault -DefaultsPath $DefaultsPath).From | Should -Be 'EUR'
    }

    It 'Does not create a defaults file when no preference is specified' {

        Set-CurrencyDefault -DefaultsPath $DefaultsPath

        Test-Path $DefaultsPath | Should -BeFalse
    }

    It 'Removes all saved preferences with -Reset' {

        Set-CurrencyDefault -From USD -To GBP -DefaultsPath $DefaultsPath

        $Result = Set-CurrencyDefault -Reset -DefaultsPath $DefaultsPath

        $Result.PSObject.Properties.Name | Should -BeNullOrEmpty
        Test-Path $DefaultsPath | Should -BeFalse
    }

    It 'Does not remove saved preferences with -Reset -WhatIf' {

        Set-CurrencyDefault -From USD -DefaultsPath $DefaultsPath

        Set-CurrencyDefault -Reset -WhatIf -DefaultsPath $DefaultsPath

        Test-Path $DefaultsPath | Should -BeTrue
        (Get-CurrencyDefault -DefaultsPath $DefaultsPath).From | Should -Be 'USD'
    }
}
