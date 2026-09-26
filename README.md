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
│   ├── dot_config/tmux/tmux.conf.tmpl # native tmux configuration rendered from the palette
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
- [docs/tools/README.md](docs/tools/README.md) indexes dedicated configuration
  documents for each managed tool. Each records its Omarchy reference,
  intentional macOS/Zsh divergence, and validation boundary;
  [omarchy-tool-source-index.md](docs/omarchy-tool-source-index.md)
  cites the official Manual and quattro tree.
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
- `home/dot_config/tmux/tmux.conf.tmpl` configures Omarchy's non-keybinding
  tmux behavior: panes, sessions, mouse, clipboard, and CSI-u extended keys.
  Its session/window/state/hostname modules follow Omarchy and its colours
  render directly from Contrast; the two-row rounded presentation is local.
  The managed `~/.tmux.conf` symlink makes it the default startup
  configuration. TPM, theme runtimes, auto-restoration, and Linux-specific
  Omarchy launch/theme hooks remain absent.
- `home/dot_config/hyprspace/config.toml` retains nine workspaces and the
  configured macOS bindings. `home/dot_config/borders/executable_bordersrc.tmpl`
  renders a 12pt border using Contrast `lavender` for focus and `surface1`
  for inactive windows. SketchyBar's
  template uses the same palette for a three-section bar: workspaces/front app,
  centered calendar and status read-outs, and macOS-native system launchers.
  Workspaces 1–9 show deduplicated application icons from Hyprspace windows,
  with a chevron separating them from the front app. Empty workspaces show
  `—`; failed queries show `?`. One shared query refreshes on events and every
  two seconds, including window moves/closures. The Node plugin reads the
  installed app font's embedded APPM mapping (font 3+), so icons stay aligned
  with font updates without a separate downloaded mapping script.
  It deliberately does not emulate Omarchy's Linux-only Quickshell panels,
  tray, or device-management backends. Colors follow Catppuccin roles: Base bar,
  Surface0 items, Text labels, Subtext1 secondary icons, and Lavender focused
  workspace border/number. Battery icons use Yellow at 10–29% and Red below
  10%; normal levels stay neutral. Item backgrounds have symmetric 6pt
  outer content padding and a 6pt icon–label gap; backgrounds are 26pt high
  with 1pt outlines. Labels and workspace numbers use `SF Pro:Semibold:15.0` within SketchyBar
  only. SF Symbols supply the display and power pictograms; audio retains a
  Nerd Font override. Bluetooth is omitted. The bar explicitly loads the installed
  SF Pro font on reload. `topmost=window` floats above application windows.
  Homebrew-managed `sketchybar-toggle` starts from the bar configuration:
  the top 3px hides the bar, moving below 50px restores it after 150ms.
  It polls mouse position; it does not detect whether a native menu is open.
  Reloading replaces the current user's helper instance. If the helper is
  unavailable, the bar still starts. To recover a hidden bar manually, run
  `sketchybar --bar hidden=off y_offset=0` after stopping the helper.
  The Raycast button is removed. The centered clock reads `Sat 26 Sep 13:14` (24-hour time) and
  refreshes every 30 seconds; volume responds to events with a two-second mute fallback.
  The centered keyboard item reads the current input method's localized name
  through Carbon, including Chinese input methods, rather than the last keyboard
  layout preference. A distributed input-source event and five-second fallback
  refresh it. Weather fetches wttr.in every 15 minutes, shows condition icons and
  Celsius, and displays `N/A` on failure. Set `weather-location` to a city to
  pin it; otherwise the native helper supplies coordinates rounded to two
  decimal places to wttr.in. If location is unavailable, it displays `N/A`.
  Wi-Fi shows the CoreWLAN SSID when macOS permits access, otherwise
  `unavailable`; it polls every 30 seconds because `wifi_change` does not work
  reliably on newer macOS. The single-run `StatusHelper.app` requests location
  access only when explicitly launched in authorization mode; grant it yourself:
  `open -W -a ~/.local/share/sketchybar/StatusHelper.app --args authorize`.
  Rebuilding this locally signed app may require granting access again.
  It caches readings locally and exits. No privacy permissions are changed
  automatically. The VPN item reports connected macOS network services from
  `scutil --nc list`; proxy-only tools and unmanaged tunnels may not appear.
  Display names come from Hyprspace, with the focused display highlighted in
  Lavender, refreshed on events and every two seconds. CPU refreshes every
  second using differences in native host CPU ticks; memory shows resident
  active + wired + compressor pages as a percentage of physical RAM, excluding
  reclaimable inactive pages. This is not Activity Monitor's Memory Pressure.
  The native Swift helper builds into the XDG data directory only after source changes;
  Xcode Command Line Tools are required. `plugins/` contains update scripts,
  `helpers/` contains native support code; component declarations remain in
  `sketchybarrc`. SketchyBar does not require an `items/` directory.
  Device buttons open their corresponding System Settings panes. Homebrew's
  outdated count is informational, without an unrelated Settings shortcut.

  After reviewing the scoped chezmoi diff, apply the changed files and run
  `sketchybar --reload` for the bar, or `~/.config/borders/bordersrc` for borders.
  Reloading the bar keeps the currently running binary; executing bordersrc
  sends the configured options to the existing Borders process.

  **Target-machine limitation (2026-09-26):** SketchyBar 2.24.0 runs from a
  temporary one-line background-layer patch, verified by repeated clicks. Its
  temporary LaunchAgent was manually restored after being absent from the GUI
  session. The Homebrew service remains unloaded; the temporary registration
  and binary do not survive logout/reboot. See TODO for persistent installation.

  Catppuccin references: [style guide](https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md),
  [Waybar](https://github.com/catppuccin/waybar), and
  [Polybar](https://github.com/catppuccin/polybar). The ports supply palette
  variables rather than a mandatory bar design. Contrast keeps its custom
  accents and follows their semantic roles; it is not an official flavor.
  SketchyBar's [plugin sharing discussion](https://github.com/FelixKratz/SketchyBar/discussions/12)
  is the community discovery entry point. Candidates discussed but not installed:
  native caffeinate toggle. Now Playing integration is intentionally omitted.
- [showy-quota](https://github.com/enieuwy/showy-quota) uses CodexBar's provider
  data for SketchyBar quota strips. CodexBar, Bash 4+, jq, and the app-icon font
  are declared in `Brewfiles/Brewfile.base`; upstream showy-quota has no official
  Homebrew formula, so `bash scripts/install-showy-quota.sh` installs its pinned
  v0.9.0 release after checking the published SHA-256. The native renderer is
  included, without requiring Rust. The bar invokes the installed upstream
  rendering plugin through a local trigger, avoiding its bootstrap's exported
  registry flag bug. A small local layout adapter places Codex quota at the right
  edge of the center group, clears inherited child outlines, and shows remaining
  percentages plus reset countdowns for both five-hour and weekly windows.
  Clicking quota opens Codex; the separate agent launcher is omitted.
  `home/dot_config/showy-quota/` selects a local Contrast theme rendered from
  the canonical palette using the upstream Catppuccin role mapping. Only Codex
  is selected for this bar; authentication stays in CodexBar. Never put
  credentials in this repo.
  The adapter uses its default local `codexbar serve` lifecycle/cache, and
  provider count determines the strip width. tmux wiring is deferred in TODO.
  SF Pro and SF Symbols install through Apple's package installers and require
  interactive administrator authentication: `brew install --cask font-sf-pro sf-symbols`.
  Installing these packages does not change the macOS system font setting.
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

Squirrel custom settings live in `home/private_Library/Rime/`, deployed to
`~/Library/Rime/` on macOS. `default.custom.yaml` reserves `Ctrl+grave` for
Ghostty and disables `Ctrl+Shift+grave`, retaining only `F4` as the input scheme
switcher shortcut. Use Squirrel's **Deploy** menu after changing these settings.
Generated builds, user dictionaries, and runtime state remain unmanaged.

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

## Codex settings

Codex uses its native `~/.codex/` directory; no `CODEX_HOME` override is
required. `home/dot_codex/private_AGENTS.md.tmpl` manages global contributor guidance.
`home/dot_codex/modify_private_config.toml` updates only selected TOML fields,
preserving local project trust, MCP connections, hooks, and unrelated settings.
Astra (low by default; medium when selected) coordinates and delegates complete
work packages to Luna (xhigh), Sol (medium), or Sol (high), as described in the
global instructions. `home/dot_codex/agents/` defines portable `explorer`,
`worker`, `sol_worker`, and `sol_high_worker` roles with explicit model settings.
Explicit spawn settings and concise context keep execution
on the selected worker model. Delegation is instruction-driven, not a guaranteed
quota reduction; verify actual worker models and task usage after changes. Host/model availability still needs
verification on each machine.

Run `python3 scripts/validate-codex-settings.py` to check both personal/work
branches, first-run rendering, preservation of host-owned state, and idempotence.

Personal appearance and memory preferences render only when
`is_personal_machine` is true. The dark appearance reuses the canonical theme
template; the light appearance preserves the observed desktop settings.
Desktop appearance keys are version-sensitive; verify them after app upgrades.
UI edits to managed fields must be deliberately incorporated into source or
the next apply restores the repository values. Close the app before applying
to avoid concurrent config writes. TOML serialization may normalize formatting.

Personal background is optionally read from local `~/.codex/user-context.md`
on personal machines. Keep that file owner-readable/writable only; provision
it separately, for example from a 1Password document. It is not an automatically
loaded Codex file: the template embeds it into AGENTS.md. Conditional templates
and private permissions do not encrypt data, and rendered diffs can expose it.
No personal background, credentials, generated memories, sessions, databases,
plugin caches, machine-specific hooks, or historical command approvals are
tracked. Installed third-party skills remain installer-owned; custom skill
sources can be added individually after review.

Preview only the intended Codex targets before an explicitly authorized apply;
do not recursively add `~/.codex`. Fresh machines need their own sign-in and
local integrations. A work-machine render leaves existing personal config
fields unchanged; it is not a privacy cleanup of a previously personal host.

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
