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
        The currency to convert from.

    .PARAMETER To
        The currency to convert to.

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
    #>
    param(
        [parameter(ValueFromPipeline, Mandatory)]
        [decimal]
        $Value,

        [validateset('AED','AFN','ALL','AMD','ANG','AOA','ARS','AUD','AWG','AZN','BAM','BBD','BDT','BGN','BHD','BIF','BMD','BND','BOB','BRL','BSD','BTN','BWP','BYN','BZD','CAD','CDF','CHF','CLP','CNY','COP','CRC','CUP','CVE','CZK','DJF','DKK','DOP','DZD','EGP','ERN','ETB','EUR','FJD','FKP','FOK','GBP','GEL','GGP','GHS','GIP','GMD','GNF','GTQ','GYD','HKD','HNL','HRK','HTG','HUF','IDR','ILS','IMP','INR','IQD','IRR','ISK','JEP','JMD','JOD','JPY','KES','KGS','KHR','KID','KMF','KRW','KWD','KYD','KZT','LAK','LBP','LKR','LRD','LSL','LYD','MAD','MDL','MGA','MKD','MMK','MNT','MOP','MRU','MUR','MVR','MWK','MXN','MYR','MZN','NAD','NGN','NIO','NOK','NPR','NZD','OMR','PAB','PEN','PGK','PHP','PKR','PLN','PYG','QAR','RON','RSD','RUB','RWF','SAR','SBD','SCR','SDG','SEK','SGD','SHP','SLE','SOS','SRD','SSP','STN','SYP','SZL','THB','TJS','TMT','TND','TOP','TRY','TTD','TVD','TWD','TZS','UAH','UGX','USD','UYU','UZS','VES','VND','VUV','WST','XAF','XCD','XDR','XOF','XPF','YER','ZAR','ZMW','ZWL')]
        [parameter(Mandatory)]
        [string]
        $From,
        
        [validateset('AED','AFN','ALL','AMD','ANG','AOA','ARS','AUD','AWG','AZN','BAM','BBD','BDT','BGN','BHD','BIF','BMD','BND','BOB','BRL','BSD','BTN','BWP','BYN','BZD','CAD','CDF','CHF','CLP','CNY','COP','CRC','CUP','CVE','CZK','DJF','DKK','DOP','DZD','EGP','ERN','ETB','EUR','FJD','FKP','FOK','GBP','GEL','GGP','GHS','GIP','GMD','GNF','GTQ','GYD','HKD','HNL','HRK','HTG','HUF','IDR','ILS','IMP','INR','IQD','IRR','ISK','JEP','JMD','JOD','JPY','KES','KGS','KHR','KID','KMF','KRW','KWD','KYD','KZT','LAK','LBP','LKR','LRD','LSL','LYD','MAD','MDL','MGA','MKD','MMK','MNT','MOP','MRU','MUR','MVR','MWK','MXN','MYR','MZN','NAD','NGN','NIO','NOK','NPR','NZD','OMR','PAB','PEN','PGK','PHP','PKR','PLN','PYG','QAR','RON','RSD','RUB','RWF','SAR','SBD','SCR','SDG','SEK','SGD','SHP','SLE','SOS','SRD','SSP','STN','SYP','SZL','THB','TJS','TMT','TND','TOP','TRY','TTD','TVD','TWD','TZS','UAH','UGX','USD','UYU','UZS','VES','VND','VUV','WST','XAF','XCD','XDR','XOF','XPF','YER','ZAR','ZMW','ZWL')]
        [parameter(Mandatory)]
        [string]
        $To
    )

    process {
        if ($From -eq $To) {
            $Value
        }
        else {
            $FromFile = "$PSScriptRoot\${From}.json"
            $CachedCurrency = Test-Path $FromFile

            if ($CachedCurrency) {
                $ExchangeRates = Get-Content $FromFile | ConvertFrom-Json
            }

            if (-not $CachedCurrency -or ((Get-Date) -gt ($ExchangeRates.time_next_update_unix | ConvertFrom-UnixTime))) {
                $ExchangeRates = Invoke-RestMethod "https://open.er-api.com/v6/latest/${From}"
                $ExchangeRates | ConvertTo-Json | Out-File "$PSScriptRoot\${From}.json" -Force
            }

            if ($ExchangeRates.rates.$To) {
                $Value * $ExchangeRates.rates.$To
            }
            else {
                Write-Error "Could not convert currency."
            }
        }
    }
}