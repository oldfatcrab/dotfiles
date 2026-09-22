# Ghostty terminal

## Current configuration

`home/dot_config/ghostty/config.tmpl` renders background, foreground, cursor,
selection, search, and all sixteen ANSI colours from the canonical palette. It
sets Liga SFMono Nerd Font at 16pt, bright ANSI for bold, one-cell taller lines,
balanced 14px padding, 50 MiB scrollback, block blinking cursor, SSH shell
integration, and completion notifications after ten unfocused seconds. It also
configures a 40%-high auto-hiding top quick terminal on `Ctrl+\`` and disables
Ghostty auto-update because Homebrew owns updates.

## Omarchy reference and divergence

Omarchy's [Ghostty config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/ghostty/config)
imports its active runtime theme and includes GTK/Hyprland-oriented settings;
its default terminal is foot. This repository uses Ghostty as the macOS
terminal role and renders a fixed local palette. The retained `epoll` setting
is explicitly pending reassessment in `DECISIONS.md`, not evidence of macOS
fit; state paths, window placement, and runtime theme machinery are not copied.

## Validation boundary

Render the template to a temporary file, then run
`/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config --config-file /path/to/rendered-config`.
Validate behavior only after an authorized target apply.
