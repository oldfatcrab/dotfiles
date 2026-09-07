# dotfiles

macOS-oriented dotfiles managed with [chezmoi](https://www.chezmoi.io/).
This repository manages bootstrap scripts, Homebrew package manifests, Zsh
startup files, a Powerlevel10k configuration, and a shared color palette. Terminal, editor, window-manager, and
application configuration are deliberately added only when each has a
concrete, reviewed requirement.

## Repository layout

```text
├── .chezmoi.toml.tmpl  # prompts once for is_personal_machine
├── .chezmoiignore.tmpl # conditional ignore rules
├── .chezmoiroot        # sets home/ as the chezmoi source root
├── .agents/AGENTS.md   # instructions for automated contributors
├── Brewfiles/          # shared and personal Homebrew Bundle manifests
├── DECISIONS.md        # durable design decisions and Omarchy divergences
├── themes/             # portable palette data for future app configurations
├── home/               # maps to $HOME
│   ├── dot_zprofile    # Homebrew environment for login shells
│   ├── dot_zshrc       # interactive Zsh configuration
│   ├── dot_p10k.zsh.tmpl # Powerlevel10k configuration rendered from the palette
│   ├── run_once_before_00-install-homebrew.sh.tmpl
│   ├── run_onchange_before_00-install-packages.sh.tmpl
│   └── run_onchange_before_20-install-brew-packages.sh.tmpl
└── TODO.md             # product and implementation roadmap
```

`Brewfile.base` applies on every machine and contains the shared package
baseline, including shell, TUI, GUI, browser, service, and web applications.
`Brewfile.personal` is included only when `is_personal_machine` is true and
contains selected personal applications. The package safety-net list
is intentionally empty.

## Current scope

- `chezmoi apply` bootstraps Homebrew, then synchronizes the applicable
  Brewfile manifests.
- The source files are authoritative for current behavior: package manifests
  live in `Brewfiles/`, Zsh startup files live in `home/dot_z*`, and action
  order lives in `home/run_*.tmpl`.
- [DECISIONS.md](DECISIONS.md) records durable choices; [TODO.md](TODO.md)
  records deferred work. Neither replaces the source files.
- Package declarations do not claim that a target machine has already been
  configured.
- `home/dot_p10k.zsh.tmpl` preserves the supplied Powerlevel10k configuration,
  renders its colors from `themes/catppuccin-contrast.toml`, and does not
  install or initialize Powerlevel10k yet.
- `themes/catppuccin-contrast.toml` is the canonical palette data for future
  terminal and editor configurations; it does not affect a target machine on
  its own.

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

See [TODO.md](TODO.md) for the Omarchy-inspired roadmap. It is a planning
reference, not a commitment to reproduce Omarchy or its Linux-specific behavior
on macOS.
