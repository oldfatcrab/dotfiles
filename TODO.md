# Roadmap

This is the source of truth for planned repository work. The source files
remain authoritative for current behavior, and [DECISIONS.md](DECISIONS.md)
records durable constraints. The checklist is derived from the
[Omarchy Manual table of contents](https://omarchy.org/manual/toc/), but every
linked item must be adapted to macOS and chezmoi before implementation.
Unchecked items are planned work, not authorization to change a target machine.

## Operating rules

- When starting work, define its scope and validation method.
- At handoff, record the managed source files and validation results; include
  them in the commit description when committing. Record source implementation
  and target-machine validation separately. A completed manifest item does not
  claim that every target machine has run `chezmoi apply`.
- Mark an item **Not planned** when it does not fit macOS, this repository, or
  the user's needs; retain a brief reason rather than silently dropping it.
- Add packages to the appropriate Brewfile only after the related work is
  explicitly scoped and reviewed.
- When starting an item, read its linked decision and the affected source files
  before changing the manifest or script.

## Next up

### Managed configuration

- [ ] 2026-09-25 — Codex portable settings source prepared: global guidance,
  selected model/agent fields, and personal-machine appearance/memory settings.
  Pending explicitly authorized target apply; local private context
  is provisioned separately. On 2026-09-26, local routing guidance and Luna
  xhigh were updated directly and synchronized to source; broader target apply
  and real-task usage comparison remain pending. Desktop `session-flags: features.thread_tools`
  warning remains unresolved; the desktop references a flag its CLI does not list.

- [ ] Validate the existing managed Zsh, Powerlevel10k configuration, and Ghostty
  configuration on the target machine. Zsh and Powerlevel10k source already
  exist in `home/dot_config/zsh/`, with Ghostty at
  `home/dot_config/ghostty/config.tmpl`; inspect `chezmoi diff` before any
  explicitly authorized `chezmoi apply`. Target validation remains unrecorded.
<!--
- [ ] Verify fzf-backed Tab completion in a fresh interactive target shell.
  [Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab) is selected in
  `Brewfiles/Brewfile.base` and loaded after `compinit` in
  `home/dot_config/zsh/dot_zshrc`; plugin selection and source wiring are done.
-->
- [x] 2026-09-11 — Configured daily-command aliases and explicit visual
  workflows guided by
  [Shell Tools](https://omarchy.org/manual/shell-tools/): `zsh-eza` manages
  eza-backed listings, while `bat`, `batman`, and bat-extras are configured in
  `home/dot_config/bat/` and `home/dot_config/zsh/aliases.zsh`; `batfind` and
  `batlog` preserve the native command names, and batdiff uses delta when
  available.
- [x] 2026-09-11 — Configured zsh-vi-mode with blinking per-mode cursors,
  palette-derived selection highlighting, and restored fzf widgets after its
  deferred initialization.
- [ ] Research the [fzf wiki](https://github.com/junegunn/fzf/wiki) and refine
  the fzf configuration. Prioritize complete system-tool configuration before
  editor or tmux integration.
- [x] 2026-09-22 — Added the LazyVim starter source under
  `home/dot_config/nvim/` and a shared Catppuccin Contrast override rendered
  from `themes/catppuccin-contrast.toml`. Its selected LazyExtras are managed
  in `lazyvim.json`; `lazy-lock.json` was updated after target `:Lazy sync`.
  Run `:LazyHealth` after a fresh target sync before further plugin updates.
- [ ] After LazyVim is configured, evaluate its selected picker before adding fzf
  integration. Prefer that picker when it already covers files, buffers, live
  grep, Git status, diagnostics, and help; otherwise evaluate `fzf-lua` for
  those actions and its native sorter. Do not add the legacy `fzf.vim` plugin
  alongside a Lua picker.
- [ ] Define and manage the Visual Studio Code extension list in a Brewfile.
- [x] Configure Ghostty; see the 2026-09-08 completed entry.
- [x] 2026-09-22 — Configured native tmux with Omarchy's non-keybinding pane,
  window, session, and protocol behavior. Contrast colours render directly
  from the canonical palette; module selection follows Omarchy while its
  two-row rounded presentation is local. TPM, theme runtimes, session
  restoration, and Bash layout helpers remain absent.
<!--
- [ ] After tmux is configured, evaluate fzf popup integration: use fzf's
  `--tmux`/`FZF_TMUX_OPTS` for its existing shell widgets, and, on tmux 3.2+,
  evaluate `fzf-tab`'s `ftb-tmux-popup` for Tab completion. Keep tmux's native
  session/window chooser unless it proves inadequate; do not add a second
  fzf-based tmux navigator by default.
-->
- [x] 2026-09-23 — Configured Hyprspace, SketchyBar, and JankyBorders from
  Catppuccin Contrast. Hyprspace retains its nine workspaces and existing
  bindings; SketchyBar maps the portable Omarchy bar roles to native macOS
  launchers and read-outs. Linux service panels remain intentionally absent.

### Deferred installation and activation

- [x] 2026-09-26 — Completed guide step 20 for Hyprspace: workspace 1–9
  application icons, a separator before the front app, and `—` for empty
  workspaces. Font APPM mapping, per-workspace deduplication, window moves,
  invalid data, and empty workspaces passed the Node behavior check. Scoped
  `chezmoi apply --exclude scripts` and `sketchybar --reload` completed;
  live queries matched all nine labels to Hyprspace and confirmed a two-second
  shared refresh interval and separator placement.
- [ ] Connect showy-quota to tmux later, reusing its shared CodexBar cache and
  the existing native tmux status configuration; no TPM or second fetcher.
- [x] 2026-09-26 — Applied the SketchyBar/showy-quota configuration with
  `chezmoi apply -r --exclude scripts ~/.config/sketchybar ~/.config/showy-quota`
  and reloaded the existing bar. Live queries confirmed centered 24-hour clock,
  `Squirrel - Simplified` input source, weather icon + Celsius, CPU update_freq=1,
  memory, `Mi 27 NU` name/focus highlight, and real Codex quota strips using
  Contrast colors through managed `codexbar serve`. Source validation and four
  plugin behavior checks passed. CodexBar 0.66.0, app-icon font 3.0.1, and
  checksum-verified showy-quota v0.9.0 are installed on this machine.
- [x] 2026-09-26 — Verified SF Pro/SF Symbols are installed. Explicitly load
  SF Pro on bar reload; rendered display/power glyphs were compared with native
  SF Symbols. Scoped apply/reload and live queries confirmed the new icons.
- [x] 2026-09-26 — Removed Bluetooth and repaired quota child outlines and
  right-group placement. Offline layout/battery/native checks and source
  validation passed; live checks after scoped apply confirmed placement,
  zero child borders, and aligned quota rows/markers.
- [x] 2026-09-26 — Restored the then-unloaded temporary SketchyBar LaunchAgent with
  `launchctl bootstrap gui/$(id -u) /tmp/local.sketchybar-background-test.plist`.
  Live query confirmed `hidden=off` at that time. The reason the job disappeared
  is unknown; the temporary binary and job have since been replaced by the
  Homebrew service below.
- [x] 2026-09-26 — Scoped apply/reload moved Codex-only quota to the center
  group's right edge, removed the agent launcher, and wired quota clicks to
  Codex. Live checks confirmed both remaining percentages/reset countdowns and
  aligned rows. The local bootstrap avoids the upstream exported-registry bug.
- [x] 2026-09-26 — Scoped apply/build installed StatusHelper.app; the user
  approved location access. Same-app status returned 3 (authorized); live
  plugin refresh obtained a real SSID, 31°C weather, and VPN on. The managed
  helper uses CoreWLAN/Core Location and sends only two-decimal coordinates
  to wttr.in, explicitly approved by the user. Source validation and native,
  weather, quota, and CPU/memory behavior checks passed.
  Missing readings remain unavailable/N/A; no public-IP lookup is substituted.
  The VPN component uses system-managed connection status; proxy-only tools
  and unmanaged tunnels may not appear.

- [x] 2026-09-26 — Installed `sketchybar-toggle` 0.5.0 with Homebrew,
  declared it in Brewfile.base, and applied its managed startup configuration.
  `sketchybar-toggle --setup` passed; repeated reloads left one helper instance.
  Applied native text/workspace numbers 15pt, pictograms 18pt, and 12pt
  Lavender/Surface1 window borders. Source validation and live font/layer
  queries passed. These replace the earlier 13pt text and Overlay0 borders.
- [ ] Visually verify the 2026-09-26 desktop appearance and auto-hide:
  the top 3px hides SketchyBar; moving below 50px restores it after 150ms.
  Check native menu interaction and confirm background clicks still leave
  items visible with the installed patched service.
- [x] 2026-09-26 — Installed the verified SketchyBar fix through Homebrew. On this
  machine, clicking the bar background raised it above same-level item
  windows. Tests of `topmost`, `sticky`, and paused Hyprspace did not help;
  runtime settings and Hyprspace were restored. Official 2.24.0 source at
  `6284ee816601486ace33ca48a0271832eec6de35` was patched in `src/bar.c`:
  `window_set_level(&bar->window, g_bar_manager.window_level - 1);`.
  The temporary `/tmp` binary is now absent; on 2026-09-26 the stock Homebrew
  service was confirmed running again. `Formula/sketchybar-background-fix.rb`
  now contains the pinned, checksum-verified, keg-only build and persistent
  Homebrew service definition. Local compilation and version checks passed.
  With explicit authorization, `brew install oldfatcrab/local/sketchybar-background-fix`
  and `brew services start oldfatcrab/local/sketchybar-background-fix` completed;
  the original service was stopped and its installation retained for rollback.
  Runtime checks confirmed background layer 2 below item layer 3 with
  `topmost=window`.
- [ ] Verify background clicks interactively and confirm the installed patched
  Homebrew service survives logout/login. The automation API cannot bind
  SketchyBar for mouse testing. Do not run stock and patched services together.
- [ ] Install and evaluate the [OpenRouter Ori harness](https://openrouter.ai/docs/guides/guides/ori),
  including which existing coding agents it should wrap.
- [ ] Install [Chromium](https://formulae.brew.sh/cask/chromium).
- [ ] Install [AstrillVPN](https://www.astrill.com/download/mac) on personal machines.
- [ ] Evaluate [network controls](https://omarchy.org/manual/networking/) as
  part of the [top-bar implementation](https://omarchy.org/manual/the-top-bar/).

## Capability inventory

### Foundation and daily experience

- [ ] Evaluate [welcome / onboarding guidance](https://omarchy.org/manual/).
- [ ] Evaluate [getting-started automation](https://omarchy.org/manual/getting-started/).
- [ ] Evaluate [migration guidance for macOS or Windows users](https://omarchy.org/manual/coming-from-mac-or-windows/).
- [ ] Evaluate [navigation and workspace switching](https://omarchy.org/manual/navigation/).
- [ ] Evaluate [themes and theme switching](https://omarchy.org/manual/themes/).
- [ ] Evaluate [global hotkeys](https://omarchy.org/manual/hotkeys/).
- [ ] Evaluate [reminders](https://omarchy.org/manual/reminders/).
- [ ] Evaluate [notices](https://omarchy.org/manual/notices/).
- [ ] Evaluate [text extraction and dictation](https://omarchy.org/manual/text-extraction-dictation/).
- [ ] Evaluate [screenshots and recording](https://omarchy.org/manual/screenshots-recording/).
- [ ] Evaluate [toggles, idle behavior, and screensaver settings](https://omarchy.org/manual/toggles-idle-screensaver/).

### Core tools

- [ ] Evaluate an [Omarchy-style CLI or macOS-appropriate alternative](https://omarchy.org/manual/omarchy-cli/).
- [ ] Evaluate [terminal configuration](https://omarchy.org/manual/terminal/).
- [ ] Evaluate [shell functions](https://omarchy.org/manual/shell-functions/).
- [ ] Define [personal-machine applications and configuration](https://omarchy.org/manual/commercial-apps-services/)
  in [`Brewfile.personal`](Brewfiles/Brewfile.personal) and managed source files.
- [ ] Evaluate [Windows VM support](https://omarchy.org/manual/windows-vm/).
- [ ] Evaluate [other packages](https://omarchy.org/manual/other-packages/).
- [ ] Evaluate [update workflow](https://omarchy.org/manual/updates/).
- [ ] Define the [dotfiles-management workflow](https://omarchy.org/manual/dotfiles/).
- [ ] Evaluate [shell plugins](https://omarchy.org/manual/shell-plugins/).

### Hardware and system integration

- [ ] Evaluate [multi-monitor support](https://omarchy.org/manual/monitors/).
- [ ] Evaluate [keyboard, mouse, and trackpad settings](https://omarchy.org/manual/keyboard-mouse-trackpad/).
- [x] 2026-09-11 — Disabled macOS Mission Control's Ctrl-Left/Right Space
  shortcuts through a chezmoi run script, reserving them for terminal word
  navigation.
- [ ] Evaluate [networking configuration](https://omarchy.org/manual/networking/).
- [ ] Evaluate [system-sleep behavior](https://omarchy.org/manual/system-sleep/).
- [ ] Evaluate [hardware authentication](https://omarchy.org/manual/hardware-authentication/).
- [ ] Evaluate [backgrounds](https://omarchy.org/manual/backgrounds/).
- [ ] Evaluate [branding](https://omarchy.org/manual/branding/).
- [ ] Evaluate [common system tweaks](https://omarchy.org/manual/common-tweaks/).
- [ ] Evaluate [custom theme creation](https://omarchy.org/manual/making-your-own-theme/).
- [ ] Evaluate [macOS compatibility and native alternatives](https://omarchy.org/manual/mac-support/).

### Reliability, security, and platform scope

- [ ] Define [troubleshooting guidance](https://omarchy.org/manual/troubleshooting/).
- [ ] Define [FAQ content](https://omarchy.org/manual/faq/).
- [ ] Evaluate [system snapshots and recovery](https://omarchy.org/manual/system-snapshots/).
- [ ] Define [security and secret-management policy](https://omarchy.org/manual/security/).
- [ ] Evaluate [support for additional platforms](https://omarchy.org/manual/omarchy-on/).
- [ ] Decide whether [dual-boot installation guidance](https://omarchy.org/manual/dual-boot-install/) is in scope.
- [ ] Decide whether [unattended-install guidance](https://omarchy.org/manual/unattended-installs/) is in scope.

## Not planned

Add evaluated items here with a reason and date. Do not delete them; the record
prevents the same proposal from being repeatedly re-evaluated.

- 2026-09-01 — Do not add [Files, Pinta, Aether, LocalSend, LibreOffice, or
  Omacalc](https://omarchy.org/manual/guis/); use the corresponding native
  macOS capabilities instead.
- 2026-09-01 — Do not add [Omawrite](https://omarchy.org/manual/guis/); use
  Neovim or Visual Studio Code for Markdown writing.
- 2026-09-01 — Do not add [Omacut](https://omarchy.org/manual/guis/); use
  native macOS video-editing tools.
- 2026-09-01 — Do not add any application from
  [Omarchy Gaming](https://omarchy.org/manual/gaming/). The personal
  `eve-online` cask is a separate, explicit exception.
- 2026-09-01 — Do not add an Omarchy PDF viewer or editor; use macOS Preview
  for [filling out and signing PDFs](https://omarchy.org/manual/filling-out-pdfs/).

## Completed

- [x] 2026-09-22 — Added `themes/codex-catppuccin-contrast.json.tmpl`, which
  renders a manually importable ChatGPT desktop Appearance token from
  `themes/catppuccin-contrast.toml`. The desktop `codex-theme-v1` payload is
  observed rather than documented; re-export after app upgrades before relying
  on it.

- [x] 2026-09-18 — Configured VS Code user settings from the shared
  `vscode/settings.json.tmpl` template, rendered to the native macOS, Linux,
  or Windows settings path; validated with `chezmoi execute-template`, JSON
  parsing, and `git diff --check`.

- [x] 2026-09-18 — Replaced fzf-tab with Carapace while retaining fzf widgets.
  `Brewfiles/Brewfile.base` declares `carapace` and `vivid` (the current target
  has Carapace 1.7.3 and vivid 0.11.1 installed); `home/dot_config/zsh/dot_zshrc`
  initializes `compinit`, applies vivid-generated `LS_COLORS`, and registers
  Carapace. The vivid and Carapace style templates render from
  `themes/catppuccin-contrast.toml`. Validate with `chezmoi execute-template`,
  `vivid generate`, `zsh -n`, and `git diff --check`. The source remains
  unapplied to the target machine; fzf-tab is not removed from existing targets.

- [x] 2026-09-14 — Added `home/dot_config/btop/btop.conf` and
  `home/dot_config/btop/themes/catppuccin_contrast.theme.tmpl`. The config
  enables truecolor and selects the rendered `catppuccin_contrast.theme`, which
  maps btop's existing theme roles to `themes/catppuccin-contrast.toml`.
  Validate with `chezmoi execute-template --file
  home/dot_config/btop/themes/catppuccin_contrast.theme.tmpl` and
  `git diff --check`.

- [x] 2026-09-14 — Added `home/dot_config/fastfetch/config.jsonc`, derived
  from Fastfetch `examples/25.jsonc`: it uses the `examples/7.jsonc` title
  header, a 7-line logo offset, and a 56-column table; omits development-tool
  probes; renders Uptime red with login time only; reports display
  name/resolution/refresh rate, keyboard, mouse, sound, and CPU/GPU
  temperatures; and prints normal then bright terminal colors as two rows of
  circled dots beneath the logo. Their ANSI cursor positioning is coupled to
  the default macOS logo's 34-column indent. Validate with
  `fastfetch --config home/dot_config/fastfetch/config.jsonc --pipe` and
  `git diff --check`.

- [x] 2026-09-08 — Added `home/dot_config/ghostty/config.tmpl`, rendering
  Ghostty colors from `themes/catppuccin-contrast.toml`; retained Liga SFMono
  Nerd Font and selected Omarchy-derived behavior, including the `Ctrl+\``
  quick terminal, a 50 MiB scrollback limit, and a distinct named ANSI bold
  ramp, without applying to a target machine. Validate with `chezmoi execute-template --file
  home/dot_config/ghostty/config.tmpl`, `chezmoi status`, `chezmoi diff`, and
  `git diff --check`.

Move completed items here with the date, affected source files, and validation
command.

- [x] 2026-09-07 — Retired the Starship experiment: removed its configuration,
  initialization, Brewfile declaration, and tests; preserved the supplied
  Powerlevel10k configuration at `home/dot_p10k.zsh` without installing or
  initializing Powerlevel10k. Validate with `git diff --check`.

- [x] 2026-09-10 — Activated Powerlevel10k from `Brewfile.base`; load its
  Homebrew theme before the managed `$ZDOTDIR/.p10k.zsh` configuration.

- [x] 2026-09-01 — Established the selected [AI tooling](https://omarchy.org/manual/ai/)
  baseline in `Brewfiles/Brewfile.base`; validated with `git diff --check`.
  OpenRouter Ori remains in **Next up** for separate evaluation.

- [x] 2026-09-01 — Established the selected [TUI baseline](https://omarchy.org/manual/tuis/)
  in `Brewfiles/Brewfile.base`, including Yazi and its `chafa`, `imagemagick`,
  and `ffmpeg-full` preview dependencies; validated with `git diff --check`.
- [x] 2026-09-01 — Established the selected [GUI baseline](https://omarchy.org/manual/guis/)
  in `Brewfiles/Brewfile.base`; native macOS replacements are recorded in
  `DECISIONS.md`; validated with `git diff --check`.
- [x] 2026-09-01 — Established the selected [browser baseline](https://omarchy.org/manual/browsers/)
  in `Brewfiles/Brewfile.personal`; Chromium installation remains in **Next
  up**; validated with `git diff --check`.
- [x] 2026-09-01 — Established [commercial service selections](https://omarchy.org/manual/commercial-apps-services/)
  in `Brewfiles/Brewfile.base`; validated with `git diff --check`.
- [x] 2026-09-01 — Established selected [web applications](https://omarchy.org/manual/web-apps/)
  in `Brewfiles/Brewfile.base`; validated with `git diff --check`.

- [x] 2026-09-01 — Established the selected [font baseline](https://omarchy.org/manual/fonts/)
  in `Brewfiles/Brewfile.base`; SF Mono is the primary coding font, as recorded
  in `DECISIONS.md`; validated with `git diff --check`.

- [x] 2026-09-01 — Established the [Neovim](https://omarchy.org/manual/neovim/)
  package baseline in `Brewfiles/Brewfile.base`; validated with `git diff --check`.

- [x] 2026-09-01 — Established selected [development tools](https://omarchy.org/manual/development-tools/)
  in `Brewfiles/Brewfile.base`; Visual Studio Code configuration and extensions
  remain in **Next up**; validated with `git diff --check`.

- [x] 2026-09-01 — Established the selected [top-bar baseline](https://omarchy.org/manual/the-top-bar/)
  in `Brewfiles/Brewfile.base`; configuration and service activation remain in
  **Next up**; validated with `git diff --check`.

- [x] 2026-09-01 — Established the [unified clipboard and launcher baseline](https://omarchy.org/manual/unified-clipboard-history/)
  with Raycast in `Brewfiles/Brewfile.base`; validated with `git diff --check`.

- [x] 2026-09-01 — Established the shared
  [Shell Tools package baseline](https://omarchy.org/manual/shell-tools/) in
  `Brewfiles/Brewfile.base`; validated with `git diff --check` and a static
  formula inventory. Runtime configuration work remains in **Next up**.
