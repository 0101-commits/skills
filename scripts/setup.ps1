Write-Host "==> Installing full Claude Code skill stack..." -ForegroundColor Cyan

$RawBase = "https://raw.githubusercontent.com/0101-commits/skills/main"

# ---------------------------------------------------------------------------
# [1/5] Claude Code plugins (marketplaces)
# ---------------------------------------------------------------------------
Write-Host "`n[1/5] Claude Code plugins" -ForegroundColor Yellow

# marketplace add sources (superpowers is on the official marketplace -> no add)
$marketplaces = @(
    "forrestchang/andrej-karpathy-skills",
    "Egonex-AI/Understand-Anything",
    "JuliusBrussee/caveman",
    "bradautomates/claude-video",
    "nextlevelbuilder/ui-ux-pro-max-skill",
    "DietrichGebert/ponytail",
    "mattpocock/skills",
    "https://github.com/affaan-m/ECC",
    "https://github.com/Yeachan-Heo/oh-my-claudecode",
    "thedotmack/claude-mem"
)
foreach ($m in $marketplaces) {
    Write-Host "  + marketplace: $m"
    try { claude plugin marketplace add $m } catch { }
}

# plugin install targets (plugin@marketplace)
# NOTE: all eleven install enabled; step [4/5] then turns five of them off to
#       match the reference machine (see scripts/apply-state.js).
$plugins = @(
    "ecc@ecc",
    "oh-my-claudecode@omc",
    "superpowers@claude-plugins-official",
    "understand-anything@understand-anything",
    "ui-ux-pro-max@ui-ux-pro-max-skill",
    "caveman@caveman",
    "mattpocock-skills@mattpocock",
    "andrej-karpathy-skills@karpathy-skills",
    "ponytail@ponytail",
    "watch@claude-video",
    "claude-mem@thedotmack"
)
foreach ($p in $plugins) {
    Write-Host "  + plugin: $p"
    try { claude plugin install $p } catch { }
}

Write-Host "  ! OMC global instructions: run /oh-my-claudecode:omc-setup inside Claude Code" -ForegroundColor Gray
Write-Host "    (writes ~/.claude/CLAUDE-omc.md and the @CLAUDE-omc.md import)" -ForegroundColor Gray

# ---------------------------------------------------------------------------
# [2/5] npx skills packages
# ---------------------------------------------------------------------------
Write-Host "`n[2/5] npx skills packages" -ForegroundColor Yellow
npx skills@latest add 0101-commits/skills --yes             # my-stack, graphify
npx skills@latest add daleseo/korean-skills --yes           # 3 skills
npx skills@latest add coreyhaines31/marketingskills --yes   # 49 skills
npx skills@latest add remotion-dev/skills --yes             # 13 skills
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes
npx skills@latest add D4Vinci/Scrapling --skill scrapling-official --yes
npx skills@latest add rebelytics/one-skill-to-rule-them-all --skill task-observer --yes

# ---------------------------------------------------------------------------
# [3/5] CLI tools the skills drive (graphify, scrapling, onyx-cli)
# graphify ships in this repo as a pinned snapshot; the pip package keeps it
# current. scrapling-official needs the scrapling binary plus its browsers.
# onyx-cli bundles its own skill (npx skills cannot see it in the onyx repo).
# ---------------------------------------------------------------------------
Write-Host "`n[3/5] CLI tools" -ForegroundColor Yellow
$hasUv = [bool](Get-Command uv -ErrorAction SilentlyContinue)
$hasPip = [bool](Get-Command pip -ErrorAction SilentlyContinue)
function Install-PyTool([string]$spec, [string[]]$uvArgs = @()) {
    if ($hasUv) {
        try { uv tool install --upgrade @uvArgs $spec } catch { }
    } elseif ($hasPip) {
        try { pip install --upgrade $spec } catch { }
    } else {
        Write-Host "  ! no uv/pip found - skipping $spec (skill still installed)" -ForegroundColor Gray
    }
}
Install-PyTool "graphifyy"
Install-PyTool "scrapling[all]>=0.4.15" @("--python", "3.12")
Install-PyTool "onyx-cli"
# fresh machines: uv's tool bin dir is not on PATH in this session yet
if ($hasUv) { $env:Path = "$(uv tool dir --bin);$env:Path" }
if (Get-Command graphify -ErrorAction SilentlyContinue) {
    try { graphify install --platform claude } catch { }
}
if (Get-Command scrapling -ErrorAction SilentlyContinue) {
    try { scrapling install } catch { }   # browser downloads, a few hundred MB
}
if ($onyx = Get-Command onyx-cli -ErrorAction SilentlyContinue) {
    # uv installs onyx-cli without an .exe extension; PowerShell's & runs it silently
    # as a no-op, so launch it through Start-Process.
    Start-Process -FilePath $onyx.Source -ArgumentList 'install-skill', '--global', '--agent', 'claude-code' -NoNewWindow -Wait
}

# ---------------------------------------------------------------------------
# [4/5] Apply the reference on/off state
# Plugins install enabled and every skill is listed by default. apply-state.js
# turns off the plugins and skills the reference machine keeps off.
# ---------------------------------------------------------------------------
Write-Host "`n[4/5] Applying plugin/skill on-off state" -ForegroundColor Yellow
$stateLocal = $null
if (Test-Path "scripts/apply-state.js") {
    $stateLocal = "scripts/apply-state.js"
} elseif ($PSScriptRoot) {
    $sibling = Join-Path $PSScriptRoot "apply-state.js"
    if (Test-Path $sibling) { $stateLocal = $sibling }
}
if ($stateLocal) {
    node $stateLocal
} else {
    # piped install (irm | iex) has no repo checkout - fetch the script
    $tmpJs = Join-Path $env:TEMP "apply-state.js"
    Invoke-WebRequest -Uri "$RawBase/scripts/apply-state.js" -OutFile $tmpJs -UseBasicParsing
    node $tmpJs
    Remove-Item $tmpJs -Force -ErrorAction SilentlyContinue
}
if ($LASTEXITCODE) { Write-Warning "apply-state.js failed - on/off state was not applied" }

# ---------------------------------------------------------------------------
# [5/5] ECC full install (optional deep install)
# The ecc@ecc plugin above already provides the ecc: skills/agents/commands.
# Run the full everything-claude-code installer only if you want the complete
# rules + hooks + framework modules copied into ~/.claude. Enable with:
#   $env:ECC_FULL = "1"; ./setup.ps1   (default languages: typescript python golang)
# ---------------------------------------------------------------------------
if ($env:ECC_FULL -eq "1") {
    Write-Host "`n[5/5] ECC full install (everything-claude-code)" -ForegroundColor Yellow
    $langStr = if ($env:ECC_LANG) { $env:ECC_LANG } else { "typescript python golang" }
    $langs = $langStr -split '\s+'
    $tmp = Join-Path $env:TEMP ("ecc-" + [System.Guid]::NewGuid().ToString())
    git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git $tmp
    Push-Location $tmp
    # splat so multiple languages pass as separate args
    bash ./install.sh @langs
    Pop-Location
} else {
    Write-Host "`n[5/5] ECC full install skipped (ecc plugin already installed). Set `$env:ECC_FULL='1' to run it." -ForegroundColor Gray
}

Write-Host "`nDone! Plugins and skills installed; on/off state matches the reference machine." -ForegroundColor Green
Write-Host "Restart Claude Code or run /reload-plugins to apply." -ForegroundColor Gray
Write-Host "Manual steps (see README): onyx-cli config (ONYX_PAT), rea setup, optional CLI tools." -ForegroundColor Gray
