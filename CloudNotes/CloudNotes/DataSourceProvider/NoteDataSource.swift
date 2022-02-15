import Foundation

protocol NoteDataSource {
    var noteList: [Content] { get }

    func fetch() throws
    
    func createNote(_ note: Content)

    func updateNote(_ updatedNote: Content) throws

    func deleteNote(_ noteToDelete: Note) throws
}
