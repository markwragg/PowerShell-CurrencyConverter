function Format-Currency {
    <#
    .SYNOPSIS
        Formats a value with the currency symbol for a specified country.
    #>
    param(
        [parameter(Mandatory)]
        [string]
        $Currency,

        [string]
        $ConvertToCurrency,

        [parameter(ValueFromPipeline,Mandatory)]
        [decimal]
        $Value
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