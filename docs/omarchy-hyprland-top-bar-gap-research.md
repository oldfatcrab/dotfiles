# Omarchy Hyprland and top-bar gap research

**Research date:** 2026-09-22
**Scope:** Compare Omarchy quattro's current Hyprland and shell-bar behaviour
with `home/dot_config/hyprspace/config.toml` and
`home/dot_config/sketchybar/executable_sketchybarrc.tmpl`. This is research only:
it does not authorize source changes, service activation, or target changes.
Keyboard-chord parity is not a goal; capability parity is.

## Boundary

Omarchy is a Linux desktop built around Hyprland. Its top bar is not an
independent status-bar configuration: the long-running Omarchy Quickshell
process also owns its menu, notifications, OSDs, and lock screen.
[Top-bar manual](https://omarchy.org/manual/the-top-bar/)

The accepted local design is Hyprspace + SketchyBar + borders as native macOS
replacements. So “absent” below means “not configured in these two files”, not
that Omarchy's Linux configuration should be copied. Omarchy's user loader
itself loads system defaults from `/usr/share/omarchy` before user overrides.
[Hyprland user loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/hypr/hyprland.lua)

## Already represented locally

| Capability | Local state | Omarchy comparison |
| --- | --- | --- |
| Tiling basics | Hyprspace starts at login; configures gaps, directional focus/move, `tiles`/`accordion`, floating, resizing, fullscreen, a service mode, and workspaces 1–9. | Same basic role as Omarchy's dwindle workflow. Omarchy defaults to dwindle with gaps, borders, and animations. [Omarchy look and feel](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/looknfeel.lua) |
| Workspace display | SketchyBar renders buttons 1–9, focuses them on click, and receives Hyprspace workspace-change events. | Same workspace-indicator intent as Omarchy's left-section widget. [Omarchy bar layout](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/omarchy/shell.json) |
| Bar read-outs | SketchyBar has workspace controls, front app, centered keyboard/weather/calendar/update items, and native audio, media, agent, system, and battery entries. | Its portable roles follow Omarchy's three sections; the actual Linux panels remain absent. [Omarchy bar layout](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/omarchy/shell.json) |
| Top reserve | Hyprspace reserves 48 px at the main monitor's top and SketchyBar is a 40 px top bar. | Omarchy's default is top too, but it can move to all edges and adapt widgets to vertical bars. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |

## Hyprland workflow differences

| Omarchy feature | Local Hyprspace state | Classification |
| --- | --- | --- |
| Per-workspace persistent scrolling layout alongside dwindle. | Not configured. Local `tiles`/`horizontal`/`vertical`/`accordion` layouts are not Omarchy's Hyprland scrolling layout. | **Different; possibly useful.** Check for a native Hyprspace equivalent only when a concrete workflow calls for it. [Navigation manual](https://omarchy.org/manual/navigation/), [layout-state loader](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/workspace-layouts.lua) |
| Window groups and group navigation/moves. | Not configured. | **Different.** This is a Hyprland primitive; only consider a native equivalent. [Tiling bindings](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/bindings/tiling.lua) |
| Scratchpad workspace; a pinned pop-out window; pseudo window; full-width and tiled-fullscreen variants. | Not configured; local has ordinary floating and macOS-native fullscreen. | **Different.** Scratchpad/pinned workflows need a macOS-native capability check. [Tiling bindings](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/bindings/tiling.lua) |
| Previous/next workspace, silent move, cross-monitor workspace moves, mouse move/resize, three resize increments, and scale stepping. | Not configured; local provides focus-back-and-forth, directional movement, and one resize increment. | **Linux/Hyprland-specific semantics.** Do not map literally to macOS spaces. [Tiling bindings](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/bindings/tiling.lua) |
| Compositor defaults: gradient borders, opacity, animations, group bar, and XWayland dragging exception. | Different: local uses external `borders` and a short list of macOS app IDs forced to float. | **Linux/Hyprland-only**, except native per-app floating. [Look and feel](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/looknfeel.lua), [window rules](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/windows.lua) |
| Linux capture, OCR, recording, notifications, reminders, idle/night-light, lock, and menu hotkeys. | Not configured in Hyprspace. | **Mixed.** macOS equivalents may exist, but Omarchy's commands/session hooks are Linux-only. [Utility bindings](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/bindings/utilities.lua) |

## Omarchy-bar capabilities absent from the SketchyBar source

| Omarchy capability | Local status | Classification |
| --- | --- | --- |
| Inline weather and time-zone data, plus Omarchy-specific update state. | Different: Weather and Calendar open their native apps; the badge counts locally known Homebrew updates. | **macOS-feasible in principle.** Raycast owns the accepted launcher role. [Top-bar manual](https://omarchy.org/manual/the-top-bar/), [bar layout](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/omarchy/shell.json) |
| Audio output/input and per-app mixer; media transport; bluetooth device control; network scan/connect/DNS; display brightness/scaling; power-profile panel. | Different: a compact audio read-out and native-app/settings launchers replace Linux panels. | **Mixed; do not port.** These rely on Linux audio, NetworkManager, and power/display services. [Top-bar manual](https://omarchy.org/manual/the-top-bar/), [networking manual](https://omarchy.org/manual/networking/) |
| Tray drawer, agent-usage widget/panel, and Tailscale/Dropbox service widgets. | Different: the agent entry launches Codex; native tray and service telemetry remain absent. | **Mixed.** Native status-item integration is separate; Omarchy adds Tailscale/Dropbox only after their services are installed. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |
| DND, night-light, reminder, recording, stay-awake, and dictation indicators; notification history/actions. | Absent. | **Mixed.** Omarchy connects these to its Quickshell shell and Linux capture/notification stack. [Top-bar manual](https://omarchy.org/manual/the-top-bar/), [utility bindings](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/bindings/utilities.lua) |
| Bar drag to every edge, widget drag/reorder, transparency toggle, widget enable/disable, and `omarchy bar` state management. | Different: local bar is fixed top with source-defined order and no configured auto-hide. | **Different; possibly useful.** SketchyBar needs its own persistence/UI design if this becomes a requirement. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |
| A unified bar/panel/menu/notification/OSD/lock lifecycle; hiding the bar leaves panels and hotkeys alive. | Absent by design: SketchyBar and Hyprspace are separate processes. | **Linux/Omarchy architecture.** Do not recreate a monolithic shell without a concrete macOS need. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |

## Visual mapping for a native implementation

Catppuccin's Hyprland and Waybar projects are palette exporters, not desktop
layout specifications: Hyprland receives named Lua `rgb(...)`/alpha values and
Waybar receives named GTK CSS variables. Neither upstream configuration
prescribes a border width, gaps, bar height, widget order, or widget styling.
The local Catppuccin Contrast palette must therefore remain the colour source;
do not substitute upstream Mocha hex values.
[Catppuccin Hyprland Mocha](https://raw.githubusercontent.com/catppuccin/hyprland/main/themes/catppuccin-mocha.lua),
[Catppuccin Waybar Mocha](https://raw.githubusercontent.com/catppuccin/waybar/main/themes/mocha.css),
[Waybar template](https://raw.githubusercontent.com/catppuccin/waybar/main/waybar.tera)

| Upstream visual intent | Native mapping | Ceiling |
| --- | --- | --- |
| Omarchy uses inner/outer gaps of 5/10, a 2 px active gradient border, square corners, no window shadow/blur, and animations. | JankyBorders can map only the focus distinction: use one semantic active colour and one inactive colour (the local palette already names `terminal.active_border` and `terminal.inactive_border`); its `width` and `style` are separate native choices. Hyprspace owns gaps. | **Partial, macOS-feasible.** JankyBorders has global active/inactive colours, width, and round/square style; it supports its own gradient colors, but cannot reproduce Hyprland compositor animation, group bars, window opacity, or XWayland rules. [Omarchy look and feel](https://raw.githubusercontent.com/omacom/omarchy/quattro/default/hypr/looknfeel.lua), [JankyBorders README](https://github.com/FelixKratz/JankyBorders/blob/main/README.md) |
| Omarchy's default bar is opaque, top-positioned, three-sectioned, with the clock as the exact center anchor. | SketchyBar can express a top/bottom bar, opaque `base` background, height, border/corner/shadow/blur choices, and left/center/right item positions. Keep the existing top reserve synchronized with the chosen height. | **Partial, macOS-feasible.** Omarchy's drag-to-any-edge/vertical compact layout and its shell-managed persistence are not a SketchyBar import format. [Omarchy shell layout](https://raw.githubusercontent.com/omacom/omarchy/quattro/config/omarchy/shell.json), [SketchyBar bar properties](https://felixkratz.github.io/SketchyBar/config/bar) |
| Omarchy opens actionable panels rather than showing only read-outs. | SketchyBar has popup menus, so small native popups (for example clock/calendar or a compact selector) are technically available. | **MacOS-feasible only when a native command/API owns the action.** Do not use popups to emulate Linux device-management backends. [Omarchy panels](https://omarchy.org/manual/the-top-bar/), [SketchyBar popups](https://felixkratz.github.io/SketchyBar/config/popups) |

### Widget portability

| Omarchy widget | macOS classification |
| --- | --- |
| Workspace indicators, clock/calendar/time zone, weather, battery percentage, keyboard-layout indication, and media play/pause. | **Feasible as native status or shortcut widgets.** The local source already covers workspaces and battery; menu launching remains intentionally Raycast-owned. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |
| Audio volume/output shortcut, Bluetooth status/toggle, display brightness shortcut, Tailscale/Dropbox status, and an agent-usage read-out. | **Feasible only as a scoped macOS integration.** A compact read-out/shortcut is realistic; Omarchy's full panels do not establish a portable implementation. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |
| Per-app audio mixer, MPRIS metadata/cover-art transport, NetworkManager Wi-Fi scan/connect/DNS picker, BlueZ device panel, UPower profiles, Arch update action, and Wayland system-tray drawer. | **Linux-service-specific.** Do not port these implementations; macOS has different system services and no compatible Omarchy widget protocol. [Top-bar manual](https://omarchy.org/manual/the-top-bar/), [Networking manual](https://omarchy.org/manual/networking/) |
| Quickshell-owned DND/night-light/reminder/recording/stay-awake/dictation indicators, notification history, OSD, and lock lifecycle. | **Linux/Omarchy shell-specific.** macOS may supply analogous system state, but it is not a SketchyBar-only feature. [Top-bar manual](https://omarchy.org/manual/the-top-bar/) |

## Result

The only substantial macOS-plausible follow-ups are: (1) a scratchpad or
pinned-window workflow, (2) native bar controls for audio, network,
bluetooth, brightness, media, or calendar/weather, and (3) persistent
per-workspace layout choice, if Hyprspace supports it. The remaining gaps are
already covered at smaller scope, intentionally different, or coupled to
Omarchy's Linux/Hyprland/Quickshell runtime.

Omarchy's own Mac page describes installing it as replacing macOS and does
not directly support M-series Macs. It is not evidence that the Hyprland or
Quickshell runtime can coexist with this macOS configuration.
[Omarchy Mac support](https://omarchy.org/manual/mac-support/)

## Local evidence

- `home/dot_config/hyprspace/config.toml`
- `home/dot_config/sketchybar/executable_sketchybarrc.tmpl`
- `home/dot_config/borders/executable_bordersrc.tmpl`
- `DECISIONS.md` — 2026-09-01 “Use a native macOS top-bar and terminal stack”
- `TODO.md` — deferred top-bar services and network-controls evaluation
