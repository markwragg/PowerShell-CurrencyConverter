function Set-CurrencyDefault {
    <#
    .SYNOPSIS
        Sets default preferences used automatically by other cmdlets in this module, such as the currency
        to convert From, To, and your APIKey.

    .DESCRIPTION
        The Set-CurrencyDefault cmdlet saves default preferences that are then used automatically by
        other cmdlets in this module, so you don't need to specify the same parameters every time. Explicitly
        specifying a parameter on a cmdlet (e.g. Convert-Currency -From EUR) always overrides the saved default.

        Only the preferences you specify are changed -- any others already saved are left as they are. Use
        -Reset to remove all saved preferences and restore the module's built-in behavior.

        Supported preferences:

        -From    Default for -From on Convert-Currency and Convert-CryptoCurrency, and -Currency (alias -From)
                 on Get-ExchangeRate and Get-CryptoExchangeRate.
        -To      Default for -To on Convert-Currency, Convert-CryptoCurrency, Get-ExchangeRate and
                 Get-CryptoExchangeRate.
        -APIKey  Default for -APIKey on Convert-Currency and Get-ExchangeRate.

    .EXAMPLE
        Set-CurrencyDefault -From USD -To GBP

        Description
        -----------
        Makes Convert-Currency, Convert-CryptoCurrency, Get-ExchangeRate and Get-CryptoExchangeRate use USD
        and GBP by default, so they can be called without specifying -From/-To.

    .EXAMPLE
        Set-CurrencyDefault -APIKey 12345abcdef

        Description
        -----------
        Makes Convert-Currency and Get-ExchangeRate use the specified API key by default.

    .EXAMPLE
        Set-CurrencyDefault -Reset

        Description
        -----------
        Removes all saved default preferences.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([pscustomobject])]
    param(
        # Sets the default for -From on Convert-Currency and Convert-CryptoCurrency, and -Currency (alias
        # -From) on Get-ExchangeRate and Get-CryptoExchangeRate.
        [string]
        $From,

        # Sets the default for -To on Convert-Currency, Convert-CryptoCurrency, Get-ExchangeRate and
        # Get-CryptoExchangeRate.
        [string]
        $To,

        # Sets the default for -APIKey on Convert-Currency and Get-ExchangeRate.
        [string]
        $APIKey,

        # Removes all saved default preferences, restoring the module's built-in behavior.
        [switch]
        $Reset,

        # Path to the file used to store default preferences. By default this is in the user's per-user
        # data directory (~/.currencyconverter).
        [string]
        $DefaultsPath = (Get-CurrencyDefaultsPath)
    )

    if ($Reset) {
        if ((Test-Path $DefaultsPath) -and $PSCmdlet.ShouldProcess($DefaultsPath, 'Remove all saved default preferences')) {
            Remove-Item $DefaultsPath -Force
        }
        return [pscustomobject]@{}
    }

    $Current = Get-CurrencyDefault -DefaultsPath $DefaultsPath

    if ($PSBoundParameters.ContainsKey('From')) { $Current | Add-Member -NotePropertyName From -NotePropertyValue $From -Force }
    if ($PSBoundParameters.ContainsKey('To')) { $Current | Add-Member -NotePropertyName To -NotePropertyValue $To -Force }
    if ($PSBoundParameters.ContainsKey('APIKey')) { $Current | Add-Member -NotePropertyName APIKey -NotePropertyValue $APIKey -Force }

    $AnyPreferenceSpecified = 'From', 'To', 'APIKey' | Where-Object { $PSBoundParameters.ContainsKey($_) }

    if ($AnyPreferenceSpecified -and $PSCmdlet.ShouldProcess($DefaultsPath, 'Save default preferences')) {
        $Current | ConvertTo-Json | Out-File $DefaultsPath -Force
    }

    $Current
}
