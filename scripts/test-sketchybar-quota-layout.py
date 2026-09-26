#!/usr/bin/env python3
"""Exercise the Codex quota adapter with stub SketchyBar IPC."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[1]
if '--live' in sys.argv:
    def query(name):
        return json.loads(subprocess.check_output(['sketchybar', '--query', name], text=True))
    items = query('bar')['items']
    names = [name for name in items if name.startswith('showy_quota.') and name != 'showy_quota.trigger']
    assert names and all(name.startswith('showy_quota.codex.') or name in
                         {'showy_quota.stale', 'showy_quota.degraded'} for name in names)
    centers = [name for name in items if name != 'showy_quota_bracket' and
               query(name)['geometry']['position'] == 'center']
    assert centers[-len(names):] == [name for name in items if name in names]
    for name in names:
        geometry = query(name)['geometry']
        assert geometry['position'] == 'center', name
        assert geometry['background']['border_width'] == 0, name
    print('PASS: live Codex-only quota at center right edge')
    sys.exit(0)

with tempfile.TemporaryDirectory() as directory:
    tmp = Path(directory)
    binary = tmp / 'sketchybar'
    binary.write_text('''#!/usr/bin/env python3
import json, os, sys
if sys.argv[1] == '--query':
    if sys.argv[2] == 'bar': print(os.environ['TEST_BAR'])
    else: print(json.dumps({'geometry': {'drawing': 'on'}}))
else:
    with open(os.environ['TEST_OUTPUT'], 'a') as f: f.write(json.dumps(sys.argv[1:]) + '\\n')
''')
    binary.chmod(0o700)
    data = tmp / 'showy-quota'
    plugin = data / 'adapters/sketchybar/plugins/showy_quota.sh'
    plugin.parent.mkdir(parents=True)
    plugin.write_text('''#!/bin/sh
test -z "${SHOWY_QUOTA_PROVIDER_REGISTRY_LOADED-}"
''')
    plugin.chmod(0o700)
    state = data / 'bin/showy-quota-state'
    state.parent.mkdir(parents=True)
    state.write_text('''#!/usr/bin/env python3
import json
print(json.dumps({'providerMetrics': [{'provider': 'codex', 'windows': {
    'primary': {'remainingPercent': 10, 'minutesUntilReset': 123},
    'secondary': {'remainingPercent': 42, 'minutesUntilReset': 3000}}}]}))
''')
    state.chmod(0o700)
    parts = ['icon', 'primary', 'secondary', 'primary_marker', 'secondary_marker', 'slot', 'label']
    names = [f'showy_quota.codex.{part}' for part in parts]
    bar = ['keyboard', 'clock', 'agent', *names, 'showy_quota_bracket']
    output = tmp / 'args.jsonl'
    env = dict(os.environ, XDG_DATA_HOME=str(tmp), TEST_BAR=json.dumps({'items': bar}),
               TEST_OUTPUT=str(output), SHOWY_QUOTA_PROVIDER_REGISTRY_LOADED='1',
               PATH=f'{tmp}:' + os.environ['PATH'])
    subprocess.run(['node', str(root / 'home/dot_config/sketchybar/plugins/executable_quota_update.js')],
                   env=env, check=True)
    calls = [json.loads(line) for line in output.read_text().splitlines()]
    assert calls[0] == ['--add', 'item', 'showy_quota.codex.detail', 'center']
    args = calls[-1]
    assert args.count('position=center') == len(names) + 1
    assert args.count('background.border_width=0') == len(names) + 1
    assert args.count('click_script=open -a Codex') == len(names) + 1
    assert 'label=5h 10%, 2h 3min' in args
    assert 'label=7d 42%, 2d 2h 0min' in args
    order = args[args.index('--reorder') + 1:]
    assert order[:3] == ['keyboard', 'clock', 'agent']
    assert order.index('showy_quota.codex.icon') < order.index('showy_quota.codex.slot')
    assert order.index('showy_quota.codex.slot') < order.index('showy_quota.codex.detail')
    assert order.index('showy_quota.codex.detail') < order.index('showy_quota.codex.label')
    assert len(order) == len(set(order)) == len(bar) + 1
print('PASS: Codex quota text, center order, click target, and clean upstream environment')
