function Get-Currency {
    <#
    .SYNOPSIS
        Returns the list of supported currency codes along with their currency name and country code.

    .DESCRIPTION
        Use to list the countries and currencies that are supported by this module, and the Exchange Rate API.

    .PARAMETER Currency
        The currency to return. Alias: Code.

    .PARAMETER Name
        The currency name to return.

    .PARAMETER Country
        The country to return.

    .EXAMPLE
        Get-Currency

        Description
        -----------
        Returns the list of all supported currency codes, along with their name and country.

    .EXAMPLE
        Get-Currency -Currency GBP

        Description
        -----------
        Returns the code, name and country for GBP.

    .EXAMPLE
        Get-Currency -Country 'United Kingdom'

        Description
        -----------
        Returns the code, name and country for the United Kingdom.

    .EXAMPLE
        Get-Currency -Name 'Dollar'

        Description
        -----------
        Returns all currencies that include the word 'Dollar'
    #>
    [CmdletBinding(DefaultParameterSetName='Code')]
    param(
        [parameter(ParameterSetName='Code')]
        [alias('Code')]
        [string]
        $Currency,
        
        [parameter(ParameterSetName='Name')]
        [string]
        $Name,

        [parameter(ParameterSetName='Country')]
        [string]
        $Country
    )

    process {
        $SupportedCurrency = Import-Csv "$PSScriptRoot\SupportedCurrency.csv"

        if ($Currency) {
            $SupportedCurrency | Where-Object { $_.Code -eq $Currency }
        }
        elseif ($Name) {
            $SupportedCurrency | Where-Object { $_.Name -match $Name }
        }
        elseif ($Country) {
            $SupportedCurrency | Where-Object { $_.Country -match $Country }
        }
        else {
            $SupportedCurrency
        }
    }
}