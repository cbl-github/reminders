import Foundation
import Combine
import UserNotifications

final class NotificationScheduler: ObservableObject {
    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private static let identifierPrefix = "gurr.reminder."
    private let center = UNUserNotificationCenter.current()

    init() {
        refreshAuthorizationStatus()
    }

    var authorizationTitle: String {
        switch authorizationStatus {
        case .authorized:
            return "已允许"
        case .denied:
            return "已拒绝"
        case .notDetermined:
            return "未设置"
        case .provisional:
            return "临时允许"
        case .ephemeral:
            return "临时"
        @unknown default:
            return "未知"
        }
    }

    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.refreshAuthorizationStatus()
            }
        }
    }

    func refreshAuthorizationStatus() {
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationStatus = settings.authorizationStatus
            }
        }
    }

    func refreshSchedule(for reminders: [Reminder]) {
        center.getPendingNotificationRequests { [weak self] requests in
            guard let self else { return }

            let oldIdentifiers = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.identifierPrefix) }

            self.center.removePendingNotificationRequests(withIdentifiers: oldIdentifiers)

            let scheduledReminders = reminders
                .compactMap { reminder -> (Reminder, Date)? in
                    guard let date = reminder.nextNotificationDate() else { return nil }
                    return (reminder, date)
                }
                .sorted { $0.1 < $1.1 }
                .prefix(64)

            for (reminder, date) in scheduledReminders {
                self.schedule(reminder, at: date)
            }
        }
    }

    private func schedule(_ reminder: Reminder, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title.isEmpty ? "Gurr Reminder" : reminder.title
        content.body = reminder.notes.isEmpty ? reminder.recurrence.title : reminder.notes
        content.sound = .default
        content.userInfo = ["reminderID": reminder.id.uuidString]

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: Self.identifierPrefix + reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }
}
