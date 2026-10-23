if (-not $PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }

# Fall back to locally-derived values when not running under the BuildHelpers-driven build (which sets
# these as real environment variables so they survive Pester's Discovery/Run split, unlike plain variables).
if (-not $env:BHProjectPath) { $env:BHProjectPath = (Resolve-Path "$PSScriptRoot/../..").ProviderPath }
if (-not $env:BHProjectName) {
    $env:BHProjectName = (Get-ChildItem -Path $env:BHProjectPath -Filter '*.psd1' -Recurse -Depth 1 |
        Where-Object { $_.BaseName -eq $_.Directory.Name }).BaseName
}

# Vars
$StagingFolder = Join-Path -Path $env:BHProjectPath -ChildPath 'Staging'
$StagingModulePath = Join-Path -Path $StagingFolder -ChildPath $env:BHProjectName
$StagingManifestPath = Join-Path -Path $StagingModulePath -ChildPath "$($env:BHProjectName).psd1"

# Functions like Get-Currency load supporting data files (e.g. SupportedCurrency.csv) via $PSScriptRoot.
# The other function tests dot-source straight from Public/, where $PSScriptRoot resolves to a folder the
# data file always lives in -- so they can't catch a packaging regression in the combined module that
# actually ships to users. This file runs the real 'CombineFunctionsAndStage' build task and imports the
# staged output directly, so a file the build forgets to copy fails here instead of in production.
#
# This runs at Discovery time (top-level, not inside BeforeAll/It) because calling into psake's own control
# flow (which uses 'break' internally) from inside a Pester block trips
# https://github.com/pester/Pester/issues/2669 and silently aborts the whole run.
& (Join-Path -Path $env:BHProjectPath -ChildPath 'Build\build.ps1') -TaskList 'CombineFunctionsAndStage' | Out-Null

if ($LASTEXITCODE -ne 0) {
    throw "Failed to stage module for testing (exit code $LASTEXITCODE)"
}

Get-Module -Name $env:BHProjectName | Remove-Module -Force -ErrorAction 'SilentlyContinue'
Import-Module -Name $StagingManifestPath -ErrorAction 'Stop' -Force

Describe 'Staged module' {

    AfterAll {
        Get-Module -Name $env:BHProjectName | Remove-Module -Force -ErrorAction 'SilentlyContinue'
    }

    It 'Ships the currency data file Get-Currency needs' {
        (Get-Currency -Currency 'GBP').Country | Should -Be 'United Kingdom'
    }

    It 'Ships the crypto currency data file Get-CryptoCurrency needs' {
        (Get-CryptoCurrency -Currency 'BTC').Name | Should -Be 'Bitcoin'
    }
}
