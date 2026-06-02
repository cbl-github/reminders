import Foundation

struct Reminder: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var notes: String
    var startDate: Date
    var recurrence: ReminderRecurrence
    var isCompleted: Bool
    var isPinned: Bool
    var showInMenuBar: Bool
    var createdAt: Date
    var updatedAt: Date
    var lastCompletedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        startDate: Date,
        recurrence: ReminderRecurrence = .daily,
        isCompleted: Bool = false,
        isPinned: Bool = false,
        showInMenuBar: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastCompletedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.recurrence = recurrence
        self.isCompleted = isCompleted
        self.isPinned = isPinned
        self.showInMenuBar = showInMenuBar
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastCompletedAt = lastCompletedAt
    }

    func displayDate(now: Date = Date(), calendar: Calendar = .current) -> Date? {
        guard !isCompleted else { return nil }

        if recurrence == .once {
            return startDate
        }

        let reference = max(now, lastCompletedAt ?? .distantPast)
        return recurrence.nextDate(startingAt: startDate, after: reference, calendar: calendar)
    }

    func nextNotificationDate(now: Date = Date(), calendar: Calendar = .current) -> Date? {
        guard !isCompleted else { return nil }

        if recurrence == .once {
            return startDate > now ? startDate : nil
        }

        let reference = max(now, lastCompletedAt ?? .distantPast)
        return recurrence.nextDate(startingAt: startDate, after: reference, calendar: calendar)
    }

    func isDueToday(now: Date = Date(), calendar: Calendar = .current) -> Bool {
        guard let date = displayDate(now: now, calendar: calendar) else { return false }
        return calendar.isDateInToday(date)
    }

    func isOverdue(now: Date = Date()) -> Bool {
        recurrence == .once && !isCompleted && startDate < now
    }

    mutating func markDone(now: Date = Date()) {
        if recurrence == .once {
            isCompleted = true
        } else {
            lastCompletedAt = now
        }

        updatedAt = now
    }
}
