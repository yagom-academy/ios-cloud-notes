import Foundation

protocol DetailedNoteViewDelegate: AnyObject {
    func creatNote()

    func passModifiedNote(note: Content)
}
