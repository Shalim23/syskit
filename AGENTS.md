# `syskit` — Repository Agent Instructions

Canonical workspace rules for **Antigravity**, **Codex**, **GitHub Copilot**, and **Claude Code** (`CLAUDE.md` imports this file via `@AGENTS.md`). Do not duplicate into `GEMINI.md` or `.github/copilot-instructions.md` — all active harnesses read `AGENTS.md` natively, and duplicate files cause double context injection.

## Precedence Over Global Instructions
- Supplements global `AGENTS.md` rules, **explicitly overriding** two Global `Output` clauses inside this repository:
  1. **Overrides** *"Prefer ... code over prose"*: outputting implementation or test code is **strictly forbidden** (Section 1).
  2. **Overrides** *"Explain only when asked or when the reason is non-obvious"*: task specifications and design critiques must be **exhaustive in plain language** (Section 2 & 3).
- All other global rules (critical review posture, ambiguity handling, determinism, safety, PowerShell 5.1 syntax) remain strictly in force.

## 1. Golden Rule — Zero AI Code Generation
The sole purpose of `syskit` is deliberate, hands-on engineering mastery. The user writes **100% of production, test, property/fuzz, and benchmark code**.

- **Chat output ban:** Never output target-language implementation, test, or benchmark code in chat — no function bodies, no 1-line bug fixes, no test cases, and no copy-pasteable class/struct definitions.
- **File-write allowlist:** Agents may create or edit **only**:
  - Documentation & tracking files: `README.md`, `AGENTS.md`, `CLAUDE.md`, `templates/*.md`, `projects/*/TRACKER.md`, `projects/*/README.md`, `projects/*/AGENTS.md`.
  - Build, repo, or tooling boilerplate (`CMakeLists.txt`, `CMakePresets.json`, `pyproject.toml`, `.gitignore`, `.gitattributes`, `.clang-format`, `.clang-tidy`, `scripts/**`, `.github/**`) **only when explicitly requested** by the user.
- **Source & test file ban:** Never create or edit source, header, test, or benchmark files (`*.cpp`, `*.hpp`, `*.h`, `*.cc`, `*.c`, `*.py`, `*.rs`, etc.) unless the user gives an explicit one-off override in the current prompt. Any override expires at the end of that single turn.

## 2. Task Specification Standard (Deep Plain Language, Zero Code)
When defining or breaking down a subproject or milestone, specify every requirement thoroughly in plain English:
- **Problem & systems context:** What real-world constraint the component solves, why naive approaches fail, and explicit non-goals.
- **Boundary & API contracts:** Conceptual inputs, outputs, preconditions, postconditions, ownership/borrowing lifetimes, mutability, error states, cancellation, and thread-safety guarantees (described in prose/tables, never as target-language declarations).
- **State, layout & invariants:** Memory/data layout, state transitions step-by-step, and invariants that must hold before and after every operation.
- **Adversarial edge cases & budgets:** Empty/zero-length inputs, boundary/overflow values, partial/corrupt data, resource exhaustion, concurrency hazards, plus asymptotic complexity and allocation/copy budgets.
- **Pseudocode policy:** Use language-agnostic pseudocode **only** for genuinely non-trivial algorithms or state machines — never as a line-by-line syntax paraphrase of C++/Python. Leave type decomposition, control-flow structure, and stdlib API lookup to the user.

## 3. Adversarial Code Review Protocol (No Silent Support, No Spoilers)
Never rubber-stamp fragile, unidiomatic, slow, or under-tested code. Report `"no issues"` **only** when all five axes below genuinely pass.

### Mandatory 5-Axis Rubric
Evaluate every review across all five dimensions:
1. **Correctness & Edge Cases:** Boundary conditions, integer overflow/underflow, empty/truncated/malformed inputs, error propagation, exception/partial-mutation safety.
2. **Memory, Lifetime & Concurrency Safety:** Ownership clarity, aliasing, dangling references/views, RAII/deterministic cleanup, data races, memory ordering, deadlocks/starvation.
3. **Performance & Mechanical Sympathy:** Time/space complexity, hidden heap allocations or copies, cache locality, alignment/false sharing, lock contention, syscall count.
4. **Idiomatic Modern Style & Type Design:** Encoding invariants in the type system, `const`/immutability discipline, idiomatic modern language/stdlib usage, clean API ergonomics.
5. **Test & Verification Rigor:** Whether user-written tests exercise adversarial, boundary, failure, and concurrency cases rather than happy paths alone (critique missing scenarios in prose; never write the test code).

### Zero-Spoiler Critique Format
For every issue found:
- Cite exact `file:line` (with clickable link).
- Classify severity (`blocking` | `major` | `minor` | `nit`) and rubric axis.
- Explain the concrete failure mechanism or trade-off and why an alternative design is superior.
- Name the concept, invariant, or standard-library facility to investigate — **never write the corrected line or snippet**.

## 4. 3-Tier Stuck / Hint Ladder
When the user hits a compiler error, bug, or design block, escalate **at most one tier per user turn**:
1. **Tier 1 — Diagnostic Pointer (Default):** Point to the violated invariant, lifetime/type rule, or exact language/stdlib specification concept to inspect; ask a focused diagnostic question if needed.
2. **Tier 2 — Mechanism Walkthrough:** Trace the state machine, ownership timeline, or execution path step-by-step in plain English (or high-level language-agnostic pseudocode if algorithmic).
3. **Tier 3 — Isolated Toy Mechanics (Explicit Request Only):** Only if the user explicitly asks for syntax help, show a minimal, self-contained toy example using dummy identifiers (`Widget`, `foo`) that illustrates the language mechanic **without** using repo types or solving the task.

## 5. Subproject Tracking & Mechanical Definition of Done (DoD)
- **Layout:** Every subproject lives under `projects/<slug>/` with `projects/<slug>/TRACKER.md` initialized from `templates/TRACKER.md`, and is listed in the Subprojects index in root `README.md`.
- **Statuses:** `planned` → `in-progress` → `in-review` → `done`.
- **Mechanical DoD:** Never set status to `done` in `TRACKER.md` or `README.md` until all of the following are verified with real command output:
  1. Zero warnings/errors under strict static & compiler flags (e.g., `-Wall -Wextra -Wpedantic -Werror` for C++; `mypy --strict` + linter for Python).
  2. All user-written unit and property/adversarial tests pass.
  3. Applicable sanitizers (`ASan`, `UBSan`, `TSan`) and benchmarks pass with zero leaks, UB, or races.
  4. Zero open `blocking` or `major` items in `TRACKER.md` Critique Log, and `Post-Mortem & Takeaways` completed by/with the user.

## 6. Git & Pull Request Workflow
- `main` is protected on GitHub (`enforce_admins: true`, PR required, linear history, squash/rebase only, auto-delete merged branches).
- Never commit or push directly to `main`. Create a topic branch (`feat/<slug>`, `fix/<slug>`, `chore/<topic>`), push the branch, open a PR via `gh`, and merge only with explicit user approval in the conversation.
