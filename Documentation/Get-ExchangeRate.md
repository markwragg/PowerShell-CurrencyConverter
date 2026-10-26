# Get-ExchangeRate

## SYNOPSIS
Returns all exchange rates for a specified currency, or a specified exchange rate between two currencies.

## SYNTAX

### ToRate (Default)
```
Get-ExchangeRate [[-Currency] <String>] [-To <String>] [-APIKey <String>] [-Date <DateTime>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Rates
```
Get-ExchangeRate [[-Currency] <String>] [-Rates] [-APIKey <String>] [-Date <DateTime>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Open Exchange Rate API (https://www.exchangerate-api.com/docs/free) to retrieve currency rates.
Caches the conversion rates for the specified currency (valid for 24 hours).

## EXAMPLES

### EXAMPLE 1
```
Get-ExchangeRate -Currency USD
```

Description
-----------
Returns the exchange rates for US Dollar as a PowerShell object.

### EXAMPLE 2
```
Get-ExchangeRate -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere
```

Description
-----------
Returns the exchange rate from US Dollar to British Pound as it was on 15th January 2024.

### EXAMPLE 3
```
Get-ExchangeRate -Currency USD -Rates
```

Description
-----------
Returns all exchange rates for US Dollar.

### EXAMPLE 4
```
Get-ExchangeRate -From USD -To GBP
```

Description
-----------
Returns the exchange rate from US Dollar to British Pound, example result: 0.792011

### EXAMPLE 5
```
'USD','GBP' | Get-ExchangeRate
```

Description
-----------
Returns the exchange rates for US Dollar and British Pound as PowerShell objects.

### EXAMPLE 6
```
Set-CurrencyDefault -From USD -To GBP
Get-ExchangeRate
```

Description
-----------
Saves USD/GBP as the default currencies, then returns the exchange rate from US Dollar to British Pound without needing to specify -Currency/-To.

## PARAMETERS

### -Currency
The currency to return exchange rates for.
(Alias: From) Defaults to the value saved with
Set-CurrencyDefault -From, if any.

```yaml
Type: String
Parameter Sets: (All)
Aliases: From

Required: False
Position: 1
Default value: (Get-CurrencyDefaultValue -Name 'From')
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -To
The currency to return the exchange rate to (from the currency specified as -Currency or -From).
Defaults to the value saved with Set-CurrencyDefault -To, if any.

```yaml
Type: String
Parameter Sets: ToRate
Aliases:

Required: False
Position: Named
Default value: (Get-CurrencyDefaultValue -Name 'To')
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Rates
Switch: Use to return just the exchange rates for a specified currency.

```yaml
Type: SwitchParameter
Parameter Sets: Rates
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -APIKey
Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
Defaults to the value saved with Set-CurrencyDefault -APIKey, if any.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-CurrencyDefaultValue -Name 'APIKey')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date
Optional: Returns the historical exchange rates for the specified date, instead of the latest
rates.
This requires an -APIKey, as historical data is only available via the registered v6 API.
Historical results are cached indefinitely once retrieved, as they do not change.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{Fill ProgressAction Description}}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Currency codes can be provided via the pipeline.
## OUTPUTS

### System.Management.Automation.PSObject
### System.Management.Automation.PSObject
### System.Double
## NOTES

## RELATED LINKS

[https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Get-ExchangeRate](https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Get-ExchangeRate)

