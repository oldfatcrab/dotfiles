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
- [ ] Install and configure [LazyVim](https://www.lazyvim.org/installation)
  after confirming how its `~/.config/nvim` starter configuration should be managed.
- [ ] After LazyVim is configured, evaluate its selected picker before adding fzf
  integration. Prefer that picker when it already covers files, buffers, live
  grep, Git status, diagnostics, and help; otherwise evaluate `fzf-lua` for
  those actions and its native sorter. Do not add the legacy `fzf.vim` plugin
  alongside a Lua picker.
- [ ] Define and manage the Visual Studio Code extension list in a Brewfile.
- [x] Configure Ghostty; see the 2026-09-08 completed entry.
- [ ] Configure tmux, including evaluating [oh-my-tmux](https://github.com/gpakosz/.tmux).
<!--
- [ ] After tmux is configured, evaluate fzf popup integration: use fzf's
  `--tmux`/`FZF_TMUX_OPTS` for its existing shell widgets, and, on tmux 3.2+,
  evaluate `fzf-tab`'s `ftb-tmux-popup` for Tab completion. Keep tmux's native
  session/window chooser unless it proves inadequate; do not add a second
  fzf-based tmux navigator by default.
-->
- [ ] Configure Hyprspace, Sketchybar, and borders.

### Deferred installation and activation

- [ ] Enable the top-bar services with `brew services start borders` and
  `brew services start sketchybar`.
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
