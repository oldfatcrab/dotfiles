#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 [--check|--dry-run|--apply]" >&2
    exit 2
}

mode=${1:---check}
[[ $# -le 1 ]] || usage
case "$mode" in --check|--dry-run|--apply) ;; *) usage ;; esac

source_dir=$(cd "$(dirname "$0")/.." && pwd -P)
private_dir=${WORKSTATION_PRIVATE_REPO:-"$HOME/.local/share/workstation-private"}
private_entry="$private_dir/scripts/bootstrap.sh"

[[ $(uname -s) == Darwin ]] || { echo "macOS is required." >&2; exit 1; }
[[ -f "$source_dir/.chezmoiroot" && $(cat "$source_dir/.chezmoiroot") == home ]] || {
    echo "Expected a chezmoi source with .chezmoiroot=home: $source_dir" >&2
    exit 1
}

if [[ ! -f "$private_entry" ]]; then
    echo "Private layer missing: $private_entry. Clone your own private repository there or set WORKSTATION_PRIVATE_REPO." >&2
    exit 1
fi

command -v chezmoi >/dev/null 2>&1 || { echo "Missing chezmoi; install it before $mode." >&2; exit 1; }

chezmoi --source "$source_dir" status
chezmoi --source "$source_dir" diff

if [[ "$mode" == --apply ]]; then
    # Preflight the independent personal-workstation layer before changing public targets.
    bash "$private_entry" --dry-run
fi

if ! command -v brew >/dev/null 2>&1; then
    if [[ "$mode" == --apply ]]; then
        echo "Homebrew missing; running the existing chezmoi Homebrew installer."
        chezmoi --source "$source_dir" execute-template --file "$source_dir/home/run_once_before_00-install-homebrew.sh.tmpl" | bash
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "Missing brew; install it before $mode." >&2
        exit 1
    fi
fi
command -v brew >/dev/null 2>&1 || { echo "Missing brew after setup." >&2; exit 1; }

if [[ "$mode" == --dry-run ]]; then
    echo "Would apply public chezmoi source, then run private --apply: $private_entry"
else
    if [[ "$mode" == --apply ]]; then
        chezmoi --source "$source_dir" apply
    fi
fi

bash "$private_entry" "$mode"
