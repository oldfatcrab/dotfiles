# zsh-syntax-highlighting

## Current configuration

`home/dot_config/zsh/syntax-highlighting.zsh.tmpl` renders the main and cursor
highlighter styles from the canonical palette, covering aliases, commands,
options, quoting, substitutions, paths, errors, and the cursor. It then sources
Homebrew's `zsh-syntax-highlighting.zsh` after all interactive widgets and
aliases have been defined.

## Omarchy reference and divergence

Omarchy's Bash shell has its own aliases/input initialization but no matching
Zsh highlighter source. The local implementation follows the shared visual
coherence goal only; it is not a port of a Bash feature or an Omarchy theme.

**Sources:** [Omarchy Bash loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/rc)
and [shell policy](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/shell).
No Omarchy zsh-syntax-highlighting source exists.

## Validation boundary

Render and run `zsh -n`; inspect a fresh interactive shell for valid and
invalid command styling. Preserve late load order, since the plugin observes
the final command-line editing setup.
