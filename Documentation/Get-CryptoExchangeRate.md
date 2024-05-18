# Get-CryptoExchangeRate

## SYNOPSIS
Returns all crypto exchange rates for a specified currency, or a specified exchange rate between two currencies.

## SYNTAX

### ToRate (Default)
```
Get-CryptoExchangeRate [-Currency] <String> [-To <String>] [-CacheSeconds <Object>] [<CommonParameters>]
```

### Rates
```
Get-CryptoExchangeRate [-Currency] <String> [-Rates] [-CacheSeconds <Object>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Coin Base API (https://api.coinbase.com/v2/exchange-rates) to perform currency conversions.
Caches the conversion rates for the specified currency for a number of seconds if -CacheSeconds is specified.

## EXAMPLES

### EXAMPLE 1
```
Get-CryptoExchangeRate -Currency BTC
```

Description
-----------
Returns the exchange rates for Bitcoin as a PowerShell object.

### EXAMPLE 2
```
Get-CryptoExchangeRate -Currency BTC -Rates
```

Description
-----------
Returns all exchange rates for Bitcoin.

### EXAMPLE 3
```
Get-CryptoExchangeRate -From USD -To BTC
```

Description
-----------
Returns the exchange rate from US Dollar to Bitcoin, example result: 0.0000149456903504

### EXAMPLE 4
```
'BTC','ETH' | Get-CryptoExchangeRate
```

Description
-----------
Returns the exchange rates for Bitcoin and Ether as PowerShell objects.

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
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -To
The currency to return the exchange rate to (from the currency specified as -Currency or -From).

```yaml
Type: String
Parameter Sets: ToRate
Aliases:

Required: False
Position: Named
Default value: None
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

### Currency codes can be provided via the pipeline.
## OUTPUTS

### System.Management.Automation.PSObject
### System.Management.Automation.PSObject
### System.Double
## NOTES

## RELATED LINKS
