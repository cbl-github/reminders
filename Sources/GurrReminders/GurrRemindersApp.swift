import SwiftUI

@main
struct GurrRemindersApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var store = ReminderStore()
    @StateObject private var scheduler = NotificationScheduler()
    @StateObject private var pinnedPanelController = PinnedPanelController()

    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("pinPanelEnabled") private var pinPanelEnabled = false
    @AppStorage("hideDockIcon") private var hideDockIcon = false

    var body: some Scene {
        WindowGroup("Gurr", id: "main") {
            ContentView()
                .environmentObject(store)
                .environmentObject(scheduler)
                .background(
                    WindowAccessor { window in
                        window.identifier = WindowManager.mainWindowIdentifier
                        window.titlebarAppearsTransparent = true
                    }
                )
                .onAppear {
                    DockIconController.setDockIconVisible(!hideDockIcon)
                    pinnedPanelController.setVisible(pinPanelEnabled, store: store)
                    scheduler.refreshSchedule(for: store.reminders)
                }
                .onChange(of: pinPanelEnabled) { _, newValue in
                    pinnedPanelController.setVisible(newValue, store: store)
                }
                .onChange(of: hideDockIcon) { _, newValue in
                    DockIconController.setDockIconVisible(!newValue)
                }
                .onReceive(store.$reminders) { reminders in
                    scheduler.refreshSchedule(for: reminders)
                }
                .onReceive(NotificationCenter.default.publisher(for: .showMainWindowRequested)) { _ in
                    WindowManager.showMainWindow()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandMenu("Gurr") {
                Button("New Reminder") {
                    NotificationCenter.default.post(name: .createReminderRequested, object: nil)
                }
                .keyboardShortcut("n", modifiers: [.command])

                Button("Show Main Window") {
                    NotificationCenter.default.post(name: .showMainWindowRequested, object: nil)
                }
                .keyboardShortcut("0", modifiers: [.command])
            }
        }

        MenuBarExtra("Gurr", systemImage: "bell.badge", isInserted: $showMenuBarExtra) {
            MenuBarView()
                .environmentObject(store)
                .environmentObject(scheduler)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(store)
                .environmentObject(scheduler)
        }
    }
}
