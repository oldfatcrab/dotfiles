# Squirrel input method

## Current configuration

`home/private_Library/Rime/default.custom.yaml` maps to
`~/Library/Rime/default.custom.yaml`. It replaces `switcher/hotkeys` with
only `F4`, removing both `Control+grave` and `Control+Shift+grave`.
`grave` is the backtick key beside `1`; removing `Control+grave` avoids
conflicting with the Ghostty quick terminal.

Keep the native user-data directory rather than adding an XDG symlink.
Manage individual custom files only: `build/`, `*.userdb/`, `user.yaml`,
and `installation.yaml` remain application-owned. No appearance override
is currently managed. `.chezmoiignore.tmpl` excludes `Library/Rime/` on
non-macOS systems.

## Reference boundary

This is a local macOS shortcut requirement, not an Omarchy port; no Omarchy
input-method counterpart was evaluated. The Squirrel maintainer explains
that `installation.yaml` cannot redirect the user-data directory, while
filesystem symlinks are possible in [issue #1057](https://github.com/rime/squirrel/issues/1057).

## Deployment and validation

After an authorized configuration update, use Squirrel's **Deploy** menu
or its installed command:

```bash
'/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel' --reload
```

On 2026-09-26, the target custom file was updated and Squirrel reloaded.
`~/Library/Rime/build/default.yaml` then contained only `F4` under
`switcher/hotkeys`; `scripts/validate-source.sh` passed. This verifies the
deployed configuration, not end-to-end keyboard handling: manually check
that F4 opens the scheme switcher and Control+grave opens Ghostty.
