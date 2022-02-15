import Foundation

protocol NoteDataSource {
    var noteList: [Content] { get }

    func fetch() throws
    
    func createNote(_ note: Content)

    func updateNote(updatedNote: Content)

    func deleteNote(uuid: UUID)
}
