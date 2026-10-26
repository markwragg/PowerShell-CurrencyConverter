function Get-CurrencyDefault {
    <#
    .SYNOPSIS
        Gets the default preferences saved by Set-CurrencyDefault.

    .DESCRIPTION
        The Get-CurrencyDefault cmdlet returns the default preferences currently saved by
        Set-CurrencyDefault, such as the default -From/-To currency or -APIKey. Preferences that
        haven't been saved are omitted -- each cmdlet that honours a preference falls back to its own
        built-in behavior when one isn't saved here.

    .EXAMPLE
        Get-CurrencyDefault

        Description
        -----------
        Returns the currently saved default preferences.

    .LINK
        https://github.com/markwragg/PowerShell-CurrencyConverter/wiki/Get-CurrencyDefault
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        # Path to the file used to store default preferences. By default this is in the user's per-user
        # data directory (~/.currencyconverter).
        [string]
        $DefaultsPath = (Get-CurrencyDefaultsPath)
    )

    if (Test-Path $DefaultsPath) {
        Get-Content $DefaultsPath | ConvertFrom-Json
    }
    else {
        [pscustomobject]@{}
    }
}
