#!/usr/bin/env bash
set -e

echo "==> Installing full Claude Code skill stack..."

# ---------------------------------------------------------------------------
# [1/3] Claude Code plugins (marketplaces)
# ---------------------------------------------------------------------------
echo ""
echo "[1/3] Claude Code plugins"

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
)
for m in "${marketplaces[@]}"; do
  echo "  + marketplace: $m"
  claude plugin marketplace add "$m" || true
done

# plugin install targets (plugin@marketplace)
plugins=(
  "andrej-karpathy-skills@karpathy-skills"
  "superpowers@claude-plugins-official"
  "understand-anything@understand-anything"
  "caveman@caveman"
  "watch@claude-video"
  "ui-ux-pro-max@ui-ux-pro-max-skill"
  "ponytail@ponytail"
  "mattpocock-skills@mattpocock"
  "ecc@ecc"
)
for p in "${plugins[@]}"; do
  echo "  + plugin: $p"
  claude plugin install "$p" || true
done

# ---------------------------------------------------------------------------
# [2/3] npx skills packages
# ---------------------------------------------------------------------------
echo ""
echo "[2/3] npx skills packages"
npx skills@latest add daleseo/korean-skills --yes
npx skills@latest add coreyhaines31/marketingskills --yes
npx skills@latest add remotion-dev/skills --yes
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes

# ---------------------------------------------------------------------------
# [3/3] ECC full install (optional deep install)
# The ecc@ecc plugin above already provides the ecc: skills/agents/commands.
# Run the full everything-claude-code installer only if you want the complete
# rules + hooks + framework modules copied into ~/.claude. Enable with:
#   ECC_FULL=1 bash setup.sh   (default language: typescript)
# ---------------------------------------------------------------------------
if [ "${ECC_FULL:-0}" = "1" ]; then
  echo ""
  echo "[3/3] ECC full install (everything-claude-code)"
  ECC_LANG="${ECC_LANG:-typescript}"
  tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git "$tmp/ecc"
  (cd "$tmp/ecc" && ./install.sh "$ECC_LANG")
else
  echo ""
  echo "[3/3] ECC full install skipped (ecc plugin already installed). Set ECC_FULL=1 to run it."
fi

echo ""
echo "Done! All skills installed."
echo "Restart Claude Code or run /reload-plugins to apply."
