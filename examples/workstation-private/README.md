# Private workstation directory contract

A minimal private workstation repository only needs personal machine choices
that should not live in public dotfiles.

```text
Brewfiles/Brewfile.personal
scripts/bootstrap.sh
```

The bootstrap should support `--check`, `--dry-run`, and `--apply` and
should limit itself to those personal workstation choices.

Agent configuration belongs in a separate private AI workspace. Do not copy
Codex `AGENTS.md`, `config.toml`, custom agent profiles, MCP credentials,
or agent runtime state into this repository.
