# Gurr Reminders

Gurr Reminders is a lightweight macOS SwiftUI reminder app with daily, weekly, monthly, semester, and yearly recurrence. It includes a main Apple-style window, a menu bar extra, local notifications, and an optional pinned floating panel.

## Requirements

- macOS 14 or later
- Xcode 15 or later

## Run

1. Open `GurrReminders.xcodeproj` in Xcode on macOS.
2. Select the `GurrReminders` scheme.
3. Run on `My Mac`.
4. In app settings, allow notifications and choose whether to show the menu bar entry or pinned panel.

`Package.swift` is also included as a lightweight source entry, but the Xcode project is the preferred way to build the macOS app bundle.

## Design Notes

- Data is stored as JSON in Application Support.
- The app schedules only the next notification occurrence for each reminder.
- Semester recurrence is defined as every 6 months.
- The pinned panel uses `NSPanel` with floating level and SwiftUI content.
- There is no database, sync engine, web view, or polling worker.

## Current Limitation

This repository was generated in a Windows workspace where Swift and Xcode are unavailable, so the app still needs a first compile pass on macOS.
