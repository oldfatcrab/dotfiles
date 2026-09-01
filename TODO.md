# Roadmap

This is the single source of truth for planned repository work. The checklist
is derived from the [Omarchy Manual table of contents](https://omarchy.org/manual/toc/),
but every linked item must be adapted to macOS and chezmoi before implementation.
Unchecked items are evaluation tasks, not authorization to install software or
change the target machine.

## Operating rules

- Move an item to **In progress** only with a concrete owner, scope, and test.
- Before marking an item complete, record the managed source files and the
  validation command in its pull request or commit.
- Mark an item **Not planned** when it does not fit macOS, this repository, or
  the user's needs; retain a brief reason rather than silently dropping it.
- Add packages to the appropriate Brewfile only after the related work is
  explicitly scoped and reviewed.

## Next up

- [ ] Establish the first managed configuration, using the
  [Omarchy dotfiles workflow](https://omarchy.org/manual/dotfiles/) as a
  reference, and verify it with `chezmoi diff` and `chezmoi apply`.
- [ ] Decide whether to use [lincheney/fzf-tab-completion](https://github.com/lincheney/fzf-tab-completion),
  [Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab), or both, in the context
  of [Omarchy Shell Tools](https://omarchy.org/manual/shell-tools/).
- [ ] Configure [fzf-backed Tab completion](https://omarchy.org/manual/shell-tools/)
  after selecting the plugin approach.
- [ ] Alias common daily commands—`cat`, `man`, `cd`, and `ls`—to `bat`,
  `batman`, `z`, and `eza` through Oh My Zsh or another Zsh plugin mechanism,
  guided by [Shell Tools](https://omarchy.org/manual/shell-tools/).
- [ ] Configure defaults for [`eza`, `bat`, and `bat-extras`](https://omarchy.org/manual/shell-tools/).

## Capability inventory

### Foundation and daily experience

- [ ] Evaluate [welcome / onboarding guidance](https://omarchy.org/manual/).
- [ ] Evaluate [getting-started automation](https://omarchy.org/manual/getting-started/).
- [ ] Evaluate [migration guidance for macOS or Windows users](https://omarchy.org/manual/coming-from-mac-or-windows/).
- [ ] Evaluate [navigation and workspace switching](https://omarchy.org/manual/navigation/).
- [ ] Evaluate a [top-bar solution](https://omarchy.org/manual/the-top-bar/).
- [ ] Evaluate [themes and theme switching](https://omarchy.org/manual/themes/).
- [ ] Evaluate [global hotkeys](https://omarchy.org/manual/hotkeys/).
- [ ] Evaluate [unified clipboard and history](https://omarchy.org/manual/unified-clipboard-history/).
- [ ] Evaluate [reminders](https://omarchy.org/manual/reminders/).
- [ ] Evaluate [notices](https://omarchy.org/manual/notices/).
- [ ] Evaluate [text extraction and dictation](https://omarchy.org/manual/text-extraction-dictation/).
- [ ] Evaluate [screenshots and recording](https://omarchy.org/manual/screenshots-recording/).
- [ ] Evaluate [toggles, idle behavior, and screensaver settings](https://omarchy.org/manual/toggles-idle-screensaver/).

### Core tools

- [ ] Evaluate an [Omarchy-style CLI or macOS-appropriate alternative](https://omarchy.org/manual/omarchy-cli/).
- [ ] Evaluate [terminal configuration](https://omarchy.org/manual/terminal/).
- [ ] Evaluate [Neovim configuration](https://omarchy.org/manual/neovim/).
- [ ] Evaluate [AI tooling](https://omarchy.org/manual/ai/).
- [ ] Evaluate [development tools](https://omarchy.org/manual/development-tools/).
- [ ] Evaluate [shell functions](https://omarchy.org/manual/shell-functions/).
- [ ] Evaluate [terminal user interfaces (TUIs)](https://omarchy.org/manual/tuis/).
- [ ] Evaluate [graphical user interfaces (GUIs)](https://omarchy.org/manual/guis/).
- [ ] Evaluate [browser setup](https://omarchy.org/manual/browsers/).
- [ ] Evaluate [commercial applications and services](https://omarchy.org/manual/commercial-apps-services/).
- [ ] Define [personal-machine applications and configuration](https://omarchy.org/manual/commercial-apps-services/)
  in [`Brewfile.personal`](Brewfiles/Brewfile.personal) and managed source files.
- [ ] Evaluate [web applications](https://omarchy.org/manual/web-apps/).
- [ ] Evaluate [gaming support](https://omarchy.org/manual/gaming/).
- [ ] Evaluate [PDF form-filling tools](https://omarchy.org/manual/filling-out-pdfs/).
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
- [ ] Evaluate [fonts](https://omarchy.org/manual/fonts/).
- [ ] Evaluate [backgrounds](https://omarchy.org/manual/backgrounds/).
- [ ] Evaluate [shell prompt](https://omarchy.org/manual/prompt/).
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

## Completed

Move completed items here with the date, affected source files, and validation
command.

- [x] 2026-09-01 — Established the shared
  [Shell Tools package baseline](https://omarchy.org/manual/shell-tools/) in
  `Brewfiles/Brewfile.base`; validated with `git diff --check` and a static
  formula inventory. Runtime configuration work remains in **Next up**.
