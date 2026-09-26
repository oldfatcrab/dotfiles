#!/usr/bin/env python3
"""Check native SketchyBar plugins with stubbed system and bar commands."""

import os
from pathlib import Path
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
plugins = root / "home/dot_config/sketchybar/plugins"

with tempfile.TemporaryDirectory() as tmp:
    base = Path(tmp)
    config = base / "config"
    (config / "helpers").mkdir(parents=True)
    app = base / "StatusHelper.app"
    (app / "Contents/MacOS").mkdir(parents=True)
    (config / "helpers/build-status-helper.sh").write_text(f"#!/bin/sh\nprintf '%s\\n' '{app}'\n")
    (config / "plugins").mkdir()
    (config / "plugins/native_status.sh").symlink_to(plugins / "executable_native_status.sh")
    bin_dir = base / "bin"
    cache = base / "cache"
    bin_dir.mkdir()
    calls = base / "calls"
    added = base / "added"
    (app / "Contents/MacOS/StatusHelper").write_text(
        "#!/bin/sh\n"
        "case \"$1\" in\n"
        " keyboard) echo 'ABC - Extended' ;;\n"
        " wifi) echo 'Studio Wi-Fi' ;;\n"
        " cpu) echo '100 200' ;;\n"
        " displays)\n"
        "   case \"$MONITORS\" in\n"
        "    two) printf '1\\tMi 27 NU\\t1\\n2\\tStudio\\t0\\n' ;;\n"
        "    one) printf '1\\tMi 27 NU\\t1\\n' ;;\n"
        "    fail) exit 1 ;;\n"
        "   esac ;;\n"
        "esac\n"
    )
    (app / "Contents/MacOS/StatusHelper").chmod(0o700)
    (bin_dir / "open").write_text(
        "#!/bin/sh\n"
        "mkdir -p \"$HOME/Library/Caches/local.sketchybar.StatusHelper\"\n"
        "case \"$6\" in\n"
        " wifi) printf '%s' 'Studio Wi-Fi' > \"$HOME/Library/Caches/local.sketchybar.StatusHelper/wifi\" ;;\n"
        " location) printf '%s' '12.34,56.78' > \"$HOME/Library/Caches/local.sketchybar.StatusHelper/location\" ;;\n"
        "esac\n"
    )
    (bin_dir / "scutil").write_text(
        "#!/bin/sh\n"
        "if [ \"$VPN_CONNECTED\" = yes ]; then\n"
        "  echo '* (Connected) UUID VPN (stub) \"Stub\" [VPN:stub]'\n"
        "else echo '* (Disconnected) UUID VPN (stub) \"Stub\" [VPN:stub]'; fi\n"
    )
    (bin_dir / "sketchybar").write_text(
        "#!/bin/sh\n"
        "printf '%s\\n' \"$*\" >> \"$CALLS\"\n"
        "if [ \"$1\" = --query ]; then grep -qxF \"$2\" \"$ADDED\"; exit $?; fi\n"
        "if [ \"$1\" = --add ]; then printf '%s\\n' \"$3\" >> \"$ADDED\"; fi\n"
    )
    for path in bin_dir.iterdir():
        path.chmod(0o700)

    env = dict(
        os.environ,
        PATH=f"{bin_dir}:/usr/bin:/bin",
        HOME=str(base / "home"),
        CONFIG_DIR=str(config),
        XDG_CACHE_HOME=str(cache),
        NAME="keyboard",
        CALLS=str(calls),
        ADDED=str(added),
        MONITORS="two",
        HYPRSPACE_BIN="/stub/hyprspace",
        BORDER_COLOR="0xff45475a",
        ICON_BG_COLOR="0xffbac2de",
        ICON_FG_COLOR="0xff313244",
        VPN_CONNECTED="no",
    )
    subprocess.run(["/bin/bash", str(plugins / "executable_keyboard_layout.sh")], env=env, check=True)
    env["NAME"] = "wifi"
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "wifi"], env=env, check=True)
    assert subprocess.check_output(["/bin/bash", str(plugins / "executable_native_status.sh"), "location"], env=env, text=True).strip() == "12.34,56.78"
    env["NAME"] = "vpn"
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "vpn"], env=env, check=True)
    env["VPN_CONNECTED"] = "yes"
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "vpn"], env=env, check=True)
    env["NAME"] = "display_status"
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "displays"], env=env, check=True)
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "displays"], env=env, check=True)
    assert added.read_text().splitlines() == ["display.1", "display.2"]

    env["MONITORS"] = "one"
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "displays"], env=env, check=True)
    env["MONITORS"] = "fail"
    subprocess.run(["/bin/bash", str(plugins / "executable_native_status.sh"), "displays"], env=env, check=True)

    output = calls.read_text().splitlines()
    assert "--set keyboard label=ABC - Extended" in output, output
    assert "--set wifi label=Studio Wi-Fi" in output, output
    assert "--set vpn label=off" in output and "--set vpn label=Stub" in output, output
    assert "--move display.1 before memory" in output, output
    assert any("--add item display.1 right --set display.1 icon.color=0xff313244 icon.background.drawing=on icon.background.color=0xffbac2de" in line for line in output), output
    assert any("--set display.1 icon=􀒶 label=Mi 27 NU icon.highlight=off background.border_color=0xff45475a" in line for line in output), output
    assert any("--set display.2 icon=􀒶 label=Studio icon.highlight=off" in line for line in output), output
    assert "--remove display.2" in output, output
    assert output.count("--remove display.1") == 1, output
    assert "--set display_status drawing=on icon=􀒶 label=unavailable" in output, output

print("PASS: keyboard, Wi-Fi, rounded location, VPN, display focus, hot-unplug cleanup, and query failure")
