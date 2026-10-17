---
name: my-stack
description: Use when setting up Claude Code skills on a new machine or fresh install - installs the full plugin + skill stack in one shot
---

# My Stack Setup

Installs the full Claude Code stack: 11 plugins + 7 npx skill packages (70 skills) + the CLI
tools that drive them, then applies the reference machine's on/off state (6 plugins on, 5 off,
77 skills muted). Last verified against a live machine: 2026-10-16.

## One-shot install (repo root)

```powershell
# PowerShell
irm https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.ps1 | iex
```
```bash
# bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.sh | bash
```

Prereqs: `claude` CLI, `node`/`npx`, `git`, `uv` or `pip` (graphify, scrapling, onyx-cli).
Then restart Claude Code or run `/reload-plugins`.

Steps: `[1/5]` plugins, `[2/5]` npx skill packages, `[3/5]` CLI tools (graphify, scrapling,
onyx-cli), `[4/5]` apply on/off state, `[5/5]` optional ECC full install (`ECC_FULL=1`).

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
claude plugin marketplace add thedotmack/claude-mem

# plugins (on)
claude plugin install ecc@ecc
claude plugin install oh-my-claudecode@omc
claude plugin install superpowers@claude-plugins-official
claude plugin install caveman@caveman
claude plugin install ponytail@ponytail
claude plugin install claude-mem@thedotmack

# plugins (installed, then turned off by apply-state.js)
claude plugin install understand-anything@understand-anything
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
claude plugin install mattpocock-skills@mattpocock
claude plugin install andrej-karpathy-skills@karpathy-skills
claude plugin install watch@claude-video
```

On/off lives in `enabledPlugins` in `~/.claude/settings.json`. To change one, flip its key or
toggle it in `/plugin`, then restart or `/reload-plugins`; also edit `PLUGINS` in
`scripts/apply-state.js` so new machines get the same state.

After installing OMC, write its global instructions:

```
/oh-my-claudecode:omc-setup
```

## npx skills packages

```bash
npx skills@latest add 0101-commits/skills --yes            # my-stack, graphify (off)
npx skills@latest add daleseo/korean-skills --yes          # 3 (off)
npx skills@latest add coreyhaines31/marketingskills --yes  # 49 (off)
npx skills@latest add remotion-dev/skills --yes            # 13 (off)
npx skills@latest add Leonxlnx/taste-skill --skill design-taste-frontend --yes      # off
npx skills@latest add D4Vinci/Scrapling --skill scrapling-official --yes            # on
npx skills@latest add rebelytics/one-skill-to-rule-them-all --skill task-observer --yes  # on
```

Skills land in `~/.agents/skills/<name>/` with a symlink/junction at `~/.claude/skills/<name>`.
`~/skills-lock.json` is the source of truth: if an entry is in the lock but missing from
`~/.agents/skills/`, the install was interrupted — re-run that package's `add`.

## CLI tools and the skills they bundle

```bash
uv tool install --upgrade graphifyy && graphify install --platform claude
uv tool install --upgrade --python 3.12 "scrapling[all]>=0.4.15" && scrapling install
uv tool install --upgrade onyx-cli && onyx-cli install-skill --global --agent claude-code
```

- Without uv the setup scripts fall back to `pip install`; the Python 3.12 pin and the uv
  interpreter path below then do not apply.
- On Windows PowerShell, uv's `onyx-cli` has no `.exe` extension and `& onyx-cli` silently
  does nothing — the setup script launches it with `Start-Process`; Git Bash runs it fine.
- scrapling is pinned to Python 3.12 (dependency wheels). Python code written with Scrapling
  runs on the uv tool's interpreter (`<uv tool dir>/scrapling/Scripts/python.exe`), not the
  global one. CLI extraction must pass `--ai-targeted` (skill rule, prompt-injection guard).
- `onyx-cli` is the only install path for its skill — `npx skills add onyx-dot-app/onyx` does
  not see it. It needs an Onyx server and token: `onyx-cli chat` (first-time setup) or
  `ONYX_SERVER_URL` + `ONYX_PAT`, then `onyx-cli validate-config`.

Manual (not in the setup scripts):

```bash
npm i -g rea-agents && rea setup                                   # reverse-engineer-anything skill + MCP rea (on)
npm i -g @21st-dev/cli && 21st skills install --global             # 21st-* x8 (off)
npm i -g @playwright/cli && playwright-cli install --skills --global   # playwright-cli (off)
```

`21st skills install` runs a real install even with `--help`, and writes to the Claude,
Cursor, and Codex skill folders at once.

## Apply on/off state

Plugins install enabled and every skill is listed by default. Step `[4/5]` runs
`scripts/apply-state.js`, which sets the 11 plugins to the reference on/off values and sets the
77 skills in `SKILLS_OFF` to `skillOverrides: "off"` (marketing 49, remotion 12, Korean 3,
taste 1, this repo 2, 21st 8, playwright-cli, omc-reference). Keys outside those lists are left
alone. Idempotent; backs up `settings.json` first.

Run it standalone on an already-installed machine:

```bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/apply-state.js | node
```

To turn a skill back on, delete its key from `skillOverrides` and drop it from `SKILLS_OFF`,
or the next run mutes it again. Modes: `"off"` hides a skill from both the model and `/name`,
`"name-only"` drops its description, `"user-invocable-only"` keeps only `/name`.

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
