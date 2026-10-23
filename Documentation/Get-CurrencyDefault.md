# Get-CurrencyDefault

## SYNOPSIS
Gets the default preferences saved by Set-CurrencyDefault.

## SYNTAX

```
Get-CurrencyDefault [[-DefaultsPath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-CurrencyDefault cmdlet returns the default preferences currently saved by
Set-CurrencyDefault, such as the default -From/-To currency or -APIKey.
Preferences that
haven't been saved are omitted -- each cmdlet that honours a preference falls back to its own
built-in behavior when one isn't saved here.

## EXAMPLES

### EXAMPLE 1
```
Get-CurrencyDefault
```

Description
-----------
Returns the currently saved default preferences.

## PARAMETERS

### -DefaultsPath
Path to the file used to store default preferences.
By default this is in the user's per-user
data directory (~/.currencyconverter).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-CurrencyDefaultsPath)
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
