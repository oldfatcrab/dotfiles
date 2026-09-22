# Omarchy Neovim gap research

**Research date:** 2026-09-22
**Scope:** Compare the current official Omarchy `omarchy-nvim` package with
this repository's tracked `home/dot_config/nvim/`. Keybindings are explicitly
out of scope. This is research only; it does not authorize configuration or
target-machine changes.

## What Omarchy configures

Omarchy's current Neovim configuration lives in the
[`omarchy-nvim` package source](https://github.com/omacom/omarchy-pkgs/tree/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim),
not the main Omarchy repository. It builds the LazyVim starter, overlays its
own Lua and plugin files, runs `:Lazy! sync`, and seeds both configuration and
plugin data for new users. The package then offers a setup command that leaves
an existing configuration alone by default, and an explicit refresh command
that backs it up and replaces it. [PKGBUILD](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/PKGBUILD),
[setup command](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/omarchy-nvim-setup)

Its selected LazyVim extra is only `editor.neo-tree`; the remainder is the
starter plus these small Omarchy-specific behaviours:

| Omarchy behaviour | Status here | Classification |
| --- | --- | --- |
| `neo-tree` | Present, along with 48 additional selected LazyExtras in `home/dot_config/nvim/lazyvim.json`. | Already covered; no Omarchy extra is missing. |
| Absolute line numbers and disabled global autoformat. | `home/dot_config/nvim/lua/config/options.lua` has no active overrides, so it retains LazyVim defaults. | Intentional preference needs a user decision, not a missing capability. [Omarchy options](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/lua/config/options.lua) |
| OSC 52 remote clipboard for tmux, SSH, and Herdr; Wayland clipboard fallback. | No equivalent local Neovim module. | Meaningful only if remote-terminal copy/paste is a real workflow. Omarchy's implementation reads Linux `/proc` and uses `wl-copy`/`wl-paste`, so it must not be copied to macOS. [Omarchy remote clipboard](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/lua/config/remote_clipboard.lua) |
| 18 installed colorschemes, active-theme hot reload, and transparent highlight backgrounds. | One rendered Catppuccin Contrast override is deliberately selected in `home/dot_config/nvim/lua/plugins/personal/catppuccin.lua.tmpl`. | Intentionally not applicable: `DECISIONS.md` requires one canonical palette and explicitly excludes a theme-switching runtime. [theme inventory](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/lua/plugins/all-themes.lua), [hot reload](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/lua/plugins/omarchy-theme-hotreload.lua), [transparency](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/plugin/after/transparency.lua) |
| Suppress LazyVim/Neovim news alerts and Snacks scrolling animation. | Local selection includes `mini-animate`; no local news override. | Preference differences, not functional gaps. Do not add either without a concrete annoyance. [news](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/lua/plugins/disable-news-alert.lua), [scrolling](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/lua/plugins/snacks-animated-scrolling-off.lua) |
| Prebuilt Lazy plugin cache, setup/refresh command, active-theme symlink, and `xdg-mime` Neovim file associations. | Lazy.nvim bootstraps under the user's XDG data directory; runtime data, state, and cache are unmanaged. `EDITOR` and `VISUAL` already point to `nvim`. | Not applicable to macOS chezmoi. This repository's accepted LazyVim decision intentionally keeps runtime artifacts unmanaged; `xdg-mime` is Linux-specific. [package build](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/PKGBUILD), [setup command](https://raw.githubusercontent.com/omacom/omarchy-pkgs/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim/omarchy-nvim-setup) |

## Result

There is one potential macOS follow-up: decide whether remote-terminal OSC 52
clipboard support is needed. Everything else Omarchy adds is either already
covered by the larger LazyVim selection, a user-interface preference, or tied
to Omarchy's Linux package/theme system and conflicts with the accepted
single-palette, source-only model. Keybindings were not inspected.

## Local evidence

- `home/dot_config/nvim/lazyvim.json`
- `home/dot_config/nvim/lua/config/options.lua`
- `home/dot_config/nvim/lua/plugins/personal/catppuccin.lua.tmpl`
- `home/dot_config/nvim/lua/config/lazy.lua`
- `home/dot_config/zsh/dot_zshenv`
- `DECISIONS.md` — 2026-09-22 “Vendor LazyVim configuration and render shared theming”
