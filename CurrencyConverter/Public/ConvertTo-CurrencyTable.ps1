function ConvertTo-CurrencyTable {
    <#
    .SYNOPSIS
        Converts a decimal value from one currency to several currencies at once.

    .DESCRIPTION
        Uses Convert-Currency to convert a value from a source currency (-From) to each of a list of
        destination currencies (-To), and returns the results as a single object with one property per
        currency. This avoids having to call Convert-Currency in a loop when you want to compare a value
        across multiple currencies.

    .PARAMETER Value
        The amount you want to convert between currencies.

    .PARAMETER From
        The currency to convert from. Defaults to the value saved with Set-CurrencyDefault -From, if any.

    .PARAMETER To
        The currencies to convert to.

    .PARAMETER APIKey
        Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
        Defaults to the value saved with Set-CurrencyDefault -APIKey, if any.

    .PARAMETER Date
        Optional: Converts using the historical exchange rates for the specified date, instead of the
        latest rates. This requires an -APIKey, as historical data is only available via the registered
        v6 API. Historical results are cached indefinitely once retrieved, as they do not change.

    .INPUTS
        A numerical value, can be provided via the pipeline.

    .OUTPUTS
        A single object with a property for -From and one for each currency specified via -To.

    .EXAMPLE
        100 | ConvertTo-CurrencyTable -From USD -To GBP,EUR,JPY

        Description
        -----------
        Converts 100 USD to GBP, EUR and JPY, and returns the results as a single object with a USD,
        GBP, EUR and JPY property.

    .EXAMPLE
        100,200 | ConvertTo-CurrencyTable -From USD -To GBP,EUR

        Description
        -----------
        Converts each of 100 and 200 USD to GBP and EUR, returning one object per input value.

    .EXAMPLE
        Set-CurrencyDefault -From USD
        100 | ConvertTo-CurrencyTable -To GBP,EUR

        Description
        -----------
        Uses the saved default -From currency to convert 100 to GBP and EUR.

    .EXAMPLE
        100 | ConvertTo-CurrencyTable -From USD -To GBP,EUR -Date '2024-01-15' -ApiKey yourapikeystringhere

        Description
        -----------
        Converts 100 USD to GBP and EUR using the exchange rates as they were on 15th January 2024.

    .LINK
        https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/ConvertTo-CurrencyTable
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [parameter(ValueFromPipeline, Mandatory, Position = 0)]
        [decimal]
        $Value,

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [string]
        $From = (Get-CurrencyDefaultValue -Name 'From'),

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL')]
        [parameter(Mandatory, Position = 1)]
        [string[]]
        $To,

        [string]
        $APIKey = (Get-CurrencyDefaultValue -Name 'APIKey'),

        [datetime]
        $Date
    )

    process {
        if (-not $From) {
            Write-Error "A -From currency is required. Specify it explicitly, or save a default with Set-CurrencyDefault -From."
            return
        }

        if ($Date -and -not $APIKey) {
            Write-Error "A -Date requires an -APIKey, as historical rates are only available via the registered v6 API."
            return
        }

        $Row = [ordered]@{ $From = $Value }

        $ConvertParams = @{ From = $From; APIKey = $APIKey }

        if ($Date) {
            $ConvertParams.Date = $Date
        }

        foreach ($Currency in $To) {
            $ConvertedValue = $Value | Convert-Currency @ConvertParams -To $Currency

            if ($null -ne $ConvertedValue) {
                $Row[$Currency] = [decimal]$ConvertedValue
            }
        }

        [pscustomobject]$Row
    }
}
