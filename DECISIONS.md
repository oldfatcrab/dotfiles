# Architecture decisions

This log records durable decisions that intentionally differ from Omarchy or
other reference setups. It explains *why* this repository chose a different
path, so future changes do not repeat the same evaluation.

## Entry format

Add new entries in reverse chronological order. Each entry should state the
context, decision, rationale, and consequences. Link the relevant source files
or external reference when useful.

## 2026-09-01 — Use Raycast for clipboard history and application launching

**Status:** accepted

**Omarchy reference:** [Unified Clipboard & History](https://omarchy.org/manual/unified-clipboard-history/)

**Context:** Omarchy provides a unified clipboard manager and an application
launcher. This macOS setup needs one replacement for both roles.

**Decision:** Use Raycast's unified capabilities for clipboard history and the
application launcher (the macOS equivalent of Omarchy menu).

**Rationale:** One macOS application covers both workflows without separate
clipboard and launcher tooling.

**Consequences:** Do not add a separate Omarchy-style clipboard manager or
start-menu application unless Raycast proves insufficient for a concrete need.

**Implementation / validation:** `Brewfiles/Brewfile.base`; run
`brew bundle check --file Brewfiles/Brewfile.base` after Homebrew is healthy.

## 2026-09-01 — Use a native macOS top-bar and terminal stack

**Status:** accepted

**Omarchy reference:** [The Top Bar](https://omarchy.org/manual/the-top-bar/)

**Context:** Omarchy's top bar depends on Hyprland and its Omarchy-specific
bar, neither of which is available on macOS. The Linux-only `foot` terminal is
also unavailable.

**Decision:** Use Hyprspace, Sketchybar, and borders as the macOS replacement
for the Hyprland and Omarchy-bar experience. Use Ghostty instead of `foot`.

**Rationale:** These tools provide a macOS-native implementation path while
preserving the intended tiling, top-bar, and terminal roles.

**Consequences:** Their configuration and service activation are managed as
separate follow-up work rather than attempting to reuse Omarchy configuration.

**Implementation / validation:** `Brewfiles/Brewfile.base` and `TODO.md`; run
`brew bundle check --file Brewfiles/Brewfile.base` after Homebrew is healthy.

## 2026-09-01 — Use SF Mono as the primary coding font

**Status:** accepted

**Omarchy reference:** [Fonts](https://omarchy.org/manual/fonts/)

**Context:** The shared baseline installs several Nerd Font families for
terminal and editor compatibility.

**Decision:** Use SF Mono as the primary coding font, via the
`font-sf-mono-nerd-font-ligaturized` cask.

**Rationale:** SF Mono most closely matches the native macOS look and feel
while retaining Nerd Font glyph coverage.

**Consequences:** The other installed Nerd Fonts remain available for
compatibility or experimentation, but are not the default. Future terminal or
editor configuration should select SF Mono explicitly.

**Implementation / validation:** `Brewfiles/Brewfile.base`; run
`brew bundle check --file Brewfiles/Brewfile.base` after Homebrew is healthy,
then select SF Mono in the configured terminal or editor.

## 2026-09-01 — Use Preview for PDF viewing, forms, and signing

**Status:** accepted

**Omarchy reference:** [Filling out PDFs](https://omarchy.org/manual/filling-out-pdfs/)

**Context:** Omarchy uses Document Viewer for standard PDFs and Xournal++ for
annotation or signatures.

**Decision:** Use the built-in macOS Preview application for PDF viewing,
form-filling, annotation, and signing. Do not add a separate PDF application.

**Rationale:** Preview already covers the required workflow and is integrated
with macOS.

**Consequences:** No Omarchy PDF viewer or editor is managed by either
Brewfile. Re-evaluate only if Preview cannot support a concrete future need.

**Implementation / validation:** `TODO.md`; open a representative PDF in
Preview and verify form-filling or signing when the workflow is next used.

## 2026-09-01 — Exclude Omarchy gaming applications

**Status:** accepted

**Omarchy reference:** [Gaming](https://omarchy.org/manual/gaming/)

**Context:** Omarchy documents a set of gaming applications and launchers.

**Decision:** Do not install any application from the Omarchy Gaming list.
Install only the `eve-online` cask in `Brewfile.personal` as an explicit
personal-machine exception.

**Rationale:** The selected personal gaming scope is EVE Online only.

**Consequences:** No Omarchy gaming application is part of either Brewfile.
EVE Online is not installed on work machines.

**Implementation / validation:** `Brewfiles/Brewfile.personal` and `TODO.md`;
run `brew bundle check --file Brewfiles/Brewfile.personal` after Homebrew is
healthy.

## 2026-09-01 — Limit Web App desktop installations and exclude 37signals apps

**Status:** accepted

**Omarchy reference:** [Web Apps](https://omarchy.org/manual/web-apps/)

**Context:** Omarchy provides a set of dedicated Web App installations,
including 37signals products. This macOS setup needs a deliberately small set
of shared desktop applications.

**Decision:** Install only ChatGPT, WhatsApp, Zoom, and Discord from this
category. Do not install any 37signals application, including ONCE, HEY, or
Basecamp. Use native macOS applications where available; otherwise install a
Chrome App when a concrete workflow requires it.

**Rationale:** This keeps the managed application surface small while retaining
dedicated clients for the selected communication and AI workflows.

**Consequences:** Other Omarchy Web Apps are intentionally absent from the
Brewfile. Chrome App installations are user-specific and are not managed by
chezmoi unless a future requirement makes them reproducible.

**Implementation / validation:** `Brewfiles/Brewfile.base`; run
`brew bundle check --file Brewfiles/Brewfile.base` after Homebrew is healthy.

## 2026-09-01 — Select 1Password and Surfshark for shared services

**Status:** accepted

**Omarchy reference:** [Commercial apps/services](https://omarchy.org/manual/commercial-apps-services/)

**Context:** Omarchy offers 1Password and Bitwarden as password-manager
choices, and NordVPN as a consumer VPN. This repository needs one shared
selection for each role.

**Decision:** Install 1Password (including its CLI) rather than Bitwarden, and
install Surfshark rather than NordVPN. Keep Spotify, Dropbox, and Tailscale in
the shared base manifest. Signal is also included as a shared GUI application.

**Rationale:** These are the selected services for this dotfiles setup.

**Consequences:** Bitwarden and NordVPN are intentionally absent. Tailscale,
Dropbox, and Surfshark may require macOS privacy/security approval and account
sign-in after installation.

**Implementation / validation:** `Brewfiles/Brewfile.base`; run
`brew bundle check --file Brewfiles/Brewfile.base` after Homebrew is healthy.

## 2026-09-01 — Prefer native macOS applications for selected GUI roles

**Status:** accepted

**Omarchy reference:** [GUIs](https://omarchy.org/manual/guis/)

**Context:** Omarchy provides Files, Pinta, Aether, LocalSend, LibreOffice,
Omacalc, Omawrite, and Omacut. This repository targets macOS, which already
provides integrated functionality for several of those roles.

**Decision:** Use native macOS capabilities instead of adding Files, Pinta,
Aether, LocalSend, LibreOffice, or Omacalc. Use Neovim or Visual Studio Code
instead of Omawrite, and native macOS video-editing tools instead of Omacut.
Install Obsidian, OBS Studio, and Kdenlive in `Brewfile.base`. Use `mpv`,
installed through `Brewfile.base`, rather than VLC for shared media playback.

**Rationale:** Native applications reduce duplicate software and configuration
while preserving macOS integration. Neovim and Visual Studio Code already
cover the intended Markdown-writing workflow. Obsidian, OBS Studio, and
Kdenlive are selected shared applications. `mpv` provides a lightweight,
scriptable cross-platform media player for the shared baseline.

**Consequences:** The corresponding Omarchy applications will not be managed
by this repository. Any required native-app preferences should be added only
when a concrete workflow needs them.

**Implementation / validation:** `Brewfiles/Brewfile.base`,
`Brewfiles/Brewfile.personal`, and `TODO.md`; run
`brew bundle check --file Brewfiles/Brewfile.base` after Homebrew is healthy.

## 2026-09-01 — Use `batman` instead of installing `tldr`

**Status:** accepted

**Omarchy reference:** [Shell Tools](https://omarchy.org/manual/shell-tools/)

**Context:** Omarchy includes `tldr` for short command examples. This macOS
setup already uses `bat` and adds the `bat-extras` formula, which provides
`batman` for rendering manual pages with bat.

**Decision:** Do not install `tldr`. Use `batman` as the standard enhanced
manual-page command.

**Rationale:** Reusing the selected `bat` ecosystem keeps the baseline smaller
and avoids adding a second documentation tool before a demonstrated need.

**Consequences:** `batman` improves `man` page presentation but does not supply
the curated example cheatsheets that `tldr` provides. Revisit this decision if
that distinction becomes a recurring need.

**Implementation / validation:** `Brewfiles/Brewfile.base`; run
`brew bundle check --file Brewfiles/Brewfile.base` and `batman --help`.

## 2026-09-01 — Prefer Zsh for interactive shell configuration

**Status:** accepted

**Omarchy reference:** [Shell Tools](https://omarchy.org/manual/shell-tools/)

**Context:** Omarchy configures a Bash-based Linux environment. macOS ships
Zsh as its default interactive shell.

**Decision:** Write interactive-shell aliases, functions, completion, and
plugin configuration for Zsh rather than Bash.

**Rationale:** This follows the macOS default and avoids a separate interactive
shell runtime solely to mirror Omarchy.

**Consequences:** Zsh plugins and native completion APIs are preferred. The
chezmoi `run_*.sh.tmpl` automation scripts remain Bash because they are
non-interactive, explicitly portable scripts—not interactive shell settings.

**Implementation / validation:** Future Zsh source files under `home/`; verify
with `zsh -n <file>` and a fresh interactive Zsh session.

## Template — Copy for a new decision

```markdown
## YYYY-MM-DD — Short decision title

**Status:** proposed | accepted | superseded

**Omarchy reference:** <manual section or URL, if applicable>

**Context:** <What requirement or behavior is being evaluated?>

**Decision:** <What will this repository do instead?>

**Rationale:** <Why is this a better fit for this macOS chezmoi repository?>

**Consequences:** <What is gained, lost, deferred, or made incompatible?>

**Implementation / validation:** <Managed files and commands that verify it>
```
