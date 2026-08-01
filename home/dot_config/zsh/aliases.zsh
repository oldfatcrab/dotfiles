# =============================================================================
# Aliases — sourced by ~/.zshrc for interactive shells.
#
# Migrated from Omarchy (omarchy/default/bash/aliases) and adapted for
# macOS + Zsh. Linux-specific aliases are marked with TODO.
# =============================================================================

# ---------------------------------------------------------------------------
# File System (eza — modern ls replacement)
# ---------------------------------------------------------------------------
if command -v eza &>/dev/null; then
    # eza aliases are provided by OMZP::eza via zinit in .zshrc
    alias lt='eza --tree --level=2 --long --icons=auto --git'
    alias lta='lt -a'
fi

# ---------------------------------------------------------------------------
# Fuzzy Finder (fzf + bat)
# ---------------------------------------------------------------------------
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'

# ---------------------------------------------------------------------------
# Navigation
# ---------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ---------------------------------------------------------------------------
# Editors (Neovim as default)
# ---------------------------------------------------------------------------
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'

# ---------------------------------------------------------------------------
# Modern CLI Replacements (bat-extras ecosystem)
# ---------------------------------------------------------------------------
if command -v prettybat &>/dev/null; then
    alias cat='prettybat --style=full --paging=never -p'
    alias less='prettybat --style=full'
fi

if command -v batgrep &>/dev/null; then
    alias rg='batgrep --color=auto --paging=never'
fi

if command -v batman &>/dev/null; then
    alias man='batman'
fi

if command -v batwatch &>/dev/null; then
    alias watch='batwatch --color=auto'
fi

if command -v batdiff &>/dev/null; then
    alias diff='batdiff --color=auto --paging=never'
fi

# ---------------------------------------------------------------------------
# Global Aliases (pipe help pages through bat)
# ---------------------------------------------------------------------------
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# ---------------------------------------------------------------------------
# Tools (from Omarchy)
# ---------------------------------------------------------------------------
alias d='docker'
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias t='tmux attach || tmux new -s Work'

# Compression (from Omarchy fns/compression)
alias decompress="tar -xzf"

# ---------------------------------------------------------------------------
# AI Coding Tools (from Omarchy — uncomment as needed)
# ---------------------------------------------------------------------------
# alias c='opencode --auto'
# alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode bypassPermissions'
# alias cy='codex -s danger-full-access -a never'
