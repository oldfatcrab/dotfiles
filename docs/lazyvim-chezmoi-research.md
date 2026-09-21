# LazyVim in chezmoi: research note

**Research date:** 2026-09-22
**Scope:** manage a LazyVim starter configuration in this chezmoi repository,
with Catppuccin Contrast as the only theme customization on every managed
machine. This note does not install or apply anything.

## Recommendation

Vendor the small [LazyVim starter](https://github.com/LazyVim/starter) source
tree into `home/dot_config/nvim/`; it renders to `~/.config/nvim/`. Keep the
starter's `init.lua`, `lua/config/`, and its `lua/plugins/` import boundary,
rather than cloning the starter from a chezmoi script or treating it as a Git
submodule. LazyVim's own installation guide instructs users to remove the
starter's `.git` directory so they can place the resulting configuration in
their own repository. That makes the chezmoi repository the single source of
truth for the configuration while preserving ordinary, reviewable file diffs.

Keep `~/.local/share/nvim/`, `~/.local/state/nvim/`, and `~/.cache/nvim/`
unmanaged. The starter bootstraps lazy.nvim below `stdpath("data")`, and
lazy.nvim's documented default plugin root is also below `stdpath("data")`;
these are installed runtime artifacts, not configuration. Its default lockfile
is `stdpath("config") .. "/lazy-lock.json"`, so commit the observed
`home/dot_config/nvim/lazy-lock.json`. This gives reproducible plugin revisions
without versioning plugin clones or cache.

Use exactly one local plugin-spec file:
`home/dot_config/nvim/lua/plugins/personal/catppuccin.lua.tmpl`. It returns an
identical Catppuccin configuration on every machine. Keep it within the
existing `plugins` import instead of adding a second loader: LazyVim
automatically loads `lua/plugins/`, and the starter's spec intentionally
imports LazyVim first and local `plugins` second. A local spec for the same
plugin merges with LazyVim's Catppuccin spec.

The shared spec should override the already-present `catppuccin/nvim`
plugin, set LazyVim's colorscheme to `catppuccin-mocha`, and render
`color_overrides.mocha` plus only necessary highlights from
`themes/catppuccin-contrast.toml`, using the repository's established
`include "../themes/catppuccin-contrast.toml" | fromToml` pattern. Do not
invent `contrast` as a Catppuccin flavour: upstream supports only latte,
frappé, macchiato, and mocha, while its documented `color_overrides` API is
the supported way to customize a palette. Start with color overrides; add
highlight overrides only after a specific LazyVim surface needs correction.

## Evidence

- [LazyVim installation](https://www.lazyvim.org/installation) directs users
  to clone the starter at `~/.config/nvim`, remove its `.git`, start Neovim,
  and run `:LazyHealth`.
- The current [starter bootstrap](https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua)
  imports `lazyvim.plugins` before local `plugins`, bootstraps lazy.nvim in
  `stdpath("data")`, and leaves `version = false` for current plugin commits.
- [LazyVim configuration](https://www.lazyvim.org/configuration) specifies
  that files under `lua/plugins/` are loaded automatically and shows a local
  `LazyVim/LazyVim` spec selecting `catppuccin`.
- [lazy.nvim plugin-spec documentation](https://lazy.folke.io/spec) defines
  `import`, says plugin `opts` merge with parent specs, and recommends `opts`
  over custom `config` functions. Its [configuration defaults](https://lazy.folke.io/configuration)
  locate plugins under `stdpath("data")` and the lockfile under
  `stdpath("config")`.
- [Catppuccin for Neovim](https://github.com/catppuccin/nvim) documents its
  lazy.nvim spec, supported flavours, and `color_overrides`; setup must occur
  before loading the colorscheme.

## Minimal implementation and validation sequence

1. Import the existing target's starter-compatible configuration and lockfile
   into `home/dot_config/nvim/`; exclude `.git` metadata and runtime paths.
2. Add the single shared Catppuccin template. Do not add a second theme plugin.
   Selected LazyExtras and their supporting tools are recorded separately in
   `home/dot_config/nvim/lazyvim.json` and `Brewfiles/Brewfile.base`.
3. Render the template and run `git diff --check`.
4. After explicit permission to apply, start `nvim` and run `:LazyHealth`.
   Target-machine validation is separate from source validation.
