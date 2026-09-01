# Architecture decisions

This log records durable decisions that intentionally differ from Omarchy or
other reference setups. It explains *why* this repository chose a different
path, so future changes do not repeat the same evaluation.

## Entry format

Add new entries in reverse chronological order. Each entry should state the
context, decision, rationale, and consequences. Link the relevant source files
or external reference when useful.

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
