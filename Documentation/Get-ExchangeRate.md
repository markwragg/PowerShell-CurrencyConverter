# Get-ExchangeRate

## SYNOPSIS
Returns all exchange rates for a specified currency, or a specified exchange rate between two currencies.

## SYNTAX

```
Get-ExchangeRate [-Currency] <String> [[-To] <String>] [<CommonParameters>]
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
Get-ExchangeRate -From USD -To GBP
```

Description
-----------
Returns the exchange rate from US Dollar to British Pound, example result: 0.792011

## PARAMETERS

### -Currency
The currency to return exchange rates for.
(Alias: From)

```yaml
Type: String
Parameter Sets: (All)
Aliases: From

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
The currency to return the exchange rate to (from the currency specified as -Currency or -From).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
