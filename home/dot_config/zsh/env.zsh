# =============================================================================
# Environment Variables — sourced by ~/.zshrc for interactive shells.
#
# Convention (per Zsh best practices):
#   ~/.zprofile  → PATH, brew shellenv (login shells, after macOS path_helper)
#   ~/.zshrc     → interactive config: aliases, prompt, plugins, and this file
#
# PATH is set in ~/.zprofile. This file uses `typeset -U` as a safety net
# to deduplicate any PATH entries that may accumulate from subshells.
# =============================================================================

# Prevent duplicate entries in PATH and FPATH
typeset -U path fpath

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"

# ---------------------------------------------------------------------------
# Locale
# ---------------------------------------------------------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# ---------------------------------------------------------------------------
# Bat (modern cat replacement)
# ---------------------------------------------------------------------------
export BAT_THEME="Dracula"

# Color man pages with bat (from Omarchy)
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ---------------------------------------------------------------------------
# FZF (fuzzy finder)
# ---------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --border --height=60%"
export FZF_COMPLETION_OPTS='--border --info=inline'

# CTRL-R: Interactive history search with preview & clipboard support
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# ---------------------------------------------------------------------------
# Zsh History
# ---------------------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${HOME}/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries from history
setopt HIST_FIND_NO_DUPS       # Do not display duplicates in search
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks from history
setopt HIST_SAVE_NO_DUPS       # Do not save duplicates in history file
setopt SHARE_HISTORY           # Share history between all sessions
setopt APPEND_HISTORY          # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY      # Write to history file immediately
