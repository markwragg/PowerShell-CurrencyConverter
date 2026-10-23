function Get-CurrencyConverterDefault {
    <#
    .SYNOPSIS
        Gets the default preferences saved by Set-CurrencyConverterDefault.

    .DESCRIPTION
        The Get-CurrencyConverterDefault cmdlet returns the default preferences currently saved by
        Set-CurrencyConverterDefault, such as the default -From/-To currency or -APIKey. Preferences that
        haven't been saved are omitted -- each cmdlet that honours a preference falls back to its own
        built-in behavior when one isn't saved here.

    .EXAMPLE
        Get-CurrencyConverterDefault

        Description
        -----------
        Returns the currently saved default preferences.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        # Path to the file used to store default preferences. By default this is in the user's per-user
        # data directory (~/.currencyconverter).
        [string]
        $DefaultsPath = (Get-CurrencyConverterDefaultsPath)
    )

    if (Test-Path $DefaultsPath) {
        Get-Content $DefaultsPath | ConvertFrom-Json
    }
    else {
        [pscustomobject]@{}
    }
}
