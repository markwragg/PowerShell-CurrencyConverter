# Run Pester tests
# Unit tests: verify inputs / outputs / expected execution path
# Misc tests: verify manifest data, check comment-based help exists
Task 'Test' -Depends 'ImportStagingModule' {
    $lines

    Import-Module -Name 'Pester' -RequiredVersion '6.1.0' -Force

    # Gather test results. Store them in a variable and file
    $CodeFiles = (Get-ChildItem $ENV:BHModulePath -Recurse -Include '*.ps1').FullName
    $TestFilePath = Join-Path -Path $ArtifactFolder -ChildPath $TestFile

    $PesterConfiguration = New-PesterConfiguration
    $PesterConfiguration.Run.Path = $TestScripts.FullName
    $PesterConfiguration.Run.PassThru = $true
    $PesterConfiguration.CodeCoverage.Enabled = $true
    $PesterConfiguration.CodeCoverage.Path = $CodeFiles
    $PesterConfiguration.TestResult.Enabled = $true
    $PesterConfiguration.TestResult.OutputFormat = 'NUnitXml'
    $PesterConfiguration.TestResult.OutputPath = $TestFilePath
    $PesterConfiguration.Output.Verbosity = 'Detailed'

    $TestResults = Invoke-Pester -Configuration $PesterConfiguration

    # Fail build if any tests fail. Checking Result (rather than just FailedCount) also
    # catches discovery failures (e.g. a test file with a syntax/encoding error), which
    # Pester reports via FailedContainersCount rather than FailedCount.
    if ($TestResults.Result -ne 'Passed') {
        throw "Failed '$($TestResults.FailedCount)' tests and '$($TestResults.FailedContainersCount)' containers, build failed"
    }

    # Surface the coverage result as a pipeline output variable so a later stage (which runs in a
    # separate, discarded workspace) can apply it to README.md without re-running the tests.
    $CoveragePercent = [math]::floor($TestResults.CodeCoverage.CoveragePercent)

    Write-Host "##vso[task.setvariable variable=CoveragePercent;isOutput=true]$CoveragePercent"
}
