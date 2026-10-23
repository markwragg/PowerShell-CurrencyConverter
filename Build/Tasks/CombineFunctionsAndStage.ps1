# Create a single .psm1 module file containing all functions
# Copy new module and other supporting files (Documentation / Examples) to Staging folder
Task 'CombineFunctionsAndStage' -Depends 'Clean' {
    $lines

    # Create folders
    New-Item -Path $StagingFolder -ItemType 'Directory' -Force | Out-String | Write-Verbose
    New-Item -Path $StagingModulePath -ItemType 'Directory' -Force | Out-String | Write-Verbose

    # Get public and private function files
    $publicFunctions = @( Get-ChildItem -Path "$env:BHModulePath\Public\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )
    $privateFunctions = @( Get-ChildItem -Path "$env:BHModulePath\Private\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )

    # Combine functions into a single .psm1 module
    $combinedModulePath = Join-Path -Path $StagingModulePath -ChildPath "$($env:BHProjectName).psm1"
    # Read as UTF-8 and write UTF-8 with BOM: Windows PowerShell 5.1 defaults to the ANSI code page for BOM-less
    # files, which would corrupt non-ASCII currency symbols when the module is loaded.
    $combinedContent = @($publicFunctions + $privateFunctions) | Get-Content -Encoding UTF8
    [System.IO.File]::WriteAllLines($combinedModulePath, [string[]]$combinedContent, (New-Object System.Text.UTF8Encoding($true)))

    # Copy other required folders and files if they exist
    $PathsToCopy = @(
        Join-Path -Path $ProjectRoot -ChildPath 'Documentation'
        Join-Path -Path $ProjectRoot -ChildPath 'Examples'
        Join-Path -Path $ProjectRoot -ChildPath 'CHANGELOG.md'
        Join-Path -Path $ProjectRoot -ChildPath 'README.md'
    )

    foreach ($Path in $PathsToCopy) {
        if (Test-Path $Path) {
            Copy-Item -Path $Path -Destination $StagingFolder -Recurse
        }
    }

    # Copy existing manifest
    Copy-Item -Path $env:BHPSModuleManifest -Destination $StagingModulePath -Recurse

    # Copy format/type ps1xml files so the views they define ship with the built module -- FormatsToProcess
    # in the manifest references them by filename relative to the module root, which the combined psm1 also
    # resolves $PSScriptRoot to, so they need to sit alongside it in Staging the same way they do in source.
    Get-ChildItem -Path $env:BHModulePath -Filter '*.ps1xml' -File | Copy-Item -Destination $StagingModulePath

    # Copy data files (e.g. SupportedCurrency.csv) referenced via $PSScriptRoot by the combined psm1, so they
    # sit alongside it in Staging the same way they do next to the source functions in Public/Private.
    Get-ChildItem -Path $env:BHModulePath -Filter '*.csv' -File -Recurse | Copy-Item -Destination $StagingModulePath
}
