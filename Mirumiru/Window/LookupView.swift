import SwiftUI

struct LookupView: View {
    @ObservedObject var viewModel: LookupViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Spacer()

                Button {
                    viewModel.toggleMode()
                } label: {
                    Text(
                        viewModel.mode == .compact
                        ? "Expand"
                        : "Compact"
                    )
                }
            }

            if viewModel.mode == .compact {
                CompactView(
                    result: viewModel.result
                )
            } else {
                ExpandedView(
                    result: viewModel.result
                )
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}
