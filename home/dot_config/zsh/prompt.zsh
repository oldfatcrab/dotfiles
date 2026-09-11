# Load Powerlevel10k before its user configuration.
if [[ -r "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"