function Get-ExchangeRate {
    <#
    .SYNOPSIS
        Returns all exchange rates for a specified currency, or a specified exchange rate between two currencies.

    .DESCRIPTION
        Uses the Open Exchange Rate API (https://www.exchangerate-api.com/docs/free) to retrieve currency rates.
        Caches the conversion rates for the specified currency (valid for 24 hours).

    .PARAMETER Currency
        The currency to return exchange rates for. (Alias: From) Defaults to the value saved with
        Set-CurrencyDefault -From, if any.

    .PARAMETER To
        The currency to return the exchange rate to (from the currency specified as -Currency or -From).
        Defaults to the value saved with Set-CurrencyDefault -To, if any.

    .PARAMETER Rates
        Switch: Use to return just the exchange rates for a specified currency.

    .PARAMETER APIKey
        Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
        Defaults to the value saved with Set-CurrencyDefault -APIKey, if any.

    .PARAMETER Date
        Optional: Returns the historical exchange rates for the specified date, instead of the latest
        rates. This requires an -APIKey, as historical data is only available via the registered v6 API.
        Historical results are cached indefinitely once retrieved, as they do not change.

    .INPUTS
        Currency codes can be provided via the pipeline.

    .EXAMPLE
        Get-ExchangeRate -Currency USD

        Description
        -----------
        Returns the exchange rates for US Dollar as a PowerShell object.

    .EXAMPLE
        Get-ExchangeRate -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere

        Description
        -----------
        Returns the exchange rate from US Dollar to British Pound as it was on 15th January 2024.

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

    .EXAMPLE
        Set-CurrencyDefault -From USD -To GBP
        Get-ExchangeRate

        Description
        -----------
        Saves USD/GBP as the default currencies, then returns the exchange rate from US Dollar to British Pound without needing to specify -Currency/-To.

    .LINK
        https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Get-ExchangeRate
    #>
    [CmdletBinding(DefaultParameterSetName = 'ToRate')]
    [OutputType([pscustomobject])]
    [OutputType([pscustomobject], ParameterSetName=('Rates'))]
    [OutputType([double], ParameterSetName=('ToRate'))]
    param(
        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [alias('From')]
        [string]
        $Currency = (Get-CurrencyDefaultValue -Name 'From'),

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ToRate')]
        [string]
        $To = (Get-CurrencyDefaultValue -Name 'To'),

        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Rates')]
        [switch]
        $Rates,

        [string]
        $APIKey = (Get-CurrencyDefaultValue -Name 'APIKey'),

        [datetime]
        $Date
    )
    process {
        if (-not $Currency) {
            Write-Error "A -Currency (or -From) is required. Specify it explicitly, or save a default with Set-CurrencyDefault -From."
            return
        }

        if ($Date -and -not $APIKey) {
            Write-Error "A -Date requires an -APIKey, as historical rates are only available via the registered v6 API."
            return
        }

        if ($Date) {
            $DateStamp = $Date.ToString('yyyy-MM-dd')
            $Cached = Join-Path $PSScriptRoot "${Currency}_${DateStamp}v6.json"
            $APIUrl = "https://v6.exchangerate-api.com/v6/${APIKey}/history/${Currency}/$($Date.Year)/$($Date.Month)/$($Date.Day)"
            $RateStr = 'conversion_rates'
        }
        elseif ($APIKey) {
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

        # Historical rates for a given date never change, so once cached they don't need to be refreshed.
        $NeedsRefresh = if ($Date) {
            -not $isCached
        }
        else {
            -not $isCached -or ((Get-Date) -gt ($ExchangeRates.time_next_update_unix | ConvertFrom-UnixTime))
        }

        if ($NeedsRefresh) {
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