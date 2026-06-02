import Foundation

enum ReminderFilter: String, CaseIterable, Identifiable, Hashable {
    case upcoming
    case today
    case pinned
    case menuBar
    case completed
    case all

    var id: String { rawValue }

    var title: String {
        switch self {
        case .upcoming:
            return "近期"
        case .today:
            return "今天"
        case .pinned:
            return "屏幕 Pin"
        case .menuBar:
            return "菜单栏"
        case .completed:
            return "已完成"
        case .all:
            return "全部"
        }
    }

    var systemImage: String {
        switch self {
        case .upcoming:
            return "calendar.badge.clock"
        case .today:
            return "sun.max"
        case .pinned:
            return "pin"
        case .menuBar:
            return "menubar.rectangle"
        case .completed:
            return "checkmark.circle"
        case .all:
            return "tray.full"
        }
    }
}
