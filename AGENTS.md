# Stardust-3 Development Guide

## Project Overview

Stardust-3 is a heavily modified Star Wars Galaxies server emulator derived from Core3.

The codebase primarily uses:

- C++
- Lua
- IDL
- SQL
- XML and object-template-related configuration

Many gameplay systems span multiple languages and engine layers. Search for existing implementations and established Core3 patterns before creating new systems.

## General Development Philosophy

- Extend existing engine systems instead of introducing unnecessary new architecture.
- Prefer consistency with Core3 over stylistic modernization.
- Avoid third-party libraries unless explicitly requested.
- Minimize refactoring unrelated to the requested change.
- Prefer localized, low-risk modifications.
- Prioritize stability and maintainability over cleverness or premature optimization.

## Stardust-3 Preferences

When solving problems:

- Fix the underlying cause rather than adding workarounds.
- Preserve existing gameplay unless the requested feature intentionally changes it.
- Search the repository before adding new classes, functions, fields, or systems.
- Keep changes small and focused.
- Explain compiler errors instead of only supplying a patch.
- Explain crash backtraces and identify the original invalid pointer, object, or assumption.
- Choose the least invasive solution when several valid approaches exist.
- Do not rewrite unrelated code.
- Preserve compatibility with the existing server architecture and data model.

## Code Style

Follow the conventions in the surrounding Core3 files.

- Preserve existing indentation, brace placement, spacing, and naming.
- Do not rename code merely for style.
- Avoid modern C++ constructs when they conflict with surrounding code or supported compilers.
- Do not replace engine pointer or synchronization types with STL equivalents unless explicitly requested.
- Use established engine types where appropriate, including `ManagedReference`, `Reference`, `WeakReference`, and `Locker`.
- Avoid broad formatting-only changes.

## Pointer and Object Safety

- Never dereference a pointer before validating it when it may legitimately be null.
- Never remove a null check without proving the object is always valid.
- Do not assume a creature is currently in a zone, cell, building, or scene during login, logout, transfer, cloning, destruction, or delayed tasks.
- Be careful with `getZone()`, parent lookups, `dynamic_cast`, scheduled tasks, destroyed objects, transferred objects, and references captured before a zone switch.
- Additional null checks should protect valid edge cases, not hide lifecycle bugs.

## Gameplay Rules

- Preserve existing gameplay outside the requested scope.
- Do not rebalance professions, combat, abilities, experience, economy, loot, spawns, or rewards unless requested.
- When adding persistent state, verify initialization, persistence, reset behavior, bounds, and compatibility with existing characters.
- Confirm that per-player counters or flags are truly stored per player and survive restarts when expected.

## C++ Changes

Before modifying a C++ function:

1. Find its declaration and implementation.
2. Find callers and related functions.
3. Identify ownership, locking, and lifetime expectations.
4. Determine whether it runs synchronously or through a scheduled task.
5. Preserve behavior outside the requested change.

When adding a method, verify all required declarations, implementations, generated interfaces, includes, and registrations remain synchronized.

Avoid unnecessary includes and public-interface changes.

## Lua Screenplays

- Keep scripts simple and consistent with existing screenplay patterns.
- Reuse existing helpers, observers, screenplay states, conversation handlers, and SUI patterns.
- Do not duplicate engine functionality in Lua when C++ already provides it.
- Avoid unnecessary globals.
- For random coordinates, verify bounds, terrain height, water, inaccessible areas, and cell requirements.
- For dialogue or SUI changes, ensure repeated interactions do not duplicate windows, observers, rewards, or quest state.

## IDL Changes

IDL declarations and C++ implementations must remain synchronized.

When adding or changing an IDL method, verify:

- It is declared in the correct IDL class.
- The implementation exists in the matching implementation class.
- Signature and return type match exactly.
- Generated headers expose it where expected.
- The method logically belongs to that class.
- A clean rebuild is performed when generated files require regeneration.

Do not move a method between `PlayerObject.idl` and `PlayerManager.idl` merely to silence a scope error. Correct ownership and the call site.

## Database, Serialization, and Network Safety

- Avoid schema changes unless explicitly requested.
- Avoid modifying serialization, object variables, baselines, deltas, or packet structures unless required.
- Do not change network layouts or client expectations without identifying the client-side dependency.
- When adding persistent fields, confirm compatibility with existing serialized characters and database records.

## Client Files and TRE Assets

- Do not modify TRE assets, client data files, client executables, or client-only resources unless explicitly requested.
- Do not assume matching client modifications exist.
- Prefer server-side changes that work independently.
- Clearly identify when mirrored client and server changes are required.
- Do not fabricate client file names, template paths, CRC values, or TRE contents.

## Build Environment

The authoritative build and runtime environment is Debian Linux.

Compilation is typically performed on the Debian VPS with:

```bash
make -j$(nproc)
```

Development edits are made on Windows in Eclipse, committed with GitHub Desktop, pushed to GitHub, pulled to the Debian VPS, built, run under GDB, and then tested through the SWG client.

Code must remain compatible with the GCC version and libraries used on Debian. Do not assume successful parsing on Windows proves the project will compile under GCC.

## Preferred Workflow

Before editing:

1. Inspect the relevant files.
2. Search for similar implementations.
3. Find declarations, implementations, and call sites.
4. Identify persistence and client-side implications.
5. State important assumptions.

After editing:

1. Review the diff.
2. Check for pointer and lifecycle risks.
3. Check declarations and signatures.
4. Check for unrelated changes.
5. Identify what must be compiled and tested.

## Debugging Workflow

### Compiler Errors

1. Explain what the error means.
2. Identify the declaration, scope, type, include, or signature responsible.
3. Trace it to the smallest root cause.
4. Produce the smallest appropriate fix.
5. Do not rewrite unrelated code.
6. Note when a clean rebuild or generated-file refresh is needed.

Do not resolve a compiler error by moving methods between classes unless the method logically belongs there.

### Server Crashes

1. Analyze the GDB backtrace.
2. Identify the first invalid pointer, object, reference, or assumption.
3. Explain the call chain leading to the crash.
4. Determine why the value became invalid or null.
5. Fix the root cause.
6. Add defensive checks only where the invalid state is legitimate.
7. Avoid masking required behavior.

When GDB reports a member call with `this=0x0`, treat that as evidence the object was dereferenced before validation.

### Runtime and Gameplay Failures

A successful build does not prove the gameplay change works.

Runtime verification may include:

- Starting the server under GDB.
- Checking startup crashes.
- Logging in through the SWG client.
- Reproducing the affected behavior.
- Reviewing server logs and client messages.
- Confirming persistence after relog or restart.
- Ensuring repeated use does not duplicate objects, rewards, tasks, or UI windows.

When gameplay testing fails without a crash, trace both the expected path and all conditions that may cause an early return.

## Scheduled Tasks and Concurrency

- Scheduled tasks may run after the player, zone, parent, or scene state has changed.
- Verify stored references are still valid at execution time.
- Respect existing locking patterns.
- Do not remove `Locker` usage without understanding lock ordering.
- Avoid raw pointers across delayed execution when engine reference types are expected.

## Feature Development

When adding a feature:

1. Search for an analogous feature.
2. Reuse existing managers, tasks, screenplay patterns, and data structures.
3. Avoid duplicated code.
4. Limit the initial implementation to the requested scope.
5. Identify persistence, lifecycle, and client dependencies.
6. Explain important side effects.

Do not create a large framework for a localized feature unless explicitly requested.

## Documentation

For non-trivial changes, briefly explain:

- What changed.
- Why it changed.
- Which files were affected.
- Possible side effects.
- What must be compiled and tested.

Do not add excessive source comments. Comment only where behavior, ownership, synchronization, or engine constraints are not obvious.

## Git and Repository Hygiene

- Do not commit build output, temporary files, IDE metadata, crash dumps, or local configuration unless intentionally tracked.
- Do not alter `.gitignore`, build scripts, submodules, or repository-wide configuration unless required.
- Keep changes focused on one logical task where practical.
- Before proposing a commit, summarize changed files and expected behavior.

## If Information Is Incomplete

Do not invent architecture, file locations, signatures, object ownership, client behavior, or gameplay rules.

Search the repository for evidence. When evidence is insufficient, state the uncertainty and identify what needs inspection before making a potentially unsafe change.
