# Homebrew package model

## Current configuration

`Brewfiles/Brewfile.base` declares the shared baseline. Stow and mise remain
present for now but are no longer required by the private workstation layer. The managed
`run_onchange_before_20-install-brew-packages.sh.tmpl` hashes and bundles only
that manifest. Its existing OpenJDK registration remains macOS-specific.
Personal casks live in the private repository and are installed by its
bootstrap. Non-core taps declare `trusted: true` individually.

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
