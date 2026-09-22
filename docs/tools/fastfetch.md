# Fastfetch

## Current configuration

`home/dot_config/fastfetch/config.jsonc` derives from Fastfetch example 25 and
defines a 56-column boxed layout, title header, seven-line logo offset, macOS
hardware/device probes, red login-time uptime, and two ANSI palette rows. The
palette rows use cursor movement tied to Fastfetch's default macOS logo indent.
`.zshrc` invokes Fastfetch once per shell ancestry only in direct Ghostty or
SSH sessions, never tmux or the VS Code integrated terminal.

## Omarchy reference and divergence

Omarchy documents TUIs but provides no confirmed quattro Fastfetch config.
Fastfetch is therefore a local macOS presentation choice, not an Omarchy port.
Its guarded startup follows the general principle that terminal embellishment
must not duplicate inside nested terminal environments.

**Sources:** [Omarchy TUIs manual](https://omarchy.org/manual/tuis/) and the
[quattro config tree](https://github.com/omacom/omarchy/tree/quattro/config).
No confirmed Omarchy Fastfetch configuration source exists.

## Validation boundary

Run `fastfetch --config home/dot_config/fastfetch/config.jsonc --pipe` and
`git diff --check`. Target output can differ until the source is applied; do
not change source geometry merely because an older target looks different.
