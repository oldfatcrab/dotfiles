# Omarchy reference research

**Research date:** 2026-09-22
**Scope:** primary-source reference for the tools managed after commit
`889d46408030fdc3d20c09a9595b7bacbe075536`. This is a comparison aid, not
an instruction to copy Linux settings into this macOS chezmoi source.

## What is being borrowed

Omarchy describes itself as an opinionated Arch, Hyprland, and Quickshell
system: a complete, aesthetics-and-productivity-oriented desktop, deliberately
terminal-heavy rather than a familiar macOS or Windows clone. Its useful
inspiration here is therefore coherent tool integration and intentional visual
defaults, not feature parity or its Linux runtime.

The manual's shell-tools chapter selects ergonomic CLI replacements and binds
them into the shell: fzf, zoxide, ripgrep, eza, fd, bat, tldr, yt-dlp, and
try. This repository follows that *selection-and-integration* idea where it
has a reviewed macOS need (notably bat, eza, fzf, zoxide, and ripgrep), while
keeping individual commands, aliases, palette, and packages as its own
source-of-truth choices.

Sources: [Manual welcome](https://omarchy.org/manual/),
[Shell tools](https://omarchy.org/manual/shell-tools/).

## Configuration model and category boundary

Omarchy documents a two-layer model: package-owned defaults in
`/usr/share/omarchy`, with user-owned `~/.config` overrides that survive
updates. Its Dotfiles guide lists Hyprland, the Omarchy shell JSON, terminal,
and XCompose as user customization areas, and also supports executable event
hooks below `~/.config/omarchy/hooks/<event>.d/`.

The `quattro/config` tree is the user-tool layer (including terminal emulators,
btop, Git, Hyprland, LazyGit, tmux, and browser-related settings); the
`quattro/default` tree additionally covers Bash, agents, environment, GPG,
package/system integration, theming, and Wayland session infrastructure.
Those trees are category inventories, not proof that any particular current
tool setting is suitable for macOS.

This repository instead keeps desired configuration in chezmoi source,
renders it where needed, and only deploys it on explicit `chezmoi apply`.
That shares Omarchy's clear ownership boundary but replaces packaged-default
overrides and hooks with a versioned, deterministic source model.

Sources: [Dotfiles manual](https://omarchy.org/manual/dotfiles/),
[quattro config](https://github.com/omacom/omarchy/tree/quattro/config),
[quattro default](https://github.com/omacom/omarchy/tree/quattro/default).

## Current tool categories: reference versus local decision

| Category | Omarchy reference | Local boundary |
| --- | --- | --- |
| Terminal / Ghostty | Omarchy's Ghostty config imports the active runtime theme and contains Hyprland-oriented settings such as `async-backend=epoll`. | The managed Ghostty template renders the fixed Catppuccin Contrast palette. Linux state paths and epoll are not portable design input. |
| Shell tools | Bash aliases and init wire eza, fzf, zoxide, bat and other selected utilities into the interactive workflow. | Zsh uses its own aliases and native integration files; install declarations do not establish target availability. |
| btop and colours | btop selects `color_theme="current"`, delegating palette choice to Omarchy's active theme. | The btop theme is rendered deterministically from `themes/catppuccin-contrast.toml`; no runtime theme switcher is managed. |
| Prompt / editor tooling | Bash initialises Starship when interactive and available; the manual positions Neovim and terminal tools as part of the desktop. | The repository deliberately uses Powerlevel10k and managed LazyVim source. This is a preference/platform divergence, not an Omarchy gap. |
| Completion | Bash loads bash-completion and then fzf completion/key bindings when their files exist. | Zsh runs `compinit`, then Carapace, vivid-derived completion colours, and fzf widgets. The richer Zsh completion stack is intentional. |
| Desktop, system, and app integration | Default sources also own Hyprland, systemd, pacman, udev, audio, fonts, and Wayland-session details. | These are out of scope for the macOS source unless a separately reviewed native equivalent exists. VS Code, Codex-theme, Fastfetch, and Neovim settings are local additions, not purported Omarchy ports. |

Sources: [Ghostty config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/ghostty/config),
[btop config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/btop/btop.conf),
[Bash aliases](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/aliases),
[Bash init](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init),
[config tree](https://github.com/omacom/omarchy/tree/quattro/config),
[default tree](https://github.com/omacom/omarchy/tree/quattro/default).

## Bash and this repository's Zsh

Omarchy has a small ordered Bash entry point: its `rc` sources environment,
shell policy, aliases, functions, and initialisation, then reads input bindings
only for interactive shells. Its shell policy appends history, ignores duplicate
and space-prefixed commands, uses a 32,768-entry history, conditionally loads
bash-completion, and disables command hashing for mise. The package `bashrc`
first ensures the shared environment is present, returns before interactive
defaults for non-interactive shells, then loads that `rc`; the documented
user extension point is `~/.bashrc`.

This repository has the analogous separation of non-interactive bootstrap from
interactive behaviour, but makes the boundary XDG-first: root `.zshenv` sets
`ZDOTDIR` and loads `~/.config/zsh/.zshenv`; interactive `.zshrc` owns history,
completion, plugins, prompt, aliases, syntax highlighting, and vi mode. The
Zsh policy intentionally goes beyond the Omarchy Bash baseline with incremental
shared history and duplicate-expiry options, while its configuration is split
into reviewable modules and rendered palette inputs. Both favour guarded,
optional integration; only Omarchy couples that policy to an Arch/Wayland
package runtime and an editable Bash override file.

Sources: [Bash rc](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/rc),
[Bash shell policy](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/shell),
[Bash environment](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/envs),
[Bash init](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init),
[Dotfiles manual](https://omarchy.org/manual/dotfiles/).

## Maintenance rule

Use Omarchy as a primary-source reference for a concrete local configuration
decision. Record a durable divergence in `DECISIONS.md`; keep implementation
facts in the managed source, not in this research note.
