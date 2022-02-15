import Foundation

protocol NoteModel {
    
    var countOfNoteData: Int { get }

    func fetchData()
    func fetchTitle(at index: Int) -> String
    func fetchDate(at index: Int) -> String
    func fetchBody(at index: Int) -> String
    func deleteNote(at index: Int)
    
}
