# ConvertTo-CurrencyTable

## SYNOPSIS
Converts a decimal value from one currency to several currencies at once.

## SYNTAX

```
ConvertTo-CurrencyTable [-Value] <Decimal> [-From <String>] [-To] <String[]> [-APIKey <String>]
 [-Date <DateTime>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses Convert-Currency to convert a value from a source currency (-From) to each of a list of
destination currencies (-To), and returns the results as a single object with one property per
currency.
This avoids having to call Convert-Currency in a loop when you want to compare a value
across multiple currencies.

## EXAMPLES

### EXAMPLE 1
```
100 | ConvertTo-CurrencyTable -From USD -To GBP,EUR,JPY
```

Description
-----------
Converts 100 USD to GBP, EUR and JPY, and returns the results as a single object with a USD,
GBP, EUR and JPY property.

### EXAMPLE 2
```
100,200 | ConvertTo-CurrencyTable -From USD -To GBP,EUR
```

Description
-----------
Converts each of 100 and 200 USD to GBP and EUR, returning one object per input value.

### EXAMPLE 3
```
Set-CurrencyDefault -From USD
100 | ConvertTo-CurrencyTable -To GBP,EUR
```

Description
-----------
Uses the saved default -From currency to convert 100 to GBP and EUR.

### EXAMPLE 4
```
100 | ConvertTo-CurrencyTable -From USD -To GBP,EUR -Date '2024-01-15' -ApiKey yourapikeystringhere
```

Description
-----------
Converts 100 USD to GBP and EUR using the exchange rates as they were on 15th January 2024.

## PARAMETERS

### -Value
The amount you want to convert between currencies.

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -From
The currency to convert from.
Defaults to the value saved with Set-CurrencyDefault -From, if any.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-CurrencyDefaultValue -Name 'From')
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
The currencies to convert to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
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
Optional: Converts using the historical exchange rates for the specified date, instead of the
latest rates.
This requires an -APIKey, as historical data is only available via the registered
v6 API.
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

### A numerical value, can be provided via the pipeline.
## OUTPUTS

### A single object with a property for -From and one for each currency specified via -To.
## NOTES

## RELATED LINKS

[https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/ConvertTo-CurrencyTable](https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/ConvertTo-CurrencyTable)

