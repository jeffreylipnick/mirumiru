import SwiftUI

struct LookupView: View {
    @ObservedObject var viewModel: LookupViewModel

    var body: some View {
        VStack {
            if let result = viewModel.result {
                switch viewModel.mode {
                case .compact:
                    CompactView(result: result)

                case .expanded:
                    ExpandedView(result: result)
                }
            } else {
                Text(viewModel.message)
                    .padding(12)
            }
        }
        .id(viewModel.lookupID)
    }
}
