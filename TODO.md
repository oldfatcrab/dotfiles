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
  configuration on the target machine. Source implementation already exists in
  `home/dot_config/zsh/`, `home/dot_p10k.zsh.tmpl`, and
  `home/dot_config/ghostty/config.tmpl`; inspect `chezmoi diff` before any
  explicitly authorized `chezmoi apply`. Target validation remains unrecorded.
- [ ] Verify fzf-backed Tab completion in a fresh interactive target shell.
  [Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab) is already selected in
  `Brewfiles/Brewfile.base` and loaded after `compinit` in
  `home/dot_config/zsh/dot_zshrc`; plugin selection and source wiring are done.
- [ ] Configure remaining daily-command aliases: `cat`, `man`, and `ls` to
  `bat`, `batman`, and `eza`, guided by
  [Shell Tools](https://omarchy.org/manual/shell-tools/). The Zsh source already
  initializes zoxide with `--cmd cd`; target behavior remains to be verified.
- [ ] Configure defaults for [`eza`, `bat`, and `bat-extras`](https://omarchy.org/manual/shell-tools/).
- [ ] Install and configure [LazyVim](https://www.lazyvim.org/installation)
  after confirming how its `~/.config/nvim` starter configuration should be managed.
- [ ] Configure Visual Studio Code.
- [ ] Define and manage the Visual Studio Code extension list in a Brewfile.
- [x] Configure Ghostty; see the 2026-09-08 completed entry.
- [ ] Configure tmux, including evaluating [oh-my-tmux](https://github.com/gpakosz/.tmux).
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
