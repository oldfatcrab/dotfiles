# Repository instructions for automated contributors

## Required reading order

For every task, use this order:

1. Read this file, then inspect `git status` and the affected source files.
2. Read relevant accepted entries in `DECISIONS.md`; they constrain the change.
3. Read the relevant `TODO.md` item to determine whether the work is planned,
   completed, or explicitly out of scope.
4. Read `README.md` when the change affects user-facing setup or behavior.

Source files are authoritative for current behavior. `DECISIONS.md` records
durable tradeoffs, `TODO.md` records roadmap state, and `README.md` summarizes
the user-facing system. Do not treat a package declaration as proof that it is
installed on a target machine.

## Scope and layout

This is a minimal, macOS-oriented **chezmoi** repository. The source directory
is `~/.local/share/chezmoi/`; `.chezmoiroot` makes `home/` the source root, so
its contents map to the target home directory.

Use the following documentation boundaries:

- `README.md`: user-facing setup, behavior, and repository layout.
- `TODO.md`: roadmap, status, and acceptance criteria.
- `DECISIONS.md`: durable architecture decisions, including intentional
  divergences from Omarchy.
- `.agents/AGENTS.md`: contributor-only working rules.

Do not create or restore a separate project-memory document. Place durable
operational facts in the appropriate document above.

## Framework invariants

- `.chezmoi.toml.tmpl` prompts once for the boolean
  `is_personal_machine`. Use `get . "is_personal_machine"` in templates.
- `.chezmoiignore.tmpl` contains machine-conditional ignore patterns.
- `home/run_*` files are chezmoi scripts. Retain their naming prefixes,
  ordering, and `.tmpl` suffix unless changing execution semantics.
- `Brewfiles/Brewfile.base` is for all machines and contains the shared package
  baseline. `Brewfiles/Brewfile.personal` is for personal machines only and
  contains selected personal applications.

## Implementation rules

- Follow chezmoi source-state names: `dot_`, `empty_`, `run_once_`, and
  `run_onchange_`.
- Use Go templates for OS- or machine-specific behavior. Files outside `home/`
  require `../` in `include` paths from templates under `home/`.
- Shell scripts must use `#!/usr/bin/env bash`, `set -euo pipefail`, and
  `command -v` guards for optional programs. Do not hardcode user home paths.
- Do not add credentials or secrets in plaintext.
- Prefer minimal, reversible changes. Do not commit unless the user explicitly
  asks.

## Validation

- Render edited templates with `chezmoi execute-template` where practical.
- Run `chezmoi status` and `chezmoi diff` before applying source changes.
- Run `chezmoi ignored` after editing ignore rules and `chezmoi doctor` for
  setup issues.
- Run `git diff --check` before handoff.
- Keep README and TODO status accurate when behavior or roadmap changes.
- Treat a completed `TODO.md` item as a committed repository state unless its
  validation records a target-machine command result.
- Add a DECISIONS.md entry when deliberately choosing a different approach from
  Omarchy or another documented reference.
