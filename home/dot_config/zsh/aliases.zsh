# Interactive visual replacements.
alias cat='bat --paging=never --style=plain'
alias vi='nvim'
alias vim='nvim'
alias grep='batgrep --color=auto --paging=never'
alias less='bat'
alias man='batman'
alias rg='batgrep --color=auto --paging=never'
alias watch='batwatch --color=auto'
alias diff='batdiff --color=auto --paging=never'

# Explicit visual workflows. Do not replace `find` or `tail`: their full
# command-line semantics remain available through the native commands.
batfind() {
  command find "$@" -exec bat {} +
}

batlog() {
  command tail -f "$@" | command bat --paging=never --language=log
}

# batdiff delegates two-file rendering to delta when it is installed.
if (( $+commands[delta] )); then
  export BATDIFF_USE_DELTA=true
fi

# Zsh global aliases colorize any command's built-in help output.
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
