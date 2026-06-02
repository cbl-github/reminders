import SwiftUI

struct PinnedRemindersView: View {
    @EnvironmentObject private var store: ReminderStore

    private var reminders: [Reminder] {
        Array(store.filteredReminders(for: .pinned).prefix(8))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Pinned", systemImage: "pin.fill")
                    .font(.headline)

                Spacer()

                Button {
                    WindowManager.showMainWindow()
                } label: {
                    Image(systemName: "arrow.up.right.square")
                }
                .buttonStyle(.borderless)
                .help("打开 Gurr")
            }

            if reminders.isEmpty {
                Text("没有 Pin 的提醒")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 120)
            } else {
                VStack(spacing: 8) {
                    ForEach(reminders) { reminder in
                        PinnedReminderRow(reminder: reminder)
                    }
                }
            }
        }
        .padding(14)
        .frame(width: 320)
        .background(.regularMaterial)
    }
}

private struct PinnedReminderRow: View {
    @EnvironmentObject private var store: ReminderStore
    let reminder: Reminder

    var body: some View {
        HStack(spacing: 10) {
            Button {
                store.complete(reminder.id)
            } label: {
                Image(systemName: "circle")
            }
            .buttonStyle(.plain)
            .help("完成本次")

            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title.isEmpty ? "未命名提醒" : reminder.title)
                    .font(.callout.weight(.medium))
                    .lineLimit(2)

                if let date = reminder.displayDate() {
                    HStack(spacing: 5) {
                        Image(systemName: reminder.recurrence.systemImage)
                        Text(date, style: .date)
                        Text(date, style: .time)
                    }
                    .font(.caption)
                    .foregroundStyle(reminder.isOverdue() ? .red : .secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
