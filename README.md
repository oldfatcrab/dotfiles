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
├── AGENTS.md           # instructions for automated contributors
├── CLAUDE.md           # pointer to AGENTS.md for Claude
├── Brewfiles/          # shared and personal Homebrew Bundle manifests
├── DECISIONS.md        # durable design decisions and Omarchy divergences
├── docs/               # implementation history, research, and agent conventions
├── themes/             # portable palette data for future app configurations
├── home/               # maps to $HOME
│   ├── dot_zshenv      # bootstrap into the XDG Zsh directory
│   ├── dot_config/zsh/ # managed Zsh startup files
│   ├── dot_config/zsh/dot_p10k.zsh.tmpl # Powerlevel10k configuration rendered from the palette
│   ├── dot_config/ghostty/config.tmpl # Ghostty configuration rendered from the palette
│   ├── run_once_before_00-install-homebrew.sh.tmpl
│   ├── run_onchange_before_20-install-brew-packages.sh.tmpl
│   └── run_after_40-disable-mission-control-space-shortcuts.sh.tmpl
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
- [docs/implementation-history.md](docs/implementation-history.md) indexes
  every implementation commit after `889d46408030fdc3d20c09a9595b7bacbe075536`;
  its entries point back to the current source of truth rather than prescribing
  target-machine actions.
- [docs/post-889d464-tooling.md](docs/post-889d464-tooling.md) maps that
  commit history to the current configuration, its Omarchy inspiration, and
  explicit macOS/Zsh boundaries; its linked research note cites the official
  Omarchy manual and quattro source tree.
- Package declarations do not claim that a target machine has already been
  configured.
- `home/dot_config/zsh/dot_p10k.zsh.tmpl` renders the Powerlevel10k
  configuration from `themes/catppuccin-contrast.toml`. The shared Brewfile
  installs Powerlevel10k, and `.zshrc` loads its theme before `$ZDOTDIR/.p10k.zsh`.
- `home/dot_config/zsh/fzf.zsh.tmpl` renders fzf's Catppuccin-style colors from the
  same palette while retaining the existing fzf command and options.
- `home/dot_config/vivid/themes/catppuccin-contrast.yml.tmpl` renders `LS_COLORS`
  from the same palette for Zsh and Carapace file completions, while
  `home/dot_config/carapace/styles.json.tmpl` renders Carapace value and
  description styles.
- `themes/catppuccin-contrast.toml` is the canonical palette data for terminal
  and editor configurations. `home/dot_config/ghostty/config.tmpl` renders
  Ghostty's colors from it, including its named, deeper ANSI bold ramp, and
  manages the Mac substitute for Omarchy's Linux-only `foot`: Liga SFMono Nerd
  Font, a `Ctrl+\`` quick terminal, 50 MiB scrollback, and Homebrew-owned
  updates.
- `themes/codex-catppuccin-contrast.json.tmpl` renders a ChatGPT desktop
  Appearance import token from the same palette. It retains the observable
  built-in `catppuccin` ID because `codex-theme-v1` has no published schema.
- `home/dot_config/bat/config` sets the Catppuccin Contrast theme and concise
  interactive style. Interactive Zsh aliases replace `cat`, `less`, `man`,
  `rg`, `watch`, and `diff` with bat or bat-extras equivalents, and colorize
  `grep` results through batgrep. The explicit `batfind` and `batlog` functions
  render find results and followed logs without changing native `find` or
  `tail`; `batdiff` uses delta when available.
- `home/dot_config/fastfetch/config.jsonc` derives from Fastfetch example 25,
  adds a title header, seven-line logo offset, and wider 56-column table;
  omits development-tool probes; reports display name/resolution/refresh rate,
  keyboard, mouse, sound, and CPU/GPU temperatures; renders Uptime red with
  login time only; and prints the normal then bright ANSI palette as two rows
  of circled dots beneath the logo. The palette placement deliberately uses
  ANSI cursor positioning tied to the default macOS logo's 34-column indent.
- `home/dot_config/btop/btop.conf` selects btop's managed truecolor Catppuccin
  Contrast theme, rendered by
  `home/dot_config/btop/themes/catppuccin_contrast.theme.tmpl` from the
  canonical palette.
- `home/dot_config/nvim/` is the vendored LazyVim starter configuration. Its
  Catppuccin override renders the canonical palette on every machine as a
  Mocha color override, and `lazyvim.json` records selected LazyExtras; plugin
  data, state, and cache remain unmanaged. Commit `lazy-lock.json` to record
  reviewed plugin revisions, and update it only after a successful
  target-machine sync.
- `home/dot_config/zsh/vi-mode.zsh.tmpl` configures blinking zsh-vi-mode
  cursors, palette-derived selection highlighting, and fzf widget restoration
  after the plugin's deferred initialization.
- `vscode/settings.json.tmpl` is the canonical VS Code user-settings template;
  OS-specific source paths render it to VS Code's native user-settings location.
- `home/run_after_40-disable-mission-control-space-shortcuts.sh.tmpl` disables
  macOS Mission Control's Ctrl-Left/Right Space shortcuts so Ghostty can pass
  them to zsh-vi-mode.
- On macOS, the Homebrew package hook registers the managed `openjdk` bundle
  with the system Java wrappers, requesting `sudo` only when the link is absent
  or points elsewhere.

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
- Run `scripts/validate-source.sh` before handoff to render templates, check
  managed shell and JSON syntax, and check the Git diff.
- Never store secrets in plaintext; use chezmoi's supported secret-management
  or encryption workflow when secrets are needed.
- Update this README or `TODO.md` when user-facing behavior or roadmap status
  changes. Contributor-specific rules belong in `AGENTS.md`.
- Record intentional differences from Omarchy in `DECISIONS.md`.

## Roadmap

See [TODO.md](TODO.md) for the Omarchy-inspired roadmap. It is a planning
reference, not a commitment to reproduce Omarchy or its Linux-specific behavior
on macOS.
