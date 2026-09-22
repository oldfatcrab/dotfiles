#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

while IFS= read -r -d '' template; do
  chezmoi execute-template --file "$template" >/dev/null

  case "$template" in
    themes/codex-catppuccin-contrast.json.tmpl) chezmoi execute-template --file "$template" | sed 's/^codex-theme-v1://' | jq -e . >/dev/null ;;
    *.json.tmpl) chezmoi execute-template --file "$template" | jq -e . >/dev/null ;;
    *.sh.tmpl) chezmoi execute-template --file "$template" | bash -n ;;
    home/dot_config/zsh/*.tmpl) chezmoi execute-template --file "$template" | zsh -n ;;
  esac
done < <(find home themes vscode -type f -name '*.tmpl' -print0)

zsh -n home/dot_zshenv home/dot_config/zsh/*.zsh home/dot_config/zsh/dot_zprofile home/dot_config/zsh/dot_zshenv home/dot_config/zsh/dot_zshrc
git diff --check
