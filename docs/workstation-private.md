# Private workstation compatibility

The public dotfiles repository owns portable macOS behavior. The optional
`workstation-private` repository owns personal workstation choices that should
not be published, currently the personal Homebrew cask list.

It does **not** own Codex instructions, agent profiles, model routing, MCP policy,
or other agent configuration. Those belong in the separate private
`ai-workspace` repository.

## Directory contract

```text
Brewfiles/Brewfile.personal
scripts/bootstrap.sh
```

The private bootstrap supports `--check`, `--dry-run`, and `--apply`.
It checks or applies the personal Brewfile only.

## Rebuild order

1. Apply the public portable dotfiles layer.
2. Clone and check/apply `workstation-private` for personal applications.
3. Clone and check/apply `ai-workspace` independently for agent configuration.

The layers are intentionally independent. Do not use chezmoi or the workstation
bootstrap to overwrite `~/.codex/AGENTS.md` or `~/.codex/config.toml`.
