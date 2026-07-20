import AppKit

final class AccessibilitySelectionProvider: SelectionProvider {

    func selectedText() -> String? {
        if let text = accessibilitySelection() {
            return text
        }

        print("Accessibility selection failed, trying clipboard")

        return clipboardSelection()
    }

    private func accessibilitySelection() -> String? {

        let systemWideElement = AXUIElementCreateSystemWide()

        var focusedElement: CFTypeRef?

        let result = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXFocusedUIElementAttribute as CFString,
            &focusedElement
        )

        guard result == .success,
              let focusedElement
        else {
            print("No focused accessibility element")
            return nil
        }

        var selectedText: CFTypeRef?

        let selectedResult = AXUIElementCopyAttributeValue(
            focusedElement as! AXUIElement,
            kAXSelectedTextAttribute as CFString,
            &selectedText
        )

        guard selectedResult == .success else {
            print("No accessibility selected text")
            return nil
        }

        return selectedText as? String
    }


    private func clipboardSelection() -> String? {
        // Temporarily disabled.
        // We will re-add this after accessibility selection is stable.
        return nil
    }
}
