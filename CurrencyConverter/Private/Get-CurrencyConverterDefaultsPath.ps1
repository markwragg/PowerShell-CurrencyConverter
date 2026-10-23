function Get-CurrencyConverterDefaultsPath {
    <#
    .SYNOPSIS
        Returns the path to the file used to store default preferences (set via Set-CurrencyConverterDefault),
        creating its directory if it doesn't already exist.
    #>
    [CmdletBinding()]
    param()

    $Directory = Join-Path $HOME '.currencyconverter'

    if (-not (Test-Path $Directory)) {
        New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    }

    Join-Path $Directory 'CurrencyConverter.defaults.json'
}
