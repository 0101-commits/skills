---
name: my-stack
description: Use when setting up Claude Code skills on a new machine or fresh install - installs the full plugin + skill stack in one shot
---

# My Stack Setup

Installs the full Claude Code stack: 10 plugins + 5 npx skill packages (66 skills).
Last verified against a live machine: 2026-07-31.

## One-shot install (repo root)

```powershell
# PowerShell
irm https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.ps1 | iex
```
```bash
# bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.sh | bash
```

Prereqs: `claude` CLI, `node`/`npx`, `git`, `python` (optional, for graphify).
Then restart Claude Code or run `/reload-plugins`.

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
claude plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode

# plugins
claude plugin install ecc@ecc
claude plugin install oh-my-claudecode@omc
claude plugin install superpowers@claude-plugins-official
claude plugin install understand-anything@understand-anything
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
claude plugin install caveman@caveman
claude plugin install mattpocock-skills@mattpocock
claude plugin install andrej-karpathy-skills@karpathy-skills
claude plugin install ponytail@ponytail
claude plugin install watch@claude-video
```

All ten sit at `enabledPlugins: true` in `~/.claude/settings.json`. To turn one off, flip its
key to `false` or toggle it in `/plugin`, then restart or `/reload-plugins`.

After installing OMC, write its global instructions:

```
/oh-my-claudecode:omc-setup
```

## npx skills packages

```bash
npx skills@latest add 0101-commits/skills --yes            # my-stack, graphify
npx skills@latest add daleseo/korean-skills --yes          # 3
npx skills@latest add coreyhaines31/marketingskills --yes  # 49
npx skills@latest add remotion-dev/skills --yes            # 12
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes
```

Skills land in `~/.agents/skills/<name>/` with a symlink/junction at `~/.claude/skills/<name>`.
`~/skills-lock.json` is the source of truth: if an entry is in the lock but missing from
`~/.agents/skills/`, the install was interrupted — re-run that package's `add`.

Most marketing/Korean skills are turned off via `skillOverrides` in `~/.claude/settings.json`
to save context. Turn them on individually when needed.

## graphify CLI

The `graphify` skill in this repo is a pinned snapshot of
[Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) (Apache-2.0). For the
live version plus the binary it drives:

```bash
uv tool install --upgrade graphifyy   # or: pip install --upgrade graphifyy
graphify install --platform claude
```

## ECC full install (optional)

The `ecc@ecc` plugin already provides ecc skills/agents/commands. For the full
rules + hooks + framework modules copied into `~/.claude`:

```bash
# default languages: typescript python golang
ECC_FULL=1 bash scripts/setup.sh
```

ECC ships a GateGuard hook that demands a fact list before the first Bash/Write call.
Disable with `ECC_GATEGUARD=off` or
`ECC_DISABLED_HOOKS=pre:bash:gateguard-fact-force,pre:edit-write:gateguard-fact-force`.

## Optional CLI tools (not wired by default)

| Tool | Install | Note |
|------|---------|------|
| `headroom-ai` | `uv tool install --python 3.13 "headroom-ai[all]"` | Needs `headroom deploy` / `headroom wrap claude` to route traffic. If the proxy dies, Claude Code requests die with it. |
| `@agentmemory/agentmemory` | `npm i -g @agentmemory/agentmemory` | `agentmemory connect` is not supported on Windows — manual wiring only. |
