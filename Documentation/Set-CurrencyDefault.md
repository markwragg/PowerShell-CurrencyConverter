# Set-CurrencyDefault

## SYNOPSIS
Sets default preferences used automatically by other cmdlets in this module, such as the currency
to convert From, To, and your APIKey.

## SYNTAX

```
Set-CurrencyDefault [[-From] <String>] [[-To] <String>] [[-APIKey] <String>] [-Reset]
 [[-DefaultsPath] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-CurrencyDefault cmdlet saves default preferences that are then used automatically by
other cmdlets in this module, so you don't need to specify the same parameters every time.
Explicitly
specifying a parameter on a cmdlet (e.g.
Convert-Currency -From EUR) always overrides the saved default.

Only the preferences you specify are changed -- any others already saved are left as they are.
Use
-Reset to remove all saved preferences and restore the module's built-in behavior.

Supported preferences:

-From    Default for -From on Convert-Currency and Convert-CryptoCurrency, and -Currency (alias -From)
         on Get-ExchangeRate and Get-CryptoExchangeRate.
-To      Default for -To on Convert-Currency, Convert-CryptoCurrency, Get-ExchangeRate and
         Get-CryptoExchangeRate.
-APIKey  Default for -APIKey on Convert-Currency and Get-ExchangeRate.

## EXAMPLES

### EXAMPLE 1
```
Set-CurrencyDefault -From USD -To GBP
```

Description
-----------
Makes Convert-Currency, Convert-CryptoCurrency, Get-ExchangeRate and Get-CryptoExchangeRate use USD
and GBP by default, so they can be called without specifying -From/-To.

### EXAMPLE 2
```
Set-CurrencyDefault -APIKey 12345abcdef
```

Description
-----------
Makes Convert-Currency and Get-ExchangeRate use the specified API key by default.

### EXAMPLE 3
```
Set-CurrencyDefault -Reset
```

Description
-----------
Removes all saved default preferences.

## PARAMETERS

### -From
Sets the default for -From on Convert-Currency and Convert-CryptoCurrency, and -Currency (alias
-From) on Get-ExchangeRate and Get-CryptoExchangeRate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
Sets the default for -To on Convert-Currency, Convert-CryptoCurrency, Get-ExchangeRate and
Get-CryptoExchangeRate.

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

### -APIKey
Sets the default for -APIKey on Convert-Currency and Get-ExchangeRate.

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

### -Reset
Removes all saved default preferences, restoring the module's built-in behavior.

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

### -DefaultsPath
Path to the file used to store default preferences.
By default this is in the user's per-user
data directory (~/.currencyconverter).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Get-CurrencyDefaultsPath)
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS

[https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Set-CurrencyDefault](https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Set-CurrencyDefault)

