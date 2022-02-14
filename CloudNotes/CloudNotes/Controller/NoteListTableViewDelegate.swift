import Foundation

protocol NoteListTableViewDelegate: AnyObject {
    
    func selectNote(title: String, body: String)
    func selectBlankNote()
    
}
