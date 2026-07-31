# Agent Instructions for dotfiles Repository

## Critical Context

This is a **chezmoi** dotfiles repository. The **source directory** is `~/.local/share/chezmoi/`. The **source root** is `home/` (set by `.chezmoiroot`). Target OS is **macOS** with **Zsh** shell.

### The #1 Rule

**The `omarchy/` directory is READ-ONLY reference material.** Never modify files inside it. It contains Basecamp's Omarchy bash configurations used as inspiration for the Zsh migration.

## Repository Layout

```
.chezmoi.toml.tmpl      → Chezmoi config with prompted variables
.chezmoiignore.tmpl     → Conditional file ignoring (OS, work/personal)
.chezmoiroot            → "home" (source root is home/, not repo root)
Brewfiles/              → Homebrew package lists (outside chezmoiroot)
home/                   → Chezmoi source root → maps to $HOME
  dot_*                 → Regular dotfiles (dot_ prefix → . in target)
  empty_dot_*           → Empty placeholder files
  run_once_before_*     → Run once scripts (install homebrew)
  run_onchange_before_* → Run when content changes (packages)
  dot_config/           → Maps to ~/.config/
    ghostty/            → Ghostty terminal configuration
    hyprspace/          → Hyprspace / Aerospace tiling WM configuration
    nvim/               → LazyVim Neovim configuration
    sketchybar/         → Sketchybar status bar configuration
    tmux/               → Tmux terminal multiplexer configuration
    zsh/                → Modular Zsh config (env, aliases, functions, init)
omarchy/                → READ-ONLY Omarchy bash reference
```

## Chezmoi Conventions

### File Naming

| Prefix/Suffix | Meaning |
|---------------|---------|
| `dot_` | Replaced with `.` in target path |
| `empty_` | Creates empty file (content ignored) |
| `run_once_before_` | Runs once, before file sync |
| `run_onchange_before_` | Runs when file hash changes, before sync |
| `run_once_after_` | Runs once, after file sync |
| `.tmpl` | Processed as Go template |

### Template Variables

- `{{ .chezmoi.os }}` → `"darwin"` on macOS
- `{{ .chezmoi.arch }}` → `"arm64"` (Apple Silicon) or `"amd64"`
- `{{ .chezmoi.homeDir }}` → User's home directory
- `{{ .chezmoi.sourceDir }}` → Chezmoi source directory path
- `{{ .is_work_machine }}` → Boolean, prompted during `chezmoi init`

### Include Paths

Because `.chezmoiroot = home`, template `{{ include }}` paths to files **outside** `home/` need a `../` prefix:

```go
{{ include "../Brewfiles/Brewfile.base" | sha256sum }}  ← Correct
{{ include "Brewfiles/Brewfile.base" | sha256sum }}     ← WRONG (looks in home/)
```

## Style Guidelines

### Shell Scripts (`.sh.tmpl`)

- Use `#!/usr/bin/env bash` (not `#!/bin/bash` — this is macOS, not Omarchy Linux)
- Always `set -euo pipefail`
- Guard commands with `command -v tool &>/dev/null` checks
- Use `$HOME` or `{{ .chezmoi.homeDir }}` — never hardcode `/Users/<username>/`
- Homebrew paths: check `/opt/homebrew/bin/brew` (ARM) then `/usr/local/bin/brew` (Intel)

### Zsh Configuration (`.zsh`)

- All aliases and functions must degrade gracefully with `command -v` guards
- Use `typeset -U path fpath` to prevent PATH duplication
- Follow the Zsh file convention:
  - `~/.zprofile` → PATH, brew shellenv, EDITOR (login shell only)
  - `~/.zshrc` → plugins, prompt, aliases, functions (interactive shell)
  - `~/.zshenv` → leave empty on macOS (path_helper overrides it)

### Neovim (Lua)

- LazyVim is the base distribution — extend, don't replace
- Plugin specs go in `home/dot_config/nvim/lua/plugins/*.lua`
- User config goes in `home/dot_config/nvim/lua/config/{options,keymaps,autocmds}.lua`
- `lazy.nvim` bootstraps itself — no external clone scripts needed

## Brewfile Management

Two Brewfiles exist:

| File | Scope | When Used |
|------|-------|-----------|
| `Brewfiles/Brewfile.base` | All machines | Always |
| `Brewfiles/Brewfile.personal` | Personal machines | When `is_work_machine = false` |

To add a package: edit the appropriate Brewfile. Chezmoi detects the sha256 change and re-runs `brew bundle` on next `chezmoi apply`.

## Common Modification Patterns

### Adding a new Zsh alias

Edit `home/dot_config/zsh/aliases.zsh`. Guard with `command -v` if it depends on an optional tool.

### Adding a new tool/package

1. Add to `Brewfiles/Brewfile.base` (or `.personal`)
2. If it needs `eval "$(tool init zsh)"`, add the guarded eval to `home/dot_config/zsh/init.zsh`
3. If it has aliases, add to `home/dot_config/zsh/aliases.zsh`

### Adding a new zinit plugin

Edit `home/dot_zshrc.tmpl`, section 5. Use `wait lucid` for turbo-mode deferred loading. Syntax highlighting must load last.

### Adding OS-conditional logic

Use chezmoi Go templates:
```go
{{ if eq .chezmoi.os "darwin" -}}
# macOS-only content
{{ end -}}
```

## Validation Checklist

Before committing changes, verify:

- [ ] No hardcoded `/Users/` paths (`grep -rn '/Users/' home/`)
- [ ] Templates render: `chezmoi execute-template < home/file.tmpl`
- [ ] Managed files correct: `chezmoi managed --include=files`
- [ ] Diff looks right: `chezmoi diff`
- [ ] Relevant documentation updated (`README.md`, `MEMORY.md`, `.agents/AGENTS.md`)
- [ ] Shell scripts pass `shellcheck` (if available)

## Documentation Maintenance

- **Always update relevant markdown documentation** (`README.md`, `MEMORY.md`, `.agents/AGENTS.md`) whenever architectural, structural, or behavioral changes are made to the repository, configs, or scripts.

## Git

- **Always make a git commit after completing changes.**
- Commits must be atomic, descriptive, and clearly explain what was changed and why so future agents can easily understand the commit history.
- Follow conventional/best engineering commit message practices (e.g. `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`).
- Do NOT commit changes to `omarchy/` — it is a read-only reference directory.
- Test with `chezmoi diff` before committing.
