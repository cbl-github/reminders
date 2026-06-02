import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: ReminderStore

    @State private var selectedFilter: ReminderFilter? = .upcoming
    @State private var selectedReminderID: UUID?

    var body: some View {
        NavigationSplitView {
            List(ReminderFilter.allCases, selection: $selectedFilter) { filter in
                Label(filter.title, systemImage: filter.systemImage)
                    .tag(filter)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 210)
        } content: {
            ReminderListView(
                filter: selectedFilter ?? .upcoming,
                selectedReminderID: $selectedReminderID
            )
            .navigationSplitViewColumnWidth(min: 320, ideal: 420)
        } detail: {
            if let selectedReminderID, let binding = binding(for: selectedReminderID) {
                ReminderEditorView(
                    reminder: binding,
                    onDelete: {
                        store.delete(selectedReminderID)
                        self.selectedReminderID = nil
                    }
                )
                .id(selectedReminderID)
            } else {
                EmptyDetailView()
            }
        }
        .frame(minWidth: 900, minHeight: 580)
        .onAppear {
            selectFirstReminderIfNeeded()
        }
        .onChange(of: selectedFilter) { _, _ in
            selectFirstReminderIfNeeded()
        }
        .onReceive(NotificationCenter.default.publisher(for: .createReminderRequested)) { _ in
            selectedReminderID = store.addReminder()
            selectedFilter = .upcoming
            WindowManager.showMainWindow()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openReminderFromNotification)) { notification in
            guard
                let reminderIDString = notification.object as? String,
                let reminderID = UUID(uuidString: reminderIDString),
                store.reminder(withID: reminderID) != nil
            else { return }

            selectedReminderID = reminderID
        }
        .onReceive(store.$reminders) { _ in
            selectFirstReminderIfNeeded()
        }
    }

    private func binding(for id: UUID) -> Binding<Reminder>? {
        guard let currentReminder = store.reminder(withID: id) else { return nil }

        return Binding(
            get: {
                store.reminder(withID: id) ?? currentReminder
            },
            set: { updatedReminder in
                store.update(updatedReminder)
            }
        )
    }

    private func selectFirstReminderIfNeeded() {
        let visibleReminders = store.filteredReminders(for: selectedFilter ?? .upcoming)

        if let selectedReminderID, visibleReminders.contains(where: { $0.id == selectedReminderID }) {
            return
        }

        selectedReminderID = visibleReminders.first?.id
    }
}
