#!/usr/bin/env node
// Make ~/.claude/settings.json match the reference machine's on/off state.
//
// Installing plugins and skill packages is not the whole job: plugins install
// enabled, and every skill is listed by default. The reference machine keeps
// some plugins off and mutes skills it rarely uses to save context. This
// applies exactly that state, so a fresh machine ends up the same.
//
// Only the plugins and skills named below are touched; anything else the user
// set themselves is left as it is. Idempotent. Backs the file up before writing.

const fs = require('fs')
const os = require('os')
const path = require('path')

// plugin@marketplace -> enabled
const PLUGINS = {
  'ecc@ecc': true,
  'oh-my-claudecode@omc': true,
  'superpowers@claude-plugins-official': true,
  'caveman@caveman': true,
  'ponytail@ponytail': true,
  'claude-mem@thedotmack': true,
  'understand-anything@understand-anything': false,
  'ui-ux-pro-max@ui-ux-pro-max-skill': false,
  'mattpocock-skills@mattpocock': false,
  'andrej-karpathy-skills@karpathy-skills': false,
  'watch@claude-video': false,
}

// skills set to skillOverrides: "off" (hidden from the model and from /name)
const SKILLS_OFF = [
  // coreyhaines31/marketingskills (49)
  'ab-testing', 'ad-creative', 'ads', 'ai-seo', 'analytics', 'aso', 'attribution',
  'churn-prevention', 'co-marketing', 'cold-email', 'community-marketing',
  'competitor-profiling', 'competitors', 'content-strategy', 'copy-editing',
  'copywriting', 'cro', 'customer-research', 'directory-submissions', 'emails',
  'free-tools', 'image', 'influencer-marketing', 'launch', 'lead-magnets',
  'marketing-council', 'marketing-ideas', 'marketing-loops', 'marketing-plan',
  'marketing-psychology', 'offers', 'onboarding', 'paywalls', 'popups', 'pricing',
  'product-marketing', 'programmatic-seo', 'prospecting', 'public-relations',
  'referrals', 'revops', 'sales-enablement', 'schema', 'seo-audit', 'signup',
  'site-architecture', 'sms', 'social', 'video',
  // remotion-dev/skills (12 of 13; mediabunny is not linked into ~/.claude/skills)
  'remotion-best-practices', 'remotion-captions', 'remotion-create', 'remotion-docs',
  'remotion-interactivity', 'remotion-maps', 'remotion-markup', 'remotion-multimedia',
  'remotion-render', 'remotion-saas', 'remotion-studio', 'remotion-upgrade',
  // daleseo/korean-skills (3), Leonxlnx/taste-skill (1), this repo (2)
  'grammar-checker', 'humanizer', 'style-guide',
  'design-taste-frontend',
  'graphify', 'my-stack',
  // CLI-bundled skills: @21st-dev/cli (8), @playwright/cli (1), OMC (1)
  '21st-ai', '21st-cli-use', '21st-design-sync', '21st-registry',
  '21st-ui-build', '21st-ui-explore', '21st-ui-review', '21st-video',
  'playwright-cli',
  'omc-reference',
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
}

settings.enabledPlugins = settings.enabledPlugins || {}
const flipped = []
for (const [id, on] of Object.entries(PLUGINS)) {
  if (settings.enabledPlugins[id] !== on) {
    flipped.push(`${id}=${on}`)
    settings.enabledPlugins[id] = on
  }
}

settings.skillOverrides = settings.skillOverrides || {}
const muted = []
for (const skill of SKILLS_OFF) {
  if (settings.skillOverrides[skill] !== 'off') {
    muted.push(skill)
    settings.skillOverrides[skill] = 'off'
  }
}

// Write only when something changed, so re-runs don't pile up backups.
if (flipped.length || muted.length) {
  if (fs.existsSync(settingsPath)) {
    // Timestamped backup so a bad merge is always recoverable.
    const stamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)
    fs.copyFileSync(settingsPath, `${settingsPath}.bak-${stamp}`)
  } else {
    fs.mkdirSync(path.dirname(settingsPath), { recursive: true })
  }
  fs.writeFileSync(settingsPath, `${JSON.stringify(settings, null, 2)}\n`, 'utf8')
}

const on = Object.values(PLUGINS).filter(Boolean).length
console.log(`  settings: ${settingsPath}`)
console.log(`  plugins: ${on} on, ${Object.keys(PLUGINS).length - on} off (${flipped.length ? `changed: ${flipped.join(', ')}` : 'no change'})`)
console.log(`  skills off: ${SKILLS_OFF.length} (${muted.length ? `newly muted: ${muted.length}` : 'no change'})`)
console.log('  restart Claude Code or run /reload-plugins to apply')
