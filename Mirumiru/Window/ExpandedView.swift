import SwiftUI

struct ExpandedView: View {
    let result: LookupResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                Text(result.word)
                    .font(.largeTitle)

                Text(result.reading)
                    .font(.title2)

                Text(result.pitchAccent)

                Text(result.partOfSpeech)

                Divider()

                ForEach(result.definitions, id: \.self) {
                    Text($0)
                }

                Divider()

                Text(result.jlpt)
                Text(result.frequency)

                Divider()

                Text("Examples")
                    .font(.headline)

                ForEach(result.examples,
                        id: \.japanese) { example in
                    Text(example.japanese)
                        .bold()

                    Text(example.english)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
