#!/usr/bin/env bash
set -euo pipefail

source_dir="${CONFIG_DIR:?set CONFIG_DIR}/helpers"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/sketchybar"
app="$data_dir/StatusHelper.app"
binary="$app/Contents/MacOS/StatusHelper"
mkdir -p "$data_dir"
if [[ "${1:-}" != --locked ]]; then
  exec /usr/bin/lockf -k -t 30 "$data_dir/.status-helper-build.lock" bash "$0" --locked
fi
if [[ -x "$binary" && "$binary" -nt "$source_dir/status.swift" && "$binary" -nt "$source_dir/StatusHelper-Info.plist" ]]; then
  printf '%s\n' "$app"
  exit 0
fi

tmp="$(mktemp -d "$data_dir/.StatusHelper.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/Contents/MacOS"
cp "$source_dir/StatusHelper-Info.plist" "$tmp/Contents/Info.plist"
swiftc -module-cache-path "$data_dir/module-cache" "$source_dir/status.swift" -o "$tmp/Contents/MacOS/StatusHelper"
codesign --force --sign - "$tmp" >/dev/null
if [[ -d "$app" ]]; then
  old="$data_dir/.StatusHelper.old.$$"
  mv "$app" "$old"
  if ! mv "$tmp" "$app"; then
    mv "$old" "$app"
    exit 1
  fi
  rm -rf "$old"
else
  mv "$tmp" "$app"
fi
printf '%s\n' "$app"
