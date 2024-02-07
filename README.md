# PowerShell Currency Converter

[![Build Status](https://dev.azure.com/markwragg/GitHub/_apis/build/status/markwragg.PowerShell-CurrencyConverter?branchName=main)](https://dev.azure.com/markwragg/GitHub/_build/latest?definitionId=12&branchName=main) ![coverage](https://img.shields.io/badge/coverage-91%25-brightgreen.svg)

A PowerShell wrapper for the open currency conversion API provided by [ExchangeRate-API](https://www.exchangerate-api.com/).

> [!NOTE]
> No registration / API key is required to use this API, but the currency rates are refreshed once a day and rate limiting may occur if you make too many requests.
> The module caches the results for a currency to disk, so that the API only needs to be queried once a day for a specified currency.

## Installation

The module is published in the PowerShell Gallery, so if you have PowerShell 5 or newer can be installed by running:

```powershell
Install-Module CurrencyConverter
```

## Usage

To perform a simple currency conversion, execute:

```powershell
Convert-Currency -Value 100 -From USD -To GBP
```

> {!INFORMATION}
> See here for a list of supported currencies: https://www.exchangerate-api.com/docs/supported-currencies

The value can alternatively be provided via the pipeline:

```powershell
100 | Convert-Currency -From EUR -To CAD
```

This means that you can pipe multiple values in to perform a series of conversions:

```powershell
100,200,250 | Convert-Currency -From USD -To JPY
```

If you would like to return the result as a formatted string including the currency symbol and rounded to a number of decimal places, execute:

```powershell
100 | Format-Currency -Currency USD

$100.00
```

This cmdlet rounds to two decimal places by default. To specify a different number of decimal places, use the `-Decimals` parameter:

```powershell
Format-Currency -Value 123.4567890 -Currency GBP -Decimals 4

£123.4568
```

You can also perform a currency conversion at the same time as performing the format:

```powershell
Format-Currency -Value 100 -Currency GBP -ConvertTo USD

$125.85
```

If you would prefer the currency symbol to appear after the value, use the `-SymbolAtEnd` switch parameter:

```powershell
Format-Currency -Value 100 -Currency GBP -SymbolAtEnd

125.85£
```

You can also pipe the result of `Convert-Currency` to `Format-Currency`:

```powershell
Convert-Currency -Value 100 -From USD -To EUR | Format-Currency -Currency EUR

€93.04
```

