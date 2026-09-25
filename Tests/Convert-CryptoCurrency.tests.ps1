Describe 'Convert-CryptoCurrency' {

    BeforeAll {
        . $PSScriptRoot/../CurrencyConverter/Public/Convert-CryptoCurrency.ps1
        
        Mock Invoke-RestMethod {
            [pscustomobject]@{
                data = @{
                    currency = 'BTC'
                    rates    = @{
                        AAVE  = 756.4296520423600605
                        ABT   = 15987.300371124144476664
                        ACH   = 2281519.852388437092592704
                        ACS   = 27195731.508634734440052536
                        ADA   = 138888.8888888888888889
                        AED   = 245251.96173826991314036
                        AERGO = 531192.999204455050924256
                        AERO  = 62900.977367466614420144
                        AEVO  = 81895.181249992645481
                        AFN   = 4779954.550464930848624712
                        AGLD  = 63191.179671603652026976
                        AIOZ  = 79636.185819070906620056
                        AKT   = 11558.0682014886593058
                        ALCX  = 2692.920346844120184344
                        ALEPH = 185089.28620928620910112
                        ALGO  = 361010.8303249097472924
                        ALICE = 56609.54641797372039424
                        ALL   = 6155377.736053655961240176
                        AMD   = 25836213.10702616
                    }
                }
            }
        }

        Mock Get-Content {
            @"
            {
                "currency": "BTC",
                "rates": {
                  "1INCH": "7885.375796178344025927",
                  "AAVE": "34.808637462745385169",
                  "ABT": "15987.300371124144476664"
                },
                "Expires": "2299-05-18T16:29:32.474651+01:00"
            } 
"@
        }

        Mock Out-File
    }

    Context 'Value provided via pipeline' {

        It 'Convert from BTC to ABT using cached currency' {

            Mock Test-Path { $true }

            $result = 100 | Convert-CryptoCurrency -From BTC -To ABT
            $result | Should -Be 1598730.0371124100

            Should -Invoke Get-Content -Exactly 1
            Should -Not -Invoke Invoke-RestMethod
            Should -Not -Invoke Out-File
        }

        It 'Convert from BTC to ABT using API' {

            Mock Test-Path { $false }

            $result = 100 | Convert-CryptoCurrency -From BTC -To ABT
            $result | Should -Be 1598730.0371124100

            Should -Not -Invoke Get-Content
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Not -Invoke Out-File
        }

        It 'Convert from BTC to ABT using API and caches currency' {

            Mock Test-Path { $false }

            $result = 100 | Convert-CryptoCurrency -From BTC -To ABT -CacheSeconds 60
            $result | Should -Be 1598730.0371124100

            Should -Not -Invoke Get-Content
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Invoke Out-File -Exactly 1
        }

        It 'Convert from BTC to ABT using API and update out of date cached currency' {

            Mock Test-Path { $false }
            Mock Get-Content {
                @"
            {
                "currency": "BTC",
                "rates": {
                    "1INCH": "7885.375796178344025927",
                    "AAVE": "34.808637462745385169",
                    "ABT": "15987.300371124144476664"
                },
                "Expires": "2021-05-18T16:29:32.474651+01:00"
            } 
"@
            }

            $result = 100 | Convert-CryptoCurrency -From BTC -To ABT -CacheSeconds 60
            $result | Should -Be 1598730.0371124100

            Should -Not -Invoke Get-Content
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Invoke Out-File -Exactly 1
        }

        It 'Returns an error if the API fails' {

            Mock Test-Path { $true }

            Mock Get-Content {
                @"
            {
                "currency": "BTC",
                "rates": {
                    "1INCH": "7885.375796178344025927",
                    "AAVE": "34.808637462745385169",
                    "ABT": "15987.300371124144476664"
                },
                "Expires": "2021-05-18T16:29:32.474651+01:00"
            } 
"@
            }

            Mock Invoke-RestMethod {}
            Mock Write-Error

            $result = 100 | Convert-CryptoCurrency -From BTC -To ABT
            
            Should -Invoke Get-Content -Exactly 1
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Not -Invoke Out-File -Exactly 1
            Should -Invoke Write-Error
        }

        It 'Should perform no conversion if the source and destination currencies are the same' {

            $result = Convert-CryptoCurrency -Value 100 -From BTC -To BTC

            $result | Should -Be 100

            Should -Not -Invoke Get-Content
            Should -Not -Invoke Invoke-RestMethod
            Should -Not -Invoke Out-file
        }

        It 'Should return an error if Invoke-RestMethod fails' {

            Mock Test-Path { $false }

            Mock Invoke-RestMethod { throw 'some failure' }
            Mock Write-Error

            $result = 100 | Convert-CryptoCurrency -From BTC -To ABT
            $result | Should -BeNullOrEmpty
            
            Should -Not -Invoke Get-Content
            Should -Invoke Invoke-RestMethod -Exactly 1
            Should -Not -Invoke Out-File -Exactly 1
            Should -Invoke Write-Error
        }
    }
}