#!/usr/bin/env python3
"""Weather contract: Celsius, conditions, and unavailable data without live HTTP."""
import json
import os
from pathlib import Path
import subprocess
import tempfile

script = Path(__file__).resolve().parents[1] / 'home/dot_config/sketchybar/plugins/executable_weather.sh'
with tempfile.TemporaryDirectory() as tmp:
    folder = Path(tmp)
    (folder / 'plugins').mkdir()
    (folder / 'plugins/native_status.sh').write_text(
        '#!/bin/sh\n[ "$LOCATION_AVAILABLE" = yes ] || exit 1\nprintf "12.34,56.78\\n"\n'
    )
    for name, body in {
        'curl': '#!/bin/sh\nfor arg do :; done\nprintf "%s" "$arg" > "$WEATHER_URL_FILE"\nprintf "%s" "$WEATHER_TEST_JSON"\n',
        'sketchybar': '#!/bin/sh\nprintf "%s\\n" "$@"\n',
    }.items():
        path = folder / name
        path.write_text(body)
        path.chmod(0o700)
    for code, temperature, icon in [('113', '26', '􀆮'), ('296', '-2', '􀇇'), ('338', '-10', '􀇥')]:
        env = dict(os.environ, PATH=f'{tmp}:' + os.environ['PATH'], CONFIG_DIR=tmp, NAME='weather',
                   SKETCHYBAR_WEATHER_LOCATION='Toronto', LOCATION_AVAILABLE='no',
                   WEATHER_URL_FILE=str(folder / 'url'),
                   WEATHER_TEST_JSON=json.dumps({'current_condition': [{'weatherCode': code, 'temp_C': temperature}]}))
        result = subprocess.check_output(['bash', str(script)], env=env, text=True).splitlines()
        assert result == ['--set', 'weather', f'icon={icon}', f'label={temperature}°C'], result
    for bad in ['{}', '<html>error</html>', '{"current_condition":[{"temp_C":"999","weatherCode":"113"}]}']:
        result = subprocess.check_output(['bash', str(script)], env=dict(env, WEATHER_TEST_JSON=bad), text=True)
        assert 'label=N/A' in result, result
    env.pop('SKETCHYBAR_WEATHER_LOCATION')
    env['LOCATION_AVAILABLE'] = 'yes'
    env['WEATHER_TEST_JSON'] = '{"current_condition":[{"temp_C":"20","weatherCode":"113"}]}'
    subprocess.check_output(['bash', str(script)], env=env, text=True)
    assert '12.34%2C56.78' in (folder / 'url').read_text()
    (folder / 'url').unlink()
    env['LOCATION_AVAILABLE'] = 'no'
    result = subprocess.check_output(['bash', str(script)], env=env, text=True)
    assert 'label=N/A' in result and not (folder / 'url').exists(), result
print('PASS: weather icon, Celsius, rounded location, and unavailable response without IP lookup')
