import Foundation

protocol NoteDataSource {
    var noteList: [Content] { get }

    func fetch() throws
}
