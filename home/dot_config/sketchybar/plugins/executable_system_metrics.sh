#!/bin/sh

cpu="N/A"
cache_dir="${XDG_CACHE_HOME:-${HOME:?}/.cache}/sketchybar"
cache_file="$cache_dir/cpu-ticks"
umask 077
set -f
if mkdir -p "$cache_dir"; then
  sample="$("$CONFIG_DIR/plugins/native_status.sh" cpu 2>/dev/null)" || sample=""
  case "$sample" in
    '' | *[!0-9\ ]*) rm -f "$cache_file" ;;
    *)
      set -- $sample
      if [ "$#" -eq 2 ]; then
        busy=$1 total=$2
        case "$busy:$total" in *[!0-9:]*) busy= total= ;; esac
        if [ -n "$busy" ] && [ -n "$total" ] && awk -v b="$busy" -v t="$total" 'BEGIN { exit !(t > 0 && b <= t) }'; then
          previous="$(cat "$cache_file" 2>/dev/null || true)"
          case "$previous" in *[!0-9\ ]*) previous= ;; esac
          set -- $previous
          if [ "$#" -eq 2 ]; then
            old_busy=$1 old_total=$2
            case "$old_busy:$old_total" in *[!0-9:]*) old_busy= old_total= ;; esac
            if [ -n "$old_busy" ] && [ -n "$old_total" ] && awk -v b="$old_busy" -v t="$old_total" 'BEGIN { exit !(t > 0 && b <= t) }'; then
              cpu="$(awk -v busy="$busy" -v total="$total" -v old_busy="$old_busy" -v old_total="$old_total" 'BEGIN { db = busy - old_busy; dt = total - old_total; if (db >= 0 && dt > 0 && db <= dt) printf "%.0f%%", db * 100 / dt; else exit 1 }')" || cpu="N/A"
            fi
          fi
          tmp_file="$cache_file.$$"
          if printf '%s %s\n' "$busy" "$total" >"$tmp_file" && mv -f "$tmp_file" "$cache_file"; then
            :
          else
            rm -f "$tmp_file" "$cache_file"
            cpu="N/A"
          fi
        else
          rm -f "$cache_file"
        fi
      else
        rm -f "$cache_file"
      fi
      ;;
  esac
else
  rm -f "$cache_file"
fi

# Count resident active, wired, and compressor pages once; inactive/cache pages
# are reclaimable and "Pages stored in compressor" is logical, not resident.
vm_output="$(vm_stat 2>/dev/null)" && memory_bytes="$(sysctl -n hw.memsize 2>/dev/null)" && memory="$(
  printf '%s\n' "$vm_output" | awk '
    /^Mach Virtual Memory Statistics:/ { if (match($0, /page size of [0-9]+ bytes/)) { size = substr($0, RSTART, RLENGTH); gsub(/[^0-9]/, "", size) } }
    /^Pages active:/ { active = $3; sub(/\.$/, "", active) }
    /^Pages wired down:/ { wired = $4; sub(/\.$/, "", wired) }
    /^Pages occupied by compressor:/ { compressed = $5; sub(/\.$/, "", compressed) }
    END { if (total ~ /^[0-9]+$/ && total > 0 && size > 0 && active ~ /^[0-9]+$/ && wired ~ /^[0-9]+$/ && compressed ~ /^[0-9]+$/) printf "%.0f%%", ((active + wired + compressed) * size / total) * 100; else exit 1 }
  ' total="$memory_bytes"
)" || memory="N/A"

gpu="$(ioreg -r -c IOAccelerator -d 1 -k PerformanceStatistics 2>/dev/null | awk '
  match($0, /"Device Utilization %"=[0-9]+/) {
    value = substr($0, RSTART, RLENGTH)
    sub(/.*=/, "", value)
    if (value + 0 <= 100) { printf "%d%%", value; exit }
  }
')" || gpu=""
sketchybar --set cpu label="$cpu" --set gpu label="${gpu:-N/A}" --set memory label="$memory"
