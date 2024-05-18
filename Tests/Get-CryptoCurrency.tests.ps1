Describe 'Get-CryptoCurrency' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/Get-CryptoCurrency.ps1
    }

    Context 'Currency provided' {

        $SupportedCodes = @('00', '1INCH', 'AAVE', 'ABT', 'ACH', 'ACS', 'ADA', 'AERGO', 'AERO', 'AGLD', 'AIOZ', 'AKT', 'ALCX', 'ALEPH', 'ALGO', 'ALICE', 'AMP', 'ANKR', 'ANT', 'APE', 'API3', 'APT', 'ARB', 'ARKM', 'ARPA', 'ASM', 'AST', 'ATA', 'ATOM', 'AUCTION', 'AUDIO', 'AURORA', 'AVAX', 'AVT', 'AXL', 'AXS', 'BADGER', 'BAL', 'BAND', 'BAT', 'BCH', 'BICO', 'BIGTIME', 'BIT', 'BLUR', 'BLZ', 'BNT', 'BOBA', 'BOND', 'BONK', 'BTC', 'BTRST', 'BUSD', 'C98', 'CBETH', 'CELR', 'CGLD', 'CHZ', 'CLV', 'COMP', 'COTI', 'COVAL', 'CRO', 'CRPT', 'CRV', 'CTSI', 'CTX', 'CVC', 'CVX', 'DAI', 'DAR', 'DASH', 'DDX', 'DESO', 'DEXT', 'DIA', 'DIMO', 'DNT', 'DOGE', 'DOT', 'DREP', 'DRIFT', 'DYP', 'EGLD', 'ELA', 'ENJ', 'ENS', 'EOS', 'ERN', 'ETC', 'ETH', 'EUR', 'EUROC', 'FARM', 'FET', 'FIDA', 'FIL', 'FIS', 'FLOW', 'FLR', 'FORT', 'FORTH', 'FOX', 'FX', 'GAL', 'GALA', 'GBP', 'GFI', 'GHST', 'GLM', 'GMT', 'GNO', 'GNT', 'GODS', 'GRT', 'GST', 'GTC', 'GUSD', 'GYEN', 'HBAR', 'HFT', 'HIGH', 'HNT', 'HONEY', 'HOPR', 'ICP', 'IDEX', 'ILV', 'IMX', 'INDEX', 'INJ', 'INV', 'IOTX', 'JASMY', 'JTO', 'JUP', 'KARRAT', 'KAVA', 'KEEP', 'KNC', 'KRL', 'KSM', 'LCX', 'LDO', 'LINK', 'LIT', 'LOKA', 'LOOM', 'LPT', 'LQTY', 'LRC', 'LSETH', 'LTC', 'MAGIC', 'MANA', 'MASK', 'MATH', 'MATIC', 'MCO2', 'MDT', 'MEDIA', 'METIS', 'MINA', 'MIR', 'MKR', 'MLN', 'MNDE', 'MOBILE', 'MONA', 'MPL', 'MSOL', 'MTL', 'MULTI', 'MUSD', 'MUSE', 'MXC', 'NCT', 'NEAR', 'NEON', 'NEST', 'NKN', 'NMR', 'NU', 'OCEAN', 'OGN', 'OMG', 'OMNI', 'ONDO', 'OOKI', 'OP', 'ORCA', 'ORN', 'OSMO', 'OXT', 'PAX', 'PERP', 'PLA', 'PLU', 'PNG', 'POLS', 'POLY', 'POND', 'POWR', 'PRIME', 'PRO', 'PRQ', 'PUNDIX', 'PYR', 'PYUSD', 'QI', 'QNT', 'QSP', 'QUICK', 'RAD', 'RAI', 'RARE', 'RARI', 'RBN', 'REN', 'RENDER', 'REP', 'REQ', 'RGT', 'RLC', 'RLY', 'RNDR', 'RONIN', 'ROSE', 'RPL', 'SAFE', 'SAND', 'SEAM', 'SEI', 'SHDW', 'SHIB', 'SHPING', 'SKL', 'SNT', 'SNX', 'SOL', 'SPA', 'SPELL', 'STG', 'STORJ', 'STRK', 'STX', 'SUI', 'SUKU', 'SUPER', 'SUSHI', 'SWFTC', 'SYLO', 'SYN', 'T', 'TBTC', 'TIA', 'TIME', 'TNSR', 'TONE', 'TRAC', 'TRB', 'TRIBE', 'TRU', 'TVK', 'UMA', 'UNFI', 'UNI', 'UPI', 'USD', 'USDC', 'USDT', 'UST', 'VARA', 'VELO', 'VET', 'VGX', 'VOXEL', 'VTHO', 'WAMPL', 'WAXL', 'WBTC', 'WCFG', 'WLUNA', 'XCN', 'XLM', 'XMON', 'XRP', 'XTZ', 'XYO', 'YFI', 'YFII', 'ZEC', 'ZEN', 'ZETA', 'ZRX')

        It 'Should return the specified currency <_> via the -Currency parameter' -TestCases $SupportedCodes {
            $Code = $_
            $Result = Get-CryptoCurrency -Currency $Code
            $Result.Code | Should -Be $Code
        }

        It 'Should return the specified currency <_> via the -Code parameter' -TestCases $SupportedCodes {
            $Code = $_
            $Result = Get-CryptoCurrency -Code $Code
            $Result.Code | Should -Be $Code
        }

        It 'Should return the specified currency <_> via pipeline input' -TestCases $SupportedCodes {
            $Code = $_
            $Result = $Code | Get-CryptoCurrency
            $Result.Code | Should -Be $Code
        }
    }

    Context 'Name provided' {

        It 'Should return the specified currency' {
            $Result = Get-CryptoCurrency -Name 'Ethereum'
            $Result.Code | Should -Be 'ENS'
        }

        It 'Should return the specified currencies' {
            $Result = Get-CryptoCurrency -Name 'Bitcoin'
            $Result.Count | Should -Be 3
        }
    }

    Context 'No input' {

        It 'Should return currencies' {
            $Result = Get-CryptoCurrency
            $Result.Count | Should -Be 295
        }
    }

    Context 'false input' {

        It 'Should return nothing' {
            $Result = Get-CryptoCurrency -Code XXX
            $Result | Should -BeNullOrEmpty
        }

        It 'Should return nothing' {
            $Result = Get-CryptoCurrency -Name XXX
            $Result | Should -BeNullOrEmpty
        }
    }
}