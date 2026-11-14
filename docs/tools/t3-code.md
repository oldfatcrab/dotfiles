# T3 Code — managed Bicerin theme

## Ownership and installation

- T3 Code is installed by `Brewfiles/Brewfile.base` with `cask "t3-code"`. Do **not** duplicate the package declaration in `workstation-private`.
- The single color authority is `themes/catppuccin-contrast.toml` (enhanced Frappé accents / Mocha neutrals). **Bicerin** is the agreed display name; the older canonical filename remains unchanged to avoid breaking other consumers.
- Chezmoi renders `home/private_dot_t3/private_userdata/themes/bicerin.json.tmpl` into `~/.t3/userdata/themes/bicerin.json`. T3 Code publishes themes from this directory.
- The published theme is named **Bicerin** and has the ID `bicerin`, separate from the user's device-local **Cappuccin** custom theme (`cappuccin`). This avoids a documented precedence collision while preserving the original.
- The rendered JSON has two base colors (`canvas`, `accent`) plus 59 explicit T3 theme roles. Every hex color is resolved from the canonical palette. No secrets, app databases, or other user settings are managed by chezmoi.

## Apply or reproduce on another machine

```sh
# From ~/workspace/dotfiles:
bash scripts/validate-source.sh
chezmoi apply ~/.t3/userdata/themes/bicerin.json
t3 theme show
t3 theme set bicerin
```

The `t3` CLI may need to be installed via T3 Code's own settings on a new workstation; installing the Homebrew desktop cask alone does not guarantee it is on PATH.

The `t3 theme set` command publishes the environment's selected theme to connected clients; when offline they adopt it on reconnect. Alternatively, select **Bicerin** under T3 Code → Settings → Appearance after publishing. This command does **not** change T3 credentials, providers, or service/network configuration.

To update colors, edit only `themes/catppuccin-contrast.toml`, validate, re-apply the managed JSON, and run `t3 theme set bicerin` again. Do not edit Chromium Local Storage/LevelDB by hand. The existing custom `Cappuccin` remains a separate local theme that you may keep as a rollback.

## Scope and validation

Local custom T3 themes live in Electron Local Storage under `~/Library/Application Support/t3code-v2/Local Storage/leveldb/`; these files are *not* machine-portable templates and can be locked by the running application. Instead use T3's supported published-theme directory. The app currently exposes 61 color roles, including `canvas` and `accent`, which are represented as top-level values in the published JSON.

The theme uses role-appropriate Catppuccin neutrals for panels and UI text; mauve for the accent, teal/green/yellow/red for status, and rosewater for the terminal cursor. It is a local contrast variant, not an official upstream Catppuccin flavor.

Official reference: https://github.com/pingdotgg/t3code/blob/main/docs/user/appearance.md
