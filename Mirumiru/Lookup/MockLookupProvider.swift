import Foundation

final class MockLookupProvider: LookupProvider {

    func lookup(_ text: String) async -> LookupResult? {

        guard text == "募集" else {
            return nil
        }

        return .sample
    }
}
