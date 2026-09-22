# Zsh startup and interactive shell policy

## Current configuration

Root `home/dot_zshenv` defaults `XDG_CONFIG_HOME`, sets an unexported
`ZDOTDIR`, and sources `$ZDOTDIR/.zshenv`. The XDG `.zshenv` owns environment
defaults; `.zprofile` enters the correct Homebrew architecture; `.zshrc`
returns for non-interactive shells and owns `GPG_TTY`, Fastfetch, history,
completion, plugins, prompt, aliases, and ZLE layers. Empty `.zlogin` and
`.zlogout` intentionally add no behavior.

History is stored under `ZDOTDIR`, uses a 1,024,000-entry in-memory/save limit,
and enables append, incremental append, shared history, duplicate expiry,
space-ignore, and duplicate-search options. `zinit` loads `zsh-eza`; zoxide
replaces `cd`; autosuggestions loads after fzf/completion setup.

## Omarchy reference and divergence

Omarchy's [shell tools](https://omarchy.org/manual/shell-tools/) use Bash.
Its [Bash loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/rc)
orders package-owned environment, shell policy, aliases, functions, and init;
the documented user extension point is `~/.bashrc`. Both configurations guard
interactive work and optional tools. The local choice is XDG-first, modular
Zsh source and shared incremental history, not a package-default-plus-override
Bash system coupled to Arch, mise, and a desktop session.

## Validation boundary

Run `zsh -n` on rendered or edited startup files and test an isolated
interactive/login shell after an authorized apply. Do not move interactive
state into `.zshenv` merely to mirror Omarchy's Bash fragments.
