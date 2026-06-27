#!/usr/bin/env bash
set -e

echo "Installing Claude Code skills..."

packages=(
  "daleseo/korean-skills"
  "coreyhaines31/marketingskills"
  "remotion-dev/skills"
)

for pkg in "${packages[@]}"; do
  echo ""
  echo "Installing $pkg..."
  npx skills@latest add "$pkg" --yes
done

echo ""
echo "Done! All skills installed."
echo "Restart Claude Code or run /reload-plugins to apply."
