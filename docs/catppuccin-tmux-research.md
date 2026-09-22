# Catppuccin tmux implementation research

**Research date:** 2026-09-22

## Outcome

Catppuccin/tmux is deliberately not installed. Its documented flavours are
Latte, Frappé, Macchiato, and Mocha; this repository's Contrast palette is not
an upstream flavour. More importantly, the plugin generates status-line
options, which conflicts with retaining Omarchy's chosen native modules.

`home/dot_config/tmux/tmux.conf.tmpl` instead renders native tmux values from
`themes/catppuccin-contrast.toml`: `mantle`/`text` for the bar, `base` for its
blank spacing row, `blue`/`crust` for the session and mode accent, and
`overlay0` for inactive elements. The module selection remains Omarchy's
session, `#I:#W`, COPY/PREFIX/ZOOM state, and hostname; the two-row bar and
rounded ` … ` session badge are local visual adaptations. Its empty row uses
tmux's `fill` rather than `bg`, because `bg` cannot paint an empty format.

This avoids TPM, target-time cloning, a plugin runtime, and duplicate colour
literals. [Catppuccin/tmux](https://github.com/catppuccin/tmux) remains the
reference for optional modules, not a dependency.

## Validation

`scripts/validate-source.sh` renders the template and starts an isolated tmux
server through the managed `~/.tmux.conf` symlink. It checks the resolved
session and current-window status formats, the second-line `fill` style, and
the rendered Contrast bar roles.
