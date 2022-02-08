import UIKit

struct JSONDataSourceProvider: NoteDataSource {
    var noteList = [Note]()

    mutating func fetch() throws {
        guard let data = NSDataAsset(name: "sampleNotes")?.data else {
            throw DataSourceError.jsonNotFound
        }

        guard let decodedData: [Note] = try? DecodingUtility.decode(data: data) else {
            throw DataSourceError.decodingFailure
        }

        self.noteList = decodedData
    }
}
