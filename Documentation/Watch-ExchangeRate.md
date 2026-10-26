# Watch-ExchangeRate

## SYNOPSIS
Polls the exchange rate between two currencies on an interval, until it crosses a specified threshold.

## SYNTAX

```
Watch-ExchangeRate [[-From] <String>] [[-To] <String>] [-AboveThreshold <Decimal>] [-BelowThreshold <Decimal>]
 [-IntervalSeconds <Int32>] [-MaxIterations <Int32>] [-APIKey <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Repeatedly calls Get-ExchangeRate (or Get-CryptoExchangeRate, if -From or -To is a crypto currency)
on the interval specified by -IntervalSeconds, writing a result to the pipeline for each poll.
If
-AboveThreshold or -BelowThreshold is specified, polling stops as soon as the rate crosses that
threshold (the result for that poll has its Triggered property set to $true).
If neither is
specified, polling continues until -MaxIterations is reached, or indefinitely if -MaxIterations
isn't specified (use Ctrl+C to stop).

## EXAMPLES

### EXAMPLE 1
```
Watch-ExchangeRate -From USD -To GBP -AboveThreshold 0.80 -IntervalSeconds 300
```

Description
-----------
Polls the USD to GBP exchange rate every 5 minutes until it rises to 0.80 or above.

### EXAMPLE 2
```
Watch-ExchangeRate -From USD -To GBP -MaxIterations 5
```

Description
-----------
Polls the USD to GBP exchange rate every 60 seconds, 5 times, regardless of its value.

### EXAMPLE 3
```
Set-CurrencyDefault -From USD -To GBP
Watch-ExchangeRate -BelowThreshold 0.75
```

Description
-----------
Uses the saved default -From/-To currencies to poll the exchange rate every 60 seconds until it
falls to 0.75 or below.

### EXAMPLE 4
```
Watch-ExchangeRate -From BTC -To USD -AboveThreshold 100000 -IntervalSeconds 30
```

Description
-----------
Polls the BTC to USD exchange rate every 30 seconds, via Get-CryptoExchangeRate, until it rises to 100000 or above.

## PARAMETERS

### -From
The currency to convert from.
(Alias: Currency) Defaults to the value saved with
Set-CurrencyDefault -From, if any.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Currency

Required: False
Position: 1
Default value: (Get-CurrencyDefaultValue -Name 'From')
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
The currency to convert to.
Defaults to the value saved with Set-CurrencyDefault -To, if any.
If -From or -To is a crypto currency, the rate is polled via Get-CryptoExchangeRate instead of
Get-ExchangeRate (in which case -APIKey is not used).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-CurrencyDefaultValue -Name 'To')
Accept pipeline input: False
Accept wildcard characters: False
```

### -AboveThreshold
Optional: Stop polling once the exchange rate is greater than or equal to this value.

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BelowThreshold
Optional: Stop polling once the exchange rate is less than or equal to this value.

```yaml
Type: Decimal
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntervalSeconds
How many seconds to wait between each poll.
Defaults to 60.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 60
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxIterations
Optional: The maximum number of times to poll the exchange rate before stopping.
If not specified,
polling continues indefinitely (or until a specified threshold is crossed).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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

## OUTPUTS

### One object per poll, with From, To, Rate, Timestamp and Triggered properties.
## NOTES

## RELATED LINKS

[https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Watch-ExchangeRate](https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Watch-ExchangeRate)

