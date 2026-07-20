import SwiftUI

struct CompactView: View {
    let result: LookupResult

    var body: some View {
        VStack(alignment: .leading) {
            Text(result.word)
                .font(.largeTitle)

            Text(result.reading)
                .font(.title3)

            Text(result.pitchAccent)

            Divider()

            ForEach(result.definitions, id: \.self) { definition in
                Text(definition)
            }
        }
    }
}
