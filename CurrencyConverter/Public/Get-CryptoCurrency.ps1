function Get-CryptoCurrency {
    <#
    .SYNOPSIS
        Returns the list of supported crypto currency codes along with their currency name.

    .DESCRIPTION
        Use to list the crypto currencies that are supported by this module, and the CoinBaser API.

    .PARAMETER Currency
        The currency to return. Alias: Code.

    .PARAMETER Name
        The currency name to return.

    .INPUTS
        Currency codes can be provided via the pipeline.

    .EXAMPLE
        Get-CryptoCurrency

        Description
        -----------
        Returns the list of all supported currency codes, along with their name and type.

    .EXAMPLE
        Get-CryptoCurrency -Currency BTC

        Description
        -----------
        Returns the code and name for BTC.

    .EXAMPLE
        'BTC','ETH' | Get-CryptoCurrency

        Description
        -----------
        Returns the code and name details for BTC and ETH.

    .EXAMPLE
        Get-CryptoCurrency -Name 'Bitcoin'

        Description
        -----------
        Returns all currencies that include the word 'Bitcoin'
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding(DefaultParameterSetName='Code')]
    param(
        [parameter(ValueFromPipeline,ParameterSetName='Code',Position=0)]
        [alias('Code')]
        [string]
        $Currency,
        
        [parameter(ParameterSetName='Name')]
        [string]
        $Name
    )

    process {
        $SupportedCurrency = Import-Csv "$PSScriptRoot\SupportedCryptoCurrency.csv"

        if ($Currency) {
            $SupportedCurrency | Where-Object { $_.Code -eq $Currency }
        }
        elseif ($Name) {
            $SupportedCurrency | Where-Object { $_.Name -match $Name }
        }
        else {
            $SupportedCurrency
        }
    }
}