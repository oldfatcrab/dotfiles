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
│   ├── dot_zshenv      # bootstrap into the XDG Zsh directory
│   ├── dot_config/zsh/ # managed Zsh startup files
│   ├── dot_config/zsh/dot_p10k.zsh.tmpl # Powerlevel10k configuration rendered from the palette
│   ├── dot_config/ghostty/config.tmpl # Ghostty configuration rendered from the palette
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
  live in `Brewfiles/`, Zsh startup files live in `home/dot_config/zsh/`, and
  action order lives in `home/run_*.tmpl`.
- `home/dot_zshenv` defaults `XDG_CONFIG_HOME` to `~/.config` and bootstraps
  the complete Zsh startup set from `~/.config/zsh`.
- [DECISIONS.md](DECISIONS.md) records durable choices; [TODO.md](TODO.md)
  records deferred work. Neither replaces the source files.
- Package declarations do not claim that a target machine has already been
  configured.
- `home/dot_config/zsh/dot_p10k.zsh.tmpl` renders the Powerlevel10k
  configuration from `themes/catppuccin-contrast.toml`. The shared Brewfile
  installs Powerlevel10k, and `.zshrc` loads its theme before `$ZDOTDIR/.p10k.zsh`.
- `themes/catppuccin-contrast.toml` is the canonical palette data for terminal
  and editor configurations. `home/dot_config/ghostty/config.tmpl` renders
  Ghostty's colors from it, including its named, deeper ANSI bold ramp, and
  manages the Mac substitute for Omarchy's Linux-only `foot`: Liga SFMono Nerd
  Font, a `Ctrl+\`` quick terminal, 50 MiB scrollback, and Homebrew-owned
  updates.
- `home/dot_config/bat/config` sets the Catppuccin Contrast theme and concise
  interactive style. Interactive Zsh aliases replace `cat`, `less`, `man`,
  `rg`, `watch`, and `diff` with bat or bat-extras equivalents, and colorize
  `grep` results through batgrep. The explicit `batfind` and `batlog` functions
  render find results and followed logs without changing native `find` or
  `tail`; `batdiff` uses delta when available.
- `home/dot_config/zsh/vi-mode.zsh.tmpl` configures blinking zsh-vi-mode
  cursors, palette-derived selection highlighting, and fzf widget restoration
  after the plugin's deferred initialization.

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
