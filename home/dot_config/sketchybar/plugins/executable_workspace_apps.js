#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

// Font 3+ embeds its own mapping; codepoints can change with font releases.
function readIcons(font) {
  for (let i = 0; i < font.readUInt16BE(4); i++) {
    const table = 12 + i * 16;
    if (font.toString('ascii', table, table + 4) !== 'meta') continue;
    const meta = font.readUInt32BE(table + 8);
    for (let j = 0; j < font.readUInt32BE(meta + 12); j++) {
      const entry = meta + 16 + j * 12;
      if (font.toString('ascii', entry, entry + 4) !== 'APPM') continue;
      const start = meta + font.readUInt32BE(entry + 4);
      const end = start + font.readUInt32BE(entry + 8);
      if (end > font.length) throw new Error('Truncated font metadata');
      const mapping = JSON.parse(font.toString('utf8', start, end));
      if (mapping.version !== 1 || !Array.isArray(mapping.icons)) throw new Error('Unsupported font mapping');
      return mapping.icons;
    }
  }
  throw new Error('App font has no APPM mapping');
}

function labels(windows, icons) {
  if (!Array.isArray(windows) || windows.some(w =>
    typeof w.workspace !== 'string' || typeof w['app-name'] !== 'string')) {
    throw new Error('Invalid Hyprspace window list');
  }
  const exact = new Map();
  const prefixes = [];
  for (const [, codepoint, names] of icons) {
    const glyph = String.fromCodePoint(codepoint);
    for (const name of names ?? []) {
      if (name.endsWith('*')) prefixes.push([name.slice(0, -1), glyph]);
      else exact.set(name, glyph);
    }
  }
  prefixes.sort((a, b) => b[0].length - a[0].length);
  return Array.from({ length: 9 }, (_, i) => {
    const apps = [...new Set(windows.filter(w => w.workspace === String(i + 1)).map(w => w['app-name']))].sort();
    return apps.map(app => exact.get(app) ?? prefixes.find(([prefix]) => app.startsWith(prefix))?.[1] ?? ':default:').join('') || '—';
  });
}

if (require.main === module) {
  let values;
  try {
    const fontPath = process.env.SKETCHYBAR_APP_FONT || path.join(process.env.HOME, 'Library/Fonts/sketchybar-app-font.ttf');
    const hyprspace = process.env.HYPRSPACE_BIN || 'hyprspace';
    const windows = JSON.parse(execFileSync(hyprspace,
      ['list-windows', '--all', '--format', '%{workspace}%{app-name}', '--json'],
      { encoding: 'utf8', timeout: 3000, stdio: ['ignore', 'pipe', 'pipe'] }));
    values = labels(windows, readIcons(fs.readFileSync(fontPath)));
  } catch (error) {
    console.error(`workspace apps: ${error.message}`);
    values = Array(9).fill('?'); // Unavailable is different from an empty workspace.
  }
  execFileSync('sketchybar', values.flatMap((label, i) => ['--set', `space.${i + 1}`, `label=${label}`]), { timeout: 3000 });
}

module.exports = { readIcons, labels };
