# Change Log

## [1.0.4] - 2026-10-23

* Added `Add-CurrencyMember` cmdlet, to add a new property to an object that is a currency conversion of one of its existing properties.

## [1.0.3] - 2026-10-23

* No functional changes. Published as a result of an overlapping deploy pipeline run; identical to 1.0.2.

## [1.0.2] - 2026-10-23

* Renamed `Get-CurrencyConverterDefault` and `Set-CurrencyConverterDefault` to `Get-CurrencyDefault` and `Set-CurrencyDefault`.

## [1.0.1] - 2026-10-23

* Added `Set-CurrencyConverterDefault` and `Get-CurrencyConverterDefault` cmdlets, so you can save default values for `-From`, `-To` and `-APIKey` (stored under `~/.currencyconverter`) that `Convert-Currency`, `Convert-CryptoCurrency`, `Get-ExchangeRate` and `Get-CryptoExchangeRate` will use automatically when those parameters aren't specified.
* Fixed `Get-Currency` and `Get-CryptoCurrency` failing in the published module because `SupportedCurrency.csv` and `SupportedCryptoCurrency.csv` were not being copied into the built module during staging.

## [1.0.0] - 2025-09-25

* Updated `Convert-Currency` and `Convert-CryptoCurrency` to attach the destination currency to their output, so that `Format-Currency` can automatically pick it up via the pipeline without needing to specify `-Currency`.

## [0.0.7] - 2024-05-18

* Implemented `Convert-CryptoCurrency`, `Get-CryptoCurrency` and `Get-CryptoExchangeRate` cmdlets to support the conversion of crypto currencies via the CoinBase API.
* Updated `Format-Currency` to support some crypto currency symbols (where known) and the conversion of crypto currencies.

## [0.0.6] - 2024-02-08

* Added API Key support to `Convert-Currency` and `Get-ExchangeRate`. To use the v6 API, specify your API key via the `-APIKey` parameter.

## [0.0.5] - 2024-02-08

* Added position=0 for `-Value` of `Convert-Currency` so the value can be provided without naming the parameter.
* Added Inputs and OutputType for cmdlet help.
* Amended `Get-Currency` to accept the currency code values via pipeline.
* Amended `Get-ExchangeRate` to accept the currency code values via pipeline.

## [0.0.4] - 2024-02-08

* Implemented `Get-Currency` to return details of the currencies supported by this tool.
* Added a `-Rates` switch to `Get-ExchangeRate` to return all rates for a specified currency.

## [0.0.3] - 2024-02-08

* Implemented `Get-ExchangeRate` to return the full result from the API as a PowerShell object, or a specified exchange rate.

## [0.0.1] - 2024-02-07

* Implemented `Convert-Currency` to perform currency conversions via the ExchangeRate-API Open Access API.
* Implemented `Format-Currency` to decorate a value with a specified currency symbol.

## [0.0.0] - 2024-02-06

* Initial commit
