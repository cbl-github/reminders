import SwiftUI

struct MenuBarView: View {
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject private var store: ReminderStore
    @EnvironmentObject private var scheduler: NotificationScheduler

    private var reminders: [Reminder] {
        Array(store.filteredReminders(for: .menuBar).prefix(6))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Gurr", systemImage: "bell.badge")
                    .font(.headline)

                Spacer()

                Button {
                    scheduler.requestAuthorization()
                } label: {
                    Image(systemName: "bell.and.waves.left.and.right")
                }
                .buttonStyle(.borderless)
                .help("通知权限")
            }

            if reminders.isEmpty {
                Text("没有菜单栏提醒")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 72)
            } else {
                VStack(spacing: 6) {
                    ForEach(reminders) { reminder in
                        MenuBarReminderRow(reminder: reminder) {
                            openReminder(reminder.id)
                        }
                    }
                }
            }

            Divider()

            HStack {
                Button {
                    selectedNewReminder()
                } label: {
                    Label("新建", systemImage: "plus")
                }

                Spacer()

                Button {
                    openMainWindow()
                } label: {
                    Label("打开", systemImage: "macwindow")
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(14)
        .frame(width: 320)
    }

    private func selectedNewReminder() {
        let id = store.addReminder()
        openReminder(id)
    }

    private func openMainWindow() {
        openWindow(id: "main")
        DispatchQueue.main.async {
            WindowManager.showMainWindow()
        }
    }

    private func openReminder(_ id: UUID) {
        openWindow(id: "main")
        DispatchQueue.main.async {
            WindowManager.showMainWindow()
            NotificationCenter.default.post(name: .openReminderFromNotification, object: id.uuidString)
        }
    }
}

private struct MenuBarReminderRow: View {
    @EnvironmentObject private var store: ReminderStore
    let reminder: Reminder
    let onOpen: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button {
                store.complete(reminder.id)
            } label: {
                Image(systemName: "checkmark.circle")
            }
            .buttonStyle(.borderless)
            .help("完成本次")

            Button(action: onOpen) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(reminder.title.isEmpty ? "未命名提醒" : reminder.title)
                        .font(.callout.weight(.medium))
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        Image(systemName: reminder.recurrence.systemImage)
                        Text(reminder.recurrence.title)

                        if let date = reminder.displayDate() {
                            Text(date, style: .date)
                            Text(date, style: .time)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(reminder.isOverdue() ? .red : .secondary)
                    .lineLimit(1)
                }
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)
        }
        .padding(8)
        .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
