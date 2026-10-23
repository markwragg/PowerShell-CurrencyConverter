# Config file for PSDeploy
# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHModulePath and related variables.
# $env:BHStagingModulePath is set by the psake 'Deploy' task when the combined module built by
# CombineFunctionsAndStage is available -- a bare psake Properties variable wouldn't be visible here, since
# Invoke-PSDeploy dot-sources this file from inside the PSDeploy module's own function scope.
if ($env:BHStagingModulePath -and (Test-Path $env:BHStagingModulePath)) {
    $ModuleSourcePath = $env:BHStagingModulePath
}
else {
    $ModuleSourcePath = $env:BHPSModulePath
}

# The branch that's allowed to publish to the Gallery is a deploy gate, not something to infer (e.g. from
# the repo's default branch) -- it's set explicitly via the pipeline's DeployBranch variable (passed through
# as an env var on the Deploy step in azure-pipelines.yml), defaulting to 'main' for local/manual runs
# where that env var isn't set.
$DeployBranch = if ($env:DeployBranch) { $env:DeployBranch } else { 'main' }

# Publish to gallery with a few restrictions
if (
    $ModuleSourcePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq $DeployBranch -and
    $ENV:NugetApiKey
) {
    Deploy Module {
        By PSGalleryModule {
            FromSource $ModuleSourcePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }

    # Signal back to the psake 'Deploy' task that a Gallery deploy was actually attempted here -- a return
    # value or local variable can't cross this boundary, since Invoke-PSDeploy dot-sources this file from
    # inside PSDeploy's own function scope. Deploy.ps1 uses this to decide whether CHANGELOG.md's
    # '## !Deploy' marker should actually be consumed, rather than assuming it always should be just
    # because the marker was present -- this gate above (branch/build-system/API key) can still skip
    # deploying even when it was.
    $env:PSGalleryDeployAttempted = 'true'
} else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the $DeployBranch branch (Current: $ENV:BHBranchName) `n" +
    "`t* You have access to the Nuget API key" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if ($env:BHPSModulePath -and $env:BHBuildSystem -eq 'AppVeyor') {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ModuleSourcePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}
