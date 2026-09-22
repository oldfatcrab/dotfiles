# Carapace completion

## Current configuration

After a single `compinit`, `.zshrc` sources `carapace _carapace zsh` so
Carapace registers completers with Zsh's initialized completion system.
`home/dot_config/carapace/styles.json.tmpl` renders description and value
styles from the canonical palette. Case-insensitive and substring matchers are
Zsh styles, not Carapace configuration.

## Omarchy reference and divergence

Omarchy's Bash stack uses bash-completion and fzf completion rather than
Carapace. The local divergence is intentional: Carapace supplies CLI argument
candidates while Zsh owns the completion lifecycle. It is not a replacement
claim for every fzf-tab frontend feature.

**Sources:** [Omarchy shell-tools manual](https://omarchy.org/manual/shell-tools/)
and [Bash init](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init).
No Omarchy Carapace configuration source was found.

## Validation boundary

Render `styles.json.tmpl`, validate the JSON, run `zsh -n`, and start a new
interactive shell. Do not add another `compinit` or a second Tab-owning plugin.
