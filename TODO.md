# Roadmap

This is the single source of truth for planned repository work. It is derived
from the [Omarchy Manual table of contents](https://omarchy.org/manual/toc/),
but each item must be adapted to macOS and chezmoi before implementation.
Unchecked items are evaluation tasks, not an instruction to install software or
change the target machine.

## Operating rules

- Move an item to **In progress** only with a concrete owner, scope, and test.
- Before marking an item complete, record the managed source files and the
  validation command in its pull request or commit.
- Mark an item **Not planned** when it does not fit macOS, this repository, or
  the user's needs; retain a brief reason rather than silently dropping it.
- Add resulting packages to the appropriate Brewfile only after the related
  configuration is implemented and reviewed.

## In progress

- [ ] Establish the first managed configuration and verify it with
  `chezmoi diff` and `chezmoi apply`.

## Capability inventory

### Foundation and daily experience

- [ ] Evaluate welcome / onboarding guidance.
- [ ] Evaluate getting-started automation.
- [ ] Evaluate migration guidance for macOS or Windows users.
- [ ] Evaluate navigation and workspace switching.
- [ ] Evaluate a top-bar solution.
- [ ] Evaluate themes and theme switching.
- [ ] Evaluate global hotkeys.
- [ ] Evaluate unified clipboard and history.
- [ ] Evaluate reminders.
- [ ] Evaluate notices.
- [ ] Evaluate text extraction and dictation.
- [ ] Evaluate screenshots and recording.
- [ ] Evaluate toggles, idle behavior, and screensaver settings.

### Core tools

- [ ] Evaluate an Omarchy-style CLI or a macOS-appropriate alternative.
- [ ] Evaluate terminal configuration.
- [ ] Evaluate Neovim configuration.
- [ ] Evaluate AI tooling.
- [ ] Evaluate development tools.
- [ ] Evaluate shell tools.
- [ ] Evaluate shell functions.
- [ ] Evaluate terminal user interfaces (TUIs).
- [ ] Evaluate graphical user interfaces (GUIs).
- [ ] Evaluate browser setup.
- [ ] Evaluate commercial applications and services.
- [ ] Evaluate web applications.
- [ ] Evaluate gaming support.
- [ ] Evaluate PDF form-filling tools.
- [ ] Evaluate Windows VM support.
- [ ] Evaluate other packages.
- [ ] Evaluate update workflow.
- [ ] Define the dotfiles-management workflow.
- [ ] Evaluate shell plugins.

### Hardware and system integration

- [ ] Evaluate multi-monitor support.
- [ ] Evaluate keyboard, mouse, and trackpad settings.
- [ ] Evaluate networking configuration.
- [ ] Evaluate system-sleep behavior.
- [ ] Evaluate hardware authentication.
- [ ] Evaluate fonts.
- [ ] Evaluate backgrounds.
- [ ] Evaluate shell prompt.
- [ ] Evaluate branding.
- [ ] Evaluate common system tweaks.
- [ ] Evaluate custom theme creation.
- [ ] Evaluate macOS compatibility and native alternatives.

### Reliability, security, and platform scope

- [ ] Define troubleshooting guidance.
- [ ] Define FAQ content.
- [ ] Evaluate system snapshots and recovery.
- [ ] Define security and secret-management policy.
- [ ] Evaluate support for additional platforms.
- [ ] Decide whether dual-boot installation guidance is in scope.
- [ ] Decide whether unattended-install guidance is in scope.

## Not planned

Add evaluated items here with a reason and date. Do not delete them; the record
prevents the same proposal from being repeatedly re-evaluated.

## Completed

Move completed items here with the date, affected source files, and validation
command.
