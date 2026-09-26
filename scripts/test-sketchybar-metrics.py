#!/usr/bin/env python3
"""Check cached CPU deltas and memory parsing with deterministic stubs."""

import os
from pathlib import Path
import subprocess
import tempfile

repo = Path(__file__).resolve().parents[1]
plugin = repo / "home/dot_config/sketchybar/plugins/executable_system_metrics.sh"

with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    config_dir = root / "config"
    helper = config_dir / "plugins/native_status.sh"
    helper.parent.mkdir(parents=True)
    helper.write_text(
        '#!/bin/sh\n[ "$1" = cpu ] || exit 2\n'
        'printf "%s\\n" "$NATIVE_TICKS"\n[ "$NATIVE_FAIL" != 1 ]\n'
    )
    helper.chmod(0o700)

    bin_dir = root / "bin"
    bin_dir.mkdir()
    stubs = {
        "vm_stat": '#!/bin/sh\nprintf "%s\\n" "$VM_OUTPUT"\n[ "$VM_FAIL" != 1 ]\n',
        "sysctl": '#!/bin/sh\nprintf "%s\\n" "$MEM_BYTES"\n[ "$SYSCTL_FAIL" != 1 ]\n',
        "ioreg": '#!/bin/sh\nprintf "%s\\n" "$GPU_OUTPUT"\n',
        "sketchybar": '#!/bin/sh\nprintf "%s\\n" "$@"\n',
    }
    for name, body in stubs.items():
        path = bin_dir / name
        path.write_text(body)
        path.chmod(0o700)

    env = dict(
        os.environ,
        PATH=f"{bin_dir}:/usr/bin:/bin",
        CONFIG_DIR=str(config_dir),
        VM_OUTPUT=(
            "Mach Virtual Memory Statistics: ( page size of 4096 bytes)\n"
            "Pages active: 100.\nPages wired down: 50.\n"
            "Pages occupied by compressor: 25.\n"
            "Pages stored in compressor: 900.\n"
        ),
        MEM_BYTES=str(4096 * 350),
        GPU_OUTPUT='"PerformanceStatistics" = {"Device Utilization %"=37}',
    )

    def run(cache_name, ticks, overrides=None, memory="50%"):
        cache_home = root / cache_name
        result = subprocess.check_output(
            ["/bin/sh", str(plugin)],
            env=dict(env, XDG_CACHE_HOME=str(cache_home), NATIVE_TICKS=ticks, **(overrides or {})),
            text=True,
        ).splitlines()
        assert result[0:3] == ["--set", "cpu", result[2]], result
        assert result[3:6] == ["--set", "gpu", "label=37%"], result
        assert result[6:] == ["--set", "memory", f"label={memory}"], result
        return result[2]

    assert run("sequence", "100 200") == "label=N/A"
    assert run("sequence", "130 300") == "label=30%"
    assert run("sequence", "130 300") == "label=N/A"  # Zero total delta.
    assert run("sequence", "140 320") == "label=50%"  # Zero sample rebaselines.
    assert run("sequence", "5 10") == "label=N/A"  # Counter rollback rebaselines.
    assert run("sequence", "15 30") == "label=50%"

    bad_cache = root / "bad-cache/sketchybar/cpu-ticks"
    bad_cache.parent.mkdir(parents=True)
    bad_cache.write_text("corrupt cache")
    assert run("bad-cache", "700 1000") == "label=N/A"
    assert run("bad-cache", "750 1200") == "label=25%"

    assert run("failure", "100 200") == "label=N/A"
    assert run("failure", "", {"NATIVE_FAIL": "1"}) == "label=N/A"
    assert not (root / "failure/sketchybar/cpu-ticks").exists()
    assert run("failure", "120 250") == "label=N/A"

    for bad in ["0", "invalid", ""]:
        run("invalid-memory", "100 200", {"MEM_BYTES": bad}, memory="N/A")
    run("failed-memory", "100 200", {"VM_FAIL": "1"}, memory="N/A")

    result = subprocess.check_output(["/bin/sh", str(plugin)], env=dict(env,
        XDG_CACHE_HOME=str(root / "gpu-missing"), NATIVE_TICKS="100 200", GPU_OUTPUT=""), text=True).splitlines()
    assert result[3:6] == ["--set", "gpu", "label=N/A"], result

print("PASS: CPU tick deltas, GPU utilization, failures, and resident memory accounting")
