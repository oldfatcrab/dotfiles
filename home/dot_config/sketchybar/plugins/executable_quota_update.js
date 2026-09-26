#!/usr/bin/env node
'use strict';
const { execFileSync } = require('node:child_process');
const path = require('node:path');

// Keep upstream fetching and bars; adapt the Codex display after each update.
const root = path.join(process.env.XDG_DATA_HOME || path.join(process.env.HOME, '.local/share'), 'showy-quota');
const query = name => JSON.parse(execFileSync('sketchybar', ['--query', name], { encoding: 'utf8', timeout: 3000 }));
if (!process.argv.includes('--layout-only')) {
  // The upstream bootstrap exports this guard, but Bash arrays cannot cross exec.
  const env = { ...process.env };
  delete env.SHOWY_QUOTA_PROVIDER_REGISTRY_LOADED;
  execFileSync(path.join(root, 'adapters/sketchybar/plugins/showy_quota.sh'),
    { timeout: 50000, stdio: 'ignore', env });
}
const items = query('bar').items;
const prefix = 'showy_quota.codex.';
if (!items.includes(prefix + 'icon')) process.exit(0);

const detail = prefix + 'detail';
if (!items.includes(detail)) {
  execFileSync('sketchybar', ['--add', 'item', detail, 'center'], { timeout: 3000 });
  items.push(detail);
}

const format = (window, horizon) => {
  if (!window || !Number.isInteger(window.remainingPercent)) return null;
  const minutes = window.minutesUntilReset;
  if (!Number.isInteger(minutes) || minutes < 0) return `${horizon} ${window.remainingPercent}%`;
  const days = Math.floor(minutes / 1440);
  const hours = Math.floor(minutes % 1440 / 60);
  const rest = minutes % 60;
  const duration = [days && `${days}d`, hours && `${hours}h`, `${rest}min`].filter(Boolean).join(' ');
  return `${horizon} ${window.remainingPercent}%, ${duration}`;
};
let primary = null;
let secondary = null;
try {
  const state = JSON.parse(execFileSync(path.join(root, 'bin/showy-quota-state'),
    ['--json', '--no-fetch'], { encoding: 'utf8', timeout: 3000 }));
  const windows = state.providerMetrics?.find(metric => metric.provider === 'codex')?.windows;
  primary = format(windows?.primary, '5h');
  secondary = format(windows?.secondary, '7d');
} catch { /* Preserve upstream's label when the cache is unavailable. */ }

const quota = items.filter(name => name.startsWith('showy_quota.') && name !== 'showy_quota.trigger');
const group = [
  prefix + 'icon',
  ...['primary', 'secondary', 'tertiary', 'quaternary',
    'primary_marker', 'secondary_marker', 'tertiary_marker', 'quaternary_marker',
    'slot', 'detail', 'label'].map(part => prefix + part),
  'showy_quota.degraded', 'showy_quota.stale',
].filter(name => quota.includes(name));
const args = quota.flatMap(name => ['--set', name, 'position=center', 'background.border_width=0', 'click_script=open -a Codex']);
args.push('--set', prefix + 'slot', `drawing=${query(prefix + 'primary').geometry.drawing}`);
args.push('--set', detail, 'drawing=off', 'icon.drawing=off', 'background.drawing=off',
  'label.font=SF Pro:Regular:10.0', 'label.align=left', 'label.width=135',
  'label.padding_left=0', 'label.padding_right=0', 'width=0', 'y_offset=-5');
if (primary) args.push('--set', prefix + 'label', `label=${primary}`, 'label.font=SF Pro:Regular:10.0',
  'label.width=135', 'label.padding_left=0', 'label.padding_right=0', 'y_offset=5');
if (secondary) args.push('--set', detail, 'drawing=on', `label=${secondary}`);
const other = items.filter(name => !quota.includes(name) && name !== 'showy_quota_bracket');
args.push('--reorder', ...other, ...group);
if (items.includes('showy_quota_bracket')) args.push('showy_quota_bracket');
execFileSync('sketchybar', args, { timeout: 3000 });
