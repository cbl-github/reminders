import Foundation
import Combine

final class ReminderStore: ObservableObject {
    @Published var reminders: [Reminder] = [] {
        didSet {
            save()
        }
    }

    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileManager: FileManager = .default) {
        let supportRoot = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let folderURL = supportRoot.appendingPathComponent("GurrReminders", isDirectory: true)

        try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

        self.fileURL = folderURL.appendingPathComponent("reminders.json")
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601

        load()
    }

    var storagePath: String {
        fileURL.path
    }

    @discardableResult
    func addReminder(
        title: String = "新提醒",
        startDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(),
        recurrence: ReminderRecurrence = .daily
    ) -> UUID {
        let reminder = Reminder(
            title: title,
            startDate: startDate,
            recurrence: recurrence
        )

        reminders.insert(reminder, at: 0)
        return reminder.id
    }

    func reminder(withID id: UUID) -> Reminder? {
        reminders.first { $0.id == id }
    }

    func filteredReminders(for filter: ReminderFilter, now: Date = Date()) -> [Reminder] {
        let filtered = reminders.filter { reminder in
            switch filter {
            case .upcoming:
                return !reminder.isCompleted
            case .today:
                return reminder.isDueToday(now: now)
            case .pinned:
                return reminder.isPinned && !reminder.isCompleted
            case .menuBar:
                return reminder.showInMenuBar && !reminder.isCompleted
            case .completed:
                return reminder.isCompleted
            case .all:
                return true
            }
        }

        return filtered.sorted { lhs, rhs in
            let leftDate = lhs.displayDate(now: now) ?? .distantFuture
            let rightDate = rhs.displayDate(now: now) ?? .distantFuture

            if leftDate == rightDate {
                return lhs.createdAt < rhs.createdAt
            }

            return leftDate < rightDate
        }
    }

    func update(_ reminder: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }

        var updatedReminder = reminder
        updatedReminder.updatedAt = Date()
        reminders[index] = updatedReminder
    }

    func delete(_ id: UUID) {
        reminders.removeAll { $0.id == id }
    }

    func delete(_ ids: [UUID]) {
        reminders.removeAll { ids.contains($0.id) }
    }

    func complete(_ id: UUID) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else { return }
        reminders[index].markDone()
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            reminders = try decoder.decode([Reminder].self, from: data)
        } catch {
            reminders = []
        }
    }

    private func save() {
        do {
            let data = try encoder.encode(reminders)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            assertionFailure("Failed to save reminders: \(error.localizedDescription)")
        }
    }
}
