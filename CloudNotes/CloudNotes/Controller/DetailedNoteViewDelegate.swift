import Foundation

protocol DetailedNoteViewDelegate: AnyObject {
    func passModifiedNote(note: Note, index: Int)
}
