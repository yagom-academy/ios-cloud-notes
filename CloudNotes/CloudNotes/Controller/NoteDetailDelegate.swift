import Foundation

protocol NoteDetailDelegate: AnyObject {
    
    func selectNote(title: String, body: String)
    
}
