Write-Host "==> Installing full Claude Code skill stack..." -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# [1/3] Claude Code plugins (marketplaces)
# ---------------------------------------------------------------------------
Write-Host "`n[1/3] Claude Code plugins" -ForegroundColor Yellow

# marketplace add sources (superpowers is on the official marketplace -> no add)
$marketplaces = @(
    "forrestchang/andrej-karpathy-skills",
    "Egonex-AI/Understand-Anything",
    "JuliusBrussee/caveman",
    "bradautomates/claude-video",
    "nextlevelbuilder/ui-ux-pro-max-skill",
    "DietrichGebert/ponytail",
    "mattpocock/skills",
    "https://github.com/affaan-m/ECC"
)
foreach ($m in $marketplaces) {
    Write-Host "  + marketplace: $m"
    try { claude plugin marketplace add $m } catch { }
}

# plugin install targets (plugin@marketplace)
$plugins = @(
    "andrej-karpathy-skills@karpathy-skills",
    "superpowers@claude-plugins-official",
    "understand-anything@understand-anything",
    "caveman@caveman",
    "watch@claude-video",
    "ui-ux-pro-max@ui-ux-pro-max-skill",
    "ponytail@ponytail",
    "mattpocock-skills@mattpocock",
    "ecc@ecc"
)
foreach ($p in $plugins) {
    Write-Host "  + plugin: $p"
    try { claude plugin install $p } catch { }
}

# ---------------------------------------------------------------------------
# [2/3] npx skills packages
# ---------------------------------------------------------------------------
Write-Host "`n[2/3] npx skills packages" -ForegroundColor Yellow
npx skills@latest add daleseo/korean-skills --yes
npx skills@latest add coreyhaines31/marketingskills --yes
npx skills@latest add remotion-dev/skills --yes
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes

# ---------------------------------------------------------------------------
# [3/3] ECC full install (optional deep install)
# The ecc@ecc plugin above already provides the ecc: skills/agents/commands.
# Run the full everything-claude-code installer only if you want the complete
# rules + hooks + framework modules copied into ~/.claude. Enable with:
#   $env:ECC_FULL = "1"; ./setup.ps1   (default languages: typescript python golang)
# ---------------------------------------------------------------------------
if ($env:ECC_FULL -eq "1") {
    Write-Host "`n[3/3] ECC full install (everything-claude-code)" -ForegroundColor Yellow
    $langStr = if ($env:ECC_LANG) { $env:ECC_LANG } else { "typescript python golang" }
    $langs = $langStr -split '\s+'
    $tmp = Join-Path $env:TEMP ("ecc-" + [System.Guid]::NewGuid().ToString())
    git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git $tmp
    Push-Location $tmp
    # splat so multiple languages pass as separate args
    bash ./install.sh @langs
    Pop-Location
} else {
    Write-Host "`n[3/3] ECC full install skipped (ecc plugin already installed). Set `$env:ECC_FULL='1' to run it." -ForegroundColor Gray
}

Write-Host "`nDone! All skills installed." -ForegroundColor Green
Write-Host "Restart Claude Code or run /reload-plugins to apply." -ForegroundColor Gray
