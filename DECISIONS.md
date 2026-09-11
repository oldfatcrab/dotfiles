# Architecture decisions

This log records durable decisions that intentionally differ from Omarchy or
other reference setups. It explains *why* this repository chose a different
path, so future changes do not repeat the same evaluation.

Historical entries describe the state at the time of the decision. Paths,
implementation status, and validation commands updated by later entries are
not current operating instructions; consult the current source and the
relevant later decision.

## 2026-09-10 — Activate Powerlevel10k from Homebrew

**Status:** accepted

**Context:** The managed `.p10k.zsh` sets Powerlevel10k options but cannot
render a prompt until the theme itself is loaded.

**Decision:** Declare `powerlevel10k` in `Brewfiles/Brewfile.base`. At the end
of interactive `.zshrc`, source Homebrew's theme file, then source
`$ZDOTDIR/.p10k.zsh`.

**Rationale:** Homebrew supplies the theme at a stable path and is already the
package authority. Loading the theme first is the required, minimal order.

**Consequences:** New shells use the managed P10K prompt after Homebrew has
installed the formula. The configuration remains plain Zsh rendered from the
canonical palette.

**Implementation / validation:** Validate the rendered P10K file with `zsh -n`,
then open a new interactive shell after applying the formula and source files.

## 2026-09-10 — Give terminal bold ANSI colours a dedicated ramp

**Status:** accepted

**Context:** Ghostty uses ANSI colours 9–14 for bold text. Reusing colours
1–6 made the bold and normal variants visually identical, so font weight was
the only distinction.

**Decision:** Keep the shared Catppuccin-derived semantic accents unchanged.
Define the terminal-only colours `crimson`, `moss`, `ochre`, `cornflower`,
`orchid`, and `verdigris` in `[colors]`, and map them to ANSI colours 9–14.
They are derived in OKLCH from their matching ANSI accents with `L' = 0.88 *
L`, `C' = C + 0.035`, and `h' = h + 2 degrees`, then gamut-mapped to sRGB.

**Rationale:** This preserves each ANSI colour's identity while providing a
visibly deeper, more saturated bold layer. The approach follows Catppuccin's
principle that ANSI bright colours should be bolder and more saturated, not
necessarily brighter.

**Consequences:** P10K, syntax, and UI roles continue to use the shared
semantic accents. Only terminal ANSI bold rendering changes through Ghostty's
`bold-color = bright` behavior.

**Implementation / validation:**
`themes/catppuccin-contrast.toml`; validate TOML, render
`home/dot_config/ghostty/config.tmpl`, check palette entries 9–14, and run
`git diff --check`. Do not apply without explicit authorization.

## 2026-09-08 — Bootstrap Zsh from the XDG configuration directory

**Status:** accepted

**Context:** Zsh reads its first user `.zshenv` from `$ZDOTDIR`, or `$HOME`
when `ZDOTDIR` is unset. The repository keeps the full Zsh startup set under
the XDG configuration directory.

**Decision:** Manage `home/dot_zshenv` as a three-line bootstrap: default and
export `XDG_CONFIG_HOME`, set but do not export `ZDOTDIR` to
`$XDG_CONFIG_HOME/zsh`, then source its `.zshenv`. Manage `.zshenv`,
`.zprofile`, `.zshrc`, `.zlogin`, and `.zlogout` in `home/dot_config/zsh/`.

**Rationale:** The root file is a stable Zsh entry point while all substantive
configuration remains XDG-scoped. Leaving `ZDOTDIR` unexported makes every
child Zsh run the same bootstrap instead of requiring a second bootstrap file.

**Consequences:** After `chezmoi apply`, Zsh reads its startup files from
`$XDG_CONFIG_HOME/zsh`. `.zshenv` contains only non-interactive environment
defaults; terminal-bound `GPG_TTY` remains in interactive `.zshrc`. No startup
file creates XDG directories.

**Implementation / validation:** Validate `home/dot_zshenv` with `zsh -n` and
verify an isolated login and interactive startup with `XDG_CONFIG_HOME` set and
unset. Do not apply without explicit authorization.

## Entry format

Add new entries in reverse chronological order. Each entry should state the
context, decision, rationale, and consequences. Link the relevant source files
or external reference when useful.

## 2026-09-08 — Render Ghostty from the canonical palette

**Status:** accepted

**Context:** Omarchy's native `foot` terminal is Linux-only and unavailable on
macOS, so this repository uses Ghostty for that terminal role. The existing
macOS Ghostty configuration used a static palette, while Omarchy reads
dynamically generated Linux theme colors. This repository already has one
authoritative terminal/editor palette.

**Decision:** Manage `home/dot_config/ghostty/config.tmpl`, rendering its
background, foreground, ANSI palette, cursor, selection, and search colors
from `themes/catppuccin-contrast.toml`. Use `Liga SFMono Nerd Font` at 16pt
with synthetic-style behavior; it keeps the native macOS SF Mono character
while supplying Nerd Font glyphs. The
shared Brewfile also declares JetBrains Mono, Caskaydia Mono, Meslo LG, Fira
Code, Bitstream Vera Sans Mono, and Iosevka Nerd Fonts as switchable options.

**Rationale:** One palette prevents terminal colors from drifting away from
the editor and prompt. A self-contained template is sufficient; Omarchy's
theme-switching runtime is neither present nor required. The other font casks
remain available for deliberate future evaluation rather than configuring
fallbacks speculatively.

**Consequences:** Ghostty uses the palette's existing semantic roles; no new
color values are introduced. It uses a one-cell taller line height, bright ANSI
colours for bold text, 14px balanced padding, a 50 MiB scrollback limit, and
completion notifications for unfocused commands that run for at least 10
seconds. `Ctrl+\`` toggles a 40%-high, autohiding top quick terminal. The
Omarchy-derived `window-theme=ghostty` and `async-backend=epoll` remain
temporarily, but are Linux/Hyprland-oriented and should be reassessed if their
macOS behavior matters. Ghostty auto-updates are disabled because Homebrew is
the update authority. The template omits initial window dimensions because
Hyprspace owns placement and sizing. Platform-specific defaults—such as sRGB
colour interpretation, native macOS chrome, and GTK/systemd resource
controls—remain implicit unless a concrete need arises.

**Implementation / validation:** Render with `chezmoi execute-template --file
home/dot_config/ghostty/config.tmpl`, then inspect `chezmoi status`, `chezmoi
diff`, and `git diff --check`. Do not apply without explicit authorization.

## 2026-09-07 — Render P10K colors from the canonical palette

**Status:** accepted

**Context:** The P10K wizard configuration expresses its classic prompt using
ANSI colour indices, while `themes/catppuccin-contrast.toml` is this
repository's authoritative palette.

**Decision:** Place the source at `home/dot_config/zsh/dot_p10k.zsh.tmpl`. At
render time, parse `../themes/catppuccin-contrast.toml` with chezmoi's
`fromToml` and use
only existing, semantically nearest palette colours for P10K foregrounds and
backgrounds.

**Rationale:** The rendered target remains a plain Zsh P10K configuration and
has no runtime parser or duplicated palette. Editing the palette updates every
rendered P10K colour consistently.

**Consequences:** ANSI colour indices no longer determine the managed P10K
appearance. Render the template before testing it; do not edit the rendered
target as the source of truth.

**Implementation / validation:** Run `chezmoi execute-template --file
home/dot_p10k.zsh.tmpl`, validate the rendered output with `zsh -n`, and run
`git diff --check`. No `chezmoi apply` occurs as part of this decision.

## 2026-09-07 — Retire Starship and retain Powerlevel10k configuration

**Status:** accepted

**Context:** Matching Powerlevel10k's Powerline boundaries in Starship required
adjacent-module state. Starship independently renders optional modules, so an
exact match would require a custom renderer that duplicated Starship's prompt
logic.

**Decision:** Remove all managed Starship configuration, initialization,
package declaration, and tests. Preserve the supplied P10K configuration at
`home/dot_p10k.zsh`, but do not install or initialize P10K yet. Keep the
palette independently in `themes/catppuccin-contrast.toml`.

**Rationale:** A custom adjacency renderer would make Starship an unnecessary
data source rather than the prompt engine. A data-only TOML palette is
machine-readable, avoids polluting the shell environment, and can be mapped
directly into future Ghostty, VS Code, Neovim, or other application formats.

**Consequences:** Prompt behavior remains unchanged on target machines until
P10K is explicitly installed and initialized. Future theme configuration must
copy or generate its color values from the palette data rather than reusing a
prompt-specific configuration.

**Implementation / validation:** Validate `home/dot_p10k.zsh` with `zsh -n`,
validate the palette as TOML, and run `git diff --check`. No `chezmoi apply`
occurs as part of this decision.

## 2026-09-07 — Use Starship for the managed shell prompt

**Status:** superseded by the 2026-09-07 P10K-retention decision

**Context:** The user supplied a Powerlevel10k configuration with a
Powerline-style prompt, Git detail, command status and duration, active
environments, cloud context, and a clock.

**Decision:** Use Starship and manage its standard configuration at
`home/dot_config/starship.toml`. Initialize it from `home/dot_zshrc`. Preserve
the supplied layout through native Starship modules and small inline custom
modules for Powerlevel10k's directory-icon states, conditional left tails, and
the first right-prompt wedge.

**Rationale:** Starship natively supplies the requested Git, duration, job,
direnv, language, cloud, Nix, and time information in one portable
configuration. Two conditional status modules use the shell's exported exit
status to select the correct green or red first wedge. Its project-language
modules replace p10k's manager-specific version segments, which avoids
maintaining one wrapper per version manager.
Starship only natively distinguishes the home directory; one inline command
supplies p10k's read-only, `/etc`, home, home-subdirectory, and folder icons.
Two mutually exclusive tails preserve the final directory or Git triangle.

**Consequences:** `starship` belongs in the shared Brewfile. Exact p10k-only
segments (such as its unique-prefix directory shortening and file-manager
indicators) remain intentionally absent until a concrete need justifies a
custom module. Individual PUA glyph scaling remains a terminal-font concern;
Starship cannot request it.

**Implementation / validation:** Run `tests/test_starship_directory_icon.sh`,
then `starship prompt` and start a fresh interactive Zsh session after
`chezmoi apply`; inspect the resulting prompt in a Git repository and an
activated environment.

## 2026-09-06 — Use enhanced Frappé accents on the Mocha neutral ramp

**Status:** accepted

**Upstream inspiration:** [Catppuccin palette](https://github.com/catppuccin/catppuccin) and its [style guide](https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md)

**Attribution:** Catppuccin selected the original Frappé hues, their
relationships, and the aesthetic foundation of this palette. This repository
does not claim authorship of those color choices. Its contribution is limited
to the documented lightness/chroma transformation and combination with the
stock Mocha neutral ramp.

**Context:** Catppuccin's dark palettes preserve hue harmony and a restrained
pastel character, but their relatively high-lightness accents can make syntax
colors read as different varieties of near-white on a dark background. The
problem is accent-to-accent discrimination, not only foreground-to-background
contrast.

**Decision:** Use a personal derived palette: **enhanced Frappé accents +
Mocha neutral ramp**. “Frappé HD on Mocha” is an informal shorthand only; it
is not an official Catppuccin flavor or an upstream-endorsed palette.

Use the enhanced accents and unchanged stock Mocha neutral ramp defined in
[`themes/catppuccin-contrast.toml`](themes/catppuccin-contrast.toml).
Its `[colors]` table is the sole source of color values; this decision records
their provenance and design rationale rather than duplicating the palette.

Its intended hierarchy is:

```text
text → subtext → overlay → surface → base → mantle → crust
```

**Rationale:** Accent colors and neutral UI colors have different jobs.
Accents require semantic distinction; neutrals require low salience,
monotonic hierarchy, and separation without competing with content. The
darker Mocha background improves accent-to-background contrast, while the
enhanced Frappé accents improve accent-to-accent discrimination.

The accent values were derived conceptually in OKLCH/OKLab, whose `L`, `C`,
and `h` correspond to perceptual lightness, chroma, and hue. HSL is not used
for this reasoning because its lightness and saturation are not perceptually
uniform. Starting with Frappé accents, the conceptual transform is:

```text
L' = L_mean + 1.35 * (L - L_mean) - 0.05
C' = 1.50 * C
h' = h
```

Out-of-gamut results are mapped or clipped to sRGB. This is a derivation
description, not a generator: the hex values in the TOML `[colors]` table are
the source of truth.
The transform expands existing lightness differences, shifts accents slightly
darker, and raises chroma while retaining Frappé hue identity. It avoids both
the washed-out appearance of brighter pastels and a neon/high-saturation
aesthetic.

**Rules for future changes:**

- Prefer perceptual discrimination over strict upstream palette purity. If
  syntax colors are difficult to distinguish in normal use, treat that as a
  design problem.
- Preserve hue identity before changing hue. Adjust OKLCH lightness and chroma
  first; alter hue only when additional separation is necessary.
- Do not apply the accent transform to neutral colors. Maintain the Mocha
  neutral hierarchy unless a UI-hierarchy problem warrants a separate change.
- Do not improve contrast merely by increasing brightness. Keep accents
  restrained rather than moving toward a neon aesthetic.
- Evaluate changes as a coherent palette system, including syntax and UI
  roles, rather than as isolated hex-value tweaks.

**Consequences:** Future Ghostty, tmux, Neovim, VS Code, or other theme
configuration should reference these names and values, while preserving the
distinction between the derived accent palette and official Catppuccin
concepts. At the time of this decision, no theme configuration was managed.
The later P10K and Ghostty rendering decisions document its current consumers.

**Implementation / validation:** `themes/catppuccin-contrast.toml` is the
machine-readable source of truth. When a theme configuration is added, map its
values from that file and validate terminal/editor syntax roles in normal use.

## 2026-09-03 — Keep Zsh startup responsibilities separate

**Status:** accepted

**Reference:** [How Do Zsh Configuration Files Work?](https://www.freecodecamp.org/news/how-do-zsh-configuration-files-work/)

**Context:** The first managed Zsh configuration is planned. Zsh startup files
run in different shell modes, so putting interactive settings in a universally
loaded file can affect scripts and automation unexpectedly.

**Decision:** Manage `~/.zprofile` for login-session environment variables
such as `PATH` and `EDITOR`. Manage `~/.zshrc` for interactive aliases,
functions, completion, prompt, and plugins. Do not add managed `.zshenv` or
`.zlogin` files unless a concrete requirement needs their narrower lifecycle.
Scripts must set the environment they require themselves.

**Rationale:** On macOS, Terminal sessions are login shells, and macOS's
`path_helper` runs before `.zprofile`; this preserves intended `PATH` ordering
while keeping interactive customizations out of non-interactive shells.

**Consequences:** New Zsh settings must be assigned to their appropriate
startup phase instead of accumulating in one file. Adding `.zshenv` or
`.zlogin` requires documenting the specific lifecycle requirement.

**Implementation / validation:** The
[2026-09-08 XDG bootstrap decision](#2026-09-08--bootstrap-zsh-from-the-xdg-configuration-directory)
updates the original startup paths and documents the additional lifecycle
files. `home/dot_config/zsh/dot_zprofile` initializes Homebrew from its
standard Apple Silicon or Intel prefix; `home/dot_config/zsh/dot_zshrc` loads
Zinit. Verify current files with `zsh -n <file>` and fresh login and non-login
interactive Zsh sessions.

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
