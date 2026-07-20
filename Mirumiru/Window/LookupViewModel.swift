import Foundation

@MainActor
final class LookupViewModel: ObservableObject {

    enum DisplayMode {
        case compact
        case expanded
    }

    @Published var result: LookupResult?
    @Published var message: String = ""
    @Published var mode: DisplayMode = .compact
    @Published var lookupID = UUID()

    func update(
        result: LookupResult?,
        message: String = ""
    ) {
        self.result = result
        self.message = message
        self.lookupID = UUID()
    }

    func toggleMode() {
        switch mode {
        case .compact:
            mode = .expanded
        case .expanded:
            mode = .compact
        }
    }
}
