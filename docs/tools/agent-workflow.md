# Agent workflow and source validation

## Current configuration

`AGENTS.md` is the canonical contributor contract and `CLAUDE.md` points to it.
`docs/agents/` defines GitHub Issues, triage labels, and the single-context
domain-document layout. `scripts/validate-source.sh` renders managed templates,
syntax-checks shell sources, validates managed JSON, and runs `git diff --check`.

## Omarchy reference and divergence

Omarchy has agent-oriented product and source material, but no Omarchy agent
runtime is installed or configured by this repository. These documents govern
repository contribution only. They borrow the general goal of an intentional,
agent-friendly system while retaining explicit authority boundaries for GitHub,
deployment, and external writes.

**Sources:** [Omarchy AI manual](https://omarchy.org/manual/ai/) and the
[quattro default tree](https://github.com/omacom/omarchy/tree/quattro/default).
No verified Omarchy source configures this repository's agent workflow.

## Validation boundary

Run the validation script before handoff. It verifies source consistency, not
target deployment; `chezmoi apply` still requires explicit authorization.
