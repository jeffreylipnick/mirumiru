import Foundation

@MainActor
final class LookupViewModel: ObservableObject {

    enum DisplayMode {
        case compact
        case expanded
    }

    @Published var result: LookupResult = .sample
    @Published var mode: DisplayMode = .compact

    func update(result: LookupResult) {
        self.result = result
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
