# dotfiles

Minimal, macOS-oriented dotfiles managed with
[chezmoi](https://www.chezmoi.io/). This repository deliberately starts with
only the deployment framework; it does not yet manage a shell, editor,
terminal, or application configuration.

## Repository layout

```text
├── .chezmoi.toml.tmpl  # prompts once for is_personal_machine
├── .chezmoiignore.tmpl # conditional ignore rules
├── .chezmoiroot        # sets home/ as the chezmoi source root
├── .agents/AGENTS.md   # instructions for automated contributors
├── Brewfiles/          # shared and personal Homebrew Bundle manifests
├── DECISIONS.md        # durable design decisions and Omarchy divergences
├── home/               # maps to $HOME
│   ├── run_once_before_00-install-homebrew.sh.tmpl
│   ├── run_onchange_before_00-install-packages.sh.tmpl
│   └── run_onchange_before_20-install-brew-packages.sh.tmpl
└── TODO.md             # product and implementation roadmap
```

`Brewfile.base` applies on every machine and contains the shared shell-tool
baseline. `Brewfile.personal` is included only when `is_personal_machine` is
true and contains selected personal applications. The package safety-net list
is intentionally empty.

## Common workflow

```bash
# Add a regular configuration file.
chezmoi add ~/.gitconfig

# Add a machine-aware template.
chezmoi add --template ~/.some-machine-specific-file

# Inspect before making any target changes.
chezmoi status
chezmoi diff
chezmoi apply
```

Use `chezmoi data` to inspect available template data, `chezmoi ignored` to
check conditional paths, and `chezmoi doctor` to diagnose setup problems.

## Development policy

- Keep changes small and review `chezmoi diff` before applying them.
- Never store secrets in plaintext; use chezmoi's supported secret-management
  or encryption workflow when secrets are needed.
- Update this README or `TODO.md` when user-facing behavior or roadmap status
  changes. Contributor-specific rules belong in `.agents/AGENTS.md`.
- Record intentional differences from Omarchy in `DECISIONS.md`.

## Roadmap

See [TODO.md](TODO.md) for the Omarchy-inspired capability inventory and
acceptance criteria. It is a planning reference, not a commitment to reproduce
Omarchy or its Linux-specific behavior on macOS.
