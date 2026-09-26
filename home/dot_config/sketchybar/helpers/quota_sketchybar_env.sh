# Bash loads this for the upstream renderer. Apply final styling in the same
# IPC as the upstream update so text and geometry never flash back to defaults.
quota_item_style() {
    [[ "$item" == showy_quota.* && "$item" != showy_quota.trigger ]] || return 0
    rewritten+=(position=center background.border_width=0 click_script='open -b com.openai.codex')
    if [[ "$item" == showy_quota.codex.label ]]; then
        rewritten+=(label.font=SF\ Pro:Regular:10.0 label.width=104 label.padding_left=0 label.padding_right=0 padding_left=0 padding_right=0 y_offset=5)
    elif [[ "$item" == showy_quota.codex.icon ]]; then
        [[ -z "${SHOWY_QUOTA_CHATGPT_ICON:-}" ]] || rewritten+=(icon="$SHOWY_QUOTA_CHATGPT_ICON")
        if [[ -n "${SHOWY_QUOTA_SKETCHYBAR_ICON_BG_COLOR:-}" && -n "${SHOWY_QUOTA_SKETCHYBAR_ICON_FG_COLOR:-}" ]]; then
            rewritten+=(align=left icon.color="$SHOWY_QUOTA_SKETCHYBAR_ICON_FG_COLOR" icon.align=center icon.background.drawing=on icon.background.color="$SHOWY_QUOTA_SKETCHYBAR_ICON_BG_COLOR" icon.background.height=24 icon.background.y_offset=-1 icon.y_offset=-1 icon.background.corner_radius=5 icon.background.padding_left=0 icon.background.padding_right=0)
        fi
    fi
}
sketchybar() {
    local arg item='' next_item=0 primary_label=''
    local -a rewritten=()
    for arg in "$@"; do
        if [[ "$arg" == --* ]]; then
            quota_item_style
            item=''
            next_item=0
            [[ "$arg" != --set ]] || next_item=1
        elif (( next_item )); then
            item="$arg"
            next_item=0
        elif [[ "$item" == showy_quota.codex.label && "$arg" == label=* ]]; then
            if [[ -z "$primary_label" ]]; then
                primary_label="$(node "${SHOWY_QUOTA_LABEL_SCRIPT:?}" --primary-label 2>/dev/null)" || primary_label=''
            fi
            [[ -z "$primary_label" ]] || arg="label=$primary_label"
        fi
        rewritten+=("$arg")
    done
    quota_item_style
    command sketchybar "${rewritten[@]}"
}
