import Foundation
import SQLite3

private let SQLITE_TRANSIENT = unsafeBitCast(
    -1,
    to: sqlite3_destructor_type.self
)

final class DictionaryDatabase {

    private var db: OpaquePointer?

    init() {
        openDatabase()
    }

    deinit {
        sqlite3_close(db)
    }

    private func openDatabase() {

        guard let path = Bundle.main.path(
            forResource: "jmdict",
            ofType: "sqlite"
        )
        else {
            print("JMdict database missing")
            return
        }

        if sqlite3_open(
            path,
            &db
        ) != SQLITE_OK {
            print("Could not open database")
        }
    }


    func search(
        text: String
    ) -> DictionaryEntry? {

        guard let db else {
            return nil
        }
        
        print("DB search:", text)

        let sql = """
        SELECT kanji, reading, meanings, parts_of_speech
        FROM entries
        WHERE kanji = ?
           OR reading = ?
        LIMIT 1
        """

        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(
            db,
            sql,
            -1,
            &statement,
            nil
        ) == SQLITE_OK
        else {
            return nil
        }


        text.withCString { cString in

            sqlite3_bind_text(
                statement,
                1,
                cString,
                -1,
                SQLITE_TRANSIENT
            )

            sqlite3_bind_text(
                statement,
                2,
                cString,
                -1,
                SQLITE_TRANSIENT
            )
        }


        defer {
            sqlite3_finalize(statement)
        }


        let stepResult = sqlite3_step(statement)

        print("SQLite step result:", stepResult)

        guard stepResult == SQLITE_ROW else {
            return nil
        }


        let kanji =
            sqlite3_column_text(statement, 0)
            .map {
                String(cString: $0)
            }

        let reading =
            String(
                cString:
                    sqlite3_column_text(
                        statement,
                        1
                    )
            )

        let meanings =
            String(
                cString:
                    sqlite3_column_text(
                        statement,
                        2
                    )
            )
            .components(separatedBy: "\n")

        let parts =
            String(
                cString:
                    sqlite3_column_text(
                        statement,
                        3
                    )
            )
            .components(separatedBy: "\n")
        
        print(
            "SQLite found:",
            String(cString: sqlite3_column_text(statement, 0)),
            String(cString: sqlite3_column_text(statement, 1))
        )

        return DictionaryEntry(
            kanji: kanji,
            reading: reading,
            meanings: meanings,
            partsOfSpeech: parts
        )
    }
}
