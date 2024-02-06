function ConvertTo-Currency {

    param(
        [parameter(Mandatory)]
        [string]
        $SourceCurrency,
        
        [parameter(Mandatory)]
        [string]
        $DestinationCurrency,

        [parameter(ValueFromPipeline, Mandatory)]
        [decimal]
        $Value
    )

    process {
        if ($SourceCurrency -eq $DestinationCurrency) {
            $Value
        }
        else {
            $SourceCurrencyFile = "$PSScriptRoot\${SourceCurrency}.json"
            $CachedCurrency = Test-Path $SourceCurrencyFile

            if ($CachedCurrency) {
                $ExchangeRates = Get-Content $SourceCurrencyFile | ConvertFrom-Json
            }

            if (-not $CachedCurrency -or ((Get-Date) -gt (Get-Date -UnixTimeSeconds $ExchangeRates.time_next_update_unix))) {
                $ExchangeRates = Invoke-RestMethod "https://open.er-api.com/v6/latest/${SourceCurrency}"
                $ExchangeRates | ConvertTo-Json | Out-File "$PSScriptRoot\${SourceCurrency}.json" -Force
            }

            if ($ExchangeRates.rates.$DestinationCurrency) {
                $Value * $ExchangeRates.rates.$DestinationCurrency
            }
            else {
                Write-Error "Could not convert currency."
            }
        }
    }
}