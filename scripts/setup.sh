#!/usr/bin/env bash
set -e

echo "==> Installing full Claude Code skill stack..."

RAW_BASE="https://raw.githubusercontent.com/0101-commits/skills/main"

# ---------------------------------------------------------------------------
# [1/5] Claude Code plugins (marketplaces)
# ---------------------------------------------------------------------------
echo ""
echo "[1/5] Claude Code plugins"

# marketplace add sources (superpowers is on the official marketplace -> no add)
marketplaces=(
  "forrestchang/andrej-karpathy-skills"
  "Egonex-AI/Understand-Anything"
  "JuliusBrussee/caveman"
  "bradautomates/claude-video"
  "nextlevelbuilder/ui-ux-pro-max-skill"
  "DietrichGebert/ponytail"
  "mattpocock/skills"
  "https://github.com/affaan-m/ECC"
  "https://github.com/Yeachan-Heo/oh-my-claudecode"
)
for m in "${marketplaces[@]}"; do
  echo "  + marketplace: $m"
  claude plugin marketplace add "$m" || true
done

# plugin install targets (plugin@marketplace)
# NOTE: all ten are enabled (enabledPlugins=true in ~/.claude/settings.json).
#       Turn any of them off with /plugin after install.
plugins=(
  "ecc@ecc"
  "oh-my-claudecode@omc"
  "superpowers@claude-plugins-official"
  "understand-anything@understand-anything"
  "ui-ux-pro-max@ui-ux-pro-max-skill"
  "caveman@caveman"
  "mattpocock-skills@mattpocock"
  "andrej-karpathy-skills@karpathy-skills"
  "ponytail@ponytail"
  "watch@claude-video"
)
for p in "${plugins[@]}"; do
  echo "  + plugin: $p"
  claude plugin install "$p" || true
done

echo "  ! OMC global instructions: run /oh-my-claudecode:omc-setup inside Claude Code"
echo "    (writes ~/.claude/CLAUDE-omc.md and the @CLAUDE-omc.md import)"

# ---------------------------------------------------------------------------
# [2/4] npx skills packages
# ---------------------------------------------------------------------------
echo ""
echo "[2/5] npx skills packages"
npx skills@latest add 0101-commits/skills --yes            # my-stack, graphify
npx skills@latest add daleseo/korean-skills --yes          # 3 skills
npx skills@latest add coreyhaines31/marketingskills --yes  # 49 skills
npx skills@latest add remotion-dev/skills --yes            # 12 skills
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes

# ---------------------------------------------------------------------------
# [3/4] graphify CLI (optional but recommended)
# The skill ships in this repo as a pinned snapshot; the pip package keeps it
# current and provides the `graphify` binary the skill drives.
# ---------------------------------------------------------------------------
echo ""
echo "[3/5] graphify CLI"
if command -v uv >/dev/null 2>&1; then
  uv tool install --upgrade graphifyy || true
elif command -v pip >/dev/null 2>&1; then
  pip install --upgrade graphifyy || true
else
  echo "  ! no uv/pip found — skipping graphify CLI (skill still installed)"
fi
if command -v graphify >/dev/null 2>&1; then
  graphify install --platform claude || true
fi

# ---------------------------------------------------------------------------
# [4/5] Enable everything
# Plugins install enabled, but a machine that previously disabled one keeps it
# off, and skillOverrides can mute skills. enable-all.js normalizes both.
# ---------------------------------------------------------------------------
echo ""
echo "[4/5] Enabling all plugins and skills"
if [ -f "scripts/enable-all.js" ]; then
  node scripts/enable-all.js
elif [ -f "$(dirname "$0")/enable-all.js" ]; then
  node "$(dirname "$0")/enable-all.js"
else
  # piped install (curl | bash) has no repo checkout — fetch the script
  curl -fsSL "$RAW_BASE/scripts/enable-all.js" | node
fi

# ---------------------------------------------------------------------------
# [5/5] ECC full install (optional deep install)
# The ecc@ecc plugin above already provides the ecc: skills/agents/commands.
# Run the full everything-claude-code installer only if you want the complete
# rules + hooks + framework modules copied into ~/.claude. Enable with:
#   ECC_FULL=1 bash setup.sh   (default languages: typescript python golang)
# ---------------------------------------------------------------------------
if [ "${ECC_FULL:-0}" = "1" ]; then
  echo ""
  echo "[5/5] ECC full install (everything-claude-code)"
  ECC_LANG="${ECC_LANG:-typescript python golang}"
  tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git "$tmp/ecc"
  # unquoted on purpose: multiple languages must split into separate args
  (cd "$tmp/ecc" && ./install.sh $ECC_LANG)
else
  echo ""
  echo "[5/5] ECC full install skipped (ecc plugin already installed). Set ECC_FULL=1 to run it."
fi

echo ""
echo "Done! All plugins and skills installed and enabled."
echo "Restart Claude Code or run /reload-plugins to apply."
echo "Not wired by default (opt-in, see README): headroom-ai proxy, agentmemory."
