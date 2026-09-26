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
        ("38, false", "38%", "􀊩"),
        ("0, false", "0%", "􀊡"),
        ("38, true", "mute", "􀊣"),
        ("", "", "􀊩"),
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
    assert result == ["--set", "clock", "label=Sat 26 Sep 13:14"], result

    for focused, state in [("1", "on"), ("2", "off")]:
        result = subprocess.check_output(
            ["/bin/sh", str(plugins / "executable_hyprspace_workspace.sh")],
            env=dict(env, NAME="space.1", HYPRSPACE_BIN="/usr/bin/true",
                     SENDER="hyprspace_workspace_change", FOCUSED_WORKSPACE=focused),
            text=True,
        ).splitlines()
        assert result == ["--set", "space.1", f"background.drawing={state}",
                          f"icon.highlight={state}", f"label.highlight={state}"], result

    battery = bin_dir / "battery.sh"
    battery.write_bytes(subprocess.check_output(["chezmoi", "execute-template", "--file", str(plugins / "executable_battery.sh.tmpl")]))
    pmset = bin_dir / "pmset"
    pmset.write_text('#!/bin/sh\nprintf "%s\\n" "$BATTERY_TEST"\n')
    pmset.chmod(0o700)
    for snapshot, icon, label, background in [
        ("Now drawing from 'AC Power'", "􀡸", "AC 􀋦", "0xffbac2de"),
        ("95%; discharging", "􁠸", "95%", "0xffbac2de"),
        ("20%; discharging", "􁠸", "20%", "0xffe6ba60"),
        ("5%; discharging", "􁠸", "5%", "0xffe64f5c"),
        ("AC Power 50%; charging", "􀫯", "50%", "0xffbac2de"),
    ]:
        result = subprocess.check_output(["bash", str(battery)], env=dict(env, NAME="battery", BATTERY_TEST=snapshot), text=True).splitlines()
        assert f"icon={icon}" in result and f"label={label}" in result, result
        assert "icon.color=0xff313244" in result and f"icon.background.color={background}" in result, result

print("PASS: audio, clock, workspace focus, and SF power symbols")
