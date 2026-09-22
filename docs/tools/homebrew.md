# Homebrew package model

## Current configuration

`Brewfiles/Brewfile.base` declares the shared baseline; `Brewfile.personal`
adds personal casks only when `is_personal_machine` is true. The managed
`run_onchange_before_20-install-brew-packages.sh.tmpl` hashes both applicable
manifests, enters the Apple Silicon or Intel Homebrew environment, runs `brew
bundle` for each selected file, then registers Homebrew OpenJDK only when the
system link is absent or points elsewhere. Non-core taps declare `trusted:
true` individually.

## Omarchy reference and divergence

Omarchy's package, session, and system defaults are Arch-owned. Its
[dotfiles model](https://omarchy.org/manual/dotfiles/) distinguishes package
defaults from user overrides; its [Mac support page](https://omarchy.org/manual/mac-support/)
does not provide a Homebrew equivalent. This repository follows the ownership
clarity, but uses versioned chezmoi manifests and Homebrew rather than pacman,
systemd, udev, Hyprland, or Wayland configuration. Native macOS applications
are deliberate substitutions, not ports.

## Validation boundary

Render the hook and inspect `chezmoi status`/`chezmoi diff`; `brew bundle` runs
only during an explicitly authorized apply. A manifest declaration is not proof
that a target has the package.
