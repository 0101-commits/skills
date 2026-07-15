---
name: my-stack
description: Use when setting up Claude Code skills on a new machine or fresh install - installs the full plugin + skill stack in one shot
---

# My Stack Setup

Installs the full Claude Code stack: 9 plugins + 4 npx skill packages.

## One-shot install (repo root)

```powershell
# PowerShell
irm https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.ps1 | iex
```
```bash
# bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.sh | bash
```

Prereqs: `claude` CLI, `node`/`npx`, `git`. Then restart Claude Code or run `/reload-plugins`.

## Claude Code plugins

```bash
# marketplaces
claude plugin marketplace add forrestchang/andrej-karpathy-skills
claude plugin marketplace add Egonex-AI/Understand-Anything
claude plugin marketplace add JuliusBrussee/caveman
claude plugin marketplace add bradautomates/claude-video
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add mattpocock/skills
claude plugin marketplace add https://github.com/affaan-m/ECC

# plugins
claude plugin install andrej-karpathy-skills@karpathy-skills
claude plugin install superpowers@claude-plugins-official
claude plugin install understand-anything@understand-anything
claude plugin install caveman@caveman
claude plugin install watch@claude-video
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
claude plugin install ponytail@ponytail
claude plugin install mattpocock-skills@mattpocock
claude plugin install ecc@ecc
```

## npx skills packages

```bash
npx skills@latest add daleseo/korean-skills
npx skills@latest add coreyhaines31/marketingskills
npx skills@latest add remotion-dev/skills
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend
```

## ECC full install (optional)

The `ecc@ecc` plugin already provides ecc skills/agents/commands. For the full
rules + hooks + framework modules copied into `~/.claude`:

```bash
# default languages: typescript python golang
ECC_FULL=1 bash scripts/setup.sh
```
