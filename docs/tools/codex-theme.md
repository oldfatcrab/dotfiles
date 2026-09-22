# Codex Catppuccin Contrast import

## Current configuration

`themes/codex-catppuccin-contrast.json.tmpl` renders a `codex-theme-v1:`
appearance-import payload from canonical `mauve`, `text`, `base`, `green`, and
`red` keys. It keeps the observed built-in `catppuccin` code-theme ID and
leaves code/UI font fields `null`; the observed-format limits are documented in
[codex-theme-v1-format.md](../codex-theme-v1-format.md).

## Omarchy reference and divergence

Omarchy's AI tooling is workflow context only: no verified quattro source
configures a Codex desktop appearance import. This is a local desktop-app
configuration that shares palette ownership but is not an Omarchy theme port.

**Sources:** [Omarchy AI manual](https://omarchy.org/manual/ai/) and the
[quattro default tree](https://github.com/omacom/omarchy/tree/quattro/default).
No verified Omarchy Codex desktop-theme source exists.

## Validation boundary

Render the payload and confirm its import in the intended Codex surface. Do
not claim that the undocumented format exposes every semantic or font setting.
