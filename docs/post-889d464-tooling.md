# Post-`889d464` tooling and Omarchy alignment

This document accounts for every implementation commit after
`889d46408030fdc3d20c09a9595b7bacbe075536`. It describes the **current**
configuration; package manifests do not prove target installation or runtime
validation. [Omarchy reference research](omarchy-reference-research.md)
contains the primary-source basis, and
[implementation history](implementation-history.md) is the compact timeline.

## Shared boundary

Omarchy is an opinionated Arch/Hyprland/Quickshell desktop. This repository
borrows its coherent, terminal-heavy tool choices and visual intentionality,
not Linux desktop feature parity. Omarchy keeps package defaults in
`/usr/share/omarchy` and user overrides in `~/.config`; this repository keeps
the desired state in versioned chezmoi source, renders templates from one
palette, and deploys only through an explicitly requested `chezmoi apply`.
There is no local Omarchy runtime theme service, plugin/hook runtime, or
Wayland/session layer.

## Current configuration by tool

### Homebrew baseline and platform substitutions

`Brewfiles/Brewfile.base` declares shared CLI, TUI, terminal, editor, agent,
service, and font tools; `Brewfiles/Brewfile.personal` holds personal casks.
The package hook runs `brew bundle` and has a narrow OpenJDK registration
guard. Non-core taps declare trust individually.

This follows Omarchy's curated-ready-to-work idea while using Homebrew and
native macOS applications. Raycast covers the launcher/clipboard role and
Ghostty the terminal role. Chromium remains deferred. Omarchy's gaming,
Windows VM, Arch package manager, systemd, udev, and Wayland components are
not managed here; accepted decisions record the selected substitutions.

### Palette, Powerlevel10k, and Ghostty

`themes/catppuccin-contrast.toml` is the sole colour authority. P10K,
Ghostty, fzf, syntax highlighting, vivid, Carapace, btop, LazyVim, and the
Codex import render colours from it. Its enhanced Frappé accents, Mocha neutral
ramp, and terminal-only bright ANSI ramp intentionally keep terminal bold
colours separate from editor and prompt roles.

`home/dot_config/zsh/dot_p10k.zsh.tmpl` is loaded after Homebrew's P10K theme.
The earlier Starship experiment is superseded and no Starship source remains.
Omarchy uses a runtime desktop theme and an interactive Bash/Starship path;
this repository adopts visual cohesion but chooses deterministic palette
rendering and P10K instead of a runtime theme switcher.

`home/dot_config/ghostty/config.tmpl` renders terminal, selection, search, and
ANSI colours; it sets Liga SFMono Nerd Font at 16pt, bright-bold ANSI behavior,
14px padding, 50 MiB scrollback, long-command notifications, Homebrew-owned
updates, and a `Ctrl+\`` quick terminal. Omarchy's Ghostty config imports an
active runtime theme and includes Linux/Hyprland settings such as epoll. This
source deliberately does not depend on Omarchy state paths, Hyprland placement,
GTK controls, or a Linux backend; its default `foot` terminal is not a macOS
target.

### Zsh philosophy versus Omarchy Bash

The root `home/dot_zshenv` is a minimal XDG bridge: default
`XDG_CONFIG_HOME`, set an unexported `ZDOTDIR`, source `$ZDOTDIR/.zshenv`.
The real startup set sits in `home/dot_config/zsh/`: `.zshenv` has XDG/editor
defaults, `.zprofile` enters the architecture-specific Homebrew environment,
and `.zshrc` owns all interactive behavior. Empty `.zlogin` and `.zlogout`
make intentional absence explicit.

Omarchy's Bash entry point first supplies a shared environment, returns before
interactive defaults, then sources package-maintained environment, shell,
aliases, functions, init, and input fragments; users extend `~/.bashrc`. Both
separate non-interactive setup from interactive features and guard optional
tools. Their philosophies differ:

| Concern | Omarchy Bash | This repository's Zsh |
| --- | --- | --- |
| Ownership | Package defaults plus user override | One reviewed chezmoi source tree, explicitly applied |
| Layout | Ordered fragments under `$OMARCHY_PATH` | XDG bridge plus focused Zsh modules |
| History | Append; ignore duplicates/space; 32,768 entries | Incremental shared history, duplicate expiry/search controls; 1,024,000 entries |
| Prompt | Starship when interactive and available | Homebrew P10K rendered from the canonical palette |
| Coupling | Arch packages, mise, desktop-session environment | macOS Homebrew paths; no session-manager assumption |

The larger shared-history policy and modular source layout are intentional local
choices. `GPG_TTY`, Fastfetch, completion, prompt, aliases, and plugins remain
interactive `.zshrc` responsibilities; XDG defaults remain in `.zshenv`.

### Interactive shell tools

`aliases.zsh` provides visual aliases for `cat`, `less`, `man`, `grep`, `rg`,
`watch`, and `diff`, but deliberately does not replace `find` or `tail`;
`batfind` and `batlog` are explicit alternatives. `batdiff` delegates to delta
when present. `home/dot_config/bat/` selects the rendered theme and its hook
rebuilds bat's cache. `fzf.zsh.tmpl` configures fd search, key bindings,
history preview/copy behavior, and palette colours. Zoxide owns `cd`;
autosuggestions, syntax highlighting, and zsh-vi-mode load in the ordered
interactive path. Vi mode restores fzf widgets after lazy initialization and
binds Ctrl-Left/Right in both modes; a macOS hook removes the competing system
shortcut.

This follows Omarchy's ergonomic shell-tool workflow, not alias-for-alias
compatibility. `batman` replaces its `tldr` choice, global help aliases are
local, and macOS key interception is native. The boundary preserves generic
Unix command semantics instead of making visual aliases universal.

### Completion: vivid and Carapace

Zsh calls `compinit` once, generates `LS_COLORS` from the vivid template,
registers Carapace against that system, then loads fzf widgets.
`home/dot_config/carapace/styles.json.tmpl` separately renders candidate and
description styles. The commented fzf-tab material is historical; fzf-tab is
not installed or loaded.

Omarchy Bash conditionally loads bash-completion and fzf completion. The local
stack retains fzf widgets but deliberately uses native Zsh completion,
Carapace, and vivid; a second initializer or Tab-owning frontend would make
behavior less predictable.

### Fastfetch and btop

Fastfetch runs only for direct Ghostty and SSH sessions, never tmux or the VS
Code terminal. Its config derives from Fastfetch example 25, then adds macOS
device/thermal information, a title layout, and ANSI palette rows positioned
for the default macOS logo. `btop.conf` selects the rendered truecolour
`catppuccin_contrast.theme` while retaining ordinary btop interactions.

Omarchy's btop selects its current runtime theme. The local btop theme is
deterministically rendered from the palette; Fastfetch and macOS probes are
local additions, not claimed Omarchy ports. Target output may differ until
source is applied.

### VS Code, Codex, and LazyVim

`vscode/settings.json.tmpl` is one User Settings body, included by native
macOS/Linux/Windows adapter templates selected via `.chezmoiignore.tmpl`. It
sets the shared font and icon theme, keeps each chezmoi filename associated
with its host language, enables Go-template overlays, and gates Ghostty
external-terminal settings to macOS. Omarchy is Neovim-first; this is a native
VS Code adapter, not an attempt to force application paths into XDG.

`themes/codex-catppuccin-contrast.json.tmpl` renders the observed
`codex-theme-v1:` appearance import from the palette. It keeps the observed
built-in `catppuccin` ID because no schema is published; see
[codex-theme-v1-format.md](codex-theme-v1-format.md). It shares the palette
principle, but has no Omarchy counterpart.

`home/dot_config/nvim/` vendors the small LazyVim starter, selected extras,
and a reviewed lockfile. Its sole personal Catppuccin spec renders supported
Mocha override keys from the palette. Plugin data, caches, bootstrap downloads,
and target `:LazyHealth` are outside chezmoi. See
[lazyvim-chezmoi-research.md](lazyvim-chezmoi-research.md) and
[omarchy-neovim-gap-research.md](omarchy-neovim-gap-research.md). This borrows
the "own your configuration" posture, not Omarchy's plugins, keymaps, or
Linux runtime assumptions; the picker/fzf choice remains in `TODO.md`.

### Agent guidance and validation

`AGENTS.md` is the contributor contract and `CLAUDE.md` points to it;
`docs/agents/` documents issues, triage labels, and the domain-doc convention.
`scripts/validate-source.sh` renders templates, syntax-checks managed sources,
validates JSON, and checks the diff. These are repository workflow documents,
not desktop configuration. Although Omarchy has agent-oriented material, this
repository does not import its agent runtime; external actions still require
the authority stated in `AGENTS.md`.

## Commit ledger

Every implementation commit is accounted for below. Superseded work remains
only to stop old history being mistaken for current configuration.

| Commit | Resulting configuration / relationship |
| --- | --- |
| `851559f` | Added Omarchy-derived roadmap and decisions; see Shared boundary. |
| `42d388f` | Added initial shell-tool baseline; see Homebrew and Interactive shell tools. |
| `ba9ea60` | Added macOS substitutions across package categories; see Homebrew baseline. |
| `5ce7f31` | Declared Tailscale CLI and app; declaration only. |
| `dcfdc4c` | Deferred Chromium and scoped third-party tap trust; see Homebrew baseline. |
| `876fa0a` | Defined Zsh startup-file roles; see Zsh philosophy. |
| `de2daf1` | Added minimal Zsh, later relocated under XDG; see Zsh philosophy. |
| `000f784` | Added Starship experiment, later superseded; see Palette/P10K. |
| `7f7a185` | Removed Starship; retained P10K and palette source. |
| `7bb66c7` | Added palette semantic roles. |
| `75fbd1f` | Refined P10K's two-line layout. |
| `23d1d7d` | Rendered P10K colours from palette. |
| `61a4eb4` | Added palette-rendered Ghostty. |
| `aad4fe0` | Moved startup to XDG Zsh. |
| `b18e311` | Added distinct bright ANSI ramp. |
| `fabfea3` | Co-located P10K with XDG Zsh. |
| `124da9c` | Added bat, fzf, syntax, vi mode, aliases, and cache hook. |
| `140c8b4` | Restored Ctrl-arrow navigation via macOS hook. |
| `d4eec2e` | Applied palette colours to fzf. |
| `77d4bf4` | Added Fastfetch and btop theme. |
| `6ecd9c1` | Added btop config and refined Fastfetch. |
| `6de0ef1` | Corrected Fastfetch JSONC. |
| `1a25c4c` | Added canonical agent workflow documentation. |
| `a0ea814` | Added Carapace and vivid completion colours. |
| `6257995` | Added cross-platform VS Code adapters. |
| `592720d` | Added Codex appearance import snapshot. |
| `c54a5af` | Vendored LazyVim starter and palette override. |
| `eb62d3c` | Added LazyVim extras, lockfile, and OpenJDK hook. |
| `2d83977` | Added initial history index; this document supplies comparison. |
| `c8f1543` | Added Neovim-gap research and source validation checks. |

## Validation boundary

Render affected templates, run the smallest relevant syntax/configuration
check, then run `scripts/validate-source.sh` and `git diff --check`. Inspect
`chezmoi status` and `chezmoi diff` before an explicitly authorized apply.
Source validation is not target runtime validation; Linux-only Omarchy settings
need a separate macOS fit decision.
