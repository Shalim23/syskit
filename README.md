# syskit

A monorepo of small, focused, reusable systems building blocks in **modern C++20/23**, **modern Python (3.12+)**, and native interop via **`nanobind`**.

Each brick is designed as an isolated micro-component (~100–250 LOC) with a mechanical pass bar: strict typing, unit and property/fuzz tests, sanitizers (`ASan`, `UBSan`, `TSan`), and benchmarks.

---

## Architecture & Tracks

### Track A — Modern C++20/23
Focus on zero-overhead abstractions, cache awareness, memory safety, and concurrency.

* **C1: Binary Wire Codec** — Endian-safe reader/writer utilizing `std::span<const std::byte>`, `concepts` (`trivially_copyable`), `std::expected`, and `std::bit_cast`. Zero heap allocation.
* **C2: Arena / Block Pool Allocator** — Custom `std::pmr::memory_resource` implementation with RAII handles and explicit alignment.
* **C3: Cancellable Thread Pool** — Bounded queue with backpressure using `std::jthread`, `std::stop_token`, and `std::condition_variable_any`.
* **C4: Lock-Free SPSC Ring Buffer** — Cache-line padded (`alignas(64)`), `constexpr`-sized single-producer single-consumer ring buffer with `acquire`/`release` semantics.

### Track B — Modern Python 3.12+
Focus on high-throughput I/O, strict typing, and zero-copy protocols.

* **P1: Async Bounded Pipeline** — Rate-limited, timeout-bounded execution pipeline using `asyncio.TaskGroup`, `asyncio.timeout`, and PEP 695 generics.
* **P2: Zero-Copy Stream Framer** — Length-prefixed TCP stream reassembler using `memoryview` slicing, `bytearray`, and `struct.Struct`.
* **P3: Deterministic Resource CLI** — CLI scaffold with deterministic cleanup via `contextlib.ExitStack` and structured logging.

### Track C — Native Interop (C++ ↔ Python)
Bridge C++ performance and Python ergonomics using `nanobind`.

* **X1: Python-Fuzzed C++ Parser** — Exposing C++ wire decoders to Python `hypothesis` harnesses via zero-copy buffer views.
* **X2: GIL-Free Parallel Runner** — Releasing the GIL (`nb::gil_scoped_release`) for parallel multicore C++ execution driven by Python.
* **X3: Shared-Memory Event Tap** — Inter-process zero-copy communication via POSIX/Windows shared memory and Python's buffer protocol (`__buffer__`).

---

## Technical Stack & Standards

* **C++:** C++23 standard, CMake, `Catch2`, `google-benchmark`, Clang sanitizers (`-fsanitize=address,undefined,thread`).
* **Python:** Python 3.12+, `uv`, `mypy --strict`, `pytest`, `hypothesis`.
* **Bindings:** `nanobind` with `scikit-build-core`.
