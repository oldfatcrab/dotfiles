#!/bin/sh

layout="$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null | awk -F. '{print $NF}')"
[ -n "$layout" ] || layout=""

sketchybar --set "$NAME" label="$layout"
