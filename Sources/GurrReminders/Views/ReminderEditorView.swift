import SwiftUI

struct ReminderEditorView: View {
    @Binding var reminder: Reminder
    let onDelete: () -> Void

    @EnvironmentObject private var store: ReminderStore

    var body: some View {
        Form {
            Section {
                TextField("标题", text: $reminder.title)
                    .font(.title2.weight(.semibold))

                TextEditor(text: $reminder.notes)
                    .frame(minHeight: 110)
                    .scrollContentBackground(.hidden)
            }

            Section("时间") {
                DatePicker("首次提醒", selection: $reminder.startDate)

                Picker("重复", selection: $reminder.recurrence) {
                    ForEach(ReminderRecurrence.allCases) { recurrence in
                        Label(recurrence.title, systemImage: recurrence.systemImage)
                            .tag(recurrence)
                    }
                }
            }

            Section("显示") {
                Toggle(isOn: $reminder.isPinned) {
                    Label("Pin 到屏幕", systemImage: "pin")
                }

                Toggle(isOn: $reminder.showInMenuBar) {
                    Label("在菜单栏显示", systemImage: "menubar.rectangle")
                }
            }

            Section("状态") {
                Toggle("已完成", isOn: $reminder.isCompleted)

                if let date = reminder.displayDate() {
                    LabeledContent("下一次") {
                        HStack(spacing: 6) {
                            Text(date, style: .date)
                            Text(date, style: .time)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .padding(18)
        .toolbar {
            ToolbarItemGroup {
                Button {
                    store.complete(reminder.id)
                } label: {
                    Label("完成本次", systemImage: "checkmark.circle")
                }

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("删除", systemImage: "trash")
                }
            }
        }
    }
}
