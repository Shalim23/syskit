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
| [CMakeLists.txt](CMakeLists.txt) | Root C++23 + `import std;` CMake build (`syskit::warnings` + `projects/*` discovery). |
| [CMakePresets.json](CMakePresets.json) | Clang 21 presets (`debug`, `release`, `asan`, `tsan`). |
| [.clang-tidy](.clang-tidy) / [.clang-format](.clang-format) | C++23 module-aware static analysis and formatting configuration. |
| [scripts/setup-ubuntu.sh](scripts/setup-ubuntu.sh) | Idempotent Ubuntu / WSL2 environment bootstrap (C++, sanitizers, Python/`uv`, `gh`). |
| [templates/TRACKER.md](templates/TRACKER.md) | Standard progress, critique, and verification tracker copied into each subproject. |
| `projects/<slug>/` | Individual self-contained subprojects, each with its own `TRACKER.md`. |

## C++23 Toolchain Usage

```bash
cmake --preset debug && cmake --build --preset debug && ctest --preset debug
clang-tidy -p build/debug projects/<slug>/**/*.cpp projects/<slug>/**/*.cppm
cmake --preset asan  && cmake --build --preset asan  && ctest --preset asan
cmake --preset tsan  && cmake --build --preset tsan  && ctest --preset tsan
```

## Subprojects

| Subproject | Summary | Stack | Status | Tracker |
| :--- | :--- | :--- | :--- | :--- |
| _None yet_ | _Subprojects are scoped and added iteratively per session._ | — | — | — |
