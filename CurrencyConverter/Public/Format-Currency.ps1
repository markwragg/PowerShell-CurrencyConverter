function Format-Currency {
    <#
    .SYNOPSIS
        Formats a value with the currency symbol for a specified country.

    .DESCRIPTION
        Outputs a value with the specified currency symbol. Can also be used to perform a currency conversion and then format as the destination currency.

    .PARAMETER Currency
        The currency to format the value as.

    .PARAMETER ConvertToCurrency
        Perform a currency conversion and then format as that currency.

    .PARAMETER Value
        The currency value.

    .EXAMPLE
        100 | Format-Currency -Currency USD

        Description
        -----------
        Formats the value (provided via the pipeline) as USD: $100.00.

    .EXAMPLE
        100 | Format-Currency -Currency USD -ConvertToCurrency GBP

        Description
        -----------
        Converts 100 from USD to GBP and formats as GBP, e.g.: £79.67

    .EXAMPLE
        Format-Currency -Value 100 -Currency USD

        Description
        -----------
        Formats the value as USD: $100.00.
    #>
    param(
        [parameter(ValueFromPipeline,Mandatory)]
        [decimal]
        $Value,

        [validateset('AED','AFN','ALL','AMD','ANG','AOA','ARS','AUD','AWG','AZN','BAM','BBD','BDT','BGN','BHD','BIF','BMD','BND','BOB','BRL','BSD','BTN','BWP','BYN','BZD','CAD','CDF','CHF','CLP','CNY','COP','CRC','CUP','CVE','CZK','DJF','DKK','DOP','DZD','EGP','ERN','ETB','EUR','FJD','FKP','FOK','GBP','GEL','GGP','GHS','GIP','GMD','GNF','GTQ','GYD','HKD','HNL','HRK','HTG','HUF','IDR','ILS','IMP','INR','IQD','IRR','ISK','JEP','JMD','JOD','JPY','KES','KGS','KHR','KID','KMF','KRW','KWD','KYD','KZT','LAK','LBP','LKR','LRD','LSL','LYD','MAD','MDL','MGA','MKD','MMK','MNT','MOP','MRU','MUR','MVR','MWK','MXN','MYR','MZN','NAD','NGN','NIO','NOK','NPR','NZD','OMR','PAB','PEN','PGK','PHP','PKR','PLN','PYG','QAR','RON','RSD','RUB','RWF','SAR','SBD','SCR','SDG','SEK','SGD','SHP','SLE','SOS','SRD','SSP','STN','SYP','SZL','THB','TJS','TMT','TND','TOP','TRY','TTD','TVD','TWD','TZS','UAH','UGX','USD','UYU','UZS','VES','VND','VUV','WST','XAF','XCD','XDR','XOF','XPF','YER','ZAR','ZMW','ZWL')]
        [parameter(Mandatory)]
        [string]
        $Currency,

        [validateset('AED','AFN','ALL','AMD','ANG','AOA','ARS','AUD','AWG','AZN','BAM','BBD','BDT','BGN','BHD','BIF','BMD','BND','BOB','BRL','BSD','BTN','BWP','BYN','BZD','CAD','CDF','CHF','CLP','CNY','COP','CRC','CUP','CVE','CZK','DJF','DKK','DOP','DZD','EGP','ERN','ETB','EUR','FJD','FKP','FOK','GBP','GEL','GGP','GHS','GIP','GMD','GNF','GTQ','GYD','HKD','HNL','HRK','HTG','HUF','IDR','ILS','IMP','INR','IQD','IRR','ISK','JEP','JMD','JOD','JPY','KES','KGS','KHR','KID','KMF','KRW','KWD','KYD','KZT','LAK','LBP','LKR','LRD','LSL','LYD','MAD','MDL','MGA','MKD','MMK','MNT','MOP','MRU','MUR','MVR','MWK','MXN','MYR','MZN','NAD','NGN','NIO','NOK','NPR','NZD','OMR','PAB','PEN','PGK','PHP','PKR','PLN','PYG','QAR','RON','RSD','RUB','RWF','SAR','SBD','SCR','SDG','SEK','SGD','SHP','SLE','SOS','SRD','SSP','STN','SYP','SZL','THB','TJS','TMT','TND','TOP','TRY','TTD','TVD','TWD','TZS','UAH','UGX','USD','UYU','UZS','VES','VND','VUV','WST','XAF','XCD','XDR','XOF','XPF','YER','ZAR','ZMW','ZWL')]
        [string]
        $ConvertToCurrency
    )

    process {
        $CurrencySymbols = @{
            'AED' = 'د.إ'
            'ARS' = '$'
            'AUD' = '$'
            'BRL' = 'R$'
            'CAD' = '$'
            'CHF' = 'CHF'
            'DKK' = 'kr.'
            'EUR' = '€'
            'GBP' = '£'
            'HKD' = '$'
            'IDR' = 'Rp'
            'INR' = '₹'
            'JPY' = '¥'
            'KRW' = '₩'
            'MXN' = '$'
            'MYR' = 'RM'
            'NOK' = 'kr'
            'NZD' = '$'
            'OMR' = 'ر.ع.'
            'PKR' = 'Rs'
            'QAR' = 'ق.ر'
            'RUB' = '₽'
            'SAR' = '﷼'
            'SEK' = 'kr'
            'TWD' = 'NT$'
            'TRY' = '₺'
            'USD' = '$'
            'UZS' = 'лв'
            'ZAR' = 'R'
        }

        if ($ConvertToCurrency) {
            $ConvertedValue = $Value | ConvertTo-Currency -SourceCurrency $Currency -DestinationCurrency $ConvertToCurrency
            "$($CurrencySymbols[$ConvertToCurrency]){0:n2}" -f $ConvertedValue
        }
        else {
            "$($CurrencySymbols[$Currency]){0:n2}" -f $Value
        }
    }
}