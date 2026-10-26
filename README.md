# PowerShell Currency Converter

[![Build Status](https://dev.azure.com/markwragg/GitHub/_apis/build/status/markwragg.PowerShell-CurrencyConverter?branchName=main)](https://dev.azure.com/markwragg/GitHub/_build/latest?definitionId=12&branchName=main)
![coverage](https://img.shields.io/badge/coverage-92%25-brightgreen.svg)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/currencyconverter?label=PS%20Gallery)](https://www.powershellgallery.com/packages/currencyconverter)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/currencyconverter?color=D3D3D3)](https://www.powershellgallery.com/packages/currencyconverter)

A PowerShell module to provide currency conversion tools by wrapping the currency conversion APIs provided by [ExchangeRate-API](https://www.exchangerate-api.com/) and (for Crypto currencies) [CoinBase](https://api.coinbase.com/v2).

![PowerShell CurrencyConverter](/Media/powershell-currencyconverter.jpeg)

> [!IMPORTANT]
> No registration / API keys are required to use these APIs, but the currency rates from ExchangeRate-API are refreshed once a day and rate limiting may occur if you make too many requests.
> The module caches the results for a currency via ExchangeRate-API to disk, so that the API only needs to be queried once a day for a specified currency. You can also cache crypto currency requests
> to disk by providing the `-CacheSeconds` parameter. Note that the CoinBase API refreshes exchange rates frequently (appears to be every 15 seconds).
>
> If you have registered at ExchangeRate-API, you can provide your API key via the `-APIKey` parameter of the `Convert-Currency` and `Get-ExchangeRate` cmdlets and this will invoke the v6 API.

![PowerShell CurrencyConverter example usage](/Media/add-currencymember-example.png)
_Above: `Add-CurrencyMember` example, which allows you to add an additional currency property to an existing PowerShell object collection_

## Installation

The module is published in the PowerShell Gallery, so if you have PowerShell 5 or newer can be installed by running:

```powershell
Install-Module CurrencyConverter
```

## Usage

This module provides the following cmdlets:

Cmdlet                         | Description
------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------
Add-CurrencyMember             | Adds a new member to an object that is a currency conversion of one of its existing properties. Supports historical rates via `-Date`.
Convert-Currency               | Converts a decimal value between two specified currencies using ExchangeRate-API. Supports historical rates via `-Date`.
Convert-CryptoCurrency         | Converts a decimal value between two specified crypto/non-crypto currencies using CoinBase API.
ConvertTo-CurrencyTable        | Converts a decimal value to several currencies at once, returning the results as a single object. Supports historical rates via `-Date`.
Format-Currency                | Formats a value as a string with the currency symbol for a specified country or crypto currency (where supported).
Get-Currency                   | Returns the list of supported currency codes along with their currency name and country code.
Get-CryptoCurrency             | Returns the list of supported crypto currency codes along with their currency name and type (crypto or fiat).
Get-ExchangeRate               | Returns all exchange rates for a specified currency, or a specified exchange rate between two currencies. Supports historical rates via `-Date`.
Get-CryptoExchangeRate         | Returns all exchange rates for a specified crypto currency, or a specified exchange rate between two crypto/non-crypto currencies.
Set-CurrencyDefault   | Saves default values for `-From`, `-To` and `-APIKey` so you don't need to specify them on every call.
Get-CurrencyDefault   | Returns the default values currently saved by `Set-CurrencyDefault`.
Watch-ExchangeRate    | Polls an exchange rate on an interval, until it crosses a specified threshold. Supports crypto currencies.

To perform a simple currency conversion, execute:

```powershell
Convert-Currency -Value 100 -From USD -To GBP
```
```plaintext
74.666100
```

Or for a crypto currency:

```powershell
Convert-CryptoCurrency -Value 100 -From BTC -To GBP
```
```plaintext
6107769.00
```

To use the ExhangeRate-API registered API, provide your key via the `-APIKey` parameter:

```powershell
Convert-Currency -Value 100 -From USD -To GBP -ApiKey yourapikeystringhere
```

If you also have a registered API key, you can convert using the historical exchange rate for a specific date by specifying `-Date`:

```powershell
Convert-Currency -Value 100 -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere
```
```plaintext
79.2460
```

> [!NOTE]
> Historical rates are only available via the registered v6 API, so `-Date` requires `-APIKey` to also be specified (or saved via `Set-CurrencyDefault`). Once retrieved, historical rates are cached indefinitely, since they don't change.

> [!TIP]
> See here for a list of supported currencies: https://www.exchangerate-api.com/docs/supported-currencies. Alternatively you can use the `Get-Currency` cmdlet.

The value can alternatively be provided via the pipeline:

```powershell
100 | Convert-Currency -From EUR -To CAD
100 | Convert-CryptoCurrency -From BTC -To GBP
```
```plaintext
157.186500
```
```plaintext
6107769.00
```

This means that you can pipe multiple values in to perform a series of conversions:

```powershell
100,200,250 | Convert-Currency -From USD -To JPY
100,200,250 | Convert-CryptoCurrency -From BTC -To GBP
```
```plaintext
15692.063700
31384.127400
39230.159250
```
```plaintext
6107769.00
12215538.00
15269422.50
```

If you want to convert a value to several currencies at once, use `ConvertTo-CurrencyTable`, which returns the results as a single object with one property per currency:

```powershell
100 | ConvertTo-CurrencyTable -From USD -To GBP,EUR,JPY
```
```plaintext
USD GBP   EUR   JPY
--- ---   ---   ---
100 79.20 93.04 15692.06
```

`ConvertTo-CurrencyTable` also supports `-Date` and `-APIKey`, which it passes through to `Convert-Currency` for each destination currency.

If you would like to return the result as a formatted string including the currency symbol and rounded to a number of decimal places, execute:

```powershell
100 | Format-Currency -Currency USD
```
```plaintext
$100.00
```

```powershell
100 | Format-Currency -Currency ETH
```
```plaintext
Ξ100.00
```

This cmdlet rounds to two decimal places by default. To specify a different number of decimal places, use the `-Decimals` parameter:

```powershell
Format-Currency -Value 123.4567890 -Currency GBP -Decimals 4
```
```plaintext
£123.4568
```

You can also perform a currency conversion at the same time as performing the format:

```powershell
Format-Currency -Value 100 -Currency GBP -ConvertTo USD
```
```plaintext
$125.85
```

If you would prefer the currency symbol to appear after the value, use the `-SymbolAtEnd` switch parameter:

```powershell
Format-Currency -Value 100 -Currency GBP -SymbolAtEnd
```
```plaintext
125.85£
```

You can also pipe the result of `Convert-Currency` or `Convert-CryptoCurrency` to `Format-Currency`. The destination currency is automatically picked up from the pipeline, so there's no need to specify `-Currency`:

```powershell
Convert-Currency -Value 100 -From USD -To EUR | Format-Currency
```
```plaintext
€93.04
```

To see a full list of currency codes supported by this tool, along with their name and country, execute:

```powershell
Get-Currency
```

To see a full list of crypto currency codes supported by this tool, along with their name and type, execute:

```powershell
Get-CryptoCurrency
```

You can also specify a specific code (this requires an exact match):

```powershell
Get-Currency -Currency GBP
Get-CryptoCurrency -Currency BTC
```

Or you can filter by currency or country name (this will return partial matches):

```powershell
Get-Currency -Name 'Pound'
```
```plaintext
Code Name                   Country
---- ----                   -------
EGP  Egyptian Pound         Egypt
FKP  Falkland Islands Pound Falkland Islands
GBP  Pound Sterling         United Kingdom
GGP  Guernsey Pound         Guernsey
GIP  Gibraltar Pound        Gibraltar
IMP  Manx Pound             Isle of Man
JEP  Jersey Pound           Jersey
LBP  Lebanese Pound         Lebanon
SDG  Sudanese Pound         Sudan
SHP  Saint Helena Pound     Saint Helena
SSP  South Sudanese Pound   South Sudan
SYP  Syrian Pound           Syria
```

```powershell
Get-Currency -Country 'United'
```
```plaintext
Code Name                 Country
---- ----                 -------
AED  UAE Dirham           United Arab Emirates
GBP  Pound Sterling       United Kingdom
USD  United States Dollar United States
```


To return the full result from the API as a PowerShell object, use the `Get-ExchangeRate` cmdlet:

```powershell
Get-ExchangeRate -Currency USD
```

Or for crypto currencies:

```powershell
Get-CryptoExchangeRate -Currency BTC
```

To use the registered API, provide your key via the `-APIKey` parameter:

```powershell
Get-ExchangeRate -Currency GBP -ApiKey yourapikeystringhere
```

> [!NOTE]
> When an API key is provided, the v6 API is invoked. This returns the rates as a property called 'conversion_rates'. The Open API returns the property as 'rates'.

```plaintext
result                : success
provider              : https://www.exchangerate-api.com
documentation         : https://www.exchangerate-api.com/docs/free
terms_of_use          : https://www.exchangerate-api.com/terms
time_last_update_unix : 1707350551
time_last_update_utc  : Thu, 08 Feb 2024 00:02:31 +0000
time_next_update_unix : 1707437661
time_next_update_utc  : Fri, 09 Feb 2024 00:14:21 +0000
time_eol_unix         : 0
base_code             : USD
rates                 : @{USD=1; AED=3.6725; AFN=73.755496; ALL=96.818553; AMD=405.868756; ANG=1.79; AOA=839.476403; ARS=830.15;
                        AUD=1.533245; AWG=1.79; AZN=1.699659; BAM=1.81591; BBD=2; BDT=109.768633; BGN=1.81581; BHD=0.376;
                        BIF=2850.388516; BMD=1; BND=1.343391; BOB=6.934197; BRL=4.962119; BSD=1; BTN=83.001945; BWP=13.679849;
                        BYN=3.245101; BZD=2; CAD=1.346345; CDF=2728.475301; CHF=0.873457; CLP=947.575519; CNY=7.19952;
                        COP=3954.758146; CRC=517.23293; CUP=24; CVE=102.376655; CZK=23.176359; DJF=177.721; DKK=6.92457;
                        DOP=58.566572; DZD=134.658699; EGP=30.904297; ERN=15; ETB=56.700184; EUR=0.928449; FJD=2.247047;
                        FKP=0.792018; FOK=6.92461; GBP=0.792011; GEL=2.659816; GGP=0.792018; GHS=12.422748; GIP=0.792018;
                        GMD=66.562902; GNF=8588.188018; GTQ=7.814905; GYD=209.536717; HKD=7.820255; HNL=24.66876; HRK=6.995483;
                        HTG=131.989675; HUF=360.172059; IDR=15650.579046; ILS=3.652044; IMP=0.792018; INR=83.001968;
                        IQD=1310.842088; IRR=42080.433475; ISK=137.663905; JEP=0.792018; JMD=156.245808; JOD=0.709;
                        JPY=148.053154; KES=160.352692; KGS=89.414602; KHR=4091.328437; KID=1.533294; KMF=456.772434;
                        KRW=1326.84486; KWD=0.307938; KYD=0.833333; KZT=452.274884; LAK=20736.087575; LBP=15000; LKR=312.628935;
                        LRD=192.145847; LSL=18.897808; LYD=4.844127; MAD=10.061229; MDL=17.827961; MGA=4536.616958;
                        MKD=57.312368; MMK=2099.744651; MNT=3412.288092; MOP=8.054862; MRU=39.584855; MUR=45.384067;
                        MVR=15.453447; MWK=1689.264206; MXN=17.05608; MYR=4.761416; MZN=63.917225; NAD=18.897808;
                        NGN=1407.528785; NIO=36.672231; NOK=10.577722; NPR=132.803112; NZD=1.636807; OMR=0.384497; PAB=1;
                        PEN=3.861833; PGK=3.749532; PHP=56.01365; PKR=279.042023; PLN=4.033029; PYG=7296.21721; QAR=3.64;
                        RON=4.620779; RSD=108.801814; RUB=91.346239; RWF=1284.744312; SAR=3.75; SBD=8.488406; SCR=13.291546;
                        SDG=544.79719; SEK=10.475851; SGD=1.343391; SHP=0.792018; SLE=22.587694; SLL=22587.694431;
                        SOS=571.785619; SRD=36.611265; SSP=1102.449099; STN=22.747273; SYP=12950.775091; SZL=18.897808;
                        THB=35.595367; TJS=10.947348; TMT=3.500938; TND=3.129049; TOP=2.371485; TRY=30.62091; TTD=6.777386;
                        TVD=1.533294; TWD=31.341578; TZS=2541.212285; UAH=37.600041; UGX=3817.518963; UYU=39.148736;
                        UZS=12479.514661; VES=36.2375; VND=24413.241561; VUV=120.508933; WST=2.745778; XAF=609.029912; XCD=2.7;
                        XDR=0.754059; XOF=609.029912; XPF=110.795003; YER=250.331823; ZAR=18.897825; ZMW=27.029301;
                        ZWL=10811.587531}
```

If you want to return just the exchange rates, you can execute `Get-ExchangeRate` or `Get-CryptoExchangeRate` and specify `-Rates`:

```powershell
Get-ExchangeRate -Currency GBP -Rates
```
```plaintext
GBP : 1
AED : 4.636888
AFN : 92.99538
ALL : 122.070196
AMD : 510.608906
ANG : 2.260049
AOA : 1067.044213
ARS : 1048.144979
AUD : 1.935836
AWG : 2.260049
AZN : 2.145246
BAM : 2.292681
BBD : 2.525194
BDT : 138.549806
...
```

If you just want to return a specific exchange rate, you can execute `Get-ExchangeRate` or `Get-CryptoExchangeRate` and specify `-From` and `-To`:

```powershell
Get-ExchangeRate -From GBP -To USD
```
```plaintext
1.262609
```

If you have a registered API key, you can retrieve historical exchange rates for a specific date by specifying `-Date`:

```powershell
Get-ExchangeRate -From GBP -To USD -Date '2024-01-15' -ApiKey yourapikeystringhere
```
```plaintext
1.269
```

> [!NOTE]
> Historical rates are only available via the registered v6 API, so `-Date` requires `-APIKey` to also be specified (or saved via `Set-CurrencyDefault`). Once retrieved, historical rates are cached indefinitely, since they don't change.

### Watching an exchange rate

If you want to keep an eye on an exchange rate and be notified when it reaches a particular level, use `Watch-ExchangeRate`. It polls the rate on an interval (`-IntervalSeconds`, default 60) and writes a result to the pipeline for each poll:

```powershell
Watch-ExchangeRate -From USD -To GBP -AboveThreshold 0.80 -IntervalSeconds 300
```
```plaintext
From To  Rate     Timestamp              Triggered
---- --  ----     ---------              ---------
USD  GBP 0.792011 15/01/2024 09:00:00     False
USD  GBP 0.798    15/01/2024 09:05:00     False
USD  GBP 0.801    15/01/2024 09:10:00     True
```

Polling stops as soon as the rate crosses `-AboveThreshold` or `-BelowThreshold` (the matching result has `Triggered` set to `$true`). If you don't specify either, or want to cap how long it runs for regardless, use `-MaxIterations`:

```powershell
Watch-ExchangeRate -From USD -To GBP -MaxIterations 5
```

`Watch-ExchangeRate` also supports crypto currencies. If `-From` or `-To` is a crypto currency, it polls via `Get-CryptoExchangeRate` instead of `Get-ExchangeRate` (in which case `-APIKey` is not used):

```powershell
Watch-ExchangeRate -From BTC -To USD -AboveThreshold 100000 -IntervalSeconds 30
```

### Setting defaults

If you regularly convert between the same currencies, or always use the same API key, you can save them as defaults so you don't need to specify them every time:

```powershell
Set-CurrencyDefault -From USD -To GBP -APIKey yourapikeystringhere
```

Once saved, `Convert-Currency`, `Convert-CryptoCurrency`, `Get-ExchangeRate` and `Get-CryptoExchangeRate` will use these values automatically whenever `-From`/`-Currency`, `-To` or `-APIKey` aren't explicitly specified:

```powershell
100 | Convert-Currency
```
```plaintext
79.200
```

Explicitly specifying a parameter always overrides the saved default:

```powershell
100 | Convert-Currency -From GBP -To USD
```

Defaults are saved to `~/.currencyconverter`. To see the currently saved defaults, use `Get-CurrencyDefault`. To remove all saved defaults, use `Set-CurrencyDefault -Reset`.

### Adding a converted property to an object

If you have an object with a property that represents a currency value, you can use `Add-CurrencyMember` to add a new property to it that is a currency conversion of that value:

```powershell
[pscustomobject]@{ Product = 'Widget'; Price = 100 } | Add-CurrencyMember -Property Price -From USD -To GBP -PassThru
```
```plaintext
Product Price PriceGBP
------- ----- --------
Widget    100    79.20
```

By default the new property is named `<Property><To>`, e.g. `PriceGBP`. You can specify a different name with `-MemberName`. `-From` and `-To` also fall back to any saved defaults, and crypto currency codes are converted via `Convert-CryptoCurrency` automatically. As with `Add-Member`, the updated object is only returned to the pipeline if `-PassThru` is specified.

If you have a registered API key, `Add-CurrencyMember` also supports `-Date` for converting using a historical exchange rate (not supported when `-From`/`-To` is a crypto currency):

```powershell
[pscustomobject]@{ Product = 'Widget'; Price = 100 } | Add-CurrencyMember -Property Price -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere -PassThru
```
```plaintext
Product Price PriceGBP
------- ----- --------
Widget    100    79.246
```
