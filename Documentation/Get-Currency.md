# Get-Currency

## SYNOPSIS
Returns the list of supported currency codes along with their currency name and country code.

## SYNTAX

### Code (Default)
```
Get-Currency [[-Currency] <String>] [<CommonParameters>]
```

### Name
```
Get-Currency [-Name <String>] [<CommonParameters>]
```

### Country
```
Get-Currency [-Country <String>] [<CommonParameters>]
```

## DESCRIPTION
Use to list the countries and currencies that are supported by this module, and the Exchange Rate API.

## EXAMPLES

### EXAMPLE 1
```
Get-Currency
```

Description
-----------
Returns the list of all supported currency codes, along with their name and country.

### EXAMPLE 2
```
Get-Currency -Currency GBP
```

Description
-----------
Returns the code, name and country for GBP.

### EXAMPLE 3
```
'GBP','USD' | Get-Currency
```

Description
-----------
Returns the code, name and country details for GBP and USD.

### EXAMPLE 4
```
Get-Currency -Country 'United Kingdom'
```

Description
-----------
Returns the code, name and country for the United Kingdom.

### EXAMPLE 5
```
Get-Currency -Name 'Dollar'
```

Description
-----------
Returns all currencies that include the word 'Dollar'

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

### -Country
The country to return.

```yaml
Type: String
Parameter Sets: Country
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
