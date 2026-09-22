# btop

## Current configuration

`home/dot_config/btop/btop.conf` points to the rendered truecolour theme at
`$XDG_CONFIG_HOME/btop/themes/catppuccin_contrast.theme`, keeps the theme
background, enables vim keys and terminal synchronized output, uses braille
graphs, and configures CPU/memory/network/process panels. The theme itself is
rendered from the canonical palette.

## Omarchy reference and divergence

Omarchy's [btop config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/btop/btop.conf)
sets `color_theme = "current"`, delegating colour selection to its active
runtime theme. This repository deliberately selects one deterministic rendered
theme instead. General btop interaction choices are compatible inspiration;
the colour ownership model is not.

## Validation boundary

Render the theme and inspect btop after authorized deployment. Do not infer
Linux-only sensor, swap, disk, or GPU behavior from Omarchy's configuration.
