# Omarchy tool source index

**Use:** source map for the dedicated local tool documents. Omarchy is an Arch,
Hyprland, and Quickshell distribution; these links are comparison evidence, not
settings to copy into this macOS chezmoi repository. Its [Dotfiles guide](https://omarchy.org/manual/dotfiles/)
separates user overrides in `~/.config` from package defaults in `/usr/share/omarchy`.

For the shared ownership boundary, read
[Omarchy reference research](omarchy-reference-research.md); for the commit
ledger, read [implementation history](implementation-history.md). Tool-specific
configuration and validation boundaries are in `docs/tools/`.

| Local document category | Authoritative Omarchy sources | Scope caveat |
| --- | --- | --- |
| Zsh versus Bash | [shell-tools manual](https://omarchy.org/manual/shell-tools/); raw [Bash loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/rc), [shell policy](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/shell), [aliases](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/aliases), and [initialisation](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init) | Compare interactive-shell ordering, guarded integrations, aliases, and history only. Zsh/XDG startup and Zinit plugins are local decisions; Omarchy's Bash assumes its packaged Linux runtime. |
| Ghostty and palette | [terminal manual](https://omarchy.org/manual/terminal/); raw [Ghostty config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/ghostty/config) | Omarchy's default terminal is foot and this Ghostty file imports a dynamic theme and carries GTK/Hyprland tuning. Local Ghostty and the static Catppuccin Contrast palette are macOS choices. |
| tmux | [terminal manual](https://omarchy.org/manual/terminal/); raw [tmux config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/tmux/tmux.conf), [launcher](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-launch-terminal-tmux), and [Bash layouts](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/fns/tmux) | Reuse Omarchy's non-keybinding native behavior and status modules, with Contrast colours rendered directly. Hyprland launchers, Bash layouts, Linux palette injection, and Omarchy's reset tooling do not define macOS defaults. |
| Shell tools and completion | [shell-tools manual](https://omarchy.org/manual/shell-tools/); raw [Bash shell policy](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/shell), [Bash init](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init), and [aliases](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/aliases) | Use this for the product-level selection of fzf, zoxide, rg, eza, fd, and bat. Do not infer Bash completion, `tldr`, package paths, or aliases are required locally. |
| Fastfetch and btop | [TUIs manual](https://omarchy.org/manual/tuis/); raw [btop config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/btop/btop.conf) and [config tree](https://github.com/omacom/omarchy/tree/quattro/config) | btop's `current` theme is coupled to Omarchy's runtime theme. Fastfetch has no confirmed quattro configuration source; document it as a local addition, not an Omarchy port. |
| VS Code and Codex | [development-tools manual](https://omarchy.org/manual/development-tools/), [AI manual](https://omarchy.org/manual/ai/), and [default tree](https://github.com/omacom/omarchy/tree/quattro/default) | No verified Omarchy quattro source configures VS Code User Settings or Codex themes. Treat these as local cross-platform/editor choices; cite Omarchy only for workflow context. |
| LazyVim | [Neovim manual](https://omarchy.org/manual/neovim/); official [omarchy-nvim package](https://github.com/omacom/omarchy-pkgs/tree/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim), raw [PKGBUILD](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/PKGBUILD), and [setup command](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/omarchy-nvim-setup) | The Neovim package is outside the main quattro trees and includes Arch setup, caches, MIME integration, and Wayland behavior. Compare selected Lua behaviour only. |
| Homebrew and macOS boundary | [Mac support manual](https://omarchy.org/manual/mac-support/), [dotfiles manual](https://omarchy.org/manual/dotfiles/), [quattro config tree](https://github.com/omacom/omarchy/tree/quattro/config), and [default tree](https://github.com/omacom/omarchy/tree/quattro/default) | Omarchy does not define a Homebrew/macOS package model. Its pacman, systemd, udev, Hyprland, and Wayland defaults are explicit non-inputs unless a separate native equivalent is chosen. |

When a local tool has no matching Omarchy source, say so plainly. Record a
durable divergence in `DECISIONS.md`; keep implementation details in the
tool's dedicated document and managed source. Before changing behavior, read
the relevant tool document, source, accepted decision, and TODO item; render
templates and run the smallest relevant check before the source-validation
script and diff check. Target deployment remains explicitly authorized.
