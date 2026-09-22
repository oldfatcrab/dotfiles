# LazyVim

## Current configuration

`home/dot_config/nvim/` vendors the small LazyVim starter source,
`lazyvim.json`, and a reviewed `lazy-lock.json`. The selected extras cover
languages, coding, picker/explorer, formatting, tests, UI, chezmoi, dotfiles,
GitHub, and VS Code. The sole personal plugin spec renders supported
Catppuccin Mocha override keys from the canonical palette and selects
`catppuccin-mocha`. Runtime plugin data, cache, state, and bootstrap remain
unmanaged; lockfile updates follow a successful target sync.

## Omarchy reference and divergence

Omarchy's [Neovim package](https://github.com/omacom/omarchy-pkgs/tree/77212489259697324f331eeefe735848fdc552f9/pkgbuilds/omarchy-nvim)
starts from LazyVim but adds Arch setup/refresh behavior, cache seeding,
Wayland/MIME integration, and a runtime theme system. This source takes the
"own your configuration" posture but does not copy its package/runtime model.
[omarchy-neovim-gap-research.md](../omarchy-neovim-gap-research.md) records
the verified gap analysis and intentionally excluded features.

## Validation boundary

Render the palette plugin spec and run source checks. After an authorized
target sync, use `:LazyHealth`; do not treat a rendered source tree as proof
of plugin installation or healthy runtime behavior.
