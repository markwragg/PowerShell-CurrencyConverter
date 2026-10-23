function Get-CurrencyDefaultValue {
    <#
    .SYNOPSIS
        Returns the saved default for the named preference (set via Set-CurrencyDefault), or the
        given fallback value if no default has been saved for it.
    #>
    [CmdletBinding()]
    param(
        # The name of the preference to look up, e.g. 'From', 'To' or 'APIKey'.
        [Parameter(Mandatory)]
        [string]
        $Name,

        # The value to use if no default has been saved for this preference.
        $Value
    )

    $Stored = (Get-CurrencyDefault).$Name

    if ($null -ne $Stored) { $Stored } else { $Value }
}
