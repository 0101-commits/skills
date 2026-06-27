---
name: my-stack
description: Use when setting up Claude Code skills on a new machine or fresh install - installs all preferred skill packages in one shot
---

# My Stack Setup

Installs all preferred Claude Code skill packages.

## Packages

| Package | Skills |
|---------|--------|
| `daleseo/korean-skills` | grammar-checker, humanizer, style-guide |
| `coreyhaines31/marketingskills` | 45개 마케팅 스킬 (SEO, copywriting, ads 등) |
| `remotion-dev/skills` | remotion-best-practices |

## Install All

Run each command sequentially:

```powershell
npx skills@latest add daleseo/korean-skills
npx skills@latest add coreyhaines31/marketingskills
npx skills@latest add remotion-dev/skills
```

Or use the setup script from the repo root:

```powershell
# PowerShell
irm https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.ps1 | iex
```

```bash
# bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.sh | bash
```
