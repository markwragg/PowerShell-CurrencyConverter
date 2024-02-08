# Change Log

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
