# Private workstation directory contract

Create this layout in your own private repository:

```text
Brewfiles/Brewfile.personal
stow/codex/.codex/AGENTS.md  # generated from private template, ignored by Git
stow/codex/.codex/config.toml
stow/codex/.codex/agents/...
stow/codex/.config/codex-secure/credentials.env
codex-secure/build.sh
scripts/bootstrap.sh
```

`scripts/bootstrap.sh` handles `--check`, `--dry-run`, and `--apply`.
Check mode reports missing tools and collisions. Apply mode projects selected
files with `stow --no-folding`, installs personal packages and runtimes, builds
Codex Secure, and runs its doctor. Store only `op://` references in
`credentials.env`; adapt [the example](credentials.env.example) to your own
vault and item names. The private AGENTS source is a template; generate the
ignored Stow output before projection. Keep runtime files outside Git.
