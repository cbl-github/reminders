import SwiftUI

struct ReminderListView: View {
    let filter: ReminderFilter
    @Binding var selectedReminderID: UUID?

    @EnvironmentObject private var store: ReminderStore

    private var reminders: [Reminder] {
        store.filteredReminders(for: filter)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(filter.title)
                    .font(.title2.weight(.semibold))

                Spacer()

                Text("\(reminders.count)")
                    .font(.callout.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)

            if reminders.isEmpty {
                EmptyReminderListView()
            } else {
                List(selection: $selectedReminderID) {
                    ForEach(reminders) { reminder in
                        ReminderRowView(reminder: reminder)
                            .tag(reminder.id)
                    }
                    .onDelete { offsets in
                        let ids = offsets.map { reminders[$0].id }
                        store.delete(ids)

                        if let selectedReminderID, ids.contains(selectedReminderID) {
                            self.selectedReminderID = nil
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    selectedReminderID = store.addReminder()
                } label: {
                    Label("新建提醒", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: [.command])
            }
        }
    }
}

private struct ReminderRowView: View {
    @EnvironmentObject private var store: ReminderStore
    let reminder: Reminder

    var body: some View {
        HStack(spacing: 12) {
            Button {
                store.complete(reminder.id)
            } label: {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(reminder.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.borderless)
            .help("完成本次")

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(reminder.title.isEmpty ? "未命名提醒" : reminder.title)
                        .font(.headline)
                        .lineLimit(1)

                    if reminder.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }

                    if reminder.showInMenuBar {
                        Image(systemName: "menubar.rectangle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 8) {
                    Label(reminder.recurrence.title, systemImage: reminder.recurrence.systemImage)

                    if let date = reminder.displayDate() {
                        Label {
                            HStack(spacing: 3) {
                                Text(date, style: .date)
                                Text(date, style: .time)
                            }
                        } icon: {
                            Image(systemName: "clock")
                        }
                    }
                }
                .font(.caption)
                .foregroundStyle(reminder.isOverdue() ? .red : .secondary)
                .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

private struct EmptyReminderListView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.secondary)

            Text("没有提醒")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
