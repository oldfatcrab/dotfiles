# zsh-vi-mode

## Current configuration

`home/dot_config/zsh/vi-mode.zsh.tmpl` sets blinking block cursors for normal,
visual, and visual-line modes; a blinking beam for insert; and a blinking
underline for operator-pending mode. It renders visual selection colours from
the canonical palette. Because zsh-vi-mode initializes lazily and replaces ZLE
widgets, `zvm_after_init` reloads fzf bindings and installs Ctrl-Left/Right;
the command-mode hook installs the same word navigation there.

## Omarchy reference and divergence

Omarchy's Bash input bindings are not a zsh-vi-mode configuration. This is a
local modal-editing choice. The separate macOS run-after hook disables Mission
Control's Ctrl-Left/Right Space shortcuts so Ghostty can receive the sequences.

**Sources:** [Omarchy Bash loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/rc)
and [input bindings](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/inputrc).
No Omarchy zsh-vi-mode source exists.

## Validation boundary

Render and run `zsh -n`; after authorized apply, inspect the terminal sequence
and both ZLE modes. Do not change the shell binding if macOS consumes the key.
