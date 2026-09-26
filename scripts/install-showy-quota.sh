#!/usr/bin/env bash
set -euo pipefail

# Upstream has no Homebrew formula. Pin the release; keep its runtime out of Git.
version=0.9.0
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64) target=macos-arm64 ;;
  Darwin-x86_64) target=macos-x86_64 ;;
  *) echo 'showy-quota installer: unsupported platform' >&2; exit 1 ;;
esac
archive="showy-quota-$version-$target.tar.gz"
url="https://github.com/enieuwy/showy-quota/releases/download/v$version"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
curl --fail --location --connect-timeout 10 --max-time 180 "$url/$archive" -o "$archive"
curl --fail --location --connect-timeout 10 --max-time 30 "$url/$archive.sha256" -o "$archive.sha256"
shasum -a 256 -c "$archive.sha256"
tar -xzf "$archive"
make -C "showy-quota-$version" install-copy DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/showy-quota"
