#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
if [[ "${1:-}" == vpn ]]; then
	if ! vpn_list="$(scutil --nc list 2>/dev/null)"; then
		label=unavailable
	else
		label="$(sed -nE '/^[* ]*\(Connected\).* VPN /s/.*"([^"]+)"[[:space:]]*\[VPN:.*/\1/p' <<< "$vpn_list" | head -n 1)"
		[[ -n "$label" ]] || label=off
	fi
	sketchybar --set "$NAME" label="$label"
	exit 0
fi

app="$(bash "$CONFIG_DIR/helpers/build-status-helper.sh" 2>/dev/null)" || {
	[[ "${1:-}" == location ]] && exit 1
	sketchybar --set "$NAME" label=unavailable
	exit 0
}
binary="$app/Contents/MacOS/StatusHelper"
mkdir -p "$cache_dir"

case "${1:-}" in
	cpu)
		exec "$binary" cpu
		;;
	keyboard)
		label="$("$binary" "$1" 2>/dev/null || true)"
		sketchybar --set "$NAME" label="${label:-unavailable}"
		;;
	wifi|location)
		status_cache="$HOME/Library/Caches/local.sketchybar.StatusHelper/$1"
		rm -f "$status_cache"
		open -W -n -a "$app" --args "$1" >/dev/null 2>&1 || true
		if [[ "$1" == location ]]; then
			[[ -s "$status_cache" ]] || exit 1
			cat "$status_cache"
		else
			label="$(cat "$status_cache" 2>/dev/null || true)"
			sketchybar --set "$NAME" label="${label:-unavailable}"
		fi
		;;
	displays)
		items_file="$cache_dir/display-items"
		output=""
		if ! output="$("$binary" displays "${HYPRSPACE_BIN:-}" 2>/dev/null)"; then
			if [[ -f "$items_file" ]]; then
				while IFS= read -r old_id; do
					[[ -n "$old_id" ]] && sketchybar --remove "display.$old_id" || true
				done < "$items_file"
			fi
			: > "$items_file"
			sketchybar --set "$NAME" drawing=on icon=􀒶 label=unavailable
			exit 0
		fi
		sketchybar --set "$NAME" drawing=off
		new_items="$items_file.$$"
		: > "$new_items"
		while IFS=$'\t' read -r id name is_focused; do
			[[ -n "$id" && -n "$name" ]] || continue
			[[ "$id" =~ ^[0-9]+$ ]] || continue
			item="display.$id"
			if ! sketchybar --query "$item" >/dev/null 2>&1; then
				sketchybar --add item "$item" right --set "$item" icon.color="${ICON_FG_COLOR:?set ICON_FG_COLOR from the palette}" icon.background.drawing=on icon.background.color="${ICON_BG_COLOR:?set ICON_BG_COLOR from the palette}" icon.padding_right=7 icon.background.height=22 icon.background.y_offset=-1 icon.background.corner_radius=5 icon.background.padding_left=2 icon.background.padding_right=2
				sketchybar --move "$item" before memory
			fi
			if [[ "$is_focused" == 1 ]]; then
				sketchybar --set "$item" icon=􀒶 label="$name" icon.highlight=off background.border_color="${BORDER_COLOR:?set BORDER_COLOR from the palette}" background.drawing=on click_script="open 'x-apple.systempreferences:com.apple.Displays-Settings.extension'"
			else
				sketchybar --set "$item" icon=􀒶 label="$name" icon.highlight=off background.drawing=off click_script="open 'x-apple.systempreferences:com.apple.Displays-Settings.extension'"
			fi
			printf '%s\n' "$id" >> "$new_items"
		done <<< "$output"
		if [[ -f "$items_file" ]]; then
			while IFS= read -r old_id; do
				grep -qxF "$old_id" "$new_items" || sketchybar --remove "display.$old_id" || true
			done < "$items_file"
		fi
		mv "$new_items" "$items_file"
		;;
	*)
		exit 2
		;;
esac
