# T3 Code — Bicerin theme and portable appearance

## Ownership

- Homebrew: `Brewfiles/Brewfile.base` provides `cask "t3-code"`; no duplicate in `workstation-private`.
- Colors: `themes/bicerin.toml` is the sole value authority. Chezmoi renders `home/private_dot_t3/private_userdata/themes/bicerin.json.tmpl` to `~/.t3/userdata/themes/bicerin.json` (published theme ID `bicerin`).
- UI appearance: `home/dot_config/t3-code/appearance.json` is a portable **26-key allowlist**. Chezmoi installs it at `~/.config/t3-code/appearance.json`.
- Runtime merger: `home/dot_local/bin/executable_t3-appearance-apply` installs `~/.local/bin/t3-appearance-apply` and updates only approved fields in `~/.t3/userdata/client-settings.json`.
- `home/run_onchange_after_50-apply-t3-appearance.sh.tmpl` runs the merger and activates Bicerin after a normal chezmoi apply on macOS when T3's files and CLI exist. Re-run manually after the application's **first launch** if it was not installed yet.
- The original local `Cappuccin` theme (`cappuccin`) stays in Electron Local Storage. We neither modify LevelDB nor version runtime state, accounts, browser profiles, credentials, model preferences, or chat history.

## Appearance values

| T3 field | Managed value | Alignment |
| --- | --- | --- |
| `fontFamilySans`, `fontFamilyComposer` | `SF Pro` | macOS/SketchyBar interface font |
| `fontFamilyCode`, `fontFamilyTerminal` | `Liga SFMono Nerd Font` | VS Code editor and Ghostty |
| `fontSizeInterface`, `fontSizePrompt`, `fontSizeCode`, `fontSizeTerminal` | `15` | VS Code editor, chat, and integrated terminal |
| `fontSmoothing` | `true` | Preserve previously enabled smoothing |
| `appearanceContrast` | `100` | Preserve T3's existing local setting; not the same API/scale as Codex's `contrast` |
| `glassOpacity` | `80` | Preserve current transparency |
| `chatWidth` | `comfortable` | Preserve current layout |
| `panelAnimationDurationMs` | `0` | Preserve current reduced animation |
| Diff/sidebar/wrap/timestamps/effort | Existing local choices | Snapshot as portable visual defaults |

The JSON policy has the exact remaining appearance field values. Any new/changed T3 setting key requires a conscious update of the merger's allowlist; nonappearance settings must stay runtime-owned.

## Apply or reproduce

```sh
# From ~/workspace/dotfiles:
bash scripts/validate-source.sh
chezmoi apply ~/.t3/userdata/themes/bicerin.json ~/.config/t3-code/appearance.json ~/.local/bin/t3-appearance-apply
~/.local/bin/t3-appearance-apply
t3 theme set bicerin
t3 theme show
```

A normal full `chezmoi apply` also runs the on-change hook; avoid running a full apply merely to install T3 because it may touch unrelated managed configurations. The T3 CLI may need to be installed from the application first. A first-run T3 instance may not yet have `client-settings.json`; the merger skips it safely.

Before the first change, the merger makes a **local, permission-restricted** backup at `~/.t3/userdata/client-settings.pre-bicerin.json`; this file is deliberately *not* committed to dotfiles. The nonsecret, portable appearance policy **is** committed. The script writes atomically and preserves all unrelated fields. If T3 is running, reopen the app later to ensure it adopts changed fonts; we do not forcibly terminate active sessions.

## Validation and boundaries

Run `bash scripts/validate-source.sh`, `git diff --check`, inspect `chezmoi diff`, and verify the published theme via `t3 theme show`. The 59 T3-specific color roles plus two top-level colors derive from Bicerin's semantic palette. This is a personal Catppuccin-derived theme, not an upstream flavor.

Never add the entire `~/.t3/userdata` directory or Electron Local Storage database to this repo: they contain unrelated local/private state.
