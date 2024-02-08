# Convert-Currency

## SYNOPSIS
Converts a decimal value between specified currencies

## SYNTAX

```
Convert-Currency [-Value] <Decimal> -From <String> -To <String> [-APIKey <String>] [<CommonParameters>]
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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
The currency to convert to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIKey
Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
