#!/usr/bin/env bash
set -euo pipefail

# Manual city overrides the authorized local position.
location=${SKETCHYBAR_WEATHER_LOCATION:-}
if [[ -z "$location" && -r "$CONFIG_DIR/weather-location" ]]; then
  location=$(cat "$CONFIG_DIR/weather-location")
fi
if [[ -z "$location" ]]; then
  location=$(bash "$CONFIG_DIR/plugins/native_status.sh" location 2>/dev/null) || location=''
fi
report='{}'
if [[ -n "$location" ]]; then
  location=$(printf '%s' "$location" | jq -sRr @uri)
  report=$(curl --fail --silent --show-error --connect-timeout 5 --max-time 15 \
    "https://wttr.in/$location?format=j1" 2>/dev/null) || report='{}'
fi
condition=$(jq -er '.current_condition[0] | select((.temp_C | tonumber) >= -100 and (.temp_C | tonumber) <= 70) | [.weatherCode, .temp_C] | @tsv' <<< "$report" 2>/dev/null) || condition=''
icon=􀇕
label=N/A
if [[ -n "$condition" ]]; then
  IFS=$'\t' read -r code temperature <<< "$condition"
  case "$code" in
    113) icon=􀆮 ;;
    116) icon=􀇕 ;;
    119|122) icon=􀇃 ;;
    143|248|260) icon=􀇋 ;;
    200|386|389|392|395) icon=􀇟 ;;
    179|182|185|227|230|281|284|311|314|317|320|323|326|329|332|335|338|350|362|365|368|371|374|377) icon=􀇏 ;;
    176|263|266|293|296|299|302|305|308|353|356|359) icon=􀇇 ;;
  esac
  label="${temperature}°C"
fi
sketchybar --set "$NAME" icon="$icon" label="$label"
