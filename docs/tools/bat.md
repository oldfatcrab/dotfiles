# bat and bat-extras

## Current configuration

`home/dot_config/bat/config` selects Catppuccin Contrast and concise display.
The rendered TextMate theme lives beside it; the run-on-change hook rebuilds
bat's cache. `aliases.zsh` maps `cat`, `less`, `man`, `grep`, `rg`, `watch`,
and `diff` to bat/bat-extras workflows. `batfind` and `batlog` are explicit
helpers, while `find` and `tail` remain native commands; `batdiff` uses delta
only when it exists. Zsh global `-h`/`--help` aliases render help through bat.

## Omarchy reference and divergence

Omarchy's [shell-tools workflow](https://omarchy.org/manual/shell-tools/)
likewise treats bat as an ergonomic default. The local policy intentionally
uses `batman` instead of Omarchy's `tldr`, retains native `find`/`tail`, and
uses palette rendering rather than its runtime theme system.

## Validation boundary

Render the theme, run the cache hook only through authorized apply, and verify
an interactive Zsh session separately. Package presence is not inferred from
the Brewfile.
