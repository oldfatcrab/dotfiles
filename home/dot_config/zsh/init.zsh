# =============================================================================
# Tool Initialization — sourced by ~/.zshrc for interactive shells.
#
# Each `eval` is guarded with a `command -v` check so the shell starts
# cleanly even when a tool is not yet installed.
# =============================================================================

# ---------------------------------------------------------------------------
# Zoxide (smart cd replacement)
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ---------------------------------------------------------------------------
# FZF (fuzzy finder shell integration — fzf v0.48+)
# ---------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
fi

# ---------------------------------------------------------------------------
# Mise (polyglot runtime manager — from Omarchy init)
# ---------------------------------------------------------------------------
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi
