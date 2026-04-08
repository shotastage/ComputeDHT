# Project Guidelines

## Scope

- This repository is a mixed Swift and Rust codebase. Keep changes local to the layer you are working in instead of spreading logic across packages.
- Use this file as the workspace-wide instruction source. Do not add a parallel `.github/copilot-instructions.md` unless explicitly requested.
- Prefer small, reviewable changes that preserve existing public APIs unless the task requires an API change.

## Repository Map

- `Sources/` contains the main Swift package targets such as `ComputeDHT`, `CoreOverlay`, `OverlayDHT`, `OverlayFundation`, `CoreRuntime`, and `OverlayCLI`.
- `Tests/` contains the Swift test targets for the package.
- `rs-src/` contains the Rust workspace, shared configuration, and internal crates.
- `apps/macos/` contains the Xcode app. `apps/electron/`, `apps/linux/`, and `apps/windows/` are platform-specific surfaces and should not be changed unless the task is explicitly about them.
- `docs/` contains the canonical architecture notes. Read the relevant document before changing package boundaries or cross-cutting behavior.
- `resources/` contains examples, sample programs, and packaging assets. Treat these as reference material unless the user asks to edit them.

## Architecture

- Treat `docs/Package.md` as the source of truth for package boundaries and dependency direction.
- Keep low-level packages independent from higher-level ones. Do not introduce dependencies that invert the layering described in `docs/Package.md`.
- Keep `OverlayDHT` focused on Kademlia and routing behavior, `CoreRuntime` focused on WebAssembly runtime concerns, `CoreOverlay` focused on networking and integration, and `OverlayCLI` focused on command-line behavior.
- When a change affects architecture, layering, or a cross-package contract, update the relevant document in `docs/` in the same change.

## Build And Test

- For routine Swift package work, prefer `swift build` and `swift test` from the repository root.
- For Rust work, run commands from `rs-src/`, for example `cd rs-src && cargo build` and `cd rs-src && cargo test`.
- Use `make build` only when the task requires the full packaging and cross-toolchain workflow. It is heavier than normal package development.
- If Rust tooling is missing on the machine, use `tools/setup-toolchains.sh` before assuming the Rust workspace is broken.
- Prefer validating only the affected area first, then expand to broader verification if the change crosses package boundaries.

## Editing Conventions

- Follow `.editorconfig`: use spaces by default, use 4-space indentation in Rust, and preserve tabs in `Makefile`-style files.
- Match existing naming patterns. Swift types use PascalCase, Rust functions and modules use snake_case.
- For Swift code, write clear Xcode Quick Help style documentation comments (`///`) for types, methods, and non-trivial logic so other engineers can understand the implementation quickly during review.
- Preserve established project terminology and prefixes such as `K*` for Kademlia-related Swift types and `CO*` for CoreOverlay utility types where existing code already uses them.
- Avoid broad refactors, mass renames, or formatting-only edits unless explicitly requested.

## Risky Areas

- Do not edit generated or dependency-managed content unless the task requires it: `.build/`, `.swiftpm/`, `Package.resolved`, Rust `target/`, and Xcode project internals.
- Avoid changing `resources/example-program/`, `resources/example-config/`, and packaging files under `resources/packaging/` unless the task is specifically about examples or distribution.
- Avoid touching multiple app frontends for a core library task. Most tasks should stay within `Sources/`, `Tests/`, or the relevant crate under `rs-src/crates/`.

## Docs To Consult

- Read `docs/Package.md` for package structure and dependency rules.
- Read `docs/Overview.md` for the overall platform direction.
- Read `docs/CapsuleVM.md` for WebAssembly runtime work.
- Read `docs/FileSystem.md` for distributed storage and filesystem behavior.
- Read `docs/SuperNode.md` when changing node discovery, routing, or governance-related behavior.
