import UIKit

final class JSONDataSourceProvider: NoteDataSource {

    var noteList = [Content]()

     func fetch() throws {
        guard let data = NSDataAsset(name: "sampleNotes")?.data
        else {
            throw DataSourceError.jsonNotFound
        }

        let decodedData: [Content] = try DecodingUtility.decode(data: data)

        self.noteList = decodedData
    }

    func createNote(_ note: Content) throws { }

    func updateNote(_ updatedNote: Content) throws { }

    func deleteNote(_ noteToDelete: Content) throws { }

    func deleteAllNote() throws { }
}
