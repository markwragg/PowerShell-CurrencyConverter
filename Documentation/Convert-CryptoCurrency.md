# Convert-CryptoCurrency

## SYNOPSIS
Converts a decimal value between specified crypto and/or non-crypto currencies

## SYNTAX

```
Convert-CryptoCurrency [-Value] <Decimal> [-From <String>] [-To <String>] [-CacheSeconds <Object>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### EXAMPLE 3
```
Convert-CryptoCurrency -Value 1 -From BTC -To ETH | Format-Currency
```

Description
-----------
Converts 1 BTC to ETH and pipes the result to Format-Currency, which picks up the destination currency (ETH) from the pipeline, example result: Ξ21.4961307

### EXAMPLE 4
```
Set-CurrencyDefault -From BTC -To ETH
Convert-CryptoCurrency -Value 1
```

Description
-----------
Saves BTC/ETH as the default currencies to convert between, then converts 1 BTC to ETH without needing to specify -From/-To.

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

[https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Convert-CryptoCurrency](https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Convert-CryptoCurrency)

