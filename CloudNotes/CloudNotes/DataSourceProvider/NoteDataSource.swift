import Foundation

protocol NoteDataSource {
    var noteList: [Note] { get }

    func fetch() throws
}
