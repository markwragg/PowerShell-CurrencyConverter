function Get-CryptoExchangeRate {
    <#
    .SYNOPSIS
        Returns all crypto exchange rates for a specified currency, or a specified exchange rate between two currencies.

    .DESCRIPTION
        Uses the Coin Base API (https://api.coinbase.com/v2/exchange-rates) to perform currency conversions.
        Caches the conversion rates for the specified currency for a number of seconds if -CacheSeconds is specified.

    .PARAMETER Currency
        The currency to return exchange rates for. (Alias: From)

    .PARAMETER To
        The currency to return the exchange rate to (from the currency specified as -Currency or -From).

    .PARAMETER Rates
        Switch: Use to return just the exchange rates for a specified currency.

    .PARAMETER CacheSeconds
        Number of seconds to cache the result. Default: 0.

    .INPUTS
        Currency codes can be provided via the pipeline.

    .EXAMPLE
        Get-CryptoExchangeRate -Currency BTC

        Description
        -----------
        Returns the exchange rates for Bitcoin as a PowerShell object.

    .EXAMPLE
        Get-CryptoExchangeRate -Currency BTC -Rates

        Description
        -----------
        Returns all exchange rates for Bitcoin.
    
    .EXAMPLE
        Get-CryptoExchangeRate -From USD -To BTC

        Description
        -----------
        Returns the exchange rate from US Dollar to Bitcoin, example result: 0.0000149456903504

    .EXAMPLE
        'BTC','ETH' | Get-CryptoExchangeRate

        Description
        -----------
        Returns the exchange rates for Bitcoin and Ether as PowerShell objects.

    #>
    [CmdletBinding(DefaultParameterSetName = 'ToRate')]
    [OutputType([pscustomobject])]
    [OutputType([pscustomobject], ParameterSetName = ('Rates'))]
    [OutputType([double], ParameterSetName = ('ToRate'))]
    param(
        [validateset('00', '1INCH', 'AAVE', 'ABT', 'ACH', 'ACS', 'ADA', 'AERGO', 'AERO', 'AGLD', 'AIOZ', 'AKT', 'ALCX', 'ALEPH', 'ALGO', 'ALICE', 'AMP', 'ANKR', 'ANT', 'APE', 'API3', 'APT', 'ARB', 'ARKM', 'ARPA', 'ASM', 'AST', 'ATA', 'ATOM', 'AUCTION', 'AUDIO', 'AURORA', 'AVAX', 'AVT', 'AXL', 'AXS', 'BADGER', 'BAL', 'BAND', 'BAT', 'BCH', 'BICO', 'BIGTIME', 'BIT', 'BLUR', 'BLZ', 'BNT', 'BOBA', 'BOND', 'BONK', 'BTC', 'BTRST', 'BUSD', 'C98', 'CBETH', 'CELR', 'CGLD', 'CHZ', 'CLV', 'COMP', 'COTI', 'COVAL', 'CRO', 'CRPT', 'CRV', 'CTSI', 'CTX', 'CVC', 'CVX', 'DAI', 'DAR', 'DASH', 'DDX', 'DESO', 'DEXT', 'DIA', 'DIMO', 'DNT', 'DOGE', 'DOT', 'DREP', 'DRIFT', 'DYP', 'EGLD', 'ELA', 'ENJ', 'ENS', 'EOS', 'ERN', 'ETC', 'ETH', 'EUR', 'EUROC', 'FARM', 'FET', 'FIDA', 'FIL', 'FIS', 'FLOW', 'FLR', 'FORT', 'FORTH', 'FOX', 'FX', 'GAL', 'GALA', 'GBP', 'GFI', 'GHST', 'GLM', 'GMT', 'GNO', 'GNT', 'GODS', 'GRT', 'GST', 'GTC', 'GUSD', 'GYEN', 'HBAR', 'HFT', 'HIGH', 'HNT', 'HONEY', 'HOPR', 'ICP', 'IDEX', 'ILV', 'IMX', 'INDEX', 'INJ', 'INV', 'IOTX', 'JASMY', 'JTO', 'JUP', 'KARRAT', 'KAVA', 'KEEP', 'KNC', 'KRL', 'KSM', 'LCX', 'LDO', 'LINK', 'LIT', 'LOKA', 'LOOM', 'LPT', 'LQTY', 'LRC', 'LSETH', 'LTC', 'MAGIC', 'MANA', 'MASK', 'MATH', 'MATIC', 'MCO2', 'MDT', 'MEDIA', 'METIS', 'MINA', 'MIR', 'MKR', 'MLN', 'MNDE', 'MOBILE', 'MONA', 'MPL', 'MSOL', 'MTL', 'MULTI', 'MUSD', 'MUSE', 'MXC', 'NCT', 'NEAR', 'NEON', 'NEST', 'NKN', 'NMR', 'NU', 'OCEAN', 'OGN', 'OMG', 'OMNI', 'ONDO', 'OOKI', 'OP', 'ORCA', 'ORN', 'OSMO', 'OXT', 'PAX', 'PERP', 'PLA', 'PLU', 'PNG', 'POLS', 'POLY', 'POND', 'POWR', 'PRIME', 'PRO', 'PRQ', 'PUNDIX', 'PYR', 'PYUSD', 'QI', 'QNT', 'QSP', 'QUICK', 'RAD', 'RAI', 'RARE', 'RARI', 'RBN', 'REN', 'RENDER', 'REP', 'REQ', 'RGT', 'RLC', 'RLY', 'RNDR', 'RONIN', 'ROSE', 'RPL', 'SAFE', 'SAND', 'SEAM', 'SEI', 'SHDW', 'SHIB', 'SHPING', 'SKL', 'SNT', 'SNX', 'SOL', 'SPA', 'SPELL', 'STG', 'STORJ', 'STRK', 'STX', 'SUI', 'SUKU', 'SUPER', 'SUSHI', 'SWFTC', 'SYLO', 'SYN', 'T', 'TBTC', 'TIA', 'TIME', 'TNSR', 'TONE', 'TRAC', 'TRB', 'TRIBE', 'TRU', 'TVK', 'UMA', 'UNFI', 'UNI', 'UPI', 'USD', 'USDC', 'USDT', 'UST', 'VARA', 'VELO', 'VET', 'VGX', 'VOXEL', 'VTHO', 'WAMPL', 'WAXL', 'WBTC', 'WCFG', 'WLUNA', 'XCN', 'XLM', 'XMON', 'XRP', 'XTZ', 'XYO', 'YFI', 'YFII', 'ZEC', 'ZEN', 'ZETA', 'ZRX')]
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory)]
        [alias('From')]
        [string]
        $Currency,

        [validateset('00', '1INCH', 'AAVE', 'ABT', 'ACH', 'ACS', 'ADA', 'AERGO', 'AERO', 'AGLD', 'AIOZ', 'AKT', 'ALCX', 'ALEPH', 'ALGO', 'ALICE', 'AMP', 'ANKR', 'ANT', 'APE', 'API3', 'APT', 'ARB', 'ARKM', 'ARPA', 'ASM', 'AST', 'ATA', 'ATOM', 'AUCTION', 'AUDIO', 'AURORA', 'AVAX', 'AVT', 'AXL', 'AXS', 'BADGER', 'BAL', 'BAND', 'BAT', 'BCH', 'BICO', 'BIGTIME', 'BIT', 'BLUR', 'BLZ', 'BNT', 'BOBA', 'BOND', 'BONK', 'BTC', 'BTRST', 'BUSD', 'C98', 'CBETH', 'CELR', 'CGLD', 'CHZ', 'CLV', 'COMP', 'COTI', 'COVAL', 'CRO', 'CRPT', 'CRV', 'CTSI', 'CTX', 'CVC', 'CVX', 'DAI', 'DAR', 'DASH', 'DDX', 'DESO', 'DEXT', 'DIA', 'DIMO', 'DNT', 'DOGE', 'DOT', 'DREP', 'DRIFT', 'DYP', 'EGLD', 'ELA', 'ENJ', 'ENS', 'EOS', 'ERN', 'ETC', 'ETH', 'EUR', 'EUROC', 'FARM', 'FET', 'FIDA', 'FIL', 'FIS', 'FLOW', 'FLR', 'FORT', 'FORTH', 'FOX', 'FX', 'GAL', 'GALA', 'GBP', 'GFI', 'GHST', 'GLM', 'GMT', 'GNO', 'GNT', 'GODS', 'GRT', 'GST', 'GTC', 'GUSD', 'GYEN', 'HBAR', 'HFT', 'HIGH', 'HNT', 'HONEY', 'HOPR', 'ICP', 'IDEX', 'ILV', 'IMX', 'INDEX', 'INJ', 'INV', 'IOTX', 'JASMY', 'JTO', 'JUP', 'KARRAT', 'KAVA', 'KEEP', 'KNC', 'KRL', 'KSM', 'LCX', 'LDO', 'LINK', 'LIT', 'LOKA', 'LOOM', 'LPT', 'LQTY', 'LRC', 'LSETH', 'LTC', 'MAGIC', 'MANA', 'MASK', 'MATH', 'MATIC', 'MCO2', 'MDT', 'MEDIA', 'METIS', 'MINA', 'MIR', 'MKR', 'MLN', 'MNDE', 'MOBILE', 'MONA', 'MPL', 'MSOL', 'MTL', 'MULTI', 'MUSD', 'MUSE', 'MXC', 'NCT', 'NEAR', 'NEON', 'NEST', 'NKN', 'NMR', 'NU', 'OCEAN', 'OGN', 'OMG', 'OMNI', 'ONDO', 'OOKI', 'OP', 'ORCA', 'ORN', 'OSMO', 'OXT', 'PAX', 'PERP', 'PLA', 'PLU', 'PNG', 'POLS', 'POLY', 'POND', 'POWR', 'PRIME', 'PRO', 'PRQ', 'PUNDIX', 'PYR', 'PYUSD', 'QI', 'QNT', 'QSP', 'QUICK', 'RAD', 'RAI', 'RARE', 'RARI', 'RBN', 'REN', 'RENDER', 'REP', 'REQ', 'RGT', 'RLC', 'RLY', 'RNDR', 'RONIN', 'ROSE', 'RPL', 'SAFE', 'SAND', 'SEAM', 'SEI', 'SHDW', 'SHIB', 'SHPING', 'SKL', 'SNT', 'SNX', 'SOL', 'SPA', 'SPELL', 'STG', 'STORJ', 'STRK', 'STX', 'SUI', 'SUKU', 'SUPER', 'SUSHI', 'SWFTC', 'SYLO', 'SYN', 'T', 'TBTC', 'TIA', 'TIME', 'TNSR', 'TONE', 'TRAC', 'TRB', 'TRIBE', 'TRU', 'TVK', 'UMA', 'UNFI', 'UNI', 'UPI', 'USD', 'USDC', 'USDT', 'UST', 'VARA', 'VELO', 'VET', 'VGX', 'VOXEL', 'VTHO', 'WAMPL', 'WAXL', 'WBTC', 'WCFG', 'WLUNA', 'XCN', 'XLM', 'XMON', 'XRP', 'XTZ', 'XYO', 'YFI', 'YFII', 'ZEC', 'ZEN', 'ZETA', 'ZRX')]
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ToRate')]
        [string]
        $To,

        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Rates')]
        [switch]
        $Rates,

        [validaterange(0, [int]::MaxValue)]
        $CacheSeconds = 0
    )
    process {
        $Cached = Join-Path $PSScriptRoot "Crypto-${Currency}.json"
        $APIUrl = "https://api.coinbase.com/v2/exchange-rates?currency=${Currency}"
        $RateStr = 'rates'
    
        $isCached = Test-Path $Cached

        if ($isCached) {
            $ExchangeRates = Get-Content $Cached | ConvertFrom-Json
        }

        if (-not $isCached -or ((Get-Date) -gt ($ExchangeRates.Expires | Get-Date))) {
            try {
                $ExchangeRates = (Invoke-RestMethod $APIUrl -ErrorAction Stop).data

                if ($CacheSeconds -gt 0) {
                    $ExchangeRates | Add-Member -MemberType NoteProperty -Name Expires -Value (Get-Date).AddSeconds($CacheSeconds)
                    $ExchangeRates | ConvertTo-Json | Out-File $Cached -Force
                }
            }
            catch {
                Write-Error $_
            }
        }

        if ($ExchangeRates) {

            if ($Rates) {
                $ExchangeRates.$RateStr
            }
            elseif ($To) {
                $ExchangeRates.$RateStr.$To
            }
            else {
                $ExchangeRates
            }
        }
        else {
            Write-Error "Failed to retrieve rates for $Currency."
        }
    }
}