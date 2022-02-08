import Foundation

protocol NoteDataSource {
    var noteList: [Note] { get set }

    func fetch()
}
