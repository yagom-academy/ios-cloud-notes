import Foundation

protocol NoteDataSource {
    var noteList: [Note] { get }

    mutating func fetch() throws
}
