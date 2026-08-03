#!/usr/bin/env node
// Force every plugin and skill in this stack to the enabled state.
//
// The setup scripts install plugins and skill packages, but two things can still
// leave the stack half-on: a plugin left at enabledPlugins:false from an earlier
// session, and skills muted through skillOverrides. This normalizes both in
// ~/.claude/settings.json so a fresh machine ends up fully active.
//
// Idempotent. Backs the file up before writing. Run it after the install steps.

const fs = require('fs')
const os = require('os')
const path = require('path')

const PLUGINS = [
  'ecc@ecc',
  'oh-my-claudecode@omc',
  'superpowers@claude-plugins-official',
  'understand-anything@understand-anything',
  'ui-ux-pro-max@ui-ux-pro-max-skill',
  'caveman@caveman',
  'mattpocock-skills@mattpocock',
  'andrej-karpathy-skills@karpathy-skills',
  'ponytail@ponytail',
  'watch@claude-video',
]

const settingsPath = path.join(os.homedir(), '.claude', 'settings.json')

let settings = {}
if (fs.existsSync(settingsPath)) {
  const raw = fs.readFileSync(settingsPath, 'utf8')
  try {
    settings = JSON.parse(raw)
  } catch (err) {
    console.error(`! ${settingsPath} is not valid JSON (${err.message}) - refusing to overwrite it.`)
    console.error('  Fix the file by hand, then re-run this script.')
    process.exit(1)
  }
  // Timestamped backup so a bad merge is always recoverable.
  const stamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)
  fs.copyFileSync(settingsPath, `${settingsPath}.bak-${stamp}`)
} else {
  fs.mkdirSync(path.dirname(settingsPath), { recursive: true })
}

// 1. Every plugin in the stack on. Keys already true stay true; plugins the user
//    installed themselves are left exactly as they are.
settings.enabledPlugins = settings.enabledPlugins || {}
const flipped = []
for (const id of PLUGINS) {
  if (settings.enabledPlugins[id] !== true) {
    flipped.push(id)
    settings.enabledPlugins[id] = true
  }
}

// 2. Drop every skillOverride. "off", "name-only", and "user-invocable-only" each
//    hide a skill from the model in some way; removing the key restores the
//    default (fully listed). Explicit "on" entries are dropped too - same
//    effective result, less noise.
const cleared = []
if (settings.skillOverrides && typeof settings.skillOverrides === 'object') {
  for (const [skill, mode] of Object.entries(settings.skillOverrides)) {
    cleared.push(`${skill}=${mode}`)
    delete settings.skillOverrides[skill]
  }
  if (Object.keys(settings.skillOverrides).length === 0) delete settings.skillOverrides
}

fs.writeFileSync(settingsPath, `${JSON.stringify(settings, null, 2)}\n`, 'utf8')

console.log(`  settings: ${settingsPath}`)
console.log(`  plugins enabled: ${PLUGINS.length} (${flipped.length ? `flipped: ${flipped.join(', ')}` : 'no change'})`)
console.log(`  skillOverrides cleared: ${cleared.length}`)
if (cleared.length) console.log(`    ${cleared.join(', ')}`)
console.log('  restart Claude Code or run /reload-plugins to apply')
