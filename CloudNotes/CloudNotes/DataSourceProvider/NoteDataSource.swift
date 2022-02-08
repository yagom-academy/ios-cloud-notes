import Foundation

protocol NoteDataSource {
    var noteList: [Note] { get set }

    mutating func fetch() throws
}
