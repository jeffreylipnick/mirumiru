import SwiftUI

@main
struct MirumiruApp: App {

    private let windowManager: WindowManager
    private let hotkeyManager: HotkeyManager

    init() {
        let manager = WindowManager()

        self.windowManager = manager
        self.hotkeyManager = HotkeyManager(
            windowManager: manager
        )
    }

    var body: some Scene {

        MenuBarExtra(
            "ミルミル",
            systemImage: "character.book.closed"
        ) {

            Button("Show") {
                windowManager.show()
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
