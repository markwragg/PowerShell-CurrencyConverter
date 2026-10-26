function Convert-Currency {
    <#
    .SYNOPSIS
        Converts a decimal value between specified currencies

    .DESCRIPTION
        Uses the Open Exchange Rate API (https://www.exchangerate-api.com/docs/free) to perform currency conversions.
        Caches the conversion rates for the specified currency (valid for 24 hours).

    .PARAMETER Value
        The amount you want to convert between currencies.

    .PARAMETER From
        The currency to convert from. Defaults to the value saved with Set-CurrencyDefault -From, if any.

    .PARAMETER To
        The currency to convert to. Defaults to the value saved with Set-CurrencyDefault -To, if any.

    .PARAMETER APIKey
        Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
        Defaults to the value saved with Set-CurrencyDefault -APIKey, if any.

    .PARAMETER Date
        Optional: Converts using the historical exchange rates for the specified date, instead of the
        latest rates. This requires an -APIKey, as historical data is only available via the registered
        v6 API. Historical results are cached indefinitely once retrieved, as they do not change.

    .INPUTS
        A numerical value, can be provided via the pipeline.

    .EXAMPLE
        100 | Convert-Currency -From USD -To GBP

        Description
        -----------
        Converts the value 100 (provided via the pipeline) from USD (US Dollar) to GBP (British Pound), example result: 79.674700

    .EXAMPLE
        Convert-Currency -Value 100 -From AUD -To EUR

        Description
        -----------
        Converts the value 100 from USD (US Dollar) to AUD (Australian Dollar), example result: 154.211800

    .EXAMPLE
        Convert-Currency -Value 100 -From USD -To EUR | Format-Currency

        Description
        -----------
        Converts 100 USD to EUR and pipes the result to Format-Currency, which picks up the destination currency (EUR) from the pipeline, example result: €92.15

    .EXAMPLE
        Set-CurrencyDefault -From USD -To GBP
        Convert-Currency -Value 100

        Description
        -----------
        Saves USD/GBP as the default currencies to convert between, then converts 100 USD to GBP without needing to specify -From/-To.

    .EXAMPLE
        Convert-Currency -Value 100 -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere

        Description
        -----------
        Converts 100 USD to GBP using the exchange rate as it was on 15th January 2024.

    .LINK
        https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Convert-Currency
    #>
    [cmdletbinding()]
    [OutputType([decimal])]
    param(
        [parameter(ValueFromPipeline, Mandatory, Position = 0)]
        [decimal]
        $Value,

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [string]
        $From = (Get-CurrencyDefaultValue -Name 'From'),

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [string]
        $To = (Get-CurrencyDefaultValue -Name 'To'),

        [string]
        $APIKey = (Get-CurrencyDefaultValue -Name 'APIKey'),

        [datetime]
        $Date
    )

    process {
        if (-not $From -or -not $To) {
            Write-Error "A -From and -To currency are required. Specify them explicitly, or save defaults with Set-CurrencyDefault."
            return
        }

        if ($Date -and -not $APIKey) {
            Write-Error "A -Date requires an -APIKey, as historical rates are only available via the registered v6 API."
            return
        }

        if ($From -eq $To) {
            $Value | Add-Member -NotePropertyName Currency -NotePropertyValue $To -PassThru
        }
        else {
            if ($Date) {
                $DateStamp = $Date.ToString('yyyy-MM-dd')
                $Cached = Join-Path $PSScriptRoot "${From}_${DateStamp}v6.json"
                $APIUrl = "https://v6.exchangerate-api.com/v6/${APIKey}/history/${From}/$($Date.Year)/$($Date.Month)/$($Date.Day)"
                $RateStr = 'conversion_rates'
            }
            elseif ($APIKey) {
                $Cached = Join-Path $PSScriptRoot "${From}v6.json"
                $APIUrl = "https://v6.exchangerate-api.com/v6/${APIKey}/latest/${From}"
                $RateStr = 'conversion_rates'
            }
            else {
                $Cached = Join-Path $PSScriptRoot "${From}.json"
                $APIUrl = "https://open.er-api.com/v6/latest/${From}"
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

            if ($ExchangeRates.$RateStr.$To) {
                $Value * $ExchangeRates.$RateStr.$To | Add-Member -NotePropertyName Currency -NotePropertyValue $To -PassThru
            }
            else {
                Write-Error "Could not convert currency."
            }
        }
    }
}