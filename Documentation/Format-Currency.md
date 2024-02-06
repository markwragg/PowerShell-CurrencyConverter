# Format-Currency

## SYNOPSIS
Formats a value with the currency symbol for a specified country.

## SYNTAX

```
Format-Currency [-Value] <Decimal> [-Currency] <String> [[-ConvertToCurrency] <String>] [<CommonParameters>]
```

## DESCRIPTION
Outputs a value with the specified currency symbol.
Can also be used to perform a currency conversion and then format as the destination currency.

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
100 | Format-Currency -Currency USD -ConvertToCurrency GBP
```

Description
-----------
Converts 100 from USD to GBP and formats as GBP, e.g.: £79.67

### EXAMPLE 3
```
Format-Currency -Value 100 -Currency USD
```

Description
-----------
Formats the value as USD: $100.00.

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
The currency to format the value as.

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

### -ConvertToCurrency
Perform a currency conversion and then format as that currency.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
