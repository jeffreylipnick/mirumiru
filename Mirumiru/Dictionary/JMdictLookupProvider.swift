import Foundation

final class JMdictLookupProvider: LookupProvider {

    private let database: DictionaryDatabase

    init(database: DictionaryDatabase) {
        self.database = database
    }


    func lookup(
        _ text: String
    ) async -> LookupResult? {
        
        print("JMdict lookup called:", text)

        guard let entry =
                database.search(text: text)
        else {
            print("No dictionary result for:", text)
            return nil
        }

        print("Found:", entry.kanji ?? "", entry.reading)


        return LookupResult(
            word: entry.kanji ?? entry.reading,
            reading: entry.reading,
            pitchAccent: "",
            definitions: entry.meanings,
            partOfSpeech:
                entry.partsOfSpeech.joined(
                    separator: ", "
                ),
            jlpt: "",
            frequency: "",
            examples: []
        )
    }
}
