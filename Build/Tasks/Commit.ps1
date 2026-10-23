Task 'Commit' -Depends 'Init' {
    $lines

    Set-Location $ProjectRoot

    git --version
    git config --global user.email "build@azuredevops.com"
    git config --global user.name "AzureDevOps"
    git fetch origin $env:BUILD_SOURCEBRANCHNAME
    git checkout -B $env:BUILD_SOURCEBRANCHNAME "origin/$($env:BUILD_SOURCEBRANCHNAME)"

    git add Documentation/*.md
    git add README.md
    git add CHANGELOG.md
    git add $env:BHPSModuleManifest
    git commit -m "[skip ci] AzureDevOps Build $($env:BUILD_BUILDID)"
    git push origin $env:BUILD_SOURCEBRANCHNAME
}
