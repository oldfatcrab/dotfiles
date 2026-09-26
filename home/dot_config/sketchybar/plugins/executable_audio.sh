#!/bin/sh

# One snapshot keeps volume and mute consistent. The volume_change event updates
# immediately; polling also catches mute-only changes and missed device events.
settings="$(osascript -e 'get {output volume, output muted} of (get volume settings)' 2>/dev/null)"
volume="${settings%%,*}"
muted="${settings##*, }"

case "$muted" in
true) icon=􀊣; label="mute" ;;
*)
  case "$volume" in
  '' | *[!0-9]*) icon=􀊩; label="" ;;
  0) icon=􀊡; label="0%" ;;
  *) icon=􀊩; label="${volume}%" ;;
  esac
  ;;
esac

sketchybar --set "$NAME" icon="$icon" label="$label"
