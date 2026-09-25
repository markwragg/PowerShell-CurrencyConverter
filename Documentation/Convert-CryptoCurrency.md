# Convert-CryptoCurrency

## SYNOPSIS
Converts a decimal value between specified crypto and/or non-crypto currencies

## SYNTAX

```
Convert-CryptoCurrency [-Value] <Decimal> -From <String> -To <String> [-CacheSeconds <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Uses the Coin Base API (https://api.coinbase.com/v2/exchange-rates) to perform currency conversions.
Caches the conversion rates for the specified currency for a number of seconds if -CacheSeconds is specified.

## EXAMPLES

### EXAMPLE 1
```
100 | Convert-CryptoCurrency -From BTC -To ETH
```

Description
-----------
Converts the value 100 (provided via the pipeline) from BTC (Bitcount) to ETH (Ether), example result: 2149.6130696474600

### EXAMPLE 2
```
Convert-CryptoCurrency -Value 100 -From ETH -To GBP
```

Description
-----------
Converts the value 100 from ETH (Ether) to GBP (British Pound), example result: 245122.500

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

### -CacheSeconds
Number of seconds to cache the result.
Default: 0.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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
