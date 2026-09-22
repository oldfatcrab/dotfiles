# vivid `LS_COLORS`

## Current configuration

`home/dot_config/vivid/themes/catppuccin-contrast.yml.tmpl` maps the canonical
palette to vivid's full file-category hierarchy. Interactive `.zshrc` runs
`vivid generate` on that rendered theme, exports `LS_COLORS`, and passes the
split value to Zsh's completion `list-colors` style.

## Omarchy reference and divergence

Omarchy's shell-tool philosophy values readable terminal output, but its Bash
and runtime-theme stack does not make this vivid template an Omarchy port. The
local design uses one palette as the source for file listings and completion
candidates, with no active-theme service.

**Sources:** [Omarchy shell-tools manual](https://omarchy.org/manual/shell-tools/)
and [Bash shell policy](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/shell).
No Omarchy vivid configuration source was found.

## Validation boundary

Render to a temporary file, then run
`vivid generate /path/to/rendered-theme >/dev/null` and `zsh -n` on the
rendered Zsh file. The complete vivid hierarchy is required; do not trim it to
only locally visible categories.
