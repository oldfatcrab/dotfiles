# fzf

## Current configuration

`home/dot_config/zsh/fzf.zsh.tmpl` renders FZF colours from the canonical
palette, sets `fd --type f --hidden --strip-cwd-prefix` as the default command,
and selects reverse inline layout. Ctrl-R shows a hidden three-line preview,
toggles it with Ctrl-/, and copies the selected command with Ctrl-Y through
`pbcopy`. `.zshrc` sources Homebrew's fzf key bindings and completion after
Carapace registration.

## Omarchy reference and divergence

Omarchy includes fzf and loads Bash key bindings/completion conditionally. The
local choice preserves fzf's native widgets in Zsh but does not copy Omarchy's
Bash paths or aliases. Its old fzf-tab experiment remains commented only:
fzf-tab is neither installed nor loaded.

**Sources:** [Omarchy shell-tools manual](https://omarchy.org/manual/shell-tools/)
and [Bash init](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/init).

## Validation boundary

Render the template and run `zsh -n`; test bindings only in a fresh interactive
target shell. The command assumes `fd` and `pbcopy`, both intentional macOS
workflow dependencies.
