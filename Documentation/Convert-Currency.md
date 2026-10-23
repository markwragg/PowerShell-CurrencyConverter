# Convert-Currency

## SYNOPSIS
Converts a decimal value between specified currencies

## SYNTAX

```
Convert-Currency [-Value] <Decimal> [-From <String>] [-To <String>] [-APIKey <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Open Exchange Rate API (https://www.exchangerate-api.com/docs/free) to perform currency conversions.
Caches the conversion rates for the specified currency (valid for 24 hours).

## EXAMPLES

### EXAMPLE 1
```
100 | Convert-Currency -From USD -To GBP
```

Description
-----------
Converts the value 100 (provided via the pipeline) from USD (US Dollar) to GBP (British Pound), example result: 79.674700

### EXAMPLE 2
```
Convert-Currency -Value 100 -From AUD -To EUR
```

Description
-----------
Converts the value 100 from USD (US Dollar) to AUD (Australian Dollar), example result: 154.211800

### EXAMPLE 3
```
Convert-Currency -Value 100 -From USD -To EUR | Format-Currency
```

Description
-----------
Converts 100 USD to EUR and pipes the result to Format-Currency, which picks up the destination currency (EUR) from the pipeline, example result: €92.15

### EXAMPLE 4
```
Set-CurrencyDefault -From USD -To GBP
Convert-Currency -Value 100
```

Description
-----------
Saves USD/GBP as the default currencies to convert between, then converts 100 USD to GBP without needing to specify -From/-To.

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
The currency to convert to.
Defaults to the value saved with Set-CurrencyDefault -To, if any.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-CurrencyDefaultValue -Name 'To')
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

### System.Decimal
## NOTES

## RELATED LINKS
