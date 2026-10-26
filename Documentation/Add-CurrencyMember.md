# Add-CurrencyMember

## SYNOPSIS
Adds a new member to an object that is a currency conversion of one of its existing properties.

## SYNTAX

```
Add-CurrencyMember -InputObject <PSObject> [-Property] <String> [[-MemberName] <String>] [-From <String>]
 [-To <String>] [-APIKey <String>] [-Date <DateTime>] [-PassThru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Converts the value of an existing property on a PowerShell object to another currency, and adds the
result as a new property on that same object via Add-Member.
Uses Convert-Currency or
Convert-CryptoCurrency to perform the conversion, depending on whether -From/-To are crypto currencies.
As with Add-Member, the updated object is only returned to the pipeline if -PassThru is specified.

## EXAMPLES

### EXAMPLE 1
```
[pscustomobject]@{ Product = 'Widget'; Price = 100 } | Add-CurrencyMember -Property Price -From USD -To GBP -PassThru
```

Description
-----------
Adds a PriceGBP property to the object, with the Price property converted from USD to GBP, and returns the updated object.

### EXAMPLE 2
```
$Orders | Add-CurrencyMember -Property Total -MemberName TotalEUR -From USD -To EUR
```

Description
-----------
Adds a TotalEUR property to each object in $Orders, with the Total property converted from USD to EUR.

### EXAMPLE 3
```
Set-CurrencyDefault -From USD -To GBP
[pscustomobject]@{ Price = 100 } | Add-CurrencyMember -Property Price -PassThru
```

Description
-----------
Uses the saved default -From/-To currencies to add a PriceGBP property, and returns the updated object.

### EXAMPLE 4
```
[pscustomobject]@{ Price = 1 } | Add-CurrencyMember -Property Price -From BTC -To GBP -PassThru
```

Description
-----------
Adds a PriceGBP property, with the Price property converted from BTC to GBP via Convert-CryptoCurrency, and returns the updated object.

### EXAMPLE 5
```
[pscustomobject]@{ Price = 100 } | Add-CurrencyMember -Property Price -From USD -To GBP -Date '2024-01-15' -ApiKey yourapikeystringhere -PassThru
```

Description
-----------
Adds a PriceGBP property, with the Price property converted from USD to GBP using the exchange rate as it was on 15th January 2024, and returns the updated object.

## PARAMETERS

### -InputObject
The object to add the new member to.
Can be provided via the pipeline.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property
The name of the existing property on InputObject whose value should be converted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberName
The name of the new property to add to InputObject, containing the converted value.
Defaults to
"\<Property\>\<To\>", e.g.
a -Property of 'Price' and -To of 'GBP' would add a 'PriceGBP' property.

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

### -APIKey
Optional: To use the v6 API, provide your API key, as provided by https://www.exchangerate-api.com/
Defaults to the value saved with Set-CurrencyDefault -APIKey, if any.
Not used when converting
to/from a crypto currency.

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

### -Date
Optional: Converts using the historical exchange rates for the specified date, instead of the
latest rates.
This requires an -APIKey, as historical data is only available via the registered
v6 API.
Not supported when converting to/from a crypto currency.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns the updated object to the pipeline.
By default, this cmdlet does not generate any output.

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

### A PowerShell object, can be provided via the pipeline.
## OUTPUTS

### If -PassThru is specified, the input object, with the new member added.
## NOTES

## RELATED LINKS

[https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Add-CurrencyMember](https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Add-CurrencyMember)

