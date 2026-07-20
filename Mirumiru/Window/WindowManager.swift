import AppKit
import SwiftUI

@MainActor
final class WindowManager {
    private var window: NSWindow?
    private let viewModel = LookupViewModel()

    func show() {
        if window == nil {
            createWindow()
        }

        updateSize()
        positionWindow()

        window?.makeKeyAndOrderFront(nil)
    }

    private func createWindow() {
        let contentView = LookupView(
            viewModel: viewModel
        )

        let hostingView = NSHostingView(
            rootView: contentView
        )

        let newWindow = NSWindow(
            contentRect: .zero,
            styleMask: [
                .titled,
                .closable
            ],
            backing: .buffered,
            defer: false
        )

        newWindow.title = "ミルミル"
        newWindow.contentView = hostingView
        newWindow.level = .floating
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
