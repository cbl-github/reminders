# Task Plan: Gurr Reminders macOS App

## Goal

Build a lightweight Swift/SwiftUI macOS reminder app with Apple-style UI, daily/weekly/monthly/semester/yearly reminder timing, optional pinned screen panel, and menu bar access.

## Current Phase

Phase 5: Delivery and macOS compile handoff

## Phases

### Phase 1: Requirements and Discovery

- [x] Capture user requirements: Swift app, Apple-style UI, low memory use, recurring reminders, pin-to-screen, menu bar, click-to-open.
- [x] Inspect workspace and determine whether an existing code project exists.
- [x] Check whether Swift toolchain is available locally.
- **Status:** complete

### Phase 2: Planning and Structure

- [x] Choose macOS SwiftUI app architecture.
- [x] Decide low-memory persistence and scheduling approach.
- [x] Define project layout for models, services, views, resources, and Xcode project.
- **Status:** complete

### Phase 3: Implementation

- [x] Scaffold macOS SwiftUI app and Xcode project.
- [x] Implement reminders, recurrence, JSON persistence, notification scheduling, menu bar UI, settings UI, and pinned panel.
- [x] Add README and project notes.
- **Status:** complete

### Phase 4: Verification

- [x] Verify file presence and Xcode project source references.
- [x] Validate `Info.plist` as XML.
- [x] Confirm local environment cannot compile Swift because `swift` is unavailable on Windows.
- **Status:** complete

### Phase 5: Delivery and macOS Compile Handoff

- [x] Install requested `planning-with-files` skill.
- [x] Install requested `superpowers` skill collection.
- [x] Create planning-with-files required `task_plan.md`, `findings.md`, and `progress.md`.
- [ ] Compile and run on macOS with Xcode.
- **Status:** in_progress

## Key Questions

1. How should "semester" recurrence behave? Answer: every 6 months.
2. How should the app stay low-memory? Answer: one observable JSON-backed store, local notifications scheduled only for the next occurrence, no database/sync/web runtime.
3. Can the project be compiled in the current workspace? Answer: no, the workspace is Windows and has no Swift/Xcode toolchain.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Use macOS 14 SwiftUI | Supports `MenuBarExtra`, modern settings scene, and clean Apple-style UI. |
| Store reminders as JSON in Application Support | Lightweight, local, easy to inspect, no database overhead. |
| Schedule only next notification occurrence | Keeps notification scheduling simple and avoids background polling. |
| Implement pinned panel with `NSPanel` | Native lightweight floating UI for always-on-screen reminders. |
| Include both `.xcodeproj` and `Package.swift` | Xcode project is best for macOS app bundling; SwiftPM remains useful as a lightweight source entry. |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Requested skills were not available in active session | 1 | Installed `planning-with-files` and `superpowers`; restart Codex to auto-load them. |
| Official skill listing script returned HTTP 403 | 1 | Installed directly from public GitHub repos instead of relying on listing API. |
| `swift` command unavailable on Windows | 1 | Documented macOS/Xcode compile handoff in README and progress log. |

## Notes

- Restart Codex to pick up newly installed skills automatically.
- The generated Swift app still needs a first compile pass on macOS.
- `PROJECT_PLAN.md` exists from the first implementation pass, while `task_plan.md`, `findings.md`, and `progress.md` are the active planning-with-files files.
