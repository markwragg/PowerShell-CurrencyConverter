function Add-CurrencyMember {
    <#
    .SYNOPSIS
        Adds a new member to an object that is a currency conversion of one of its existing properties.

    .DESCRIPTION
        Converts the value of an existing property on a PowerShell object to another currency, and adds the
        result as a new property on that same object via Add-Member. Uses Convert-Currency or
        Convert-CryptoCurrency to perform the conversion, depending on whether -From/-To are crypto currencies.
        As with Add-Member, the updated object is only returned to the pipeline if -PassThru is specified.

    .PARAMETER InputObject
        The object to add the new member to. Can be provided via the pipeline.

    .PARAMETER Property
        The name of the existing property on InputObject whose value should be converted.

    .PARAMETER MemberName
        The name of the new property to add to InputObject, containing the converted value. Defaults to
        "<Property><To>", e.g. a -Property of 'Price' and -To of 'GBP' would add a 'PriceGBP' property.

    .PARAMETER From
        The currency to convert from. Defaults to the value saved with Set-CurrencyDefault -From, if any.

    .PARAMETER To
        The currency to convert to. Defaults to the value saved with Set-CurrencyDefault -To, if any.

    .PARAMETER APIKey
        Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
        Defaults to the value saved with Set-CurrencyDefault -APIKey, if any. Not used when converting
        to/from a crypto currency.

    .PARAMETER Date
        Optional: Converts using the historical exchange rates for the specified date, instead of the
        latest rates. This requires an -APIKey, as historical data is only available via the registered
        v6 API. Not supported when converting to/from a crypto currency.

    .PARAMETER PassThru
        Returns the updated object to the pipeline. By default, this cmdlet does not generate any output.

    .INPUTS
        A PowerShell object, can be provided via the pipeline.

    .OUTPUTS
        If -PassThru is specified, the input object, with the new member added.

    .EXAMPLE
        [pscustomobject]@{ Product = 'Widget'; Price = 100 } | Add-CurrencyMember -Property Price -From USD -To GBP -PassThru

        Description
        -----------
        Adds a PriceGBP property to the object, with the Price property converted from USD to GBP, and returns the updated object.

    .EXAMPLE
        $Orders | Add-CurrencyMember -Property Total -MemberName TotalEUR -From USD -To EUR

        Description
        -----------
        Adds a TotalEUR property to each object in $Orders, with the Total property converted from USD to EUR.

    .EXAMPLE
        Set-CurrencyDefault -From USD -To GBP
        [pscustomobject]@{ Price = 100 } | Add-CurrencyMember -Property Price -PassThru

        Description
        -----------
        Uses the saved default -From/-To currencies to add a PriceGBP property, and returns the updated object.

    .EXAMPLE
        [pscustomobject]@{ Price = 1 } | Add-CurrencyMember -Property Price -From BTC -To GBP -PassThru

        Description
        -----------
        Adds a PriceGBP property, with the Price property converted from BTC to GBP via Convert-CryptoCurrency, and returns the updated object.

    .EXAMPLE
        [pscustomobject]@{ Price = 100 } | Add-CurrencyMember -Property Price -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere -PassThru

        Description
        -----------
        Adds a PriceGBP property, with the Price property converted from USD to GBP using the exchange rate as it was on 15th January 2024, and returns the updated object.

    .LINK
        https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Add-CurrencyMember
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [parameter(ValueFromPipeline, Mandatory)]
        [psobject]
        $InputObject,

        [parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property,

        [parameter(Position = 1)]
        [string]
        $MemberName,

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL', 'BTC', 'ETH', 'USDT', 'ADA', 'XRP', 'SOL', 'DOT', 'DOGE', 'DAI', 'LTC', 'ALGO', 'BCH', 'OMI', 'ICP', 'ETC', 'XMR', 'XTZ', 'MIOTA', 'EOS', 'BSV', 'MKR', 'ZEC', 'DASH', 'XNO', 'REP', 'STEEM')]
        [string]
        $From = (Get-CurrencyDefaultValue -Name 'From'),

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL', 'BTC', 'ETH', 'USDT', 'ADA', 'XRP', 'SOL', 'DOT', 'DOGE', 'DAI', 'LTC', 'ALGO', 'BCH', 'OMI', 'ICP', 'ETC', 'XMR', 'XTZ', 'MIOTA', 'EOS', 'BSV', 'MKR', 'ZEC', 'DASH', 'XNO', 'REP', 'STEEM')]
        [string]
        $To = (Get-CurrencyDefaultValue -Name 'To'),

        [string]
        $APIKey = (Get-CurrencyDefaultValue -Name 'APIKey'),

        [datetime]
        $Date,

        [switch]
        $PassThru
    )

    process {
        if (-not $From -or -not $To) {
            Write-Error "A -From and -To currency are required. Specify them explicitly, or save defaults with Set-CurrencyDefault."
            return
        }

        if (-not $InputObject.PSObject.Properties[$Property]) {
            Write-Error "InputObject does not have a property named '$Property'."
            return
        }

        $CryptoCurrency = 'BTC', 'ETH', 'USDT', 'ADA', 'XRP', 'SOL', 'DOT', 'DOGE', 'DAI', 'LTC', 'ALGO', 'BCH', 'OMI', 'ICP', 'ETC', 'XMR', 'XTZ', 'MIOTA', 'EOS', 'BSV', 'MKR', 'ZEC', 'DASH', 'XNO', 'REP', 'STEEM'
        $IsCrypto = $From -in $CryptoCurrency -or $To -in $CryptoCurrency

        if ($Date -and $IsCrypto) {
            Write-Error "A -Date cannot be used when converting to/from a crypto currency."
            return
        }

        if ($Date -and -not $APIKey) {
            Write-Error "A -Date requires an -APIKey, as historical rates are only available via the registered v6 API."
            return
        }

        if ($IsCrypto) {
            $ConvertedValue = $InputObject.$Property | Convert-CryptoCurrency -From $From -To $To
        }
        else {
            $ConvertParams = @{ From = $From; To = $To; APIKey = $APIKey }

            if ($Date) {
                $ConvertParams.Date = $Date
            }

            $ConvertedValue = $InputObject.$Property | Convert-Currency @ConvertParams
        }

        if ($null -eq $ConvertedValue) {
            return
        }

        $ResolvedMemberName = if ($MemberName) { $MemberName } else { "$Property$To" }

        $InputObject | Add-Member -NotePropertyName $ResolvedMemberName -NotePropertyValue ([decimal]$ConvertedValue) -Force -PassThru:$PassThru
    }
}
