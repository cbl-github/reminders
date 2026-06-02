# Findings & Decisions

## Requirements

- Build a Swift-language reminder app.
- Use an Apple-style UI suitable for macOS.
- Keep memory usage low.
- Support reminder timing: day, week, month, semester, year.
- Allow reminders to be pinned to the screen.
- Allow reminders to appear in the menu bar.
- Single click from the menu bar should open the app/reminder.
- Use `planning-with-files` and `superpowers`; install them if absent.

## Research Findings

- The workspace initially contained learning documents, not a code project.
- Windows environment does not provide `swift` or Xcode, so compilation must happen on macOS.
- `planning-with-files` was found and installed from `OthmanAdi/planning-with-files`.
- `superpowers` was found and installed from `obra/superpowers`.
- The official skill listing helper returned HTTP 403 for both curated and experimental lists, so direct GitHub installation was used.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| SwiftUI main app with AppKit helpers | SwiftUI provides native Apple-style UI; AppKit is needed for floating `NSPanel`. |
| `ReminderStore` backed by JSON | Small app data model, lower memory and dependency footprint than database/sync stack. |
| `NotificationScheduler` using `UserNotifications` | Native local reminder delivery without custom background worker. |
| `MenuBarExtra` for menu bar presence | Native SwiftUI macOS menu bar integration. |
| `NSPanel` for pinned reminders | Lightweight, native floating panel with all-spaces behavior. |
| Semester equals every 6 months | Best concrete interpretation without requiring school calendar configuration. |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Missing requested skills | Installed both skills into user-level skill directories. |
| GitHub skill list API blocked with HTTP 403 | Used direct repo install/clone commands. |
| No local Swift compiler | Added README limitation and verified what can be checked on Windows. |

## Resources

- Planning skill: `C:\Users\Administrator\.codex\skills\planning-with-files\SKILL.md`
- Superpowers skills: `C:\Users\Administrator\.agents\skills\superpowers`
- Swift app project: `C:\Users\Administrator\Desktop\Gurr\GurrReminders.xcodeproj`
- Project README: `C:\Users\Administrator\Desktop\Gurr\README.md`
- Apple MenuBarExtra docs: https://developer.apple.com/documentation/swiftui/menubarextra
- Apple UserNotifications docs: https://developer.apple.com/documentation/usernotifications
- Apple NSPanel docs: https://developer.apple.com/documentation/appkit/nspanel

## Visual/Browser Findings

- Search results indicated `planning-with-files` is available as a Codex-style skill repository.
- Search results indicated `superpowers` has a Codex installation path and a public GitHub repository.

---

*Update this file after every 2 view/browser/search operations.*
