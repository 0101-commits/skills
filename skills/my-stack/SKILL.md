---
name: my-stack
description: Use when setting up Claude Code skills on a new machine or fresh install - installs the full plugin + skill stack in one shot
---

# My Stack Setup

Installs the full Claude Code stack: 10 plugins + 5 npx skill packages (66 skills), then
forces everything to the enabled state. Last verified against a live machine: 2026-08-03.

## One-shot install

Clone first — works whether the repo is public or private (private needs a GitHub login:
`gh auth login` or Git Credential Manager).

```powershell
# PowerShell
git clone https://github.com/0101-commits/skills.git $HOME\skills; cd $HOME\skills; .\scripts\setup.ps1
```
```bash
# bash
git clone https://github.com/0101-commits/skills.git ~/skills && cd ~/skills && bash scripts/setup.sh
```

Piped one-liners (`irm .../setup.ps1 | iex`, `curl .../setup.sh | bash`) fetch from
`raw.githubusercontent.com` without auth, so they only work while the repo is public.

Prereqs: `claude` CLI, `node`/`npx`, `git`, `python` (optional, for graphify).
Then restart Claude Code or run `/reload-plugins`.

Steps: `[1/5]` plugins, `[2/5]` npx skill packages, `[3/5]` graphify CLI, `[4/5]` enable
everything, `[5/5]` optional ECC full install (`ECC_FULL=1`).

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
npx skills@latest add 0101-commits/skills --yes            # my-stack, graphify (private: needs git credentials)
npx skills@latest add daleseo/korean-skills --yes          # 3
npx skills@latest add coreyhaines31/marketingskills --yes  # 49
npx skills@latest add remotion-dev/skills --yes            # 12
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes
```

Skills land in `~/.agents/skills/<name>/` with a symlink/junction at `~/.claude/skills/<name>`.
`~/skills-lock.json` is the source of truth: if an entry is in the lock but missing from
`~/.agents/skills/`, the install was interrupted — re-run that package's `add`.

## Enable everything

Install alone can leave the stack half-on: a machine that previously set a plugin to
`enabledPlugins: false` keeps it off, and `skillOverrides` can mute skills. Step `[4/5]` runs
`scripts/enable-all.js`, which flips all ten plugins to `true` and clears `skillOverrides`
entirely (all 66 skills listed). It is idempotent and backs up `settings.json` first.

Run it standalone on an already-installed machine (from the clone):

```bash
node scripts/enable-all.js
```

To trade skill coverage back for context, re-add specific overrides — `"off"` hides a skill
from both the model and `/name`, `"name-only"` drops its description,
`"user-invocable-only"` keeps only `/name`. Re-running `enable-all.js` clears them again.

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
