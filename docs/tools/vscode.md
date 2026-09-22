# Visual Studio Code User Settings

## Current configuration

`vscode/settings.json.tmpl` is the one canonical body. Thin templates render
it to macOS, Linux, and Windows native VS Code User Settings paths, while
`.chezmoiignore.tmpl` excludes nonmatching trees. It selects Liga SFMono Nerd
Font, Catppuccin icons, editor/chat/terminal sizes, delayed save, and
host-language file associations for chezmoi templates. Go-template overlays
are enabled for `.tmpl` and `.chezmoitemplates`; Ghostty external-terminal
settings render only on macOS.

## Omarchy reference and divergence

Omarchy is Neovim-first and has no verified quattro VS Code User Settings
source. This is a local cross-platform client-settings design, deliberately
using native application locations rather than forcing VS Code under XDG.

**Sources:** [Omarchy development-tools manual](https://omarchy.org/manual/development-tools/)
and [quattro default tree](https://github.com/omacom/omarchy/tree/quattro/default).
No verified Omarchy VS Code User Settings source exists.

## Validation boundary

Render the matching native adapter and validate with `jq -e .`. User settings
are local defaults: Remote-SSH and workspace settings can override them.
