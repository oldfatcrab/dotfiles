#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

tmux_palette_color() {
  awk -v name="$1" '$0 == "[colors]" { in_colors = 1; next } /^\[/ { in_colors = 0 } in_colors && $1 == name { gsub(/"/, "", $3); print $3 }' themes/catppuccin-contrast.toml
}

while IFS= read -r -d '' template; do
  chezmoi execute-template --file "$template" >/dev/null

  case "$template" in
    themes/codex-catppuccin-contrast.json.tmpl) chezmoi execute-template --file "$template" | sed 's/^codex-theme-v1://' | jq -e . >/dev/null ;;
    *.json.tmpl) chezmoi execute-template --file "$template" | jq -e . >/dev/null ;;
    *.sh.tmpl) chezmoi execute-template --file "$template" | bash -n ;;
    home/dot_config/zsh/*.tmpl) chezmoi execute-template --file "$template" | zsh -n ;;
    home/dot_config/tmux/tmux.conf.tmpl)
      tmux_socket="chezmoi-source-$BASHPID"
      tmux_dir=$(mktemp -d)
      tmux_config="$tmux_dir/.config/tmux/tmux.conf"
      cleanup_tmux_validation() {
        HOME="$tmux_dir" tmux -L "$tmux_socket" kill-server >/dev/null 2>&1 || true
        rm -rf "$tmux_dir"
      }
      trap cleanup_tmux_validation EXIT
      mkdir -p "$tmux_dir/.config/tmux"
      tmux_base=$(tmux_palette_color base)
      tmux_mantle=$(tmux_palette_color mantle)
      tmux_text=$(tmux_palette_color text)
      [[ -n $tmux_base && -n $tmux_mantle && -n $tmux_text ]]
      chezmoi execute-template --file "$template" >"$tmux_config"
      ln -s .config/tmux/tmux.conf "$tmux_dir/.tmux.conf"
      HOME="$tmux_dir" tmux -L "$tmux_socket" new-session -d -s source-validation 2>"$tmux_dir/tmux.stderr"
      [[ ! -s "$tmux_dir/tmux.stderr" ]]
      [[ $(HOME="$tmux_dir" tmux -L "$tmux_socket" display-message -p -F '#{E:status-left}') == *source-validation* ]]
      [[ $(HOME="$tmux_dir" tmux -L "$tmux_socket" display-message -p -F '#{E:window-status-current-format}') == *'1:'* ]]
      [[ $(HOME="$tmux_dir" tmux -L "$tmux_socket" show-options -gv status) == 2 ]]
      [[ $(HOME="$tmux_dir" tmux -L "$tmux_socket" show-options -gv 'status-format[1]') == "#[fill=$tmux_base]" ]]
      grep -F "status-style \"bg=$tmux_mantle,fg=$tmux_text\"" "$tmux_config" >/dev/null
      cleanup_tmux_validation
      trap - EXIT
      ;;
  esac
done < <(find home themes vscode -type f -name '*.tmpl' -print0)

zsh -n home/dot_zshenv home/dot_config/zsh/*.zsh home/dot_config/zsh/dot_zprofile home/dot_config/zsh/dot_zshenv home/dot_config/zsh/dot_zshrc
git diff --check
