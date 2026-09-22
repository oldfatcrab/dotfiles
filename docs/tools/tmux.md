# tmux

## Current configuration

`home/dot_config/tmux/tmux.conf.tmpl` configures tmux natively with Omarchy's
non-keybinding behavior: mouse, one-based indexes, 50,000 history lines,
focus/clipboard/passthrough, CSI-u extended keys, automatic directory window
names, and terminal titles. Its colours render directly from
`themes/catppuccin-contrast.toml`. The visible modules follow Omarchy: session
on the left, `#I:#W` windows in the middle, then COPY/PREFIX/ZOOM state and
hostname on the right. `home/symlink_dot_tmux.conf` makes that XDG source the
default tmux startup configuration. The top bar uses Contrast `mantle` rather
than the pane background; its blank second line uses tmux's `fill` style
rendered from `base` so it matches the pane background, and the session has a
rounded badge. The extra status row permanently consumes one terminal row.
`bg` styles only affect emitted characters, so an empty status format must use
`fill` to paint the whole gap.

## Omarchy reference and divergence

Omarchy's [tmux config](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/tmux/tmux.conf)
inspired the native behavior and module selection. Unlike Omarchy, this macOS
source deliberately omits all of its key bindings, uses a two-row rounded
status bar, and does not use Hyprland launchers, its Bash `Work` session
alias/layout helpers, Linux `/dev/pts` theme writes, or reset-by-overwrite
tooling. Unlike upstream
Catppuccin/tmux's [manual installation](https://github.com/catppuccin/tmux#manual-recommended),
there is no plugin installation: native tmux values render Contrast directly.

No TPM, session-restoration plugin, or automatic reboot recovery is configured.

## Validation boundary

`scripts/validate-source.sh` renders the template, simulates the managed
`~/.tmux.conf` symlink, then starts and stops an isolated tmux server. Validate
clipboard, terminal escape sequences, and the placement of `C-b :` prompts
after an authorized target apply. Applying source does not reload an existing
server; run `tmux source-file ~/.config/tmux/tmux.conf` to load it.
