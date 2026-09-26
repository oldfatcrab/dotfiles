#!/usr/bin/env python3
"""Check portable settings without reading host credentials or applying files."""
import json
from pathlib import Path
import subprocess
import tomllib

ROOT = Path(__file__).resolve().parents[1]
AGENTS = ROOT / "home/dot_codex/agents"


def render(source, personal):
    return subprocess.check_output(
        ["chezmoi", "--override-data", json.dumps({"is_personal_machine": personal}),
         "execute-template", "--with-stdin", "--file",
         "home/dot_codex/modify_private_config.toml"],
        input=source, text=True, cwd=ROOT,
    )


sample = '''
[projects."/host/project"]
trust_level = "untrusted"
[mcp_servers.local]
command = "/host/tool"
[desktop]
hostOnly = "keep"
[hooks.state.local]
trusted_hash = "sentinel"
'''
expected_agents = {
    "explorer.toml": ("explorer", "gpt-6-luna", "xhigh"),
    "worker.toml": ("worker", "gpt-6-luna", "xhigh"),
    "sol_worker.toml": ("sol_worker", "gpt-6-sol", "medium"),
    "sol_high_worker.toml": ("sol_high_worker", "gpt-6-sol", "high"),
}
for filename, expected in expected_agents.items():
    agent = tomllib.loads((AGENTS / filename).read_text())
    assert (agent["name"], agent["model"], agent["model_reasoning_effort"]) == expected
    assert agent["description"] and agent["developer_instructions"]
for personal in (False, True):
    output = render(sample, personal)
    config = tomllib.loads(output)
    original = tomllib.loads(sample)
    for section in ("projects", "mcp_servers", "hooks"):
        assert config[section] == original[section], section
    assert config["desktop"]["hostOnly"] == "keep"
    assert ("appearanceTheme" in config["desktop"]) == personal
    assert ("memories" in config) == personal
    assert config["model"] == "gpt-6-astra"
    assert config["agents"]["default_subagent_model"] == "gpt-6-luna"
    assert config["model_reasoning_effort"] == "low"
    assert config["agents"]["default_subagent_reasoning_effort"] == "xhigh"
    assert config["agents"]["enabled"] is True
    assert config["agents"]["max_concurrent_threads_per_session"] == 3
    assert tomllib.loads(render(output, personal)) == config
    assert tomllib.loads(render("", personal))["model"] == "gpt-6-astra"
    print(f"PASS personal={personal}: bootstrap, host-state preservation, idempotence")
