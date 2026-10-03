# Private workstation directory contract

The public dotfiles repository owns portable macOS behavior. An optional
`workstation-private` repository owns personal machine choices that should not
be published, currently the personal Homebrew cask list.

It does **not** own Codex instructions, agent profiles, model routing, MCP
policy, or other agent configuration. Those belong in the separate private
`ai-workspace` repository.

## Minimal layout

```text
Brewfiles/Brewfile.personal
scripts/bootstrap.sh
```

The bootstrap should support `--check`, `--dry-run`, and `--apply` and
limit itself to those personal workstation choices.

## Rebuild order

1. Apply the public portable dotfiles layer.
2. Clone and check/apply `workstation-private` for personal applications.
3. Clone and check/apply `ai-workspace` independently for agent configuration.

The layers are intentionally independent. Do not use chezmoi or the
workstation bootstrap to overwrite `~/.codex/AGENTS.md` or
`~/.codex/config.toml`.

Keep agent credentials and secrets in 1Password or service-native credential
stores rather than either Git repository.
