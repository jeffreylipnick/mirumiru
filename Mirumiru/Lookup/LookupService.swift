import Foundation

@MainActor
final class LookupService {

    private let selectionProvider: SelectionProvider
    private let lookupProvider: LookupProvider

    init(
        selectionProvider: SelectionProvider,
        lookupProvider: LookupProvider
    ) {
        self.selectionProvider = selectionProvider
        self.lookupProvider = lookupProvider
    }

    func lookupSelection() async -> LookupResult? {

        guard let text = selectionProvider.selectedText()
        else {
            return nil
        }

        return await lookupProvider.lookup(text)
    }
}
