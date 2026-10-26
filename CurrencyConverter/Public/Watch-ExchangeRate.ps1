function Watch-ExchangeRate {
    <#
    .SYNOPSIS
        Polls the exchange rate between two currencies on an interval, until it crosses a specified threshold.

    .DESCRIPTION
        Repeatedly calls Get-ExchangeRate (or Get-CryptoExchangeRate, if -From or -To is a crypto currency)
        on the interval specified by -IntervalSeconds, writing a result to the pipeline for each poll. If
        -AboveThreshold or -BelowThreshold is specified, polling stops as soon as the rate crosses that
        threshold (the result for that poll has its Triggered property set to $true). If neither is
        specified, polling continues until -MaxIterations is reached, or indefinitely if -MaxIterations
        isn't specified (use Ctrl+C to stop).

    .PARAMETER From
        The currency to convert from. (Alias: Currency) Defaults to the value saved with
        Set-CurrencyDefault -From, if any.

    .PARAMETER To
        The currency to convert to. Defaults to the value saved with Set-CurrencyDefault -To, if any.
        If -From or -To is a crypto currency, the rate is polled via Get-CryptoExchangeRate instead of
        Get-ExchangeRate (in which case -APIKey is not used).

    .PARAMETER AboveThreshold
        Optional: Stop polling once the exchange rate is greater than or equal to this value.

    .PARAMETER BelowThreshold
        Optional: Stop polling once the exchange rate is less than or equal to this value.

    .PARAMETER IntervalSeconds
        How many seconds to wait between each poll. Defaults to 60.

    .PARAMETER MaxIterations
        Optional: The maximum number of times to poll the exchange rate before stopping. If not specified,
        polling continues indefinitely (or until a specified threshold is crossed).

    .PARAMETER APIKey
        Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
        Defaults to the value saved with Set-CurrencyDefault -APIKey, if any.

    .OUTPUTS
        One object per poll, with From, To, Rate, Timestamp and Triggered properties.

    .EXAMPLE
        Watch-ExchangeRate -From USD -To GBP -AboveThreshold 0.80 -IntervalSeconds 300

        Description
        -----------
        Polls the USD to GBP exchange rate every 5 minutes until it rises to 0.80 or above.

    .EXAMPLE
        Watch-ExchangeRate -From USD -To GBP -MaxIterations 5

        Description
        -----------
        Polls the USD to GBP exchange rate every 60 seconds, 5 times, regardless of its value.

    .EXAMPLE
        Set-CurrencyDefault -From USD -To GBP
        Watch-ExchangeRate -BelowThreshold 0.75

        Description
        -----------
        Uses the saved default -From/-To currencies to poll the exchange rate every 60 seconds until it
        falls to 0.75 or below.

    .EXAMPLE
        Watch-ExchangeRate -From BTC -To USD -AboveThreshold 100000 -IntervalSeconds 30

        Description
        -----------
        Polls the BTC to USD exchange rate every 30 seconds, via Get-CryptoExchangeRate, until it rises to 100000 or above.

    .LINK
        https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Watch-ExchangeRate
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL', 'BTC', 'ETH', 'USDT', 'ADA', 'XRP', 'SOL', 'DOT', 'DOGE', 'DAI', 'LTC', 'ALGO', 'BCH', 'OMI', 'ICP', 'ETC', 'XMR', 'XTZ', 'MIOTA', 'EOS', 'BSV', 'MKR', 'ZEC', 'DASH', 'XNO', 'REP', 'STEEM')]
        [parameter(Position = 0)]
        [alias('Currency')]
        [string]
        $From = (Get-CurrencyDefaultValue -Name 'From'),

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL', 'BTC', 'ETH', 'USDT', 'ADA', 'XRP', 'SOL', 'DOT', 'DOGE', 'DAI', 'LTC', 'ALGO', 'BCH', 'OMI', 'ICP', 'ETC', 'XMR', 'XTZ', 'MIOTA', 'EOS', 'BSV', 'MKR', 'ZEC', 'DASH', 'XNO', 'REP', 'STEEM')]
        [parameter(Position = 1)]
        [string]
        $To = (Get-CurrencyDefaultValue -Name 'To'),

        [decimal]
        $AboveThreshold,

        [decimal]
        $BelowThreshold,

        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $IntervalSeconds = 60,

        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $MaxIterations,

        [string]
        $APIKey = (Get-CurrencyDefaultValue -Name 'APIKey')
    )

    if (-not $From -or -not $To) {
        Write-Error "A -From and -To currency are required. Specify them explicitly, or save defaults with Set-CurrencyDefault."
        return
    }

    $HasAboveThreshold = $PSBoundParameters.ContainsKey('AboveThreshold')
    $HasBelowThreshold = $PSBoundParameters.ContainsKey('BelowThreshold')

    $CryptoCurrency = 'BTC', 'ETH', 'USDT', 'ADA', 'XRP', 'SOL', 'DOT', 'DOGE', 'DAI', 'LTC', 'ALGO', 'BCH', 'OMI', 'ICP', 'ETC', 'XMR', 'XTZ', 'MIOTA', 'EOS', 'BSV', 'MKR', 'ZEC', 'DASH', 'XNO', 'REP', 'STEEM'
    $IsCrypto = $From -in $CryptoCurrency -or $To -in $CryptoCurrency

    $Iteration = 0

    while ($true) {
        $Iteration++

        $Rate = if ($IsCrypto) {
            Get-CryptoExchangeRate -From $From -To $To
        }
        else {
            Get-ExchangeRate -From $From -To $To -APIKey $APIKey
        }

        if ($null -ne $Rate) {
            $Triggered = ($HasAboveThreshold -and $Rate -ge $AboveThreshold) -or ($HasBelowThreshold -and $Rate -le $BelowThreshold)

            [pscustomobject]@{
                From      = $From
                To        = $To
                Rate      = $Rate
                Timestamp = Get-Date
                Triggered = [bool]$Triggered
            }

            if ($Triggered) {
                break
            }
        }

        if ($MaxIterations -and $Iteration -ge $MaxIterations) {
            break
        }

        Start-Sleep -Seconds $IntervalSeconds
    }
}
