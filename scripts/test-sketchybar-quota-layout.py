#!/usr/bin/env python3
"""Exercise the Codex quota adapter with stub SketchyBar IPC."""
import json
import os
from pathlib import Path
import subprocess
import struct
import sys
import tempfile

root = Path(__file__).resolve().parents[1]
config = subprocess.check_output(
    ['chezmoi', 'execute-template', '--file', str(root / 'home/dot_config/showy-quota/config.env.tmpl')],
    text=True,
)
settings = dict(line.split('=', 1) for line in config.splitlines() if line and not line.startswith('#'))
assert int(settings['SHOWY_QUOTA_SKETCHYBAR_ICON_WIDTH']) + int(settings['SHOWY_QUOTA_SKETCHYBAR_PROVIDER_ICON_FONT_PADDING_RIGHT']) == 38
assert settings['SHOWY_QUOTA_SKETCHYBAR_PROVIDER_ICON_FONT'] == 'sketchybar-app-font:Regular:18.0'
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
    config = tmp / 'config'
    (config / 'plugins').mkdir(parents=True)
    (config / 'helpers').mkdir()
    for name in ['quota_update.js', 'workspace_apps.js']:
        (config / 'plugins' / name).write_bytes((root / 'home/dot_config/sketchybar/plugins' / f'executable_{name}').read_bytes())
    (config / 'helpers/quota_sketchybar_env.sh').write_bytes((root / 'home/dot_config/sketchybar/helpers/quota_sketchybar_env.sh').read_bytes())
    adapter = str(config / 'plugins/quota_update.js')
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
    plugin.write_text('''#!/usr/bin/env bash
test -z "${SHOWY_QUOTA_PROVIDER_REGISTRY_LOADED-}"
printf '20' > "$TEST_PERCENT_FILE"
sketchybar --add item showy_quota.codex.label left --set showy_quota.codex.label label.font.size=11 label.width=32 label.padding_right=4
sketchybar --set showy_quota.codex.label drawing=on label='Codex 5h 10%, 2h 3min' label.color=0xffcdd6f4 label.width=32 label.align=left background.color=0x00000000 background.height=0 \
  --set showy_quota.codex.icon drawing=on icon.drawing=on width=32 click_script='open -b com.openai.codex' \
  --set showy_quota.codex.primary drawing=on slider.percentage=10 y_offset=4 \
  --set showy_quota.codex.slot drawing=on width=83 \
  --set other label=untouched
''')
    plugin.chmod(0o700)
    state = data / 'bin/showy-quota-state'
    state.parent.mkdir(parents=True)
    state.write_text('''#!/usr/bin/env python3
import json, os
from pathlib import Path
percent = int(Path(os.environ['TEST_PERCENT_FILE']).read_text())
print(json.dumps({'providerMetrics': [{'provider': 'codex', 'windows': {
    'primary': {'remainingPercent': percent, 'minutesUntilReset': 123},
    'secondary': {'remainingPercent': 42, 'minutesUntilReset': 3000}}}]}))
''')
    state.chmod(0o700)
    parts = ['icon', 'primary', 'secondary', 'primary_marker', 'secondary_marker', 'slot', 'label']
    names = [f'showy_quota.codex.{part}' for part in parts]
    bar = ['keyboard', 'clock', 'agent', *names, 'showy_quota_bracket']
    output = tmp / 'args.jsonl'
    percent_file = tmp / 'percent'
    payload = json.dumps({'version': 1, 'icons': [[':openai:', 0xe001, ['ChatGPT']]]}).encode()
    font = bytearray(56 + len(payload))
    struct.pack_into('>H', font, 4, 1)
    font[12:16] = b'meta'
    struct.pack_into('>I', font, 20, 28)
    struct.pack_into('>I', font, 40, 1)
    font[44:48] = b'APPM'
    struct.pack_into('>II', font, 48, 28, len(payload))
    font[56:] = payload
    font_path = tmp / 'app.ttf'
    font_path.write_bytes(font)
    env = dict(os.environ, XDG_DATA_HOME=str(tmp), TEST_BAR=json.dumps({'items': bar}),
               TEST_OUTPUT=str(output), TEST_PERCENT_FILE=str(percent_file), SHOWY_QUOTA_PROVIDER_REGISTRY_LOADED='1',
               SHOWY_QUOTA_SKETCHYBAR_ICON_BG_COLOR='0xffbac2de',
               SHOWY_QUOTA_SKETCHYBAR_ICON_FG_COLOR='0xff313244',
               SKETCHYBAR_APP_FONT=str(font_path), PATH=f'{tmp}:' + os.environ['PATH'])
    subprocess.run(['node', adapter],
                   env=env, check=True)
    calls = [json.loads(line) for line in output.read_text().splitlines()]
    initial = calls[0]
    assert initial[:6] == ['--add', 'item', 'showy_quota.codex.label', 'left', '--set', 'showy_quota.codex.label']
    assert initial[-10:] == ['position=center', 'background.border_width=0', 'click_script=open -b com.openai.codex',
                            'label.font=SF Pro:Regular:10.0', 'label.width=104', 'label.padding_left=0',
                            'label.padding_right=0', 'padding_left=0', 'padding_right=0', 'y_offset=5'], initial
    first = calls[1]
    def properties(name):
        start = first.index(name) + 1
        end = first.index('--set', start) if '--set' in first[start:] else len(first)
        return dict(arg.split('=', 1) for arg in first[start:end] if '=' in arg)
    label = properties('showy_quota.codex.label')
    assert label['label'] == '20%, 2h 3min', label
    assert label['label.width'] == '104' and label['label.font'] == 'SF Pro:Regular:10.0', label
    assert label['y_offset'] == '5' and label['position'] == 'center', label
    icon = properties('showy_quota.codex.icon')
    assert icon['icon'] == '\ue001', icon
    assert icon['position'] == 'center' and icon['icon.color'] == '0xff313244', icon
    assert icon['align'] == 'left' and icon['icon.align'] == 'center' and icon['icon.y_offset'] == '-1', icon
    assert icon['icon.background.color'] == '0xffbac2de' and icon['icon.background.drawing'] == 'on', icon
    assert icon['icon.background.height'] == '24' and icon['icon.background.y_offset'] == '-1', icon
    assert properties('showy_quota.codex.primary')['background.border_width'] == '0'
    assert properties('other')['label'] == 'untouched'
    assert calls[2] == ['--add', 'item', 'showy_quota.codex.detail', 'center']
    args = calls[-1]
    assert args.count('position=center') == len(names) + 1
    assert args.count('background.border_width=0') == len(names) + 1
    assert args.count('click_script=open -b com.openai.codex') == len(names) + 1
    assert ['--set', 'showy_quota.codex.icon', 'align=left'] == args[args.index('align=left') - 2:args.index('align=left') + 1]
    assert 'label=20%, 2h 3min' in args
    assert 'label=42%, 2d 2h 0min' in args
    order = args[args.index('--reorder') + 1:]
    assert order[:3] == ['keyboard', 'clock', 'agent']
    assert order.index('showy_quota.codex.icon') < order.index('showy_quota.codex.slot')
    assert order.index('showy_quota.codex.slot') < order.index('showy_quota.codex.detail')
    assert order.index('showy_quota.codex.detail') < order.index('showy_quota.codex.label')
    assert len(order) == len(set(order)) == len(bar) + 1
    output.write_text('')
    subprocess.run(['node', adapter, '--layout-only'],
                   env=dict(env, TEST_BAR=json.dumps({'items': order})), check=True)
    assert '--reorder' not in json.loads(output.read_text().splitlines()[-1])
print('PASS: Codex quota text, center order, click target, and clean upstream environment')
