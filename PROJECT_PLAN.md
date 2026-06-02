# Gurr Reminders Project Plan

## Goal

Build a lightweight macOS reminder app in Swift with an Apple-style UI, local persistence, local notifications, a menu bar entry, and an optional pinned floating panel.

## Core Scope

- SwiftUI macOS app targeting macOS 14 or later.
- Reminder recurrence options:
  - Once
  - Daily
  - Weekly
  - Monthly
  - Semester, implemented as every 6 months
  - Yearly
- Menu bar extra:
  - Shows reminders marked for the menu bar
  - Opens the main window with one click
  - Supports quick add and quick complete
- Pinned screen panel:
  - Uses a lightweight floating `NSPanel`
  - Shows reminders marked as pinned
  - Avoids timers or heavyweight background services
- Low-memory approach:
  - JSON storage in Application Support
  - One observable store
  - Local notifications scheduled only for the next occurrence
  - No database, sync engine, web runtime, or background polling loop

## File Layout

- `Package.swift`: Swift Package entry for opening in Xcode.
- `Sources/GurrReminders/Models`: reminder and recurrence data types.
- `Sources/GurrReminders/Services`: persistence, notifications, AppKit window helpers.
- `Sources/GurrReminders/Views`: SwiftUI views for main window, menu bar, editor, settings, and pinned panel.

## Verification

The current workspace is on Windows and does not have Swift or Xcode installed, so compile-time verification must be done on macOS with Xcode. Local checks here are limited to file review and project consistency.
