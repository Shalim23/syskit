# syskit

A personal systems-engineering monorepo of small, self-contained building blocks written from scratch to sharpen low-level design, concurrency, memory/resource discipline, and protocol engineering skills.

## Core Principles

- **100% Human-Written Code:** Every implementation, test suite, property/fuzz test, and benchmark is written by hand. AI harnesses operate strictly as specification authors and adversarial reviewers under [AGENTS.md](AGENTS.md).
- **Focused Scope:** Each subproject is an isolated, concrete component defined iteratively per session rather than a monolithic framework.
- **Mechanical Pass Bar:** No subproject is marked `done` without passing strict compiler/typecheck flags, adversarial tests, applicable sanitizers, and an explicit 5-axis design critique.

## Repository Layout

| Path | Purpose |
| :--- | :--- |
| [AGENTS.md](AGENTS.md) | Canonical rules for AI coding harnesses (zero code generation, deep plain-language specs, 5-axis adversarial review). |
| [CLAUDE.md](CLAUDE.md) | Import shim (`@AGENTS.md`) for Claude Code compatibility. |
| [templates/TRACKER.md](templates/TRACKER.md) | Standard progress, critique, and verification tracker copied into each subproject. |
| `projects/<slug>/` | Individual self-contained subprojects, each with its own `TRACKER.md`. |

## Subprojects

| Subproject | Summary | Stack | Status | Tracker |
| :--- | :--- | :--- | :--- | :--- |
| _None yet_ | _Subprojects are scoped and added iteratively per session._ | — | — | — |
