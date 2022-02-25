import Foundation

protocol DetailedNoteViewDelegate: AnyObject {
    
    func creatNote()

    func deleteNote(_ note: Content)

    func passModifiedNote(_ note: Content)
}
