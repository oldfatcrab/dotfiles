# Implementation history

This is a compact, commit-by-commit index for changes made after
`889d46408030fdc3d20c09a9595b7bacbe075536`. It is historical context, not an
installation guide: current source files define behaviour, while
[DECISIONS.md](../DECISIONS.md) records durable rationale and
[TODO.md](../TODO.md) records planned work.

For the current configuration and per-tool Omarchy comparisons, start at
[the tool-document index](tools/README.md); use
[Omarchy reference research](omarchy-reference-research.md) for the shared
configuration-model boundary and
[Omarchy tool source index](omarchy-tool-source-index.md) for primary sources.

| Date | Commit | Change and current source of truth |
| --- | --- | --- |
| 2026-09-01 | `851559f` | Added the decision log and Omarchy-derived roadmap: [DECISIONS.md](../DECISIONS.md) and [TODO.md](../TODO.md). |
| 2026-09-01 | `42d388f` | Established the first shared shell-tool package baseline and the initial personal casks in `Brewfiles/`. The manifests, not this record, define the current package set. |
| 2026-09-01 | `ba9ea60` | Expanded the macOS package baseline for terminal, TUI, GUI, browser, service, web-app, and font roles; documented macOS-specific substitutions in [DECISIONS.md](../DECISIONS.md). |
| 2026-09-01 | `5ce7f31` | Split Tailscale into the `tailscale` formula and `tailscale-app` cask in `Brewfiles/Brewfile.base`. |
| 2026-09-01 | `dcfdc4c` | Removed Chromium from the shared manifest, left it deferred in [TODO.md](../TODO.md), and made non-core tap trust explicit in the Brewfile. |
| 2026-09-03 | `876fa0a` | Declared separate Zsh startup-file roles with empty chezmoi source-state files; the durable role boundary is in [DECISIONS.md](../DECISIONS.md). |
| 2026-09-03 | `de2daf1` | Replaced the root `.zprofile` and `.zshrc` placeholders with the first minimal interactive configuration and added `zinit`. Those files were later moved under `home/dot_config/zsh/`. |
| 2026-09-06 | `000f784` | Added a Starship experiment. It was intentionally removed by `7f7a185`; no managed Starship configuration remains. |
| 2026-09-07 | `7f7a185` | Retired Starship, retained the supplied P10K configuration, and introduced `themes/catppuccin-contrast.toml` as the palette source. |
| 2026-09-07 | `7bb66c7` | Expanded the palette from a small color list into semantic Catppuccin Contrast roles. `themes/catppuccin-contrast.toml` remains the only palette authority. |
| 2026-09-07 | `75fbd1f` | Switched P10K to the selected two-line, transient-prompt layout. The current rendered configuration is `home/dot_config/zsh/dot_p10k.zsh.tmpl`. |
| 2026-09-07 | `23d1d7d` | Converted P10K to a chezmoi template that reads the canonical palette instead of managing literal P10K colors. |
| 2026-09-08 | `61a4eb4` | Added `home/dot_config/ghostty/config.tmpl`, rendered from the canonical palette, as the macOS terminal configuration. |
| 2026-09-10 | `aad4fe0` | Moved substantive Zsh startup files to `home/dot_config/zsh/`; root `home/dot_zshenv` now bootstraps `ZDOTDIR`. |
| 2026-09-10 | `b18e311` | Added the terminal-only bold ANSI ramp (`crimson` through `verdigris`) and enabled it through Ghostty; see the corresponding accepted decision. |
| 2026-09-10 | `fabfea3` | Co-located the P10K template with the rest of the XDG Zsh source and updated the loader path. |
| 2026-09-11 | `124da9c` | Added interactive Zsh tooling: bat/bat-extras aliases and cache hook, fzf settings, syntax highlighting, zsh-vi-mode, prompt loading, and related packages. |
| 2026-09-11 | `140c8b4` | Restored Ctrl-Left/Right word navigation by disabling the competing macOS Mission Control shortcuts in `run_after_40-disable-mission-control-space-shortcuts.sh.tmpl`. |
| 2026-09-11 | `d4eec2e` | Applied canonical-palette colors to fzf; `77d4bf4` subsequently converted that source file into the current template. |
| 2026-09-14 | `77d4bf4` | Added Fastfetch and a palette-rendered btop theme; Fastfetch startup is guarded in `home/dot_config/zsh/dot_zshrc`. |
| 2026-09-14 | `6ecd9c1` | Added `home/dot_config/btop/btop.conf` and refined the Fastfetch layout. |
| 2026-09-14 | `6de0ef1` | Simplified Fastfetch by removing its IDE-only schema URL and an invalid trailing comma; current behavior is in `home/dot_config/fastfetch/config.jsonc`. |
| 2026-09-15 | `1a25c4c` | Made root [AGENTS.md](../AGENTS.md) canonical, added the [CLAUDE.md](../CLAUDE.md) pointer, and documented GitHub Issue, triage-label, and domain conventions in `docs/agents/`. |
| 2026-09-18 | `a0ea814` | Replaced the deferred fzf-tab plan with Carapace, added palette-rendered vivid and Carapace styles, and preserved native fzf widgets. |
| 2026-09-18 | `6257995` | Added one canonical `vscode/settings.json.tmpl` plus thin macOS, Linux, and Windows adapters, selected by `.chezmoiignore.tmpl`. |
| 2026-09-22 | `592720d` | Added a palette-rendered `codex-theme-v1` import snapshot. Its observed-format limits are documented in [codex-theme-v1-format.md](codex-theme-v1-format.md). |
| 2026-09-22 | `c54a5af` | Vendored the LazyVim starter configuration and its lockfile under `home/dot_config/nvim/`; the evidence and runtime boundary are in [lazyvim-chezmoi-research.md](lazyvim-chezmoi-research.md). |
| 2026-09-22 | `eb62d3c` | Added shared LazyVim extras/tooling, updated the lockfile after target sync, added the OpenJDK registration guard to the Homebrew hook, and made the Catppuccin override render on every machine. |
| 2026-09-22 | `2d83977` | Added this historical index and refined the LazyVim research boundary. Per-tool documents now carry configuration comparisons. |
| 2026-09-22 | `c8f1543` | Added Neovim gap research and expanded `scripts/validate-source.sh` source checks; neither substitutes for a target-machine runtime check. |
| 2026-09-26 | `ba564ef` | Added `home/private_Library/Rime/default.custom.yaml` with an F4-only scheme switcher; see [Squirrel](tools/squirrel.md) for deployment and validation. |

## How to use this record

Start from the named current source file when changing behavior. Use the commit
only to inspect why a source path or policy changed, for example:

```bash
git show 6257995 -- vscode/settings.json.tmpl .chezmoiignore.tmpl
```

Do not use this document to infer target-machine installation or validation;
package declarations and repository-only checks are not evidence that a target
has run `chezmoi apply`.

When changing a tool, read its document, current source, relevant accepted
decision, and TODO item. Render affected templates, run the smallest relevant
check, then run `scripts/validate-source.sh` and `git diff --check`; inspect
`chezmoi status` and `chezmoi diff` before an explicitly authorized apply.
