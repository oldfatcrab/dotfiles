#!/bin/sh

if ! command -v brew >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

count="$(brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')"
case "$count" in
'' | *[!0-9]*) count=0 ;;
esac

if [ "$count" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on label="$count"
else
  sketchybar --set "$NAME" drawing=off
fi
