# `codex-theme-v1` desktop theme payload

**Research date:** 2026-09-22
**Scope:** the ChatGPT/Codex desktop Appearance screen's `Copy theme` and
`Import` controls—not Codex CLI theming.

## Finding

OpenAI has not published a format definition, JSON Schema, field reference,
or compatibility guarantee for `codex-theme-v1`.

The only applicable official documentation found is the [Codex CLI
customization guide](https://developers.openai.com/docs/cli/customization). It
documents the unrelated terminal `tui.theme` setting and custom `.tmTheme`
files; it does not mention desktop Appearance import/export or
`codex-theme-v1`.

## Observable current payload

The desktop app's **Copy theme** control exported the following payload on
2026-09-22 (user-provided evidence):

```json
codex-theme-v1:{
  "codeThemeId": "catppuccin",
  "theme": {
    "accent": "#cba6f7",
    "accentSource": "custom",
    "contrast": 60,
    "fonts": { "code": null, "ui": null },
    "ink": "#cdd6f4",
    "opaqueWindows": false,
    "semanticColors": {
      "diffAdded": "#a6e3a1",
      "diffRemoved": "#f38ba8",
      "skill": "#cba6f7"
    },
    "surface": "#1e1e2e"
  },
  "variant": "dark"
}
```

The `codex-theme-v1:` prefix is outside the JSON value. This establishes only
that this desktop build exported these keys and values. It does **not**
establish required fields, accepted values, contrast bounds, font IDs,
backward compatibility, or that an import will remain portable across builds
or accounts.

## Configuration implication

Treat any checked-in payload as a convenient snapshot for manual import, not
as a stable source format. Preserve the prefix and valid JSON exactly when
copying it into the desktop app. Re-export it from the target app after an
upgrade before relying on it.
