# Repository instructions

## Before changing anything

- Inspect `git status` and the affected source files first.
- Source files define current behavior. Package declarations do not prove target-machine installation.
- Read `DECISIONS.md` when a task touches a durable architecture choice or an intentional divergence.
- Read the relevant open `TODO.md` item when changing roadmap scope or acceptance criteria.
- Read `README.md` when changing user-facing setup or behavior.

## Scope and ownership

This is a macOS-oriented chezmoi repository. `.chezmoiroot` makes `home/` the source root.

- Public dotfiles: portable shell, editor, desktop, palette, and shared package configuration.
- `workstation-private`: personal workstation choices such as personal Homebrew casks.
- `ai-workspace`: agent principles, Codex policy, protocols, tooling governance, and AI decision history.
- `~/.codex`: runtime-owned Codex sessions, caches, account/plugin state, and live config.

Do not add agent-system configuration, credentials, or runtime state to this repository.
## Implementation rules

- Follow chezmoi source-state names such as `dot_`, `empty_`, `run_once_`, and `run_onchange_`.
- Use Go templates for OS- or machine-specific behavior; preserve existing `home/run_*` ordering unless execution semantics change.
- Executable Bash scripts use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Zsh startup files use Zsh syntax and appropriate startup semantics.
- Guard optional commands, avoid hardcoded home paths, and never commit plaintext secrets.
- Prefer minimal, reversible changes and preserve unrelated user work.
- Local commits are appropriate at meaningful recovery boundaries. Do not push, open PRs, deploy, or run `chezmoi apply` without explicit intent.

## Validation

- Use the smallest relevant validation first.
- Render edited templates with `chezmoi execute-template` where practical.
- For managed-source, template, script, ignore-rule, or package changes, run `scripts/validate-source.sh`.
- For documentation-only changes, run `git diff --check` plus any targeted link/reference check.
- Inspect `chezmoi status` and `chezmoi diff` before any explicitly authorized apply.
- Update `README.md`, `TODO.md`, or `DECISIONS.md` only when their stated responsibility actually changed.
