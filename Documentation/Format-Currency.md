# Format-Currency

## SYNOPSIS
Formats a value as a string with the currency symbol for a specified country.

## SYNTAX

```
Format-Currency [-Value] <Decimal> [-Currency] <String> [[-Decimals] <Int32>] [[-ConvertTo] <String>]
 [-SymbolAtEnd] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Outputs a value with the specified currency symbol.
Can also be used to perform a currency conversion and then format as the converted currency.

## EXAMPLES

### EXAMPLE 1
```
100 | Format-Currency -Currency USD
```

Description
-----------
Formats the value (provided via the pipeline) as USD: $100.00.

### EXAMPLE 2
```
Convert-Currency -Value 100 -From USD -To EUR | Format-Currency
```

Description
-----------
Converts 100 USD to EUR and formats the result as EUR, with the Currency parameter inferred from the pipeline, e.g.: €92.15

### EXAMPLE 3
```
100 | Format-Currency -Currency USD -ConvertTo GBP
```

Description
-----------
Converts 100 from USD to GBP and formats as GBP, e.g.: £79.67

### EXAMPLE 4
```
Format-Currency -Value 100 -Currency USD
```

Description
-----------
Formats the value as USD: $100.00.

### EXAMPLE 5
```
Format-Currency -Value 100.2345 -Currency USD -Decimals 3
```

Description
-----------
Formats the value as USD: $100.235.

### EXAMPLE 6
```
Format-Currency -Value 100 -Currency USD -SymbolAtEnd
```

Description
-----------
Formats the value as USD: 100.00$.

## PARAMETERS

### -Value
The currency value.

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

### -Currency
The currency represented by value.
If not specified, this can be picked up from the pipeline by property name, e.g.
from the output of Convert-Currency or Convert-CryptoCurrency.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Decimals
The number of decimal places to round the value to.
Default: 2

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConvertTo
Perform a currency conversion and then format as that currency.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SymbolAtEnd
Place the currency symbol after the value.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### A numerical value, can be provided via the pipeline. If piped from Convert-Currency or Convert-CryptoCurrency, the Currency parameter is automatically populated from the destination currency of that conversion.
## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
