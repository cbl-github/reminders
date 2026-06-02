import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: ReminderStore
    @EnvironmentObject private var scheduler: NotificationScheduler

    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("pinPanelEnabled") private var pinPanelEnabled = false
    @AppStorage("hideDockIcon") private var hideDockIcon = false

    var body: some View {
        Form {
            Section("显示") {
                Toggle("菜单栏入口", isOn: $showMenuBarExtra)
                Toggle("屏幕 Pin 面板", isOn: $pinPanelEnabled)
                Toggle("隐藏 Dock 图标", isOn: $hideDockIcon)
            }

            Section("通知") {
                LabeledContent("状态", value: scheduler.authorizationTitle)

                HStack {
                    Button("允许通知") {
                        scheduler.requestAuthorization()
                    }

                    Button("重新调度") {
                        scheduler.refreshSchedule(for: store.reminders)
                    }
                }
            }

            Section("数据") {
                Text(store.storagePath)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 440)
    }
}
