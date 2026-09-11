export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--layout=reverse --inline-info'
export FZF_CTRL_R_OPTS="
  --preview 'printf \"%s\\n\" {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(printf %s {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'
"

# fzf-tab augments Zsh completion; it has its own fzf settings and previews.
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
if [[ -n ${LS_COLORS-} ]]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-flags '--height=50%'

zstyle ':completion:*:*:*:*:processes' command 'ps -u "$USER" -o pid,user,comm -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps -p $word -o command -w | tail -n +2'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--height=50%' '--preview-window=down:3:wrap'

zstyle ':fzf-tab:complete:*:*' fzf-preview '
printf "\033[1m%s\033[0m\n\n" "${(Q)group}"
if [[ "${(Q)group}" == "[file]" ]]; then
  if [[ -n "${(Q)realpath}" ]]; then
    if [[ -d "${(Q)realpath}" ]]; then
      eza --tree --level=2 --icons --color=always "${(Q)realpath}"
    elif [[ $(file -bL --mime-type "${(Q)realpath}") == text/* ]]; then
      bat --color=always --style=plain --paging=never -- "${(Q)realpath}"
    fi
  fi
elif [[ "${(Q)group}" == "[alias]" ]]; then
  printf "%s\n" "${(Q)desc}"
elif [[ "${(Q)group}" =~ "command]$" ]]; then
  command -v -- "${(Q)word}"
elif [[ "${(Q)group}" == "[parameter]" ]]; then
  printf "%s\n" "${(P)word}"
fi'
