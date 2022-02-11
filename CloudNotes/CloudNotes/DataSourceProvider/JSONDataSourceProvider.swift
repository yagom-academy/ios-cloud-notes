import UIKit

struct JSONDataSourceProvider: NoteDataSource {
    var noteList = [Note]()

    mutating func fetch() throws {
        guard let data = NSDataAsset(name: "sampleNotes")?.data else {
            throw DataSourceError.jsonNotFound
        }

        let decodedData: [Note] = try DecodingUtility.decode(data: data)

        self.noteList = decodedData
    }
}
