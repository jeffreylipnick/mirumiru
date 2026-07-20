import AppKit
import SwiftUI

@MainActor
final class WindowManager {

    private let lookupService: LookupService
    private var window: NSWindow?
    private let viewModel = LookupViewModel()

    init() {
        self.lookupService = LookupService(
            selectionProvider: AccessibilitySelectionProvider(),
            lookupProvider: JMdictLookupProvider(
                database: DictionaryDatabase()
            )
        )
    }

    func show() {
        let needsPositioning = (window == nil)

        if window == nil {
            createWindow()
        }

        updateSize()

        if needsPositioning {
            positionWindow()
        }

        window?.makeKeyAndOrderFront(nil)
        window?.orderFrontRegardless()
    }

    func lookupSelectedText() {
        Task {
            let result = await lookupService.lookupSelection()

            if let result {
                viewModel.update(
                    result: result
                )
            } else {
                let selected = AccessibilitySelectionProvider()
                    .selectedText() ?? ""

                viewModel.update(
                    result: nil,
                    message: "No result found for \(selected)"
                )
            }

            show()
        }
    }

    private func createWindow() {
        let contentView = LookupView(
            viewModel: viewModel
        )

        let hostingView = NSHostingView(
            rootView: contentView
        )

        let newWindow = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: 340,
                height: 180
            ),
            styleMask: [
                .titled,
                .closable
            ],
            backing: .buffered,
            defer: false
        )

        newWindow.title = "ミルミル"

        newWindow.contentView = hostingView

        // Keep above other applications
        newWindow.level = .floating

        // Prevent user resizing
        newWindow.styleMask.remove(.resizable)

        // Keep window alive after closing
        newWindow.isReleasedWhenClosed = false

        window = newWindow
    }

    private func updateSize() {
        let size: NSSize

        switch viewModel.mode {
        case .compact:
            size = NSSize(
                width: 340,
                height: 180
            )

        case .expanded:
            size = NSSize(
                width: 420,
                height: 600
            )
        }

        window?.setContentSize(size)
    }

    private func positionWindow() {
        guard let window,
              let screen = NSScreen.main
        else {
            return
        }

        let frame = screen.visibleFrame
        let size = window.frame.size

        window.setFrameOrigin(
            NSPoint(
                x: frame.maxX - size.width - 20,
                y: frame.maxY - size.height - 20
            )
        )
    }
}
