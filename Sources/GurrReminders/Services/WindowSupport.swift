import AppKit
import SwiftUI

enum WindowManager {
    static let mainWindowIdentifier = NSUserInterfaceItemIdentifier("gurr.main-window")

    @MainActor
    static func showMainWindow() {
        NSApp.activate(ignoringOtherApps: true)

        let targetWindow = NSApp.windows.first { window in
            window.identifier == mainWindowIdentifier || window.title == "Gurr"
        }

        targetWindow?.makeKeyAndOrderFront(nil)
    }
}

struct WindowAccessor: NSViewRepresentable {
    var configure: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)

        DispatchQueue.main.async {
            if let window = view.window {
                configure(window)
            }
        }

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            if let window = nsView.window {
                configure(window)
            }
        }
    }
}

enum DockIconController {
    @MainActor
    static func setDockIconVisible(_ isVisible: Bool) {
        NSApp.setActivationPolicy(isVisible ? .regular : .accessory)
    }
}
