#!/usr/bin/env bash
set -euo pipefail

source_dir=$(cd "$(dirname "$0")/.." && pwd -P)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
mkdir -p "$test_dir/bin" "$test_dir/home" "$test_dir/private/scripts"
cat > "$test_dir/bin/uname" <<'STUB'
#!/usr/bin/env bash
echo Darwin
STUB
cat > "$test_dir/bin/brew" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
cat > "$test_dir/bin/chezmoi" <<'STUB'
#!/usr/bin/env bash
printf 'chezmoi:%s\n' "${*: -1}" >> "$TEST_LOG"
STUB
cat > "$test_dir/private/scripts/bootstrap.sh" <<'STUB'
#!/usr/bin/env bash
printf 'private:%s\n' "$1" >> "$TEST_LOG"
if [[ "$1" == --dry-run ]]; then exit "${PRIVATE_DRY_EXIT:-0}"; fi
exit "${PRIVATE_EXIT:-0}"
STUB
chmod +x "$test_dir/bin/"* "$test_dir/private/scripts/bootstrap.sh"
export PATH="$test_dir/bin:$PATH" HOME="$test_dir/home"
export WORKSTATION_PRIVATE_REPO="$test_dir/private" TEST_LOG="$test_dir/log"

bash "$source_dir/scripts/bootstrap.sh"
[[ $(cat "$TEST_LOG") == $'chezmoi:status\nchezmoi:diff\nprivate:--check' ]]
[[ ! -e "$HOME/.local" ]]
: > "$TEST_LOG"
bash "$source_dir/scripts/bootstrap.sh" --dry-run
[[ $(cat "$TEST_LOG") == $'chezmoi:status\nchezmoi:diff\nprivate:--dry-run' ]]
: > "$TEST_LOG"
bash "$source_dir/scripts/bootstrap.sh" --apply
[[ $(cat "$TEST_LOG") == $'chezmoi:status\nchezmoi:diff\nprivate:--dry-run\nchezmoi:apply\nprivate:--apply' ]]
: > "$TEST_LOG"
PRIVATE_DRY_EXIT=19 bash "$source_dir/scripts/bootstrap.sh" --apply >/dev/null && exit 1 || result=$?
[[ $result == 19 ]]
[[ $(cat "$TEST_LOG") == $'chezmoi:status\nchezmoi:diff\nprivate:--dry-run' ]]
: > "$TEST_LOG"
PRIVATE_EXIT=23 bash "$source_dir/scripts/bootstrap.sh" --apply >/dev/null && exit 1 || result=$?
[[ $result == 23 ]]
[[ $(cat "$TEST_LOG") == *$'private:--apply' ]]
rm "$test_dir/private/scripts/bootstrap.sh"
bash "$source_dir/scripts/bootstrap.sh" --check >/dev/null 2>&1 && exit 1 || result=$?
[[ $result == 1 ]]
echo 'bootstrap modes, ordering, no-write check, missing private, and exit propagation: PASS'
