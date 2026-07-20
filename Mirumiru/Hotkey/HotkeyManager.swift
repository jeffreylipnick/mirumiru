import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let lookupJapanese = Self(
        "lookupJapanese",
        default: .init(
            .j,
            modifiers: [.option, .command]
        )
    )
}

@MainActor
final class HotkeyManager {

    private let windowManager: WindowManager

    init(windowManager: WindowManager) {
        self.windowManager = windowManager

        KeyboardShortcuts.onKeyDown(
            for: .lookupJapanese
        ) { [weak self] in
            self?.windowManager.lookupSelectedText()
        }
    }
}
