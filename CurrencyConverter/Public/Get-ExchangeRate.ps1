function Get-ExchangeRate {
    <#
    .SYNOPSIS
        Returns all exchange rates for a specified currency, or a specified exchange rate between two currencies.

    .DESCRIPTION
        Uses the Open Exchange Rate API (https://www.exchangerate-api.com/docs/free) to retrieve currency rates.
        Caches the conversion rates for the specified currency (valid for 24 hours).

    .PARAMETER Currency
        The currency to return exchange rates for. (Alias: From)

    .PARAMETER To
        The currency to return the exchange rate to (from the currency specified as -Currency or -From).

    .PARAMETER Rates
        Switch: Use to return just the exchange rates for a specified currency.

    .PARAMETER APIKey
        Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/

    .INPUTS
        Currency codes can be provided via the pipeline.

    .EXAMPLE
        Get-ExchangeRate -Currency USD

        Description
        -----------
        Returns the exchange rates for US Dollar as a PowerShell object.

    .EXAMPLE
        Get-ExchangeRate -Currency USD -Rates

        Description
        -----------
        Returns all exchange rates for US Dollar.
    
    .EXAMPLE
        Get-ExchangeRate -From USD -To GBP

        Description
        -----------
        Returns the exchange rate from US Dollar to British Pound, example result: 0.792011

    .EXAMPLE
        'USD','GBP' | Get-ExchangeRate

        Description
        -----------
        Returns the exchange rates for US Dollar and British Pound as PowerShell objects.

    #>
    [CmdletBinding(DefaultParameterSetName = 'ToRate')]
    [OutputType([pscustomobject])]
    [OutputType([pscustomobject], ParameterSetName=('Rates'))]
    [OutputType([double], ParameterSetName=('ToRate'))]
    param(
        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory)]
        [alias('From')]
        [string]
        $Currency,

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ToRate')]
        [string]
        $To,

        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Rates')]
        [switch]
        $Rates,

        [string]
        $APIKey
    )
    process {
        if ($APIKey) {
            $Cached = Join-Path $PSScriptRoot "${Currency}v6.json"
            $APIUrl = "https://v6.exchangerate-api.com/v6/${APIKey}/latest/${Currency}"
            $RateStr = 'conversion_rates'
        }
        else {
            $Cached = Join-Path $PSScriptRoot "${Currency}.json"
            $APIUrl = "https://open.er-api.com/v6/latest/${Currency}"
            $RateStr = 'rates'
        }

        $isCached = Test-Path $Cached

        if ($isCached) {
            $ExchangeRates = Get-Content $Cached | ConvertFrom-Json
        }

        if (-not $isCached -or ((Get-Date) -gt ($ExchangeRates.time_next_update_unix | ConvertFrom-UnixTime))) {
            try {
                $ExchangeRates = Invoke-RestMethod $APIUrl -ErrorAction Stop
                $ExchangeRates | ConvertTo-Json | Out-File $Cached -Force
            }
            catch {
                Write-Error $_
            }
        }

        if ($ExchangeRates) {

            if ($Rates) {
                $ExchangeRates.$RateStr
            }
            elseif ($To) {
                $ExchangeRates.$RateStr.$To
            }
            else {
                $ExchangeRates
            }
        }
        else {
            Write-Error "Failed to retrieve rates for $Currency."
        }
    }
}