# =============================================================================
# Interactive Functions — sourced by ~/.zshrc for interactive shells.
#
# Migrated from Omarchy (omarchy/default/bash/fns/) and adapted for
# macOS + Zsh. Linux-specific functions are marked with TODO.
# =============================================================================

# ---------------------------------------------------------------------------
# Neovim launcher (from Omarchy aliases)
# Opens current directory if no arguments given.
# ---------------------------------------------------------------------------
n() {
    if [[ $# -eq 0 ]]; then
        command nvim .
    else
        command nvim "$@"
    fi
}

# ---------------------------------------------------------------------------
# Zoxide-enhanced cd (from Omarchy aliases)
# Falls back to builtin cd for directories, uses zoxide for fuzzy matching.
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    zd() {
        if (( $# == 0 )); then
            builtin cd ~ || return
        elif [[ -d $1 ]]; then
            builtin cd "$1" || return
        else
            if ! z "$@"; then
                echo "Error: Directory not found"
                return 1
            fi
            printf "\U000F17A9 "
            pwd
        fi
    }
    alias cd="zd"
fi

# ---------------------------------------------------------------------------
# FZF Wrapper for fzf-tab (Clear Kitty Images on Exit)
# ---------------------------------------------------------------------------
ftb_fzf_with_kitty_clear() {
    fzf "$@"
    local ret=$?
    printf '\e_Ga=d\e\\' > /dev/tty
    return $ret
}

# ---------------------------------------------------------------------------
# FZF + SCP file transfer (from Omarchy aliases)
# Usage: sff <destination> (e.g., sff host:/tmp/)
# ---------------------------------------------------------------------------
sff() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
        return 1
    fi
    local file
    file=$(find . -type f -print0 | xargs -0 stat -f '%m %N' | sort -rn | cut -d' ' -f2- | ff) \
        && [[ -n "$file" ]] \
        && scp "$file" "$1"
}

# ---------------------------------------------------------------------------
# Compression (from Omarchy fns/compression)
# ---------------------------------------------------------------------------
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }

# ---------------------------------------------------------------------------
# Tmux Dev Layouts (from Omarchy fns/tmux)
# ---------------------------------------------------------------------------

# Create a Tmux Dev Layout with editor, AI, and terminal
# Usage: tdl <c|cx|codex|other_ai> [<second_ai>]
tdl() {
    [[ -z $1 ]] && { echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

    local current_dir="${PWD}"
    local editor_pane ai_pane ai2_pane
    local ai="$1"
    local ai2="$2"

    editor_pane="$TMUX_PANE"

    tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
    tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
    ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

    if [[ -n $ai2 ]]; then
        ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
        tmux send-keys -t "$ai2_pane" "$ai2" C-m
    fi

    tmux send-keys -t "$ai_pane" "$ai" C-m
    tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
    tmux select-pane -t "$editor_pane"
}

# Create a Tmux Dev Square layout
# Usage: tds
tds() {
    [[ -n $1 ]] && { echo "Usage: tds"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tds."; return 1; }

    local current_dir="${PWD}"
    local editor_pane diff_pane terminal_pane opencode_pane

    editor_pane="$TMUX_PANE"

    tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

    terminal_pane=$(tmux split-window -v -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
    diff_pane=$(tmux split-window -h -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
    opencode_pane=$(tmux split-window -h -p 50 -t "$terminal_pane" -c "$current_dir" -P -F '#{pane_id}')

    tmux send-keys -t "$editor_pane" -l "nvim ."
    tmux send-keys -t "$editor_pane" C-m
    tmux send-keys -t "$diff_pane" -l "hunk diff --watch"
    tmux send-keys -t "$diff_pane" C-m
    tmux send-keys -t "$opencode_pane" -l "opencode"
    tmux send-keys -t "$opencode_pane" C-m

    tmux select-pane -t "$editor_pane"
}

# Create multiple tdl windows with one per subdirectory
# Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]
tdlm() {
    [[ -z $1 ]] && { echo "Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }

    local ai="$1"
    local ai2="$2"
    local base_dir="$PWD"
    local first=true

    tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

    for dir in "$base_dir"/*/; do
        [[ -d $dir ]] || continue
        local dirpath="${dir%/}"

        if $first; then
            tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
            first=false
        else
            local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
            tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
        fi
    done
}

# Create a multi-pane swarm layout
# Usage: tsl <pane_count> <command>
tsl() {
    [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }

    local count="$1"
    local cmd="$2"
    local current_dir="${PWD}"
    local -a panes

    tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"

    panes+=("$TMUX_PANE")

    while (( ${#panes[@]} < count )); do
        local new_pane
        local split_target="${panes[-1]}"
        new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
        panes+=("$new_pane")
        tmux select-layout -t "${panes[1]}" tiled
    done

    for pane in "${panes[@]}"; do
        tmux send-keys -t "$pane" "$cmd" C-m
    done

    tmux select-pane -t "${panes[1]}"
}

# ---------------------------------------------------------------------------
# Git Worktree Helpers (from Omarchy fns/worktrees)
# ---------------------------------------------------------------------------

# Create a new worktree and branch from within current git directory.
# Usage: ga <branch_name>
ga() {
    if [[ -z "$1" ]]; then
        echo "Usage: ga [branch name]"
        return 1
    fi

    local branch="$1"
    local base="$(basename "$PWD")"
    local wt_path="../${base}--${branch}"

    git worktree add -b "$branch" "$wt_path"
    # TODO: `mise trust` is Linux/Omarchy-specific; uncomment if mise is installed
    # command -v mise &>/dev/null && mise trust "$wt_path"
    cd "$wt_path"
}

# Remove worktree and branch from within active worktree directory.
# Usage: gd
gd() {
    # TODO: `gum` is optional; falls back to read prompt on macOS
    local confirm="n"
    if command -v gum &>/dev/null; then
        gum confirm "Remove worktree and branch?" && confirm="y"
    else
        printf "Remove worktree and branch? [y/N]: "
        read -r confirm
    fi

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        local cwd worktree root branch

        cwd="$(pwd)"
        worktree="$(basename "$cwd")"

        # Split on first `--`
        root="${worktree%%--*}"
        branch="${worktree#*--}"

        # Protect against accidentally nuking a non-worktree directory
        if [[ "$root" != "$worktree" ]]; then
            cd "../$root"
            git worktree remove "$cwd" --force || return 1
            git branch -D "$branch"
        fi
    fi
}

# ---------------------------------------------------------------------------
# SSH Port Forwarding (from Omarchy fns/ssh-port-forwarding)
# ---------------------------------------------------------------------------

# Forward local ports to a remote host
# Usage: fip <host> <port1> [port2] ...
fip() {
    (( $# < 2 )) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
    local host="$1"
    shift
    for port in "$@"; do
        ssh -f -N -L "${port}:localhost:${port}" "$host" \
            && echo "Forwarding localhost:$port -> $host:$port"
    done
}

# Stop forwarding on specified ports
# Usage: dip <port1> [port2] ...
dip() {
    (( $# == 0 )) && echo "Usage: dip <port1> [port2] ..." && return 1
    for port in "$@"; do
        pkill -f "ssh.*-L ${port}:localhost:${port}" \
            && echo "Stopped forwarding port $port" \
            || echo "No forwarding on port $port"
    done
}

# List all active SSH port forwards
lip() {
    pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# ---------------------------------------------------------------------------
# Rsync-on-change watchers (from Omarchy fns/rsyncing)
# TODO: Linux-only (requires inotifywait + setsid). macOS alternative would
# use fswatch instead. Placeholder for future implementation.
# ---------------------------------------------------------------------------
# rsw() { ... }
# lsw() { ... }
# dsw() { ... }
