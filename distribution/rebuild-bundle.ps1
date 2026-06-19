# rebuild-bundle.ps1
# Copies the latest top-level template files into distribution/bundle/
# so the offline distribution bundle stays in sync with the repo root.
#
# Usage (from the repo root):
#   .\distribution\rebuild-bundle.ps1
#
# Note: distribution/bundle/ is intentionally git-ignored. The originals already
# live in the repo, so we do not track duplicate copies. This script just
# regenerates the offline hand-off bundle on demand.

$ErrorActionPreference = "Stop"

# Resolve repo root as the parent of this script's folder.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot  = Split-Path -Parent $scriptDir
$bundle    = Join-Path $scriptDir "bundle"

Write-Host "Repo root : $repoRoot"
Write-Host "Bundle    : $bundle"

# Files the recipient needs to build their automation.
$files = @(
    "AUTOMATION_BUILDER_PRD.md",
    "QUICK_START.md",
    "README.md",
    "LICENSE",
    ".gitignore"
)

# Recreate the bundle folder (keep START_HERE.md which lives only in the bundle).
if (-not (Test-Path $bundle)) {
    New-Item -ItemType Directory -Path $bundle | Out-Null
}

foreach ($f in $files) {
    $src = Join-Path $repoRoot $f
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $bundle $f) -Force
        Write-Host "  copied  $f"
    } else {
        Write-Host "  SKIP    $f (not found)" -ForegroundColor Yellow
    }
}

# Copy examples/ (reference cases), excluding any captures/output/logs.
$examplesSrc = Join-Path $repoRoot "examples"
$examplesDst = Join-Path $bundle "examples"
if (Test-Path $examplesSrc) {
    if (Test-Path $examplesDst) { Remove-Item -Recurse -Force $examplesDst }
    Copy-Item -Path $examplesSrc -Destination $examplesDst -Recurse -Force
    # Strip any sensitive runtime folders if present.
    Get-ChildItem -Path $examplesDst -Recurse -Directory -Include "captures","output","logs" -ErrorAction SilentlyContinue |
        ForEach-Object { Remove-Item -Recurse -Force $_.FullName }
    Write-Host "  copied  examples/"
}

Write-Host ""
Write-Host "Bundle rebuilt. Zip 'distribution/bundle/' to hand it out offline." -ForegroundColor Green
