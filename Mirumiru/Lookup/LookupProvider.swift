import Foundation

protocol LookupProvider {
    func lookup(_ text: String) async -> LookupResult?
}
