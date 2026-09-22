# Omarchy tmux research

**Research date:** 2026-09-22
**Scope:** current `quattro` Omarchy sources, excluding the keybinding inventory.
The adopted subset and local divergences are recorded in
[tools/tmux.md](tools/tmux.md); this file remains the upstream evidence.

## Answer

Yes. Omarchy's tmux experience is more than bindings, but its core tmux file
is deliberately compact: there are no TPM/plugin-manager declarations, plugin
loads, `run-shell` directives, or current `set-hook` directives in the shipped
[`config/tmux/tmux.conf`](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/tmux/tmux.conf).
The rest is native tmux options plus Omarchy-owned launcher, theme, refresh,
cheatsheet, and Bash layout-function integration.

| Area | Current Omarchy behaviour beyond bindings | Primary source |
| --- | --- | --- |
| Terminal protocol | Sets `default-terminal` to `tmux-256color`, enables RGB terminal overrides, extended CSI-u keys for `xterm-kitty`, and terminal clipboard capability. It also enables `set-clipboard` and `allow-passthrough`. | [tmux.conf](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/tmux/tmux.conf) |
| Native tmux policy | Mouse mode; one-based window/pane indexes; automatic renumbering; 50,000 lines of history; focus events; aggressive-resize; `detach-on-destroy off`; and automatic window renaming from the current directory. The source contains both a global `escape-time 0` setting and a later server `escape-time 10` setting. | [tmux.conf](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/tmux/tmux.conf) |
| Status and titles | Status bar is top-aligned, refreshes every five seconds, and shows session, mode/prefix/zoom flags, host, directory-derived window names, and ANSI-blue/bright-black borders and messages. It sets the terminal title to `host:window`. The static status theme uses terminal-default background/foreground rather than a hard-coded Omarchy palette. | [tmux.conf](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/tmux/tmux.conf) |
| Theme runtime | Every Omarchy theme application calls `omarchy-theme-set-tmux`. For a running server, that script imports theme environment values, updates `COLORFGBG` per light/dark mode, changes window and active-window colours plus cursor colour, writes OSC palette sequences to panes, signals their foreground process groups with `WINCH`, and refreshes clients. | [theme dispatcher](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-theme-set), [tmux theme sync](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-theme-set-tmux) |
| Session lifecycle | The desktop launcher and Bash `t` alias both attach to an existing server or create a session named `Work`; no session-restoration plugin or service is configured. The manual's "resumable" claim is therefore persistence while the tmux server remains alive, not reboot persistence. | [launcher](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-launch-terminal-tmux), [Bash aliases](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/aliases), [manual](https://omarchy.org/manual/terminal/) |
| Layout workflows | Bash sources four functions: `tdl` (editor + one/two AI panes + terminal), `tds` (editor + `hunk diff --watch` + terminal + opencode), `tdlm` (one `tdl` window per subdirectory), and `tsl` (a tiled command swarm). They require an active tmux session and use `$EDITOR`, `nvim`, `hunk`, and agent command aliases. | [function loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/functions), [tmux functions](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/bash/fns/tmux), [manual](https://omarchy.org/manual/terminal/) |
| User-facing maintenance | `omarchy-refresh-tmux` replaces `~/.config/tmux/tmux.conf` with Omarchy's default, then reloads it if a server exists. The Omarchy menu exposes that as a reset-to-default action. The standalone cheatsheet parses the effective user config in a temporary tmux server; its UI size path calls `hyprctl`, so that presentation layer is Hyprland-specific. | [refresh](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-refresh-tmux), [restart](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-restart-tmux), [cheatsheet](https://raw.githubusercontent.com/omacom/omarchy/quattro/bin/omarchy-menu-tmux-keybindings), [menu entry](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/omarchy/omarchy-menu.jsonc) |

## Platform and adoption boundary

`tmux` itself is part of Omarchy's Arch base package list. The tmux source
assumes Linux terminal/device paths (`/dev/pts/*`) for live palette injection,
Omarchy commands/state under `~/.local/state/omarchy`, Bash-provided layouts,
and Hyprland for desktop launchers and the graphical cheatsheet. Its terminal
configs also deliberately emit CSI-u for Alt-Shift-Enter so the matching tmux
binding can distinguish it; that is a coordinated terminal-plus-tmux decision,
not a standalone tmux setting.

For this macOS chezmoi repository, the adopted subset is native tmux behaviour
(history, indexes, mouse, renaming, status modules, and protocol capabilities).
The Omarchy theme daemon, `/dev/pts` palette writes, Hyprland launch/menu
integration, Bash functions, and reset-by-overwrite workflow are not portable
defaults.

Sources: [base packages](https://raw.githubusercontent.com/omacom/omarchy/quattro/install/omarchy-base.packages), [Ghostty CSI-u configuration](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/ghostty/config), [Hyprland launcher binding](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/bindings/applications.lua).
