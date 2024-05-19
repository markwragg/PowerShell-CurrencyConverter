function Format-Currency {
    <#
    .SYNOPSIS
        Formats a value as a string with the currency symbol for a specified country.

    .DESCRIPTION
        Outputs a value with the specified currency symbol. Can also be used to perform a currency conversion and then format as the converted currency.

    .PARAMETER Value
        The currency value.

    .PARAMETER Currency
        The currency represented by value.

    .PARAMETER Decimals
        The number of decimal places to round the value to. Default: 2

    .PARAMETER ConvertTo
        Perform a currency conversion and then format as that currency.

    .PARAMETER SymbolAtEnd
        Place the currency symbol after the value.

    .INPUTS
        A numerical value, can be provided via the pipeline.

    .EXAMPLE
        100 | Format-Currency -Currency USD

        Description
        -----------
        Formats the value (provided via the pipeline) as USD: $100.00.

    .EXAMPLE
        100 | Format-Currency -Currency USD -ConvertTo GBP

        Description
        -----------
        Converts 100 from USD to GBP and formats as GBP, e.g.: £79.67

    .EXAMPLE
        Format-Currency -Value 100 -Currency USD

        Description
        -----------
        Formats the value as USD: $100.00.

    .EXAMPLE
        Format-Currency -Value 100.2345 -Currency USD -Decimals 3

        Description
        -----------
        Formats the value as USD: $100.235.

    .EXAMPLE
        Format-Currency -Value 100 -Currency USD -SymbolAtEnd

        Description
        -----------
        Formats the value as USD: 100.00$.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [parameter(ValueFromPipeline, Mandatory)]
        [decimal]
        $Value,

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL','BTC','ETH','USDT','ADA','XRP','SOL','DOT','DOGE','DAI','LTC','ALGO','BCH','OMI','ICP','ETC','XMR','XTZ','MIOTA','EOS','BSV','MKR','ZEC','DASH','XNO','REP','STEEM')]
        [parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [string]
        $Currency,

        [int]
        $Decimals = 2,

        [validateset('AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'FOK', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KID', 'KMF', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XDR', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL', 'BTC','ETH','USDT','ADA','XRP','SOL','DOT','DOGE','DAI','LTC','ALGO','BCH','OMI','ICP','ETC','XMR','XTZ','MIOTA','EOS','BSV','MKR','ZEC','DASH','XNO','REP','STEEM')]
        [parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ConvertTo,

        [switch]
        $SymbolAtEnd
    )

    process {
        $currencySymbols = @{
            'AED'   = 'د.إ'
            'AFN'   = '؋'
            'ALL'   = 'L'
            'AMD'   = 'Դ'
            'ANG'   = 'ƒ'
            'AOA'   = 'Kz'
            'ARS'   = '$'
            'AUD'   = '$'
            'AWG'   = 'ƒ'
            'AZN'   = 'ман'
            'BAM'   = 'KM'
            'BBD'   = '$'
            'BDT'   = '৳'
            'BGN'   = 'лв'
            'BHD'   = 'ب.د'
            'BIF'   = 'Fr'
            'BMD'   = '$'
            'BND'   = '$'
            'BOB'   = 'Bs.'
            'BRL'   = 'R$'
            'BSD'   = '$'
            'BTN'   = 'Nu.'
            'BWP'   = 'P'
            'BYN'   = 'Br'
            'BZD'   = '$'
            'CAD'   = '$'
            'CDF'   = 'Fr'
            'CHF'   = '₣'
            'CLP'   = '$'
            'CNY'   = '¥'
            'COP'   = '$'
            'CRC'   = '₡'
            'CUP'   = '₱'
            'CVE'   = '$'
            'CZK'   = 'Kč'
            'DJF'   = 'Fr'
            'DKK'   = 'kr'
            'DOP'   = 'RD$'
            'DZD'   = 'د.ج'
            'EGP'   = '£'
            'ERN'   = 'Nfk'
            'ETB'   = 'Br'
            'EUR'   = '€'
            'FJD'   = '$'
            'FKP'   = '£'
            'FOK'   = 'kr'
            'GBP'   = '£'
            'GEL'   = '₾'
            'GGP'   = '£'
            'GHS'   = '₵'
            'GIP'   = '£'
            'GMD'   = 'D'
            'GNF'   = 'Fr'
            'GTQ'   = 'Q'
            'GYD'   = '$'
            'HKD'   = '$'
            'HNL'   = 'L'
            'HRK'   = 'kn'
            'HTG'   = 'G'
            'HUF'   = 'Ft'
            'IDR'   = 'Rp'
            'ILS'   = '₪'
            'IMP'   = '£'
            'INR'   = '₹'
            'IQD'   = 'ع.د'
            'IRR'   = '﷼'
            'ISK'   = 'kr'
            'JEP'   = '£'
            'JMD'   = 'J$'
            'JOD'   = 'د.ا'
            'JPY'   = '¥'
            'KES'   = 'Sh'
            'KGS'   = 'с'
            'KHR'   = '៛'
            'KID'   = '$'
            'KMF'   = 'Fr'
            'KRW'   = '₩'
            'KWD'   = 'د.ك'
            'KYD'   = '$'
            'KZT'   = '₸'
            'LAK'   = '₭'
            'LBP'   = 'ل.ل'
            'LKR'   = 'Rs'
            'LRD'   = '$'
            'LSL'   = 'L'
            'LYD'   = 'ل.د'
            'MAD'   = 'د.م.'
            'MDL'   = 'L'
            'MGA'   = 'Ar'
            'MKD'   = 'ден'
            'MMK'   = 'Ks'
            'MNT'   = '₮'
            'MOP'   = 'P'
            'MRU'   = 'UM'
            'MUR'   = '₨'
            'MVR'   = 'Rf'
            'MWK'   = 'MK'
            'MXN'   = '$'
            'MYR'   = 'RM'
            'MZN'   = 'MT'
            'NAD'   = '$'
            'NGN'   = '₦'
            'NIO'   = 'C$'
            'NOK'   = 'kr'
            'NPR'   = '₨'
            'NZD'   = '$'
            'OMR'   = 'ر.ع.'
            'PAB'   = 'B/.'
            'PEN'   = 'S/'
            'PGK'   = 'K'
            'PHP'   = '₱'
            'PKR'   = '₨'
            'PLN'   = 'zł'
            'PYG'   = '₲'
            'QAR'   = 'ر.ق'
            'RON'   = 'lei'
            'RSD'   = 'дин'
            'RUB'   = '₽'
            'RWF'   = 'Fr'
            'SAR'   = 'ر.س'
            'SBD'   = '$'
            'SCR'   = '₨'
            'SDG'   = 'ج.س.'
            'SEK'   = 'kr'
            'SGD'   = '$'
            'SHP'   = '£'
            'SLE'   = 'Le'
            'SOS'   = 'Sh'
            'SRD'   = '$'
            'SSP'   = '£'
            'STN'   = 'Db'
            'SYP'   = '£'
            'SZL'   = 'L'
            'THB'   = '฿'
            'TJS'   = 'ЅМ'
            'TMT'   = 'm'
            'TND'   = 'د.ت'
            'TOP'   = 'T$'
            'TRY'   = '₺'
            'TTD'   = '$'
            'TVD'   = '$'
            'TWD'   = '$'
            'TZS'   = 'Sh'
            'UAH'   = '₴'
            'UGX'   = 'Sh'
            'USD'   = '$'
            'UYU'   = '$'
            'UZS'   = 'сўм'
            'VES'   = 'Bs.S'
            'VND'   = '₫'
            'VUV'   = 'Vt'
            'WST'   = 'T'
            'XAF'   = 'Fr'
            'XCD'   = '$'
            'XDR'   = 'SDR'
            'XOF'   = 'Fr'
            'XPF'   = 'Fr'
            'YER'   = '﷼'
            'ZAR'   = 'R'
            'ZMW'   = 'ZK'
            'ZWL'   = '$'
            # Cryto Currency
            'BTC'   = '₿'
            'ETH'   = 'Ξ'
            'USDT'  = '₮'
            'ADA'   = '₳'
            'XRP'   = '✕'
            'SOL'   = '◎'
            'DOT'   = '●'
            'DOGE'  = 'Ð'
            'DAI'   = '◈'
            'LTC'   = 'Ł'
            'ALGO'  = 'Ⱥ'
            'BCH'   = 'Ƀ'
            'OMI'   = 'Ο'
            'ICP'   = '∞'
            'ETC'   = 'ξ'
            'XMR'   = 'ɱ'
            'XTZ'   = 'ꜩ'
            'MIOTA' = 'ɨ'
            'EOS'   = 'ε'
            'BSV'   = 'Ɓ'
            'MKR'   = 'Μ'
            'ZEC'   = 'ⓩ'
            'DASH'  = 'Đ'
            'XNO'   = 'Ӿ'
            'REP'   = 'Ɍ'
            'STEEM' = 'ȿ'
        }

        if ($ConvertTo) {
            if ($ConvertTo -in 'BTC','ETH','USDT','ADA','XRP','SOL','DOT','DOGE','DAI','LTC','ALGO','BCH','OMI','ICP','ETC','XMR','XTZ','MIOTA','EOS','BSV','MKR','ZEC','DASH','XNO','REP','STEEM') {
                $Value = $Value | Convert-CryptoCurrency -From $Currency -To $ConvertTo
            }
            else {
                $Value = $Value | Convert-Currency -From $Currency -To $ConvertTo
            }
            
            $Currency = $ConvertTo
        }

        $CurrencySymbol = $CurrencySymbols[$Currency]
        
        if ($SymbolAtEnd) {
            ("{0:n$Decimals}" -f $Value) + $CurrencySymbol
        }
        else {
            $CurrencySymbol + ("{0:n$Decimals}" -f $Value)
        }
    }
}