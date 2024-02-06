# ConvertTo-Currency

## SYNOPSIS
Converts a decimal value between specified currencies

## SYNTAX

```
ConvertTo-Currency [-Value] <Decimal> [-SourceCurrency] <String> [-DestinationCurrency] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Uses the Open Exchange Rate API (https://www.exchangerate-api.com/docs/free) to perform currency conversions.
Caches the conversion rates for the specified currency (valid for 24 hours).

## EXAMPLES

### EXAMPLE 1
```
100 | ConvertTo-Currency -SourceCurrency USD -DestinationCurrency GBP
```

Description
-----------
Converts the value 100 (provided via the pipeline) from USD (US Dollar) to GBP (British Pound), example result: 79.674700

### EXAMPLE 2
```
ConvertTo-Currency -Value 100 -SourceCurrency AUD -DestinationCurrency EUR
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

### -SourceCurrency
The currency to convert from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationCurrency
The currency to convert to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
