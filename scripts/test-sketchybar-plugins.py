#!/usr/bin/env python3
"""Run plugin behavior checks without changing the live bar or system volume."""

import os
from pathlib import Path
import subprocess
import tempfile

plugins = Path(__file__).resolve().parents[1] / "home/dot_config/sketchybar/plugins"

with tempfile.TemporaryDirectory() as directory:
    bin_dir = Path(directory)
    stubs = {
        "sketchybar": '#!/bin/sh\nprintf "%s\\n" "$@"\n',
        "osascript": '#!/bin/sh\nprintf "%s\\n" "$AUDIO_TEST_SETTINGS"\n',
        "date": '#!/bin/sh\n[ "$LC_ALL" = C ] || exit 1\nexec /bin/date -j -f "%Y-%m-%d %H:%M:%S" "2026-09-26 13:14:00" "$@"\n',
    }
    for name, body in stubs.items():
        path = bin_dir / name
        path.write_text(body)
        path.chmod(0o700)
    env = dict(os.environ, PATH=f"{directory}:/usr/bin:/bin", NAME="audio")
    for settings, label, icon in [
        ("38, false", "38%", "󰕾"),
        ("0, false", "0%", "󰖁"),
        ("38, true", "mute", "󰝟"),
        ("", "", "󰕾"),
    ]:
        result = subprocess.check_output(
            ["/bin/sh", str(plugins / "executable_audio.sh")],
            env=dict(env, AUDIO_TEST_SETTINGS=settings), text=True,
        ).splitlines()
        assert result == ["--set", "audio", f"icon={icon}", f"label={label}"], result
    result = subprocess.check_output(
        ["/bin/sh", str(plugins / "executable_clock.sh")],
        env=dict(env, NAME="clock"), text=True,
    ).splitlines()
    assert result == ["--set", "clock", "label=Sep 26, 2026 13:14"], result

    for focused, state in [("1", "on"), ("2", "off")]:
        result = subprocess.check_output(
            ["/bin/sh", str(plugins / "executable_hyprspace_workspace.sh")],
            env=dict(env, NAME="space.1", HYPRSPACE_BIN="/usr/bin/true",
                     SENDER="hyprspace_workspace_change", FOCUSED_WORKSPACE=focused),
            text=True,
        ).splitlines()
        assert result == ["--set", "space.1", f"background.drawing={state}",
                          f"icon.highlight={state}"], result

print("PASS: audio, clock format, and workspace focus colors")
