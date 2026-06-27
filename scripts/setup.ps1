Write-Host "Installing Claude Code skills..." -ForegroundColor Cyan

$packages = @(
    "daleseo/korean-skills",
    "coreyhaines31/marketingskills",
    "remotion-dev/skills"
)

foreach ($pkg in $packages) {
    Write-Host "`nInstalling $pkg..." -ForegroundColor Yellow
    npx skills@latest add $pkg --yes
}

Write-Host "`nDone! All skills installed." -ForegroundColor Green
Write-Host "Restart Claude Code or run /reload-plugins to apply." -ForegroundColor Gray
