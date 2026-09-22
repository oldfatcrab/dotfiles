# Catppuccin Contrast palette

## Current configuration

`themes/catppuccin-contrast.toml` is the only colour-value authority. It keeps
enhanced Frappé accents on the stock Mocha neutral ramp, semantic role tables,
and a separate deeper ANSI bright ramp (`crimson` through `verdigris`).
Templates consume named keys; no consumer should copy its hex values.

## Omarchy reference and divergence

Omarchy changes a desktop-wide active theme at runtime. This repository borrows
the value of coherent appearance but deliberately has no runtime theme service:
chezmoi renders the selected palette into each consumer. The palette is a local
derived Catppuccin configuration, not an Omarchy theme and not an upstream
Catppuccin flavour.

**Sources:** [Omarchy themes manual](https://omarchy.org/manual/themes/) and
[Omarchy Ghostty config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/ghostty/config).
They establish the runtime-theme comparison; neither defines this palette.

## Consumers and validation

P10K, Ghostty, fzf, syntax highlighting, vivid, Carapace, btop, LazyVim, and
the Codex import consume it. Render the affected template and validate its
native output; edit this file only for a palette-wide decision. See the
accepted palette and bold-ANSI decisions in `DECISIONS.md`.
