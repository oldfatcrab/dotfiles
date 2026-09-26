#!/usr/bin/env node
'use strict';
const assert = require('node:assert/strict');
const { labels, readIcons } = require('../home/dot_config/sketchybar/plugins/executable_workspace_apps.js');
const icons = [[':a:', 0xe001, ['A']], [':b:', 0xe002, ['B*']]];
const window = (workspace, app) => ({ workspace, 'app-name': app });
const before = labels([window('1', 'A'), window('1', 'A'), window('3', 'Beta'), window('9', 'Unknown')], icons);
assert.equal(before[0], '\ue001');
assert.equal(before[1], '—');
assert.equal(before[2], '\ue002');
assert.equal(before[8], ':default:');
const after = labels([window('2', 'A')], icons);
assert.equal(after[0], '—'); // Last window closed/moved out.
assert.equal(after[1], '\ue001');
assert.deepEqual(labels([], icons), Array(9).fill('—'));
assert.throws(() => labels([{}], icons));
assert.throws(() => readIcons(Buffer.alloc(0)));
// Minimal font table exercises APPM offsets without depending on installed fonts.
const payload = Buffer.from(JSON.stringify({ version: 1, icons }));
const font = Buffer.alloc(56 + payload.length);
font.writeUInt16BE(1, 4); font.write('meta', 12); font.writeUInt32BE(28, 20);
font.writeUInt32BE(1, 40); font.write('APPM', 44);
font.writeUInt32BE(28, 48); font.writeUInt32BE(payload.length, 52); payload.copy(font, 56);
assert.deepEqual(readIcons(font), icons);
assert.throws(() => readIcons(font.subarray(0, 60)));
console.log('PASS: font metadata, deduplication, moves, empty/unknown apps, invalid data');
