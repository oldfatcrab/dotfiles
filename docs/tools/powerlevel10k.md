# Powerlevel10k prompt

## Current configuration

`home/dot_config/zsh/dot_p10k.zsh.tmpl` renders the two-line transient P10K
layout from `themes/catppuccin-contrast.toml`. Interactive `.zshrc` first
sources Homebrew's P10K theme, then this generated configuration. The prompt
does not parse palette data at shell runtime.

## Omarchy reference and divergence

Omarchy's Bash initialization uses Starship when it is available. This
repository evaluated Starship and removed it because reproducing the selected
P10K adjacency/layout would require custom rendering. P10K is therefore a
deliberate preference divergence, while palette-derived colours retain the
shared visual-system principle.

**Sources:** [Omarchy Bash init](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init)
and [Bash loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/rc).
They establish the Bash/Starship baseline; Omarchy has no P10K source.

## Validation boundary

Render with chezmoi and run `zsh -n` on the result. A successful render does
not prove Homebrew has installed P10K or that an interactive target shell has
loaded it.
