Describe 'ConvertTo-Currency' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/ConvertTo-Currency.ps1
        . $PSScriptRoot/../CurrencyConverter/Private/ConvertFrom-UnixTime.ps1

        Mock Invoke-RestMethod {
            [pscustomobject]@{
                result                = 'success'
                provider              = 'https://www.exchangerate-api.com'
                documentation         = 'https://www.exchangerate-api.com/docs/free'
                terms_of_use          = 'https://www.exchangerate-api.com/terms'
                time_last_update_unix = 1706918552
                time_last_update_utc  = 'Sat, 03 Feb 2024 00:02:32 +0000'
                time_next_update_unix = 1707006302
                time_next_update_utc  = 'Sun, 04 Feb 2024 00:25:02 +0000'
                time_eol_unix         = 0
                base_code             = 'GBP'
                rates                 = @{GBP = 1; AED = 4.651339; AFN = 94.482314; ALL = 121.965758; AMD = 515.03716; ANG = 2.267093; AOA = 1073.379609; ARS = 1047.865406; AUD = 1.938049; AWG = 2.267093; AZN = 2.165101; BAM = 2.29131;
                    BBD = 2.533064; BDT = 138.771067; BGN = 2.291589; BHD = 0.476216; BIF = 3611.009259; BMD = 1.266532; BND = 1.69924; BOB = 8.783628; BRL = 6.273346; BSD = 1.266532; BTN = 105.120098; BWP = 17.370291;
                    BYN = 4.129916; BZD = 2.533064; CAD = 1.701493; CDF = 3482.044643; CHF = 1.094468; CLP = 1187.374334; CNY = 9.117683; COP = 4943.751633; CRC = 650.833868; CUP = 30.396773; CVE = 129.178556;
                    CZK = 29.183862; DJF = 225.089367; DKK = 8.731055; DOP = 74.47288; DZD = 170.835865; EGP = 39.0807; ERN = 18.997983; ETB = 69.725784; EUR = 1.171529; FJD = 2.837631; FKP = 1; FOK = 8.731024;
                    GEL = 3.401644; GGP = 1; GHS = 15.702309; GIP = 1; GMD = 82.241285; GNF = 10881.710735; GTQ = 9.909408; GYD = 265.479238; HKD = 9.906686; HNL = 31.280498; HRK = 8.826879; HTG = 167.233705;
                    HUF = 448.843918; IDR = 19860.534195; ILS = 4.634743; IMP = 1; INR = 105.121393; IQD = 1659.52766; IRR = 53940.96913; ISK = 173.858109; JEP = 1; JMD = 195.728157; JOD = 0.897971; JPY = 187.253024;
                    KES = 204.1948; KGS = 113.927084; KHR = 5199.853333; KID = 1.938404; KMF = 576.354088; KRW = 1688.042647; KWD = 0.389283; KYD = 1.055443; KZT = 569.483207; LAK = 26077.89312; LBP = 18997.982826;
                    LKR = 397.366394; LRD = 243.455976; LSL = 23.844533; LYD = 6.121123; MAD = 12.679409; MDL = 22.652653; MGA = 5724.652611; MKD = 72.2824; MMK = 3667.510535; MNT = 4335.79679; MOP = 10.203748;
                    MRU = 50.165809; MUR = 57.623139; MVR = 19.584347; MWK = 2148.642006; MXN = 21.683306; MYR = 5.999089; MZN = 80.977297; NAD = 23.844533; NGN = 1649.607305; NIO = 46.443968; NOK = 13.393649;
                    NPR = 168.192157; NZD = 2.077904; OMR = 0.486978; PAB = 1.266532; PEN = 4.841964; PGK = 4.743954; PHP = 71.330106; PKR = 352.731989; PLN = 5.051988; PYG = 9267.866499; QAR = 4.610177; RON = 5.830228;
                    RSD = 137.384695; RUB = 115.501345; RWF = 1669.493507; SAR = 4.749496; SBD = 10.699856; SCR = 16.937756; SDG = 566.844477; SEK = 13.250784; SGD = 1.699247; SHP = 1; SLE = 28.557299;
                    SLL = 28556.857394; SOS = 724.886617; SRD = 46.783709; SSP = 1400.863492; STN = 28.702441; SYP = 16312.14469; SZL = 23.844533; THB = 44.953221; TJS = 13.977182; TMT = 4.465668; TND = 3.955292;
                    TOP = 2.976965; TRY = 38.516762; TTD = 8.791345; TVD = 1.938404; TWD = 39.683836; TZS = 3232.70759; UAH = 47.903533; UGX = 4850.55084; USD = 1.266552; UYU = 49.563715; UZS = 15721.6941;
                    VES = 45.957977; VND = 30812.484007; VUV = 152.13455; WST = 3.44583; XAF = 768.472118; XCD = 3.419637; XDR = 0.95608; XOF = 768.472118; XPF = 139.800802; YER = 317.252324; ZAR = 23.820971;
                    ZMW = 34.503957; ZWL = 13387.8296
                }
            }
        }

        Mock Get-Content {
            @"
{
    "result": "success",
    "provider": "https://www.exchangerate-api.com",
    "documentation": "https://www.exchangerate-api.com/docs/free",
    "terms_of_use": "https://www.exchangerate-api.com/terms",
    "time_last_update_unix": $([int](New-TimeSpan 01/01/1970 (Get-Date)).TotalSeconds),
    "time_last_update_utc": "Sat, 03 Feb 2024 00:02:32 +0000",
    "time_next_update_unix": $([int](New-TimeSpan 01/01/1970 (Get-Date).AddDays(1)).TotalSeconds),
    "time_next_update_utc": "Sun, 04 Feb 2024 00:25:02 +0000",
    "time_eol_unix": 0,
    "base_code": "GBP",
    "rates": {
        "GBP": 1,
        "USD": 1.266552,
        "ZWL": 13387.8296
    }
}              
"@
        }

        Mock Out-File
    }

    Context 'Value provided via pipeline' {

        It 'Convert from GBP to USD using cached currency' {

            Mock Test-Path { $true }

            $result = 100 | ConvertTo-Currency -SourceCurrency GBP -DestinationCurrency USD
            $result | Should -Be 126.655200

            Should -Invoke Get-Content -Exactly 1
            Should -Not -Invoke Invoke-RestMethod
            Should -Not -Invoke Out-File
        }

        It 'Convert from GBP to USD using API' {

            Mock Test-Path { $false }

            $result = 100 | ConvertTo-Currency -SourceCurrency GBP -DestinationCurrency USD
            $result | Should -Be 126.655200

            Should -Not -Invoke Get-Content
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Invoke Out-File -Exactly 1
        }

        It 'Convert from GBP to USD using API and update out of date cached currency' {

            Mock Test-Path { $false }
            Mock Get-Content {
                @'
{
    "result": "success",
    "provider": "https://www.exchangerate-api.com",
    "documentation": "https://www.exchangerate-api.com/docs/free",
    "terms_of_use": "https://www.exchangerate-api.com/terms",
    "time_last_update_unix": 1706747100,
    "time_last_update_utc": "Sat, 01 Feb 2024 00:02:00 +0000",
    "time_next_update_unix": 1706833500,
    "time_next_update_utc": "Sun, 02 Feb 2024 00:25:00 +0000",
    "time_eol_unix": 0,
    "base_code": "GBP",
    "rates": {
        "GBP": 1,
        "USD": 1.266552,
        "ZWL": 13387.8296
    }
}
'@
            }

            $result = 100 | ConvertTo-Currency -SourceCurrency GBP -DestinationCurrency USD
            $result | Should -Be 126.655200

            Should -Not -Invoke Get-Content
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Invoke Out-File -Exactly 1
        }

        It 'Returns an error if the API fails' {

            Mock Test-Path { $true }

            Mock Get-Content {
                @'
{
    "result": "success",
    "provider": "https://www.exchangerate-api.com",
    "documentation": "https://www.exchangerate-api.com/docs/free",
    "terms_of_use": "https://www.exchangerate-api.com/terms",
    "time_last_update_unix": 1706747100,
    "time_last_update_utc": "Sat, 01 Feb 2024 00:02:00 +0000",
    "time_next_update_unix": 1706833500,
    "time_next_update_utc": "Sun, 02 Feb 2024 00:25:00 +0000",
    "time_eol_unix": 0,
    "base_code": "GBP",
    "rates": {
        "GBP": 1,
        "USD": 1.266552,
        "ZWL": 13387.8296
    }
}
'@
            }

            Mock Invoke-RestMethod {}
            Mock Write-Error

            $result = 100 | ConvertTo-Currency -SourceCurrency GBP -DestinationCurrency USD

            Should -Invoke Get-Content -Exactly 1
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Not -Invoke Out-File -Exactly 1
            Should -Invoke Write-Error
        }
    }
}