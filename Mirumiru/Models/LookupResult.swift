import Foundation

struct LookupResult {
    let word: String
    let reading: String
    let pitchAccent: String
    let definitions: [String]
    let partOfSpeech: String
    let jlpt: String
    let frequency: String
    let examples: [ExampleSentence]

    static let sample = LookupResult(
        word: "募集",
        reading: "ぼしゅう",
        pitchAccent: "[0]",
        definitions: [
            "Recruitment",
            "Solicitation"
        ],
        partOfSpeech: "noun / する verb",
        jlpt: "JLPT N3",
        frequency: "★★★★★ Common",
        examples: [
            ExampleSentence(
                japanese: "人材を募集する",
                english: "Recruit employees"
            ),
            ExampleSentence(
                japanese: "参加者を募集しています",
                english: "We are looking for participants"
            )
        ]
    )
}

struct ExampleSentence {
    let japanese: String
    let english: String
}
