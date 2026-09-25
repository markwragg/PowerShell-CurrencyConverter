# Get-CryptoCurrency

## SYNOPSIS
Returns the list of supported crypto currency codes along with their currency name.

## SYNTAX

### Code (Default)
```
Get-CryptoCurrency [[-Currency] <String>] [<CommonParameters>]
```

### Name
```
Get-CryptoCurrency [-Name <String>] [<CommonParameters>]
```

## DESCRIPTION
Use to list the crypto currencies that are supported by this module, and the CoinBaser API.

## EXAMPLES

### EXAMPLE 1
```
Get-CryptoCurrency
```

Description
-----------
Returns the list of all supported currency codes, along with their name and type.

### EXAMPLE 2
```
Get-CryptoCurrency -Currency BTC
```

Description
-----------
Returns the code and name for BTC.

### EXAMPLE 3
```
'BTC','ETH' | Get-CryptoCurrency
```

Description
-----------
Returns the code and name details for BTC and ETH.

### EXAMPLE 4
```
Get-CryptoCurrency -Name 'Bitcoin'
```

Description
-----------
Returns all currencies that include the word 'Bitcoin'

## PARAMETERS

### -Currency
The currency to return.
Alias: Code.

```yaml
Type: String
Parameter Sets: Code
Aliases: Code

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The currency name to return.

```yaml
Type: String
Parameter Sets: Name
Aliases:

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

### Currency codes can be provided via the pipeline.
## OUTPUTS

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
