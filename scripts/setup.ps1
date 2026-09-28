Write-Host "==> Installing full Claude Code skill stack..." -ForegroundColor Cyan

$RawBase = "https://raw.githubusercontent.com/0101-commits/skills/main"

# Repo checkout root, if this script runs from a clone (cwd = repo root, or
# invoked as scripts/setup.ps1). $null for a piped install (irm | iex).
$Warn = $false
$RepoDir = $null
if (Test-Path "skills/my-stack/SKILL.md") {
    $RepoDir = (Get-Location).Path
} elseif ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "../skills/my-stack/SKILL.md"))) {
    $RepoDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

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
    "https://github.com/Yeachan-Heo/oh-my-claudecode"
)
foreach ($m in $marketplaces) {
    Write-Host "  + marketplace: $m"
    try { claude plugin marketplace add $m } catch { }
}

# plugin install targets (plugin@marketplace)
# NOTE: all ten are enabled (enabledPlugins=true in ~/.claude/settings.json).
#       Turn any of them off with /plugin after install.
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
    "watch@claude-video"
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
# this repo: remote first; if that fails (private repo without git credentials),
# fall back to the local checkout so the rest of the install still runs.
npx skills@latest add 0101-commits/skills --yes             # my-stack, graphify
if ($LASTEXITCODE -ne 0) {
    if ($RepoDir) {
        Write-Host "  ! remote add failed - installing from local checkout: $RepoDir" -ForegroundColor Gray
        npx skills@latest add $RepoDir --yes
    } else {
        Write-Host "  ! 0101-commits/skills add failed. If the repo is private, run 'gh auth login'" -ForegroundColor Gray
        Write-Host "    (or sign in with Git Credential Manager), then re-run this script." -ForegroundColor Gray
        $Warn = $true
    }
}
npx skills@latest add daleseo/korean-skills --yes           # 3 skills
npx skills@latest add coreyhaines31/marketingskills --yes   # 49 skills
npx skills@latest add remotion-dev/skills --yes             # 12 skills
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes

# ---------------------------------------------------------------------------
# [3/5] graphify CLI (optional but recommended)
# The skill ships in this repo as a pinned snapshot; the pip package keeps it
# current and provides the `graphify` binary the skill drives.
# ---------------------------------------------------------------------------
Write-Host "`n[3/5] graphify CLI" -ForegroundColor Yellow
if (Get-Command uv -ErrorAction SilentlyContinue) {
    try { uv tool install --upgrade graphifyy } catch { }
} elseif (Get-Command pip -ErrorAction SilentlyContinue) {
    try { pip install --upgrade graphifyy } catch { }
} else {
    Write-Host "  ! no uv/pip found - skipping graphify CLI (skill still installed)" -ForegroundColor Gray
}
if (Get-Command graphify -ErrorAction SilentlyContinue) {
    try { graphify install --platform claude } catch { }
}

# ---------------------------------------------------------------------------
# [4/5] Enable everything
# Plugins install enabled, but a machine that previously disabled one keeps it
# off, and skillOverrides can mute skills. enable-all.js normalizes both.
# ---------------------------------------------------------------------------
Write-Host "`n[4/5] Enabling all plugins and skills" -ForegroundColor Yellow
if ($RepoDir) {
    node (Join-Path $RepoDir "scripts/enable-all.js")
} else {
    # piped install (irm | iex) has no repo checkout - fetch the script
    $tmpJs = Join-Path $env:TEMP "enable-all.js"
    try {
        Invoke-WebRequest -Uri "$RawBase/scripts/enable-all.js" -OutFile $tmpJs -UseBasicParsing -ErrorAction Stop
        node $tmpJs
    } catch {
        Write-Host "  ! could not download enable-all.js (private repo?). Clone the repo and run:" -ForegroundColor Gray
        Write-Host "    node scripts/enable-all.js" -ForegroundColor Gray
        $Warn = $true
    }
    Remove-Item $tmpJs -Force -ErrorAction SilentlyContinue
}

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

if ($Warn) {
    Write-Host "`nDone with warnings - see the '!' lines above; those steps did not complete." -ForegroundColor Yellow
} else {
    Write-Host "`nDone! All plugins and skills installed and enabled." -ForegroundColor Green
}
Write-Host "Restart Claude Code or run /reload-plugins to apply." -ForegroundColor Gray
Write-Host "Not wired by default (opt-in, see README): headroom-ai proxy, agentmemory." -ForegroundColor Gray
