#!/usr/bin/env bash
set -eo pipefail

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
  "thedotmack/claude-mem"
)
for m in "${marketplaces[@]}"; do
  echo "  + marketplace: $m"
  claude plugin marketplace add "$m" || true
done

# plugin install targets (plugin@marketplace)
# NOTE: all eleven install enabled; step [4/5] then turns five of them off to
#       match the reference machine (see scripts/apply-state.js).
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
  "claude-mem@thedotmack"
)
for p in "${plugins[@]}"; do
  echo "  + plugin: $p"
  claude plugin install "$p" || true
done

echo "  ! OMC global instructions: run /oh-my-claudecode:omc-setup inside Claude Code"
echo "    (writes ~/.claude/CLAUDE-omc.md and the @CLAUDE-omc.md import)"

# ---------------------------------------------------------------------------
# [2/5] npx skills packages
# ---------------------------------------------------------------------------
echo ""
echo "[2/5] npx skills packages"
# one failed package must not stop the rest of the setup (set -e)
skills_add() { npx skills@latest add "$@" --yes || echo "  ! failed: $1"; }
skills_add 0101-commits/skills            # my-stack, graphify
skills_add daleseo/korean-skills          # 3 skills
skills_add coreyhaines31/marketingskills  # 49 skills
skills_add remotion-dev/skills            # 13 skills
skills_add Leonxlnx/taste-skill --skill design-taste-frontend
skills_add D4Vinci/Scrapling --skill scrapling-official
skills_add rebelytics/one-skill-to-rule-them-all --skill task-observer

# ---------------------------------------------------------------------------
# [3/5] CLI tools the skills drive (graphify, scrapling, onyx-cli)
# graphify ships in this repo as a pinned snapshot; the pip package keeps it
# current. scrapling-official needs the scrapling binary plus its browsers.
# onyx-cli bundles its own skill (npx skills cannot see it in the onyx repo).
# ---------------------------------------------------------------------------
echo ""
echo "[3/5] CLI tools"
# usage: py_tool <pip spec> [extra uv args...]
py_tool() {
  spec="$1"; shift
  if command -v uv >/dev/null 2>&1; then
    uv tool install --upgrade "$@" "$spec" || true
  elif command -v pip >/dev/null 2>&1; then
    pip install --upgrade "$spec" || true
  else
    echo "  ! no uv/pip found — skipping $spec (skill still installed)"
  fi
}
py_tool graphifyy
py_tool "scrapling[all]>=0.4.15" --python 3.12
py_tool onyx-cli
# fresh machines: uv's tool bin dir is not on PATH in this session yet
if command -v uv >/dev/null 2>&1; then
  uvbin="$(uv tool dir --bin 2>/dev/null)" || uvbin=""   # very old uv has no --bin
  if [ -n "$uvbin" ]; then
    if command -v cygpath >/dev/null 2>&1; then uvbin="$(cygpath -u "$uvbin")"; fi
    PATH="$uvbin:$PATH"
  fi
fi
if command -v graphify >/dev/null 2>&1; then
  graphify install --platform claude || true
fi
if command -v scrapling >/dev/null 2>&1; then
  scrapling install || true   # browser downloads, a few hundred MB
fi
if command -v onyx-cli >/dev/null 2>&1; then
  onyx-cli install-skill --global --agent claude-code || true
fi

# ---------------------------------------------------------------------------
# [4/5] Apply the reference on/off state
# Plugins install enabled and every skill is listed by default. apply-state.js
# turns off the plugins and skills the reference machine keeps off.
# ---------------------------------------------------------------------------
echo ""
echo "[4/5] Applying plugin/skill on-off state"
if [ -f "scripts/apply-state.js" ]; then
  node scripts/apply-state.js
elif [ -f "$(dirname "$0")/apply-state.js" ]; then
  node "$(dirname "$0")/apply-state.js"
else
  # piped install (curl | bash) has no repo checkout — fetch the script
  curl -fsSL "$RAW_BASE/scripts/apply-state.js" | node
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
echo "Done! Plugins and skills installed; on/off state matches the reference machine."
echo "Restart Claude Code or run /reload-plugins to apply."
echo "Manual steps (see README): onyx-cli config (ONYX_PAT), rea setup, optional CLI tools."
