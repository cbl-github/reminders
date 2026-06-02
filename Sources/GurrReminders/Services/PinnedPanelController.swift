import AppKit
import SwiftUI

final class PinnedPanelController: ObservableObject {
    private var panel: NSPanel?

    @MainActor
    func setVisible(_ isVisible: Bool, store: ReminderStore) {
        if isVisible {
            show(store: store)
        } else {
            hide()
        }
    }

    @MainActor
    private func show(store: ReminderStore) {
        if panel == nil {
            let panel = NSPanel(
                contentRect: NSRect(x: 80, y: 520, width: 340, height: 360),
                styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )

            panel.title = "Gurr"
            panel.isReleasedWhenClosed = false
            panel.level = .floating
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            panel.titlebarAppearsTransparent = true
            panel.standardWindowButton(.closeButton)?.isHidden = true
            panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
            panel.standardWindowButton(.zoomButton)?.isHidden = true
            panel.contentView = NSHostingView(
                rootView: PinnedRemindersView()
                    .environmentObject(store)
            )

            self.panel = panel
        }

        panel?.orderFrontRegardless()
    }

    @MainActor
    private func hide() {
        panel?.orderOut(nil)
    }
}
