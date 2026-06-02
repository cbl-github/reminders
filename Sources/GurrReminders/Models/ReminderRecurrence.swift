import Foundation

enum ReminderRecurrence: String, CaseIterable, Codable, Identifiable, Hashable {
    case once
    case daily
    case weekly
    case monthly
    case semester
    case yearly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .once:
            return "一次"
        case .daily:
            return "每天"
        case .weekly:
            return "每周"
        case .monthly:
            return "每月"
        case .semester:
            return "每学期"
        case .yearly:
            return "每年"
        }
    }

    var systemImage: String {
        switch self {
        case .once:
            return "calendar"
        case .daily:
            return "sun.max"
        case .weekly:
            return "calendar.badge.clock"
        case .monthly:
            return "calendar"
        case .semester:
            return "graduationcap"
        case .yearly:
            return "sparkles"
        }
    }

    private var dateComponent: Calendar.Component? {
        switch self {
        case .once:
            return nil
        case .daily:
            return .day
        case .weekly:
            return .weekOfYear
        case .monthly, .semester:
            return .month
        case .yearly:
            return .year
        }
    }

    private var step: Int {
        switch self {
        case .once, .daily, .weekly, .monthly, .yearly:
            return 1
        case .semester:
            return 6
        }
    }

    func nextDate(startingAt startDate: Date, after reference: Date, calendar: Calendar = .current) -> Date? {
        guard let dateComponent else {
            return startDate > reference ? startDate : nil
        }

        var candidate = startDate
        var iterationCount = 0

        while candidate <= reference && iterationCount < 100_000 {
            guard let next = calendar.date(byAdding: dateComponent, value: step, to: candidate) else {
                return nil
            }

            candidate = next
            iterationCount += 1
        }

        return candidate > reference ? candidate : nil
    }
}
