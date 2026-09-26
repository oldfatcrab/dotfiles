#!/usr/bin/env node
'use strict';
const { execFileSync } = require('node:child_process');
const path = require('node:path');
const fs = require('node:fs');
const { readIcons } = require('./workspace_apps.js');

// Keep upstream fetching and bars; adapt the Codex display after each update.
const root = path.join(process.env.XDG_DATA_HOME || path.join(process.env.HOME, '.local/share'), 'showy-quota');
const query = name => JSON.parse(execFileSync('sketchybar', ['--query', name], { encoding: 'utf8', timeout: 3000 }));
const format = window => {
  if (!window || !Number.isInteger(window.remainingPercent)) return null;
  const minutes = window.minutesUntilReset;
  if (!Number.isInteger(minutes) || minutes < 0) return `${window.remainingPercent}%`;
  const days = Math.floor(minutes / 1440);
  const hours = Math.floor(minutes % 1440 / 60);
  const rest = minutes % 60;
  const duration = [days && `${days}d`, hours && `${hours}h`, `${rest}min`].filter(Boolean).join(' ');
  return `${window.remainingPercent}%, ${duration}`;
};
const labels = () => {
  try {
    const state = JSON.parse(execFileSync(path.join(root, 'bin/showy-quota-state'),
      ['--json', '--no-fetch'], { encoding: 'utf8', timeout: 3000 }));
    const windows = state.providerMetrics?.find(metric => metric.provider === 'codex')?.windows;
    return [format(windows?.primary), format(windows?.secondary)];
  } catch { return [null, null]; }
};
if (process.argv.includes('--primary-label')) {
  process.stdout.write(labels()[0] || '');
  process.exit(0);
}

if (!process.argv.includes('--layout-only')) {
  // Rewrite upstream's first label in its own SketchyBar call, before it can flash.
  const env = { ...process.env, SHOWY_QUOTA_LABEL_SCRIPT: __filename };
  try {
    const font = process.env.SKETCHYBAR_APP_FONT || path.join(process.env.HOME, 'Library/Fonts/sketchybar-app-font.ttf');
    const icon = readIcons(fs.readFileSync(font)).find(([, , names]) => names?.includes('ChatGPT'));
    if (icon) env.SHOWY_QUOTA_CHATGPT_ICON = String.fromCodePoint(icon[1]);
  } catch { /* Keep the provider glyph when the app font is unavailable. */ }
  env.BASH_ENV = path.join(__dirname, '../helpers/quota_sketchybar_env.sh');
  delete env.SHOWY_QUOTA_PROVIDER_REGISTRY_LOADED;
  execFileSync(path.join(root, 'adapters/sketchybar/plugins/showy_quota.sh'),
    { timeout: 50000, stdio: 'ignore', env });
}
const [primary, secondary] = labels();
const items = query('bar').items;
const prefix = 'showy_quota.codex.';
if (!items.includes(prefix + 'icon')) process.exit(0);

const detail = prefix + 'detail';
if (!items.includes(detail)) {
  execFileSync('sketchybar', ['--add', 'item', detail, 'center'], { timeout: 3000 });
  items.push(detail);
}

const quota = items.filter(name => name.startsWith('showy_quota.') && name !== 'showy_quota.trigger');
const group = [
  prefix + 'icon',
  ...['primary', 'secondary', 'tertiary', 'quaternary',
    'primary_marker', 'secondary_marker', 'tertiary_marker', 'quaternary_marker',
    'slot', 'detail', 'label'].map(part => prefix + part),
  'showy_quota.degraded', 'showy_quota.stale',
].filter(name => quota.includes(name));
const args = quota.flatMap(name => ['--set', name, 'position=center', 'background.border_width=0', 'click_script=open -b com.openai.codex']);
args.push('--set', prefix + 'icon', 'align=left');
args.push('--set', prefix + 'slot', `drawing=${query(prefix + 'primary').geometry.drawing}`);
args.push('--set', detail, 'drawing=off', 'icon.drawing=off', 'background.drawing=off',
  'label.font=SF Pro:Regular:10.0', 'label.align=left', 'label.width=104',
  'label.padding_left=0', 'label.padding_right=0', 'width=0', 'padding_left=0', 'padding_right=0', 'y_offset=-5');
if (primary) args.push('--set', prefix + 'label', `label=${primary}`, 'label.font=SF Pro:Regular:10.0',
  'label.width=104', 'label.padding_left=0', 'label.padding_right=0', 'padding_left=0', 'padding_right=0', 'y_offset=5');
if (secondary) args.push('--set', detail, 'drawing=on', `label=${secondary}`);
const other = items.filter(name => !quota.includes(name) && name !== 'showy_quota_bracket');
const order = [...other, ...group];
if (items.includes('showy_quota_bracket')) order.push('showy_quota_bracket');
if (items.some((name, i) => name !== order[i])) args.push('--reorder', ...order);
execFileSync('sketchybar', args, { timeout: 3000 });
